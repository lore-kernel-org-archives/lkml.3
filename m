Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbbAFNT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:19:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbbAFNT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:19:27 -0500
From: Bob Liu <bob.liu@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, roger.pau@citrix.com, junxiao.bi@oracle.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] xen/blkfront: restart request queue when there is enough persistent_gnts_c
Date: Tue,  6 Jan 2015 21:19:03 +0800
Message-Id: <1420550343-14013-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there is no enough free grants, gnttab_alloc_grant_references()
will fail and block request queue will stop.
If the system is always lack of grants, blkif_restart_queue_callback() can't be
scheduled and block request queue can't be restart(block I/O hang).

But when there are former requests complete, some grants may free to
persistent_gnts_c, we can give the request queue another chance to restart and
avoid block hang.

Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/block/xen-blkfront.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2236c6f..dd30f99 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1125,6 +1125,17 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			}
 		}
 	}
+
+	/*
+	 * Request queue would be stopped if failed to alloc enough grants and
+	 * won't be restarted until gnttab_free_count >= info->callback->count.
+	 *
+	 * But there is another case, once we have enough persistent grants we
+	 * can try to restart the request queue instead of continue to wait for
+	 * 'gnttab_free_count'.
+	 */
+	if (info->persistent_gnts_c >= info->callback.count)
+		schedule_work(&info->work);
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
-- 
1.7.10.4

