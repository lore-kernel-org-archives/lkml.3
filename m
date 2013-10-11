Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3JKTpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:45:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3JKTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Franck Jullien <franck.jullien@gmail.com>, Chris Ball <cjb@laptop.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [ 123/135] mmc: fix null pointer use in mmc_blk_remove_req
Date: Fri, 11 Oct 2013 12:40:04 -0700
Message-Id: <20131011193958.628533634@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Franck Jullien <franck.jullien@gmail.com>

commit 8efb83a2f8518a6ffcc074177f8d659c5165ef37 upstream.

A previous commit (fdfa20c1631210d0) reordered the shutdown sequence
in mmc_blk_remove_req. However, mmc_cleanup_queue is now called before
we get the card pointer, and mmc_cleanup_queue sets mq->card to NULL.

This patch moves the card pointer assignment before mmc_cleanup_queue.

Signed-off-by: Franck Jullien <franck.jullien@gmail.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2191,10 +2191,10 @@ static void mmc_blk_remove_req(struct mm
 		 * is freeing the queue that stops new requests
 		 * from being accepted.
 		 */
+		card = md->queue.card;
 		mmc_cleanup_queue(&md->queue);
 		if (md->flags & MMC_BLK_PACKED_CMD)
 			mmc_packed_clean(&md->queue);
-		card = md->queue.card;
 		if (md->disk->flags & GENHD_FL_UP) {
 			device_remove_file(disk_to_dev(md->disk), &md->force_ro);
 			if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&


