Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3KGBqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:46:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42038 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab3KGBqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:46:43 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        rostedt@goodmis.org, Artem Bityutskiy <dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH v2 10/11] mtd/ubi: use rbtree postorder iteration helper instead of opencoding
Date: Wed,  6 Nov 2013 17:42:39 -0800
Message-Id: <1383788572-25938-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110701-0320-0000-0000-000001A5D3A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 drivers/mtd/ubi/attach.c | 49 +++++++-----------------------------------------
 drivers/mtd/ubi/wl.c     | 25 +++---------------------
 2 files changed, 10 insertions(+), 64 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index c071d41..6de0786 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1133,27 +1133,11 @@ static int late_analysis(struct ubi_device *ubi, struct ubi_attach_info *ai)
  */
 static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 {
-	struct ubi_ainf_peb *aeb;
-	struct rb_node *this = av->root.rb_node;
-
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			aeb = rb_entry(this, struct ubi_ainf_peb, u.rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &aeb->u.rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
+	struct ubi_ainf_peb *aeb, *next;
+
+	rbtree_postorder_for_each_entry_safe(aeb, next, &av->root, u.rb)
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
 
-			kmem_cache_free(ai->aeb_slab_cache, aeb);
-		}
-	}
 	kfree(av);
 }
 
@@ -1164,8 +1148,7 @@ static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 static void destroy_ai(struct ubi_attach_info *ai)
 {
 	struct ubi_ainf_peb *aeb, *aeb_tmp;
-	struct ubi_ainf_volume *av;
-	struct rb_node *rb;
+	struct ubi_ainf_volume *av, *next;
 
 	list_for_each_entry_safe(aeb, aeb_tmp, &ai->alien, u.list) {
 		list_del(&aeb->u.list);
@@ -1185,26 +1168,8 @@ static void destroy_ai(struct ubi_attach_info *ai)
 	}
 
 	/* Destroy the volume RB-tree */
-	rb = ai->volumes.rb_node;
-	while (rb) {
-		if (rb->rb_left)
-			rb = rb->rb_left;
-		else if (rb->rb_right)
-			rb = rb->rb_right;
-		else {
-			av = rb_entry(rb, struct ubi_ainf_volume, rb);
-
-			rb = rb_parent(rb);
-			if (rb) {
-				if (rb->rb_left == &av->rb)
-					rb->rb_left = NULL;
-				else
-					rb->rb_right = NULL;
-			}
-
-			destroy_av(ai, av);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(av, next, &ai->volumes, rb)
+		destroy_av(ai, av);
 
 	if (ai->aeb_slab_cache)
 		kmem_cache_destroy(ai->aeb_slab_cache);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index c95bfb1..1af3899 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1760,29 +1760,10 @@ int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum)
  */
 static void tree_destroy(struct rb_root *root)
 {
-	struct rb_node *rb;
-	struct ubi_wl_entry *e;
-
-	rb = root->rb_node;
-	while (rb) {
-		if (rb->rb_left)
-			rb = rb->rb_left;
-		else if (rb->rb_right)
-			rb = rb->rb_right;
-		else {
-			e = rb_entry(rb, struct ubi_wl_entry, u.rb);
-
-			rb = rb_parent(rb);
-			if (rb) {
-				if (rb->rb_left == &e->u.rb)
-					rb->rb_left = NULL;
-				else
-					rb->rb_right = NULL;
-			}
+	struct ubi_wl_entry *e, *next;
 
-			kmem_cache_free(ubi_wl_entry_slab, e);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(e, next, root, u.rb)
+		kmem_cache_free(ubi_wl_entry_slab, e);
 }
 
 /**
-- 
1.8.4.2

