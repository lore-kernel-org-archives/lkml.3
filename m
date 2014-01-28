Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaA1RoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:44:05 -0500
Received: from smtp.citrix.com ([66.165.176.89]:46844 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbaA1RoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:44:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="97353082"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH 2/3] xen-blkback: fix memory leaks
Date: Tue, 28 Jan 2014 18:43:34 +0100
Message-ID: <1390931015-5490-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've at least identified two possible memory leaks in blkback, both
related to the shutdown path of a VBD:

- blkback doesn't wait for any pending purge work to finish before
  cleaning the list of free_pages. The purge work will call
  put_free_pages and thus we might end up with pages being added to
  the free_pages list after we have emptied it. Fix this by making
  sure there's no pending purge work before exiting
  xen_blkif_schedule, and moving the free_page cleanup code to
  xen_blkif_free.
- blkback doesn't wait for pending requests to end before cleaning
  persistent grants and the list of free_pages. Again this can add
  pages to the free_pages list or persistent grants to the
  persistent_gnts red-black tree. Fixed by moving the persistent
  grants and free_pages cleanup code to xen_blkif_free.

Also, add some checks in xen_blkif_free to make sure we are cleaning
everything.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Matt Rushton <mrushton@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
---
 drivers/block/xen-blkback/blkback.c |   27 ++++++++++++++++++---------
 drivers/block/xen-blkback/common.h  |    1 +
 drivers/block/xen-blkback/xenbus.c  |   12 ++++++++++++
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 30ef7b3..dcfe49f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -375,7 +375,7 @@ static void purge_persistent_gnt(struct xen_blkif *blkif)
 
 	pr_debug(DRV_PFX "Going to purge %u persistent grants\n", num_clean);
 
-	INIT_LIST_HEAD(&blkif->persistent_purge_list);
+	BUG_ON(!list_empty(&blkif->persistent_purge_list));
 	root = &blkif->persistent_gnts;
 purge_list:
 	foreach_grant_safe(persistent_gnt, n, root, node) {
@@ -625,6 +625,23 @@ purge_gnt_list:
 			print_stats(blkif);
 	}
 
+	/* Drain pending purge work */
+	flush_work(&blkif->persistent_purge_work);
+
+	if (log_stats)
+		print_stats(blkif);
+
+	blkif->xenblkd = NULL;
+	xen_blkif_put(blkif);
+
+	return 0;
+}
+
+/*
+ * Remove persistent grants and empty the pool of free pages
+ */
+void xen_blkbk_free_caches(struct xen_blkif *blkif)
+{
 	/* Free all persistent grant pages */
 	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
 		free_persistent_gnts(blkif, &blkif->persistent_gnts,
@@ -635,14 +652,6 @@ purge_gnt_list:
 
 	/* Since we are shutting down remove all pages from the buffer */
 	shrink_free_pagepool(blkif, 0 /* All */);
-
-	if (log_stats)
-		print_stats(blkif);
-
-	blkif->xenblkd = NULL;
-	xen_blkif_put(blkif);
-
-	return 0;
 }
 
 /*
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 8d88075..f733d76 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -376,6 +376,7 @@ int xen_blkif_xenbus_init(void);
 irqreturn_t xen_blkif_be_int(int irq, void *dev_id);
 int xen_blkif_schedule(void *arg);
 int xen_blkif_purge_persistent(void *arg);
+void xen_blkbk_free_caches(struct xen_blkif *blkif);
 
 int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 			      struct backend_info *be, int state);
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index c2014a0..8afef67 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -125,6 +125,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->persistent_gnts.rb_node = NULL;
 	spin_lock_init(&blkif->free_pages_lock);
 	INIT_LIST_HEAD(&blkif->free_pages);
+	INIT_LIST_HEAD(&blkif->persistent_purge_list);
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
 
@@ -259,6 +260,17 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 	if (!atomic_dec_and_test(&blkif->refcnt))
 		BUG();
 
+	/* Remove all persistent grants and the cache of ballooned pages. */
+	xen_blkbk_free_caches(blkif);
+
+	/* Make sure everything is drained before shutting down */
+	BUG_ON(blkif->persistent_gnt_c != 0);
+	BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);
+	BUG_ON(blkif->free_pages_num != 0);
+	BUG_ON(!list_empty(&blkif->persistent_purge_list));
+	BUG_ON(!list_empty(&blkif->free_pages));
+	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
+
 	/* Check that there is no request in use */
 	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
 		list_del(&req->free_list);
-- 
1.7.7.5 (Apple Git-26)

