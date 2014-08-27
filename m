Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102AbaH0PU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:20:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42766 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaH0PUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:20:25 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d9-53fdf737e054
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
Subject: [PATCH v4 1/8] mfd: max14577: Add defines for MAX77836 charger
Date: Wed, 27 Aug 2014 17:20:07 +0200
Message-id: <1409152814-17302-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7rm3/8GG3TuV7XYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFl8
	7j3CaLH2yF12i6XXLzJZTJi+lsWide8RdovT3awWp3eXOAh7rJm3htHjcl8vk8fOWXfZPVYu
	/8LmsXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5AK4orhsUlJzMstSi/TtErgypn44yFLw
	Vb1i4o/prA2Mh5S6GDk5JARMJL4c+cQIYYtJXLi3nq2LkYtDSGApo8TTQ6tYIZw+JollvdNZ
	QarYBIwlNi9fwgZiiwgsYJK4uC4XxGYWOMMsMXU1B4gtLOAucePxPBYQm0VAVeLVpVnsIDYv
	UPzFzZlsENvkJE4emww2k1PAQ+Jl7wWmLkYOoGXuEnfn8U9g5F3AyLCKUTS1NLmgOCk910iv
	ODG3uDQvXS85P3cTIyTov+5gXHrM6hCjAAejEg+vwuk/wUKsiWXFlbmHGCU4mJVEeMsO/A0W
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLig6EKNidCsuPiZsasahQVnXni82Dh/5sNF11PuFy4Q
	XbcsxJLX6+7WtkVr7aY1htpwzyh5yPrk1ZmfaiWT/zL5MG89r23Hfy9gV5h5qbhL2fX1kryr
	SmU3/q26+X8h14yejVJM+yZOY2AsU+pmSEr2bQj/I6685tR3zuV9HXv8ZVra4qacjldiKc5I
	NNRiLipOBAAUcyz4WAIAAA==
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

