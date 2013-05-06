Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab3EFXg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:36:26 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59775 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3EFXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:36:22 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: dove: add PMU functions to pinctrl
Date: Tue,  7 May 2013 01:36:08 +0200
Message-Id: <1367883368-27889-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dove power management unit can mux some special functions to mpp0-15.
This patch adds support to set/get the current PMU function mapped
to the corresponding mpp pins. The device tree documentation is also
updated accordingly.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |   49 ++--
 drivers/pinctrl/mvebu/pinctrl-dove.c               |  244 +++++++++++++++++---
 2 files changed, 249 insertions(+), 44 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
index a648aaa..50ec351 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
@@ -10,29 +10,31 @@ Required properties:
 Available mpp pins/groups and functions:
 Note: brackets (x) are not part of the mpp name for marvell,function and given
 only for more detailed description in this document.
+Note: pmu* also allows for Power Management functions listed below
 
 name          pins     functions
 ================================================================================
-mpp0          0        gpio, pmu, uart2(rts), sdio0(cd), lcd0(pwm)
-mpp1          1        gpio, pmu, uart2(cts), sdio0(wp), lcd1(pwm)
+mpp0          0        gpio, pmu, uart2(rts), sdio0(cd), lcd0(pwm), pmu*
+mpp1          1        gpio, pmu, uart2(cts), sdio0(wp), lcd1(pwm), pmu*
 mpp2          2        gpio, pmu, uart2(txd), sdio0(buspwr), sata(prsnt),
-                       uart1(rts)
+                       uart1(rts), pmu*
 mpp3          3        gpio, pmu, uart2(rxd), sdio0(ledctrl), sata(act),
-                       uart1(cts), lcd-spi(cs1)
-mpp4          4        gpio, pmu, uart3(rts), sdio1(cd), spi1(miso)
-mpp5          5        gpio, pmu, uart3(cts), sdio1(wp), spi1(cs)
-mpp6          6        gpio, pmu, uart3(txd), sdio1(buspwr), spi1(mosi)
-mpp7          7        gpio, pmu, uart3(rxd), sdio1(ledctrl), spi1(sck)
-mpp8          8        gpio, pmu, watchdog(rstout)
-mpp9          9        gpio, pmu, pex1(clkreq)
-mpp10         10       gpio, pmu, ssp(sclk)
+                       uart1(cts), lcd-spi(cs1), pmu*
+mpp4          4        gpio, pmu, uart3(rts), sdio1(cd), spi1(miso), pmu*
+mpp5          5        gpio, pmu, uart3(cts), sdio1(wp), spi1(cs), pmu*
+mpp6          6        gpio, pmu, uart3(txd), sdio1(buspwr), spi1(mosi), pmu*
+mpp7          7        gpio, pmu, uart3(rxd), sdio1(ledctrl), spi1(sck), pmu*
+mpp8          8        gpio, pmu, watchdog(rstout), pmu*
+mpp9          9        gpio, pmu, pex1(clkreq), pmu*
+mpp10         10       gpio, pmu, ssp(sclk), pmu*
 mpp11         11       gpio, pmu, sata(prsnt), sata-1(act), sdio0(ledctrl),
-                       sdio1(ledctrl), pex0(clkreq)
-mpp12         12       gpio, pmu, uart2(rts), audio0(extclk), sdio1(cd), sata(act)
+                       sdio1(ledctrl), pex0(clkreq), pmu*
+mpp12         12       gpio, pmu, uart2(rts), audio0(extclk), sdio1(cd),
+                       sata(act), pmu*
 mpp13         13       gpio, pmu, uart2(cts), audio1(extclk), sdio1(wp),
-                       ssp(extclk)
-mpp14         14       gpio, pmu, uart2(txd), sdio1(buspwr), ssp(rxd)
-mpp15         15       gpio, pmu, uart2(rxd), sdio1(ledctrl), ssp(sfrm)
+                       ssp(extclk), pmu*
+mpp14         14       gpio, pmu, uart2(txd), sdio1(buspwr), ssp(rxd), pmu*
+mpp15         15       gpio, pmu, uart2(rxd), sdio1(ledctrl), ssp(sfrm), pmu*
 mpp16         16       gpio, uart3(rts), sdio0(cd), ac97(sdi1), lcd-spi(cs1)
 mpp17         17       gpio, uart3(cts), sdio0(wp), ac97(sdi2), twsi(sda),
                        ac97-1(sysclko)
@@ -57,6 +59,21 @@ mpp_nand      64-71    gpo, nand
 audio0        -        i2s, ac97
 twsi          -        none, opt1, opt2, opt3
 
+Power Management functions (pmu*):
+pmu-nc               Pin not driven by any PM function
+pmu-low              Pin driven low (0)
+pmu-high             Pin driven high (1)
+pmic(sdi)            Pin is used for PMIC SDI
+cpu-pwr-down         Pin is used for CPU_PWRDWN
+standby-pwr-down     Pin is used for STBY_PWRDWN
+core-pwr-good        Pin is used for CORE_PWR_GOOD (Pins 0-7 only)
+cpu-pwr-good         Pin is used for CPU_PWR_GOOD (Pins 8-15 only)
+bat-fault            Pin is used for BATTERY_FAULT
+ext0-wakeup          Pin is used for EXT0_WU
+ext1-wakeup          Pin is used for EXT0_WU
+ext2-wakeup          Pin is used for EXT0_WU
+pmu-blink            Pin is used for blink function
+
 Notes:
 * group "mpp_audio1" allows the following functions and gpio pins:
   - gpio          : gpio on pins 52-57
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 428ea96..048ae80 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -26,6 +26,9 @@
 #define DOVE_MPP_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0200)
 #define DOVE_PMU_MPP_GENERAL_CTRL	(DOVE_MPP_VIRT_BASE + 0x10)
 #define  DOVE_AU0_AC97_SEL		BIT(16)
+#define DOVE_PMU_SIGNAL_SELECT_0	(DOVE_SB_REGS_VIRT_BASE + 0xd802C)
+#define DOVE_PMU_SIGNAL_SELECT_1	(DOVE_SB_REGS_VIRT_BASE + 0xd8030)
+#define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
 #define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
 #define  DOVE_TWSI_ENABLE_OPTION1	BIT(7)
 #define DOVE_GLOBAL_CONFIG_2		(DOVE_SB_REGS_VIRT_BASE + 0xe8030)
@@ -58,12 +61,16 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
 	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
-	unsigned long mpp = readl(DOVE_MPP_VIRT_BASE + off);
-
-	if (pmu & (1 << ctrl->pid))
-		*config = CONFIG_PMU;
-	else
-		*config = (mpp >> shift) & MPP_MASK;
+	unsigned long func;
+
+	if (pmu & (1 << ctrl->pid)) {
+		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+		*config = (func >> shift) & MPP_MASK;
+		*config |= CONFIG_PMU;
+	} else {
+		func = readl(DOVE_MPP_VIRT_BASE + off);
+		*config = (func >> shift) & MPP_MASK;
+	}
 	return 0;
 }
 
@@ -73,15 +80,20 @@ static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
 	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
-	unsigned long mpp = readl(DOVE_MPP_VIRT_BASE + off);
+	unsigned long func;
 
-	if (config == CONFIG_PMU)
+	if (config & CONFIG_PMU) {
 		writel(pmu | (1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
-	else {
+		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+		func &= ~(MPP_MASK << shift);
+		func |= (config & MPP_MASK) << shift;
+		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
+	} else {
 		writel(pmu & ~(1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
-		mpp &= ~(MPP_MASK << shift);
-		mpp |= config << shift;
-		writel(mpp, DOVE_MPP_VIRT_BASE + off);
+		func = readl(DOVE_MPP_VIRT_BASE + off);
+		func &= ~(MPP_MASK << shift);
+		func |= (config & MPP_MASK) << shift;
+		writel(func, DOVE_MPP_VIRT_BASE + off);
 	}
 	return 0;
 }
@@ -378,20 +390,53 @@ static struct mvebu_mpp_mode dove_mpp_modes[] = {
 		MPP_FUNCTION(0x02, "uart2", "rts"),
 		MPP_FUNCTION(0x03, "sdio0", "cd"),
 		MPP_FUNCTION(0x0f, "lcd0", "pwm"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(1,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart2", "cts"),
 		MPP_FUNCTION(0x03, "sdio0", "wp"),
 		MPP_FUNCTION(0x0f, "lcd1", "pwm"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(2,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x01, "sata", "prsnt"),
 		MPP_FUNCTION(0x02, "uart2", "txd"),
 		MPP_FUNCTION(0x03, "sdio0", "buspwr"),
 		MPP_FUNCTION(0x04, "uart1", "rts"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(3,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x01, "sata", "act"),
@@ -399,43 +444,131 @@ static struct mvebu_mpp_mode dove_mpp_modes[] = {
 		MPP_FUNCTION(0x03, "sdio0", "ledctrl"),
 		MPP_FUNCTION(0x04, "uart1", "cts"),
 		MPP_FUNCTION(0x0f, "lcd-spi", "cs1"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(4,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart3", "rts"),
 		MPP_FUNCTION(0x03, "sdio1", "cd"),
 		MPP_FUNCTION(0x04, "spi1", "miso"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(5,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart3", "cts"),
 		MPP_FUNCTION(0x03, "sdio1", "wp"),
 		MPP_FUNCTION(0x04, "spi1", "cs"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(6,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart3", "txd"),
 		MPP_FUNCTION(0x03, "sdio1", "buspwr"),
 		MPP_FUNCTION(0x04, "spi1", "mosi"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(7,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart3", "rxd"),
 		MPP_FUNCTION(0x03, "sdio1", "ledctrl"),
 		MPP_FUNCTION(0x04, "spi1", "sck"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "core-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(8,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x01, "watchdog", "rstout"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(9,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x05, "pex1", "clkreq"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(10,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x05, "ssp", "sclk"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(11,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x01, "sata", "prsnt"),
@@ -443,33 +576,88 @@ static struct mvebu_mpp_mode dove_mpp_modes[] = {
 		MPP_FUNCTION(0x03, "sdio0", "ledctrl"),
 		MPP_FUNCTION(0x04, "sdio1", "ledctrl"),
 		MPP_FUNCTION(0x05, "pex0", "clkreq"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(12,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x01, "sata", "act"),
 		MPP_FUNCTION(0x02, "uart2", "rts"),
 		MPP_FUNCTION(0x03, "audio0", "extclk"),
 		MPP_FUNCTION(0x04, "sdio1", "cd"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(13,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart2", "cts"),
 		MPP_FUNCTION(0x03, "audio1", "extclk"),
 		MPP_FUNCTION(0x04, "sdio1", "wp"),
 		MPP_FUNCTION(0x05, "ssp", "extclk"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(14,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart2", "txd"),
 		MPP_FUNCTION(0x04, "sdio1", "buspwr"),
 		MPP_FUNCTION(0x05, "ssp", "rxd"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(15,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart2", "rxd"),
 		MPP_FUNCTION(0x04, "sdio1", "ledctrl"),
 		MPP_FUNCTION(0x05, "ssp", "sfrm"),
-		MPP_FUNCTION(0x10, "pmu", NULL)),
+		MPP_FUNCTION(CONFIG_PMU | 0x0, "pmu-nc", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x1, "pmu-low", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x2, "pmu-high", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x3, "pmic", "sdi"),
+		MPP_FUNCTION(CONFIG_PMU | 0x4, "cpu-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x5, "standby-pwr-down", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0x8, "cpu-pwr-good", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xa, "bat-fault", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xb, "ext0-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xc, "ext1-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xd, "ext2-wakeup", NULL),
+		MPP_FUNCTION(CONFIG_PMU | 0xe, "pmu-blink", NULL)),
 	MPP_MODE(16,
 		MPP_FUNCTION(0x00, "gpio", NULL),
 		MPP_FUNCTION(0x02, "uart3", "rts"),
-- 
1.7.10.4

