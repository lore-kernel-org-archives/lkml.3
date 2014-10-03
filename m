Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbaJDABg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:01:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaJCVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Lindgren <simon@aqwary.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.14 037/238] i2c: at91: Fix a race condition during signal handling in at91_do_twi_xfer.
Date: Fri,  3 Oct 2014 14:29:12 -0700
Message-Id: <20141003212914.850775967@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -434,8 +434,8 @@ static int at91_do_twi_transfer(struct a
 		}
 	}
 
-	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
-							dev->adapter.timeout);
+	ret = wait_for_completion_io_timeout(&dev->cmd_complete,
+					     dev->adapter.timeout);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		at91_init_twi_bus(dev);


