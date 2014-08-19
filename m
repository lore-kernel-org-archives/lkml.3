Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaHSUXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:23:36 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17162 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbaHSUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:23:34 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH] genirq: Introduce irq_read_line()
Date: Tue, 19 Aug 2014 13:23:31 -0700
Message-ID: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the irq_read_line() function to allow device drivers to read
the current logical state of an input when the hardware only exposes
this through status bits in the interrupt controller.

The new function is backed by a new callback function in the irq_chip -
irq_read_line() - that can be implemented by irq_chips that owns such
status bits.

Based on rfc patch from April 2011 by Abhijeet.

Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

Due to address size limitations in the SSBI protocol used to communicate with
various Qualcomm PMICs most accesses are banked. Furthermore the input/status
bits for the adc, battery monitor, charger, gpio, mpp and usb blocks are all
banked as interrupt status bits.

Therefor to be able to implement any of those drivers we need to make a call
into the pm8xxx irq_chip code to acquire the state of those bits - as my first
hack [1] did.


The patch is based on Abhijeet's RFC found here [2], but my reasons for having
this accessor function is different.

[1] https://lkml.org/lkml/2014/7/7/892
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/048277.html

 include/linux/interrupt.h |    1 +
 include/linux/irq.h       |    2 ++
 kernel/irq/manage.c       |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 698ad05..8f3af5d 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -361,6 +361,7 @@ static inline int disable_irq_wake(unsigned int irq)
 	return irq_set_irq_wake(irq, 0);
 }
 
+extern int irq_read_line(unsigned int irq);
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 extern bool force_irqthreads;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0d998d8..f656590 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -294,6 +294,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_retrigger:	resend an IRQ to the CPU
  * @irq_set_type:	set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
+ * @irq_read_line:	read the logical state of an irq line
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
  * @irq_cpu_online:	configure an interrupt source for a secondary CPU
@@ -326,6 +327,7 @@ struct irq_chip {
 	int		(*irq_retrigger)(struct irq_data *data);
 	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
 	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
+	int		(*irq_read_line)(struct irq_data *data);
 
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3dc6a61..33bf9c7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -565,6 +565,31 @@ int irq_set_irq_wake(unsigned int irq, unsigned int on)
 }
 EXPORT_SYMBOL(irq_set_irq_wake);
 
+/**
+ *	irq_read_line - read the logical state of an irq line
+ *	@irq:	interrupt to read
+ *
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
+ */
+int irq_read_line(unsigned int irq)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+	int ret = -ENOSYS;
+
+	desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	if (!desc)
+		return -EINVAL;
+
+	if (desc->irq_data.chip->irq_read_line)
+		ret = desc->irq_data.chip->irq_read_line(&desc->irq_data);
+
+	irq_put_desc_busunlock(desc, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(irq_read_line);
+
 /*
  * Internal function that tells the architecture code whether a
  * particular irq has been exclusively allocated or is available
-- 
1.7.9.5

