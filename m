Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3IIQED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:04:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3IIQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 3/4] ARM: shmobile: r8a7790: add CPUFreq clock support
Date: Mon,  9 Sep 2013 18:03:55 +0200
Message-Id: <1378742636-11215-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:RhO8eMf7uzPJZWPfsLsduyJh3IDR4rayS7MC+KXkZBq
 OSw4WqYxuRWHDtbv0WWwjeyQA48Yxp8uV3arH4GZJW3DtxgTES
 anQHEd1pRf8Hf+5kctxn1ImVWMqOlwkV+JBrYmqYNqL8e5p4Q9
 Gf3b6NIDp6DuBmqrCMQHewiBTdAnHoeCwux0Pta4+KNmwTb8gp
 EtHsk59jerCDUQJL5RZPjguTnXaJe/fu4MrJ/QiEnQywSfUfcf
 hwQN5/4jOewikfujlejjI6LEn2lkHEjl7YvePLuvVszooFZkek
 jHZRP2hUNlSzggOSjcKfxnNeLwthtYTxWT/ymk3til+vwxZLZr
 6J3z1HqYOGR7R4Ewn5uIoMKgjHhHvFnBZMpr3mzUoHwq2LBmRA
 qP84l5RTUL4ag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Z clock on r8a7790, driving the four SoC's CA15 cores,
and its parent - PLL0. This is required for CPUFreq support on this SoC.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/mach-shmobile/Kconfig         |    2 +
 arch/arm/mach-shmobile/clock-r8a7790.c |  150 ++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 1f94c31..b9422f2 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -100,6 +100,8 @@ config ARCH_R8A7790
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index 8e5e90b..3ef043e 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -54,9 +54,12 @@
 #define SMSTPCR8 0xe6150990
 #define SMSTPCR9 0xe6150994
 
+#define FRQCRB		0xE6150004
 #define SDCKCR		0xE6150074
 #define SD2CKCR		0xE6150078
 #define SD3CKCR		0xE615007C
+#define FRQCRC		0xE61500E0
+#define PLLECR		0xE61500D0
 #define MMC0CKCR	0xE6150240
 #define MMC1CKCR	0xE6150244
 #define SSPCKCR		0xE6150248
@@ -85,6 +88,7 @@ static struct clk main_clk = {
  * clock ratio of these clock will be updated
  * on r8a7790_clock_init()
  */
+SH_FIXED_RATIO_CLK_SET(pll0_clk,		main_clk,	1, 1);
 SH_FIXED_RATIO_CLK_SET(pll1_clk,		main_clk,	1, 1);
 SH_FIXED_RATIO_CLK_SET(pll3_clk,		main_clk,	1, 1);
 SH_FIXED_RATIO_CLK_SET(lb_clk,			pll1_clk,	1, 1);
@@ -113,15 +117,155 @@ SH_FIXED_RATIO_CLK_SET(zb3d2_clk,		pll3_clk,	1, 8);
 SH_FIXED_RATIO_CLK_SET(ddr_clk,			pll3_clk,	1, 8);
 SH_FIXED_RATIO_CLK_SET(mp_clk,			pll1_div2_clk,	1, 15);
 
+/* Locking not needed yet, only one clock is using FRQCR[BC] divisors so far */
+static atomic_t frqcr_lock;
+#define CPG_MAP(o) ((o) - CPG_BASE + cpg_mapping.base)
+
+/* Several clocks need to access FRQCRB, have to lock */
+static bool frqcr_kick_check(struct clk *clk)
+{
+	return !(ioread32(CPG_MAP(FRQCRB)) & BIT(31));
+}
+
+static int frqcr_kick_do(struct clk *clk)
+{
+	int i;
+
+	/* set KICK bit in FRQCRB to update hardware setting, check success */
+	iowrite32(ioread32(CPG_MAP(FRQCRB)) | BIT(31), CPG_MAP(FRQCRB));
+	for (i = 1000; i; i--)
+		if (ioread32(CPG_MAP(FRQCRB)) & BIT(31))
+			cpu_relax();
+		else
+			return 0;
+
+	return -ETIMEDOUT;
+}
+
+static int zclk_set_rate(struct clk *clk, unsigned long rate)
+{
+	void __iomem *frqcrc;
+	int ret;
+	unsigned long step, p_rate;
+	u32 val;
+
+	if (!clk->parent || !__clk_get(clk->parent))
+		return -ENODEV;
+
+	if (!atomic_inc_and_test(&frqcr_lock) || !frqcr_kick_check(clk)) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	/*
+	 * Users are supposed to first call clk_set_rate() only with
+	 * clk_round_rate() results. So, we don't fix wrong rates here, but
+	 * guard against them anyway
+	 */
+
+	p_rate = clk_get_rate(clk->parent);
+	if (rate == p_rate) {
+		val = 0;
+	} else {
+		step = DIV_ROUND_CLOSEST(p_rate, 32);
+
+		if (rate > p_rate || rate < step) {
+			ret = -EINVAL;
+			goto done;
+		}
+
+		val = 32 - rate / step;
+	}
+
+	frqcrc = clk->mapped_reg + (FRQCRC - (u32)clk->enable_reg);
+
+	iowrite32((ioread32(frqcrc) & ~(clk->div_mask << clk->enable_bit)) |
+		  (val << clk->enable_bit), frqcrc);
+
+	ret = frqcr_kick_do(clk);
+
+done:
+	atomic_dec(&frqcr_lock);
+	__clk_put(clk->parent);
+	return ret;
+}
+
+static long zclk_round_rate(struct clk *clk, unsigned long rate)
+{
+	/*
+	 * theoretical rate = parent rate * multiplier / 32,
+	 * where 1 <= multiplier <= 32. Therefore we should do
+	 * multiplier = rate * 32 / parent rate
+	 * rounded rate = parent rate * multiplier / 32.
+	 * However, multiplication before division won't fit in 32 bits, so
+	 * we sacrifice some precision by first dividing and then multiplying.
+	 * To find the nearest divisor we calculate both and pick up the best
+	 * one. This avoids 64-bit arithmetics.
+	 */
+	unsigned long step, mul_min, mul_max, rate_min, rate_max;
+
+	rate_max = clk_get_rate(clk->parent);
+
+	/* output freq <= parent */
+	if (rate >= rate_max)
+		return rate_max;
+
+	step = DIV_ROUND_CLOSEST(rate_max, 32);
+	/* output freq >= parent / 32 */
+	if (step >= rate)
+		return step;
+
+	mul_min = rate / step;
+	mul_max = DIV_ROUND_UP(rate, step);
+	rate_min = step * mul_min;
+	if (mul_max == mul_min)
+		return rate_min;
+
+	rate_max = step * mul_max;
+
+	if (rate_max - rate <  rate - rate_min)
+		return rate_max;
+
+	return rate_min;
+}
+
+static unsigned long zclk_recalc(struct clk *clk)
+{
+	void __iomem *frqcrc = FRQCRC - (u32)clk->enable_reg + clk->mapped_reg;
+	unsigned int max = clk->div_mask + 1;
+	unsigned long val = ((ioread32(frqcrc) >> clk->enable_bit) &
+			     clk->div_mask);
+
+	return DIV_ROUND_CLOSEST(clk_get_rate(clk->parent), max) *
+		(max - val);
+}
+
+static struct sh_clk_ops zclk_ops = {
+	.recalc = zclk_recalc,
+	.set_rate = zclk_set_rate,
+	.round_rate = zclk_round_rate,
+};
+
+static struct clk z_clk = {
+	.parent = &pll0_clk,
+	.div_mask = 0x1f,
+	.enable_bit = 8,
+	/* We'll need to access FRQCRB and FRQCRC */
+	.enable_reg = (void __iomem *)FRQCRB,
+	.ops = &zclk_ops,
+};
+
 static struct clk *main_clks[] = {
 	&extal_clk,
 	&extal_div2_clk,
 	&main_clk,
+	&pll0_clk,
 	&pll1_clk,
 	&pll1_div2_clk,
 	&pll3_clk,
 	&lb_clk,
 	&qspi_clk,
+	&z_clk,
 	&zg_clk,
 	&zx_clk,
 	&zs_clk,
@@ -249,6 +393,9 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("qspi",		&qspi_clk),
 	CLKDEV_CON_ID("cp",		&cp_clk),
 
+	/* CPU clock */
+	CLKDEV_DEV_ID("cpufreq-cpu0",	&z_clk),
+
 	/* DIV4 */
 	CLKDEV_CON_ID("sdh",		&div4_clks[DIV4_SDH]),
 
@@ -291,6 +438,7 @@ static struct clk_lookup lookups[] = {
 #define R8A7790_CLOCK_ROOT(e, m, p0, p1, p30, p31)		\
 	extal_clk.rate	= e * 1000 * 1000;			\
 	main_clk.parent	= m;					\
+	SH_CLK_SET_RATIO(&pll0_clk_ratio, p0 / 2, 1);		\
 	SH_CLK_SET_RATIO(&pll1_clk_ratio, p1 / 2, 1);		\
 	if (mode & MD(19))					\
 		SH_CLK_SET_RATIO(&pll3_clk_ratio, p31, 1);	\
@@ -303,6 +451,8 @@ void __init r8a7790_clock_init(void)
 	u32 mode = r8a7790_read_mode_pins();
 	int k, ret = 0;
 
+	atomic_set(&frqcr_lock, -1);
+
 	switch (mode & (MD(14) | MD(13))) {
 	case 0:
 		R8A7790_CLOCK_ROOT(15, &extal_clk, 172, 208, 106, 88);
-- 
1.7.2.5

