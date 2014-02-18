Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaBRJri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:47:38 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754472AbaBRJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:47:35 -0500
Message-ID: <53032C14.9020502@free-electrons.com>
Date: Tue, 18 Feb 2014 10:47:00 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        =?UTF-8?B?RW1pbA==?= =?UTF-8?B?aW8gTMOzcGV6?= 
	<emilio@elopez.com.ar>
CC: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140205183457.GW8533@titan.lakedaemon.net> <20140217141336.GA2765@localhost> <53021BD2.3090301@free-electrons.com> <20140217152147.GC2765@localhost> <53022AA9.8090606@free-electrons.com> <20140217154421.GD2765@localhost> <530231C5.8090905@free-electrons.com> <20140217181902.GG2765@localhost>
In-Reply-To: <20140217181902.GG2765@localhost>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------060405060608090300010205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060405060608090300010205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/02/2014 19:19, Ezequiel Garcia wrote:
> On Mon, Feb 17, 2014 at 04:59:01PM +0100, Gregory CLEMENT wrote:
> [..]
>>>
>>> Right. If you think it adds a regression, then that's a perfectly valid reasons
>>> for nacking.
>>>
>>> However, I'd like to double-check we have such a regression. I guess you're
>>> talking about the "tclk" name being hardcoded. IMHO, it's hardcoded in the
>>> driver in the first place:
>>>
>>> void __init mvebu_coreclk_setup(struct device_node *np,
>>> 				const struct coreclk_soc_desc *desc)
>>> {
>>> 	const char *tclk_name = "tclk";
>>> [..] 
>>
>>
>> Here it is just about giving a name to a clock. As in the device tree
>> we only refer to the clock by index, the name don't matter.
>>
> 
> Unless I'm really confused about what's the problem here, the *name* is
> *all* that matters.
> 
> We're having a clock *registration* order issue (which is different from clock
> enable). Let me try to explain the issue, in case it's still not clear.
> 
> I'll stick to the current specific problem but it can apply to any other
> pair of parent/child.
> 
> Some of the mvebu clocks are registered as part of the "core" clock
> group, modeled by the "marvell,armada-370-core-clock" compatible node.
> 
> Another group of mvebu clocks are registered as part of the "gating"
> clock group, modeled by the "marvell,armada-370-gating-clock" compatible
> node.
> 
> By default, all the gating clocks are child of the first registered core
> clock. This clock is named "tclk" by default, and this name can be overloaded
> in the devicetree.
> 
> So far, so good, right?
> 
> The issue we're trying to fix, arises from the mvebu_clk_gating_setup()
> trying to get the name of this "tclk", as a registered clock.
> 
> In other words, the current code needs the tclk to be registered, for it
> will ask his name like this:
> 
> 	const char *default_parent = NULL;
> 
> 	clk = of_clk_get(np, 0);
> 	if (!IS_ERR(clk)) {
> 		default_parent = __clk_get_name(clk);
> 		clk_put(clk);
> 	}
> 
> Once it gets the name, all goes smoothly. Notice how the clock is obtained
> for the sole purpose of getting the name of it, which shows clearly it's the
> *name* that matters.
> 
> The ordering issue happens when the gating clock group is probed, before
> the core clock group. In that case, it's not possible to get the
> "&coreclk 0" (which is wrongly assumed to be registered), and so it's
> not possible to get the name.
> 
> So the root of the problem is that snippet above, which adds a
> completely unneeded registration order requirement. Instead, we should
> be looking for the names: we can hardcode the name or fetch it from the
> devicetree (Emilio has posted patches for both).
> 
> I really don't see why we're not fixing this, instead of adding yet
> another layer of complexity to the problem.

All this have already discussed in the previous emails. And even if Emilio
denied introducing a regression, it was what the code did. See my example
here:
http://article.gmane.org/gmane.linux.kernel/1649439

Now as you both are really annoying with it, what would be an acceptable
version would be the something like the patch attached. There will be still
an issue if old dtb is used with recent kernel, but at least the user will
be warned.

This code only fix the Armada 370 case, a complete solution should modify
the dtsi for Armada XP, Armada 375, Armada 38x, Kirkwood and Dove. It should
also make the outputname mandatory for gate-clk for consistency.


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

--------------060405060608090300010205
Content-Type: text/x-diff;
 name="0001-RFC-clk-mvebu-make-clock-output-names-mandatory.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-RFC-clk-mvebu-make-clock-output-names-mandatory.patch"

>From ca82f66b8fbb8247b0ec2c407726105e1e1af419 Mon Sep 17 00:00:00 2001
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Date: Tue, 18 Feb 2014 10:38:08 +0100
Subject: [PATCH] [RFC] clk:mvebu: make clock-output-names mandatory

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 .../devicetree/bindings/clock/mvebu-core-clock.txt |  7 ++--
 arch/arm/boot/dts/armada-370.dtsi                  |  1 +
 drivers/clk/mvebu/common.c                         | 38 +++++++++++++++-------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
index 307a503c5db8..4f2e3953b6a6 100644
--- a/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
+++ b/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
@@ -40,16 +40,15 @@ Required properties:
 	"marvell,mv88f6180-core-clock" - for Kirkwood MV88f6180 SoC
 - reg : shall be the register address of the Sample-At-Reset (SAR) register
 - #clock-cells : from common clock binding; shall be set to 1
-
-Optional properties:
-- clock-output-names : from common clock binding; allows overwrite default clock
-	output names ("tclk", "cpuclk", "l2clk", "ddrclk")
+- clock-output-names : from common clock binding; should be the clock
+	output names given above
 
 Example:
 
 core_clk: core-clocks@d0214 {
 	compatible = "marvell,dove-core-clock";
 	reg = <0xd0214 0x4>;
+	clock-output-names = "tclk", "cpuclk", "l2clk", "ddrclk";
 	#clock-cells = <1>;
 };
 
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index af1f11e9e5a0..0d5853d05bd6 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -196,6 +196,7 @@
 			coreclk: mvebu-sar@18230 {
 				compatible = "marvell,armada-370-core-clock";
 				reg = <0x18230 0x08>;
+				clock-output-names = "tclk", "cpuclk", "nbclk", "hclk", "dramclk";
 				#clock-cells = <1>;
 			};
 
diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
index 25ceccf939ad..5e7c9274e4d3 100644
--- a/drivers/clk/mvebu/common.c
+++ b/drivers/clk/mvebu/common.c
@@ -51,16 +51,21 @@ void __init mvebu_coreclk_setup(struct device_node *np,
 	}
 
 	/* Register TCLK */
-	of_property_read_string_index(np, "clock-output-names", 0,
-				      &tclk_name);
+	if (of_property_read_string_index(np, "clock-output-names", 0,
+						&tclk_name))
+		pr_err("%s[0]: clock-output-names is mandatory\n"
+			"\"%s\" will be used by default\n", np->name, tclk_name);
 	rate = desc->get_tclk_freq(base);
 	clk_data.clks[0] = clk_register_fixed_rate(NULL, tclk_name, NULL,
 						   CLK_IS_ROOT, rate);
 	WARN_ON(IS_ERR(clk_data.clks[0]));
 
 	/* Register CPU clock */
-	of_property_read_string_index(np, "clock-output-names", 1,
-				      &cpuclk_name);
+	if (of_property_read_string_index(np, "clock-output-names", 1,
+						&cpuclk_name))
+		pr_err("%s[1]: clock-output-names is mandatory\n"
+			"\"%s\" will be used by default\n",
+			np->name, cpuclk_name);
 	rate = desc->get_cpu_freq(base);
 	clk_data.clks[1] = clk_register_fixed_rate(NULL, cpuclk_name, NULL,
 						   CLK_IS_ROOT, rate);
@@ -71,8 +76,11 @@ void __init mvebu_coreclk_setup(struct device_node *np,
 		const char *rclk_name = desc->ratios[n].name;
 		int mult, div;
 
-		of_property_read_string_index(np, "clock-output-names",
-					      2+n, &rclk_name);
+		if (of_property_read_string_index(np, "clock-output-names",
+							2+n, &rclk_name))
+			pr_err("%s[%d]:clock-output-names is mandatory\n"
+				"\"%s\" will be used by default\n",
+				np->name, 2+n, rclk_name);
 		desc->get_clk_ratio(base, desc->ratios[n].id, &mult, &div);
 		clk_data.clks[2+n] = clk_register_fixed_factor(NULL, rclk_name,
 				       cpuclk_name, 0, mult, div);
@@ -119,19 +127,27 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 				   const struct clk_gating_soc_desc *desc)
 {
 	struct clk_gating_ctrl *ctrl;
-	struct clk *clk;
 	void __iomem *base;
 	const char *default_parent = NULL;
 	int n;
+	struct of_phandle_args clkspec;
 
 	base = of_iomap(np, 0);
 	if (WARN_ON(!base))
 		return;
 
-	clk = of_clk_get(np, 0);
-	if (!IS_ERR(clk)) {
-		default_parent = __clk_get_name(clk);
-		clk_put(clk);
+	if (!of_parse_phandle_with_args(np, "clocks", "#clock-cells", 0, &clkspec)) {
+		of_property_read_string_index(clkspec.np, "clock-output-names",
+					clkspec.args_count ? clkspec.args[0] : 0,
+					&default_parent);
+		if (WARN_ON(default_parent == NULL)) {
+			pr_err("%s: The clock-output-names of the parent clock is mandatory.\n"
+				"%s: As this proprety is missing, this parent will be ignored.\n"
+				"%s: The tclk clock will be used as parent clock\n",
+				np->name, np->name, np->name);
+			default_parent = "tclk";
+		}
+		of_node_put(clkspec.np);
 	}
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
-- 
1.8.1.2


--------------060405060608090300010205--
