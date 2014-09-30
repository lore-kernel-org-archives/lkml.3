Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaI3Vjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaI3Vj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Lindgren <simon@aqwary.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 099/103] i2c: at91: Fix a race condition during signal handling in at91_do_twi_xfer.
Date: Tue, 30 Sep 2014 14:31:44 -0700
Message-Id: <1412112708-27356-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Lindgren <simon@aqwary.com>

commit 6721f28a26efd6368497abbdef5dcfc59608d899 upstream.

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
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-at91.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index d13d3bb..ae4cdc0 100644
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
1.9.1

