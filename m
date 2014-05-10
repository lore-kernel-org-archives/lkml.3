Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaEJG77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:59:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35401 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaEJG7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:59:54 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-9c-536dce687e55
From: y@samsung.com
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH v3 1/6] i2c: s3c2410: Handle i2c sys_cfg register in i2c driver
Date: Sat, 10 May 2014 16:18:02 +0900
Message-id: <1399706287-13919-2-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706287-13919-1-git-send-email-y@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jAd2Mc7nBBi2/lC3+TjrGbjH/yDlW
	i94FV9ksNj2+xmqxsG0Ji0XH3y+MFpd3zWGzmHF+H5PF7cu8Fou2fmG3eHtnOotF694j7Bbr
	Z7xmsVh5YhazA59HS3MPm8fvX5MYPTav0PLYtKqTzWPzknqPvi2rGD1OnnrC4vF5k1wARxSX
	TUpqTmZZapG+XQJXxq4Xn1gKVplW7HxxnqWBcaV2FyMnh4SAicTOJTfYIWwxiQv31rOB2EIC
	ixgllh9262LkArLbmCQOLt7A1MXIwcEmICwx9YAWSI2IQLbElcb7zCA1zAIXmCQ6Ny8CaxYW
	8JeYs+c0K4jNIqAqsez9f7AFvAK2Ejen7GMGmSMhoCAxZ5INSJhTwE7i2rZmFoi9thJTjh5m
	nMDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMA+k9rBuLLB4hCjAAejEg9vwduc
	YCHWxLLiytxDjBIczEoivCsO5gYL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKa
	nZpakFoEk2Xi4JRqYMxsPGD9kTNq75S9dbwGO/6/FzvoZ+ccG8+royjgH/605Wjm7Osdn5bu
	VgtfN3/roubL25cFNV+TCtNQDHqwPPj323czOlhKt1VcrrgoofJcazn3+1IbXbuZOx+WnRaO
	ev7i7q9arft1DZJS/w45LJM6EPvN8x5X/m1Gppl8PFnr7QJXzTG3XqjEUpyRaKjFXFScCAAY
	q9ngVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

Let's handle i2c interrupt re-configuration in i2c driver. This will
help us in removing some soc specific checks from machine files.
Since only Exynos5250, and Exynos5420 need to do this, added syscon
based phandle to i2c device nodes of respective SoC DT files.
Also handle saving and restoring of SYS_I2C_CFG register during
suspend and resume of i2c driver. This will help in removing soc
specific check from mach-exynos/pm.c.

CC: Rob Herring <robh+dt@kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Wolfram Sang <wsa@the-dreams.de>
CC: Russell King <linux@arm.linux.org.uk>
CC: devicetree@vger.kernel.org
CC: linux-doc@vger.kernel.org
CC: linux-i2c@vger.kernel.org
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
 arch/arm/boot/dts/exynos5.dtsi                     |    5 +++
 arch/arm/boot/dts/exynos5250.dtsi                  |    4 +++
 arch/arm/boot/dts/exynos5420.dtsi                  |    4 +++
 drivers/i2c/busses/i2c-s3c2410.c                   |   32 ++++++++++++++++++++
 5 files changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/sysreg.txt b/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
index 0ab3251..fd71581 100644
--- a/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
@@ -3,6 +3,7 @@ SAMSUNG S5P/Exynos SoC series System Registers (SYSREG)
 Properties:
  - compatible : should contain "samsung,<chip name>-sysreg", "syscon";
    For Exynos4 SoC series it should be "samsung,exynos4-sysreg", "syscon";
+   For Exynos5 SoC series it should be "samsung,exynos5-sysreg", "syscon";
  - reg : offset and length of the register set.
 
 Example:
diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
index 79d0608..3027e37 100644
--- a/arch/arm/boot/dts/exynos5.dtsi
+++ b/arch/arm/boot/dts/exynos5.dtsi
@@ -99,4 +99,9 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	sys_reg: syscon@10050000 {
+		compatible = "samsung,exynos5-sysreg", "syscon";
+		reg = <0x10050000 0x400>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 8d724d5..46f0233 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -285,6 +285,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c0_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -298,6 +299,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c1_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -311,6 +313,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c2_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -324,6 +327,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c3_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index ff496ad..762128c 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -517,6 +517,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c0_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -530,6 +531,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c1_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -543,6 +545,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c2_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
@@ -556,6 +559,7 @@
 		clock-names = "i2c";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c3_bus>;
+		samsung,syscon-phandle = <&sys_reg>;
 		status = "disabled";
 	};
 
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index ae44910..e707062 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -39,6 +39,8 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 #include <asm/irq.h>
 
@@ -91,6 +93,9 @@
 /* Max time to wait for bus to become idle after a xfer (in us) */
 #define S3C2410_IDLE_TIMEOUT	5000
 
+/* Exynos5 Sysreg offset */
+#define EXYNOS5_SYS_I2C_CFG	0x0234
+
 /* i2c controller state */
 enum s3c24xx_i2c_state {
 	STATE_IDLE,
@@ -127,6 +132,8 @@ struct s3c24xx_i2c {
 #if defined(CONFIG_ARM_S3C24XX_CPUFREQ)
 	struct notifier_block	freq_transition;
 #endif
+	struct regmap		*sysreg;
+	unsigned int		sys_i2s_cfg;
 };
 
 static struct platform_device_id s3c24xx_driver_ids[] = {
@@ -1075,6 +1082,8 @@ static void
 s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
 {
 	struct s3c2410_platform_i2c *pdata = i2c->pdata;
+	u32 val = 0;
+	int id;
 
 	if (!np)
 		return;
@@ -1084,6 +1093,23 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
 	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
 	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
 				(u32 *)&pdata->frequency);
+	/*
+	 * Exynos5's legacy i2c controller and new high speed i2c
+	 * controller have muxed interrupt sources. By default the
+	 * interrupts for 4-channel HS-I2C controller are enabled.
+	 * If node for first four channels of legacy i2c controller
+	 * are available then re-configure the interrupts via the
+	 * system register.
+	 */
+	id = of_alias_get_id(np, "i2c");
+	i2c->sysreg = syscon_regmap_lookup_by_phandle(np,
+			"samsung,syscon-phandle");
+	if (IS_ERR(i2c->sysreg)) {
+		/* As this is not compulsory do not return error */
+		pr_info("i2c-%d skipping re-configuration of interrutps\n", id);
+		return;
+	}
+	regmap_update_bits(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, BIT(id), val);
 }
 #else
 static void
@@ -1268,6 +1294,9 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
 
 	i2c->suspended = 1;
 
+	if (!IS_ERR(i2c->sysreg))
+		regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &i2c->sys_i2s_cfg);
+
 	return 0;
 }
 
@@ -1276,6 +1305,9 @@ static int s3c24xx_i2c_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
+	if (!IS_ERR(i2c->sysreg))
+		regmap_write(i2c->sysreg, i2c->sys_i2s_cfg, EXYNOS5_SYS_I2C_CFG);
+
 	i2c->suspended = 0;
 	clk_prepare_enable(i2c->clk);
 	s3c24xx_i2c_init(i2c);
-- 
1.7.10.4

