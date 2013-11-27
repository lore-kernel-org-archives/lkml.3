Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab3K0TJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:09:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50947 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3K0TIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 11/13] mfd: menelaus: start to use irqdomain
Date: Wed, 27 Nov 2013 13:06:55 -0600
Message-ID: <1385579217-20127-12-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1385579217-20127-1-git-send-email-balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce an irq_chip and irq_domain for
menelaus driver. Following patches will
convert uses to traditional request_threaded_irq().

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index aa3c579..295fe84 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
@@ -47,6 +48,7 @@
 #include <asm/gpio.h>
 
 #define DRIVER_NAME			"menelaus"
+#define MENELAUS_NR_IRQS		16
 
 #define MENELAUS_I2C_ADDRESS		0x72
 
@@ -168,11 +170,19 @@ struct menelaus_chip {
 	u8			rtc_control;
 	unsigned		uie:1;
 #endif
+	int			irq_base;
 	unsigned		vcore_hw_mode:1;
 	u8			mask1, mask2;
+	u8			ack1, ack2;
+
 	void			(*handlers[16])(struct menelaus_chip *);
 	void			(*mmc_callback)(void *data, u8 mask);
 	void			*mmc_callback_data;
+
+	unsigned		mask1_pending:1;
+	unsigned		mask2_pending:1;
+	unsigned		ack1_pending:1;
+	unsigned		ack2_pending:1;
 };
 
 static struct menelaus_chip *the_menelaus;
@@ -235,6 +245,83 @@ static int menelaus_ack_irq(struct menelaus_chip *m, int irq)
 		return menelaus_write_reg(m, MENELAUS_INT_ACK1, 1 << irq);
 }
 
+static void menelaus_irq_ack(struct irq_data *data)
+{
+	struct menelaus_chip *m = irq_data_get_irq_chip_data(data);
+	int irq = data->irq - m->irq_base;
+
+	if (irq > 7) {
+		m->ack2 |= BIT(irq);
+		m->ack2_pending = true;
+	} else {
+		m->ack1 |= BIT(irq);
+		m->ack1_pending = true;
+	}
+}
+
+static void menelaus_irq_mask(struct irq_data *data)
+{
+	struct menelaus_chip *m = irq_data_get_irq_chip_data(data);
+	int irq = data->irq - m->irq_base;
+
+	if (irq > 7) {
+		m->mask2 |= BIT(irq);
+		m->mask2_pending = true;
+	} else {
+		m->mask1 |= BIT(irq);
+		m->mask1_pending = true;
+	}
+}
+
+static void menelaus_irq_unmask(struct irq_data *data)
+{
+	struct menelaus_chip *m = irq_data_get_irq_chip_data(data);
+	int irq = data->irq - m->irq_base;
+
+	if (irq > 7) {
+		m->mask2 &= ~BIT(irq);
+		m->mask2_pending = true;
+	} else {
+		m->mask1 &= ~BIT(irq);
+		m->mask1_pending = true;
+	}
+}
+
+static void menelaus_irq_bus_lock(struct irq_data *data)
+{
+	struct menelaus_chip *m = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&m->lock);
+}
+
+static void menelaus_irq_bus_sync_unlock(struct irq_data *data)
+{
+	struct menelaus_chip *m = irq_data_get_irq_chip_data(data);
+
+	if (m->ack1_pending)
+		menelaus_write_reg(m, MENELAUS_INT_ACK1, m->ack1);
+
+	if (m->ack2_pending)
+		menelaus_write_reg(m, MENELAUS_INT_ACK2, m->ack2);
+
+	if (m->mask1_pending)
+		menelaus_write_reg(m, MENELAUS_INT_MASK1, m->mask1);
+
+	if (m->mask2_pending)
+		menelaus_write_reg(m, MENELAUS_INT_MASK2, m->mask2);
+
+	mutex_unlock(&m->lock);
+}
+
+static struct irq_chip menelaus_irq_chip = {
+	.name		= "menelaus",
+	.irq_ack	= menelaus_irq_ack,
+	.irq_mask	= menelaus_irq_mask,
+	.irq_unmask	= menelaus_irq_unmask,
+	.irq_bus_lock	= menelaus_irq_bus_lock,
+	.irq_bus_sync_unlock = menelaus_irq_bus_sync_unlock,
+};
+
 /* Adds a handler for an interrupt. Does not run in interrupt context */
 static int menelaus_add_irq_work(struct menelaus_chip *m, int irq,
 		void (*handler)(struct menelaus_chip *))
@@ -1186,8 +1273,11 @@ static int menelaus_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
 	struct menelaus_chip	*m;
+	struct device_node	*node = client->dev.of_node;
 	int			rev = 0, val;
 	int			err = 0;
+	int			irq_base;
+	int			i;
 	struct menelaus_platform_data *menelaus_pdata =
 					dev_get_platdata(&client->dev);
 
@@ -1206,6 +1296,25 @@ static int menelaus_probe(struct i2c_client *client,
 	the_menelaus = m;
 	m->client = client;
 
+	irq_base = irq_alloc_descs(-1, 0, MENELAUS_NR_IRQS, 0);
+	if (irq_base < 0) {
+		dev_err(&client->dev, "failed to allocate irq descs\n");
+		return irq_base;
+	}
+
+	irq_domain_add_legacy(node, MENELAUS_NR_IRQS, irq_base, 0,
+			&irq_domain_simple_ops, m);
+
+	m->irq_base = irq_base;
+
+	for (i = irq_base; i < irq_base + MENELAUS_NR_IRQS; i++) {
+		irq_set_chip_and_handler(i, &menelaus_irq_chip,
+				handle_simple_irq);
+		irq_set_nested_thread(i, 1);
+		irq_set_chip_data(i, m);
+		set_irq_flags(i, IRQF_VALID);
+	}
+
 	/* If a true probe check the device */
 	rev = menelaus_read_reg(m, MENELAUS_REV);
 	if (rev < 0) {
-- 
1.8.4.GIT

