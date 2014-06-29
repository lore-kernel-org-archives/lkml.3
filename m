Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaF2Q6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:58:14 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:62619 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaF2Q5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:57:47 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@gmail.com>
Subject: [PATCH 2/2] MIPS: Alchemy: common clock framework integration
Date: Sun, 29 Jun 2014 18:57:35 +0200
Message-Id: <1404061055-89797-3-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
References: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose chip-internal configurable clocks to the common clk framework,
and fix a few drivers to take advantage of it.

The patch takes the frequencies and tree configuration set up by
the bootloader and runs with it;  all boards should continue to
work without modifications.  A few clocks for which I haven't yet
modified the drivers using them are force-enabled when firmware
has left them enabled (the clk framework disables all not yet
clk_enable()d ones late during boot). This whitelist will go away
eventually.

The set_rate logic in the muxes does not request rate changes from
upstream sources, nor does it change parents if it seems more
appropriate: I've kept this logic as simple as possible for
now.  Source and rate changes have to be made manually at each pll
and mux.

Tested only on the DB1300 and DB1500 so far, but I see no functional
changes / errors on either board, I'll test on the other DB boards
I have soon as well.

Example clock summaries right after boot:

db1300 ~ # cat /sys/kernel/debug/clk/clk_summary
   clock                         enable_cnt  prepare_cnt        rate   accuracy
--------------------------------------------------------------------------------
 root_clk                                 3            3    12000000          0
    auxpll2_clk                           1            1   756000000          0
       fg5_clk                            0            0   252000000          0
          maebsa_clk                      0            0   252000000          0
       fg4_clk                            0            0   189000000          0
          maempe_clk                      0            0   189000000          0
       fg3_clk                            0            0   252000000          0
          gpemgp_clk                      0            0   252000000          0
       fg2_clk                            1            1   189000000          0
          EXTCLK1                         1            1    47250000          0
       fg1_clk                            0            0   756000000          0
       fg0_clk                            0            0   756000000          0
    auxpll_clk                            1            1    96000000          0
       EXTCLK0                            0            0    96000000          0
       lcd_intclk                         1            1    96000000          0
    cpu_clk                               1            1   660000000          0
       sysbus_clk                         1            1   330000000          0
          mem_clk                         0            0   330000000          0
          periph_clk                      3            3   165000000          0
             lr_clk                       0            0   165000000          0

db1500 ~ # cat /sys/kernel/debug/clk/clk_summary
   clock                         enable_cnt  prepare_cnt        rate   accuracy
--------------------------------------------------------------------------------
 root_clk                                 2            2    12000000          0
    auxpll_clk                            2            2   384000000          0
       EXTCLK1                            0            0   384000000          0
       EXTCLK0                            0            0   384000000          0
       fg2_clk                            1            1    64000000          0
          pci_clko                        1            1    64000000          0
       fg1_clk                            1            1    96000000          0
          usbh_clk                        1            1    48000000          0
          usbd_clk                        0            0    48000000          0
    cpu_clk                               1            1   396000000          0
       fg5_clk                            0            0   198000000          0
       fg4_clk                            0            0   198000000          0
       fg3_clk                            0            0   198000000          0
       fg0_clk                            0            0   198000000          0
       sysbus_clk                         1            1   198000000          0
          mem_clk                         0            0    99000000          0
          periph_clk                      1            1    99000000          0
             lr_clk                       0            0    99000000          0

---
 arch/mips/Kconfig                          |    1 +
 arch/mips/alchemy/common/Makefile          |    2 +-
 arch/mips/alchemy/common/clock.c           | 1113 ++++++++++++++++++++++++++++
 arch/mips/alchemy/common/clocks.c          |  106 ---
 arch/mips/alchemy/common/platform.c        |   10 +-
 arch/mips/alchemy/common/setup.c           |   18 -
 arch/mips/alchemy/common/usb.c             |   10 +
 arch/mips/alchemy/devboards/db1000.c       |   14 +
 arch/mips/alchemy/devboards/db1200.c       |   54 +-
 arch/mips/include/asm/mach-au1x00/au1000.h |   87 +--
 arch/mips/pci/pci-alchemy.c                |   20 +-
 drivers/mmc/host/au1xmmc.c                 |   28 +-
 drivers/net/irda/au1k_ir.c                 |   48 +-
 drivers/video/fbdev/au1100fb.c             |   16 -
 14 files changed, 1279 insertions(+), 248 deletions(-)
 create mode 100644 arch/mips/alchemy/common/clock.c
 delete mode 100644 arch/mips/alchemy/common/clocks.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 458608d..86e79de 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -72,6 +72,7 @@ config MIPS_ALCHEMY
 	select SYS_SUPPORTS_APM_EMULATION
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_SUPPORTS_ZBOOT
+	select COMMON_CLK
 
 config AR7
 	bool "Texas Instruments AR7"
diff --git a/arch/mips/alchemy/common/Makefile b/arch/mips/alchemy/common/Makefile
index cb83d8d..2e4d505 100644
--- a/arch/mips/alchemy/common/Makefile
+++ b/arch/mips/alchemy/common/Makefile
@@ -5,7 +5,7 @@
 # Makefile for the Alchemy Au1xx0 CPUs, generic files.
 #
 
-obj-y += prom.o time.o clocks.o platform.o power.o setup.o \
+obj-y += prom.o time.o clock.o platform.o power.o setup.o \
 	sleeper.o dma.o dbdma.o vss.o irq.o usb.o
 
 # optional gpiolib support
diff --git a/arch/mips/alchemy/common/clock.c b/arch/mips/alchemy/common/clock.c
new file mode 100644
index 0000000..c744a56
--- /dev/null
+++ b/arch/mips/alchemy/common/clock.c
@@ -0,0 +1,1113 @@
+/*
+ * Alchemy clocks.
+ *
+ * Exposes all configurable internal clock sources to the clk framework.
+ *
+ * We have:
+ *  - Root source, usually 12MHz supplied by an external crystal
+ *  - 3 PLLs which generate multiples of root rate [AUX, CPU, AUX2]
+ *
+ * Dividers:
+ *  - 6 clock dividers with:
+ *   * selectable source [one of the PLLs],
+ *   * output divided between [2 .. 512 in steps of 2] (!Au1300)
+ *     or [1 .. 256 in steps of 1] (Au1300),
+ *   * can be enabled individually.
+ *
+ * - up to 6 "internal" (fixed) consumers which:
+ *   * take either AUXPLL or one of the above 6 dividers as input,
+ *   * divide this input by 1, 2, or 4 (and 3 on Au1300).
+ *   * can be disabled separately.
+ *
+ * Misc clocks:
+ * - sysbus clock: CPU core clock (CPUPLL) divided by 2, 3 or 4.
+ *    depends on board design and should be set by bootloader, read-only.
+ * - peripheral clock: half the rate of sysbus clock, source for a lot
+ *    of peripheral blocks, read-only.
+ * - memory clock: clk rate to main memory chips, depends on board
+ *    design and is read-only,
+ * - lrclk: the static bus clock signal for synchronous operation.
+ *    depends on board design, must be set by bootloader,
+ *    but may be required to correctly configure devices attached to
+ *    the static bus. The Au1000/1500/1100 manuals call it LCLK, on
+ *    later models it's called RCLK.
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <asm/mach-au1x00/au1000.h>
+
+/* Base clock: 12MHz is the default in all databooks, and I haven't
+ * found any board yet which uses a different rate.
+ */
+#define ALCHEMY_ROOTCLK_RATE	12000000
+
+/*
+ * the internal sources which can be driven by the PLLs and dividers.
+ * Refer to the databooks for more information about them, especially
+ * regarding the aliases of the EXTCLK0/1 clocks on Au1550/1200/1300!
+ */
+static const char * const alchemy_au1300_intclknames[] = {
+	"lcd_intclk", "gpemgp_clk", "maempe_clk", "maebsa_clk",
+	"EXTCLK0", "EXTCLK1"
+};
+
+static const char * const alchemy_au1200_intclknames[] = {
+	"lcd_intclk", NULL, NULL, NULL, "EXTCLK0", "EXTCLK1"
+};
+
+static const char * const alchemy_au1550_intclknames[] = {
+	"usb_clk", "psc0_intclk", "psc1_intclk", "pci_clko",
+	"EXTCLK0", "EXTCLK1"
+};
+
+static const char * const alchemy_au1100_intclknames[] = {
+	"usb_clk", "lcd_intclk", NULL, "i2s_clk", "EXTCLK0", "EXTCLK1"
+};
+
+static const char * const alchemy_au1500_intclknames[] = {
+	NULL, "usbd_clk", "usbh_clk", "pci_clko", "EXTCLK0", "EXTCLK1"
+};
+
+static const char * const alchemy_au1000_intclknames[] = {
+	"irda_clk", "usbd_clk", "usbh_clk", "i2s_clk", "EXTCLK0",
+	"EXTCLK1"
+};
+
+/* aliases for a few on-chip sources which are either shared
+ * or have gone through name changes.
+ */
+static struct clk_aliastable {
+	char *alias;
+	char *base;
+	int cputype;
+} alchemy_clk_aliases[] __initdata = {
+	{ "usbh_clk", "usb_clk",    ALCHEMY_CPU_AU1100 },
+	{ "usbd_clk", "usb_clk",    ALCHEMY_CPU_AU1100 },
+	{ "irda_clk", "usb_clk",    ALCHEMY_CPU_AU1100 },
+	{ "usbh_clk", "usb_clk",    ALCHEMY_CPU_AU1550 },
+	{ "usbd_clk", "usb_clk",    ALCHEMY_CPU_AU1550 },
+	{ "psc2_intclk", "usb_clk", ALCHEMY_CPU_AU1550 },
+	{ "psc3_intclk", "EXTCLK0", ALCHEMY_CPU_AU1550 },
+	{ "psc0_intclk", "EXTCLK0", ALCHEMY_CPU_AU1200 },
+	{ "psc1_intclk", "EXTCLK1", ALCHEMY_CPU_AU1200 },
+	{ "psc0_intclk", "EXTCLK0", ALCHEMY_CPU_AU1300 },
+	{ "psc2_intclk", "EXTCLK0", ALCHEMY_CPU_AU1300 },
+	{ "psc1_intclk", "EXTCLK1", ALCHEMY_CPU_AU1300 },
+	{ "psc3_intclk", "EXTCLK1", ALCHEMY_CPU_AU1300 },
+
+	{ NULL, NULL, 0 },
+};
+
+/* FIXME: keep these enabled until drivers have been fixed */
+static const char *alchemy_clk_aenwl[] __initconst = {
+	"lcd_intclk", "EXTCLK0", "EXTCLK1", NULL
+};
+
+
+#define IOMEM(x)	((void __iomem *)(KSEG1ADDR(CPHYSADDR(x))))
+
+/* access locks to SYS_FREQCTRL0/1 and SYS_CLKSRC registers */
+static spinlock_t alchemy_clk_fg0_lock;
+static spinlock_t alchemy_clk_fg1_lock;
+static spinlock_t alchemy_clk_csrc_lock;
+
+/* CPU Core clock *****************************************************/
+
+static unsigned long alchemy_clk_cpu_recalc(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	unsigned long t;
+
+	/*
+	 * On early Au1000, sys_cpupll was write-only. Since these
+	 * silicon versions of Au1000 are not sold, we don't bend
+	 * over backwards trying to determine the frequency.
+	 */
+	if (unlikely(au1xxx_cpu_has_pll_wo()))
+		t = 396000000;
+	else {
+		t = AU1X_RDSYS(AU1000_SYS_CPUPLL) & 0x7f;
+		t *= parent_rate;
+	}
+
+	return t;
+}
+
+static struct clk_ops alchemy_clkops_cpu = {
+	.recalc_rate	= alchemy_clk_cpu_recalc,
+};
+
+static struct clk __init *alchemy_clk_setup_cpu(const char *parent_name,
+						int ctype)
+{
+	struct clk_init_data id;
+	struct clk_hw *h;
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return ERR_PTR(-ENOMEM);
+
+	id.name = ALCHEMY_CPU_CLK;
+	id.parent_names = &parent_name;
+	id.num_parents = 1;
+	id.flags = CLK_IS_BASIC;	/* no to_foo_clk(x) */
+	id.ops = &alchemy_clkops_cpu;
+	h->init = &id;
+
+	return clk_register(NULL, h);
+}
+
+/* AUXPLLs ************************************************************/
+
+struct alchemy_auxpll_clk {
+	struct clk_hw hw;
+	unsigned long reg;	/* au1300 has also AUXPLL2 */
+	int maxmult;		/* max multiplier */
+};
+#define to_auxpll_clk(x) container_of(x, struct alchemy_auxpll_clk, hw)
+
+static unsigned long alchemy_clk_aux_recalc(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	struct alchemy_auxpll_clk *a = to_auxpll_clk(hw);
+
+	return (AU1X_RDSYS(a->reg) & 0xff) * parent_rate;
+}
+
+static int alchemy_clk_aux_setr(struct clk_hw *hw,
+				unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct alchemy_auxpll_clk *a = to_auxpll_clk(hw);
+	unsigned long d = rate;
+
+	if (rate)
+		d /= parent_rate;
+	else
+		d = 0;
+
+	/* minimum is 84MHz, max is 756-1032 depending on variant */
+	if (((d < 7) && (d != 0)) || (d > a->maxmult))
+		return -EINVAL;
+
+	AU1X_WRSYS(d, a->reg);
+	wmb();	/* flush write buffer */
+	return 0;
+}
+
+static long alchemy_clk_aux_roundr(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
+{
+	struct alchemy_auxpll_clk *a = to_auxpll_clk(hw);
+	unsigned long mult;
+
+	if (!rate || !*parent_rate)
+		return 0;
+
+	mult = rate / (*parent_rate);
+
+	if (mult && (mult < 7))
+		mult = 7;
+	if (mult > a->maxmult)
+		mult = a->maxmult;
+
+	return (*parent_rate) * mult;
+}
+
+static struct clk_ops alchemy_clkops_aux = {
+	.recalc_rate	= alchemy_clk_aux_recalc,
+	.set_rate	= alchemy_clk_aux_setr,
+	.round_rate	= alchemy_clk_aux_roundr,
+};
+
+static struct clk __init *alchemy_clk_setup_aux(const char *parent_name,
+						char *name, int maxmult,
+						unsigned long reg)
+{
+	struct clk_init_data id;
+	struct clk *c;
+	struct alchemy_auxpll_clk *a;
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return ERR_PTR(-ENOMEM);
+
+	id.name = name;
+	id.parent_names = &parent_name;
+	id.num_parents = 1;
+	id.flags = CLK_GET_RATE_NOCACHE;
+	id.ops = &alchemy_clkops_aux;
+
+	a->reg = reg;
+	a->maxmult = maxmult;
+	a->hw.init = &id;
+
+	c = clk_register(NULL, &a->hw);
+	if (!IS_ERR(c))
+		clk_register_clkdev(c, name, NULL);
+	else
+		kfree(a);
+
+	return c;
+}
+
+/* sysbus_clk *********************************************************/
+
+static struct clk __init  *alchemy_clk_setup_sysbus(const char *pn)
+{
+	unsigned long v = (AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 3) + 2;
+	struct clk *c;
+
+	c = clk_register_fixed_factor(NULL, ALCHEMY_SYSBUS_CLK,
+				      pn, 0, 1, v);
+	if (!IS_ERR(c))
+		clk_register_clkdev(c, ALCHEMY_SYSBUS_CLK, NULL);
+	return c;
+}
+
+/* Peripheral Clock ***************************************************/
+
+static struct clk __init *alchemy_clk_setup_periph(const char *pn)
+{
+	/* Peripheral clock runs at half the rate of sysbus clk */
+	struct clk *c;
+
+	c = clk_register_fixed_factor(NULL, ALCHEMY_PERIPH_CLK,
+				      pn, 0, 1, 2);
+	clk_register_clkdev(c, ALCHEMY_PERIPH_CLK, NULL);
+	return c;
+}
+
+/* mem clock **********************************************************/
+
+static struct clk __init *alchemy_clk_setup_mem(const char *pn, int ct)
+{
+	void __iomem *addr = IOMEM(AU1000_MEM_PHYS_ADDR);
+	unsigned long v;
+	struct clk *c;
+	int div;
+
+	switch (ct) {
+	case ALCHEMY_CPU_AU1550:
+	case ALCHEMY_CPU_AU1200:
+		v = __raw_readl(addr + AU1550_MEM_SDCONFIGB);
+		div = (v & (1 << 15)) ? 1 : 2;
+		break;
+	case ALCHEMY_CPU_AU1300:
+		v = __raw_readl(addr + AU1550_MEM_SDCONFIGB);
+		div = (v & (1 << 31)) ? 1 : 2;
+		break;
+	case ALCHEMY_CPU_AU1000:
+	case ALCHEMY_CPU_AU1500:
+	case ALCHEMY_CPU_AU1100:
+	default:
+		div = 2;
+		break;
+	}
+
+	c = clk_register_fixed_factor(NULL, ALCHEMY_MEM_CLK, pn,
+				      0, 1, div);
+	if (!IS_ERR(c))
+		clk_register_clkdev(c, ALCHEMY_MEM_CLK, NULL);
+	return c;
+}
+
+/* lrclk: external synchronous static bus clock ***********************/
+
+static struct clk __init *alchemy_clk_setup_lrclk(const char *pn)
+{
+	/* MEM_STCFG0[15:13] = divisor.
+	 * L/RCLK = periph_clk / (divisor + 1)
+	 * On Au1000, Au1500, Au1100 it's called LCLK,
+	 * on later models it's called RCLK, but it's the same thing.
+	 */
+	struct clk *c;
+	void __iomem *a = IOMEM(AU1000_STATIC_MEM_PHYS_ADDR);
+	unsigned long v = __raw_readl(a + AU1000_MEM_STCFG0) >> 13;
+
+	v = (v & 7) + 1;
+	c = clk_register_fixed_factor(NULL, ALCHEMY_LR_CLK,
+				      pn, 0, 1, v);
+	if (!IS_ERR(c))
+		clk_register_clkdev(c, ALCHEMY_LR_CLK, NULL);
+	return c;
+}
+
+/* Clock dividers and muxes *******************************************/
+
+/* data for fgen and csrc mux-dividers */
+struct alchemy_fgcs_clk {
+	struct clk_hw hw;
+	spinlock_t *reglock;	/* register lock		  */
+	unsigned long reg;	/* SYS_FREQCTRL0/1		  */
+	int shift;		/* offset in register		  */
+	int parent;		/* parent before disable [Au1300] */
+	int isen;		/* is it enabled?		  */
+	int *dt;		/* dividertable for csrc	  */
+};
+#define to_fgcs_clk(x) container_of(x, struct alchemy_fgcs_clk, hw)
+
+static int alchemy_clk_fgv1_en(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v, flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v |= (1 << 1) << c->shift;
+	AU1X_WRSYS(v, c->reg);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static int alchemy_clk_fgv1_isen(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v = AU1X_RDSYS(c->reg) >> (c->shift + 1);
+
+	return v & 1;
+}
+
+static void alchemy_clk_fgv1_dis(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v, flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v &= ~((1 << 1) << c->shift);
+	AU1X_WRSYS(v, c->reg);
+	spin_unlock_irqrestore(c->reglock, flags);
+}
+
+static int alchemy_clk_fgv1_setp(struct clk_hw *hw, u8 index)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v, flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	if (index)
+		v |= (1 << c->shift);
+	else
+		v &= ~(1 << c->shift);
+	AU1X_WRSYS(v, c->reg);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static u8 alchemy_clk_fgv1_getp(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+
+	return (AU1X_RDSYS(c->reg) >> c->shift) & 1;
+}
+
+static long alchemy_calc_div(unsigned long rate, unsigned long prate,
+			       int scale)
+{
+	long div1;
+
+	div1 = prate / rate;
+	if ((prate / div1) > rate)
+		div1++;
+
+	if (scale == 2) {	/* only div-by-multiple-of-2 possible */
+		if (div1 & 1)
+			div1++;	/* stay <=prate */
+	}
+	div1 = (div1 / scale) - 1;
+
+	if (div1 > 255)
+		return -EINVAL;
+
+	return div1;
+}
+
+static int alchemy_clk_fgv1_setr(struct clk_hw *hw, unsigned long rate,
+				 unsigned long parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long div, v, flags;
+	int sh = c->shift + 2;
+
+	if (!rate || !parent_rate || rate > (parent_rate / 2))
+		return -EINVAL;
+	div = alchemy_calc_div(rate, parent_rate, 2);
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v &= ~(0xff << sh);
+	v |= div << sh;
+	AU1X_WRSYS(v, c->reg);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static unsigned long alchemy_clk_fgv1_recalc(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v = AU1X_RDSYS(c->reg) >> (c->shift + 2);
+
+	v = ((v & 0xff) + 1) * 2;
+	return parent_rate / v;
+}
+
+static long alchemy_clk_fgv1_round(struct clk_hw *hw,
+				   unsigned long rate,
+				   unsigned long *parent_rate)
+{
+	long div;
+
+	if (!rate || !*parent_rate || rate > *parent_rate)
+		return -EINVAL;
+
+	div = alchemy_calc_div(rate, *parent_rate, 2);
+
+	return *parent_rate / ((div + 1) * 2);
+}
+
+/* Au1000, Au1100, Au15x0, Au12x0 */
+static struct clk_ops alchemy_clkops_fgenv1 = {
+	.recalc_rate	= alchemy_clk_fgv1_recalc,
+	.round_rate	= alchemy_clk_fgv1_round,
+	.set_rate	= alchemy_clk_fgv1_setr,
+	.set_parent	= alchemy_clk_fgv1_setp,
+	.get_parent	= alchemy_clk_fgv1_getp,
+	.enable		= alchemy_clk_fgv1_en,
+	.disable	= alchemy_clk_fgv1_dis,
+	.is_enabled	= alchemy_clk_fgv1_isen,
+};
+
+static void __alchemy_clk_fgv2_en(struct alchemy_fgcs_clk *c)
+{
+	unsigned long v = AU1X_RDSYS(c->reg);
+
+	v &= ~(3 << c->shift);
+	v |= (c->parent & 3) << c->shift;
+	AU1X_WRSYS(v, c->reg);
+	c->isen = 1;
+}
+
+static int alchemy_clk_fgv2_en(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long flags;
+
+	/* enable by setting the previous parent clock */
+	spin_lock_irqsave(c->reglock, flags);
+	__alchemy_clk_fgv2_en(c);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static int alchemy_clk_fgv2_isen(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+
+	return ((AU1X_RDSYS(c->reg) >> c->shift) & 3) != 0;
+}
+
+static void alchemy_clk_fgv2_dis(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v, flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v &= ~(3 << c->shift);	/* set input mux to "disabled" state */
+	AU1X_WRSYS(v, c->reg);
+	c->isen = 0;
+	spin_unlock_irqrestore(c->reglock, flags);
+}
+
+static int alchemy_clk_fgv2_setp(struct clk_hw *hw, u8 index)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	c->parent = index + 1;	/* value to write to register */
+	if (c->isen)
+		__alchemy_clk_fgv2_en(c);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static u8 alchemy_clk_fgv2_getp(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long flags, v;
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = c->parent - 1;
+	spin_unlock_irqrestore(c->reglock, flags);
+	return v;
+}
+
+/* fg0-2 and fg4-6 share a "scale"-bit. With this bit cleared, the
+ * dividers behave exactly as on previous models (dividers are multiples
+ * of 2); with the bit set, dividers are multiples of 1, halving their
+ * range, but making them also much more flexible.
+ */
+static int alchemy_clk_fgv2_setr(struct clk_hw *hw, unsigned long rate,
+				 unsigned long parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	int sh = c->shift + 2;
+	unsigned long div, v, flags;
+
+	if (!rate || !parent_rate || rate > parent_rate)
+		return -EINVAL;
+
+	v = AU1X_RDSYS(c->reg) & (1 << 30); /* test "scale" bit */
+	div = alchemy_calc_div(rate, parent_rate, v ? 1 : 2);
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v &= ~(0xff << sh);
+	v |= (div & 0xff) << sh;
+	AU1X_WRSYS(v, c->reg);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static unsigned long alchemy_clk_fgv2_recalc(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	int sh = c->shift + 2;
+	unsigned long v, t;
+
+	v = AU1X_RDSYS(c->reg);
+	t = parent_rate / (((v >> sh) & 0xff) + 1);
+	if ((v & (1 << 30)) == 0)		/* test scale bit */
+		t /= 2;
+
+	return t;
+}
+
+static long alchemy_clk_fgv2_round(struct clk_hw *hw,
+				   unsigned long rate,
+				   unsigned long *parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v, e;
+	long d;
+
+	if (!rate || !*parent_rate || rate > *parent_rate)
+		return -EINVAL;
+	v = AU1X_RDSYS(c->reg);
+	v &= (1 << 30);	/* test scale bit */
+	d = alchemy_calc_div(rate, *parent_rate, v ? 1 : 2);
+
+	e = *parent_rate / (d + 1);
+	if (!v)
+		e /= 2;
+
+	return e;
+}
+
+#if 0
+/* doesn't work: I can't tell the clock framework that there are
+ * a range of parent frequencies (and parents) that would work, but the
+ * last one I report back is then set, regardless of the other children
+ * this (new) parent might already have!  And I can't dive down the
+ * child branches of each possible parent either...
+ */
+static long alchemy_clk_fgv2_detr(struct clk_hw *hw, unsigned long rate,
+					unsigned long *best_parent_rate,
+					struct clk **best_parent_clk)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	struct clk *pc, *bpc, *clk = hw->clk;
+	long tpr, pr, nr, br, bpr, diff, lastdiff;
+	int inc, max, i, j, n;
+
+	if (AU1X_RDSYS(c->reg) & (1 << 30)) {
+		inc = 1;
+		max = 256;
+	} else {
+		inc = 2;
+		max = 512;
+	}
+
+	lastdiff = rate;
+	bpr = *best_parent_rate;
+	bpc = *best_parent_clk;
+	br = rate;
+
+	n = 3;
+	/* most naive approach i could make... :) */
+	for (i = 1; i <= max; i += inc) {
+		tpr = rate * i;
+		if (tpr < 0)
+			continue;
+		for (j = 0; j < n; j++) {
+			pc = clk_get_parent_by_index(clk, j);
+			if (!pc)
+				continue;
+			pr = clk_round_rate(pc, tpr);
+			nr = pr / i;
+			if (nr > rate)
+				continue;
+			diff = rate - nr;
+			if (diff < lastdiff) {
+				lastdiff = diff;
+				bpr = pr;
+				bpc = pc;
+				br = nr;
+			}
+		}
+		/* TODO: die liste der kinder des gefundenen elterneils
+		 * ansehen und testen ob sie mit der neuen rate zurecht
+		 * kommen (bei aktivierten sollten wir genau treffen,
+		 * bei nicht-aktivierten könnte etwas abweichung
+		 * toleriert werden.) Vielleicht das Ganze überhaupt mit
+		 * JEDER von uns vorgeschlagenen Rate probieren?
+		 */
+	}
+	/* sometimes a whole bunch of frequencies are possible
+	 * per parent, but how to tell the framework?
+	 * For now, supply the most recent best we've found
+	 */
+	*best_parent_rate = bpr;
+	*best_parent_clk = bpc;
+	return br;
+}
+#endif
+
+/* Au1300 larger input mux, no separate disable bit, flexible divider */
+static struct clk_ops alchemy_clkops_fgenv2 = {
+	.recalc_rate	= alchemy_clk_fgv2_recalc,
+	.round_rate	= alchemy_clk_fgv2_round,
+/*	.determine_rate	= alchemy_clk_fgv2_detr,	*/
+	.set_rate	= alchemy_clk_fgv2_setr,
+	.set_parent	= alchemy_clk_fgv2_setp,
+	.get_parent	= alchemy_clk_fgv2_getp,
+	.enable		= alchemy_clk_fgv2_en,
+	.disable	= alchemy_clk_fgv2_dis,
+	.is_enabled	= alchemy_clk_fgv2_isen,
+};
+
+static const char * const alchemy_clk_fgv1_parents[] = {
+	ALCHEMY_CPU_CLK, ALCHEMY_AUXPLL_CLK };
+
+static const char * const alchemy_clk_fgv2_parents[] = {
+	ALCHEMY_AUXPLL2_CLK, ALCHEMY_CPU_CLK,
+};
+
+static const char * const alchemy_clk_fgen_names[] = {
+	ALCHEMY_FG0_CLK, ALCHEMY_FG1_CLK, ALCHEMY_FG2_CLK,
+	ALCHEMY_FG3_CLK, ALCHEMY_FG4_CLK, ALCHEMY_FG5_CLK };
+
+static int __init alchemy_clk_init_fgens(int ctype)
+{
+	struct clk *c;
+	struct clk_init_data id;
+	struct alchemy_fgcs_clk *a;
+	unsigned long v;
+	int i, ret;
+
+	switch (ctype) {
+	case ALCHEMY_CPU_AU1000...ALCHEMY_CPU_AU1200:
+		id.ops = &alchemy_clkops_fgenv1;
+		id.parent_names = (const char **)alchemy_clk_fgv1_parents;
+		id.num_parents = 2;
+		break;
+	case ALCHEMY_CPU_AU1300:
+		id.ops = &alchemy_clkops_fgenv2;
+		id.parent_names = (const char **)alchemy_clk_fgv2_parents;
+		id.num_parents = 3;
+		break;
+	default:
+		return -ENODEV;
+	}
+	id.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE;
+
+	a = kzalloc((sizeof(*a)) * 6, GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	spin_lock_init(&alchemy_clk_fg0_lock);
+	spin_lock_init(&alchemy_clk_fg1_lock);
+	ret = 0;
+	for (i = 0; i < 6; i++) {
+		id.name = alchemy_clk_fgen_names[i];
+		a->shift = 10 * (i < 3 ? i : i - 3);
+		if (i > 2) {
+			a->reg = AU1000_SYS_FREQCTRL1;
+			a->reglock = &alchemy_clk_fg1_lock;
+		} else {
+			a->reg = AU1000_SYS_FREQCTRL0;
+			a->reglock = &alchemy_clk_fg0_lock;
+		}
+
+		/* default to first parent if bootloader has set
+		 * the mux to disabled state.
+		 */
+		if (ctype == ALCHEMY_CPU_AU1300) {
+			v = AU1X_RDSYS(a->reg);
+			a->parent = (v >> a->shift) & 3;
+			if (!a->parent) {
+				a->parent = 1;
+				a->isen = 0;
+			} else
+				a->isen = 1;
+		}
+
+		a->hw.init = &id;
+		c = clk_register(NULL, &a->hw);
+		if (IS_ERR(c))
+			ret++;
+		else
+			clk_register_clkdev(c, id.name, NULL);
+		a++;
+	}
+
+	return ret;
+}
+
+/* internal sources muxes *********************************************/
+
+static int alchemy_clk_csrc_isen(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v = AU1X_RDSYS(c->reg);
+
+	return (((v >> c->shift) >> 2) & 7) != 0;
+}
+
+static void __alchemy_clk_csrc_en(struct alchemy_fgcs_clk *c)
+{
+	unsigned long v = AU1X_RDSYS(c->reg);
+
+	v &= ~((7 << 2) << c->shift);
+	v |= ((c->parent & 7) << 2) << c->shift;
+	AU1X_WRSYS(v, c->reg);
+	c->isen = 1;
+}
+
+static int alchemy_clk_csrc_en(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long flags;
+
+	/* enable by setting the previous parent clock */
+	spin_lock_irqsave(c->reglock, flags);
+	__alchemy_clk_csrc_en(c);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static void alchemy_clk_csrc_dis(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v, flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v &= ~((3 << 2) << c->shift);	/* mux to "disabled" state */
+	AU1X_WRSYS(v, c->reg);
+	c->isen = 0;
+	spin_unlock_irqrestore(c->reglock, flags);
+}
+
+static int alchemy_clk_csrc_setp(struct clk_hw *hw, u8 index)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(c->reglock, flags);
+	c->parent = index + 1;	/* value to write to register */
+	if (c->isen)
+		__alchemy_clk_csrc_en(c);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static u8 alchemy_clk_csrc_getp(struct clk_hw *hw)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+
+	return c->parent - 1;
+}
+
+static unsigned long alchemy_clk_csrc_recalc(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long v = (AU1X_RDSYS(c->reg) >> c->shift) & 3;
+
+	return parent_rate / c->dt[v];
+}
+
+static long alchemy_clk_csrc_round(struct clk_hw *hw,
+				   unsigned long rate,
+				   unsigned long *parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	long d;
+
+	if (!rate || !*parent_rate)
+		return -EINVAL;
+
+	if (rate > *parent_rate)
+		return *parent_rate;
+
+	d = (*parent_rate + (rate / 2)) / rate;
+	if ((d > 4) || ((d == 3) && (c->dt[2] != 3)))
+		d = 4;
+
+	return *parent_rate / d;
+}
+
+static int alchemy_clk_csrc_setr(struct clk_hw *hw, unsigned long rate,
+				 unsigned long parent_rate)
+{
+	struct alchemy_fgcs_clk *c = to_fgcs_clk(hw);
+	unsigned long d, v, flags;
+	int i;
+
+	if (!rate || !parent_rate || rate > parent_rate)
+		return -EINVAL;
+
+	d = (parent_rate + (rate / 2)) / rate;
+	if (d > 4)
+		return -EINVAL;
+	if ((d == 3) && (c->dt[2] != 3))
+		d = 4;
+
+	for (i = 0; i < 4; i++)
+		if (c->dt[i] == d)
+			break;
+
+	if (i > 4)
+		return -EINVAL;	/* oops */
+
+	spin_lock_irqsave(c->reglock, flags);
+	v = AU1X_RDSYS(c->reg);
+	v &= ~(3 << c->shift);
+	v |= (i & 3) << c->shift;
+	AU1X_WRSYS(v, c->reg);
+	spin_unlock_irqrestore(c->reglock, flags);
+
+	return 0;
+}
+
+static struct clk_ops alchemy_clkops_csrc = {
+	.recalc_rate	= alchemy_clk_csrc_recalc,
+	.round_rate	= alchemy_clk_csrc_round,
+	.set_rate	= alchemy_clk_csrc_setr,
+	.set_parent	= alchemy_clk_csrc_setp,
+	.get_parent	= alchemy_clk_csrc_getp,
+	.enable		= alchemy_clk_csrc_en,
+	.disable	= alchemy_clk_csrc_dis,
+	.is_enabled	= alchemy_clk_csrc_isen,
+};
+
+static const char * const alchemy_clk_csrc_parents[] = {
+	/* disabled at index 0 */ ALCHEMY_AUXPLL_CLK,
+	ALCHEMY_FG0_CLK, ALCHEMY_FG1_CLK, ALCHEMY_FG2_CLK,
+	ALCHEMY_FG3_CLK, ALCHEMY_FG4_CLK, ALCHEMY_FG5_CLK
+};
+
+/* divider tables */
+static int alchemy_csrc_dt1[] = { 1, 4, 1, 2 };	/* rest */
+static int alchemy_csrc_dt2[] = { 1, 4, 3, 2 };	/* Au1300 */
+
+static int __init alchemy_clk_setup_imux(int ctype)
+{
+	struct alchemy_fgcs_clk *a;
+	const char * const *names, **wl;
+	struct clk_init_data id;
+	unsigned long v;
+	int i, ret, *dt;
+	struct clk *c;
+
+	id.ops = &alchemy_clkops_csrc;
+	id.parent_names = (const char **)alchemy_clk_csrc_parents;
+	id.num_parents = 7;
+	id.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE;
+
+	dt = alchemy_csrc_dt1;
+	switch (ctype) {
+	case ALCHEMY_CPU_AU1000:
+		names = alchemy_au1000_intclknames;
+		break;
+	case ALCHEMY_CPU_AU1500:
+		names = alchemy_au1500_intclknames;
+		break;
+	case ALCHEMY_CPU_AU1100:
+		names = alchemy_au1100_intclknames;
+		break;
+	case ALCHEMY_CPU_AU1550:
+		names = alchemy_au1550_intclknames;
+		break;
+	case ALCHEMY_CPU_AU1200:
+		names = alchemy_au1200_intclknames;
+		break;
+	case ALCHEMY_CPU_AU1300:
+		dt = alchemy_csrc_dt2;
+		names = alchemy_au1300_intclknames;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	a = kzalloc((sizeof(*a)) * 6, GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	spin_lock_init(&alchemy_clk_csrc_lock);
+	ret = 0;
+
+	for (i = 0; i < 6; i++) {
+		id.name = names[i];
+		if (!id.name)
+			goto next;
+
+		a->shift = i * 5;
+		a->reg = AU1000_SYS_CLKSRC;
+		a->reglock = &alchemy_clk_csrc_lock;
+		a->dt = dt;
+
+		/* default to first parent clock if mux is initially
+		 * set to disabled state.
+		 */
+		v = AU1X_RDSYS(a->reg);
+		a->parent = ((v >> a->shift) >> 2) & 7;
+		if (!a->parent) {
+			a->parent = 1;
+			a->isen = 0;
+		} else
+			a->isen = 1;
+
+		a->hw.init = &id;
+		c = clk_register(NULL, &a->hw);
+		if (IS_ERR(c)) {
+			ret++;
+			goto next;
+		}
+
+		/* make it clk_get-able */
+		clk_register_clkdev(c, id.name, NULL);
+
+		/* tell the framework to leave some firmware-enabled
+		 * clocks running. FIXME! UPDATE DRIVERS!
+		 */
+		if (a->isen) {
+			wl = alchemy_clk_aenwl;
+			while (*wl) {
+				if (0 == strcmp(*wl, names[i])) {
+					clk_prepare_enable(c);
+					break;
+				}
+				wl++;
+			}
+		}
+next:
+		a++;
+	}
+
+	return ret;
+}
+
+
+/**********************************************************************/
+
+
+#define ERRCK(x)						\
+	if (IS_ERR(x)) {					\
+		ret = PTR_ERR(x);				\
+		goto out;					\
+	}
+
+static int __init alchemy_clk_init(void)
+{
+	int ctype = alchemy_get_cputype(), ret, i;
+	struct clk_aliastable *t = alchemy_clk_aliases;
+	struct clk *c;
+
+	/* Root of the Alchemy clock tree: external 12MHz crystal osc */
+	c = clk_register_fixed_rate(NULL, ALCHEMY_ROOT_CLK, NULL,
+					   CLK_IS_ROOT,
+					   ALCHEMY_ROOTCLK_RATE);
+	ERRCK(c)
+
+	/* CPU core clock */
+	c = alchemy_clk_setup_cpu(ALCHEMY_ROOT_CLK, ctype);
+	ERRCK(c)
+
+	/* AUXPLLs: max 1GHz on Au1300, 748MHz on older models */
+	i = (ctype == ALCHEMY_CPU_AU1300) ? 84 : 63;
+	c = alchemy_clk_setup_aux(ALCHEMY_ROOT_CLK, ALCHEMY_AUXPLL_CLK,
+				  i, AU1000_SYS_AUXPLL);
+	ERRCK(c)
+
+	if (ctype == ALCHEMY_CPU_AU1300) {
+		c = alchemy_clk_setup_aux(ALCHEMY_ROOT_CLK,
+					  ALCHEMY_AUXPLL2_CLK, i,
+					  AU1300_SYS_AUXPLL2);
+		ERRCK(c)
+	}
+
+	/* sysbus clock: cpu core clock divided by 2, 3 or 4 */
+	c = alchemy_clk_setup_sysbus(ALCHEMY_CPU_CLK);
+	ERRCK(c)
+
+	/* peripheral clock: runs at half rate of sysbus clk */
+	c = alchemy_clk_setup_periph(ALCHEMY_SYSBUS_CLK);
+	ERRCK(c)
+
+	/* SDR/DDR memory clock */
+	c = alchemy_clk_setup_mem(ALCHEMY_SYSBUS_CLK, ctype);
+	ERRCK(c)
+
+	/* L/RCLK: external static bus clock for synchronous mode */
+	c = alchemy_clk_setup_lrclk(ALCHEMY_PERIPH_CLK);
+	ERRCK(c)
+
+	/* Frequency dividers 0-5 */
+	ret = alchemy_clk_init_fgens(ctype);
+	if (ret) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* diving muxes for internal sources */
+	ret = alchemy_clk_setup_imux(ctype);
+	if (ret) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* set up aliases drivers might look for */
+	while (t->base) {
+		if (t->cputype == ctype)
+			clk_add_alias(t->alias, NULL, t->base, NULL);
+		t++;
+	}
+
+	pr_info("Alchemy clocktree installed\n");
+	return 0;
+
+out:
+	return ret;
+}
+arch_initcall(alchemy_clk_init);
diff --git a/arch/mips/alchemy/common/clocks.c b/arch/mips/alchemy/common/clocks.c
deleted file mode 100644
index 35db35b..0000000
--- a/arch/mips/alchemy/common/clocks.c
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * BRIEF MODULE DESCRIPTION
- *	Simple Au1xx0 clocks routines.
- *
- * Copyright 2001, 2008 MontaVista Software Inc.
- * Author: MontaVista Software, Inc. <source@mvista.com>
- *
- *  This program is free software; you can redistribute	 it and/or modify it
- *  under  the terms of	 the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the	License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED	  ``AS	IS'' AND   ANY	EXPRESS OR IMPLIED
- *  WARRANTIES,	  INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO	EVENT  SHALL   THE AUTHOR  BE	 LIABLE FOR ANY	  DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED	  TO, PROCUREMENT OF  SUBSTITUTE GOODS	OR SERVICES; LOSS OF
- *  USE, DATA,	OR PROFITS; OR	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN	 CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <asm/time.h>
-#include <asm/mach-au1x00/au1000.h>
-
-/*
- * I haven't found anyone that doesn't use a 12 MHz source clock,
- * but just in case.....
- */
-#define AU1000_SRC_CLK	12000000
-
-static unsigned int au1x00_clock; /*  Hz */
-static unsigned long uart_baud_base;
-
-/*
- * Set the au1000_clock
- */
-void set_au1x00_speed(unsigned int new_freq)
-{
-	au1x00_clock = new_freq;
-}
-
-unsigned int get_au1x00_speed(void)
-{
-	return au1x00_clock;
-}
-EXPORT_SYMBOL(get_au1x00_speed);
-
-/*
- * The UART baud base is not known at compile time ... if
- * we want to be able to use the same code on different
- * speed CPUs.
- */
-unsigned long get_au1x00_uart_baud_base(void)
-{
-	return uart_baud_base;
-}
-
-void set_au1x00_uart_baud_base(unsigned long new_baud_base)
-{
-	uart_baud_base = new_baud_base;
-}
-
-/*
- * We read the real processor speed from the PLL.  This is important
- * because it is more accurate than computing it from the 32 KHz
- * counter, if it exists.  If we don't have an accurate processor
- * speed, all of the peripherals that derive their clocks based on
- * this advertised speed will introduce error and sometimes not work
- * properly.  This function is further convoluted to still allow configurations
- * to do that in case they have really, really old silicon with a
- * write-only PLL register.			-- Dan
- */
-unsigned long au1xxx_calc_clock(void)
-{
-	unsigned long cpu_speed;
-
-	/*
-	 * On early Au1000, sys_cpupll was write-only. Since these
-	 * silicon versions of Au1000 are not sold by AMD, we don't bend
-	 * over backwards trying to determine the frequency.
-	 */
-	if (au1xxx_cpu_has_pll_wo())
-		cpu_speed = 396000000;
-	else
-		cpu_speed = (AU1X_RDSYS(AU1000_SYS_CPUPLL) & 0x0000003f)
-				* AU1000_SRC_CLK;
-
-	/* On Alchemy CPU:counter ratio is 1:1 */
-	mips_hpt_frequency = cpu_speed;
-	/* Equation: Baudrate = CPU / (SD * 2 * CLKDIV * 16) */
-	set_au1x00_uart_baud_base(cpu_speed /
-		(2 * ((AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 0x03) + 2) * 16));
-
-	set_au1x00_speed(cpu_speed);
-
-	return cpu_speed;
-}
diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index 4cdc8fd..3c6fe70 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -11,6 +11,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -99,10 +100,17 @@ static struct platform_device au1xx0_uart_device = {
 
 static void __init alchemy_setup_uarts(int ctype)
 {
-	unsigned int uartclk = get_au1x00_uart_baud_base() * 16;
+	long uartclk;
 	int s = sizeof(struct plat_serial8250_port);
 	int c = alchemy_get_uarts(ctype);
 	struct plat_serial8250_port *ports;
+	struct clk *clk = clk_get(NULL, "periph_clk");
+
+	if (IS_ERR(clk))
+		return;
+
+	uartclk = clk_get_rate(clk);
+	clk_put(clk);
 
 	ports = kzalloc(s * (c + 1), GFP_KERNEL);
 	if (!ports) {
diff --git a/arch/mips/alchemy/common/setup.c b/arch/mips/alchemy/common/setup.c
index 6f8b91d..0e53e6c 100644
--- a/arch/mips/alchemy/common/setup.c
+++ b/arch/mips/alchemy/common/setup.c
@@ -27,31 +27,13 @@
 
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/jiffies.h>
-#include <linux/module.h>
-
 #include <asm/dma-coherence.h>
-#include <asm/mipsregs.h>
-#include <asm/time.h>
-
 #include <asm/mach-au1x00/au1000.h>
 
 extern void __init board_setup(void);
 
 void __init plat_mem_setup(void)
 {
-	unsigned long est_freq;
-
-	/* determine core clock */
-	est_freq = au1xxx_calc_clock();
-	est_freq += 5000;    /* round */
-	est_freq -= est_freq % 10000;
-	printk(KERN_INFO "(PRId %08x) @ %lu.%02lu MHz\n", read_c0_prid(),
-	       est_freq / 1000000, ((est_freq % 1000000) * 100) / 1000000);
-
-	/* this is faster than wasting cycles trying to approximate it */
-	preset_lpj = (est_freq >> 1) / HZ;
-
 	if (au1xxx_cpu_needs_config_od())
 		/* Various early Au1xx0 errata corrected by this */
 		set_c0_config(1 << 19); /* Set Config[OD] */
diff --git a/arch/mips/alchemy/common/usb.c b/arch/mips/alchemy/common/usb.c
index d193dbe..86247a9 100644
--- a/arch/mips/alchemy/common/usb.c
+++ b/arch/mips/alchemy/common/usb.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -407,8 +408,15 @@ static inline void __au1xx0_ohci_control(int enable, unsigned long rb, int creg)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(rb);
 	unsigned long r = __raw_readl(base + creg);
+	struct clk *c = clk_get(NULL, "usbh_clk");
+
+	if (IS_ERR(c))
+		return;
 
 	if (enable) {
+		clk_set_rate(c, 48000000);
+		clk_prepare_enable(c);
+
 		__raw_writel(r | USBHEN_CE, base + creg);
 		wmb();
 		udelay(1000);
@@ -423,7 +431,9 @@ static inline void __au1xx0_ohci_control(int enable, unsigned long rb, int creg)
 	} else {
 		__raw_writel(r & ~(USBHEN_CE | USBHEN_E), base + creg);
 		wmb();
+		clk_disable_unprepare(c);
 	}
+	clk_put(c);
 }
 
 static inline int au1000_usb_control(int block, int enable, unsigned long rb,
diff --git a/arch/mips/alchemy/devboards/db1000.c b/arch/mips/alchemy/devboards/db1000.c
index 6e55bcc..5b4f81b 100644
--- a/arch/mips/alchemy/devboards/db1000.c
+++ b/arch/mips/alchemy/devboards/db1000.c
@@ -19,6 +19,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
@@ -496,6 +497,7 @@ int __init db1000_dev_setup(void)
 	int board = BCSR_WHOAMI_BOARD(bcsr_read(BCSR_WHOAMI));
 	int c0, c1, d0, d1, s0, s1, flashsize = 32,  twosocks = 1;
 	unsigned long pfc;
+	struct clk *c, *p;
 
 	if (board == BCSR_WHOAMI_DB1500) {
 		c0 = AU1500_GPIO2_INT;
@@ -525,6 +527,18 @@ int __init db1000_dev_setup(void)
 		spi_register_board_info(db1100_spi_info,
 					ARRAY_SIZE(db1100_spi_info));
 
+		/* link LCD clock to AUXPLL */
+		p = clk_get(NULL, "auxpll_clk");
+		c = clk_get(NULL, "lcd_intclk");
+		if (!IS_ERR(c) && !IS_ERR(p)) {
+			clk_set_parent(c, p);
+			clk_set_rate(c, clk_get_rate(p));
+		}
+		if (!IS_ERR(c))
+			clk_put(c);
+		if (!IS_ERR(p))
+			clk_put(p);
+
 		platform_add_devices(db1100_devs, ARRAY_SIZE(db1100_devs));
 		platform_device_register(&db1100_spi_dev);
 	} else if (board == BCSR_WHOAMI_DB1000) {
diff --git a/arch/mips/alchemy/devboards/db1200.c b/arch/mips/alchemy/devboards/db1200.c
index 8c71cde..1a80248 100644
--- a/arch/mips/alchemy/devboards/db1200.c
+++ b/arch/mips/alchemy/devboards/db1200.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
@@ -129,7 +130,6 @@ static int __init db1200_detect_board(void)
 
 int __init db1200_board_setup(void)
 {
-	unsigned long freq0, clksrc, div, pfc;
 	unsigned short whoami;
 
 	if (db1200_detect_board())
@@ -149,30 +149,6 @@ int __init db1200_board_setup(void)
 		"  Board-ID %d	Daughtercard ID %d\n", get_system_type(),
 		(whoami >> 4) & 0xf, (whoami >> 8) & 0xf, whoami & 0xf);
 
-	/* SMBus/SPI on PSC0, Audio on PSC1 */
-	pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
-	pfc &= ~(SYS_PINFUNC_P0A | SYS_PINFUNC_P0B);
-	pfc &= ~(SYS_PINFUNC_P1A | SYS_PINFUNC_P1B | SYS_PINFUNC_FS3);
-	pfc |= SYS_PINFUNC_P1C; /* SPI is configured later */
-	AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
-
-	/* Clock configurations: PSC0: ~50MHz via Clkgen0, derived from
-	 * CPU clock; all other clock generators off/unused.
-	 */
-	div = (get_au1x00_speed() + 25000000) / 50000000;
-	if (div & 1)
-		div++;
-	div = ((div >> 1) - 1) & 0xff;
-
-	freq0 = div << SYS_FC_FRDIV0_BIT;
-	AU1X_WRSYS(freq0, AU1000_SYS_FREQCTRL0);
-	freq0 |= SYS_FC_FE0;	/* enable F0 */
-	AU1X_WRSYS(freq0, AU1000_SYS_FREQCTRL0);
-
-	/* psc0_intclk comes 1:1 from F0 */
-	clksrc = SYS_CS_MUX_FQ0 << SYS_CS_ME0_BIT;
-	AU1X_WRSYS(clksrc, AU1000_SYS_CLKSRC);
-
 	return 0;
 }
 
@@ -842,7 +818,8 @@ static int __init pb1200_res_fixup(void)
 
 int __init db1200_dev_setup(void)
 {
-	unsigned long pfc;
+	struct clk *c, *p;
+	unsigned long pfc, freq0;
 	unsigned short sw;
 	int swapped, bid;
 
@@ -857,6 +834,31 @@ int __init db1200_dev_setup(void)
 	irq_set_irq_type(AU1200_GPIO7_INT, IRQ_TYPE_LEVEL_LOW);
 	bcsr_init_irq(DB1200_INT_BEGIN, DB1200_INT_END, AU1200_GPIO7_INT);
 
+	/* SMBus/SPI on PSC0, Audio on PSC1 */
+	pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
+	pfc &= ~(SYS_PINFUNC_P0A | SYS_PINFUNC_P0B);
+	pfc &= ~(SYS_PINFUNC_P1A | SYS_PINFUNC_P1B | SYS_PINFUNC_FS3);
+	pfc |= SYS_PINFUNC_P1C; /* SPI is configured later */
+	AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
+
+	/* get 50MHz for I2C driver on PSC0 */
+	p = clk_get(NULL, "fg0_clk");
+	c = clk_get(NULL, "psc0_intclk");
+	if (!IS_ERR(c) && !IS_ERR(p)) {
+		freq0 = clk_round_rate(p, 50000000);
+		if ((freq0 < 1) || (abs(50000000 - freq0) > 5000000))
+			pr_err("DB1200: cant set EXTCLK0 to 50MHz\n");
+		else {
+			clk_set_rate(p, freq0);
+			clk_set_parent(c, p);
+			clk_set_rate(c, freq0);
+		}
+	}
+	if (!IS_ERR(c))
+		clk_put(c);
+	if (!IS_ERR(p))
+		clk_put(p);
+
 	/* insert/eject pairs: one of both is always screaming.	 To avoid
 	 * issues they must not be automatically enabled when initially
 	 * requested.
diff --git a/arch/mips/include/asm/mach-au1x00/au1000.h b/arch/mips/include/asm/mach-au1x00/au1000.h
index d3b5284..af3cd0d 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000.h
@@ -34,6 +34,22 @@
 #ifndef _AU1000_H_
 #define _AU1000_H_
 
+/* common clock names, shared among all variants. AUXPLL2 is Au1300 */
+#define ALCHEMY_ROOT_CLK		"root_clk"
+#define ALCHEMY_CPU_CLK			"cpu_clk"
+#define ALCHEMY_AUXPLL_CLK		"auxpll_clk"
+#define ALCHEMY_AUXPLL2_CLK		"auxpll2_clk"
+#define ALCHEMY_SYSBUS_CLK		"sysbus_clk"
+#define ALCHEMY_PERIPH_CLK		"periph_clk"
+#define ALCHEMY_MEM_CLK			"mem_clk"
+#define ALCHEMY_LR_CLK			"lr_clk"
+#define ALCHEMY_FG0_CLK			"fg0_clk"
+#define ALCHEMY_FG1_CLK			"fg1_clk"
+#define ALCHEMY_FG2_CLK			"fg2_clk"
+#define ALCHEMY_FG3_CLK			"fg3_clk"
+#define ALCHEMY_FG4_CLK			"fg4_clk"
+#define ALCHEMY_FG5_CLK			"fg5_clk"
+
 
 /* SOC Interrupt numbers */
 /* Au1000-style (IC0/1): 2 controllers with 32 sources each */
@@ -463,69 +479,7 @@
 #define AU1000_SYS_CLKSRC	0x0028
 #define AU1000_SYS_CPUPLL	0x0060
 #define AU1000_SYS_AUXPLL	0x0064
-
-/* SYS_FREQCTRLx bits */
-#  define SYS_FC_FRDIV2_BIT	22
-#  define SYS_FC_FRDIV2_MASK	(0xff << SYS_FC_FRDIV2_BIT)
-#  define SYS_FC_FE2		(1 << 21)
-#  define SYS_FC_FS2		(1 << 20)
-#  define SYS_FC_FRDIV1_BIT	12
-#  define SYS_FC_FRDIV1_MASK	(0xff << SYS_FC_FRDIV1_BIT)
-#  define SYS_FC_FE1		(1 << 11)
-#  define SYS_FC_FS1		(1 << 10)
-#  define SYS_FC_FRDIV0_BIT	2
-#  define SYS_FC_FRDIV0_MASK	(0xff << SYS_FC_FRDIV0_BIT)
-#  define SYS_FC_FE0		(1 << 1)
-#  define SYS_FC_FS0		(1 << 0)
-#  define SYS_FC_FRDIV5_BIT	22
-#  define SYS_FC_FRDIV5_MASK	(0xff << SYS_FC_FRDIV5_BIT)
-#  define SYS_FC_FE5		(1 << 21)
-#  define SYS_FC_FS5		(1 << 20)
-#  define SYS_FC_FRDIV4_BIT	12
-#  define SYS_FC_FRDIV4_MASK	(0xff << SYS_FC_FRDIV4_BIT)
-#  define SYS_FC_FE4		(1 << 11)
-#  define SYS_FC_FS4		(1 << 10)
-#  define SYS_FC_FRDIV3_BIT	2
-#  define SYS_FC_FRDIV3_MASK	(0xff << SYS_FC_FRDIV3_BIT)
-#  define SYS_FC_FE3		(1 << 1)
-#  define SYS_FC_FS3		(1 << 0)
-
-/* SYS_CLKSRC bits */
-#  define SYS_CS_ME1_BIT	27
-#  define SYS_CS_ME1_MASK	(0x7 << SYS_CS_ME1_BIT)
-#  define SYS_CS_DE1		(1 << 26)
-#  define SYS_CS_CE1		(1 << 25)
-#  define SYS_CS_ME0_BIT	22
-#  define SYS_CS_ME0_MASK	(0x7 << SYS_CS_ME0_BIT)
-#  define SYS_CS_DE0		(1 << 21)
-#  define SYS_CS_CE0		(1 << 20)
-#  define SYS_CS_MI2_BIT	17
-#  define SYS_CS_MI2_MASK	(0x7 << SYS_CS_MI2_BIT)
-#  define SYS_CS_DI2		(1 << 16)
-#  define SYS_CS_CI2		(1 << 15)
-#  define SYS_CS_ML_BIT		7
-#  define SYS_CS_ML_MASK	(0x7 << SYS_CS_ML_BIT)
-#  define SYS_CS_DL		(1 << 6)
-#  define SYS_CS_CL		(1 << 5)
-#  define SYS_CS_MUH_BIT	12
-#  define SYS_CS_MUH_MASK	(0x7 << SYS_CS_MUH_BIT)
-#  define SYS_CS_DUH		(1 << 11)
-#  define SYS_CS_CUH		(1 << 10)
-#  define SYS_CS_MUD_BIT	7
-#  define SYS_CS_MUD_MASK	(0x7 << SYS_CS_MUD_BIT)
-#  define SYS_CS_DUD		(1 << 6)
-#  define SYS_CS_CUD		(1 << 5)
-#  define SYS_CS_MIR_BIT	2
-#  define SYS_CS_MIR_MASK	(0x7 << SYS_CS_MIR_BIT)
-#  define SYS_CS_DIR		(1 << 1)
-#  define SYS_CS_CIR		(1 << 0)
-#  define SYS_CS_MUX_AUX	0x1
-#  define SYS_CS_MUX_FQ0	0x2
-#  define SYS_CS_MUX_FQ1	0x3
-#  define SYS_CS_MUX_FQ2	0x4
-#  define SYS_CS_MUX_FQ3	0x5
-#  define SYS_CS_MUX_FQ4	0x6
-#  define SYS_CS_MUX_FQ5	0x7
+#define AU1300_SYS_AUXPLL2	0x0068
 
 
 /* Au15x0 PCI *********************************************************/
@@ -810,13 +764,6 @@ static inline int alchemy_get_macs(int type)
 	return 0;
 }
 
-/* arch/mips/au1000/common/clocks.c */
-extern void set_au1x00_speed(unsigned int new_freq);
-extern unsigned int get_au1x00_speed(void);
-extern void set_au1x00_uart_baud_base(unsigned long new_baud_base);
-extern unsigned long get_au1x00_uart_baud_base(void);
-extern unsigned long au1xxx_calc_clock(void);
-
 /* PM: arch/mips/alchemy/common/sleeper.S, power.c, irq.c */
 void alchemy_sleep_au1000(void);
 void alchemy_sleep_au1550(void);
diff --git a/arch/mips/pci/pci-alchemy.c b/arch/mips/pci/pci-alchemy.c
index 912c5f2..d4dc30a 100644
--- a/arch/mips/pci/pci-alchemy.c
+++ b/arch/mips/pci/pci-alchemy.c
@@ -7,6 +7,7 @@
  * Support for all devices (greater than 16) added by David Gathright.
  */
 
+#include <linux/clk.h>
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -365,6 +366,7 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 	void __iomem *virt_io;
 	unsigned long val;
 	struct resource *r;
+	struct clk *c;
 	int ret;
 
 	/* need at least PCI IRQ mapping table */
@@ -394,11 +396,24 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 		goto out1;
 	}
 
+	c = clk_get(&pdev->dev, "pci_clko");
+	if (IS_ERR(c)) {
+		dev_err(&pdev->dev, "unable to find PCI clock\n");
+		ret = PTR_ERR(c);
+		goto out2;
+	}
+	ret = clk_prepare_enable(c);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot enable PCI clock\n");
+		clk_put(c);
+		goto out2;
+	}
+
 	ctx->regs = ioremap_nocache(r->start, resource_size(r));
 	if (!ctx->regs) {
 		dev_err(&pdev->dev, "cannot map pci regs\n");
 		ret = -ENODEV;
-		goto out2;
+		goto out5;
 	}
 
 	/* map parts of the PCI IO area */
@@ -472,6 +487,9 @@ out4:
 	iounmap(virt_io);
 out3:
 	iounmap(ctx->regs);
+out5:
+	clk_disable_unprepare(c);
+	clk_put(c);
 out2:
 	release_mem_region(r->start, resource_size(r));
 out1:
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 1837309..28bfe5b 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -32,6 +32,7 @@
  * (the low to high transition will not occur).
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -118,6 +119,7 @@ struct au1xmmc_host {
 	struct au1xmmc_platform_data *platdata;
 	struct platform_device *pdev;
 	struct resource *ioarea;
+	struct clk *clk;
 };
 
 /* Status flags used by the host structure */
@@ -596,15 +598,11 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 
 static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 {
-	unsigned int pbus = get_au1x00_speed();
+	unsigned int pbus;
 	unsigned int divisor;
 	u32 config;
 
-	/* From databook:
-	 * divisor = ((((cpuclock / sbus_divisor) / 2) / mmcclock) / 2) - 1
-	 */
-	pbus /= ((AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 0x3) + 2);
-	pbus /= 2;
+	pbus = clk_get_rate(host->clk);
 	divisor = ((pbus / rate) / 2) - 1;
 
 	config = __raw_readl(HOST_CONFIG(host));
@@ -1029,6 +1027,16 @@ static int au1xmmc_probe(struct platform_device *pdev)
 		goto out3;
 	}
 
+	host->clk = clk_get(&pdev->dev, ALCHEMY_PERIPH_CLK);
+	if (IS_ERR(host->clk)) {
+		dev_err(&pdev->dev, "cannot find clock\n");
+		goto out_irq;
+	}
+	if (clk_prepare_enable(host->clk)) {
+		dev_err(&pdev->dev, "cannot enable clock\n");
+		goto out_clk;
+	}
+
 	host->status = HOST_S_IDLE;
 
 	/* board-specific carddetect setup, if any */
@@ -1105,7 +1113,10 @@ out5:
 	if (host->platdata && host->platdata->cd_setup &&
 	    !(mmc->caps & MMC_CAP_NEEDS_POLL))
 		host->platdata->cd_setup(mmc, 0);
-
+out_clk:
+	clk_disable_unprepare(host->clk);
+	clk_put(host->clk);
+out_irq:
 	free_irq(host->irq, host);
 out3:
 	iounmap((void *)host->iobase);
@@ -1147,6 +1158,9 @@ static int au1xmmc_remove(struct platform_device *pdev)
 
 		au1xmmc_set_power(host, 0);
 
+		clk_disable_unprepare(host->clk);
+		clk_put(host->clk);
+
 		free_irq(host->irq, host);
 		iounmap((void *)host->iobase);
 		release_resource(host->ioarea);
diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
index 5f91e3e..aab2cf7 100644
--- a/drivers/net/irda/au1k_ir.c
+++ b/drivers/net/irda/au1k_ir.c
@@ -18,6 +18,7 @@
  *  with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
@@ -175,6 +176,7 @@ struct au1k_private {
 
 	struct resource *ioarea;
 	struct au1k_irda_platform_data *platdata;
+	struct clk *irda_clk;
 };
 
 static int qos_mtt_bits = 0x07;  /* 1 ms or more */
@@ -514,9 +516,39 @@ static irqreturn_t au1k_irda_interrupt(int dummy, void *dev_id)
 static int au1k_init(struct net_device *dev)
 {
 	struct au1k_private *aup = netdev_priv(dev);
-	u32 enable, ring_address;
+	u32 enable, ring_address, phyck;
+	struct clk *c;
 	int i;
 
+	c = clk_get(NULL, "irda_clk");
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+	i = clk_prepare_enable(c);
+	if (i) {
+		clk_put(c);
+		return i;
+	}
+
+	switch (clk_get_rate(c)) {
+	case 40000000:
+		phyck = IR_PHYCLK_40MHZ;
+		break;
+	case 48000000:
+		phyck = IR_PHYCLK_48MHZ;
+		break;
+	case 56000000:
+		phyck = IR_PHYCLK_56MHZ;
+		break;
+	case 64000000:
+		phyck = IR_PHYCLK_64MHZ;
+		break;
+	default:
+		clk_disable_unprepare(c);
+		clk_put(c);
+		return -EINVAL;
+	}
+	aup->irda_clk = c;
+
 	enable = IR_HC | IR_CE | IR_C;
 #ifndef CONFIG_CPU_LITTLE_ENDIAN
 	enable |= IR_BE;
@@ -545,7 +577,7 @@ static int au1k_init(struct net_device *dev)
 	irda_write(aup, IR_RING_SIZE,
 				(RING_SIZE_64 << 8) | (RING_SIZE_64 << 12));
 
-	irda_write(aup, IR_CONFIG_2, IR_PHYCLK_48MHZ | IR_ONE_PIN);
+	irda_write(aup, IR_CONFIG_2, phyck | IR_ONE_PIN);
 	irda_write(aup, IR_RING_ADDR_CMPR, 0);
 
 	au1k_irda_set_speed(dev, 9600);
@@ -619,6 +651,9 @@ static int au1k_irda_stop(struct net_device *dev)
 	free_irq(aup->irq_tx, dev);
 	free_irq(aup->irq_rx, dev);
 
+	clk_disable_unprepare(aup->irda_clk);
+	clk_put(aup->irda_clk);
+
 	return 0;
 }
 
@@ -853,6 +888,7 @@ static int au1k_irda_probe(struct platform_device *pdev)
 	struct au1k_private *aup;
 	struct net_device *dev;
 	struct resource *r;
+	struct clk *c;
 	int err;
 
 	dev = alloc_irdadev(sizeof(struct au1k_private));
@@ -886,6 +922,14 @@ static int au1k_irda_probe(struct platform_device *pdev)
 	if (!aup->ioarea)
 		goto out;
 
+	/* bail out early if clock doesn't exist */
+	c = clk_get(NULL, "irda_clk");
+	if (IS_ERR(c)) {
+		err = PTR_ERR(c);
+		goto out;
+	}
+	clk_put(c);
+
 	aup->iobase = ioremap_nocache(r->start, resource_size(r));
 	if (!aup->iobase)
 		goto out2;
diff --git a/drivers/video/fbdev/au1100fb.c b/drivers/video/fbdev/au1100fb.c
index 2c2804b..82d7b35 100644
--- a/drivers/video/fbdev/au1100fb.c
+++ b/drivers/video/fbdev/au1100fb.c
@@ -434,7 +434,6 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	struct au1100fb_device *fbdev = NULL;
 	struct resource *regs_res;
 	unsigned long page;
-	u32 sys_clksrc;
 
 	/* Allocate new device private */
 	fbdev = devm_kzalloc(&dev->dev, sizeof(struct au1100fb_device),
@@ -506,11 +505,6 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	print_dbg("Framebuffer memory map at %p", fbdev->fb_mem);
 	print_dbg("phys=0x%08x, size=%dK", fbdev->fb_phys, fbdev->fb_len / 1024);
 
-	/* Setup LCD clock to AUX (48 MHz) */
-	sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC) &
-			~(SYS_CS_ML_MASK | SYS_CS_DL | SYS_CS_CL);
-	AU1X_WRSYS((sys_clksrc | (1 << SYS_CS_ML_BIT)), AU1000_SYS_CLKSRC);
-
 	/* load the panel info into the var struct */
 	au1100fb_var.bits_per_pixel = fbdev->panel->bpp;
 	au1100fb_var.xres = fbdev->panel->xres;
@@ -581,7 +575,6 @@ int au1100fb_drv_remove(struct platform_device *dev)
 }
 
 #ifdef CONFIG_PM
-static u32 sys_clksrc;
 static struct au1100fb_regs fbregs;
 
 int au1100fb_drv_suspend(struct platform_device *dev, pm_message_t state)
@@ -591,15 +584,9 @@ int au1100fb_drv_suspend(struct platform_device *dev, pm_message_t state)
 	if (!fbdev)
 		return 0;
 
-	/* Save the clock source state */
-	sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC);
-
 	/* Blank the LCD */
 	au1100fb_fb_blank(VESA_POWERDOWN, &fbdev->info);
 
-	/* Stop LCD clocking */
-	AU1X_WRSYS(sys_clksrc & ~SYS_CS_ML_MASK, AU1000_SYS_CLKSRC);
-
 	memcpy(&fbregs, fbdev->regs, sizeof(struct au1100fb_regs));
 
 	return 0;
@@ -614,9 +601,6 @@ int au1100fb_drv_resume(struct platform_device *dev)
 
 	memcpy(fbdev->regs, &fbregs, sizeof(struct au1100fb_regs));
 
-	/* Restart LCD clocking */
-	AU1X_WRSYS(sys_clksrc, AU1000_SYS_CLKSRC);
-
 	/* Unblank the LCD */
 	au1100fb_fb_blank(VESA_NO_BLANKING, &fbdev->info);
 
-- 
2.0.0

