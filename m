Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3JIGbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:31:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3JIGar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:30:47 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-66-5254f7fdd18a
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 3/5] thermal: exynos: Provide initial setting for TMU's test
 MUX address at Exynos4412
Date: Wed, 09 Oct 2013 08:29:52 +0200
Message-id: <1381300194-13134-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd2/30OCDO5/ELRouBpisXHGelaL
	+UfOsVqs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVsFmdO
	X2K1ePKwj81i/YzXLA78Hov3vGTyWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQC2KC6blNSc
	zLLUIn27BK6MNd1HmAo+q1Ss/zmDpYFxunwXIweHhICJxKQXml2MnECmmMSFe+vZuhi5OIQE
	pjNKfFrQzgrhdDFJnFz+iB2kik1AT+Lz3adMILaIQIbEqUuzmUCKmAX+Mktcn3aMBSQhLJAt
	MeHJAWYQm0VAVWL60utgDbwCbhKNFw+yQayTl3h6vw/M5hRwlzh45x07xLZmRolHFzexTGDk
	XcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOFyfSe1gXNlgcYhRgINRiYf3AX9IkBBr
	YllxZe4hRgkOZiUR3ryFQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtS
	i2CyTBycUg2MsTUZS1VYt0xZ85jb/1mQ8XZne8E5f7s5HA01NX3tyh7f/3dD+99FxU0KC3OF
	13088tajaybrrkfWd0IjtkU9s7JaFlp7WHze2xXZzC5J/WmVzLqrf3B/2cAjX22VYMCmFTj7
	1ufYae7hYrOuFtxwymf9PXHT2VMz46TeX2C7Pe3mVzaXtVtmKLEUZyQaajEXFScCABZ8EnpT	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal: exynos: Add
missing definations and code cleanup") has removed setting of test MUX address
value at TMU configuration setting.

This field is not present on Exynos4210 and Exynos5 SoCs. However on Exynos4412
SoC it is required to set this field after reset because without it TMU shows
maximal available temperature, which causes immediate platform shutdown.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes for v2:
- Define test_mux and test_mux_addr_shift to not use direct register access
- Remove pdata->type == SOC_ARCH_EXYNOS4412 check at exynos_tmu_control() and
  use only generic code

 drivers/thermal/samsung/exynos_tmu.c      |    3 +++
 drivers/thermal/samsung/exynos_tmu.h      |    4 ++++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 1312b34..32f38b9 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -317,6 +317,9 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 
 	con = readl(data->base + reg->tmu_ctrl);
 
+	if (pdata->test_mux)
+		con |= (pdata->test_mux << reg->test_mux_addr_shift);
+
 	if (pdata->reference_voltage) {
 		con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
 		con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index b42ece4..3fb6554 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -85,6 +85,7 @@ enum soc_type {
  * @triminfo_reload_shift: shift of triminfo reload enable bit in triminfo_ctrl
 	reg.
  * @tmu_ctrl: TMU main controller register.
+ * @test_mux_addr_shift: shift bits of test mux address.
  * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl register.
  * @buf_vref_sel_mask: mask bits of reference voltage in tmu_ctrl register.
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
@@ -151,6 +152,7 @@ struct exynos_tmu_registers {
 	u32	triminfo_reload_shift;
 
 	u32	tmu_ctrl;
+	u32     test_mux_addr_shift;
 	u32	buf_vref_sel_shift;
 	u32	buf_vref_sel_mask;
 	u32	therm_trip_mode_shift;
@@ -258,6 +260,7 @@ struct exynos_tmu_registers {
  * @first_point_trim: temp value of the first point trimming
  * @second_point_trim: temp value of the second point trimming
  * @default_temp_offset: default temperature offset in case of no trimming
+ * @test_mux; information if SoC supports test MUX
  * @cal_type: calibration type for temperature
  * @cal_mode: calibration mode for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
@@ -287,6 +290,7 @@ struct exynos_tmu_platform_data {
 	u8 first_point_trim;
 	u8 second_point_trim;
 	u8 default_temp_offset;
+	u8 test_mux;
 
 	enum calibration_type cal_type;
 	enum calibration_mode cal_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index d8de5c1..073c292 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -98,6 +98,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
 	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
+	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
 	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
@@ -174,6 +175,7 @@ struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
 		{
 			EXYNOS4412_TMU_DATA,
 			.type = SOC_ARCH_EXYNOS4412,
+			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
 		},
 	},
 	.tmu_count = 1,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index b130b1e..a1ea19d 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -95,6 +95,10 @@
 
 #define EXYNOS_MAX_TRIGGER_PER_REG	4
 
+/* Exynos4412 specific */
+#define EXYNOS4412_MUX_ADDR_VALUE          6
+#define EXYNOS4412_MUX_ADDR_SHIFT          20
+
 /*exynos5440 specific registers*/
 #define EXYNOS5440_TMU_S0_7_TRIM		0x000
 #define EXYNOS5440_TMU_S0_7_CTRL		0x020
-- 
1.7.10.4

