Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3GCJlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:41:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39129 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3GCJlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:41:39 -0400
From: Alexander Savchenko <oleksandr.savchenko@ti.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-patch-review@list.ti.com>
Subject: [RESEND][PATCH] OMAP2+: UART: enable tx wakeup bit for wer reg
Date: Wed, 3 Jul 2013 12:41:31 +0300
Message-ID: <1372844491-7172-1-git-send-email-oleksandr.savchenko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Govindraj.R" <govindraj.raja@ti.com>

>From omap36xx onwards the module wakeup enable reg
wer has TX wakeup bit available enable the same
by populating the necessary tx wakeup flag for the
applicable module ip blocks and use the same
while configuaring wer reg.

Also wer is not context restored, restore wer when
context is lost.

Cc: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(for drivers/tty changes)
Signed-off-by: Govindraj.R <govindraj.raja@ti.com>
Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
---
[rebased according to 3.10]
 drivers/tty/serial/omap-serial.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b6d1728..b9fa344 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -52,6 +52,11 @@
 #define OMAP_UART_REV_52 0x0502
 #define OMAP_UART_REV_63 0x0603
 
+#define OMAP_UART_TX_WAKEUP_EN		BIT(7)
+
+/* Feature flags */
+#define OMAP_UART_WER_HAS_TX_WAKEUP	BIT(0)
+
 #define UART_ERRATA_i202_MDR1_ACCESS	BIT(0)
 #define UART_ERRATA_i291_DMA_FORCEIDLE	BIT(1)
 
@@ -137,6 +142,7 @@ struct uart_omap_port {
 	unsigned char		dlh;
 	unsigned char		mdr1;
 	unsigned char		scr;
+	unsigned char		wer;
 
 	int			use_dma;
 	/*
@@ -151,6 +157,7 @@ struct uart_omap_port {
 	int			context_loss_cnt;
 	u32			errata;
 	u8			wakeups_enabled;
+	u32			features;
 
 	int			DTR_gpio;
 	int			DTR_inverted;
@@ -683,7 +690,11 @@ static int serial_omap_startup(struct uart_port *port)
 	serial_out(up, UART_IER, up->ier);
 
 	/* Enable module level wake up */
-	serial_out(up, UART_OMAP_WER, OMAP_UART_WER_MOD_WKUP);
+	up->wer = OMAP_UART_WER_MOD_WKUP;
+	if (up->features & OMAP_UART_WER_HAS_TX_WAKEUP)
+		up->wer |= OMAP_UART_TX_WAKEUP_EN;
+
+	serial_out(up, UART_OMAP_WER, up->wer);
 
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
@@ -1373,9 +1384,11 @@ static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
 	case OMAP_UART_REV_52:
 		up->errata |= (UART_ERRATA_i202_MDR1_ACCESS |
 				UART_ERRATA_i291_DMA_FORCEIDLE);
+		up->features |= OMAP_UART_WER_HAS_TX_WAKEUP;
 		break;
 	case OMAP_UART_REV_63:
 		up->errata |= UART_ERRATA_i202_MDR1_ACCESS;
+		up->features |= OMAP_UART_WER_HAS_TX_WAKEUP;
 		break;
 	default:
 		break;
@@ -1609,6 +1622,7 @@ static void serial_omap_restore_context(struct uart_omap_port *up)
 		serial_omap_mdr1_errataset(up, up->mdr1);
 	else
 		serial_out(up, UART_OMAP_MDR1, up->mdr1);
+	serial_out(up, UART_OMAP_WER, up->wer);
 }
 
 static int serial_omap_runtime_suspend(struct device *dev)
-- 
1.7.9.5

