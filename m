Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaH1NGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:06:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30094 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaH1NGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:06:11 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-2b-53ff2940a491
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 1/8] mfd: max14577: Add defines for MAX77836 charger
Date: Thu, 28 Aug 2014 15:05:43 +0200
Message-id: <1409231150-2701-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
References: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7oOmv+DDbae5LDYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFl8
	7j3CaLH2yF12i6XXLzJZTJi+lsWide8RdovT3awWp3eXOAh7rJm3htHjcl8vk8fOWXfZPVYu
	/8LmsXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5AK4orhsUlJzMstSi/TtErgyFryaxFyw
	UKPi+vxH7A2ML5W6GDk4JARMJJ611HQxcgKZYhIX7q1n62Lk4hASWMoocffBP2YIp49J4vW8
	EywgVWwCxhKbly9hA7FFBBYwSVxclwtiMwucYZaYupoDxBYWcJfo2nqOGcRmEVCVON/ZzQpi
	8wq4SRw+cokVYpucxMljk8FsTqD6D037WEEOEgKq2dwTMoGRdwEjwypG0dTS5ILipPRcQ73i
	xNzi0rx0veT83E2MkJD/soNx8TGrQ4wCHIxKPLwbSv8FC7EmlhVX5h5ilOBgVhLh3ST5P1iI
	NyWxsiq1KD++qDQntfgQIxMHp1QDY5Jg9TGTCSkK706/tjn9tNTZfLMPs6Oi27mUTeEisgsv
	XVvPrL2lskd9usU61dV2YefXz/8SsKv9RvjKL8eXT+FIYq6wmOjXtu3NnBOlefO/2nb9W/x+
	xspfN9TKhR6aJMx7c9X5ZSjf7F63vd+6nHhDph1Meh26L+jpr6mCTqxHvrRa7A9a8VmJpTgj
	0VCLuag4EQAYZCMkVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for adding support for MAX77836 charger to the max14577 charger
driver by adding necessary new defines and prefixes to existing ones.

The MAX77836 uses slightly different values for ChgTyp field of STATUS2
register. On the MAX14577 value of 0x6 is reserved and 0x7 dead battery.
On the MAX77836 the opposite:
 - 0x6 means special charger,
 - 0x7 is reserved.
Regardless of these differences use one common enum
max14577_muic_charger_type.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max14577-private.h | 54 ++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 499253604026..d6f321699b89 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -72,15 +72,33 @@ enum max14577_muic_reg {
 	MAX14577_MUIC_REG_END,
 };
 
+/*
+ * Combined charger types for max14577 and max77836.
+ *
+ * On max14577 three lower bits map to STATUS2/CHGTYP field.
+ * However the max77836 has different two last values of STATUS2/CHGTYP.
+ * To indicate the difference enum has two additional values for max77836.
+ * These values are just a register value bitwise OR with 0x8.
+ */
 enum max14577_muic_charger_type {
-	MAX14577_CHARGER_TYPE_NONE = 0,
-	MAX14577_CHARGER_TYPE_USB,
-	MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT,
-	MAX14577_CHARGER_TYPE_DEDICATED_CHG,
-	MAX14577_CHARGER_TYPE_SPECIAL_500MA,
-	MAX14577_CHARGER_TYPE_SPECIAL_1A,
-	MAX14577_CHARGER_TYPE_RESERVED,
-	MAX14577_CHARGER_TYPE_DEAD_BATTERY = 7,
+	MAX14577_CHARGER_TYPE_NONE		= 0x0,
+	MAX14577_CHARGER_TYPE_USB		= 0x1,
+	MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT	= 0x2,
+	MAX14577_CHARGER_TYPE_DEDICATED_CHG	= 0x3,
+	MAX14577_CHARGER_TYPE_SPECIAL_500MA	= 0x4,
+	/* Special 1A or 2A charger */
+	MAX14577_CHARGER_TYPE_SPECIAL_1A	= 0x5,
+	/* max14577: reserved, used on max77836 */
+	MAX14577_CHARGER_TYPE_RESERVED		= 0x6,
+	/* max14577: dead-battery charing with maximum current 100mA */
+	MAX14577_CHARGER_TYPE_DEAD_BATTERY	= 0x7,
+	/*
+	 * max77836: special charger (bias on D+/D-),
+	 * matches register value of 0x6
+	 */
+	MAX77836_CHARGER_TYPE_SPECIAL_BIAS	= 0xe,
+	/* max77836: reserved, register value 0x7 */
+	MAX77836_CHARGER_TYPE_RESERVED		= 0xf,
 };
 
 /* MAX14577 interrupts */
@@ -121,13 +139,15 @@ enum max14577_muic_charger_type {
 #define STATUS2_CHGTYP_SHIFT		0
 #define STATUS2_CHGDETRUN_SHIFT		3
 #define STATUS2_DCDTMR_SHIFT		4
-#define STATUS2_DBCHG_SHIFT		5
+#define MAX14577_STATUS2_DBCHG_SHIFT	5
+#define MAX77836_STATUS2_DXOVP_SHIFT	5
 #define STATUS2_VBVOLT_SHIFT		6
 #define MAX77836_STATUS2_VIDRM_SHIFT	7
 #define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
 #define STATUS2_CHGDETRUN_MASK		BIT(STATUS2_CHGDETRUN_SHIFT)
 #define STATUS2_DCDTMR_MASK		BIT(STATUS2_DCDTMR_SHIFT)
-#define STATUS2_DBCHG_MASK		BIT(STATUS2_DBCHG_SHIFT)
+#define MAX14577_STATUS2_DBCHG_MASK	BIT(MAX14577_STATUS2_DBCHG_SHIFT)
+#define MAX77836_STATUS2_DXOVP_MASK	BIT(MAX77836_STATUS2_DXOVP_SHIFT)
 #define STATUS2_VBVOLT_MASK		BIT(STATUS2_VBVOLT_SHIFT)
 #define MAX77836_STATUS2_VIDRM_MASK	BIT(MAX77836_STATUS2_VIDRM_SHIFT)
 
@@ -177,9 +197,11 @@ enum max14577_muic_charger_type {
 #define CTRL3_JIGSET_SHIFT		0
 #define CTRL3_BOOTSET_SHIFT		2
 #define CTRL3_ADCDBSET_SHIFT		4
+#define CTRL3_WBTH_SHIFT		6
 #define CTRL3_JIGSET_MASK		(0x3 << CTRL3_JIGSET_SHIFT)
 #define CTRL3_BOOTSET_MASK		(0x3 << CTRL3_BOOTSET_SHIFT)
 #define CTRL3_ADCDBSET_MASK		(0x3 << CTRL3_ADCDBSET_SHIFT)
+#define CTRL3_WBTH_MASK			(0x3 << CTRL3_WBTH_SHIFT)
 
 /* Slave addr = 0x4A: Charger */
 enum max14577_charger_reg {
@@ -210,16 +232,20 @@ enum max14577_charger_reg {
 #define CDETCTRL1_CHGTYPMAN_SHIFT	1
 #define CDETCTRL1_DCDEN_SHIFT		2
 #define CDETCTRL1_DCD2SCT_SHIFT		3
-#define CDETCTRL1_DCHKTM_SHIFT		4
-#define CDETCTRL1_DBEXIT_SHIFT		5
+#define MAX14577_CDETCTRL1_DCHKTM_SHIFT	4
+#define MAX77836_CDETCTRL1_CDLY_SHIFT	4
+#define MAX14577_CDETCTRL1_DBEXIT_SHIFT	5
+#define MAX77836_CDETCTRL1_DCDCPL_SHIFT	5
 #define CDETCTRL1_DBIDLE_SHIFT		6
 #define CDETCTRL1_CDPDET_SHIFT		7
 #define CDETCTRL1_CHGDETEN_MASK		BIT(CDETCTRL1_CHGDETEN_SHIFT)
 #define CDETCTRL1_CHGTYPMAN_MASK	BIT(CDETCTRL1_CHGTYPMAN_SHIFT)
 #define CDETCTRL1_DCDEN_MASK		BIT(CDETCTRL1_DCDEN_SHIFT)
 #define CDETCTRL1_DCD2SCT_MASK		BIT(CDETCTRL1_DCD2SCT_SHIFT)
-#define CDETCTRL1_DCHKTM_MASK		BIT(CDETCTRL1_DCHKTM_SHIFT)
-#define CDETCTRL1_DBEXIT_MASK		BIT(CDETCTRL1_DBEXIT_SHIFT)
+#define MAX14577_CDETCTRL1_DCHKTM_MASK	BIT(MAX14577_CDETCTRL1_DCHKTM_SHIFT)
+#define MAX77836_CDETCTRL1_CDDLY_MASK	BIT(MAX77836_CDETCTRL1_CDDLY_SHIFT)
+#define MAX14577_CDETCTRL1_DBEXIT_MASK	BIT(MAX14577_CDETCTRL1_DBEXIT_SHIFT)
+#define MAX77836_CDETCTRL1_DCDCPL_MASK	BIT(MAX77836_CDETCTRL1_DCDCPL_SHIFT)
 #define CDETCTRL1_DBIDLE_MASK		BIT(CDETCTRL1_DBIDLE_SHIFT)
 #define CDETCTRL1_CDPDET_MASK		BIT(CDETCTRL1_CDPDET_SHIFT)
 
-- 
1.9.1

