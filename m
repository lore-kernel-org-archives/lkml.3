Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab3BLWlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:40 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18877 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050Ab3BLWlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:32 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/9] block: xd: merge header file into driver
Date: Tue, 12 Feb 2013 23:40:58 +0100
Message-Id: <1360708860-23466-9-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-8-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-7-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-8-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This consolidates the XD driver in one single file.
No semantic changes.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c |  84 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/block/xd.h | 101 -----------------------------------------------------
 2 files changed, 83 insertions(+), 102 deletions(-)
 delete mode 100644 drivers/block/xd.h

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index ffa6e76..1875590 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -53,11 +53,93 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
+#include <linux/interrupt.h>
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 
-#include "xd.h"
+/* XT hard disk controller registers */
+#define XD_DATA		(xd_iobase + 0x00)	/* data RW register */
+#define XD_RESET	(xd_iobase + 0x01)	/* reset WO register */
+#define XD_STATUS	(xd_iobase + 0x01)	/* status RO register */
+#define XD_SELECT	(xd_iobase + 0x02)	/* select WO register */
+#define XD_JUMPER	(xd_iobase + 0x02)	/* jumper RO register */
+#define XD_CONTROL	(xd_iobase + 0x03)	/* DMAE/INTE WO register */
+#define XD_RESERVED	(xd_iobase + 0x03)	/* reserved */
+
+/* XT hard disk controller commands (incomplete list) */
+#define CMD_TESTREADY	0x00	/* test drive ready */
+#define CMD_RECALIBRATE	0x01	/* recalibrate drive */
+#define CMD_SENSE	0x03	/* request sense */
+#define CMD_FORMATDRV	0x04	/* format drive */
+#define CMD_VERIFY	0x05	/* read verify */
+#define CMD_FORMATTRK	0x06	/* format track */
+#define CMD_FORMATBAD	0x07	/* format bad track */
+#define CMD_READ	0x08	/* read */
+#define CMD_WRITE	0x0A	/* write */
+#define CMD_SEEK	0x0B	/* seek */
+
+/* Controller specific commands */
+#define CMD_DTCSETPARAM	0x0C	/* set drive parameters (DTC 5150X & CX only?) */
+#define CMD_DTCGETECC	0x0D	/* get ecc error length (DTC 5150X only?) */
+#define CMD_DTCREADBUF	0x0E	/* read sector buffer (DTC 5150X only?) */
+#define CMD_DTCWRITEBUF 0x0F	/* write sector buffer (DTC 5150X only?) */
+#define CMD_DTCREMAPTRK	0x11	/* assign alternate track (DTC 5150X only?) */
+#define CMD_DTCGETPARAM	0xFB	/* get drive parameters (DTC 5150X only?) */
+#define CMD_DTCSETSTEP	0xFC	/* set step rate (DTC 5150X only?) */
+#define CMD_DTCSETGEOM	0xFE	/* set geometry data (DTC 5150X only?) */
+#define CMD_DTCGETGEOM	0xFF	/* get geometry data (DTC 5150X only?) */
+#define CMD_ST11GETGEOM 0xF8	/* get geometry data (Seagate ST11R/M only?) */
+#define CMD_WDSETPARAM	0x0C	/* set drive parameters (WD 1004A27X only?) */
+#define CMD_XBSETPARAM	0x0C	/* set drive parameters (XEBEC only?) */
+
+/* Bits for command status byte */
+#define CSB_ERROR	0x02	/* error */
+#define CSB_LUN		0x20	/* logical Unit Number */
+
+/* XT hard disk controller status bits */
+#define STAT_READY	0x01	/* controller is ready */
+#define STAT_INPUT	0x02	/* data flowing from controller to host */
+#define STAT_COMMAND	0x04	/* controller in command phase */
+#define STAT_SELECT	0x08	/* controller is selected */
+#define STAT_REQUEST	0x10	/* controller requesting data */
+#define STAT_INTERRUPT	0x20	/* controller requesting interrupt */
+
+/* XT hard disk controller control bits */
+#define PIO_MODE	0x00	/* control bits to set for PIO */
+#define DMA_MODE	0x03	/* control bits to set for DMA & interrupt */
+
+#define XD_MAXDRIVES	2	/* maximum 2 drives */
+#define XD_TIMEOUT	(HZ * 30)	/* 30 second timeout */
+#define XD_RETRIES	4	/* maximum 4 retries */
+
+#undef DEBUG			/* define for debugging output */
+
+#ifdef DEBUG
+	#define DEBUG_STARTUP	/* debug driver initialisation */
+	#define DEBUG_OVERRIDE	/* debug override geometry detection */
+	#define DEBUG_READWRITE	/* debug each read/write command */
+	#define DEBUG_OTHER	/* debug misc. interrupt/DMA stuff */
+	#define DEBUG_COMMAND	/* debug each controller command */
+#endif /* DEBUG */
+
+/* this structure defines the XT drives and their types */
+struct xd_info {
+	u_char heads;
+	u_short cylinders;
+	u_char sectors;
+	u_char control;
+	int unit;
+};
+
+/* this structure defines a ROM BIOS signature */
+struct xd_signature {
+	unsigned int offset;
+	const char *string;
+	void (*init_controller)(unsigned int address);
+	void (*init_drive)(u_char drive);
+	const char *name;
+};
 
 #define OUTB_DELAY 100
 
diff --git a/drivers/block/xd.h b/drivers/block/xd.h
deleted file mode 100644
index f09a33d..0000000
--- a/drivers/block/xd.h
+++ /dev/null
@@ -1,101 +0,0 @@
-#ifndef _LINUX_XD_H
-#define _LINUX_XD_H
-
-/*
- * This file contains the definitions for the IO ports and errors etc. for XT hard disk controllers (at least the DTC 5150X).
- *
- * Author: Pat Mackinlay, pat@it.com.au
- * Date: 29/09/92
- *
- * Revised: 01/01/93, ...
- *
- * Ref: DTC 5150X Controller Specification (thanks to Kevin Fowler, kevinf@agora.rain.com)
- * Also thanks to: Salvador Abreu, Dave Thaler, Risto Kankkunen and Wim Van Dorst.
- */
-
-#include <linux/interrupt.h>
-
-/* XT hard disk controller registers */
-#define XD_DATA		(xd_iobase + 0x00)	/* data RW register */
-#define XD_RESET	(xd_iobase + 0x01)	/* reset WO register */
-#define XD_STATUS	(xd_iobase + 0x01)	/* status RO register */
-#define XD_SELECT	(xd_iobase + 0x02)	/* select WO register */
-#define XD_JUMPER	(xd_iobase + 0x02)	/* jumper RO register */
-#define XD_CONTROL	(xd_iobase + 0x03)	/* DMAE/INTE WO register */
-#define XD_RESERVED	(xd_iobase + 0x03)	/* reserved */
-
-/* XT hard disk controller commands (incomplete list) */
-#define CMD_TESTREADY	0x00	/* test drive ready */
-#define CMD_RECALIBRATE	0x01	/* recalibrate drive */
-#define CMD_SENSE	0x03	/* request sense */
-#define CMD_FORMATDRV	0x04	/* format drive */
-#define CMD_VERIFY	0x05	/* read verify */
-#define CMD_FORMATTRK	0x06	/* format track */
-#define CMD_FORMATBAD	0x07	/* format bad track */
-#define CMD_READ	0x08	/* read */
-#define CMD_WRITE	0x0A	/* write */
-#define CMD_SEEK	0x0B	/* seek */
-
-/* Controller specific commands */
-#define CMD_DTCSETPARAM	0x0C	/* set drive parameters (DTC 5150X & CX only?) */
-#define CMD_DTCGETECC	0x0D	/* get ecc error length (DTC 5150X only?) */
-#define CMD_DTCREADBUF	0x0E	/* read sector buffer (DTC 5150X only?) */
-#define CMD_DTCWRITEBUF 0x0F	/* write sector buffer (DTC 5150X only?) */
-#define CMD_DTCREMAPTRK	0x11	/* assign alternate track (DTC 5150X only?) */
-#define CMD_DTCGETPARAM	0xFB	/* get drive parameters (DTC 5150X only?) */
-#define CMD_DTCSETSTEP	0xFC	/* set step rate (DTC 5150X only?) */
-#define CMD_DTCSETGEOM	0xFE	/* set geometry data (DTC 5150X only?) */
-#define CMD_DTCGETGEOM	0xFF	/* get geometry data (DTC 5150X only?) */
-#define CMD_ST11GETGEOM 0xF8	/* get geometry data (Seagate ST11R/M only?) */
-#define CMD_WDSETPARAM	0x0C	/* set drive parameters (WD 1004A27X only?) */
-#define CMD_XBSETPARAM	0x0C	/* set drive parameters (XEBEC only?) */
-
-/* Bits for command status byte */
-#define CSB_ERROR	0x02	/* error */
-#define CSB_LUN		0x20	/* logical Unit Number */
-
-/* XT hard disk controller status bits */
-#define STAT_READY	0x01	/* controller is ready */
-#define STAT_INPUT	0x02	/* data flowing from controller to host */
-#define STAT_COMMAND	0x04	/* controller in command phase */
-#define STAT_SELECT	0x08	/* controller is selected */
-#define STAT_REQUEST	0x10	/* controller requesting data */
-#define STAT_INTERRUPT	0x20	/* controller requesting interrupt */
-
-/* XT hard disk controller control bits */
-#define PIO_MODE	0x00	/* control bits to set for PIO */
-#define DMA_MODE	0x03	/* control bits to set for DMA & interrupt */
-
-#define XD_MAXDRIVES	2	/* maximum 2 drives */
-#define XD_TIMEOUT	(HZ * 30)	/* 30 second timeout */
-#define XD_RETRIES	4	/* maximum 4 retries */
-
-#undef DEBUG			/* define for debugging output */
-
-#ifdef DEBUG
-	#define DEBUG_STARTUP	/* debug driver initialisation */
-	#define DEBUG_OVERRIDE	/* debug override geometry detection */
-	#define DEBUG_READWRITE	/* debug each read/write command */
-	#define DEBUG_OTHER	/* debug misc. interrupt/DMA stuff */
-	#define DEBUG_COMMAND	/* debug each controller command */
-#endif /* DEBUG */
-
-/* this structure defines the XT drives and their types */
-struct xd_info {
-	u_char heads;
-	u_short cylinders;
-	u_char sectors;
-	u_char control;
-	int unit;
-};
-
-/* this structure defines a ROM BIOS signature */
-struct xd_signature {
-	unsigned int offset;
-	const char *string;
-	void (*init_controller)(unsigned int address);
-	void (*init_drive)(u_char drive);
-	const char *name;
-};
-
-#endif /* _LINUX_XD_H */
-- 
1.8.1.2

