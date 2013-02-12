Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3BLWlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:25 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18860 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab3BLWlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:22 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/9] block: xd: introduce a delay before every outb operation
Date: Tue, 12 Feb 2013 23:40:52 +0100
Message-Id: <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I plug an ISA XT 8bit card into a 16bit compatible EISA
slot, the outb() operations seemingly stumble over each other
so we need to introduce a small delay after each outb()
operation. After this my MFM MiniScribe harddrive is properly
detected like this:

Detected 1 hard drive (using IRQ5 & DMA3)
 xda: CHS=615/4/17

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index ff54052..303e9f2 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -57,6 +57,8 @@
 
 #include "xd.h"
 
+#define OUTB_DELAY 100
+
 static DEFINE_MUTEX(xd_mutex);
 static void __init do_xd_setup (int *integers);
 #ifdef MODULE
@@ -485,7 +487,8 @@ static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
 #ifdef DEBUG_OTHER
 		printk("xd_interrupt_handler: interrupt detected\n");
 #endif /* DEBUG_OTHER */
-		outb(0,XD_CONTROL);								/* acknowledge interrupt */
+		outb(0,XD_CONTROL); /* acknowledge interrupt */
+		udelay(OUTB_DELAY);
 		wake_up(&xd_wait_int);	/* and wake up sleeping processes */
 		return IRQ_HANDLED;
 	}
@@ -588,7 +591,9 @@ static u_int xd_command (u_char *command,u_char mode,u_char *indata,u_char *outd
 #endif /* DEBUG_COMMAND */
 
 	outb(0,XD_SELECT);
+	udelay(OUTB_DELAY);
 	outb(mode,XD_CONTROL);
+	udelay(OUTB_DELAY);
 
 	if (xd_waitport(XD_STATUS,STAT_SELECT,STAT_SELECT,timeout))
 		return (1);
@@ -602,8 +607,10 @@ static u_int xd_command (u_char *command,u_char mode,u_char *indata,u_char *outd
 				if (mode == DMA_MODE) {
 					if (xd_wait_for_IRQ())
 						return (1);
-				} else
+				} else {
 					outb(outdata ? *outdata++ : 0,XD_DATA);
+					udelay(OUTB_DELAY);
+				}
 				break;
 			case STAT_INPUT:
 				if (mode == DMA_MODE) {
@@ -617,6 +624,7 @@ static u_int xd_command (u_char *command,u_char mode,u_char *indata,u_char *outd
 				break;
 			case STAT_COMMAND:
 				outb(command ? *command++ : 0,XD_DATA);
+				udelay(OUTB_DELAY);
 				break;
 			case STAT_COMMAND | STAT_INPUT:
 				complete = 1;
@@ -680,6 +688,7 @@ static void __init xd_dtc_init_controller (unsigned int address)
 	xd_maxsectors = 0x01;		/* my card seems to have trouble doing multi-block transfers? */
 
 	outb(0,XD_RESET);		/* reset the controller */
+	udelay(OUTB_DELAY);
 }
 
 
@@ -773,6 +782,7 @@ static void __init xd_wd_init_controller (unsigned int address)
 	xd_maxsectors = 0x01;		/* this one doesn't wrap properly either... */
 
 	outb(0,XD_RESET);		/* reset the controller */
+	udelay(OUTB_DELAY);
 
 	msleep(XD_INIT_DISK_DELAY);
 }
@@ -875,6 +885,7 @@ static void __init xd_seagate_init_controller (unsigned int address)
 	xd_maxsectors = 0x40;
 
 	outb(0,XD_RESET);		/* reset the controller */
+	udelay(OUTB_DELAY);
 }
 
 static void __init xd_seagate_init_drive (u_char drive)
@@ -908,6 +919,7 @@ static void __init xd_omti_init_controller (unsigned int address)
 	xd_maxsectors = 0x40;
 
 	outb(0,XD_RESET);		/* reset the controller */
+	udelay(OUTB_DELAY);
 }
 
 static void __init xd_omti_init_drive (u_char drive)
@@ -947,6 +959,7 @@ If you need non-standard settings use the xd=... command */
 
 	xd_maxsectors = 0x01;
 	outb(0,XD_RESET);		/* reset the controller */
+	udelay(OUTB_DELAY);
 
 	msleep(XD_INIT_DISK_DELAY);
 }
-- 
1.8.1.2

