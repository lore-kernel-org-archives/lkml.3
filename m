Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab3HGKXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:23:08 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56278 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab3HGKXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:23:02 -0400
Date: Wed, 7 Aug 2013 12:21:53 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 25/26] drivers/clk: sta2x11 common clock framework
 implementation
Message-ID: <fb33ff2d9152d80f45c079da626551ac8df2c8b2.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was submitted as RFC on June 20th 2012 (see
https://lkml.org/lkml/2012/6/20/779 for more details) and
resubmitted on March 8th 2013 (see
https://lkml.org/lkml/2013/3/8/245 for more details).

This is a new version which:

* Gets rid of the platform bus notifier replacing it with a platform
driver for the "virtual" sta2x11-clock-regs" device, which is created
when three of the sta2x11 basic platform devices (sta2x11-sctl,
sta2x11-apbreg and sta2x11-apb-soc-regs) have been probed.

* Adds some more clocks (gpios, sdio/mmc, spi, i2c, dma). Clocks still
have to be improved because not all the details have been modeled (for
instance mmc clocks are actually muxed clocks, not fixed factor).

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/Kconfig                    |    1 +
 drivers/clk/Makefile                |    1 +
 drivers/clk/sta2x11/Makefile        |    1 +
 drivers/clk/sta2x11/clk-audio-pll.c |  149 ++++++
 drivers/clk/sta2x11/clk-soc-pll.c   |   95 ++++
 drivers/clk/sta2x11/clk.c           |  865 +++++++++++++++++++++++++++++++++++
 drivers/clk/sta2x11/clk.h           |   88 ++++
 7 files changed, 1200 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/sta2x11/Makefile
 create mode 100644 drivers/clk/sta2x11/clk-audio-pll.c
 create mode 100644 drivers/clk/sta2x11/clk-soc-pll.c
 create mode 100644 drivers/clk/sta2x11/clk.c
 create mode 100644 drivers/clk/sta2x11/clk.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ae05df92..fed3507 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -551,6 +551,7 @@ config STA2X11
 	depends on X86_32_NON_STANDARD && PCI
 	select X86_DEV_DMA_OPS
 	select X86_DMA_REMAP
+	select COMMON_CLK
 	select SWIOTLB
 	select MFD_STA2X11
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 4038c2b..d2b7693 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
 
 obj-$(CONFIG_X86)		+= x86/
+obj-$(CONFIG_STA2X11)		+= sta2x11/
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) += clk-axi-clkgen.o
diff --git a/drivers/clk/sta2x11/Makefile b/drivers/clk/sta2x11/Makefile
new file mode 100644
index 0000000..60c319a
--- /dev/null
+++ b/drivers/clk/sta2x11/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_STA2X11) += clk.o clk-soc-pll.o clk-audio-pll.o
diff --git a/drivers/clk/sta2x11/clk-audio-pll.c b/drivers/clk/sta2x11/clk-audio-pll.c
new file mode 100644
index 0000000..8ed28a2
--- /dev/null
+++ b/drivers/clk/sta2x11/clk-audio-pll.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright ST Microelectronics 2012
+ * Author: Davide Ciminaghi <ciminaghi@gnudd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Common clock api implementation for sta2x11
+ * audio-pll clock type implementation
+ */
+/* #define DEBUG */
+
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/clk-provider.h>
+#include <asm/div64.h>
+#include <asm/sta2x11.h>
+
+#include "clk.h"
+
+/**
+ * struct clk_audio_pll - sta2x11 audio pll clock
+ * @hw: clk_hw for the pll
+ *
+ * Soc pll
+ */
+struct clk_audio_pll {
+	struct clk_hw hw;
+	void __iomem *base;
+	spinlock_t *lock;
+};
+
+#define to_clk_audio_pll(_hw) container_of(_hw, struct clk_audio_pll, hw)
+
+static unsigned long clk_audio_pll_recalc_rate(struct clk_hw *hw,
+					       unsigned long parent_rate)
+{
+	struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
+	u32 scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
+	u32 scpllfctrl = readl(audio_pll->base + SCTL_SCPLLFCTRL);
+	u16 scresfract = readl(audio_pll->base + SCTL_SCRESFRACT);
+	u64 fvco, inff, ndiv, fract, idf, phi, odf;
+	int frac_control, dither_disable;
+
+	inff = parent_rate;
+	frac_control = scpllctl & SCTL_SCPLLCTL_FRAC_CONTROL;
+	ndiv = (scpllfctrl >> SCTL_SCPLLFCTRL_AUDIO_PLL_NDIV_SHIFT) &
+		SCTL_SCPLLFCTRL_AUDIO_PLL_NDIV_MASK;
+	fract = scresfract & SCTL_SCRESFRACT_MASK ;
+	idf = (scpllfctrl >> SCTL_SCPLLFCTRL_AUDIO_PLL_IDF_SHIFT) &
+		SCTL_SCPLLFCTRL_AUDIO_PLL_IDF_MASK;
+	idf = idf ? idf : 1;
+	odf = (scpllfctrl >> SCTL_SCPLLFCTRL_AUDIO_PLL_ODF_SHIFT) &
+		SCTL_SCPLLFCTRL_AUDIO_PLL_ODF_MASK;
+	odf = odf > 5 ? 32 : (1<<odf);
+	dither_disable = ((scpllfctrl >> SCTL_SCPLLFCTRL_DITHER_DISABLE_SHIFT) &
+			  SCTL_SCPLLFCTRL_DITHER_DISABLE_MASK) ? 0 : 1;
+
+	pr_debug("%s : refclk = %llu, scpllctl = 0x%08x\n", __func__,
+		 inff, scpllctl);
+	pr_debug("%s : scpllfctrl = 0x%08x, scresfract = 0x%08x\n",
+		 __func__, scpllfctrl, scresfract);
+	pr_debug("%s : ndiv = %llu, frac_control = %d, dither_disable = %d\n",
+		 __func__, ndiv, frac_control, dither_disable);
+	pr_debug("%s: fract = %llu, idf = %llu, odf = %llu\n",
+		 __func__, fract, idf, odf);
+
+	fvco = frac_control ?
+		div_u64((inff*2*((ndiv<<17)+(fract<<1)+dither_disable ? 0 : 1)),
+			(idf<<17)) :
+		div_u64((inff * 2 * ndiv), idf);
+	phi = div_u64(fvco, (odf * 2));
+
+	pr_debug("%s: fvco = %llu Hz, phi = %llu Hz\n", __func__, fvco, phi);
+
+	return phi;
+}
+
+static int clk_audio_pll_enable(struct clk_hw *hw)
+{
+	struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
+	u32 scpllctl;
+	unsigned long flags;
+	spin_lock_irqsave(audio_pll->lock, flags);
+	scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
+	scpllctl &= ~SCTL_SCPLLCTL_AUDIO_PLL_PD;
+	writel(scpllctl, audio_pll->base + SCTL_SCPLLCTL);
+	spin_unlock_irqrestore(audio_pll->lock, flags);
+	return 0;
+}
+
+static void clk_audio_pll_disable(struct clk_hw *hw)
+{
+	struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
+	u32 scpllctl;
+	unsigned long flags;
+	spin_lock_irqsave(audio_pll->lock, flags);
+	scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
+	scpllctl |= SCTL_SCPLLCTL_AUDIO_PLL_PD;
+	writel(scpllctl, audio_pll->base + SCTL_SCPLLCTL);
+	spin_unlock_irqrestore(audio_pll->lock, flags);
+}
+
+static const struct clk_ops clk_soc_pll_ops = {
+	.enable = clk_audio_pll_enable,
+	.disable = clk_audio_pll_disable,
+	.recalc_rate = clk_audio_pll_recalc_rate,
+};
+
+
+struct clk *register_sta2x11_clk_audio_pll(const char *name,
+					   const char *parent_name,
+					   void __iomem *base, spinlock_t *lock)
+{
+	struct clk_audio_pll *audio_pll;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	audio_pll = kzalloc(sizeof(*audio_pll), GFP_KERNEL);
+	if (!audio_pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_soc_pll_ops;
+	init.flags = 0;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	audio_pll->base = base;
+	audio_pll->lock = lock;
+	audio_pll->hw.init = &init;
+
+	clk = clk_register(NULL, &audio_pll->hw);
+	if (IS_ERR(clk))
+		kfree(audio_pll);
+
+	return clk;
+}
diff --git a/drivers/clk/sta2x11/clk-soc-pll.c b/drivers/clk/sta2x11/clk-soc-pll.c
new file mode 100644
index 0000000..8383bf9
--- /dev/null
+++ b/drivers/clk/sta2x11/clk-soc-pll.c
@@ -0,0 +1,95 @@
+/*
+ * Copyright ST Microelectronics 2012
+ * Author: Davide Ciminaghi <ciminaghi@gnudd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Common clock api implementation for sta2x11
+ * soc-pll clock type implementation
+ */
+/* #define DEBUG */
+
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <asm/sta2x11.h>
+
+#include "clk.h"
+
+/**
+ * struct clk_soc_pll - sta2x11 soc pll clock
+ * @hw: clk_hw for the pll
+ *
+ * Soc pll
+ */
+struct clk_soc_pll {
+	struct clk_hw hw;
+	void __iomem *base;
+	spinlock_t *lock;
+};
+
+#define to_clk_soc_pll(_hw) container_of(_hw, struct clk_soc_pll, hw)
+
+#define PLL1NMUL_MASK	0x7f
+#define PLL1NMUL_SHIFT	3
+
+static unsigned long clk_soc_pll_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct clk_soc_pll *soc_pll = to_clk_soc_pll(hw);
+	unsigned long out;
+	u32 scpllfctrl = readl(soc_pll->base + SCTL_SCPLLFCTRL);
+	u32 nmul = (scpllfctrl >> PLL1NMUL_SHIFT) & PLL1NMUL_MASK;
+	out = parent_rate * nmul;
+	pr_debug("%s : soc_pll->base = %p\n", __func__, soc_pll->base);
+	pr_debug("%s : scpllfctrl = 0x%08x\n", __func__, scpllfctrl);
+	pr_debug("%s : nmul = %d\n", __func__, nmul);
+	pr_debug("%s : calculated rate = %lu\n", __func__, out);
+	pr_debug("%s : parent_rate = %lu\n", __func__, parent_rate);
+	return out;
+}
+
+static const struct clk_ops clk_soc_pll_ops = {
+	.recalc_rate = clk_soc_pll_recalc_rate,
+};
+
+
+struct clk *register_sta2x11_clk_soc_pll(const char *name,
+					 const char *parent_name,
+					 void __iomem *base, spinlock_t *lock)
+{
+	struct clk_soc_pll *soc_pll;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	soc_pll = kzalloc(sizeof(*soc_pll), GFP_KERNEL);
+	if (!soc_pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_soc_pll_ops;
+	init.flags = 0;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	soc_pll->base = base;
+	soc_pll->lock = lock;
+	soc_pll->hw.init = &init;
+
+	clk = clk_register(NULL, &soc_pll->hw);
+	if (IS_ERR(clk))
+		kfree(soc_pll);
+
+	return clk;
+}
diff --git a/drivers/clk/sta2x11/clk.c b/drivers/clk/sta2x11/clk.c
new file mode 100644
index 0000000..24087a6
--- /dev/null
+++ b/drivers/clk/sta2x11/clk.c
@@ -0,0 +1,865 @@
+/*
+ * Copyright ST Microelectronics 2012
+ * Author: Davide Ciminaghi <ciminaghi@gnudd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Common clock api implementation for sta2x11
+ */
+/* #define DEBUG */
+
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/clkdev.h>
+#include <linux/pci-amba.h>
+#include <asm/sta2x11.h>
+
+#include "clk.h"
+
+#define STA2X11_MAX_CLK_NAME_LEN 60
+#define STA2X11_MAX_CLK_NPARENTS 8
+
+/*
+ * struct sta2x11_clk_data
+ * This structure is used to build the table listing all the
+ * clocks for a connext chip.
+ *
+ * @basename : basename of the clock (a .%d suffix will be added to
+ * deal with multiple connext instances).
+ * @type : sta2x11 clock type (see clk.h, enum sta2x11_clk_type)
+ * @reg_offset : the controlling register's offset for this clock
+ * @init : pointer to init function. When this pointer is not NULL, the
+ * pointed function is invoked before clock registration. This is used to
+ * fill the clock struct fields which are unknown at compile time (typically
+ * virtual addresses of controlling registers).
+ * @args : arguments needed for registration
+ */
+struct sta2x11_clk_data {
+	const char *basename;
+	int type;
+	unsigned int reg_offset;
+	void (*init)(struct sta2x11_clk_data *, struct sta2x11_instance_data *);
+	unsigned long flags;
+	union {
+		struct	{
+			const char *parent_name;
+			unsigned long rate;
+		} fixed_rate_root;
+		struct {
+			const char *parent_name;
+			unsigned int mult;
+			unsigned int div;
+		} fixed_factor;
+		struct {
+			const char **parent_names;
+			u8 num_parents;
+			void __iomem *reg;
+			u8 shift;
+			u8 width;
+			u8 clk_mux_flags;
+			spinlock_t *lock;
+		} mux;
+		struct {
+			const char *parent_name;
+			void __iomem *base;
+			spinlock_t *lock;
+		} soc_pll;
+		struct {
+			const char *parent_name;
+			void __iomem *base;
+			spinlock_t *lock;
+		} audio_pll;
+		struct {
+			const char *parent_name;
+			void __iomem *reg;
+			u8 shift;
+			u8 width;
+			spinlock_t *lock;
+			struct clk_div_table *div_tab;
+			u8 tab_divider_flags;
+		} tab_divider;
+	} args;
+};
+
+/* Various helper macros used to setup the clock table */
+
+/*
+ * Use this macro to declare a fixed clock with no parents
+ *
+ * @name : clock name
+ * @f : clock frequency
+ */
+#define DECLARE_FIXED_RATE_ROOT_CLK(n, f)				\
+	[n] = {								\
+		.basename = #n,						\
+		.type = fixed_rate_root,				\
+		.flags = CLK_IS_ROOT,					\
+		.args = {						\
+			.fixed_rate_root = {				\
+				.parent_name = NULL,			\
+				.rate = f,				\
+			}						\
+		}							\
+	}
+
+/*
+ * Use this macro to declare a fixed factor clock
+ *
+ * @n : clock name
+ * @parent_name = name of parent clock
+ * @flags = clock flags
+ * @mult = const mult factor
+ * @div = const div factor
+ */
+#define DECLARE_FIXED_FACTOR_CLK(n, pn, f, m, d)			\
+	[n] = {								\
+		.basename = #n,						\
+		.type = fixed_factor,					\
+		.reg_offset = 0,					\
+		.flags = f,						\
+		.args = {						\
+			.fixed_factor = {				\
+				.parent_name = #pn,			\
+				.mult = m,				\
+				.div = d,				\
+			}						\
+		}							\
+	}
+
+/*
+ * Use this macro to declare a mux clock
+ *
+ * @name : clock name
+ * @reg_offset : offset of controlling register
+ * @parent_names : names of parents
+ * @init : pointer to init function
+ * @flags : clock flags
+ * @shift : bitmask shift
+ * @width : bitmask width
+ * @clk_mux_flags : flags of clock mux
+ */
+#define DECLARE_MUX_CLK(n, ro, pn, in, f, s, w, cmf)			\
+	[n] = {								\
+		.basename = #n,						\
+		.type = mux,						\
+		.flags = f,						\
+		.reg_offset = ro,					\
+		.init = in,						\
+		.args = {						\
+			.mux = {					\
+				.parent_names = pn,			\
+				.num_parents = ARRAY_SIZE(pn),		\
+				.shift = s,				\
+				.width = w,				\
+				.clk_mux_flags = cmf,			\
+			},						\
+		}							\
+	}
+
+/*
+ * Use this macro to declare a pll clock
+ *
+ * @n : clock name
+ * @parent_name : name of parent
+ * @type : clock type
+ */
+#ifndef xcat
+#define xcat(a, b) a##b
+#endif
+
+#define DECLARE_PLL_CLK(n, pn, t)			\
+	[n] = {						\
+		.basename = #n,				\
+		.type = t,				\
+		.init = xcat(t, _init),			\
+		.args = {				\
+			.t = {				\
+				.parent_name = #pn,	\
+			},				\
+		}					\
+	}
+
+/*
+ * Use this macro to declare a soc-pll clock
+ *
+ * @n : clock name
+ * @parent_name : name of parent
+ */
+#define DECLARE_SOC_PLL_CLK(n, pn)   DECLARE_PLL_CLK(n, pn, soc_pll)
+
+/*
+ * Use this macro to declare an audio-pll clock
+ *
+ * @n : clock name
+ * @parent_name : name of parent
+ */
+#define DECLARE_AUDIO_PLL_CLK(n, pn)  DECLARE_PLL_CLK(n, pn, audio_pll)
+
+/*
+ * Use this macro to declare a tab-divider clock
+ *
+ * @n : clock name
+ * @ro : register offset
+ * @pn : parent name
+ * @in : init function
+ * @f : clock flags
+ * @s : controlling bitmask shift
+ * @w : controlling bitmask width
+ * @tdf : tab divider clock specific flags
+ */
+#define DECLARE_TAB_DIVIDER_CLK(n, ro, pn, in, f, s, w, tab, tdf)	\
+	[n] = {								\
+		.basename = #n,						\
+		.type = tab_divider,					\
+		.flags = f,						\
+		.reg_offset = ro,					\
+		.init = in,						\
+		.args = {						\
+			.tab_divider = {				\
+				.parent_name = #pn,			\
+				.shift = s,				\
+				.width = w,				\
+				.div_tab = tab,				\
+				.tab_divider_flags = tdf,		\
+			},						\
+		}							\
+	}
+
+/* Arrays with parents */
+
+static const char *soc_phi_parents[] = {
+	"soc_phia.%d",
+	"soc_phib.%d",
+};
+
+static const char *audio_pll_sdmmc_parents[] = {
+	"audio_pll_phi.%d",
+	"eaudio_pll_phi_div2.%d",
+};
+
+static const char *audio_pll_msp_parents[] = {
+	"audio_pll_phi_div4.%d",
+	"audio_pll_phi_div10.%d",
+};
+
+static const char *audio_pll_sarac_parents[] = {
+	"audio_pll_phi_div4.%d",
+	"audio_pll_phi.%d",
+};
+
+static const char *hclk_pre_parents[] = {
+	"soc_phi_byp_div3.%d",
+	"soc_phi_byp_div4.%d",
+	"soc_phi_byp_div6.%d",
+	"soc_phi_byp_div3.%d",
+};
+
+static const char *hclk_parents[] = {
+	"soc_phi_byp.%d",
+	"hclk_pre.%d",
+};
+
+/*
+ * Dividers' tables
+ */
+
+/* phia odf */
+static struct clk_div_table phia_odf_tab[] = {
+	{
+		.val = 0,
+		.div = 1,
+	},
+	{
+		.val = 1,
+		.div = 2,
+	},
+	{
+		.val = 2,
+		.div = 4,
+	},
+	{
+		.val = 3,
+		.div = 6,
+	},
+	{
+		.val = 4,
+		.div = 8,
+	},
+	{
+		.val = 5,
+		.div = 10,
+	},
+	{
+		.val = 6,
+		.div = 12,
+	},
+	{
+		.val = 7,
+		.div = 14,
+	},
+	/* Terminator */
+	{
+		.div = 0,
+	},
+};
+
+/* phib dividers */
+static struct clk_div_table phib_div_tab[] = {
+	{
+		.val = 0,
+		.div = 3,
+	},
+	{
+		.val = 1,
+		.div = 5,
+	},
+	/* Terminator */
+	{
+		.div = 0,
+	},
+};
+
+/*
+ * Init functions
+ */
+/*
+ * Init function for soc-pll clock
+ */
+static void soc_pll_init(struct sta2x11_clk_data *cptr,
+				struct sta2x11_instance_data *id)
+{
+	cptr->args.soc_pll.base = id->sctl->regs;
+	cptr->args.soc_pll.lock = &id->sctl->lock;
+}
+
+/*
+ * Init function for audio-pll clock
+ */
+static void audio_pll_init(struct sta2x11_clk_data *cptr,
+				  struct sta2x11_instance_data *id)
+{
+	cptr->args.audio_pll.base = id->sctl->regs;
+	cptr->args.audio_pll.lock = &id->sctl->lock;
+}
+
+/*
+ * Init functions for mux clocks
+ */
+static void
+sctl_mux_clock_init(struct sta2x11_clk_data *cptr,
+		    struct sta2x11_instance_data *id)
+{
+	cptr->args.mux.reg = id->sctl->regs + cptr->reg_offset;
+	cptr->args.mux.lock = &id->sctl->lock;
+}
+
+/*
+ * Init function for tab divider clock
+ */
+static void
+tab_divider_clock_init(struct sta2x11_clk_data *cptr,
+		       struct sta2x11_instance_data *id)
+{
+	cptr->args.tab_divider.reg = id->sctl->regs + cptr->reg_offset;
+	cptr->args.tab_divider.lock = &id->sctl->lock;
+}
+
+/*
+ * This table contains everything is needed to register all the clocks
+ * on a single connext instance
+ *
+ * TODO: this table shall be patched at startup to deal with the (very few
+ * at present) differences between STA2X11 based boards.
+ *
+ * TODO: complete this table with all the remaining clocks (mmc, msp, spi, ...)
+ */
+static struct sta2x11_clk_data clk_data[] = {
+	/* 24MHz refclk */
+	DECLARE_FIXED_RATE_ROOT_CLK(xtal, 24000000),
+	/* Sata clk */
+	DECLARE_FIXED_RATE_ROOT_CLK(sata, 100000000),
+	/* Eth clk */
+	DECLARE_FIXED_RATE_ROOT_CLK(eth, 50000000),
+	/* Soc pll vco */
+	DECLARE_SOC_PLL_CLK(soc_vco, xtal),
+	/* Soc pll vco dividers */
+	DECLARE_TAB_DIVIDER_CLK(soc_phia, SCTL_SCPLLFCTRL,
+				soc_vco, tab_divider_clock_init,
+				0, 0, 3, phia_odf_tab, 0),
+	DECLARE_TAB_DIVIDER_CLK(soc_phib, SCTL_SCCTL, soc_vco,
+				tab_divider_clock_init,
+				0, 10, 1, phib_div_tab, 0),
+	DECLARE_MUX_CLK(soc_phi, SCTL_SCCTL, soc_phi_parents,
+			sctl_mux_clock_init, 0, 2, 1, 0),
+	/*
+	 * TODO : IMPLEMENT THIS ONE AS A DIFFERENT TYPE OF CLOCK
+	 *
+	 * We need a mux clock controlled by a custom function:
+	 *
+	 * soc_phi_byp = soc_phi if pll is locked && !powered down && !bypassed
+	 * soc_phi_byp = xtal otherwise
+	 *
+	 * For now we assume that the soc pll is never bypassed, so we just
+	 * use a fixed factor clock to keep the correct names
+	 */
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp, soc_phi, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(clk_48M, soc_phi_byp, 0, 1, 13),
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp_div3, soc_phi_byp, 0, 1, 3),
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp_div4, soc_phi_byp, 0, 1, 4),
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp_div6, soc_phi_byp, 0, 1, 6),
+	DECLARE_FIXED_FACTOR_CLK(clk_52M, soc_phi_byp_div6, 0, 1, 2),
+	DECLARE_MUX_CLK(hclk_pre, SCTL_SCCTL, hclk_pre_parents,
+			sctl_mux_clock_init, 0, 0, 2, 0),
+	DECLARE_MUX_CLK(hclk, SCTL_SCCTL, hclk_parents,
+			sctl_mux_clock_init, 0, 9, 1, 0),
+	/* Audio pll derived clocks */
+	DECLARE_AUDIO_PLL_CLK(audio_pll_phi, xtal),
+	DECLARE_FIXED_FACTOR_CLK(audio_pll_phi_div2, audio_pll_phi, 0, 1, 2),
+	DECLARE_FIXED_FACTOR_CLK(audio_pll_phi_div10, audio_pll_phi, 0, 1, 10),
+	DECLARE_FIXED_FACTOR_CLK(audio_pll_phi_div4, audio_pll_phi_div2,
+				 0, 1, 2),
+	DECLARE_MUX_CLK(audio_pll_sdmmc, SCTL_SCCTL, audio_pll_sdmmc_parents,
+			sctl_mux_clock_init, 0, 8, 1, 0),
+	DECLARE_MUX_CLK(audio_pll_msp, SCTL_SCCTL, audio_pll_msp_parents,
+			sctl_mux_clock_init, 0, 8, 1, 0),
+	DECLARE_MUX_CLK(audio_pll_sarac, SCTL_SCCTL, audio_pll_sarac_parents,
+			sctl_mux_clock_init, 0, 8, 1, 0),
+	/* Peripheral clocks for uarts. TODO: implement these as gated clocks */
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart0, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart1, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart2, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart3, hclk, 0, 1, 1),
+	/* Baud rate clocks for uarts. TODO: implement these as gated clocks */
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart0, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart1, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart2, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart3, clk_48M, 0, 1, 1),
+	/* Peripheral clocks for gpios. TODO: implement these as gated clocks */
+	DECLARE_FIXED_FACTOR_CLK(hclk_gpio0, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_gpio1, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_gpio2, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_gpio3, hclk, 0, 1, 1),
+	/* Stmmac clock. TODO: implement this as a mux with sata */
+	DECLARE_FIXED_FACTOR_CLK(stmmac_rmii, eth, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(stmmac_csr, stmmac_rmii, 0, 1, 2),
+	/* sdmmc CLOCKS: FIXME: MUXED CLOCKS */
+	DECLARE_FIXED_FACTOR_CLK(sdmmc0, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(sdmmc1, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(sdmmc2, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(sdmmc3, clk_48M, 0, 1, 1),
+	/* Peripheral clocks for sdios */
+	DECLARE_FIXED_FACTOR_CLK(hclk_sdio0, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_sdio1, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_sdio2, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_sdio3, hclk, 0, 1, 1),
+	/* Peripheral clocks for dma's */
+	DECLARE_FIXED_FACTOR_CLK(hclk_soc_dma, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_audio_dma, hclk, 0, 1, 1),
+	/* Peripheral clocks for i2cs */
+	DECLARE_FIXED_FACTOR_CLK(hclk_i2c0, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_i2c1, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_i2c2, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_i2c3, hclk, 0, 1, 1),
+	/* i2c clocks */
+	DECLARE_FIXED_FACTOR_CLK(bclk_i2c0, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_i2c1, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_i2c2, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_i2c3, clk_48M, 0, 1, 1),
+	/* Peripheral clocks for spis */
+	DECLARE_FIXED_FACTOR_CLK(hclk_spi0, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_spi1, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_spi2, hclk, 0, 1, 1),
+	/* spi clocks */
+	DECLARE_FIXED_FACTOR_CLK(bclk_spi0, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_spi1, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_spi2, clk_48M, 0, 1, 1),
+};
+
+/*
+ * Inline helpers
+ */
+static inline int get_sdio_clk_index(unsigned int fn)
+{
+	switch(fn) {
+	case 2:
+		return sdmmc1;
+	case 3:
+		return sdmmc2;
+	case 4:
+		return sdmmc3;
+	default:
+		return sta2x11_n_clks;
+	}
+}
+
+static inline int get_i2c_bclk_index(unsigned int fn)
+{
+	return bclk_i2c0 + fn - 1;
+}
+
+static inline int get_spi_bclk_index(unsigned int fn)
+{
+	return bclk_spi0 + fn - 2;
+}
+
+/*
+ * The following code registers various clock types for the connext
+ */
+
+typedef struct clk *(regfunc)(struct sta2x11_clk_data *, const char *, int);
+
+static __init struct clk *
+do_register_fixed_rate_root(struct sta2x11_clk_data *cptr,
+			    const char *name,
+			    int instance_id)
+{
+	pr_debug("Registering fixed rate root clock %s, rate = %lu\n",
+		 name, cptr->args.fixed_rate_root.rate);
+	return clk_register_fixed_rate(NULL,
+				       name,
+				       NULL,
+				       cptr->flags,
+				       cptr->args.fixed_rate_root.rate);
+}
+
+static __init struct clk *
+do_register_fixed_factor(struct sta2x11_clk_data *cptr,
+			 const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.fixed_factor.parent_name, instance_id);
+	return clk_register_fixed_factor(NULL, name,
+					 parent_name,
+					 cptr->flags,
+					 cptr->args.fixed_factor.mult,
+					 cptr->args.fixed_factor.div);
+}
+
+static __init struct clk *
+do_register_mux(struct sta2x11_clk_data *cptr,
+		const char *name, int instance_id)
+{
+	int i, nparents = cptr->args.mux.num_parents;
+	char *parents[STA2X11_MAX_CLK_NPARENTS], *ptr;
+	char parent_names[STA2X11_MAX_CLK_NPARENTS*STA2X11_MAX_CLK_NAME_LEN];
+	if (nparents > STA2X11_MAX_CLK_NPARENTS)
+		return ERR_PTR(-ENOMEM);
+	for (i = 0, ptr = parent_names; i < nparents; i++,
+		     ptr += STA2X11_MAX_CLK_NAME_LEN) {
+		snprintf(ptr, STA2X11_MAX_CLK_NAME_LEN,
+			 cptr->args.mux.parent_names[i], instance_id);
+		parents[i] = ptr;
+	}
+	return clk_register_mux(NULL, name, (const char **)parents,
+				cptr->args.mux.num_parents, cptr->flags,
+				cptr->args.mux.reg, cptr->args.mux.shift,
+				cptr->args.mux.width,
+				cptr->args.mux.clk_mux_flags,
+				cptr->args.mux.lock);
+}
+
+static __init struct clk *
+do_register_tab_divider(struct sta2x11_clk_data *cptr,
+			const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.tab_divider.parent_name, instance_id);
+	pr_debug("%s: registering tab_divider clock %s\n", __func__, name);
+	pr_debug("%s: parent = %s\n", __func__, parent_name);
+	return clk_register_divider_table(NULL, name, parent_name,
+					  0, cptr->args.tab_divider.reg,
+					  cptr->args.tab_divider.shift,
+					  cptr->args.tab_divider.width,
+					  0, cptr->args.tab_divider.div_tab,
+					  cptr->args.tab_divider.lock);
+}
+
+static __init struct clk *
+do_register_soc_pll(struct sta2x11_clk_data *cptr,
+		    const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.soc_pll.parent_name, instance_id);
+	pr_debug("%s: registering soc_pll clock %s\n", __func__, name);
+	pr_debug("%s: parent = %s\n", __func__, parent_name);
+	return register_sta2x11_clk_soc_pll(name, parent_name,
+					    cptr->args.soc_pll.base,
+					    cptr->args.soc_pll.lock);
+}
+
+static __init struct clk *
+do_register_audio_pll(struct sta2x11_clk_data *cptr,
+		      const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.audio_pll.parent_name, instance_id);
+	pr_debug("%s: registering audio_pll clock %s\n", __func__, name);
+	pr_debug("%s: parent = %s\n", __func__, parent_name);
+	return register_sta2x11_clk_audio_pll(name, parent_name,
+					      cptr->args.audio_pll.base,
+					      cptr->args.audio_pll.lock);
+}
+
+/*
+ * This function registers all the clocks listed in the clk_data table
+ * Such table is static and can be modified on a per-board basis at startup.
+ */
+static regfunc * regfuncs[] = {
+	[fixed_rate_root] = do_register_fixed_rate_root,
+	[fixed_factor] = do_register_fixed_factor,
+	[mux] = do_register_mux,
+	[tab_divider] = do_register_tab_divider,
+	[soc_pll] = do_register_soc_pll,
+	[audio_pll] = do_register_audio_pll,
+};
+
+static int register_clocks(struct sta2x11_instance_data *id,
+				  struct platform_device *dev)
+{
+	int i;
+	struct sta2x11_clk_data *cptr;
+	struct clk *clk, **clks;
+
+	/*
+	 * When this function is called, kmalloc already works, so we should
+	 * have no problem using it
+	 */
+	clks = kzalloc(sta2x11_n_clks * sizeof(struct clk *), GFP_KERNEL);
+	if (!clks)
+		return -ENOMEM;
+
+	for (i = 0, cptr = clk_data; i < ARRAY_SIZE(clk_data); i++, cptr++) {
+		/*
+		 * name can be on stack, since the clock framework does
+		 * kstrdup on register
+		 */
+		char name[STA2X11_MAX_CLK_NAME_LEN];
+		if (cptr->type < 0 || cptr->type > sta2x11_clk_ntypes) {
+			pr_err("%s: invalid type %d for clk %s, skipping\n",
+			       __func__, cptr->type,
+			       cptr->basename ? cptr->basename : "UNKNOWN");
+			continue;
+		}
+		if (cptr->type == none)
+			/* Clock not implemented on this board */
+			continue;
+		if (!regfuncs[cptr->type]) {
+			pr_err("%s : no regfunc for clk %s, skipping\n",
+			       __func__, cptr->basename ? cptr->basename :
+			       "UNKNOWN");
+			continue;
+		}
+		/*
+		 * Set up a clock name by adding an instance id to its
+		 * basename
+		 */
+		snprintf(name, sizeof(name), "%s.%d", cptr->basename,
+			 id->id);
+		/*
+		 * This should add runtime data to the clock. In particular,
+		 * it should add the controlling register's virtual address
+		 * (which is unknown at compile time)
+		 */
+		if (cptr->init)
+			cptr->init(cptr, id);
+		/* Ok, now just register the clock */
+		clk = regfuncs[cptr->type](cptr, name, id->id);
+		if (IS_ERR(clk)) {
+			pr_err("%s error registering clock %s\n",
+			       __func__, name);
+		} else {
+			pr_info("%s: registered clock %s\n", __func__, name);
+			clks[i] = clk;
+			/*
+			  A lookup is also added for each of the registered
+			  clocks
+			*/
+			clk_register_clkdev(clks[i], name, NULL);
+		}
+	}
+	/* Finally assign registered clocks to the instance they belong to */
+	platform_set_drvdata(dev, clks);
+	return 0;
+}
+
+/*
+ * Driver for the sta2x11-clock-regs platform device
+ */
+static int sta2x11_clock_regs_probe(struct platform_device *dev)
+{
+	struct sta2x11_instance_data *id = dev_get_platdata(&dev->dev);
+
+	dev_dbg(&dev->dev, "%s entered, id = %p", __func__, id);
+	if (!id)
+		return -EINVAL;
+	return register_clocks(id, dev);
+}
+
+static struct platform_driver sta2x11_clock_regs_driver = {
+	.driver = {
+		.name	= STA2X11_CLOCK_REGS_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sta2x11_clock_regs_probe,
+};
+
+/*
+ * This function just registers a notifier for the platform bus to know
+ * when the sta2x11-sctl and sta2x11-apb-soc-regs devices have been bound
+ * to the relevant drivers
+ */
+static int __init sta2x11_init_clocks(void)
+{
+	return platform_driver_register(&sta2x11_clock_regs_driver);
+}
+subsys_initcall(sta2x11_init_clocks);
+
+static struct clk **get_instance_clocks(struct sta2x11_instance_data *idata)
+{
+	struct device *d, *start;
+	char name[strlen(STA2X11_CLOCK_REGS_NAME) + 3];
+	snprintf(name, sizeof(name), "%s.%d",
+		 STA2X11_CLOCK_REGS_NAME, idata->id);
+	for (start = NULL; ; start = d) {
+		d = bus_find_device_by_name(&platform_bus_type, start, name);
+		if (!d)
+			break;
+		WARN_ON(dev_get_platdata(d) != idata);
+		return platform_get_drvdata(to_platform_device(d));
+	}
+	return NULL;
+}
+
+/*
+ * This is invoked on pci_enable() for every connext pci device
+ *
+ * It registers a lookup for the device's clock (if needed), so that
+ * the driver can find it.
+ */
+static void clk_new_pdev(struct pci_dev *pdev)
+{
+	struct sta2x11_instance_data *instance =
+		sta2x11_dev_to_instance(&pdev->dev);
+	/* Initialize with an invalid index */
+	enum sta2x11_clk clk_index = sta2x11_n_clks;
+	int sdio_index = -1;
+	struct clk **clks;
+	char *name;
+	if (!instance)
+		/*
+		 * Just ignore devices not belonging to the connext chip
+		 */
+		return;
+	clks = get_instance_clocks(instance);
+	if (!clks) {
+		/*
+		  If this is a connext device, it should have a corresponding
+		  clocks device
+		*/
+		WARN_ON(1);
+		return;
+	}
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_STMICRO_UART_HWFC:
+		clk_index = pdev->devfn == 5 ? bclk_uart2 : bclk_uart3;
+		/* FALL THROUGH */
+	case PCI_DEVICE_ID_STMICRO_UART_NO_HWFC:
+		if (clk_index == sta2x11_n_clks)
+			clk_index =
+				(pdev->devfn == 5 ? bclk_uart0 : bclk_uart1);
+		if (pci_amba_get_dev_name(&name, pdev, 0) < 0) {
+			/* Could get no name for the pci-amba device */
+			WARN_ON(1);
+			return;
+		}
+		clk_register_clkdev(clks[clk_index], NULL, name);
+		break;
+	case PCI_DEVICE_ID_STMICRO_MAC:
+		clk_register_clkdev(clks[stmmac_csr], NULL,
+				    dev_name(&pdev->dev));
+		break;
+	case PCI_DEVICE_ID_STMICRO_GPIO:
+	{
+		int i;
+		for (i = 0; i < 4; i++) {
+			if (pci_amba_get_dev_name(&name, pdev, i) < 0) {
+				/* Could get no name for the pci-amba device */
+				WARN_ON(1);
+				continue;
+			}
+			clk_register_clkdev(clks[hclk_gpio0 + i], NULL, name);
+		}
+		break;
+	}
+	case PCI_DEVICE_ID_STMICRO_SDIO_EMMC:
+		sdio_index = sdmmc0;
+		/* FALL THROUGH */
+	case PCI_DEVICE_ID_STMICRO_SDIO:
+		if (pci_amba_get_dev_name(&name, pdev, 0) < 0) {
+			/* Could get no name for the pci-amba device */
+			WARN_ON(1);
+			return;
+		}
+		if (sdio_index < 0)
+			sdio_index = get_sdio_clk_index(pdev->devfn);
+		if (sdio_index >= sta2x11_n_clks) {
+			pr_err("Unknown sdio device, not registering clock\n");
+			break;
+		}
+		clk_register_clkdev(clks[sdio_index], NULL, name,
+				    pdev->bus->number, pdev->devfn);
+		break;
+	case PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_DMA:
+		clk_index = hclk_audio_dma;
+		/* FALL THROUGH */
+	case PCI_DEVICE_ID_STMICRO_SOC_DMA:
+		if (clk_index == sta2x11_n_clks)
+			clk_index = hclk_soc_dma;
+		if (pci_amba_get_dev_name(&name, pdev, 0) < 0) {
+			/* Could get no name for the pci-amba device */
+			WARN_ON(1);
+			return;
+		}
+		clk_register_clkdev(clks[clk_index], NULL, name);
+		break;
+	case PCI_DEVICE_ID_STMICRO_I2C:
+		if (pci_amba_get_dev_name(&name, pdev, 0) < 0) {
+			/* Could get no name for the pci-amba device */
+			WARN_ON(1);
+			return;
+		}
+		clk_index = get_i2c_bclk_index(pdev->devfn);
+		clk_register_clkdev(clks[clk_index], NULL, name);
+		break;
+	case PCI_DEVICE_ID_STMICRO_SPI_HS:
+		if (pci_amba_get_dev_name(&name, pdev, 0) < 0) {
+			/* Could get no name for the pci-amba device */
+			WARN_ON(1);
+			return;
+		}
+		clk_index = get_spi_bclk_index(pdev->devfn);
+		clk_register_clkdev(clks[clk_index], NULL, name);
+		break;
+		/* TODO : ADD MORE ID's HERE */
+	default:
+		dev_dbg(&pdev->dev, "clk: ignoring device\n");
+		break;
+	}
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, clk_new_pdev);
diff --git a/drivers/clk/sta2x11/clk.h b/drivers/clk/sta2x11/clk.h
new file mode 100644
index 0000000..7a2e0ef
--- /dev/null
+++ b/drivers/clk/sta2x11/clk.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright ST Microelectronics 2012
+ * Author: Davide Ciminaghi <ciminaghi@gnudd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Common clock api implementation for sta2x11, main header file
+ */
+#ifndef __STA2X11_CLK_H__
+#define __STA2X11_CLK_H__
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/spinlock.h>
+
+/*
+ * Indices for connext clocks
+ */
+enum sta2x11_clk {
+	xtal, sata, pcie, sdvo, eth, usb,
+	soc_vco, soc_phia, soc_phib, audio_pll_phi,
+	soc_phi, soc_phi_byp,
+	soc_phi_byp_div3, soc_phi_byp_div4, soc_phi_byp_div6,
+	audio_pll_phi_div2, audio_pll_phi_div4, audio_pll_phi_div10,
+	audio_pll_msp, audio_pll_sarac, audio_pll_sdmmc,
+	hclk_pre, hclk, clk_48M, clk_52M,
+	/* Uarts' peripheral clocks */
+	hclk_uart0, hclk_uart1, hclk_uart2, hclk_uart3,
+	/* Uarts' baud rate clocks */
+	bclk_uart0, bclk_uart1, bclk_uart2, bclk_uart3,
+	/* gpios clock */
+	hclk_gpio0, hclk_gpio1, hclk_gpio2, hclk_gpio3,
+	/* sdios clocks */
+	hclk_sdio0, hclk_sdio1, hclk_sdio2, hclk_sdio3,
+	/* soc dma clock */
+	hclk_soc_dma,
+	/* audio dma clock */
+	hclk_audio_dma,
+	/* i2c clocks */
+	hclk_i2c0, hclk_i2c1, hclk_i2c2, hclk_i2c3,
+	bclk_i2c0, bclk_i2c1, bclk_i2c2, bclk_i2c3,
+	/* spi clocks */
+	hclk_spi0, hclk_spi1, hclk_spi2,
+	bclk_spi0, bclk_spi1, bclk_spi2,
+	sdmmc0, sdmmc1, sdmmc2, sdmmc3,
+	stmmac_csr, stmmac_rmii,
+	sta2x11_n_clks,
+};
+
+/*
+ * Clock types used on the connext
+ *
+ * By convention, a clock listed in clk_data[] with type == none, is not
+ * registered (usually because the clock itself is not active on the
+ * board the kernel is being run on).
+ */
+enum sta2x11_clk_type {
+	/* Not present on this board */
+	none = 0,
+	fixed_rate_root = 1,
+	fixed_factor = 2,
+	mux = 3,
+	tab_divider = 4,
+	soc_pll = 5,
+	audio_pll = 6,
+	sta2x11_clk_ntypes,
+};
+
+struct clk *register_sta2x11_clk_soc_pll(const char *name,
+					 const char *parent_name,
+					 void __iomem *reg,
+					 spinlock_t *lock);
+struct clk *register_sta2x11_clk_audio_pll(const char *name,
+					   const char *parent_name,
+					   void __iomem *base,
+					   spinlock_t *lock);
+#endif /* __STA2X11_CLK_H__ */
-- 
1.7.7.2
