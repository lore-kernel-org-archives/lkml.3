Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab3E1PrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:47:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38513 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934500Ab3E1PrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:47:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Qo9ZXTJNXTql1aEe7GpgqbGTfbQAb8Dw=
Date: Tue, 28 May 2013 11:46:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/10] clk: mvebu: add Armada 370 SoC-centric clock init
Message-ID: <20130528154656.GV31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1368234490-31416-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368234490-31416-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian, Thomas,

On Sat, May 11, 2013 at 03:08:05AM +0200, Sebastian Hesselbarth wrote:
> This is moving core clock and clock gating init for Armada 370 to
> its own file and adds a Kconfig option. Also init functions are added
> and declared so they get called on of_clk_init.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/mvebu/Kconfig      |    5 ++
>  drivers/clk/mvebu/Makefile     |    1 +
>  drivers/clk/mvebu/armada-370.c |  176 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 182 insertions(+)
>  create mode 100644 drivers/clk/mvebu/armada-370.c

Here's the revised version after rebasing onto mvebu/pcie:

---->8------

commit 1bc2c25c3cacce0965d38f3ae2ab7571dffa1b6e
Author: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date:   Sat May 11 03:08:05 2013 +0200

    clk: mvebu: add Armada 370 SoC-centric clock init
    
    This is moving core clock and clock gating init for Armada 370 to
    its own file and adds a Kconfig option. Also init functions are added
    and declared so they get called on of_clk_init.
    
    Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index 211695c..1daf61e 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -10,6 +10,11 @@ config MVEBU_CLK_GATING
 config MVEBU_CLK_COMMON
 	bool
 
+config ARMADA_370_CLK
+	bool
+	select MVEBU_CLK_COMMON
+	select MVEBU_CLK_CPU
+
 config DOVE_CLK
 	bool
 	select MVEBU_CLK_COMMON
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index 97d1ab0..367b72c 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -3,5 +3,6 @@ obj-$(CONFIG_MVEBU_CLK_CORE) 	+= clk.o clk-core.o
 obj-$(CONFIG_MVEBU_CLK_CPU) 	+= clk-cpu.o
 obj-$(CONFIG_MVEBU_CLK_GATING) 	+= clk-gating-ctrl.o
 
+obj-$(CONFIG_ARMADA_370_CLK)	+= armada-370.o
 obj-$(CONFIG_DOVE_CLK)		+= dove.o
 obj-$(CONFIG_KIRKWOOD_CLK)	+= kirkwood.o
diff --git a/drivers/clk/mvebu/armada-370.c b/drivers/clk/mvebu/armada-370.c
new file mode 100644
index 0000000..079960e
--- /dev/null
+++ b/drivers/clk/mvebu/armada-370.c
@@ -0,0 +1,176 @@
+/*
+ * Marvell Armada 370 SoC clocks
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ * Andrew Lunn <andrew@lunn.ch>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include "common.h"
+
+/*
+ * Core Clocks
+ */
+
+#define SARL				0	/* Low part [0:31] */
+#define	 SARL_A370_PCLK_FREQ_OPT	11
+#define	 SARL_A370_PCLK_FREQ_OPT_MASK	0xF
+#define	 SARL_A370_FAB_FREQ_OPT		15
+#define	 SARL_A370_FAB_FREQ_OPT_MASK	0x1F
+#define	 SARL_A370_TCLK_FREQ_OPT	20
+#define	 SARL_A370_TCLK_FREQ_OPT_MASK	0x1
+
+enum { A370_CPU_TO_NBCLK, A370_CPU_TO_HCLK, A370_CPU_TO_DRAMCLK };
+
+static const struct coreclk_ratio __initconst a370_coreclk_ratios[] = {
+	{ .id = A370_CPU_TO_NBCLK, .name = "nbclk" },
+	{ .id = A370_CPU_TO_HCLK, .name = "hclk" },
+	{ .id = A370_CPU_TO_DRAMCLK, .name = "dramclk" },
+};
+
+static const u32 __initconst a370_tclk_freqs[] = {
+	16600000,
+	20000000,
+};
+
+static u32 __init a370_get_tclk_freq(void __iomem *sar)
+{
+	u8 tclk_freq_select = 0;
+
+	tclk_freq_select = ((readl(sar) >> SARL_A370_TCLK_FREQ_OPT) &
+			    SARL_A370_TCLK_FREQ_OPT_MASK);
+	return a370_tclk_freqs[tclk_freq_select];
+}
+
+static const u32 __initconst a370_cpu_freqs[] = {
+	400000000,
+	533000000,
+	667000000,
+	800000000,
+	1000000000,
+	1067000000,
+	1200000000,
+};
+
+static u32 __init a370_get_cpu_freq(void __iomem *sar)
+{
+	u32 cpu_freq;
+	u8 cpu_freq_select = 0;
+
+	cpu_freq_select = ((readl(sar) >> SARL_A370_PCLK_FREQ_OPT) &
+			   SARL_A370_PCLK_FREQ_OPT_MASK);
+	if (cpu_freq_select >= ARRAY_SIZE(a370_cpu_freqs)) {
+		pr_err("CPU freq select unsupported %d\n", cpu_freq_select);
+		cpu_freq = 0;
+	} else
+		cpu_freq = a370_cpu_freqs[cpu_freq_select];
+
+	return cpu_freq;
+}
+
+static const int __initconst a370_nbclk_ratios[32][2] = {
+	{0, 1}, {1, 2}, {2, 2}, {2, 2},
+	{1, 2}, {1, 2}, {1, 1}, {2, 3},
+	{0, 1}, {1, 2}, {2, 4}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {2, 2},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{2, 3}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static const int __initconst a370_hclk_ratios[32][2] = {
+	{0, 1}, {1, 2}, {2, 6}, {2, 3},
+	{1, 3}, {1, 4}, {1, 2}, {2, 6},
+	{0, 1}, {1, 6}, {2, 10}, {0, 1},
+	{1, 4}, {0, 1}, {0, 1}, {2, 5},
+	{0, 1}, {0, 1}, {0, 1}, {1, 2},
+	{2, 6}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static const int __initconst a370_dramclk_ratios[32][2] = {
+	{0, 1}, {1, 2}, {2, 3}, {2, 3},
+	{1, 3}, {1, 2}, {1, 2}, {2, 6},
+	{0, 1}, {1, 3}, {2, 5}, {0, 1},
+	{1, 4}, {0, 1}, {0, 1}, {2, 5},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{2, 3}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static void __init a370_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	u32 opt = ((readl(sar) >> SARL_A370_FAB_FREQ_OPT) &
+		SARL_A370_FAB_FREQ_OPT_MASK);
+
+	switch (id) {
+	case A370_CPU_TO_NBCLK:
+		*mult = a370_nbclk_ratios[opt][0];
+		*div = a370_nbclk_ratios[opt][1];
+		break;
+	case A370_CPU_TO_HCLK:
+		*mult = a370_hclk_ratios[opt][0];
+		*div = a370_hclk_ratios[opt][1];
+		break;
+	case A370_CPU_TO_DRAMCLK:
+		*mult = a370_dramclk_ratios[opt][0];
+		*div = a370_dramclk_ratios[opt][1];
+		break;
+	}
+}
+
+static const struct coreclk_soc_desc a370_coreclks = {
+	.get_tclk_freq = a370_get_tclk_freq,
+	.get_cpu_freq = a370_get_cpu_freq,
+	.get_clk_ratio = a370_get_clk_ratio,
+	.ratios = a370_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(a370_coreclk_ratios),
+};
+
+static void __init a370_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &a370_coreclks);
+}
+CLK_OF_DECLARE(a370_core_clk, "marvell,armada-370-core-clock",
+	       a370_coreclk_init);
+
+/*
+ * Clock Gating Control
+ */
+
+static const struct clk_gating_soc_desc __initconst a370_gating_desc[] = {
+	{ "audio", NULL, 0, 0 },
+	{ "pex0_en", NULL, 1, 0 },
+	{ "pex1_en", NULL,  2, 0 },
+	{ "ge1", NULL, 3, 0 },
+	{ "ge0", NULL, 4, 0 },
+	{ "pex0", "pex0_en", 5, 0 },
+	{ "pex1", "pex1_en", 9, 0 },
+	{ "sata0", NULL, 15, 0 },
+	{ "sdio", NULL, 17, 0 },
+	{ "tdm", NULL, 25, 0 },
+	{ "ddr", NULL, 28, CLK_IGNORE_UNUSED },
+	{ "sata1", NULL, 30, 0 },
+	{ }
+};
+
+static void __init a370_clk_gating_init(struct device_node *np)
+{
+	mvebu_clk_gating_setup(np, a370_gating_desc);
+}
+CLK_OF_DECLARE(a370_clk_gating, "marvell,armada-370-gating-clock",
+	       a370_clk_gating_init);
