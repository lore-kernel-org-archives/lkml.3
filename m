Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3LDPdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:33:46 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53257 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab3LDPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:33:38 -0500
Message-ID: <529F4B4F.4020405@linaro.org>
Date: Wed, 04 Dec 2013 09:33:35 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>
CC: "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] clk: bcm281xx: add initial clock framework support
References: <529F4B0F.2020801@linaro.org>
In-Reply-To: <529F4B0F.2020801@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code for device tree support of clocks in the BCM281xx family of
SoCs.  Machines in this family use peripheral clocks implemented by
"Kona" clock control units (CCUs).  (Other Broadcom SoC families use
Kona style CCUs as well, but support for them is not yet upstream.)

A BCM281xx SoC has multiple CCUs, each of which manages a set of
clocks on the SoC.  A Kona peripheral clock is composite clock that
may include a gate, a parent clock multiplexor, and zero, one
or two dividers.  There is a variety of gate types, and many gates
implement hardware-managed gating (often called "auto-gating").
Most dividers divide their input clock signal by an integer value
(one or more).  There are also "fractional" dividers which allow
division by non-integer values.  To accomodate such dividers,
clock rates and dividers are generally maintained by the code in
"scaled" form, which allows integer and fractional dividers to
be handled in a uniform way.

If present, the gate for a Kona peripheral clock must be enabled
when a change is made to its multiplexor or one of its dividers.
Additionally, dividers and multiplexors have trigger registers which
must be used whenever the divider value or selected parent clock is
changed.  The same trigger is often used for a divider and
multiplexor, and a BCM281xx peripheral clock occasionally has two
triggers.

The gate, dividers, and parent clock selector are treated in this
code as "components" of a peripheral clock.  Their functionality is
implemented directly--e.g. the common clock framework gate
implementation is not used for a Kona peripheral clock gate.  (This
has being considered though, and the intention is to evolve this
code to leverage common code as much as possible.)

The source code is divided into three general portions:

    drivers/clk/bcm/clk-kona.h
    drivers/clk/bcm/clk-kona.c
        These implement the basic Kona clock functionality,
        including the clk_ops methods and various routines to
        manipulate registers and interpret their values.  This
        includes some functions used to set clocks to a desired
        initial state (though this feature is only partially
        implemented here).

    drivers/clk/bcm/clk-kona-setup.c
        This contains generic run-time initialization code for
        data structures representing Kona CCUs and clocks.  This
        encapsulates the clock structure initialization that can't
        be done statically.  Note that there is a great deal of
        validity-checking code here, making explicit certain
        assumptions in the code.   This is mostly useful for adding
        new clock definitions and could possibly be disabled for
        production use.

    drivers/clk/bcm/clk-bcm281xx.c
        This file defines the specific CCUs used by BCM281XX family
        SoCs, as well as the specific clocks implemented by each.
        It declares a device tree clock match entry for each CCU
        defined.

    include/dt-bindings/clock/bcm281xx.h
        This file defines the selector (index) values used to
        identify a particular clock provided by a CCU.  It consists
        entirely of C preprocessor constants, to be used by both the
        C source and device tree source files.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
v2: - ccu->name is now allocated with kstrdup()
    - new function ccu_clks_teardown() now reverses what the
      ccu_clks_setup() callback function does
    - no longer restrict CCU address space offset to 32 bits
    - error code no longer printed when CCU setup is aborted
    - ensure number of billionths is *less* than a billion
    - define U32_MAX, etc. unconditionally

 drivers/clk/Kconfig                  |    1 +
 drivers/clk/Makefile                 |    1 +
 drivers/clk/bcm/Kconfig              |    8 +
 drivers/clk/bcm/Makefile             |    3 +
 drivers/clk/bcm/clk-bcm281xx.c       |  416 ++++++++++++++
 drivers/clk/bcm/clk-kona-setup.c     |  769 +++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.c           | 1033
++++++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h           |  414 ++++++++++++++
 include/dt-bindings/clock/bcm281xx.h |   65 +++
 9 files changed, 2710 insertions(+)
 create mode 100644 drivers/clk/bcm/Kconfig
 create mode 100644 drivers/clk/bcm/Makefile
 create mode 100644 drivers/clk/bcm/clk-bcm281xx.c
 create mode 100644 drivers/clk/bcm/clk-kona-setup.c
 create mode 100644 drivers/clk/bcm/clk-kona.c
 create mode 100644 drivers/clk/bcm/clk-kona.h
 create mode 100644 include/dt-bindings/clock/bcm281xx.h

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 5c51115..dbc7985 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -110,3 +110,4 @@ config COMMON_CLK_KEYSTONE
 endmenu

 source "drivers/clk/mvebu/Kconfig"
+source "drivers/clk/bcm/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7a10bc9..93b3bac 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_COMMON_CLK_XGENE)  += clk-xgene.o
 obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+= keystone/

 obj-$(CONFIG_X86)		+= x86/
+obj-$(CONFIG_ARCH_BCM)		+= bcm/

 # Chip specific
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) += clk-axi-clkgen.o
diff --git a/drivers/clk/bcm/Kconfig b/drivers/clk/bcm/Kconfig
new file mode 100644
index 0000000..505a31f
--- /dev/null
+++ b/drivers/clk/bcm/Kconfig
@@ -0,0 +1,8 @@
+config CLK_BCM_KONA
+	bool "Broadcom Kona CCU clock support"
+	depends on ARCH_BCM_MOBILE
+	default y
+	help
+	  Enable common clock framework support for Broadcom SoCs
+	  using "Kona" style clock control units, including those
+	  in the BCM281xx family.
diff --git a/drivers/clk/bcm/Makefile b/drivers/clk/bcm/Makefile
new file mode 100644
index 0000000..cf93359
--- /dev/null
+++ b/drivers/clk/bcm/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona.o
+obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona-setup.o
+obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm281xx.o
diff --git a/drivers/clk/bcm/clk-bcm281xx.c b/drivers/clk/bcm/clk-bcm281xx.c
new file mode 100644
index 0000000..166c7ff
--- /dev/null
+++ b/drivers/clk/bcm/clk-bcm281xx.c
@@ -0,0 +1,416 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ * Copyright 2013 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "clk-kona.h"
+#include "dt-bindings/clock/bcm281xx.h"
+
+/* bcm11351 CCU device tree "compatible" strings */
+#define BCM11351_DT_ROOT_CCU_COMPAT	"brcm,bcm11351-root-ccu"
+#define BCM11351_DT_AON_CCU_COMPAT	"brcm,bcm11351-aon-ccu"
+#define BCM11351_DT_HUB_CCU_COMPAT	"brcm,bcm11351-hub-ccu"
+#define BCM11351_DT_MASTER_CCU_COMPAT	"brcm,bcm11351-master-ccu"
+#define BCM11351_DT_SLAVE_CCU_COMPAT	"brcm,bcm11351-slave-ccu"
+
+/* Root CCU clocks */
+
+static struct peri_clk_data frac_1m_data = {
+	.gate		= HW_SW_GATE(0x214, 16, 0, 1),
+	.trig		= TRIGGER(0x0e04, 0),
+	.div		= FRAC_DIVIDER(0x0e00, 0, 22, 16),
+	.clocks		= CLOCKS("ref_crystal"),
+};
+
+/* AON CCU clocks */
+
+static struct peri_clk_data hub_timer_data = {
+	.gate		= HW_SW_GATE(0x0414, 16, 0, 1),
+	.clocks		= CLOCKS("bbl_32k",
+				 "frac_1m",
+				 "dft_19_5m"),
+	.sel		= SELECTOR(0x0a10, 0, 2),
+	.trig		= TRIGGER(0x0a40, 4),
+};
+
+static struct peri_clk_data pmu_bsc_data = {
+	.gate		= HW_SW_GATE(0x0418, 16, 0, 1),
+	.clocks		= CLOCKS("ref_crystal",
+				 "pmu_bsc_var_clk",
+				 "bbl_32k"),
+	.sel		= SELECTOR(0x0a04, 0, 2),
+	.div		= DIVIDER(0x0a04, 3, 4),
+	.trig		= TRIGGER(0x0a40, 0),
+};
+
+static struct peri_clk_data pmu_bsc_var_data = {
+	.clocks		= CLOCKS("var_312m",
+				 "ref_312m"),
+	.sel		= SELECTOR(0x0a00, 0, 2),
+	.div		= DIVIDER(0x0a00, 4, 5),
+	.trig		= TRIGGER(0x0a40, 2),
+};
+
+/* Hub CCU clocks */
+
+static struct peri_clk_data tmon_1m_data = {
+	.gate		= HW_SW_GATE(0x04a4, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "frac_1m"),
+	.sel		= SELECTOR(0x0e74, 0, 2),
+	.trig		= TRIGGER(0x0e84, 1),
+};
+
+/* Master CCU clocks */
+
+static struct peri_clk_data sdio1_data = {
+	.gate		= HW_SW_GATE(0x0358, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a28, 0, 3),
+	.div		= DIVIDER(0x0a28, 4, 14),
+	.trig		= TRIGGER(0x0afc, 9),
+};
+
+static struct peri_clk_data sdio2_data = {
+	.gate		= HW_SW_GATE(0x035c, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a2c, 0, 3),
+	.div		= DIVIDER(0x0a2c, 4, 14),
+	.trig		= TRIGGER(0x0afc, 10),
+};
+
+static struct peri_clk_data sdio3_data = {
+	.gate		= HW_SW_GATE(0x0364, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a34, 0, 3),
+	.div		= DIVIDER(0x0a34, 4, 14),
+	.trig		= TRIGGER(0x0afc, 12),
+};
+
+static struct peri_clk_data sdio4_data = {
+	.gate		= HW_SW_GATE(0x0360, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a30, 0, 3),
+	.div		= DIVIDER(0x0a30, 4, 14),
+	.trig		= TRIGGER(0x0afc, 11),
+};
+
+static struct peri_clk_data usb_ic_data = {
+	.gate		= HW_SW_GATE(0x0354, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_96m",
+				 "ref_96m"),
+	.div		= FIXED_DIVIDER(2),
+	.sel		= SELECTOR(0x0a24, 0, 2),
+	.trig		= TRIGGER(0x0afc, 7),
+};
+
+/* also called usbh_48m */
+static struct peri_clk_data hsic2_48m_data = {
+	.gate		= HW_SW_GATE(0x0370, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a38, 0, 2),
+	.div		= FIXED_DIVIDER(2),
+	.trig		= TRIGGER(0x0afc, 5),
+};
+
+/* also called usbh_12m */
+static struct peri_clk_data hsic2_12m_data = {
+	.gate		= HW_SW_GATE(0x0370, 20, 4, 5),
+	.div		= DIVIDER(0x0a38, 12, 2),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_96m",
+				 "ref_96m"),
+	.pre_div	= FIXED_DIVIDER(2),
+	.sel		= SELECTOR(0x0a38, 0, 2),
+	.trig		= TRIGGER(0x0afc, 5),
+};
+
+/* Slave CCU clocks */
+
+static struct peri_clk_data uartb_data = {
+	.gate		= HW_SW_GATE(0x0400, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a10, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a10, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 2),
+};
+
+static struct peri_clk_data uartb2_data = {
+	.gate		= HW_SW_GATE(0x0404, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a14, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a14, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 3),
+};
+
+static struct peri_clk_data uartb3_data = {
+	.gate		= HW_SW_GATE(0x0408, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a18, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a18, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 4),
+};
+
+static struct peri_clk_data uartb4_data = {
+	.gate		= HW_SW_GATE(0x0408, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a1c, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a1c, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 5),
+};
+
+static struct peri_clk_data ssp0_data = {
+	.gate		= HW_SW_GATE(0x0410, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a20, 0, 3),
+	.div		= DIVIDER(0x0a20, 4, 14),
+	.trig		= TRIGGER(0x0afc, 6),
+};
+
+static struct peri_clk_data ssp2_data = {
+	.gate		= HW_SW_GATE(0x0418, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a28, 0, 3),
+	.div		= DIVIDER(0x0a28, 4, 14),
+	.trig		= TRIGGER(0x0afc, 8),
+};
+
+static struct peri_clk_data bsc1_data = {
+	.gate		= HW_SW_GATE(0x0458, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a64, 0, 3),
+	.trig		= TRIGGER(0x0afc, 23),
+};
+
+static struct peri_clk_data bsc2_data = {
+	.gate		= HW_SW_GATE(0x045c, 18, 2, 3),
+	.clocks	= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a68, 0, 3),
+	.trig		= TRIGGER(0x0afc, 24),
+};
+
+static struct peri_clk_data bsc3_data = {
+	.gate		= HW_SW_GATE(0x0484, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a84, 0, 3),
+	.trig		= TRIGGER(0x0b00, 2),
+};
+
+static struct peri_clk_data pwm_data = {
+	.gate		= HW_SW_GATE(0x0468, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m"),
+	.sel		= SELECTOR(0x0a70, 0, 2),
+	.div		= DIVIDER(0x0a70, 4, 3),
+	.trig		= TRIGGER(0x0afc, 15),
+};
+
+/*
+ * CCU setup routines
+ *
+ * These are called from kona_dt_ccu_setup() to initialize the array
+ * of clocks provided by the CCU.  Once allocated, the entries in
+ * the array are initialized by calling kona_clk_setup() with the
+ * initialization data for each clock.  They return 0 if successful
+ * or an error code otherwise.
+ */
+static int __init bcm281xx_root_ccu_clks_setup(struct ccu_data *ccu)
+{
+	struct clk **clks;
+	size_t count = BCM281XX_ROOT_CCU_CLOCK_COUNT;
+
+	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
+	if (!clks) {
+		pr_err("%s: failed to allocate root clocks\n", __func__);
+		return -ENOMEM;
+	}
+	ccu->data.clks = clks;
+	ccu->data.clk_num = count;
+
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_ROOT_CCU_FRAC_1M, frac_1m);
+
+	return 0;
+}
+
+static int __init bcm281xx_aon_ccu_clks_setup(struct ccu_data *ccu)
+{
+	struct clk **clks;
+	size_t count = BCM281XX_AON_CCU_CLOCK_COUNT;
+
+	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
+	if (!clks) {
+		pr_err("%s: failed to allocate aon clocks\n", __func__);
+		return -ENOMEM;
+	}
+	ccu->data.clks = clks;
+	ccu->data.clk_num = count;
+
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_AON_CCU_HUB_TIMER, hub_timer);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_AON_CCU_PMU_BSC, pmu_bsc);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_AON_CCU_PMU_BSC_VAR, pmu_bsc_var);
+
+	return 0;
+}
+
+static int __init bcm281xx_hub_ccu_clks_setup(struct ccu_data *ccu)
+{
+	struct clk **clks;
+	size_t count = BCM281XX_HUB_CCU_CLOCK_COUNT;
+
+	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
+	if (!clks) {
+		pr_err("%s: failed to allocate hub clocks\n", __func__);
+		return -ENOMEM;
+	}
+	ccu->data.clks = clks;
+	ccu->data.clk_num = count;
+
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_HUB_CCU_TMON_1M, tmon_1m);
+
+	return 0;
+}
+
+static int __init bcm281xx_master_ccu_clks_setup(struct ccu_data *ccu)
+{
+	struct clk **clks;
+	size_t count = BCM281XX_MASTER_CCU_CLOCK_COUNT;
+
+	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
+	if (!clks) {
+		pr_err("%s: failed to allocate master clocks\n", __func__);
+		return -ENOMEM;
+	}
+	ccu->data.clks = clks;
+	ccu->data.clk_num = count;
+
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO1, sdio1);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO2, sdio2);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO3, sdio3);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_SDIO4, sdio4);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_USB_IC, usb_ic);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_HSIC2_48M, hsic2_48m);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_MASTER_CCU_HSIC2_12M, hsic2_12m);
+
+	return 0;
+}
+
+static int __init bcm281xx_slave_ccu_clks_setup(struct ccu_data *ccu)
+{
+	struct clk **clks;
+	size_t count = BCM281XX_SLAVE_CCU_CLOCK_COUNT;
+
+	clks = kzalloc(count * sizeof(*clks), GFP_KERNEL);
+	if (!clks) {
+		pr_err("%s: failed to allocate slave clocks\n", __func__);
+		return -ENOMEM;
+	}
+	ccu->data.clks = clks;
+	ccu->data.clk_num = count;
+
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB, uartb);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB2, uartb2);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB3, uartb3);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_UARTB4, uartb4);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_SSP0, ssp0);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_SSP2, ssp2);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_BSC1, bsc1);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_BSC2, bsc2);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_BSC3, bsc3);
+	PERI_CLK_SETUP(clks, ccu, BCM281XX_SLAVE_CCU_PWM, pwm);
+
+	return 0;
+}
+
+/* Device tree match table callback functions */
+
+static void __init kona_dt_root_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(node, bcm281xx_root_ccu_clks_setup);
+}
+
+static void __init kona_dt_aon_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(node, bcm281xx_aon_ccu_clks_setup);
+}
+
+static void __init kona_dt_hub_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(node, bcm281xx_hub_ccu_clks_setup);
+}
+
+static void __init kona_dt_master_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(node, bcm281xx_master_ccu_clks_setup);
+}
+
+static void __init kona_dt_slave_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(node, bcm281xx_slave_ccu_clks_setup);
+}
+
+CLK_OF_DECLARE(bcm11351_root_ccu, BCM11351_DT_ROOT_CCU_COMPAT,
+			kona_dt_root_ccu_setup);
+CLK_OF_DECLARE(bcm11351_aon_ccu, BCM11351_DT_AON_CCU_COMPAT,
+			kona_dt_aon_ccu_setup);
+CLK_OF_DECLARE(bcm11351_hub_ccu, BCM11351_DT_HUB_CCU_COMPAT,
+			kona_dt_hub_ccu_setup);
+CLK_OF_DECLARE(bcm11351_master_ccu, BCM11351_DT_MASTER_CCU_COMPAT,
+			kona_dt_master_ccu_setup);
+CLK_OF_DECLARE(bcm11351_slave_ccu, BCM11351_DT_SLAVE_CCU_COMPAT,
+			kona_dt_slave_ccu_setup);
diff --git a/drivers/clk/bcm/clk-kona-setup.c
b/drivers/clk/bcm/clk-kona-setup.c
new file mode 100644
index 0000000..f1e88fe
--- /dev/null
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -0,0 +1,769 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ * Copyright 2013 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/io.h>
+#include <linux/of_address.h>
+
+#include "clk-kona.h"
+
+/* These are used when a selector or trigger is found to be unneeded */
+#define selector_clear_exists(sel)	((sel)->width = 0)
+#define trigger_clear_exists(trig)	FLAG_CLEAR(trig, TRIG, EXISTS)
+
+LIST_HEAD(ccu_list);	/* The list of set up CCUs */
+
+/* Validity checking */
+
+static bool clk_requires_trigger(struct kona_clk *bcm_clk)
+{
+	struct peri_clk_data *peri = bcm_clk->peri;
+	struct bcm_clk_sel *sel;
+	struct bcm_clk_div *div;
+
+	if (bcm_clk->type != bcm_clk_peri)
+		return false;
+
+	sel = &peri->sel;
+	if (sel->parent_count && selector_exists(sel))
+		return true;
+
+	div = &peri->div;
+	if (!divider_exists(div))
+		return false;
+
+	/* Fixed dividers don't need triggers */
+	if (!divider_is_fixed(div))
+		return true;
+
+	div = &peri->pre_div;
+
+	return divider_exists(div) && !divider_is_fixed(div);
+}
+
+static bool peri_clk_data_offsets_valid(struct kona_clk *bcm_clk)
+{
+	struct peri_clk_data *peri;
+	struct bcm_clk_gate *gate;
+	struct bcm_clk_div *div;
+	struct bcm_clk_sel *sel;
+	struct bcm_clk_trig *trig;
+	const char *name;
+	u32 range;
+	u32 limit;
+
+	BUG_ON(bcm_clk->type != bcm_clk_peri);
+	peri = bcm_clk->peri;
+	name = bcm_clk->name;
+	range = bcm_clk->ccu->range;
+
+	limit = range - sizeof(u32);
+	limit = round_down(limit, sizeof(u32));
+
+	gate = &peri->gate;
+	if (gate_exists(gate)) {
+		if (gate->offset > limit) {
+			pr_err("%s: bad gate offset for %s (%u > %u)\n",
+				__func__, name, gate->offset, limit);
+			return false;
+		}
+	}
+
+	div = &peri->div;
+	if (divider_exists(div)) {
+		if (div->offset > limit) {
+			pr_err("%s: bad divider offset for %s (%u > %u)\n",
+				__func__, name, div->offset, limit);
+			return false;
+		}
+	}
+
+	div = &peri->pre_div;
+	if (divider_exists(div)) {
+		if (div->offset > limit) {
+			pr_err("%s: bad pre-divider offset for %s "
+					"(%u > %u)\n",
+				__func__, name, div->offset, limit);
+			return false;
+		}
+	}
+
+	sel = &peri->sel;
+	if (selector_exists(sel)) {
+		if (sel->offset > limit) {
+			pr_err("%s: bad selector offset for %s (%u > %u)\n",
+				__func__, name, sel->offset, limit);
+			return false;
+		}
+	}
+
+	trig = &peri->trig;
+	if (trigger_exists(trig)) {
+		if (trig->offset > limit) {
+			pr_err("%s: bad trigger offset for %s (%u > %u)\n",
+				__func__, name, trig->offset, limit);
+			return false;
+		}
+	}
+
+	trig = &peri->pre_trig;
+	if (trigger_exists(trig)) {
+		if (trig->offset > limit) {
+			pr_err("%s: bad pre-trigger offset for %s (%u > %u)\n",
+				__func__, name, trig->offset, limit);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/* A bit position must be less than the number of bits in a 32-bit
register. */
+static bool bit_posn_valid(u32 bit_posn, const char *field_name,
+			const char *clock_name)
+{
+	u32 limit = BITS_PER_BYTE * sizeof(u32) - 1;
+
+	if (bit_posn > limit) {
+		pr_err("%s: bad %s bit for %s (%u > %u)\n", __func__,
+			field_name, clock_name, bit_posn, limit);
+		return false;
+	}
+	return true;
+}
+
+/*
+ * A bitfield must be at least 1 bit wide.  Both the low-order and
+ * high-order bits must lie within a 32-bit register.  We require
+ * fields to be less than 32 bits wide, mainly because we use
+ * shifting to produce field masks, and shifting a full word width
+ * is not well-defined by the C standard.
+ */
+static bool bitfield_valid(u32 shift, u32 width, const char *field_name,
+			const char *clock_name)
+{
+	u32 limit = BITS_PER_BYTE * sizeof(u32);
+
+	if (!width) {
+		pr_err("%s: bad %s field width 0 for %s\n", __func__,
+			field_name, clock_name);
+		return false;
+	}
+	if (shift + width > limit) {
+		pr_err("%s: bad %s for %s (%u + %u > %u)\n", __func__,
+			field_name, clock_name, shift, width, limit);
+		return false;
+	}
+	return true;
+}
+
+/*
+ * All gates, if defined, have a status bit, and for hardware-only
+ * gates, that's it.  Gates that can be software controlled also
+ * have an enable bit.  And a gate that can be hardware or software
+ * controlled will have a hardware/software select bit.
+ */
+static bool gate_valid(struct bcm_clk_gate *gate, const char *field_name,
+			const char *clock_name)
+{
+	if (!bit_posn_valid(gate->status_bit, "gate status", clock_name))
+		return false;
+
+	if (gate_is_sw_controllable(gate)) {
+		if (!bit_posn_valid(gate->en_bit, "gate enable", clock_name))
+			return false;
+
+		if (gate_is_hw_controllable(gate)) {
+			if (!bit_posn_valid(gate->hw_sw_sel_bit,
+						"gate hw/sw select",
+						clock_name))
+				return false;
+		}
+	} else {
+		BUG_ON(!gate_is_hw_controllable(gate));
+	}
+
+	return true;
+}
+
+/*
+ * A selector bitfield must be valid.  Its parent_sel array must
+ * also be reasonable for the field.
+ */
+static bool sel_valid(struct bcm_clk_sel *sel, const char *field_name,
+			const char *clock_name)
+{
+	if (!bitfield_valid(sel->shift, sel->width, field_name, clock_name))
+		return false;
+
+	if (sel->parent_count) {
+		u32 max_sel;
+		u32 limit;
+
+		/*
+		 * Make sure the selector field can hold all the
+		 * selector values we expect to be able to use.  A
+		 * clock only needs to have a selector defined if it
+		 * has more than one parent.  And in that case the
+		 * highest selector value will be in the last entry
+		 * in the array.
+		 */
+		max_sel = sel->parent_sel[sel->parent_count - 1];
+		limit = (1 << sel->width) - 1;
+		if (max_sel > limit) {
+			pr_err("%s: bad selector for %s "
+					"(%u needs > %u bits)\n",
+				__func__, clock_name, max_sel,
+				sel->width);
+			return false;
+		}
+	} else {
+		pr_warn("%s: ignoring selector for %s (no parents)\n",
+			__func__, clock_name);
+		selector_clear_exists(sel);
+		kfree(sel->parent_sel);
+		sel->parent_sel = NULL;
+	}
+
+	return true;
+}
+
+/*
+ * A fixed divider just needs to be non-zero.  A variable divider
+ * has to have a valid divider bitfield, and if it has a fraction,
+ * the width of the fraction must not be no more than the width of
+ * the divider as a whole.
+ */
+static bool div_valid(struct bcm_clk_div *div, const char *field_name,
+			const char *clock_name)
+{
+	if (divider_is_fixed(div)) {
+		/* Any fixed divider value but 0 is OK */
+		if (div->fixed == 0) {
+			pr_err("%s: bad %s fixed value 0 for %s\n", __func__,
+				field_name, clock_name);
+			return false;
+		}
+		return true;
+	}
+	if (!bitfield_valid(div->shift, div->width, field_name, clock_name))
+		return false;
+
+	if (divider_has_fraction(div))
+		if (div->frac_width > div->width) {
+			pr_warn("%s: bad %s fraction width for %s (%u > %u)\n",
+				__func__, field_name, clock_name,
+				div->frac_width, div->width);
+			return false;
+		}
+
+	return true;
+}
+
+/*
+ * If a clock has two dividers, the combined number of fractional
+ * bits must be representable in a 32-bit unsigned value.  This
+ * is because we scale up a dividend using both dividers before
+ * dividing to improve accuracy, and we need to avoid overflow.
+ */
+static bool kona_dividers_valid(struct kona_clk *bcm_clk)
+{
+	struct peri_clk_data *peri = bcm_clk->peri;
+	struct bcm_clk_div *div;
+	struct bcm_clk_div *pre_div;
+	u32 limit;
+
+	BUG_ON(bcm_clk->type != bcm_clk_peri);
+
+	if (!divider_exists(&peri->div) || !divider_exists(&peri->pre_div))
+		return true;
+
+	div = &peri->div;
+	pre_div = &peri->pre_div;
+	if (divider_is_fixed(div) || divider_is_fixed(pre_div))
+		return true;
+
+	limit = BITS_PER_BYTE * sizeof(u32);
+
+	return div->frac_width + pre_div->frac_width <= limit;
+}
+
+
+/* A trigger just needs to represent a valid bit position */
+static bool trig_valid(struct bcm_clk_trig *trig, const char *field_name,
+			const char *clock_name)
+{
+	return bit_posn_valid(trig->bit, field_name, clock_name);
+}
+
+/* Determine whether the set of peripheral clock registers are valid. */
+static bool
+peri_clk_data_valid(struct kona_clk *bcm_clk)
+{
+	struct peri_clk_data *peri;
+	struct bcm_clk_gate *gate;
+	struct bcm_clk_sel *sel;
+	struct bcm_clk_div *div;
+	struct bcm_clk_div *pre_div;
+	struct bcm_clk_trig *trig;
+	const char *name;
+
+	BUG_ON(bcm_clk->type != bcm_clk_peri);
+
+	/*
+	 * First validate register offsets.  This is the only place
+	 * where we need something from the ccu, so we do these
+	 * together.
+	 */
+	if (!peri_clk_data_offsets_valid(bcm_clk))
+		return false;
+
+	peri = bcm_clk->peri;
+	name = bcm_clk->name;
+	gate = &peri->gate;
+	if (gate_exists(gate) && !gate_valid(gate, "gate", name))
+		return false;
+
+	sel = &peri->sel;
+	if (selector_exists(sel)) {
+		if (!sel_valid(sel, "selector", name))
+			return false;
+
+	} else if (sel->parent_count > 1) {
+		pr_err("%s: multiple parents but no selector for %s\n",
+			__func__, name);
+
+		return false;
+	}
+
+	div = &peri->div;
+	pre_div = &peri->pre_div;
+	if (divider_exists(div)) {
+		if (!div_valid(div, "divider", name))
+			return false;
+
+		if (divider_exists(pre_div))
+			if (!div_valid(pre_div, "pre-divider", name))
+				return false;
+	} else if (divider_exists(pre_div)) {
+		pr_err("%s: pre-divider but no divider for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	trig = &peri->trig;
+	if (trigger_exists(trig)) {
+		if (!trig_valid(trig, "trigger", name))
+			return false;
+
+		if (trigger_exists(&peri->pre_trig)) {
+			if (!trig_valid(trig, "pre-trigger", name)) {
+				return false;
+			}
+		}
+		if (!clk_requires_trigger(bcm_clk)) {
+			pr_warn("%s: ignoring trigger for %s (not needed)\n",
+				__func__, name);
+			trigger_clear_exists(trig);
+		}
+	} else if (trigger_exists(&peri->pre_trig)) {
+		pr_err("%s: pre-trigger but no trigger for %s\n", __func__,
+			name);
+		return false;
+	} else if (clk_requires_trigger(bcm_clk)) {
+		pr_err("%s: required trigger missing for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	return kona_dividers_valid(bcm_clk);
+}
+
+static bool kona_clk_valid(struct kona_clk *bcm_clk)
+{
+	switch (bcm_clk->type) {
+	case bcm_clk_peri:
+		if (!peri_clk_data_valid(bcm_clk))
+			return false;
+		break;
+	default:
+		pr_err("%s: unrecognized clock type (%d)\n", __func__,
+			(int)bcm_clk->type);
+		return false;
+	}
+	return true;
+}
+
+/*
+ * Scan an array of parent clock names to determine whether there
+ * are any entries containing BAD_CLK_NAME.  Such entries are
+ * placeholders for non-supported clocks.  Keep track of the
+ * position of each clock name in the original array.
+ *
+ * Allocates an array of pointers to to hold the names of all
+ * non-null entries in the original array, and returns a pointer to
+ * that array in *names.  This will be used for registering the
+ * clock with the common clock code.  On successful return,
+ * *count indicates how many entries are in that names array.
+ *
+ * If there is more than one entry in the resulting names array,
+ * another array is allocated to record the parent selector value
+ * for each (defined) parent clock.  This is the value that
+ * represents this parent clock in the clock's source selector
+ * register.  The position of the clock in the original parent array
+ * defines that selector value.  The number of entries in this array
+ * is the same as the number of entries in the parent names array.
+ *
+ * The array of selector values is returned.  If the clock has no
+ * parents, no selector is required and a null pointer is returned.
+ *
+ * Returns a null pointer if the clock names array supplied was
+ * null.  (This is not an error.)
+ *
+ * Returns a pointer-coded error if an error occurs.
+ */
+static u32 *parent_process(const char *clocks[],
+			u32 *count, const char ***names)
+{
+	static const char **parent_names;
+	static u32 *parent_sel;
+	const char **clock;
+	u32 parent_count;
+	u32 bad_count = 0;
+	u32 orig_count;
+	u32 i;
+	u32 j;
+
+	*count = 0;	/* In case of early return */
+	*names = NULL;
+	if (!clocks)
+		return NULL;
+
+	/*
+	 * Count the number of names in the null-terminated array,
+	 * and find out how many of those are actually clock names.
+	 */
+	for (clock = clocks; *clock; clock++)
+		if (*clock == BAD_CLK_NAME)
+			bad_count++;
+	orig_count = (u32)(clock - clocks);
+	parent_count = orig_count - bad_count;
+
+	/* If all clocks are unsupported, we treat it as no clock */
+	if (!parent_count)
+		return NULL;
+
+	/* Avoid exceeding our parent clock limit */
+	if (parent_count > PARENT_COUNT_MAX) {
+		pr_err("%s: too many parents (%u > %u)\n", __func__,
+			parent_count, PARENT_COUNT_MAX);
+		return ERR_PTR(-EINVAL);
+	}
+
+	/*
+	 * There is one parent name for each defined parent clock.
+	 * We also maintain an array containing the selector value
+	 * for each defined clock.  If there's only one clock, the
+	 * selector is not required, but we allocate space for the
+	 * array anyway to keep things simple.
+	 */
+	parent_names = kmalloc(parent_count * sizeof(parent_names), GFP_KERNEL);
+	if (!parent_names) {
+		pr_err("%s: error allocating %u parent names\n", __func__,
+				parent_count);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* There is at least one parent, so allocate a selector array */
+
+	parent_sel = kmalloc(parent_count * sizeof(*parent_sel), GFP_KERNEL);
+	if (!parent_sel) {
+		pr_err("%s: error allocating %u parent selectors\n", __func__,
+				parent_count);
+		kfree(parent_names);
+
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Now fill in the parent names and selector arrays */
+	for (i = 0, j = 0; i < orig_count; i++) {
+		if (clocks[i] != BAD_CLK_NAME) {
+			parent_names[j] = clocks[i];
+			parent_sel[j] = i;
+			j++;
+		}
+	}
+	*names = parent_names;
+	*count = parent_count;
+
+	return parent_sel;
+}
+
+static int
+clk_sel_setup(const char **clocks, struct bcm_clk_sel *sel,
+		struct clk_init_data *init_data)
+{
+	const char **parent_names = NULL;
+	u32 parent_count = 0;
+	u32 *parent_sel;
+
+	/*
+	 * If a peripheral clock has multiple parents, the value
+	 * used by the hardware to select that parent is represented
+	 * by the parent clock's position in the "clocks" list.  Some
+	 * values don't have defined or supported clocks; these will
+	 * have BAD_CLK_NAME entries in the parents[] array.  The
+	 * list is terminated by a NULL entry.
+	 *
+	 * We need to supply (only) the names of defined parent
+	 * clocks when registering a clock though, so we use an
+	 * array of parent selector values to map between the
+	 * indexes the common clock code uses and the selector
+	 * values we need.
+	 */
+	parent_sel = parent_process(clocks, &parent_count, &parent_names);
+	if (IS_ERR(parent_sel)) {
+		int ret = PTR_ERR(parent_sel);
+
+		pr_err("%s: error processing parent clocks for %s (%d)\n",
+			__func__, init_data->name, ret);
+
+		return ret;
+	}
+
+	init_data->parent_names = parent_names;
+	init_data->num_parents = parent_count;
+
+	sel->parent_count = parent_count;
+	sel->parent_sel = parent_sel;
+
+	return 0;
+}
+
+static void clk_sel_teardown(struct bcm_clk_sel *sel,
+		struct clk_init_data *init_data)
+{
+	kfree(sel->parent_sel);
+	sel->parent_sel = NULL;
+	sel->parent_count = 0;
+
+	init_data->num_parents = 0;
+	kfree(init_data->parent_names);
+	init_data->parent_names = NULL;
+}
+
+static void peri_clk_teardown(struct peri_clk_data *data,
+				struct clk_init_data *init_data)
+{
+	clk_sel_teardown(&data->sel, init_data);
+	init_data->ops = NULL;
+}
+
+/*
+ * Caller is responsible for freeing the parent_names[] and
+ * parent_sel[] arrays in the peripheral clock's "data" structure
+ * that can be assigned if the clock has one or more parent clocks
+ * associated with it.
+ */
+static int peri_clk_setup(struct ccu_data *ccu, struct peri_clk_data *data,
+			struct clk_init_data *init_data)
+{
+	init_data->ops = &kona_peri_clk_ops;
+	init_data->flags = 0;
+
+	return clk_sel_setup(data->clocks, &data->sel, init_data);
+}
+
+static void bcm_clk_teardown(struct kona_clk *bcm_clk)
+{
+	switch (bcm_clk->type) {
+	case bcm_clk_peri:
+		peri_clk_teardown(bcm_clk->data, &bcm_clk->init_data);
+		break;
+	default:
+		break;
+	}
+	bcm_clk->data = NULL;
+	bcm_clk->type = bcm_clk_none;
+}
+
+static void kona_clk_teardown(struct clk *clk)
+{
+	struct clk_hw *hw;
+	struct kona_clk *bcm_clk;
+
+	if (!clk)
+		return;
+
+	hw = __clk_get_hw(clk);
+	if (!hw) {
+		pr_err("%s: clk %p has null hw pointer\n", __func__, clk);
+		return;
+	}
+	clk_unregister(clk);
+
+	bcm_clk = to_kona_clk(hw);
+	bcm_clk_teardown(bcm_clk);
+}
+
+struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
+			enum bcm_clk_type type, void *data)
+{
+	struct kona_clk *bcm_clk;
+	struct clk_init_data *init_data;
+	struct clk *clk = NULL;
+
+	bcm_clk = kzalloc(sizeof(*bcm_clk), GFP_KERNEL);
+	if (!bcm_clk) {
+		pr_err("%s: failed to allocate bcm_clk for %s\n", __func__,
+			name);
+		return NULL;
+	}
+	bcm_clk->ccu = ccu;
+	bcm_clk->name = name;
+
+	init_data = &bcm_clk->init_data;
+	init_data->name = name;
+	switch (type) {
+	case bcm_clk_peri:
+		if (peri_clk_setup(ccu, data, init_data))
+			goto out_free;
+		break;
+	default:
+		data = NULL;
+		break;
+	}
+	bcm_clk->type = type;
+	bcm_clk->data = data;
+
+	/* Make sure everything makes sense before we set it up */
+	if (!kona_clk_valid(bcm_clk)) {
+		pr_err("%s: clock data invalid for %s\n", __func__, name);
+		goto out_teardown;
+	}
+
+	bcm_clk->hw.init = init_data;
+	clk = clk_register(NULL, &bcm_clk->hw);
+	if (IS_ERR(clk)) {
+		pr_err("%s: error registering clock %s (%ld)\n", __func__,
+				name, PTR_ERR(clk));
+		goto out_teardown;
+	}
+	BUG_ON(!clk);
+
+	return clk;
+out_teardown:
+	bcm_clk_teardown(bcm_clk);
+out_free:
+	kfree(bcm_clk);
+
+	return NULL;
+}
+
+static void ccu_clks_teardown(struct ccu_data *ccu)
+{
+	u32 i;
+
+	for (i = 0; i < ccu->data.clk_num; i++)
+		kona_clk_teardown(ccu->data.clks[i]);
+	kfree(ccu->data.clks);
+}
+
+static void kona_ccu_teardown(struct ccu_data *ccu)
+{
+	if (!ccu)
+		return;
+
+	if (!ccu->base)
+		goto done;
+
+	of_clk_del_provider(ccu->node);	/* safe if never added */
+	ccu_clks_teardown(ccu);
+	list_del(&ccu->links);
+	of_node_put(ccu->node);
+	iounmap(ccu->base);
+done:
+	kfree(ccu->name);
+	kfree(ccu);
+}
+
+/*
+ * Set up a CCU.  Call the provided ccu_clks_setup callback to
+ * initialize the array of clocks provided by the CCU.
+ */
+void __init kona_dt_ccu_setup(struct device_node *node,
+			int (*ccu_clks_setup)(struct ccu_data *))
+{
+	struct ccu_data *ccu;
+	struct resource res = { 0 };
+	resource_size_t range;
+	int ret;
+
+	ccu = kzalloc(sizeof(*ccu), GFP_KERNEL);
+	if (ccu)
+		ccu->name = kstrdup(node->name, GFP_KERNEL);
+	if (!ccu || !ccu->name) {
+		pr_err("%s: unable to allocate CCU struct for %s\n",
+			__func__, node->name);
+		kfree(ccu);
+
+		return;
+	}
+
+	ret = of_address_to_resource(node, 0, &res);
+	if (ret) {
+		pr_err("%s: no valid CCU registers found for %s\n", __func__,
+			node->name);
+		goto out_err;
+	}
+
+	range = resource_size(&res);
+	if (range > (resource_size_t)U32_MAX) {
+		pr_err("%s: address range too large for %s\n", __func__,
+			node->name);
+		goto out_err;
+	}
+
+	ccu->range = (u32)range;
+	ccu->base = ioremap(res.start, ccu->range);
+	if (!ccu->base) {
+		pr_err("%s: unable to map CCU registers for %s\n", __func__,
+			node->name);
+		goto out_err;
+	}
+
+	spin_lock_init(&ccu->lock);
+	INIT_LIST_HEAD(&ccu->links);
+	ccu->node = of_node_get(node);
+
+	list_add_tail(&ccu->links, &ccu_list);
+
+	/* Set up clocks array (in ccu->data) */
+	if (ccu_clks_setup(ccu))
+		goto out_err;
+
+	ret = of_clk_add_provider(node, of_clk_src_onecell_get, &ccu->data);
+	if (ret) {
+		pr_err("%s: error adding ccu %s as provider (%d)\n", __func__,
+				node->name, ret);
+		goto out_err;
+	}
+
+	if (!kona_ccu_init(ccu))
+		pr_err("Broadcom %s initialization had errors\n", node->name);
+
+	return;
+out_err:
+	kona_ccu_teardown(ccu);
+	pr_err("Broadcom %s setup aborted\n", node->name);
+}
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
new file mode 100644
index 0000000..e3d339e
--- /dev/null
+++ b/drivers/clk/bcm/clk-kona.c
@@ -0,0 +1,1033 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ * Copyright 2013 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "clk-kona.h"
+
+#include <linux/delay.h>
+
+#define CCU_ACCESS_PASSWORD      0xA5A500
+#define CLK_GATE_DELAY_LOOP      2000
+
+/* Bitfield operations */
+
+/* Produces a mask of set bits covering a range of a 32-bit value */
+static inline u32 bitfield_mask(u32 shift, u32 width)
+{
+	return ((1 << width) - 1) << shift;
+}
+
+/* Extract the value of a bitfield found within a given register value */
+static inline u32 bitfield_extract(u32 reg_val, u32 shift, u32 width)
+{
+	return (reg_val & bitfield_mask(shift, width)) >> shift;
+}
+
+/* Replace the value of a bitfield found within a given register value */
+static inline u32 bitfield_replace(u32 reg_val, u32 shift, u32 width,
u32 val)
+{
+	u32 mask = bitfield_mask(shift, width);
+
+	return (reg_val & ~mask) | (val << shift);
+}
+
+/* Divider and scaling helpers */
+
+/*
+ * Implement DIV_ROUND_CLOSEST() for 64-bit dividend and both values
+ * unsigned.  Note that unlike do_div(), the remainder is discarded
+ * and the return value is the quotient (not the remainder).
+ */
+u64 do_div_round_closest(u64 dividend, unsigned long divisor)
+{
+	u64 result;
+
+	result = dividend + ((u64)divisor >> 1);
+	(void)do_div(result, divisor);
+
+	return result;
+}
+
+/* Convert a divider into the scaled divisor value it represents. */
+static inline u64 scaled_div_value(struct bcm_clk_div *div, u32 reg_div)
+{
+	return (u64)reg_div + ((u64)1 << div->frac_width);
+}
+
+/*
+ * Build a scaled divider value as close as possible to the
+ * given whole part (div_value) and fractional part (expressed
+ * in billionths).
+ */
+u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value, u32
billionths)
+{
+	u64 combined;
+
+	BUG_ON(!div_value);
+	BUG_ON(billionths >= BILLION);
+
+	combined = (u64)div_value * BILLION + billionths;
+	combined <<= div->frac_width;
+
+	return do_div_round_closest(combined, BILLION);
+}
+
+/* The scaled minimum divisor representable by a divider */
+static inline u64
+scaled_div_min(struct bcm_clk_div *div)
+{
+	if (divider_is_fixed(div))
+		return (u64)div->fixed;
+
+	return scaled_div_value(div, 0);
+}
+
+/* The scaled maximum divisor representable by a divider */
+u64 scaled_div_max(struct bcm_clk_div *div)
+{
+	u32 reg_div;
+
+	if (divider_is_fixed(div))
+		return (u64)div->fixed;
+
+	reg_div = ((u32)1 << div->width) - 1;
+
+	return scaled_div_value(div, reg_div);
+}
+
+/*
+ * Convert a scaled divisor into its divider representation as
+ * stored in a divider register field.
+ */
+static inline u32
+divider(struct bcm_clk_div *div, u64 scaled_div)
+{
+	BUG_ON(scaled_div < scaled_div_min(div));
+	BUG_ON(scaled_div > scaled_div_max(div));
+
+	return (u32)(scaled_div - ((u64)1 << div->frac_width));
+}
+
+/* Return a rate scaled for use when dividing by a scaled divisor. */
+static inline u64
+scale_rate(struct bcm_clk_div *div, u32 rate)
+{
+	if (divider_is_fixed(div))
+		return (u64)rate;
+
+	return (u64)rate << div->frac_width;
+}
+
+/* CCU access */
+
+/* Read a 32-bit register value from a CCU's address space. */
+static inline u32 __ccu_read(struct ccu_data *ccu, u32 reg_offset)
+{
+	return readl(ccu->base + reg_offset);
+}
+
+/* Write a 32-bit register value into a CCU's address space. */
+static inline void
+__ccu_write(struct ccu_data *ccu, u32 reg_offset, u32 reg_val)
+{
+	writel(reg_val, ccu->base + reg_offset);
+}
+
+static inline unsigned long ccu_lock(struct ccu_data *ccu)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccu->lock, flags);
+
+	return flags;
+}
+static inline void ccu_unlock(struct ccu_data *ccu, unsigned long flags)
+{
+	spin_unlock_irqrestore(&ccu->lock, flags);
+}
+
+/*
+ * Enable/disable write access to CCU protected registers.  The
+ * WR_ACCESS register for all CCUs is at offset 0.
+ */
+static inline void __ccu_write_enable(struct ccu_data *ccu)
+{
+	if (ccu->write_enabled) {
+		pr_err("%s: access already enabled for %s\n", __func__,
+			ccu->name);
+		return;
+	}
+	ccu->write_enabled = true;
+	__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
+}
+
+static inline void __ccu_write_disable(struct ccu_data *ccu)
+{
+	if (!ccu->write_enabled) {
+		pr_err("%s: access wasn't enabled for %s\n", __func__,
+			ccu->name);
+		return;
+	}
+
+	__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
+	ccu->write_enabled = false;
+}
+
+/*
+ * Poll a register in a CCU's address space, returning when the
+ * specified bit in that register's value is set (or clear).  Delay
+ * a microsecond after each read of the register.  Returns true if
+ * successful, or false if we gave up trying.
+ *
+ * Caller must ensure the CCU lock is held.
+ */
+static inline bool
+__ccu_wait_bit(struct ccu_data *ccu, u32 reg_offset, u32 bit, bool want)
+{
+	unsigned int tries;
+	u32 bit_mask = 1 << bit;
+
+	for (tries = 0; tries < CLK_GATE_DELAY_LOOP; tries++) {
+		u32 val;
+		bool bit_val;
+
+		val = __ccu_read(ccu, reg_offset);
+		bit_val = (val & bit_mask) != 0;
+		if (bit_val == want)
+			return true;
+		udelay(1);
+	}
+	return false;
+}
+
+/* Gate operations */
+
+/* Determine whether a clock is gated.  CCU lock must be held.  */
+static bool
+__is_clk_gate_enabled(struct ccu_data *ccu, struct bcm_clk_gate *gate)
+{
+	u32 bit_mask;
+	u32 reg_val;
+
+	/* If there is no gate we can assume it's enabled. */
+	if (!gate_exists(gate))
+		return true;
+
+	bit_mask = 1 << gate->status_bit;
+	reg_val = __ccu_read(ccu, gate->offset);
+
+	return (reg_val & bit_mask) != 0;
+}
+
+/* Determine whether a clock is gated. */
+static bool
+is_clk_gate_enabled(struct ccu_data *ccu, struct bcm_clk_gate *gate)
+{
+	long flags;
+	bool ret;
+
+	/* Avoid taking the lock if we can */
+	if (!gate_exists(gate))
+		return true;
+
+	flags = ccu_lock(ccu);
+	ret = __is_clk_gate_enabled(ccu, gate);
+	ccu_unlock(ccu, flags);
+
+	return ret;
+}
+
+/*
+ * Commit our desired gate state to the hardware.
+ * Returns true if successful, false otherwise.
+ */
+static bool
+__gate_commit(struct ccu_data *ccu, struct bcm_clk_gate *gate)
+{
+	u32 reg_val;
+	u32 mask;
+	bool enabled = false;
+
+	BUG_ON(!gate_exists(gate));
+	if (!gate_is_sw_controllable(gate))
+		return true;		/* Nothing we can change */
+
+	reg_val = __ccu_read(ccu, gate->offset);
+
+	/* For a hardware/software gate, set which is in control */
+	if (gate_is_hw_controllable(gate)) {
+		mask = (u32)1 << gate->hw_sw_sel_bit;
+		if (gate_is_sw_managed(gate))
+			reg_val |= mask;
+		else
+			reg_val &= ~mask;
+	}
+
+	/*
+	 * If software is in control, enable or disable the gate.
+	 * If hardware is, clear the enabled bit for good measure.
+	 * If a software controlled gate can't be disabled, we're
+	 * required to write a 0 into the enable bit (but the gate
+	 * will be enabled).
+	 */
+	mask = (u32)1 << gate->en_bit;
+	if (gate_is_sw_managed(gate) && (enabled = gate_is_enabled(gate)) &&
+			!gate_is_no_disable(gate))
+		reg_val |= mask;
+	else
+		reg_val &= ~mask;
+
+	__ccu_write(ccu, gate->offset, reg_val);
+
+	/* For a hardware controlled gate, we're done */
+	if (!gate_is_sw_managed(gate))
+		return true;
+
+	/* Otherwise wait for the gate to be in desired state */
+	return __ccu_wait_bit(ccu, gate->offset, gate->status_bit, enabled);
+}
+
+/*
+ * Initialize a gate.  Our desired state (hardware/software select,
+ * and if software, its enable state) is committed to hardware
+ * without the usual checks to see if it's already set up that way.
+ * Returns true if successful, false otherwise.
+ */
+static bool gate_init(struct ccu_data *ccu, struct bcm_clk_gate *gate)
+{
+	if (!gate_exists(gate))
+		return true;
+	return __gate_commit(ccu, gate);
+}
+
+/*
+ * Set a gate to enabled or disabled state.  Does nothing if the
+ * gate is not currently under software control, or if it is already
+ * in the requested state.  Returns true if successful, false
+ * otherwise.  CCU lock must be held.
+ */
+static bool
+__clk_gate(struct ccu_data *ccu, struct bcm_clk_gate *gate, bool enable)
+{
+	bool ret;
+
+	if (!gate_exists(gate) || !gate_is_sw_managed(gate))
+		return true;	/* Nothing to do */
+
+	if (!enable && gate_is_no_disable(gate)) {
+		pr_warn("%s: invalid gate disable request (ignoring)\n",
+			__func__);
+		return true;
+	}
+
+	if (enable == gate_is_enabled(gate))
+		return true;	/* No change */
+
+	gate_flip_enabled(gate);
+	ret = __gate_commit(ccu, gate);
+	if (!ret)
+		gate_flip_enabled(gate);	/* Revert the change */
+
+	return ret;
+}
+
+/* Enable or disable a gate.  Returns 0 if successful, -EIO otherwise */
+static int clk_gate(struct ccu_data *ccu, const char *name,
+			struct bcm_clk_gate *gate, bool enable)
+{
+	unsigned long flags;
+	bool success;
+
+	/*
+	 * Avoid taking the lock if we can.  We quietly ignore
+	 * requests to change state that don't make sense.
+	 */
+	if (!gate_exists(gate) || !gate_is_sw_managed(gate))
+		return 0;
+	if (!enable && gate_is_no_disable(gate))
+		return 0;
+
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
+	success = __clk_gate(ccu, gate, enable);
+
+	__ccu_write_disable(ccu);
+	ccu_unlock(ccu, flags);
+
+	if (success)
+		return 0;
+
+	pr_err("%s: failed to %s gate for %s\n", __func__,
+		enable ? "enable" : "disable", name);
+
+	return -EIO;
+}
+
+/* Trigger operations */
+
+/*
+ * Caller must ensure CCU lock is held and access is enabled.
+ * Returns true if successful, false otherwise.
+ */
+static bool __clk_trigger(struct ccu_data *ccu, struct bcm_clk_trig *trig)
+{
+	/* Trigger the clock and wait for it to finish */
+	__ccu_write(ccu, trig->offset, 1 << trig->bit);
+
+	return __ccu_wait_bit(ccu, trig->offset, trig->bit, false);
+}
+
+/* Divider operations */
+
+/* Read a divider value and return the scaled divisor it represents. */
+static u64 divider_read_scaled(struct ccu_data *ccu, struct bcm_clk_div
*div)
+{
+	unsigned long flags;
+	u32 reg_val;
+	u32 reg_div;
+
+	if (divider_is_fixed(div))
+		return (u64)div->fixed;
+
+	flags = ccu_lock(ccu);
+	reg_val = __ccu_read(ccu, div->offset);
+	ccu_unlock(ccu, flags);
+
+	/* Extract the full divider field from the register value */
+	reg_div = bitfield_extract(reg_val, div->shift, div->width);
+
+	/* Return the scaled divisor value it represents */
+	return scaled_div_value(div, reg_div);
+}
+
+/*
+ * Convert a divider's scaled divisor value into its recorded form
+ * and commit it into the hardware divider register.
+ *
+ * Returns 0 on success.  Returns -EINVAL for invalid arguments.
+ * Returns -ENXIO if gating failed, and -EIO if a trigger failed.
+ */
+static int __div_commit(struct ccu_data *ccu, struct bcm_clk_gate *gate,
+			struct bcm_clk_div *div, struct bcm_clk_trig *trig)
+{
+	bool enabled;
+	u32 reg_div;
+	u32 reg_val;
+	int ret = 0;
+
+	BUG_ON(divider_is_fixed(div));
+
+	/*
+	 * If we're just initializing the divider, and no initial
+	 * state was defined in the device tree, we just find out
+	 * what its current value is rather than updating it.
+	 */
+	if (div->scaled_div == BAD_SCALED_DIV_VALUE) {
+		reg_val = __ccu_read(ccu, div->offset);
+		reg_div = bitfield_extract(reg_val, div->shift, div->width);
+		div->scaled_div = scaled_div_value(div, reg_div);
+
+		return 0;
+	}
+
+	/* Convert the scaled divisor to the value we need to record */
+	reg_div = divider(div, div->scaled_div);
+
+	/* Clock needs to be enabled before changing the rate */
+	enabled = __is_clk_gate_enabled(ccu, gate);
+	if (!enabled && !__clk_gate(ccu, gate, true)) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	/* Replace the divider value and record the result */
+	reg_val = __ccu_read(ccu, div->offset);
+	reg_val = bitfield_replace(reg_val, div->shift, div->width, reg_div);
+	__ccu_write(ccu, div->offset, reg_val);
+
+	/* If the trigger fails we still want to disable the gate */
+	if (!__clk_trigger(ccu, trig))
+		ret = -EIO;
+
+	/* Disable the clock again if it was disabled to begin with */
+	if (!enabled && !__clk_gate(ccu, gate, false))
+		ret = ret ? ret : -ENXIO;	/* return first error */
+out:
+	return ret;
+}
+
+/*
+ * Initialize a divider by committing our desired state to hardware
+ * without the usual checks to see if it's already set up that way.
+ * Returns true if successful, false otherwise.
+ */
+static bool div_init(struct ccu_data *ccu, struct bcm_clk_gate *gate,
+			struct bcm_clk_div *div, struct bcm_clk_trig *trig)
+{
+	if (!divider_exists(div) || divider_is_fixed(div))
+		return true;
+	return !__div_commit(ccu, gate, div, trig);
+}
+
+static int divider_write(struct ccu_data *ccu, struct bcm_clk_gate *gate,
+			struct bcm_clk_div *div, struct bcm_clk_trig *trig,
+			u64 scaled_div)
+{
+	unsigned long flags;
+	u64 previous;
+	int ret;
+
+	BUG_ON(divider_is_fixed(div));
+
+	previous = div->scaled_div;
+	if (previous == scaled_div)
+		return 0;	/* No change */
+
+	div->scaled_div = scaled_div;
+
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
+	ret = __div_commit(ccu, gate, div, trig);
+
+	__ccu_write_disable(ccu);
+	ccu_unlock(ccu, flags);
+
+	if (ret)
+		div->scaled_div = previous;		/* Revert the change */
+
+	return ret;
+
+}
+
+/* Common clock rate helpers */
+
+/*
+ * Implement the common clock framework recalc_rate method, taking
+ * into account a divider and an optional pre-divider.  The
+ * pre-divider register pointer may be NULL.
+ */
+static unsigned long clk_recalc_rate(struct ccu_data *ccu,
+			struct bcm_clk_div *div, struct bcm_clk_div *pre_div,
+			unsigned long parent_rate)
+{
+	u64 scaled_parent_rate;
+	u64 scaled_div;
+	u64 result;
+
+	if (!divider_exists(div))
+		return parent_rate;
+
+	if (parent_rate > (unsigned long)LONG_MAX)
+		return 0;	/* actually this would be a caller bug */
+
+	/*
+	 * If there is a pre-divider, divide the scaled parent rate
+	 * by the pre-divider value first.  In this case--to improve
+	 * accuracy--scale the parent rate by *both* the pre-divider
+	 * value and the divider before actually computing the
+	 * result of the pre-divider.
+	 *
+	 * If there's only one divider, just scale the parent rate.
+	 */
+	if (pre_div && divider_exists(pre_div)) {
+		u64 scaled_rate;
+
+		scaled_rate = scale_rate(pre_div, parent_rate);
+		scaled_rate = scale_rate(div, scaled_rate);
+		scaled_div = divider_read_scaled(ccu, pre_div);
+		scaled_parent_rate = do_div_round_closest(scaled_rate,
+							scaled_div);
+	} else  {
+		scaled_parent_rate = scale_rate(div, parent_rate);
+	}
+
+	/*
+	 * Get the scaled divisor value, and divide the scaled
+	 * parent rate by that to determine this clock's resulting
+	 * rate.
+	 */
+	scaled_div = divider_read_scaled(ccu, div);
+	result = do_div_round_closest(scaled_parent_rate, scaled_div);
+
+	return (unsigned long)result;
+}
+
+/*
+ * Compute the output rate produced when a given parent rate is fed
+ * into two dividers.  The pre-divider can be NULL, and even if it's
+ * non-null it may be nonexistent.  It's also OK for the divider to
+ * be nonexistent, and in that case the pre-divider is also ignored.
+ *
+ * If scaled_div is non-null, it is used to return the scaled divisor
+ * value used by the (downstream) divider to produce that rate.
+ */
+static long round_rate(struct ccu_data *ccu, struct bcm_clk_div *div,
+				struct bcm_clk_div *pre_div,
+				unsigned long rate, unsigned long parent_rate,
+				u64 *scaled_div)
+{
+	u64 scaled_parent_rate;
+	u64 min_scaled_div;
+	u64 max_scaled_div;
+	u64 best_scaled_div;
+	u64 result;
+
+	BUG_ON(!divider_exists(div));
+	BUG_ON(!rate);
+	BUG_ON(parent_rate > (u64)LONG_MAX);
+
+	/*
+	 * If there is a pre-divider, divide the scaled parent rate
+	 * by the pre-divider value first.  In this case--to improve
+	 * accuracy--scale the parent rate by *both* the pre-divider
+	 * value and the divider before actually computing the
+	 * result of the pre-divider.
+	 *
+	 * If there's only one divider, just scale the parent rate.
+	 *
+	 * For simplicity we treat the pre-divider as fixed (for now).
+	 */
+	if (divider_exists(pre_div)) {
+		u64 scaled_rate;
+		u64 scaled_pre_div;
+
+		scaled_rate = scale_rate(pre_div, parent_rate);
+		scaled_rate = scale_rate(div, scaled_rate);
+		scaled_pre_div = divider_read_scaled(ccu, pre_div);
+		scaled_parent_rate = do_div_round_closest(scaled_rate,
+							scaled_pre_div);
+	} else {
+		scaled_parent_rate = scale_rate(div, parent_rate);
+	}
+
+	/*
+	 * Compute the best possible divider and ensure it is in
+	 * range.  A fixed divider can't be changed, so just report
+	 * the best we can do.
+	 */
+	if (!divider_is_fixed(div)) {
+		best_scaled_div = do_div_round_closest(scaled_parent_rate,
+							rate);
+		min_scaled_div = scaled_div_min(div);
+		max_scaled_div = scaled_div_max(div);
+		if (best_scaled_div > max_scaled_div)
+			best_scaled_div = max_scaled_div;
+		else if (best_scaled_div < min_scaled_div)
+			best_scaled_div = min_scaled_div;
+	} else {
+		best_scaled_div = divider_read_scaled(ccu, div);
+	}
+
+	/* OK, figure out the resulting rate */
+	result = do_div_round_closest(scaled_parent_rate, best_scaled_div);
+
+	if (scaled_div)
+		*scaled_div = best_scaled_div;
+
+	return (long)result;
+}
+
+/* Common clock parent helpers */
+
+/*
+ * For a given parent selector (register field) value, find the
+ * index into a selector's parent_sel array that contains it.
+ * Returns the index, or BAD_CLK_INDEX if it's not found.
+ */
+static u8 parent_index(struct bcm_clk_sel *sel, u8 parent_sel)
+{
+	u8 i;
+
+	BUG_ON(sel->parent_count > (u32)U8_MAX);
+	for (i = 0; i < sel->parent_count; i++)
+		if (sel->parent_sel[i] == parent_sel)
+			return i;
+	return BAD_CLK_INDEX;
+}
+
+/*
+ * Fetch the current value of the selector, and translate that into
+ * its corresponding index in the parent array we registered with
+ * the clock framework.
+ *
+ * Returns parent array index that corresponds with the value found,
+ * or BAD_CLK_INDEX if the found value is out of range.
+ */
+static u8 selector_read_index(struct ccu_data *ccu, struct bcm_clk_sel
*sel)
+{
+	unsigned long flags;
+	u32 reg_val;
+	u32 parent_sel;
+	u8 index;
+
+	/* If there's no selector, there's only one parent */
+	if (!selector_exists(sel))
+		return 0;
+
+	/* Get the value in the selector register */
+	flags = ccu_lock(ccu);
+	reg_val = __ccu_read(ccu, sel->offset);
+	ccu_unlock(ccu, flags);
+
+	parent_sel = bitfield_extract(reg_val, sel->shift, sel->width);
+
+	/* Look up that selector's parent array index and return it */
+	index = parent_index(sel, parent_sel);
+	if (index == BAD_CLK_INDEX)
+		pr_err("%s: out-of-range parent selector %u (%s 0x%04x)\n",
+			__func__, parent_sel, ccu->name, sel->offset);
+
+	return index;
+}
+
+/*
+ * Commit our desired selector value to the hardware.
+ *
+ * Returns 0 on success.  Returns -EINVAL for invalid arguments.
+ * Returns -ENXIO if gating failed, and -EIO if a trigger failed.
+ */
+static int
+__sel_commit(struct ccu_data *ccu, struct bcm_clk_gate *gate,
+			struct bcm_clk_sel *sel, struct bcm_clk_trig *trig)
+{
+	u32 parent_sel;
+	u32 reg_val;
+	bool enabled;
+	int ret = 0;
+
+	BUG_ON(!selector_exists(sel));
+
+	/*
+	 * If we're just initializing the selector, and no initial
+	 * state was defined in the device tree, we just find out
+	 * what its current value is rather than updating it.
+	 */
+	if (sel->clk_index == BAD_CLK_INDEX) {
+		u8 index;
+
+		reg_val = __ccu_read(ccu, sel->offset);
+		parent_sel = bitfield_extract(reg_val, sel->shift, sel->width);
+		index = parent_index(sel, parent_sel);
+		if (index == BAD_CLK_INDEX)
+			return -EINVAL;
+		sel->clk_index = index;
+
+		return 0;
+	}
+
+	BUG_ON((u32)sel->clk_index >= sel->parent_count);
+	parent_sel = sel->parent_sel[sel->clk_index];
+
+	/* Clock needs to be enabled before changing the parent */
+	enabled = __is_clk_gate_enabled(ccu, gate);
+	if (!enabled && !__clk_gate(ccu, gate, true))
+		return -ENXIO;
+
+	/* Replace the selector value and record the result */
+	reg_val = __ccu_read(ccu, sel->offset);
+	reg_val = bitfield_replace(reg_val, sel->shift, sel->width, parent_sel);
+	__ccu_write(ccu, sel->offset, reg_val);
+
+	/* If the trigger fails we still want to disable the gate */
+	if (!__clk_trigger(ccu, trig))
+		ret = -EIO;
+
+	/* Disable the clock again if it was disabled to begin with */
+	if (!enabled && !__clk_gate(ccu, gate, false))
+		ret = ret ? ret : -ENXIO;	/* return first error */
+
+	return ret;
+}
+
+/*
+ * Initialize a selector by committing our desired state to hardware
+ * without the usual checks to see if it's already set up that way.
+ * Returns true if successful, false otherwise.
+ */
+static bool sel_init(struct ccu_data *ccu, struct bcm_clk_gate *gate,
+			struct bcm_clk_sel *sel, struct bcm_clk_trig *trig)
+{
+	if (!selector_exists(sel))
+		return true;
+	return !__sel_commit(ccu, gate, sel, trig);
+}
+
+/*
+ * Write a new value into a selector register to switch to a
+ * different parent clock.  Returns 0 on success, or an error code
+ * (from __sel_commit()) otherwise.
+ */
+static int selector_write(struct ccu_data *ccu, struct bcm_clk_gate *gate,
+			struct bcm_clk_sel *sel, struct bcm_clk_trig *trig,
+			u8 index)
+{
+	unsigned long flags;
+	u8 previous;
+	int ret;
+
+	previous = sel->clk_index;
+	if (previous == index)
+		return 0;	/* No change */
+
+	sel->clk_index = index;
+
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
+	ret = __sel_commit(ccu, gate, sel, trig);
+
+	__ccu_write_disable(ccu);
+	ccu_unlock(ccu, flags);
+
+	if (ret)
+		sel->clk_index = previous;	/* Revert the change */
+
+	return ret;
+}
+
+/* Clock operations */
+
+static int kona_peri_clk_enable(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_gate *gate = &bcm_clk->peri->gate;
+
+	return clk_gate(bcm_clk->ccu, bcm_clk->name, gate, true);
+}
+
+static void kona_peri_clk_disable(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_gate *gate = &bcm_clk->peri->gate;
+
+	(void)clk_gate(bcm_clk->ccu, bcm_clk->name, gate, false);
+}
+
+static int kona_peri_clk_is_enabled(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_gate *gate = &bcm_clk->peri->gate;
+
+	return is_clk_gate_enabled(bcm_clk->ccu, gate) ? 1 : 0;
+}
+
+static unsigned long kona_peri_clk_recalc_rate(struct clk_hw *hw,
+			unsigned long parent_rate)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct peri_clk_data *data = bcm_clk->peri;
+
+	return clk_recalc_rate(bcm_clk->ccu, &data->div, &data->pre_div,
+				parent_rate);
+}
+
+static long kona_peri_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+			unsigned long *parent_rate)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct bcm_clk_div *div = &bcm_clk->peri->div;
+
+	if (!divider_exists(div))
+		return __clk_get_rate(hw->clk);
+
+	/* Quietly avoid a zero rate */
+	return round_rate(bcm_clk->ccu, div, &bcm_clk->peri->pre_div,
+				rate ? rate : 1, *parent_rate, NULL);
+}
+
+static int kona_peri_clk_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct peri_clk_data *data = bcm_clk->peri;
+	struct bcm_clk_sel *sel = &data->sel;
+	struct bcm_clk_trig *trig;
+	int ret;
+
+	BUG_ON(index >= sel->parent_count);
+
+	/* If there's only one parent we don't require a selector */
+	if (!selector_exists(sel))
+		return 0;
+
+	/*
+	 * The regular trigger is used by default, but if there's a
+	 * pre-trigger we want to use that instead.
+	 */
+	trig = trigger_exists(&data->pre_trig) ? &data->pre_trig
+					       : &data->trig;
+
+	ret = selector_write(bcm_clk->ccu, &data->gate, sel, trig, index);
+	if (ret == -ENXIO) {
+		pr_err("%s: gating failure for %s\n", __func__, bcm_clk->name);
+		ret = -EIO;	/* Don't proliferate weird errors */
+	} else if (ret == -EIO) {
+		pr_err("%s: %strigger failed for %s\n", __func__,
+			trig == &data->pre_trig ? "pre-" : "",
+			bcm_clk->name);
+	}
+
+	return ret;
+}
+
+static u8 kona_peri_clk_get_parent(struct clk_hw *hw)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct peri_clk_data *data = bcm_clk->peri;
+	u8 index;
+
+	index = selector_read_index(bcm_clk->ccu, &data->sel);
+
+	/* Not all callers would handle an out-of-range value gracefully */
+	return index == BAD_CLK_INDEX ? 0 : index;
+}
+
+static int kona_peri_clk_set_rate(struct clk_hw *hw, unsigned long rate,
+			unsigned long parent_rate)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct peri_clk_data *data = bcm_clk->peri;
+	struct bcm_clk_div *div = &data->div;
+	u64 scaled_div = 0;
+	int ret;
+
+	if (parent_rate > (unsigned long)LONG_MAX)
+		return -EINVAL;
+
+	if (rate == __clk_get_rate(hw->clk))
+		return 0;
+
+	if (!divider_exists(div))
+		return rate == parent_rate ? 0 : -EINVAL;
+
+	/*
+	 * A fixed divider can't be changed.  (Nor can a fixed
+	 * pre-divider be, but for now we never actually try to
+	 * change that.)  Tolerate a request for a no-op change.
+	 */
+	if (divider_is_fixed(&data->div))
+		return rate == parent_rate ? 0 : -EINVAL;
+
+	/*
+	 * Get the scaled divisor value needed to achieve a clock
+	 * rate as close as possible to what was requested, given
+	 * the parent clock rate supplied.
+	 */
+	(void)round_rate(bcm_clk->ccu, div, &data->pre_div,
+				rate ? rate : 1, parent_rate, &scaled_div);
+
+	/*
+	 * We aren't updating any pre-divider at this point, so
+	 * we'll use the regular trigger.
+	 */
+	ret = divider_write(bcm_clk->ccu, &data->gate, &data->div,
+				&data->trig, scaled_div);
+	if (ret == -ENXIO) {
+		pr_err("%s: gating failure for %s\n", __func__, bcm_clk->name);
+		ret = -EIO;	/* Don't proliferate weird errors */
+	} else if (ret == -EIO) {
+		pr_err("%s: trigger failed for %s\n", __func__, bcm_clk->name);
+	}
+
+	return ret;
+}
+
+struct clk_ops kona_peri_clk_ops = {
+	.enable = kona_peri_clk_enable,
+	.disable = kona_peri_clk_disable,
+	.is_enabled = kona_peri_clk_is_enabled,
+	.recalc_rate = kona_peri_clk_recalc_rate,
+	.round_rate = kona_peri_clk_round_rate,
+	.set_parent = kona_peri_clk_set_parent,
+	.get_parent = kona_peri_clk_get_parent,
+	.set_rate = kona_peri_clk_set_rate,
+};
+
+/* Put a peripheral clock into its initial state */
+static bool __peri_clk_init(struct kona_clk *bcm_clk)
+{
+	struct ccu_data *ccu = bcm_clk->ccu;
+	struct peri_clk_data *peri = bcm_clk->peri;
+	const char *name = bcm_clk->name;
+	struct bcm_clk_trig *trig;
+
+	BUG_ON(bcm_clk->type != bcm_clk_peri);
+
+	if (!gate_init(ccu, &peri->gate)) {
+		pr_err("%s: error initializing gate for %s\n", __func__, name);
+		return false;
+	}
+	if (!div_init(ccu, &peri->gate, &peri->div, &peri->trig)) {
+		pr_err("%s: error initializing divider for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	/*
+	 * For the pre-divider and selector, the pre-trigger is used
+	 * if it's present, otherwise we just use the regular trigger.
+	 */
+	trig = trigger_exists(&peri->pre_trig) ? &peri->pre_trig
+					       : &peri->trig;
+
+	if (!div_init(ccu, &peri->gate, &peri->pre_div, trig)) {
+		pr_err("%s: error initializing pre-divider for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	if (!sel_init(ccu, &peri->gate, &peri->sel, trig)) {
+		pr_err("%s: error initializing selector for %s\n", __func__,
+			name);
+		return false;
+	}
+
+	return true;
+}
+
+static bool __kona_clk_init(struct kona_clk *bcm_clk)
+{
+	switch (bcm_clk->type) {
+	case bcm_clk_peri:
+		return __peri_clk_init(bcm_clk);
+	default:
+		BUG();
+	}
+	return -EINVAL;
+}
+
+/* Set a CCU and all its clocks into their desired initial state */
+bool __init kona_ccu_init(struct ccu_data *ccu)
+{
+	unsigned long flags;
+	unsigned int which;
+	struct clk **clks = ccu->data.clks;
+	bool success = true;
+
+	flags = ccu_lock(ccu);
+	__ccu_write_enable(ccu);
+
+	for (which = 0; which < ccu->data.clk_num; which++) {
+		struct kona_clk *bcm_clk;
+
+		if (!clks[which])
+			continue;
+		bcm_clk = to_kona_clk(__clk_get_hw(clks[which]));
+		success &= __kona_clk_init(bcm_clk);
+	}
+
+	__ccu_write_disable(ccu);
+	ccu_unlock(ccu, flags);
+	return success;
+}
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
new file mode 100644
index 0000000..93ca037
--- /dev/null
+++ b/drivers/clk/bcm/clk-kona.h
@@ -0,0 +1,414 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ * Copyright 2013 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CLK_KONA_H
+#define _CLK_KONA_H
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/clk-provider.h>
+
+#define	BILLION		1000000000
+
+#define U8_MAX	((u8)~0U)
+#define U32_MAX	((u32)~0U)
+#define U64_MAX	((u64)~0U)
+
+/* The common clock framework uses u8 to represent a parent index */
+#define PARENT_COUNT_MAX	((u32)U8_MAX)
+
+#define BAD_CLK_INDEX		U8_MAX	/* Can't ever be valid */
+#define BAD_CLK_NAME		((const char *)-1)
+
+#define BAD_SCALED_DIV_VALUE	U64_MAX
+
+/*
+ * Utility macros for object flag management.  If possible, flags
+ * should be defined such that 0 is the desired default value.
+ */
+#define FLAG(type, flag)		BCM_CLK_ ## type ## _FLAGS_ ## flag
+#define FLAG_SET(obj, type, flag)	((obj)->flags |= FLAG(type, flag))
+#define FLAG_CLEAR(obj, type, flag)	((obj)->flags &= ~(FLAG(type, flag)))
+#define FLAG_FLIP(obj, type, flag)	((obj)->flags ^= FLAG(type, flag))
+#define FLAG_TEST(obj, type, flag)	(!!((obj)->flags & FLAG(type, flag)))
+
+/* Clock field state tests */
+
+#define gate_exists(gate)		FLAG_TEST(gate, GATE, EXISTS)
+#define gate_is_enabled(gate)		FLAG_TEST(gate, GATE, ENABLED)
+#define gate_is_hw_controllable(gate)	FLAG_TEST(gate, GATE, HW)
+#define gate_is_sw_controllable(gate)	FLAG_TEST(gate, GATE, SW)
+#define gate_is_sw_managed(gate)	FLAG_TEST(gate, GATE, SW_MANAGED)
+#define gate_is_no_disable(gate)	FLAG_TEST(gate, GATE, NO_DISABLE)
+
+#define gate_flip_enabled(gate)		FLAG_FLIP(gate, GATE, ENABLED)
+
+#define divider_exists(div)		FLAG_TEST(div, DIV, EXISTS)
+#define divider_is_fixed(div)		FLAG_TEST(div, DIV, FIXED)
+#define divider_has_fraction(div)	(!divider_is_fixed(div) && \
+						(div)->frac_width > 0)
+
+#define selector_exists(sel)		((sel)->width != 0)
+#define trigger_exists(trig)		FLAG_TEST(trig, TRIG, EXISTS)
+
+/* Clock type, used to tell common block what it's part of */
+enum bcm_clk_type {
+	bcm_clk_none,		/* undefined clock type */
+	bcm_clk_bus,
+	bcm_clk_core,
+	bcm_clk_peri
+};
+
+/*
+ * Each CCU defines a mapped area of memory containing registers
+ * used to manage clocks implemented by the CCU.  Access to memory
+ * within the CCU's space is serialized by a spinlock.  Before any
+ * (other) address can be written, a special access "password" value
+ * must be written to its WR_ACCESS register (located at the base
+ * address of the range).  We keep track of the name of each CCU as
+ * it is set up, and maintain them in a list.
+ */
+struct ccu_data {
+	void __iomem *base;	/* base of mapped address space */
+	spinlock_t lock;	/* serialization lock */
+	bool write_enabled;	/* write access is currently enabled */
+	struct list_head links;	/* for ccu_list */
+	struct device_node *node;
+	struct clk_onecell_data data;
+	const char *name;
+	u32 range;		/* byte range of address space */
+};
+
+/*
+ * Gating control and status is managed by a 32-bit gate register.
+ *
+ * There are several types of gating available:
+ * - (no gate)
+ *     A clock with no gate is assumed to be always enabled.
+ * - hardware-only gating (auto-gating)
+ *     Enabling or disabling clocks with this type of gate is
+ *     managed automatically by the hardware.  Such clocks can be
+ *     considered by the software to be enabled.  The current status
+ *     of auto-gated clocks can be read from the gate status bit.
+ * - software-only gating
+ *     Auto-gating is not available for this type of clock.
+ *     Instead, software manages whether it's enabled by setting or
+ *     clearing the enable bit.  The current gate status of a gate
+ *     under software control can be read from the gate status bit.
+ *     To ensure a change to the gating status is complete, the
+ *     status bit can be polled to verify that the gate has entered
+ *     the desired state.
+ * - selectable hardware or software gating
+ *     Gating for this type of clock can be configured to be either
+ *     under software or hardware control.  Which type is in use is
+ *     determined by the hw_sw_sel bit of the gate register.
+ */
+struct bcm_clk_gate {
+	u32 offset;		/* gate register offset */
+	u32 status_bit;		/* 0: gate is disabled; 0: gatge is enabled */
+	u32 en_bit;		/* 0: disable; 1: enable */
+	u32 hw_sw_sel_bit;	/* 0: hardware gating; 1: software gating */
+	u32 flags;		/* BCM_CLK_GATE_FLAGS_* below */
+};
+
+/*
+ * Gate flags:
+ *   HW         means this gate can be auto-gated
+ *   SW         means the state of this gate can be software controlled
+ *   NO_DISABLE means this gate is (only) enabled if under software control
+ *   SW_MANAGED means the status of this gate is under software control
+ *   ENABLED    means this software-managed gate is *supposed* to be
enabled
+ */
+#define BCM_CLK_GATE_FLAGS_EXISTS	((u32)1 << 0)	/* Gate is valid */
+#define BCM_CLK_GATE_FLAGS_HW		((u32)1 << 1)	/* Can auto-gate */
+#define BCM_CLK_GATE_FLAGS_SW		((u32)1 << 2)	/* Software control */
+#define BCM_CLK_GATE_FLAGS_NO_DISABLE	((u32)1 << 3)	/* HW or enabled */
+#define BCM_CLK_GATE_FLAGS_SW_MANAGED	((u32)1 << 4)	/* SW now in control */
+#define BCM_CLK_GATE_FLAGS_ENABLED	((u32)1 << 5)	/* If SW_MANAGED */
+
+/*
+ * Gate initialization macros.
+ *
+ * Any gate initially under software control will be enabled.
+ */
+
+/* A hardware/software gate initially under software control */
+#define HW_SW_GATE(_offset, _status_bit, _en_bit, _hw_sw_sel_bit)	\
+	{								\
+		.offset = (_offset),					\
+		.status_bit = (_status_bit),				\
+		.en_bit = (_en_bit),					\
+		.hw_sw_sel_bit = (_hw_sw_sel_bit),			\
+		.flags = FLAG(GATE, HW)|FLAG(GATE, SW)|			\
+			FLAG(GATE, SW_MANAGED)|FLAG(GATE, ENABLED)|	\
+			FLAG(GATE, EXISTS),				\
+	}
+
+/* A hardware/software gate initially under hardware control */
+#define HW_SW_GATE_AUTO(_offset, _status_bit, _en_bit, _hw_sw_sel_bit)	\
+	{								\
+		.offset = (_offset),					\
+		.status_bit = (_status_bit),				\
+		.en_bit = (_en_bit),					\
+		.hw_sw_sel_bit = (_hw_sw_sel_bit),			\
+		.flags = FLAG(GATE, HW)|FLAG(GATE, SW)|			\
+			FLAG(GATE, EXISTS),				\
+	}
+
+/* A hardware-or-enabled gate (enabled if not under hardware control) */
+#define HW_ENABLE_GATE(_offset, _status_bit, _en_bit, _hw_sw_sel_bit)	\
+	{								\
+		.offset = (_offset),					\
+		.status_bit = (_status_bit),				\
+		.en_bit = (_en_bit),					\
+		.hw_sw_sel_bit = (_hw_sw_sel_bit),			\
+		.flags = FLAG(GATE, HW)|FLAG(GATE, SW)|			\
+			FLAG(GATE, NO_DISABLE)|FLAG(GATE, EXISTS),	\
+	}
+
+/* A software-only gate */
+#define SW_ONLY_GATE(_offset, _status_bit, _en_bit)			\
+	{								\
+		.offset = (_offset),					\
+		.status_bit = (_status_bit),				\
+		.en_bit = (_en_bit),					\
+		.flags = FLAG(GATE, SW)|FLAG(GATE, ENABLED)|		\
+				FLAG(GATE, EXISTS),			\
+	}
+
+/* A hardware-only gate */
+#define HW_ONLY_GATE(_offset, _status_bit)				\
+	{								\
+		.offset = (_offset),					\
+		.status_bit = (_status_bit),				\
+		.flags = FLAG(GATE, HW)|FLAG(GATE, EXISTS),		\
+	}
+
+/*
+ * Each clock can have zero, one, or two dividers which change the
+ * output rate of the clock.  Each divider can be either fixed or
+ * variable.  If there are two dividers, they are the "pre-divider"
+ * and the "regular" or "downstream" divider.  If there is only one,
+ * there is no pre-divider.
+ *
+ * A fixed divider is any non-zero (positive) value, and it
+ * indicates how the input rate is affected by the divider.
+ *
+ * The value of a variable divider is maintained in a sub-field of a
+ * 32-bit divider register.  The position of the field in the
+ * register is defined by its offset and width.  The value recorded
+ * in this field is always 1 less than the value it represents.
+ *
+ * In addition, a variable divider can indicate that some subset
+ * of its bits represent a "fractional" part of the divider.  Such
+ * bits comprise the low-order portion of the divider field, and can
+ * be viewed as representing the portion of the divider that lies to
+ * the right of the decimal point.  Most variable dividers have zero
+ * fractional bits.  Variable dividers with non-zero fraction width
+ * still record a value 1 less than the value they represent; the
+ * added 1 does *not* affect the low-order bit in this case, it
+ * affects the bits above the fractional part only.  (Often in this
+ * code a divider field value is distinguished from the value it
+ * represents by referring to the latter as a "divisor".)
+ *
+ * In order to avoid dealing with fractions, divider arithmetic is
+ * performed using "scaled" values.  A scaled value is one that's
+ * been left-shifted by the fractional width of a divider.  Dividing
+ * a scaled value by a scaled divisor produces the desired quotient
+ * without loss of precision and without any other special handling
+ * for fractions.
+ *
+ * The recorded value of a variable divider can be modified.  To
+ * modify either divider (or both), a clock must be enabled (i.e.,
+ * using its gate).  In addition, a trigger register (described
+ * below) must be used to commit the change, and polled to verify
+ * the change is complete.
+ */
+struct bcm_clk_div {
+	union {
+		struct {	/* variable divider */
+			u32 offset;	/* divider register offset */
+			u32 shift;	/* field shift */
+			u32 width;	/* field width */
+			u32 frac_width;	/* field fraction width */
+
+			u64 scaled_div;	/* scaled divider value */
+		};
+		u32 fixed;	/* non-zero fixed divider value */
+	};
+	u32 flags;		/* BCM_CLK_DIV_FLAGS_* below */
+};
+
+/*
+ * Divider flags:
+ *   EXISTS means this divider exists
+ *   FIXED means it is a fixed-rate divider
+ */
+#define BCM_CLK_DIV_FLAGS_EXISTS	((u32)1 << 0)	/* Divider is valid */
+#define BCM_CLK_DIV_FLAGS_FIXED		((u32)1 << 1)	/* Fixed-value */
+
+/* Divider initialization macros */
+
+/* A fixed (non-zero) divider */
+#define FIXED_DIVIDER(_value)						\
+	{								\
+		.fixed = (_value),					\
+		.flags = FLAG(DIV, EXISTS)|FLAG(DIV, FIXED),		\
+	}
+
+/* A divider with an integral divisor */
+#define DIVIDER(_offset, _shift, _width)				\
+	{								\
+		.offset = (_offset),					\
+		.shift = (_shift),					\
+		.width = (_width),					\
+		.scaled_div = BAD_SCALED_DIV_VALUE,			\
+		.flags = FLAG(DIV, EXISTS),				\
+	}
+
+/* A divider whose divisor has an integer and fractional part */
+#define FRAC_DIVIDER(_offset, _shift, _width, _frac_width)		\
+	{								\
+		.offset = (_offset),					\
+		.shift = (_shift),					\
+		.width = (_width),					\
+		.frac_width = (_frac_width),				\
+		.scaled_div = BAD_SCALED_DIV_VALUE,			\
+		.flags = FLAG(DIV, EXISTS),				\
+	}
+
+/*
+ * Clocks may have multiple "parent" clocks.  If there is more than
+ * one, a selector must be specified to define which of the parent
+ * clocks is currently in use.  The selected clock is indicated in a
+ * sub-field of a 32-bit selector register.  The range of
+ * representable selector values typically exceeds the number of
+ * available parent clocks.  Occasionally the reset value of a
+ * selector field is explicitly set to a (specific) value that does
+ * not correspond to a defined input clock.
+ *
+ * We register all known parent clocks with the common clock code
+ * using a packed array (i.e., no empty slots) of (parent) clock
+ * names, and refer to them later using indexes into that array.
+ * We maintain an array of selector values indexed by common clock
+ * index values in order to map between these common clock indexes
+ * and the selector values used by the hardware.
+ *
+ * Like dividers, a selector can be modified, but to do so a clock
+ * must be enabled, and a trigger must be used to commit the change.
+ */
+struct bcm_clk_sel {
+	u32 offset;		/* selector register offset */
+	u32 shift;		/* field shift */
+	u32 width;		/* field width */
+
+	u32 parent_count;	/* number of entries in parent_sel[] */
+	u32 *parent_sel;	/* array of parent selector values */
+	u8 clk_index;		/* current selected index in parent_sel[] */
+};
+
+/* Selector initialization macro */
+#define SELECTOR(_offset, _shift, _width)				\
+	{								\
+		.offset = (_offset),					\
+		.shift = (_shift),					\
+		.width = (_width),					\
+		.clk_index = BAD_CLK_INDEX,				\
+	}
+
+/*
+ * Making changes to a variable divider or a selector for a clock
+ * requires the use of a trigger.  A trigger is defined by a single
+ * bit within a register.  To signal a change, a 1 is written into
+ * that bit.  To determine when the change has been completed, that
+ * trigger bit is polled; the read value will be 1 while the change
+ * is in progress, and 0 when it is complete.
+ *
+ * Occasionally a clock will have more than one trigger.  In this
+ * case, the "pre-trigger" will be used when changing a clock's
+ * selector and/or its pre-divider.
+ */
+struct bcm_clk_trig {
+	u32 offset;		/* trigger register offset */
+	u32 bit;		/* trigger bit */
+	u32 flags;		/* BCM_CLK_TRIG_FLAGS_* below */
+};
+
+/*
+ * Trigger flags:
+ *   EXISTS means this trigger exists
+ */
+#define BCM_CLK_TRIG_FLAGS_EXISTS	((u32)1 << 0)	/* Trigger is valid */
+
+/* Trigger initialization macro */
+#define TRIGGER(_offset, _bit)						\
+	{								\
+		.offset = (_offset),					\
+		.bit = (_bit),						\
+		.flags = FLAG(TRIG, EXISTS),				\
+	}
+
+struct peri_clk_data {
+	struct bcm_clk_gate gate;
+	struct bcm_clk_trig pre_trig;
+	struct bcm_clk_div pre_div;
+	struct bcm_clk_trig trig;
+	struct bcm_clk_div div;
+	struct bcm_clk_sel sel;
+	const char *clocks[];	/* must be last; use CLOCKS() to declare */
+};
+#define CLOCKS(...)	{ __VA_ARGS__, NULL, }
+#define NO_CLOCKS	{ NULL, }	/* Must use of no parent clocks */
+
+struct kona_clk {
+	struct clk_hw hw;
+	struct clk_init_data init_data;
+	const char *name;	/* name of this clock */
+	struct ccu_data *ccu;	/* ccu this clock is associated with */
+	enum bcm_clk_type type;
+	union {
+		void *data;
+		struct peri_clk_data *peri;
+	};
+};
+#define to_kona_clk(_hw) \
+	container_of(_hw, struct kona_clk, hw)
+
+/* Exported globals */
+
+extern struct clk_ops kona_peri_clk_ops;
+
+/* Help functions */
+
+#define PERI_CLK_SETUP(clks, ccu, id, name) \
+	clks[id] = kona_clk_setup(ccu, #name, bcm_clk_peri, &name ## _data)
+
+/* Externally visible functions */
+
+extern u64 do_div_round_closest(u64 dividend, unsigned long divisor);
+extern u64 scaled_div_max(struct bcm_clk_div *div);
+extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
+				u32 billionths);
+
+extern struct clk *kona_clk_setup(struct ccu_data *ccu, const char *name,
+			enum bcm_clk_type type, void *data);
+extern void __init kona_dt_ccu_setup(struct device_node *node,
+			int (*ccu_clks_setup)(struct ccu_data *));
+extern bool __init kona_ccu_init(struct ccu_data *ccu);
+
+#endif /* _CLK_KONA_H */
diff --git a/include/dt-bindings/clock/bcm281xx.h
b/include/dt-bindings/clock/bcm281xx.h
new file mode 100644
index 0000000..4ecc0a1
--- /dev/null
+++ b/include/dt-bindings/clock/bcm281xx.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ * Copyright 2013 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CLOCK_BCM281XX_H
+#define _CLOCK_BCM281XX_H
+
+/*
+ * This file defines the values used to specify clocks provided by
+ * the clock control units (CCUs) on Broadcom BCM281XX family SoCs.
+ */
+
+/* root CCU clock ids */
+
+#define BCM281XX_ROOT_CCU_FRAC_1M	0
+#define BCM281XX_ROOT_CCU_CLOCK_COUNT	1
+
+/* aon CCU clock ids */
+
+#define BCM281XX_AON_CCU_HUB_TIMER	0
+#define BCM281XX_AON_CCU_PMU_BSC	1
+#define BCM281XX_AON_CCU_PMU_BSC_VAR	2
+#define BCM281XX_AON_CCU_CLOCK_COUNT	3
+
+/* hub CCU clock ids */
+
+#define BCM281XX_HUB_CCU_TMON_1M	0
+#define BCM281XX_HUB_CCU_CLOCK_COUNT	1
+
+/* master CCU clock ids */
+
+#define BCM281XX_MASTER_CCU_SDIO1	0
+#define BCM281XX_MASTER_CCU_SDIO2	1
+#define BCM281XX_MASTER_CCU_SDIO3	2
+#define BCM281XX_MASTER_CCU_SDIO4	3
+#define BCM281XX_MASTER_CCU_USB_IC	4
+#define BCM281XX_MASTER_CCU_HSIC2_48M	5
+#define BCM281XX_MASTER_CCU_HSIC2_12M	6
+#define BCM281XX_MASTER_CCU_CLOCK_COUNT	7
+
+/* slave CCU clock ids */
+
+#define BCM281XX_SLAVE_CCU_UARTB	0
+#define BCM281XX_SLAVE_CCU_UARTB2	1
+#define BCM281XX_SLAVE_CCU_UARTB3	2
+#define BCM281XX_SLAVE_CCU_UARTB4	3
+#define BCM281XX_SLAVE_CCU_SSP0		4
+#define BCM281XX_SLAVE_CCU_SSP2		5
+#define BCM281XX_SLAVE_CCU_BSC1		6
+#define BCM281XX_SLAVE_CCU_BSC2		7
+#define BCM281XX_SLAVE_CCU_BSC3		8
+#define BCM281XX_SLAVE_CCU_PWM		9
+#define BCM281XX_SLAVE_CCU_CLOCK_COUNT	10
+
+#endif /* _CLOCK_BCM281XX_H */
-- 
1.7.9.5

