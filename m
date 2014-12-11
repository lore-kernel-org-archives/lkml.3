Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbaLKNkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:40:37 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35885 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:40:36 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-37-54899ecde48d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] regulator: s2mps11: Fix dw_mmc failure on Gear 2
Date: Thu, 11 Dec 2014 14:40:21 +0100
Message-id: <1418305221-30348-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJMWRmVeSWpSXmKPExsVy+t/xq7pn53WGGNz8yWIx9eETNovXLwwt
	vl3pYLK4vGsOm8XFFV+YLBZsfMTowOaxc9Zddo9NqzrZPPq2rGL0+LxJLoAlissmJTUnsyy1
	SN8ugSvjS+sl1oIfUhUPduxma2C8KNbFyMkhIWAi8XzKQUYIW0ziwr31bF2MXBxCAksZJe5N
	f8AC4fQxSZxc+ocFpIpNwFhi8/IlYFUiAj2MEi+3fmYGSTALeEq8+/uQHcQWFnCROHn5LxuI
	zSKgKnHh3DSgOAcHr4C7xLvVoRDb5CROHpvMOoGRewEjwypG0dTS5ILipPRcI73ixNzi0rx0
	veT83E2MkID4uoNx6TGrQ4wCHIxKPLwZ8Z0hQqyJZcWVuYcYJTiYlUR4rSKAQrwpiZVVqUX5
	8UWlOanFhxiZODilGhgZHXf4hr43PKQcu1Gm1D/mfMUtjYalLDXvWa/ZFH3/MjNW97S29s7K
	NV3fGwWCtr/t88vt0RE4+UJcI779KeeExSk+p6LFLz8oW2R2es21DKMFk1QKwk/vcpdZl/I1
	jnORm8Sf5hca3AeXzd8WfUv57u8J22VWhRy7t2fTgofLtq9b4T6758Z0JZbijERDLeai4kQA
	665lNOYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalid buck4 configuration for linear mapping of voltage in S2MPS14
regulators caused boot failure on Gear 2 (dw_mmc-exynos):

[    3.569137] EXT4-fs (mmcblk0p15): mounted filesystem with ordered data mode. Opts: (null)
[    3.571716] VFS: Mounted root (ext4 filesystem) readonly on device 179:15.
[    3.629842] mmcblk0: error -110 sending status command, retrying
[    3.630244] mmcblk0: error -110 sending status command, retrying
[    3.636292] mmcblk0: error -110 sending status command, aborting

Buck4 voltage regulator has different minimal voltage value than other
bucks. Commit merging multiple regulator description macros caused to
use linear_min_sel from buck[1235] regulators as value for buck4. This
lead to lower voltage of buck4 than required.

Output of the buck4 is used internally as power source for
LDO{3,4,7,11,19,20,21,23}. On Gear 2 board LDO11 is used as MMC
regulator (V_EMMC_1.8V).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 5a867cf28893 ("regulator: s2mps11: Optimize the regulator description macro")
Cc: <stable@vger.kernel.org>

---
Changes since v1:
1. Extend patch description and trim dmesg log.
2. Justify indentation for carried-over regulator_desc_s2mps14_buck argument.
---
 drivers/regulator/s2mps11.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index c1444c3d84c2..2809ae0d6bcd 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -570,7 +570,7 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.enable_mask	= S2MPS14_ENABLE_MASK		\
 }
 
-#define regulator_desc_s2mps14_buck(num, min, step) {		\
+#define regulator_desc_s2mps14_buck(num, min, step, min_sel) {	\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPS14_BUCK##num,			\
 	.ops		= &s2mps14_reg_ops,			\
@@ -579,7 +579,7 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.min_uV		= min,					\
 	.uV_step	= step,					\
 	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
-	.linear_min_sel = S2MPS14_BUCK1235_START_SEL,		\
+	.linear_min_sel = min_sel,				\
 	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
 	.vsel_reg	= S2MPS14_REG_B1CTRL2 + (num - 1) * 2,	\
 	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
@@ -613,11 +613,16 @@ static const struct regulator_desc s2mps14_regulators[] = {
 	regulator_desc_s2mps14_ldo(23, MIN_800_MV, STEP_25_MV),
 	regulator_desc_s2mps14_ldo(24, MIN_1800_MV, STEP_25_MV),
 	regulator_desc_s2mps14_ldo(25, MIN_1800_MV, STEP_25_MV),
-	regulator_desc_s2mps14_buck(1, MIN_600_MV, STEP_6_25_MV),
-	regulator_desc_s2mps14_buck(2, MIN_600_MV, STEP_6_25_MV),
-	regulator_desc_s2mps14_buck(3, MIN_600_MV, STEP_6_25_MV),
-	regulator_desc_s2mps14_buck(4, MIN_1400_MV, STEP_12_5_MV),
-	regulator_desc_s2mps14_buck(5, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps14_buck(1, MIN_600_MV, STEP_6_25_MV,
+				    S2MPS14_BUCK1235_START_SEL),
+	regulator_desc_s2mps14_buck(2, MIN_600_MV, STEP_6_25_MV,
+				    S2MPS14_BUCK1235_START_SEL),
+	regulator_desc_s2mps14_buck(3, MIN_600_MV, STEP_6_25_MV,
+				    S2MPS14_BUCK1235_START_SEL),
+	regulator_desc_s2mps14_buck(4, MIN_1400_MV, STEP_12_5_MV,
+				    S2MPS14_BUCK4_START_SEL),
+	regulator_desc_s2mps14_buck(5, MIN_600_MV, STEP_6_25_MV,
+				    S2MPS14_BUCK1235_START_SEL),
 };
 
 static int s2mps14_pmic_enable_ext_control(struct s2mps11_info *s2mps11,
-- 
1.9.1

