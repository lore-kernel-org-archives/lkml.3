Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaANXAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:00:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55252 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaANW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:59:24 -0500
Message-Id: <0f3e257f098d5f1ec6e9f09ba4dbf055291f2d83.1389738151.git.joshc@codeaurora.org>
In-Reply-To: <cover.1389738151.git.joshc@codeaurora.org>
References: <cover.1389738151.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v4 4/6] spmi: pmic_arb: add support for interrupt handling
Date: Tue, 14 Jan 2014 12:41:38 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Qualcomm PMIC Arbiter, in addition to being a basic SPMI controller,
also implements interrupt handling for slave devices.  Note, this is
outside the scope of SPMI, as SPMI leaves interrupt handling completely
unspecified.

Extend the driver to provide a irq_chip implementation and chained irq
handling which allows for these interrupts to be used.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/spmi/spmi-pmic-arb.c | 393 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 391 insertions(+), 2 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 16083cd..32bed54 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -13,6 +13,9 @@
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -103,6 +106,14 @@ enum pmic_arb_cmd_op_code {
  * @cnfg:		address of the PMIC Arbiter configuration registers.
  * @lock:		lock to synchronize accesses.
  * @channel:		which channel to use for accesses.
+ * @irq:		PMIC ARB interrupt.
+ * @ee:			the current Execution Environment
+ * @min_apid:		minimum APID (used for bounding IRQ search)
+ * @max_apid:		maximum APID
+ * @mapping_table:	in-memory copy of PPID -> APID mapping table.
+ * @domain:		irq domain object for PMIC IRQ domain
+ * @spmic:		SPMI controller object
+ * @apid_to_ppid:	cached mapping from APID to PPID
  */
 struct spmi_pmic_arb_dev {
 	void __iomem		*base;
@@ -110,6 +121,14 @@ struct spmi_pmic_arb_dev {
 	void __iomem		*cnfg;
 	spinlock_t		lock;
 	u8			channel;
+	unsigned int		irq;
+	u8			ee;
+	u8			min_apid;
+	u8			max_apid;
+	u32			mapping_table[SPMI_MAPPING_TABLE_LEN];
+	struct irq_domain	*domain;
+	struct spmi_controller	*spmic;
+	u16			apid_to_ppid[256];
 };
 
 static inline u32 pmic_arb_base_read(struct spmi_pmic_arb_dev *dev, u32 offset)
@@ -314,12 +333,333 @@ static int pmic_arb_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	return rc;
 }
 
+enum qpnpint_regs {
+	QPNPINT_REG_RT_STS		= 0x10,
+	QPNPINT_REG_SET_TYPE		= 0x11,
+	QPNPINT_REG_POLARITY_HIGH	= 0x12,
+	QPNPINT_REG_POLARITY_LOW	= 0x13,
+	QPNPINT_REG_LATCHED_CLR		= 0x14,
+	QPNPINT_REG_EN_SET		= 0x15,
+	QPNPINT_REG_EN_CLR		= 0x16,
+	QPNPINT_REG_LATCHED_STS		= 0x18,
+};
+
+struct spmi_pmic_arb_qpnpint_type {
+	u8 type; /* 1 -> edge */
+	u8 polarity_high;
+	u8 polarity_low;
+} __packed;
+
+/* Simplified accessor functions for irqchip callbacks */
+static void qpnpint_spmi_write(struct irq_data *d, u8 reg, void *buf,
+			       size_t len)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	u8 sid = d->hwirq >> 24;
+	u8 per = d->hwirq >> 16;
+
+	if (pmic_arb_write_cmd(pa->spmic, SPMI_CMD_EXT_WRITEL, sid,
+			       (per << 8) + reg, buf, len))
+		dev_err_ratelimited(&pa->spmic->dev,
+				"failed irqchip transaction on %x\n",
+				    d->irq);
+}
+
+static void qpnpint_spmi_read(struct irq_data *d, u8 reg, void *buf, size_t len)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	u8 sid = d->hwirq >> 24;
+	u8 per = d->hwirq >> 16;
+
+	if (pmic_arb_read_cmd(pa->spmic, SPMI_CMD_EXT_READL, sid,
+			      (per << 8) + reg, buf, len))
+		dev_err_ratelimited(&pa->spmic->dev,
+				"failed irqchip transaction on %x\n",
+				    d->irq);
+}
+
+static void periph_interrupt(struct spmi_pmic_arb_dev *pa, u8 apid)
+{
+	unsigned int irq;
+	u32 status;
+	int id;
+
+	status = readl_relaxed(pa->intr + SPMI_PIC_IRQ_STATUS(apid));
+	while (status) {
+		id = ffs(status) - 1;
+		status &= ~(1 << id);
+		irq = irq_find_mapping(pa->domain,
+				       pa->apid_to_ppid[apid] << 16
+				     | id << 8
+				     | apid);
+		generic_handle_irq(irq);
+	}
+}
+
+static void pmic_arb_chained_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct spmi_pmic_arb_dev *pa = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
+	void __iomem *intr = pa->intr;
+	int first = pa->min_apid >> 5;
+	int last = pa->max_apid >> 5;
+	u32 status;
+	int i, id;
+
+	chained_irq_enter(chip, desc);
+
+	for (i = first; i <= last; ++i) {
+		status = readl_relaxed(intr +
+				       SPMI_PIC_OWNER_ACC_STATUS(pa->ee, i));
+		while (status) {
+			id = ffs(status) - 1;
+			status &= ~(1 << id);
+			periph_interrupt(pa, id + i * 32);
+		}
+	}
+
+	chained_irq_exit(chip, desc);
+}
+
+static void qpnpint_irq_ack(struct irq_data *d)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	u8 irq  = d->hwirq >> 8;
+	u8 apid = d->hwirq;
+	unsigned long flags;
+	u8 data;
+
+	dev_dbg(&pa->spmic->dev, "hwirq %lu irq: %d\n", d->hwirq, d->irq);
+
+	spin_lock_irqsave(&pa->lock, flags);
+	writel_relaxed(1 << irq, pa->intr + SPMI_PIC_IRQ_CLEAR(apid));
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	data = 1 << irq;
+	qpnpint_spmi_write(d, QPNPINT_REG_LATCHED_CLR, &data, 1);
+}
+
+static void qpnpint_irq_mask(struct irq_data *d)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	u8 irq  = d->hwirq >> 8;
+	u8 apid = d->hwirq;
+	unsigned long flags;
+	u32 status;
+	u8 data;
+
+	dev_dbg(&pa->spmic->dev, "hwirq %lu irq: %d\n", d->hwirq, d->irq);
+
+	spin_lock_irqsave(&pa->lock, flags);
+	status = readl_relaxed(pa->intr + SPMI_PIC_ACC_ENABLE(apid));
+	if (status & SPMI_PIC_ACC_ENABLE_BIT) {
+		status = status & ~SPMI_PIC_ACC_ENABLE_BIT;
+		writel_relaxed(status, pa->intr + SPMI_PIC_ACC_ENABLE(apid));
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	data = 1 << irq;
+	qpnpint_spmi_write(d, QPNPINT_REG_EN_CLR, &data, 1);
+}
+
+static void qpnpint_irq_unmask(struct irq_data *d)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	u8 irq  = d->hwirq >> 8;
+	u8 apid = d->hwirq;
+	unsigned long flags;
+	u32 status;
+	u8 data;
+
+	dev_dbg(&pa->spmic->dev, "hwirq %lu irq: %d, apid = %02x\n", d->hwirq,
+				  d->irq, apid);
+
+	spin_lock_irqsave(&pa->lock, flags);
+	status = readl_relaxed(pa->intr + SPMI_PIC_ACC_ENABLE(apid));
+	if (!(status & SPMI_PIC_ACC_ENABLE_BIT)) {
+		writel_relaxed(status | SPMI_PIC_ACC_ENABLE_BIT,
+				pa->intr + SPMI_PIC_ACC_ENABLE(apid));
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	data = 1 << irq;
+	qpnpint_spmi_write(d, QPNPINT_REG_EN_SET, &data, 1);
+}
+
+static void qpnpint_irq_enable(struct irq_data *d)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	u8 irq  = d->hwirq >> 8;
+	u8 data;
+
+	dev_dbg(&pa->spmic->dev, "hwirq %lu irq: %d\n", d->hwirq, d->irq);
+
+	qpnpint_irq_unmask(d);
+
+	data = 1 << irq;
+	qpnpint_spmi_write(d, QPNPINT_REG_LATCHED_CLR, &data, 1);
+}
+
+static int qpnpint_irq_set_type(struct irq_data *d, unsigned int flow_type)
+{
+	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
+	struct spmi_pmic_arb_qpnpint_type type;
+	u8 irq = d->hwirq >> 8;
+
+	dev_dbg(&pa->spmic->dev, "qpnpint_irq_set_type %p, %x\n", d, flow_type);
+
+	qpnpint_spmi_read(d, QPNPINT_REG_SET_TYPE, &type, sizeof(type));
+
+	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
+		type.type |= 1 << irq;
+		if (flow_type & IRQF_TRIGGER_RISING)
+			type.polarity_high |= 1 << irq;
+		if (flow_type & IRQF_TRIGGER_FALLING)
+			type.polarity_low  |= 1 << irq;
+	} else {
+		if ((flow_type & (IRQF_TRIGGER_HIGH)) &&
+		    (flow_type & (IRQF_TRIGGER_LOW)))
+			return -EINVAL;
+
+		type.type &= ~(1 << irq); /* level trig */
+		if (flow_type & IRQF_TRIGGER_HIGH)
+			type.polarity_high |= 1 << irq;
+		else
+			type.polarity_low  |= 1 << irq;
+	}
+
+	qpnpint_spmi_write(d, QPNPINT_REG_SET_TYPE, &type, sizeof(type));
+	return 0;
+}
+
+static struct irq_chip pmic_arb_irqchip = {
+	.name		= "pmic_arb",
+	.irq_enable	= qpnpint_irq_enable,
+	.irq_ack	= qpnpint_irq_ack,
+	.irq_mask	= qpnpint_irq_mask,
+	.irq_unmask	= qpnpint_irq_unmask,
+	.irq_set_type	= qpnpint_irq_set_type,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND
+			| IRQCHIP_SKIP_SET_WAKE,
+};
+
+struct spmi_pmic_arb_irq_spec {
+	unsigned slave:4;
+	unsigned per:8;
+	unsigned irq:3;
+};
+
+static int search_mapping_table(struct spmi_pmic_arb_dev *pa,
+				struct spmi_pmic_arb_irq_spec *spec,
+				u8 *apid)
+{
+	u16 ppid = spec->slave << 8 | spec->per;
+	u32 *mapping_table = pa->mapping_table;
+	int index = 0, i;
+	u32 data;
+
+	for (i = 0; i < SPMI_MAPPING_TABLE_TREE_DEPTH; ++i) {
+		data = mapping_table[index];
+
+		if (ppid & (1 << SPMI_MAPPING_BIT_INDEX(data))) {
+			if (SPMI_MAPPING_BIT_IS_1_FLAG(data)) {
+				index = SPMI_MAPPING_BIT_IS_1_RESULT(data);
+			} else {
+				*apid = SPMI_MAPPING_BIT_IS_1_RESULT(data);
+				return 0;
+			}
+		} else {
+			if (SPMI_MAPPING_BIT_IS_0_FLAG(data)) {
+				index = SPMI_MAPPING_BIT_IS_0_RESULT(data);
+			} else {
+				*apid = SPMI_MAPPING_BIT_IS_0_RESULT(data);
+				return 0;
+			}
+		}
+	}
+
+	return -ENODEV;
+}
+
+static int qpnpint_irq_domain_dt_translate(struct irq_domain *d,
+					   struct device_node *controller,
+					   const u32 *intspec,
+					   unsigned int intsize,
+					   unsigned long *out_hwirq,
+					   unsigned int *out_type)
+{
+	struct spmi_pmic_arb_dev *pa = d->host_data;
+	struct spmi_pmic_arb_irq_spec spec;
+	int err;
+	u8 apid;
+
+	dev_dbg(&pa->spmic->dev,
+		"intspec[0] 0x%1x intspec[1] 0x%02x intspec[2] 0x%02x\n",
+		intspec[0], intspec[1], intspec[2]);
+
+	if (d->of_node != controller)
+		return -EINVAL;
+	if (intsize != 4)
+		return -EINVAL;
+	if (intspec[0] > 0xF || intspec[1] > 0xFF || intspec[2] > 0x7)
+		return -EINVAL;
+
+	spec.slave = intspec[0];
+	spec.per   = intspec[1];
+	spec.irq   = intspec[2];
+
+	err = search_mapping_table(pa, &spec, &apid);
+	if (err)
+		return err;
+
+	pa->apid_to_ppid[apid] = spec.slave << 8 | spec.per;
+
+	/* Keep track of {max,min}_apid for bounding search during interrupt */
+	if (apid > pa->max_apid)
+		pa->max_apid = apid;
+	if (apid < pa->min_apid)
+		pa->min_apid = apid;
+
+	*out_hwirq = spec.slave << 24
+		   | spec.per   << 16
+		   | spec.irq   << 8
+		   | apid;
+	*out_type  = intspec[3] & IRQ_TYPE_SENSE_MASK;
+
+	dev_dbg(&pa->spmic->dev, "out_hwirq = %lu\n", *out_hwirq);
+
+	return 0;
+}
+
+static int qpnpint_irq_domain_map(struct irq_domain *d,
+				  unsigned int virq,
+				  irq_hw_number_t hwirq)
+{
+	struct spmi_pmic_arb_dev *pa = d->host_data;
+
+	dev_dbg(&pa->spmic->dev, "virq = %u, hwirq = %lu\n", virq, hwirq);
+
+	irq_set_chip_and_handler(virq, &pmic_arb_irqchip, handle_level_irq);
+	irq_set_chip_data(virq, d->host_data);
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+	return 0;
+}
+
+static const struct irq_domain_ops pmic_arb_irq_domain_ops = {
+	.map	= qpnpint_irq_domain_map,
+	.xlate	= qpnpint_irq_domain_dt_translate,
+};
+
 static int spmi_pmic_arb_probe(struct platform_device *pdev)
 {
 	struct spmi_pmic_arb_dev *pa;
 	struct spmi_controller *ctrl;
 	struct resource *res;
-	u32 channel;
+	u32 channel, ee;
 	int err, i;
 
 	ctrl = spmi_controller_alloc(&pdev->dev, sizeof(*pa));
@@ -327,6 +667,7 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pa = spmi_controller_get_drvdata(ctrl);
+	pa->spmic = ctrl;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
 	pa->base = devm_ioremap_resource(&ctrl->dev, res);
@@ -349,6 +690,12 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 		goto err_put_ctrl;
 	}
 
+	pa->irq = platform_get_irq(pdev, 0);
+	if (pa->irq < 0) {
+		err = pa->irq;
+		goto err_put_ctrl;
+	}
+
 	err = of_property_read_u32(pdev->dev.of_node, "qcom,channel", &channel);
 	if (err) {
 		dev_err(&pdev->dev, "channel unspecified.\n");
@@ -363,6 +710,28 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 
 	pa->channel = channel;
 
+	err = of_property_read_u32(pdev->dev.of_node, "qcom,ee", &ee);
+	if (err) {
+		dev_err(&pdev->dev, "EE unspecified.\n");
+		goto err_put_ctrl;
+	}
+
+	if (ee > 5) {
+		dev_err(&pdev->dev, "invalid EE (%u) specified\n", ee);
+		goto err_put_ctrl;
+	}
+
+	pa->ee = ee;
+
+	for (i = 0; i < ARRAY_SIZE(pa->mapping_table); ++i)
+		pa->mapping_table[i] = readl_relaxed(
+				pa->cnfg + SPMI_MAPPING_TABLE_REG(i));
+
+	/* Initialize max_apid/min_apid to the opposite bounds, during
+	 * the irq domain translation, we are sure to update these */
+	pa->max_apid = 0;
+	pa->min_apid = PMIC_ARB_MAX_PERIPHS - 1;
+
 	platform_set_drvdata(pdev, ctrl);
 	spin_lock_init(&pa->lock);
 
@@ -370,15 +739,31 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	ctrl->read_cmd = pmic_arb_read_cmd;
 	ctrl->write_cmd = pmic_arb_write_cmd;
 
+	dev_dbg(&pdev->dev, "adding irq domain\n");
+	pa->domain = irq_domain_add_tree(pdev->dev.of_node,
+					 &pmic_arb_irq_domain_ops, pa);
+	if (!pa->domain) {
+		dev_err(&pdev->dev, "unable to create irq_domain\n");
+		err = -ENOMEM;
+		goto err_put_ctrl;
+	}
+
+	irq_set_handler_data(pa->irq, pa);
+	irq_set_chained_handler(pa->irq, pmic_arb_chained_irq);
+
 	err = spmi_controller_add(ctrl);
 	if (err)
-		goto err_put_ctrl;
+		goto err_domain_remove;
 
 	dev_dbg(&ctrl->dev, "PMIC Arb Version 0x%x\n",
 		pmic_arb_base_read(pa, PMIC_ARB_VERSION));
 
 	return 0;
 
+err_domain_remove:
+	irq_set_chained_handler(pa->irq, NULL);
+	irq_set_handler_data(pa->irq, NULL);
+	irq_domain_remove(pa->domain);
 err_put_ctrl:
 	spmi_controller_put(ctrl);
 	return err;
@@ -387,7 +772,11 @@ err_put_ctrl:
 static int spmi_pmic_arb_remove(struct platform_device *pdev)
 {
 	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
+	struct spmi_pmic_arb_dev *pa = spmi_controller_get_drvdata(ctrl);
 	spmi_controller_remove(ctrl);
+	irq_set_chained_handler(pa->irq, NULL);
+	irq_set_handler_data(pa->irq, NULL);
+	irq_domain_remove(pa->domain);
 	spmi_controller_put(ctrl);
 	return 0;
 }
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


