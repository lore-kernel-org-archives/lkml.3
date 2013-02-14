Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab3BNKPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:15:39 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:46896 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3BNKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:15:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,664,1355097600"; 
   d="scan'208";a="1452298"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen-blkback: use balloon pages for persistent grants
Date: Thu, 14 Feb 2013 11:12:09 +0100
Message-ID: <1360836729-17874-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current persistent grants implementation we are not freeing the
persistent grants after we disconnect the device. Since grant map
operations change the mfn of the allocated page, and we can no longer
pass it to __free_page without setting the mfn to a sane value, use
balloon grant pages instead, as the gntdev device does.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c46824f..e6c2f6a 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -46,6 +46,7 @@
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <xen/balloon.h>
 #include "common.h"
 
 /*
@@ -239,6 +240,7 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
 				segs_to_unmap);
 			BUG_ON(ret);
+			free_xenballooned_pages(segs_to_unmap, pages);
 			segs_to_unmap = 0;
 		}
 
@@ -527,8 +529,8 @@ static int xen_blkbk_map(struct blkif_request *req,
 				GFP_KERNEL);
 			if (!persistent_gnt)
 				return -ENOMEM;
-			persistent_gnt->page = alloc_page(GFP_KERNEL);
-			if (!persistent_gnt->page) {
+			if (alloc_xenballooned_pages(1, &persistent_gnt->page,
+			    false)) {
 				kfree(persistent_gnt);
 				return -ENOMEM;
 			}
-- 
1.7.7.5 (Apple Git-26)

