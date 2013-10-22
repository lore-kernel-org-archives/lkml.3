Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3JVTiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:38:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:60553 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab3JVTiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:38:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396924880"
From: David Cohen <david.a.cohen@linux.intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, ning.li@intel.com,
        ivan.gorinov@intel.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 2/2] mrst_max3110: fix SPI UART interrupt parameters
Date: Tue, 22 Oct 2013 12:42:10 -0700
Message-Id: <1382470930-13807-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Gorinov <ivan.gorinov@intel.com>

The change in the max3110 driver makes the IRQ handling threaded, now
the handler is called only once per received character. Without that
change, we had many (more than 100) interrupts per one received
character.

Unfortunately, SFI interface does not support IRQ polarity and
triggering modes, so we have to keep the hacks as hard-coded device
names and IRQ numbers until we switch to ACPI.

Edge-triggered IRQ still supported to keep old platforms working.
Use platform data to pass the irq mode argument.

Signed-off-by: Ivan Gorinov <ivan.gorinov@intel.com>
Signed-off-by: Li Ning <ning.li@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/tty/serial/mrst_max3110.c | 35 +++++++++++++++++++++++++++--------
 include/linux/serial_max3110.h    | 16 ++++++++++++++++
 2 files changed, 43 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/serial_max3110.h

diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 6f618dd..3778dab 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -40,6 +40,7 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
+#include <linux/serial_max3110.h>
 
 #include <linux/kthread.h>
 #include <linux/spi/spi.h>
@@ -68,6 +69,7 @@ struct uart_max3110 {
 	u8 clock;
 	u8 parity, word_7bits;
 	u16 irq;
+	u16 irq_edge_triggered;
 
 	unsigned long uart_flags;
 
@@ -415,8 +417,8 @@ static int max3110_main_thread(void *_max)
 				max->uart_flags || kthread_should_stop());
 
 		mutex_lock(&max->thread_mutex);
-
-		if (test_and_clear_bit(BIT_IRQ_PENDING, &max->uart_flags))
+		if (max->irq_edge_triggered &&
+			test_and_clear_bit(BIT_IRQ_PENDING, &max->uart_flags))
 			max3110_con_receive(max);
 
 		/* first handle console output */
@@ -438,11 +440,15 @@ static irqreturn_t serial_m3110_irq(int irq, void *dev_id)
 {
 	struct uart_max3110 *max = dev_id;
 
-	/* max3110's irq is a falling edge, not level triggered,
-	 * so no need to disable the irq */
+	if (max->irq_edge_triggered) {
+		/* max3110's irq is a falling edge, not level triggered,
+		 * so no need to disable the irq */
 
-	if (!test_and_set_bit(BIT_IRQ_PENDING, &max->uart_flags))
-		wake_up(&max->wq);
+		if (!test_and_set_bit(BIT_IRQ_PENDING, &max->uart_flags))
+			wake_up(&max->wq);
+	} else {
+		max3110_con_receive(max);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -766,6 +772,10 @@ static int serial_m3110_probe(struct spi_device *spi)
 	void *buffer;
 	u16 res;
 	int ret = 0;
+	struct plat_max3110 *pdata = spi->dev.platform_data;
+
+	if (!pdata)
+		return -EINVAL;
 
 	max = kzalloc(sizeof(*max), GFP_KERNEL);
 	if (!max)
@@ -826,9 +836,18 @@ static int serial_m3110_probe(struct spi_device *spi)
 		goto err_kthread;
 	}
 
+	max->irq_edge_triggered = pdata->irq_edge_triggered;
+
 	if (max->irq) {
-		ret = request_irq(max->irq, serial_m3110_irq,
-				IRQ_TYPE_EDGE_FALLING, "max3110", max);
+		if (max->irq_edge_triggered) {
+			ret = request_irq(max->irq, serial_m3110_irq,
+					IRQ_TYPE_EDGE_FALLING, "max3110", max);
+		} else {
+			ret = request_threaded_irq(max->irq, NULL,
+					serial_m3110_irq,
+					IRQF_ONESHOT, "max3110", max);
+		}
+
 		if (ret) {
 			max->irq = 0;
 			dev_warn(&spi->dev,
diff --git a/include/linux/serial_max3110.h b/include/linux/serial_max3110.h
new file mode 100644
index 0000000..5470556
--- /dev/null
+++ b/include/linux/serial_max3110.h
@@ -0,0 +1,16 @@
+#ifndef _LINUX_SERIAL_MAX3110_H
+#define _LINUX_SERIAL_MAX3110_H
+
+/**
+ * struct plat_max3110 - MAX3110 SPI UART platform data
+ * @irq_edge_trigger: if IRQ is edge triggered
+ *
+ * You should use this structure in your machine description to specify
+ * how the MAX3110 is connected.
+ *
+ */
+struct plat_max3110 {
+	int irq_edge_triggered;
+};
+
+#endif
-- 
1.8.4.rc3

