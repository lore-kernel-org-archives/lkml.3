Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaLNUnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:43:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaLNUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Kochetkov <al.kochet@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.17 11/47] i2c: omap: fix NACK and Arbitration Lost irq handling
Date: Sun, 14 Dec 2014 12:20:46 -0800
Message-Id: <20141214201818.943651077@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Kochetkov <al.kochet@gmail.com>

commit 27caca9d2e01c92b26d0690f065aad093fea01c7 upstream.

commit 1d7afc95946487945cc7f5019b41255b72224b70 (i2c: omap: ack IRQ in parts)
changed the interrupt handler to complete transfers without clearing
XRDY (AL case) and ARDY (NACK case) flags. XRDY or ARDY interrupts will be
fired again. As a result, ISR keep processing transfer after it was already
complete (from the driver code point of view).

A didn't see real impacts of the 1d7afc9, but it is really bad idea to
have ISR running on user data after transfer was complete.

It looks, what 1d7afc9 violate TI specs in what how AL and NACK should be
handled (see Note 1, sprugn4r, Figure 17-31 and Figure 17-32).

According to specs (if I understood correctly), in case of NACK and AL driver
must reset NACK, AL, ARDY, RDR, and RRDY (Master Receive Mode), and
NACK, AL, ARDY, and XDR (Master Transmitter Mode).

All that is done down the code under the if condition:
if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL)) ...

The patch restore pre 1d7afc9 logic of handling NACK and AL interrupts, so
no interrupts is fired after ISR informs the rest of driver what transfer
complete.

Note: instead of removing break under NACK case, we could just replace 'break'
with 'continue' and allow NACK transfer to finish using ARDY event. I found
that NACK and ARDY bits usually set together. That case confirm TI wiki:
http://processors.wiki.ti.com/index.php/I2C_Tips#Detecting_and_handling_NACK

In order if someone interested in the event traces for NACK and AL cases,
I sent them to mailing list.

Tested on Beagleboard XM C.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Fixes: 1d7afc9 i2c: omap: ack IRQ in parts
Acked-by: Felipe Balbi <balbi@ti.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-omap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -926,14 +926,12 @@ omap_i2c_isr_thread(int this_irq, void *
 		if (stat & OMAP_I2C_STAT_NACK) {
 			err |= OMAP_I2C_STAT_NACK;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
-			break;
 		}
 
 		if (stat & OMAP_I2C_STAT_AL) {
 			dev_err(dev->dev, "Arbitration lost\n");
 			err |= OMAP_I2C_STAT_AL;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_AL);
-			break;
 		}
 
 		/*


