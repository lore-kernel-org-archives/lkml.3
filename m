Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3C0Xex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:34:53 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64530 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab3C0Xew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:34:52 -0400
From: Michael Spang <spang@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, Michael Spang <spang@chromium.org>
Subject: [PATCH 1/2] serial: samsung: Restore IRQ mask during noirq resume
Date: Wed, 27 Mar 2013 19:34:24 -0400
Message-Id: <1364427265-5304-1-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This closes a window where the system may hang in resume as soon as the
UART interrupt is enabled and before the mask is restored. The hang occurs
because the driver can't handle IRQs it thinks are masked.

Signed-off-by: Michael Spang <spang@chromium.org>
---
 drivers/tty/serial/samsung.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 2769a38..161a7a0 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1307,9 +1307,29 @@ static int s3c24xx_serial_resume(struct device *dev)
 	return 0;
 }
 
+static int s3c24xx_serial_resume_noirq(struct device *dev)
+{
+	struct uart_port *port = s3c24xx_dev_to_port(dev);
+
+	if (port) {
+		/* restore IRQ mask */
+		if (s3c24xx_serial_has_interrupt_mask(port)) {
+			unsigned int uintm = 0xf;
+			if (tx_enabled(port))
+				uintm &= ~S3C64XX_UINTM_TXD_MSK;
+			if (rx_enabled(port))
+				uintm &= ~S3C64XX_UINTM_RXD_MSK;
+			wr_regl(port, S3C64XX_UINTM, uintm);
+		}
+	}
+
+	return 0;
+}
+
 static const struct dev_pm_ops s3c24xx_serial_pm_ops = {
 	.suspend = s3c24xx_serial_suspend,
 	.resume = s3c24xx_serial_resume,
+	.resume_noirq = s3c24xx_serial_resume_noirq,
 };
 #define SERIAL_SAMSUNG_PM_OPS	(&s3c24xx_serial_pm_ops)
 
-- 
1.8.1.3

