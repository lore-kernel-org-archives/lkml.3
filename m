Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbbAMNqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:46:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38879 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbbAMNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:45:04 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [RFC 1/4] nbd: Replace kthread_create with kthread_run
Date: Tue, 13 Jan 2015 14:44:22 +0100
Message-Id: <1421156665-27318-2-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
References: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kthread_run includes the wake_up_process() call, so instead of
kthread_create() followed by wake_up_process() we can use this macro.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4bc2a5cb9935..6bd7df2ff648 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -706,13 +706,13 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		else
 			blk_queue_flush(nbd->disk->queue, 0);
 
-		thread = kthread_create(nbd_thread, nbd, "%s",
-					nbd->disk->disk_name);
+		thread = kthread_run(nbd_thread, nbd, "%s",
+				     nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
 		}
-		wake_up_process(thread);
+
 		error = nbd_do_it(nbd);
 		kthread_stop(thread);
 
-- 
2.1.4

