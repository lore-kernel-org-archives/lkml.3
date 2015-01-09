Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbbAILAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:00:20 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44490 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756897AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Kochetkov <al.kochet@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 20/78] i2c: omap: fix NACK and Arbitration Lost irq handling
Date: Fri,  9 Jan 2015 11:31:29 +0100
Message-Id: <f8d459cdc1a00eb16e934682bb52fef231fec2bd.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Kochetkov <al.kochet@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-omap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 9967a6f9c2ff..05f5919a7165 100644
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
2.2.1

