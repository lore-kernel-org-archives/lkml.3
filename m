Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaHZTON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:14:13 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50279 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaHZTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:14:11 -0400
From: Simon Lindgren <simon@aqwary.com>
To: wsa@the-dreams.de
Cc: ludovic.desroches@atmel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Lindgren <simon@aqwary.com>
Subject: [PATCH] i2c:at91: Fix a race condition during signal handling in at91_do_twi_xfer.
Date: Tue, 26 Aug 2014 21:13:24 +0200
Message-Id: <1409080404-19069-1-git-send-email-simon@aqwary.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition in at91_do_twi_xfer when signals arrive.
If a signal is recieved while waiting for a transfer to complete
wait_for_completion_interruptible_timeout() will return -ERESTARTSYS.
This is not handled correctly resulting in interrupts still being
enabled and a transfer being in flight when we return.

Symptoms include a range of oopses and bus lockups. Oopses can happen
when the transfer completes because the interrupt handler will corrupt
the stack. If a new transfer is started before the interrupt fires
the controller will start a new transfer in the middle of the old one,
resulting in confused slaves and a locked bus.

To avoid this, use wait_for_completion_io_timeout instead so that we
don't have to deal with gracefully shutting down the transfer and
disabling the interrupts.

Signed-off-by: Simon Lindgren <simon@aqwary.com>
---
 drivers/i2c/busses/i2c-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 79a6899..ec299ae 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -421,8 +421,8 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 		}
 	}
 
-	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
-							dev->adapter.timeout);
+	ret = wait_for_completion_io_timeout(&dev->cmd_complete,
+					     dev->adapter.timeout);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		at91_init_twi_bus(dev);
-- 
1.7.9.5

