Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3KLNmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:42:22 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59885 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3KLNmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:42:12 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-fd-528230310d10
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] regulator: s5m8767: Disable OVCB in probe
Date: Tue, 12 Nov 2013 14:41:55 +0100
Message-id: <1384263715-5713-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
References: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xy7qGBk1BBh+WW1lMffiEzeL1C0OL
	s01v2C3ufz3KaPHtSgeTxeVdc9gsTnezWlxc8YXJgcNj56y77B6bVnWyedy5tofNY97JQI++
	LasYPT5vkgtgi+KySUnNySxLLdK3S+DKuDTrPWvBG6GKVU8msDcwXubvYuTkkBAwkfjRvZoZ
	whaTuHBvPVsXIxeHkMBSRonD669AOX1MEg13H7GCVLEJGEtsXr4ELCEicI1R4ti3PWAJZoE4
	idMvloONEhawkvhztIEJxGYRUJXYcPQ/WJxXwE1i7Y6fjF2MHEDrFCTmTLIBCXMKeEjM3DoP
	rERIwF3i75821gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATZlx2Mi49ZHWIU
	4GBU4uHdwdUYJMSaWFZcmXuIUYKDWUmEN1q+KUiINyWxsiq1KD++qDQntfgQIxMHp1QD46wN
	ZZzFTN1fuhYd53tzVNPiQpXDXNM4hbJ97NdLYmVnrnv4ftXNZ+0PzQ/O36iR1HYvbv+12uIV
	AZuOrz5tX2D28ehr1cudyb1v5FP1E+O5l4QpbZBtuLFTycB9k4Fj2Ayx7zy8E+P6pv1efO5H
	8FLRFOb+u3w31sw/eN54k6ud5IMPUSofkpRYijMSDbWYi4oTAX/3L6YQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to SW Guide the Over-Voltage Clamp may malfunction at VBatt
5.25V and 110'C temperature. This may result in overshooting or
undershooting LDO's voltage outputs.
Disable the Over-Voltage Clamp in probe by updating proper bit in all
LDO registers.

The patch uses sec_bulk_read/write() API with reordered buf and count
parameters so it depends on:
  "mfd: sec: reorder params in API for regmap consistency"
  http://www.spinics.net/lists/kernel/msg1632519.html

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/s5m8767.c         |   26 ++++++++++++++++++++++++++
 include/linux/mfd/samsung/s5m8767.h |    1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index ac10db4..7c6fb97 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -478,6 +478,26 @@ static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(BUCK9),
 };
 
+/*
+ * Disables Over-Voltage Clamp for all LDO-s.
+ */
+static int s5m8767_reg_disable_ldo_ovcb(struct s5m8767_info *s5m8767)
+{
+	u8 data[28];
+	int i, ret;
+
+	ret = sec_bulk_read(s5m8767->iodev, S5M8767_REG_LDO1, data,
+			ARRAY_SIZE(data));
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(data); i++)
+		data[i] |= (1 << S5M8767_REG_LDO_SHIFT);
+
+	return sec_bulk_write(s5m8767->iodev, S5M8767_REG_LDO1, data,
+			ARRAY_SIZE(data));
+}
+
 #ifdef CONFIG_OF
 static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
 			struct sec_platform_data *pdata,
@@ -886,6 +906,12 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
+	/*
+	 * Disable Over-Voltage Clamp,
+	 * possible malfunction at VBatt 5.25V and 110'C temperature
+	 */
+	s5m8767_reg_disable_ldo_ovcb(s5m8767);
+
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct sec_voltage_desc *desc;
 		int id = pdata->regulators[i].id;
diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
index 306a95f..d6c09a0 100644
--- a/include/linux/mfd/samsung/s5m8767.h
+++ b/include/linux/mfd/samsung/s5m8767.h
@@ -184,5 +184,6 @@ enum s5m8767_regulators {
 };
 
 #define S5M8767_ENCTRL_SHIFT  6
+#define S5M8767_REG_LDO_SHIFT	7
 
 #endif /* __LINUX_MFD_S5M8767_H */
-- 
1.7.9.5

