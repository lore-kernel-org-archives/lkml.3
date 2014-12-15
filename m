Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaLOOj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:39:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaLOO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Kochetkov <al.kochet@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 129/168] i2c: omap: fix NACK and Arbitration Lost irq handling
Date: Mon, 15 Dec 2014 14:26:23 +0000
Message-Id: <1418653622-21105-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-omap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index b182793a4051..4ba4c2c7bc79 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -926,14 +926,12 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
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
-- 
2.1.3

