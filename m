Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaA1JdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:33:19 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:47598 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaA1JdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:33:13 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>, Daniel Santos <daniel.santos@pobox.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] Revert "spidev: fix hang when transfer_one_message fails"
Date: Tue, 28 Jan 2014 10:33:03 +0100
Message-Id: <1390901583-32359-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

This reverts commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d.

It causes a NULL pointer dereference with drivers using the generic
spi_transfer_one_message(), which always calls
spi_finalize_current_message(), which zeroes master->cur_msg.

Drivers implementing transfer_one_message() theirselves must always call
spi_finalize_current_message(), even if the transfer failed:

 * @transfer_one_message: the subsystem calls the driver to transfer a single
 *      message while queuing transfers that arrive in the meantime. When the
 *      driver is finished with this message, it must call
 *      spi_finalize_current_message() so the subsystem can issue the next
 *      transfer

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index fe18a9d80213..5e43a31ee88a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -745,9 +745,7 @@ static void spi_pump_messages(struct kthread_work *work)
 	ret = master->transfer_one_message(master, master->cur_msg);
 	if (ret) {
 		dev_err(&master->dev,
-			"failed to transfer one message from queue: %d\n", ret);
-		master->cur_msg->status = ret;
-		spi_finalize_current_message(master);
+			"failed to transfer one message from queue\n");
 		return;
 	}
 }
-- 
1.7.9.5

