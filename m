Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaAPTck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:32:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41969 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAPTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:32:38 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] regulator: ti-abb: Add support for interleaved LDO registers
Date: Thu, 16 Jan 2014 13:32:30 -0600
Message-ID: <1389900750-27625-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain platforms such as DRA7 have quirky memory maps such as:
PRM_ABBLDO_DSPEVE_CTRL	0x4ae07e20
PRM_ABBLDO_IVA_CTRL	0x4ae07e24
other-registers
PRM_ABBLDO_DSPEVE_SETUP	0x4ae07e30
PRM_ABBLDO_IVA_SETUP	0x4ae07e34

These need the address allocation to be either shared OR unique
allocation per register instance.

So, introduce v3 type of ABB for these instances to allocate based on
shared address ranges.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
Baseline off: v3.13-rc8

The alternate approach is to introduce registers as seperate
reg-names options, which means all existing abb-v1,v2 will probably have to
change as well.

The reason for this mishmash of register allocation is due to SoC integration
lack of discipline of ensuring that device instances need contigous register
allocation :(.. but too late to fix :(

 .../bindings/regulator/ti-abb-regulator.txt        |    1 +
 drivers/regulator/ti-abb-regulator.c               |   26 +++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
index 2e57a33..96ae151 100644
--- a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
@@ -4,6 +4,7 @@ Required Properties:
 - compatible: Should be one of:
   - "ti,abb-v1" for older SoCs like OMAP3
   - "ti,abb-v2" for newer SoCs like OMAP4, OMAP5
+  - "ti,abb-v3" for newer SoCs like DRA7 quirky addressing
 - reg: Address and length of the register set for the device. It contains
   the information of registers in the same order as described by reg-names
 - reg-names: Should contain the reg names
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index b187b6b..5f9cfd4 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -673,9 +673,23 @@ static const struct ti_abb_reg abb_regs_v2 = {
 	.opp_sel_mask		= (0x03 << 0),
 };
 
+static const struct ti_abb_reg abb_regs_v3 = {
+	.control_reg		= 0x00,
+	.setup_reg		= 0x10,
+
+	.sr2_wtcnt_value_mask	= (0xff << 8),
+	.fbb_sel_mask		= (0x01 << 2),
+	.rbb_sel_mask		= (0x01 << 1),
+	.sr2_en_mask		= (0x01 << 0),
+
+	.opp_change_mask	= (0x01 << 2),
+	.opp_sel_mask		= (0x03 << 0),
+};
+
 static const struct of_device_id ti_abb_of_match[] = {
 	{.compatible = "ti,abb-v1", .data = &abb_regs_v1},
 	{.compatible = "ti,abb-v2", .data = &abb_regs_v2},
+	{.compatible = "ti,abb-v3", .data = &abb_regs_v3},
 	{ },
 };
 
@@ -724,7 +738,17 @@ static int ti_abb_probe(struct platform_device *pdev)
 	/* Map ABB resources */
 	pname = "base-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
-	abb->base = devm_ioremap_resource(dev, res);
+	if (!res) {
+		dev_err(dev, "Missing '%s' IO resource\n", pname);
+		return -ENODEV;
+	}
+
+	/*
+	 * On some platforms such as DRA7, the register range of ABB LDOx is
+	 * interleaved with registers of another ABB LDO and non-LDO registers!
+	 * We cannot use reserved allocation in these cases.
+	 */
+	abb->base = devm_ioremap_nocache(dev, res->start, resource_size(res));
 	if (IS_ERR(abb->base))
 		return PTR_ERR(abb->base);
 
-- 
1.7.9.5

