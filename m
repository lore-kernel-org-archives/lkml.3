Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3HMHis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:38:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13086 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3HMHip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:38:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 Aug 2013 00:38:44 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>, <sameo@linux.intel.com>
CC: <swarren@wwwdotorg.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob@landley.net>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <j-keerthy@ti.com>,
        <ian.campbell@citrix.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/3] mfd: palmas: add support for external control configuration
Date: Tue, 13 Aug 2013 13:23:11 +0530
Message-ID: <1376380392-19723-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com>
References: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of Palmas resources like clock, SMPSs, LDOs etc can be controlled
by external pins ENABLE1, ENABLE2 or NSLEEP.

Add support to configure these resources to externally controlled.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Fix typos: palams ->palmas

 drivers/mfd/palmas.c       |   97 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/palmas.h |   49 ++++++++++++++++++++++
 2 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index e4d1c70..e71fa28 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -25,6 +25,52 @@
 #include <linux/mfd/palmas.h>
 #include <linux/of_device.h>
 
+#define PALMAS_EXT_REQ (PALMAS_EXT_CONTROL_ENABLE1 |	\
+			PALMAS_EXT_CONTROL_ENABLE2 |	\
+			PALMAS_EXT_CONTROL_NSLEEP)
+
+struct palmas_sleep_requestor_info {
+	int id;
+	int reg_offset;
+	int bit_pos;
+};
+
+#define EXTERNAL_REQUESTOR(_id, _offset, _pos)		\
+	[PALMAS_EXTERNAL_REQSTR_ID_##_id] = {		\
+		.id = PALMAS_EXTERNAL_REQSTR_ID_##_id,	\
+		.reg_offset = _offset,			\
+		.bit_pos = _pos,			\
+	}
+
+static struct palmas_sleep_requestor_info sleep_req_info[] = {
+	EXTERNAL_REQUESTOR(REGEN1, 0, 0),
+	EXTERNAL_REQUESTOR(REGEN2, 0, 1),
+	EXTERNAL_REQUESTOR(SYSEN1, 0, 2),
+	EXTERNAL_REQUESTOR(SYSEN2, 0, 3),
+	EXTERNAL_REQUESTOR(CLK32KG, 0, 4),
+	EXTERNAL_REQUESTOR(CLK32KGAUDIO, 0, 5),
+	EXTERNAL_REQUESTOR(REGEN3, 0, 6),
+	EXTERNAL_REQUESTOR(SMPS12, 1, 0),
+	EXTERNAL_REQUESTOR(SMPS3, 1, 1),
+	EXTERNAL_REQUESTOR(SMPS45, 1, 2),
+	EXTERNAL_REQUESTOR(SMPS6, 1, 3),
+	EXTERNAL_REQUESTOR(SMPS7, 1, 4),
+	EXTERNAL_REQUESTOR(SMPS8, 1, 5),
+	EXTERNAL_REQUESTOR(SMPS9, 1, 6),
+	EXTERNAL_REQUESTOR(SMPS10, 1, 7),
+	EXTERNAL_REQUESTOR(LDO1, 2, 0),
+	EXTERNAL_REQUESTOR(LDO2, 2, 1),
+	EXTERNAL_REQUESTOR(LDO3, 2, 2),
+	EXTERNAL_REQUESTOR(LDO4, 2, 3),
+	EXTERNAL_REQUESTOR(LDO5, 2, 4),
+	EXTERNAL_REQUESTOR(LDO6, 2, 5),
+	EXTERNAL_REQUESTOR(LDO7, 2, 6),
+	EXTERNAL_REQUESTOR(LDO8, 2, 7),
+	EXTERNAL_REQUESTOR(LDO9, 3, 0),
+	EXTERNAL_REQUESTOR(LDOLN, 3, 1),
+	EXTERNAL_REQUESTOR(LDOUSB, 3, 2),
+};
+
 static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
 	{
 		.reg_bits = 8,
@@ -186,6 +232,57 @@ static struct regmap_irq_chip palmas_irq_chip = {
 			PALMAS_INT1_MASK),
 };
 
+int palmas_ext_control_req_config(struct palmas *palmas,
+	enum palmas_external_requestor_id id,  int ext_ctrl, bool enable)
+{
+	int preq_mask_bit = 0;
+	int reg_add = 0;
+	int bit_pos;
+	int ret;
+
+	if (!(ext_ctrl & PALMAS_EXT_REQ))
+		return 0;
+
+	if (id >= PALMAS_EXTERNAL_REQSTR_ID_MAX)
+		return 0;
+
+	if (ext_ctrl & PALMAS_EXT_CONTROL_NSLEEP) {
+		reg_add = PALMAS_NSLEEP_RES_ASSIGN;
+		preq_mask_bit = 0;
+	} else if (ext_ctrl & PALMAS_EXT_CONTROL_ENABLE1) {
+		reg_add = PALMAS_ENABLE1_RES_ASSIGN;
+		preq_mask_bit = 1;
+	} else if (ext_ctrl & PALMAS_EXT_CONTROL_ENABLE2) {
+		reg_add = PALMAS_ENABLE2_RES_ASSIGN;
+		preq_mask_bit = 2;
+	}
+
+	bit_pos = sleep_req_info[id].bit_pos;
+	reg_add += sleep_req_info[id].reg_offset;
+	if (enable)
+		ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
+				reg_add, BIT(bit_pos), BIT(bit_pos));
+	else
+		ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
+				reg_add, BIT(bit_pos), 0);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Resource reg 0x%02x update failed %d\n",
+			reg_add, ret);
+		return ret;
+	}
+
+	/* Unmask the PREQ */
+	ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
+			PALMAS_POWER_CTRL, BIT(preq_mask_bit), 0);
+	if (ret < 0) {
+		dev_err(palmas->dev, "POWER_CTRL register update failed %d\n",
+			ret);
+		return ret;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(palmas_ext_control_req_config);
+
 static int palmas_set_pdata_irq_flag(struct i2c_client *i2c,
 		struct palmas_platform_data *pdata)
 {
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index e6090d8..dc99c3a 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -184,6 +184,50 @@ enum palmas_regulators {
 	PALMAS_NUM_REGS,
 };
 
+/* External controll signal name */
+enum {
+	PALMAS_EXT_CONTROL_ENABLE1      = 0x1,
+	PALMAS_EXT_CONTROL_ENABLE2      = 0x2,
+	PALMAS_EXT_CONTROL_NSLEEP       = 0x4,
+};
+
+/*
+ * Palmas device resources can be controlled externally for
+ * enabling/disabling it rather than register write through i2c.
+ * Add the external controlled requestor ID for different resources.
+ */
+enum palmas_external_requestor_id {
+	PALMAS_EXTERNAL_REQSTR_ID_REGEN1,
+	PALMAS_EXTERNAL_REQSTR_ID_REGEN2,
+	PALMAS_EXTERNAL_REQSTR_ID_SYSEN1,
+	PALMAS_EXTERNAL_REQSTR_ID_SYSEN2,
+	PALMAS_EXTERNAL_REQSTR_ID_CLK32KG,
+	PALMAS_EXTERNAL_REQSTR_ID_CLK32KGAUDIO,
+	PALMAS_EXTERNAL_REQSTR_ID_REGEN3,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS12,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS3,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS45,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS6,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS7,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS8,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS9,
+	PALMAS_EXTERNAL_REQSTR_ID_SMPS10,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO1,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO2,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO3,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO4,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO5,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO6,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO7,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO8,
+	PALMAS_EXTERNAL_REQSTR_ID_LDO9,
+	PALMAS_EXTERNAL_REQSTR_ID_LDOLN,
+	PALMAS_EXTERNAL_REQSTR_ID_LDOUSB,
+
+	/* Last entry */
+	PALMAS_EXTERNAL_REQSTR_ID_MAX,
+};
+
 struct palmas_pmic_platform_data {
 	/* An array of pointers to regulator init data indexed by regulator
 	 * ID
@@ -2865,4 +2909,9 @@ static inline int palmas_irq_get_virq(struct palmas *palmas, int irq)
 	return regmap_irq_get_virq(palmas->irq_data, irq);
 }
 
+
+int palmas_ext_control_req_config(struct palmas *palmas,
+	enum palmas_external_requestor_id ext_control_req_id,
+	int ext_ctrl, bool enable);
+
 #endif /*  __LINUX_MFD_PALMAS_H */
-- 
1.7.1.1

