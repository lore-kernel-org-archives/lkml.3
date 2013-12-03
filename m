Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3LCDpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:45:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45171 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab3LCDon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 11/15] mfd: menelaus: Start to use irqdomain
Date: Mon, 2 Dec 2013 21:43:04 -0600
Message-ID: <1386042188-12246-11-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce an irq_chip and irq_domain for
menelaus driver. Following patches will
convert uses to traditional request_threaded_irq().

while at that, some better error handling had
to be added, so we could free irq descs we
allocated.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 120 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index aa3c579..e4f33b7 100644
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
 
@@ -1205,12 +1295,32 @@ static int menelaus_probe(struct i2c_client *client,
 
 	the_menelaus = m;
 	m->client = client;
+	mutex_init(&m->lock);
+
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
+		irq_set_chip_data(i, m);
+		irq_set_chip_and_handler(i, &menelaus_irq_chip,
+				handle_simple_irq);
+		irq_set_nested_thread(i, 1);
+		set_irq_flags(i, IRQF_VALID);
+	}
 
 	/* If a true probe check the device */
 	rev = menelaus_read_reg(m, MENELAUS_REV);
 	if (rev < 0) {
 		pr_err(DRIVER_NAME ": device not found");
-		return -ENODEV;
+		goto fail_free_descs;
 	}
 
 	/* Ack and disable all Menelaus interrupts */
@@ -1230,17 +1340,15 @@ static int menelaus_probe(struct i2c_client *client,
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
-			return err;
+			goto fail_free_descs;
 		}
 	}
 
-	mutex_init(&m->lock);
-
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
 
 	val = menelaus_read_reg(m, MENELAUS_VCORE_CTRL1);
 	if (val < 0)
-		goto fail;
+		goto fail_free_irq;
 	if (val & (1 << 7))
 		m->vcore_hw_mode = 1;
 	else
@@ -1249,14 +1357,18 @@ static int menelaus_probe(struct i2c_client *client,
 	if (menelaus_pdata != NULL && menelaus_pdata->late_init != NULL) {
 		err = menelaus_pdata->late_init(&client->dev);
 		if (err < 0)
-			goto fail;
+			goto fail_free_irq;
 	}
 
 	menelaus_rtc_init(m);
 
 	return 0;
-fail:
+fail_free_irq:
 	free_irq(client->irq, m);
+
+fail_free_descs:
+	irq_free_descs(irq_base, MENELAUS_NR_IRQS);
+
 	return err;
 }
 
@@ -1265,6 +1377,7 @@ static int menelaus_remove(struct i2c_client *client)
 	struct menelaus_chip	*m = i2c_get_clientdata(client);
 
 	free_irq(client->irq, m);
+	irq_free_descs(m->irq_base, MENELAUS_NR_IRQS);
 	the_menelaus = NULL;
 	return 0;
 }
-- 
1.8.4.GIT

