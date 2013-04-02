Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3DBXOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:14:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab3DBWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 029/124] xen-blkfront: switch from llist to list
Date: Tue,  2 Apr 2013 15:10:11 -0700
Message-Id: <20130402221107.556444038@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit 155b7edb51430a280f86c1e21b7be308b0d219d4 upstream.

The git commit f84adf4921ae3115502f44ff467b04bf2f88cf04
(xen-blkfront: drop the use of llist_for_each_entry_safe)

was a stop-gate to fix a GCC4.1 bug. The appropiate way
is to actually use an list instead of using an llist.

As such this patch replaces the usage of llist with an
list.

Since we always manipulate the list while holding the io_lock, there's
no need for additional locking (llist used previously is safe to use
concurrently without additional locking).

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
[v1: Redid the git commit description]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkfront.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -44,7 +44,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
-#include <linux/llist.h>
+#include <linux/list.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -68,7 +68,7 @@ enum blkif_state {
 struct grant {
 	grant_ref_t gref;
 	unsigned long pfn;
-	struct llist_node node;
+	struct list_head node;
 };
 
 struct blk_shadow {
@@ -105,7 +105,7 @@ struct blkfront_info
 	struct work_struct work;
 	struct gnttab_free_callback callback;
 	struct blk_shadow shadow[BLK_RING_SIZE];
-	struct llist_head persistent_gnts;
+	struct list_head persistent_gnts;
 	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
@@ -371,10 +371,11 @@ static int blkif_queue_request(struct re
 			lsect = fsect + (sg->length >> 9) - 1;
 
 			if (info->persistent_gnts_c) {
-				BUG_ON(llist_empty(&info->persistent_gnts));
-				gnt_list_entry = llist_entry(
-					llist_del_first(&info->persistent_gnts),
-					struct grant, node);
+				BUG_ON(list_empty(&info->persistent_gnts));
+				gnt_list_entry = list_first_entry(
+				                      &info->persistent_gnts,
+				                      struct grant, node);
+				list_del(&gnt_list_entry->node);
 
 				ref = gnt_list_entry->gref;
 				buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
@@ -790,9 +791,8 @@ static void blkif_restart_queue(struct w
 
 static void blkif_free(struct blkfront_info *info, int suspend)
 {
-	struct llist_node *all_gnts;
-	struct grant *persistent_gnt, *tmp;
-	struct llist_node *n;
+	struct grant *persistent_gnt;
+	struct grant *n;
 
 	/* Prevent new requests being issued until we fix things up. */
 	spin_lock_irq(&info->io_lock);
@@ -804,20 +804,15 @@ static void blkif_free(struct blkfront_i
 
 	/* Remove all persistent grants */
 	if (info->persistent_gnts_c) {
-		all_gnts = llist_del_all(&info->persistent_gnts);
-		persistent_gnt = llist_entry(all_gnts, typeof(*(persistent_gnt)), node);
-		while (persistent_gnt) {
+		list_for_each_entry_safe(persistent_gnt, n,
+		                         &info->persistent_gnts, node) {
+			list_del(&persistent_gnt->node);
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
 			__free_page(pfn_to_page(persistent_gnt->pfn));
-			tmp = persistent_gnt;
-			n = persistent_gnt->node.next;
-			if (n)
-				persistent_gnt = llist_entry(n, typeof(*(persistent_gnt)), node);
-			else
-				persistent_gnt = NULL;
-			kfree(tmp);
+			kfree(persistent_gnt);
+			info->persistent_gnts_c--;
 		}
-		info->persistent_gnts_c = 0;
+		BUG_ON(info->persistent_gnts_c != 0);
 	}
 
 	/* No more gnttab callback work. */
@@ -875,7 +870,7 @@ static void blkif_completion(struct blk_
 	}
 	/* Add the persistent grant into the list of free grants */
 	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
-		llist_add(&s->grants_used[i]->node, &info->persistent_gnts);
+		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
 		info->persistent_gnts_c++;
 	}
 }
@@ -1171,7 +1166,7 @@ static int blkfront_probe(struct xenbus_
 	spin_lock_init(&info->io_lock);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
-	init_llist_head(&info->persistent_gnts);
+	INIT_LIST_HEAD(&info->persistent_gnts);
 	info->persistent_gnts_c = 0;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 	INIT_WORK(&info->work, blkif_restart_queue);


