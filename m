Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3JIOQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:16:44 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34421 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3JIOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:16:40 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the imx-mxs tree
Date: Wed,  9 Oct 2013 16:14:26 +0200
Message-Id: <1381328067-1593-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381328067-1593-1-git-send-email-treding@nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the imx-mxs tree got conflicts in

	arch/arm/mach-imx/clk-imx51-imx53.c
	arch/arm/mach-imx/mach-imx6q.c

caused by commits 0efe995 (ARM: mach-imx: clk-imx51-imx53: Retrieve base
address and irq from dt), d2b36f6 (ARM: imx: replace imx6q_restart()
with mxc_restart()) and 4d9d18a (ARM: imx: remove custom .init_time
hook).

I fixed them up (see below). Please verify that the resolution looks
good.

Thanks,
Thierry
---
diff --cc arch/arm/mach-imx/clk-imx51-imx53.c
index ceaac9c,03ca2e3..fa4de9a
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@@ -11,9 -11,11 +11,12 @@@
  #include <linux/clk.h>
  #include <linux/io.h>
  #include <linux/clkdev.h>
 +#include <linux/clk-provider.h>
  #include <linux/of.h>
  #include <linux/err.h>
+ #include <linux/of.h>
+ #include <linux/of_address.h>
+ #include <linux/of_irq.h>
  
  #include "crm-regs-imx5.h"
  #include "clk.h"
@@@ -464,16 -468,13 +467,17 @@@ int __init mx51_clocks_init(unsigned lo
  	return 0;
  }
  
 -int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 -			unsigned long rate_ckih1, unsigned long rate_ckih2)
 +static void __init mx51_clocks_init_dt(struct device_node *np)
 +{
 +	mx51_clocks_init(0, 0, 0, 0);
 +}
 +CLK_OF_DECLARE(imx51_ccm, "fsl,imx51-ccm", mx51_clocks_init_dt);
 +
 +static void __init mx53_clocks_init(struct device_node *np)
  {
- 	int i;
+ 	int i, irq;
  	unsigned long r;
 -	struct device_node *np;
+ 	void __iomem *base;
  
  	clk[pll1_sw] = imx_clk_pllv2("pll1_sw", "osc", MX53_DPLL1_BASE);
  	clk[pll2_sw] = imx_clk_pllv2("pll2_sw", "osc", MX53_DPLL2_BASE);
@@@ -568,5 -567,22 +569,13 @@@
  
  	r = clk_round_rate(clk[usboh3_per_gate], 54000000);
  	clk_set_rate(clk[usboh3_per_gate], r);
+ 
+ 	np = of_find_compatible_node(NULL, NULL, "fsl,imx53-gpt");
+ 	base = of_iomap(np, 0);
+ 	WARN_ON(!base);
+ 	irq = irq_of_parse_and_map(np, 0);
+ 	mxc_timer_init(base, irq);
+ 
+ 	return 0;
  }
 -
 -int __init mx51_clocks_init_dt(void)
 -{
 -	return mx51_clocks_init(0, 0, 0, 0);
 -}
 -
 -int __init mx53_clocks_init_dt(void)
 -{
 -	return mx53_clocks_init(0, 0, 0, 0);
 -}
 +CLK_OF_DECLARE(imx53_ccm, "fsl,imx53-ccm", mx53_clocks_init);
diff --cc arch/arm/mach-imx/mach-imx6q.c
index 3be0fa0,53e70f4..0f9f241
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@@ -11,9 -11,10 +11,8 @@@
   */
  
  #include <linux/clk.h>
 -#include <linux/clk-provider.h>
  #include <linux/clkdev.h>
 -#include <linux/clocksource.h>
  #include <linux/cpu.h>
- #include <linux/delay.h>
  #include <linux/export.h>
  #include <linux/init.h>
  #include <linux/io.h>
@@@ -190,8 -133,13 +131,16 @@@ static void __init imx6q_1588_init(void
  
  static void __init imx6q_init_machine(void)
  {
+ 	struct device *parent;
+ 
 +	imx_print_silicon_rev(cpu_is_imx6dl() ? "i.MX6DL" : "i.MX6Q",
- 			      imx6q_revision());
++			      imx_get_soc_revision());
++
+ 	mxc_arch_reset_init_dt();
+ 
+ 	parent = imx_soc_device_init();
+ 	if (parent == NULL)
+ 		pr_warn("failed to initialize soc device\n");
  
  	imx6q_enet_phy_init();
  
