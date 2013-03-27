Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3C0LM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:12:29 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:33206 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3C0LMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:12:24 -0400
X-IronPort-AV: E=Sophos;i="4.84,917,1355097600"; 
   d="scan'208";a="2955624"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 4/7] xen-blkback: move pending handles list from blkbk to pending_req
Date: Wed, 27 Mar 2013 12:10:40 +0100
Message-ID: <1364382643-3711-5-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving grant ref handles from blkbk to pending_req will allow us to
get rid of the shared blkbk structure.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkback/blkback.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index fd1dd38..e6542d5 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -136,6 +136,7 @@ struct pending_req {
 	struct list_head	free_list;
 	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	grant_handle_t		grant_handles[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 #define BLKBACK_INVALID_HANDLE (~0)
@@ -150,8 +151,6 @@ struct xen_blkbk {
 	/* And its spinlock. */
 	spinlock_t		pending_free_lock;
 	wait_queue_head_t	pending_free_wq;
-	/* And the grant handles that are available. */
-	grant_handle_t		*pending_grant_handles;
 };
 
 static struct xen_blkbk *blkbk;
@@ -229,7 +228,7 @@ static inline void shrink_free_pagepool(struct xen_blkif *blkif, int num)
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
 #define pending_handle(_req, _seg) \
-	(blkbk->pending_grant_handles[vaddr_pagenr(_req, _seg)])
+	(_req->grant_handles[_seg])
 
 
 static int do_block_io_op(struct xen_blkif *blkif);
@@ -1280,7 +1279,7 @@ static void make_response(struct xen_blkif *blkif, u64 id,
 
 static int __init xen_blkif_init(void)
 {
-	int i, mmap_pages;
+	int i;
 	int rc = 0;
 
 	if (!xen_domain())
@@ -1292,21 +1291,15 @@ static int __init xen_blkif_init(void)
 		return -ENOMEM;
 	}
 
-	mmap_pages = xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST;
 
 	blkbk->pending_reqs          = kzalloc(sizeof(blkbk->pending_reqs[0]) *
 					xen_blkif_reqs, GFP_KERNEL);
-	blkbk->pending_grant_handles = kmalloc(sizeof(blkbk->pending_grant_handles[0]) *
-					mmap_pages, GFP_KERNEL);
 
-	if (!blkbk->pending_reqs || !blkbk->pending_grant_handles) {
+	if (!blkbk->pending_reqs) {
 		rc = -ENOMEM;
 		goto out_of_memory;
 	}
 
-	for (i = 0; i < mmap_pages; i++) {
-		blkbk->pending_grant_handles[i] = BLKBACK_INVALID_HANDLE;
-	}
 	rc = xen_blkif_interface_init();
 	if (rc)
 		goto failed_init;
@@ -1329,7 +1322,6 @@ static int __init xen_blkif_init(void)
 	pr_alert(DRV_PFX "%s: out of memory\n", __func__);
  failed_init:
 	kfree(blkbk->pending_reqs);
-	kfree(blkbk->pending_grant_handles);
 	kfree(blkbk);
 	blkbk = NULL;
 	return rc;
-- 
1.7.7.5 (Apple Git-26)

