Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaKCAG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:06:58 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:42263 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaKCAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:06:53 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, cascardo@linux.vnet.ibm.com
Cc: lidza.louina@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-serial@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 1/5] drivers: serial: jsm: Add Classic board UART structure
Date: Mon,  3 Nov 2014 01:06:26 +0100
Message-Id: <1414973190-10153-2-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414973190-10153-1-git-send-email-bergo.torino@gmail.com>
References: <1414973190-10153-1-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds the UART structure for the Digi Classic cards. This
code comes from the staging/dgnc driver.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/jsm/jsm.h | 59 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
index af70134..9861639 100644
--- a/drivers/tty/serial/jsm/jsm.h
+++ b/drivers/tty/serial/jsm/jsm.h
@@ -222,7 +222,10 @@ struct jsm_channel {
 	u8		ch_mostat;	/* FEP output modem status	*/
 	u8		ch_mistat;	/* FEP input modem status	*/
 
-	struct neo_uart_struct __iomem *ch_neo_uart;	/* Pointer to the "mapped" UART struct */
+	/* Pointers to the "mapped" UART structs */
+	struct neo_uart_struct __iomem *ch_neo_uart; /* NEO card */
+	struct cls_uart_struct __iomem *ch_cls_uart; /* Classic card */
+
 	u8		ch_cached_lsr;	/* Cached value of the LSR register */
 
 	u8		*ch_rqueue;	/* Our read queue buffer - malloc'ed */
@@ -254,6 +257,60 @@ struct jsm_channel {
 	u64		ch_xoff_sends;	/* Count of xoffs transmitted */
 };
 
+/************************************************************************
+ * Per channel/port Classic UART structures				*
+ ************************************************************************
+ *		Base Structure Entries Usage Meanings to Host		*
+ *									*
+ *	W = read write		R = read only				*
+ *			U = Unused.					*
+ ************************************************************************/
+
+struct cls_uart_struct {
+	u8 txrx;	/* WR  RHR/THR - Holding Reg */
+	u8 ier;		/* WR  IER - Interrupt Enable Reg */
+	u8 isr_fcr;	/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg*/
+	u8 lcr;		/* WR  LCR - Line Control Reg */
+	u8 mcr;		/* WR  MCR - Modem Control Reg */
+	u8 lsr;		/* WR  LSR - Line Status Reg */
+	u8 msr;		/* WR  MSR - Modem Status Reg */
+	u8 spr;		/* WR  SPR - Scratch Pad Reg */
+};
+
+/* Where to read the interrupt register (8bits) */
+#define UART_CLASSIC_POLL_ADDR_OFFSET	0x40
+
+#define UART_EXAR654_ENHANCED_REGISTER_SET 0xBF
+
+#define UART_16654_FCR_TXTRIGGER_8	0x0
+#define UART_16654_FCR_TXTRIGGER_16	0x10
+#define UART_16654_FCR_TXTRIGGER_32	0x20
+#define UART_16654_FCR_TXTRIGGER_56	0x30
+
+#define UART_16654_FCR_RXTRIGGER_8	0x0
+#define UART_16654_FCR_RXTRIGGER_16	0x40
+#define UART_16654_FCR_RXTRIGGER_56	0x80
+#define UART_16654_FCR_RXTRIGGER_60	0xC0
+
+#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of state */
+#define UART_IIR_RDI_TIMEOUT		0x0C    /* Receiver data TIMEOUT */
+
+/*
+ * These are the EXTENDED definitions for the Exar 654's Interrupt
+ * Enable Register.
+ */
+#define UART_EXAR654_EFR_ECB      0x10    /* Enhanced control bit */
+#define UART_EXAR654_EFR_IXON     0x2     /* Receiver compares Xon1/Xoff1 */
+#define UART_EXAR654_EFR_IXOFF    0x8     /* Transmit Xon1/Xoff1 */
+#define UART_EXAR654_EFR_RTSDTR   0x40    /* Auto RTS/DTR Flow Control Enable */
+#define UART_EXAR654_EFR_CTSDSR   0x80    /* Auto CTS/DSR Flow COntrol Enable */
+
+#define UART_EXAR654_XOFF_DETECT  0x1     /* Indicates whether chip saw an incoming XOFF char  */
+#define UART_EXAR654_XON_DETECT   0x2     /* Indicates whether chip saw an incoming XON char */
+
+#define UART_EXAR654_IER_XOFF     0x20    /* Xoff Interrupt Enable */
+#define UART_EXAR654_IER_RTSDTR   0x40    /* Output Interrupt Enable */
+#define UART_EXAR654_IER_CTSDSR   0x80    /* Input Interrupt Enable */
 
 /************************************************************************
  * Per channel/port NEO UART structure					*
-- 
1.9.1

