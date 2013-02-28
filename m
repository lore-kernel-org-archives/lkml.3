Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3B1PEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:04:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42338 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3B1Ota (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Thomas <adamthomas1111@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 089/139] UBIFS: fix double free of ubifs_orphan objects
Date: Thu, 28 Feb 2013 14:43:59 +0000
Message-Id: <1362062689-2567-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Thomas <adamthomas1111@gmail.com>

commit 8afd500cb52a5d00bab4525dd5a560d199f979b9 upstream.

The last orphan in the dnext list has its dnext set to NULL. Because
of that, ubifs_delete_orphan assumes that it is not on the dnext list
and frees it immediately instead ignoring it as a second delete. The
orphan is later freed again by erase_deleted.

This change adds an explicit flag to ubifs_orphan indicating whether
it is pending delete.

Signed-off-by: Adam Thomas <adamthomas1111@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/orphan.c | 5 ++++-
 fs/ubifs/ubifs.h  | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index bd516f1..9ef951f3 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -126,13 +126,14 @@ void ubifs_delete_orphan(struct ubifs_info *c, ino_t inum)
 		else if (inum > o->inum)
 			p = p->rb_right;
 		else {
-			if (o->dnext) {
+			if (o->del) {
 				spin_unlock(&c->orphan_lock);
 				dbg_gen("deleted twice ino %lu",
 					(unsigned long)inum);
 				return;
 			}
 			if (o->cmt) {
+				o->del = 1;
 				o->dnext = c->orph_dnext;
 				c->orph_dnext = o;
 				spin_unlock(&c->orphan_lock);
@@ -447,6 +448,7 @@ static void erase_deleted(struct ubifs_info *c)
 		orphan = dnext;
 		dnext = orphan->dnext;
 		ubifs_assert(!orphan->new);
+		ubifs_assert(orphan->del);
 		rb_erase(&orphan->rb, &c->orph_tree);
 		list_del(&orphan->list);
 		c->tot_orphans -= 1;
@@ -536,6 +538,7 @@ static int insert_dead_orphan(struct ubifs_info *c, ino_t inum)
 	rb_link_node(&orphan->rb, parent, p);
 	rb_insert_color(&orphan->rb, &c->orph_tree);
 	list_add_tail(&orphan->list, &c->orph_list);
+	orphan->del = 1;
 	orphan->dnext = c->orph_dnext;
 	c->orph_dnext = orphan;
 	dbg_mnt("ino %lu, new %d, tot %d", (unsigned long)inum,
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index fb89c54..f15c6e7 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -906,6 +906,7 @@ struct ubifs_budget_req {
  * @inum: inode number
  * @new: %1 => added since the last commit, otherwise %0
  * @cmt: %1 => commit pending, otherwise %0
+ * @del: %1 => delete pending, otherwise %0
  */
 struct ubifs_orphan {
 	struct rb_node rb;
@@ -916,6 +917,7 @@ struct ubifs_orphan {
 	ino_t inum;
 	unsigned new:1;
 	unsigned cmt:1;
+	unsigned del:1;
 };
 
 /**
-- 
1.8.1.2

