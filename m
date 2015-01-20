Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbbATBKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 20:10:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38388 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbATBKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 20:10:21 -0500
From: Gilad Avidov <gavidov@codeaurora.org>
To: gavidov@codeaurora.org, sdharia@codeaurora.org, mlocke@codeaurora.org,
        linux-arm-msm@vger.kernel.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, iivanov@mm-sol.com, galak@codeaurora.org,
        agross@codeaurora.org
Subject: [PATCH] spmi: pmic_arb: add support for hw version 2
Date: Mon, 19 Jan 2015 18:10:10 -0700
Message-Id: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qualcomm PMIC Arbiter version-2 changes from version-1 are:

- Some diffrent register offsets.
- New channel register space, one per PMIC peripheral (ppid).
  All tx tarffic uses these channels.
- New observer register space. All rx trafic uses this space.
- Diffrent command format for spmi command registers.

Signed-off-by: Gilad Avidov <gavidov@codeaurora.org>
Acked-by: Sagar Dharia <sdharia@codeaurora.org>
---
 .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  11 +-
 drivers/spmi/spmi-pmic-arb.c                       | 295 ++++++++++++++++++---
 2 files changed, 263 insertions(+), 43 deletions(-)

diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
index 715d099..827bd21 100644
--- a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
@@ -1,11 +1,11 @@
 Qualcomm SPMI Controller (PMIC Arbiter)
 
-The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
+The SPMI PMIC Arbiter is found on Snapdragon chipsets.  It is an SPMI
 controller with wrapping arbitration logic to allow for multiple on-chip
 devices to control a single SPMI master.
 
-The PMIC Arbiter can also act as an interrupt controller, providing interrupts
-to slave devices.
+The PMIC Arbiter is also an interrupt controller, interrupting the Snapdragon
+on dtection of a sequence initiated by a request-capable-slave to the master.
 
 See spmi.txt for the generic SPMI controller binding requirements for child
 nodes.
@@ -38,6 +38,11 @@ Required properties:
     cell 4: interrupt flags indicating level-sense information, as defined in
             dt-bindings/interrupt-controller/irq.h
 
+Optional properties:
+- reg-names  : may have "chnls", "obsrvr"
+     "chnls"  - tx-channel per virtual slave registers.
+     "obsrvr" - rx-channel (called observer) per virtual slave registers.
+
 Example:
 
 	spmi {
diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 246e03a..d12979a 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -25,16 +25,18 @@
 
 /* PMIC Arbiter configuration registers */
 #define PMIC_ARB_VERSION		0x0000
+#define PMIC_ARB_VERSION_V2_MIN		(0x20010000)
 #define PMIC_ARB_INT_EN			0x0004
 
-/* PMIC Arbiter channel registers */
-#define PMIC_ARB_CMD(N)			(0x0800 + (0x80 * (N)))
-#define PMIC_ARB_CONFIG(N)		(0x0804 + (0x80 * (N)))
-#define PMIC_ARB_STATUS(N)		(0x0808 + (0x80 * (N)))
-#define PMIC_ARB_WDATA0(N)		(0x0810 + (0x80 * (N)))
-#define PMIC_ARB_WDATA1(N)		(0x0814 + (0x80 * (N)))
-#define PMIC_ARB_RDATA0(N)		(0x0818 + (0x80 * (N)))
-#define PMIC_ARB_RDATA1(N)		(0x081C + (0x80 * (N)))
+/* PMIC Arbiter channel registers offsets */
+#define PMIC_ARB_CMD			(0x00)
+#define PMIC_ARB_CONFIG			(0x04)
+#define PMIC_ARB_STATUS			(0x08)
+#define PMIC_ARB_WDATA0			(0x10)
+#define PMIC_ARB_WDATA1			(0x14)
+#define PMIC_ARB_RDATA0			(0x18)
+#define PMIC_ARB_RDATA1			(0x1C)
+#define PMIC_ARB_REG_CHNL(N)		(0x800 + 0x4 * (N))
 
 /* Interrupt Controller */
 #define SPMI_PIC_OWNER_ACC_STATUS(M, N)	(0x0000 + ((32 * (M)) + (4 * (N))))
@@ -52,6 +54,7 @@
 
 #define SPMI_MAPPING_TABLE_LEN		255
 #define SPMI_MAPPING_TABLE_TREE_DEPTH	16	/* Maximum of 16-bits */
+#define PPID_TO_CHAN_TABLE_SZ 		BIT(12)	/* PPID is 12bit chan is 1byte*/
 
 /* Ownership Table */
 #define SPMI_OWNERSHIP_TABLE_REG(N)	(0x0700 + (4 * (N)))
@@ -88,6 +91,7 @@ enum pmic_arb_cmd_op_code {
 
 /* Maximum number of support PMIC peripherals */
 #define PMIC_ARB_MAX_PERIPHS		256
+#define PMIC_ARB_MAX_CHNL		128
 #define PMIC_ARB_PERIPH_ID_VALID	(1 << 15)
 #define PMIC_ARB_TIMEOUT_US		100
 #define PMIC_ARB_MAX_TRANS_BYTES	(8)
@@ -98,14 +102,17 @@ enum pmic_arb_cmd_op_code {
 /* interrupt enable bit */
 #define SPMI_PIC_ACC_ENABLE_BIT		BIT(0)
 
+struct pmic_arb_ver;
+
 /**
  * spmi_pmic_arb_dev - SPMI PMIC Arbiter object
  *
- * @base:		address of the PMIC Arbiter core registers.
+ * @rd_base:		on v1 "core", on v2 "observer" register base off DT.
+ * @rd_base:		on v1 "core", on v2 "chnls"    register base off DT.
  * @intr:		address of the SPMI interrupt control registers.
  * @cnfg:		address of the PMIC Arbiter configuration registers.
  * @lock:		lock to synchronize accesses.
- * @channel:		which channel to use for accesses.
+ * @channel:		which ee channel to use for accesses.
  * @irq:		PMIC ARB interrupt.
  * @ee:			the current Execution Environment
  * @min_apid:		minimum APID (used for bounding IRQ search)
@@ -114,9 +121,11 @@ enum pmic_arb_cmd_op_code {
  * @domain:		irq domain object for PMIC IRQ domain
  * @spmic:		SPMI controller object
  * @apid_to_ppid:	cached mapping from APID to PPID
+ * @ppid_to_chan	cached mapping from APID to channel number, v2 only.
  */
 struct spmi_pmic_arb_dev {
-	void __iomem		*base;
+	void __iomem		*rd_base;
+	void __iomem		*wr_base;
 	void __iomem		*intr;
 	void __iomem		*cnfg;
 	raw_spinlock_t		lock;
@@ -129,17 +138,61 @@ struct spmi_pmic_arb_dev {
 	struct irq_domain	*domain;
 	struct spmi_controller	*spmic;
 	u16			apid_to_ppid[256];
+	const struct pmic_arb_ver *ver;
+	u8			*ppid_to_chan;
+};
+
+/**
+ * pmic_arb_ver: version dependent functionality and values.
+ *
+ * @non_data_cmd:	on v1 issues an spmi non-data command.
+ * 			on v2 no HW support, returns -EOPNOTSUPP.
+ * @offset:		on v1 offset of per-ee channel.
+ * 			on v2 offset of per-ee and per-ppid channel.
+ * @fmt_cmd:		formats a GENI/SPMI command.
+ * @owner_acc_status:	on v1 offset of PMIC_ARB_SPMI_PIC_OWNERm_ACC_STATUSn
+ * 			on v2 offset of SPMI_PIC_OWNERm_ACC_STATUSn.
+ * @acc_enable:		on v1 offset of PMIC_ARB_SPMI_PIC_ACC_ENABLEn
+ * 			on v2 offset of SPMI_PIC_ACC_ENABLEn.
+ * @irq_status:		on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_STATUSn
+ * 			on v2 offset of SPMI_PIC_IRQ_STATUSn.
+ * @irq_clear:		on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_CLEARn
+ * 			on v2 offset of SPMI_PIC_IRQ_CLEARn.
+ * @geni_ctrl:		PMIC_ARB_GENI_CTRL offset.
+ * @geni_status:	PMIC_ARB_GENI_STATUS offset.
+ * @protocol_irq_status: PMIC_ARB_PROTOCOL_IRQ_STATUS offset.
+ */
+struct pmic_arb_ver {
+	int	(*non_data_cmd)(struct spmi_controller *ctrl, u8 opc, u8 sid);
+	/* SPMI commands (including data) related functionality */
+	off_t	(*offset)(struct spmi_pmic_arb_dev *dev, u8 sid, u16 addr);
+	u32	(*fmt_cmd)(u8 opc, u8 sid, u16 addr, u8 bc);
+	/* Interrupts related functionality (offset of PIC registers) */
+	off_t	(*owner_acc_status)(u8 m, u8 n);
+	off_t	(*acc_enable)(u8 n);
+	off_t	(*irq_status)(u8 n);
+	off_t	(*irq_clear)(u8 n);
+	/* Register offsets */
+	off_t	geni_ctrl;
+	off_t	geni_status;
+	off_t	protocol_irq_status;
 };
 
 static inline u32 pmic_arb_base_read(struct spmi_pmic_arb_dev *dev, u32 offset)
 {
-	return readl_relaxed(dev->base + offset);
+	return readl_relaxed(dev->rd_base + offset);
 }
 
 static inline void pmic_arb_base_write(struct spmi_pmic_arb_dev *dev,
 				       u32 offset, u32 val)
 {
-	writel_relaxed(val, dev->base + offset);
+	writel_relaxed(val, dev->wr_base + offset);
+}
+
+static inline void pmic_arb_set_rd_cmd(struct spmi_pmic_arb_dev *dev,
+				       u32 offset, u32 val)
+{
+	writel_relaxed(val, dev->rd_base + offset);
 }
 
 /**
@@ -168,12 +221,13 @@ pa_write_data(struct spmi_pmic_arb_dev *dev, const u8 *buf, u32 reg, u8 bc)
 	pmic_arb_base_write(dev, reg, data);
 }
 
-static int pmic_arb_wait_for_done(struct spmi_controller *ctrl)
+static int pmic_arb_wait_for_done(struct spmi_controller *ctrl,
+					void __iomem *base, u8 sid, u16 addr)
 {
 	struct spmi_pmic_arb_dev *dev = spmi_controller_get_drvdata(ctrl);
 	u32 status = 0;
 	u32 timeout = PMIC_ARB_TIMEOUT_US;
-	u32 offset = PMIC_ARB_STATUS(dev->channel);
+	u32 offset = dev->ver->offset(dev, sid, addr) + PMIC_ARB_STATUS;
 
 	while (timeout--) {
 		status = pmic_arb_base_read(dev, offset);
@@ -211,28 +265,46 @@ static int pmic_arb_wait_for_done(struct spmi_controller *ctrl)
 	return -ETIMEDOUT;
 }
 
-/* Non-data command */
-static int pmic_arb_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid)
+static int
+pmic_arb_non_data_cmd_v1(struct spmi_controller *ctrl, u8 opc, u8 sid)
 {
 	struct spmi_pmic_arb_dev *pmic_arb = spmi_controller_get_drvdata(ctrl);
 	unsigned long flags;
 	u32 cmd;
 	int rc;
-
-	/* Check for valid non-data command */
-	if (opc < SPMI_CMD_RESET || opc > SPMI_CMD_WAKEUP)
-		return -EINVAL;
+	u32 offset = pmic_arb->ver->offset(pmic_arb, sid, 0);
 
 	cmd = ((opc | 0x40) << 27) | ((sid & 0xf) << 20);
 
 	raw_spin_lock_irqsave(&pmic_arb->lock, flags);
-	pmic_arb_base_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
-	rc = pmic_arb_wait_for_done(ctrl);
+	pmic_arb_base_write(pmic_arb, offset + PMIC_ARB_CMD, cmd);
+	rc = pmic_arb_wait_for_done(ctrl, pmic_arb->wr_base, sid, 0);
 	raw_spin_unlock_irqrestore(&pmic_arb->lock, flags);
 
 	return rc;
 }
 
+/* Unsupported by HW */
+static int
+pmic_arb_non_data_cmd_v2(struct spmi_controller *ctrl, u8 opc, u8 sid)
+{
+	return -EOPNOTSUPP;
+}
+
+/* Non-data command */
+static int pmic_arb_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid)
+{
+	struct spmi_pmic_arb_dev *pmic_arb = spmi_controller_get_drvdata(ctrl);
+
+	pr_debug("op:0x%x sid:%d\n", opc, sid);
+
+	/* Check for valid non-data command */
+	if (opc < SPMI_CMD_RESET || opc > SPMI_CMD_WAKEUP)
+		return -EINVAL;
+
+	return pmic_arb->ver->non_data_cmd(ctrl, opc, sid);
+}
+
 static int pmic_arb_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 			     u16 addr, u8 *buf, size_t len)
 {
@@ -241,6 +313,7 @@ static int pmic_arb_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	u8 bc = len - 1;
 	u32 cmd;
 	int rc;
+	phys_addr_t offset = pmic_arb->ver->offset(pmic_arb, sid, addr);
 
 	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
 		dev_err(&ctrl->dev,
@@ -259,20 +332,20 @@ static int pmic_arb_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	else
 		return -EINVAL;
 
-	cmd = (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
+	cmd = pmic_arb->ver->fmt_cmd(opc, sid, addr, bc);
 
 	raw_spin_lock_irqsave(&pmic_arb->lock, flags);
-	pmic_arb_base_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
-	rc = pmic_arb_wait_for_done(ctrl);
+	pmic_arb_set_rd_cmd(pmic_arb, offset + PMIC_ARB_CMD, cmd);
+	rc = pmic_arb_wait_for_done(ctrl, pmic_arb->rd_base, sid, addr);
 	if (rc)
 		goto done;
 
-	pa_read_data(pmic_arb, buf, PMIC_ARB_RDATA0(pmic_arb->channel),
+	pa_read_data(pmic_arb, buf, offset + PMIC_ARB_RDATA0,
 		     min_t(u8, bc, 3));
 
 	if (bc > 3)
 		pa_read_data(pmic_arb, buf + 4,
-				PMIC_ARB_RDATA1(pmic_arb->channel), bc - 4);
+				offset + PMIC_ARB_RDATA1, bc - 4);
 
 done:
 	raw_spin_unlock_irqrestore(&pmic_arb->lock, flags);
@@ -287,6 +360,7 @@ static int pmic_arb_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	u8 bc = len - 1;
 	u32 cmd;
 	int rc;
+	u32 offset = pmic_arb->ver->offset(pmic_arb, sid, addr);
 
 	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
 		dev_err(&ctrl->dev,
@@ -307,19 +381,19 @@ static int pmic_arb_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	else
 		return -EINVAL;
 
-	cmd = (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
+	cmd = pmic_arb->ver->fmt_cmd(opc, sid, addr, bc);
 
 	/* Write data to FIFOs */
 	raw_spin_lock_irqsave(&pmic_arb->lock, flags);
-	pa_write_data(pmic_arb, buf, PMIC_ARB_WDATA0(pmic_arb->channel)
+	pa_write_data(pmic_arb, buf, offset + PMIC_ARB_WDATA0
 							, min_t(u8, bc, 3));
 	if (bc > 3)
 		pa_write_data(pmic_arb, buf + 4,
-				PMIC_ARB_WDATA1(pmic_arb->channel), bc - 4);
+				offset + PMIC_ARB_WDATA1, bc - 4);
 
 	/* Start the transaction */
-	pmic_arb_base_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
-	rc = pmic_arb_wait_for_done(ctrl);
+	pmic_arb_base_write(pmic_arb, offset + PMIC_ARB_CMD, cmd);
+	rc = pmic_arb_wait_for_done(ctrl, pmic_arb->wr_base, sid, addr);
 	raw_spin_unlock_irqrestore(&pmic_arb->lock, flags);
 
 	return rc;
@@ -624,6 +698,96 @@ static int qpnpint_irq_domain_map(struct irq_domain *d,
 	return 0;
 }
 
+/* v1 offset per ee */
+static off_t pmic_arb_offset_v1(struct spmi_pmic_arb_dev *pa, u8 sid, u16 addr)
+{
+	return 0x800 + 0x80 * (pa->channel);
+}
+
+/* v2 offset per ppid (chan) and per ee */
+static off_t pmic_arb_offset_v2(struct spmi_pmic_arb_dev *pa, u8 sid, u16 addr)
+{
+	u16 ppid = (sid << 8) | (addr >> 8);
+	u8  chan = pa->ppid_to_chan[ppid];
+	return 0x1000 * pa->ee + 0x8000 * chan;
+}
+
+static u32 pmic_arb_fmt_cmd_v1(u8 opc, u8 sid, u16 addr, u8 bc)
+{
+	return (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
+}
+
+static u32 pmic_arb_fmt_cmd_v2(u8 opc, u8 sid, u16 addr, u8 bc)
+{
+	return (opc << 27) | ((addr & 0xff) << 4) | (bc & 0x7);
+}
+
+static off_t pmic_arb_owner_acc_status_v1(u8 m, u8 n)
+{
+	return 0x20 * (m) + 0x4 * (n);
+}
+
+static off_t pmic_arb_owner_acc_status_v2(u8 m, u8 n)
+{
+	return 0x100000 + 0x1000 * (m) + 0x4 * (n);
+}
+
+static off_t pmic_arb_acc_enable_v1(u8 n)
+{
+	return 0x200 + 0x4 * (n);
+}
+
+static off_t pmic_arb_acc_enable_v2(u8 n)
+{
+	return 0x1000 * (n);
+}
+
+static off_t pmic_arb_irq_status_v1(u8 n)
+{
+	return 0x600 + 0x4 * (n);
+}
+
+static off_t pmic_arb_irq_status_v2(u8 n)
+{
+	return 0x4 + 0x1000 * (n);
+}
+
+static off_t pmic_arb_irq_clear_v1(u8 n)
+{
+	return 0xA00 + 0x4 * (n);
+}
+
+static off_t pmic_arb_irq_clear_v2(u8 n)
+{
+	return 0x8 + 0x1000 * (n);
+}
+
+static const struct pmic_arb_ver pmic_arb_v1 = {
+	.non_data_cmd		= pmic_arb_non_data_cmd_v1,
+	.offset			= pmic_arb_offset_v1,
+	.fmt_cmd		= pmic_arb_fmt_cmd_v1,
+	.owner_acc_status	= pmic_arb_owner_acc_status_v1,
+	.acc_enable		= pmic_arb_acc_enable_v1,
+	.irq_status		= pmic_arb_irq_status_v1,
+	.irq_clear		= pmic_arb_irq_clear_v1,
+	.geni_ctrl		= 0x24,
+	.geni_status		= 0x28,
+	.protocol_irq_status	= (0x700 + 0x820),
+};
+
+static const struct pmic_arb_ver pmic_arb_v2 = {
+	.non_data_cmd		= pmic_arb_non_data_cmd_v2,
+	.offset			= pmic_arb_offset_v2,
+	.fmt_cmd		= pmic_arb_fmt_cmd_v2,
+	.owner_acc_status	= pmic_arb_owner_acc_status_v2,
+	.acc_enable		= pmic_arb_acc_enable_v2,
+	.irq_status		= pmic_arb_irq_status_v2,
+	.irq_clear		= pmic_arb_irq_clear_v2,
+	.geni_ctrl		= 0x28,
+	.geni_status		= 0x2C,
+	.protocol_irq_status	= (0x700 + 0x900),
+};
+
 static const struct irq_domain_ops pmic_arb_irq_domain_ops = {
 	.map	= qpnpint_irq_domain_map,
 	.xlate	= qpnpint_irq_domain_dt_translate,
@@ -634,9 +798,11 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	struct spmi_pmic_arb_dev *pa;
 	struct spmi_controller *ctrl;
 	struct resource *res;
-	u32 channel, ee;
+	u32 channel, ee, hw_ver;
 	int err, i;
 
+	pr_err("PMIC Arbiter\n");
+
 	ctrl = spmi_controller_alloc(&pdev->dev, sizeof(*pa));
 	if (!ctrl)
 		return -ENOMEM;
@@ -645,12 +811,64 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	pa->spmic = ctrl;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
-	pa->base = devm_ioremap_resource(&ctrl->dev, res);
-	if (IS_ERR(pa->base)) {
-		err = PTR_ERR(pa->base);
+	pa->rd_base = devm_ioremap_resource(&ctrl->dev, res);
+	if (IS_ERR(pa->rd_base)) {
+		err = PTR_ERR(pa->rd_base);
 		goto err_put_ctrl;
 	}
 
+	hw_ver = readl_relaxed(pa->rd_base + PMIC_ARB_VERSION);
+
+	if (hw_ver < PMIC_ARB_VERSION_V2_MIN) {
+		pa->ver	 = &pmic_arb_v1;
+		dev_dbg(&ctrl->dev, "PMIC Arb Version-1 (0x%x)\n", hw_ver);
+		pa->wr_base = pa->rd_base;
+	} else {
+		u8  chan;
+		u16 ppid;
+		u32 regval;
+
+		pa->ver = &pmic_arb_v2;
+		dev_dbg(&ctrl->dev, "PMIC Arb Version-2 (0x%x)\n", hw_ver);
+
+		pa->ppid_to_chan = devm_kzalloc(&ctrl->dev,
+					PPID_TO_CHAN_TABLE_SZ, GFP_KERNEL);
+		if (!pa->ppid_to_chan) {
+			dev_err(&ctrl->dev,
+				"faild allocation of ppid_to_chan table\n");
+			err = -ENOMEM;
+			goto err_put_ctrl;
+		}
+		/*
+		 * PMIC_ARB_REG_CHNL is a table in HW mapping channel to ppid.
+		 * ppid_to_chan is an inverted cache of that table.
+		 */
+		for (chan = 0; chan < PMIC_ARB_MAX_CHNL; ++chan) {
+			regval = readl_relaxed(pa->rd_base +
+						      PMIC_ARB_REG_CHNL(chan));
+			if (!regval)
+				continue;
+
+			ppid = (regval >> 8) & 0xFFF;
+			pa->ppid_to_chan[ppid] = chan;
+		}
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+								"obsrvr");
+		pa->rd_base = devm_ioremap_resource(&ctrl->dev, res);
+		if (IS_ERR(pa->rd_base)) {
+			err = PTR_ERR(pa->rd_base);
+			goto err_put_ctrl;
+		}
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+								"chnls");
+		if (IS_ERR(pa->wr_base)) {
+			err = PTR_ERR(pa->wr_base);
+			goto err_put_ctrl;
+		}
+	}
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "intr");
 	pa->intr = devm_ioremap_resource(&ctrl->dev, res);
 	if (IS_ERR(pa->intr)) {
@@ -731,9 +949,6 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	if (err)
 		goto err_domain_remove;
 
-	dev_dbg(&ctrl->dev, "PMIC Arb Version 0x%x\n",
-		pmic_arb_base_read(pa, PMIC_ARB_VERSION));
-
 	return 0;
 
 err_domain_remove:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

