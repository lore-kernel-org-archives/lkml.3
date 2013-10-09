Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3JIOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:16:59 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:36000 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3JIOQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:16:42 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the mvebu tree
Date: Wed,  9 Oct 2013 16:14:27 +0200
Message-Id: <1381328067-1593-6-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381328067-1593-1-git-send-email-treding@nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the mvebu tree got conflicts in

	arch/arm/mach-dove/board-dt.c
	arch/arm/mach-kirkwood/board-dt.c

caused by commits ebd7d3a (ARM: kirkwood: retain MAC address for DT
ethernet), 511aaab (ARM: kirkwood: Remove unneeded MBus initialization)
and a169e3a (ARM: kirkwood: remove custom .init_time hook) as well as
ccbd35c (ARM: dove: remove legacy pcie and clock init), e5901b5 (ARM:
dove: switch to DT probed mbus address windows) and 51e40f5 (ARM: dove:
remove custom .init_time hook).

I fixed them up (see below). Please verify that the resolution looks
good.

Thanks,
Thierry
---
diff --cc arch/arm/mach-dove/board-dt.c
index ddb8663,9a116d7..49fa9ab
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@@ -17,37 -20,15 +17,8 @@@
  #include <mach/dove.h>
  #include <mach/pm.h>
  #include <plat/common.h>
 -#include <plat/irq.h>
  #include "common.h"
  
- /*
-  * There are still devices that doesn't even know about DT,
-  * get clock gates here and add a clock lookup.
-  */
- static void __init dove_legacy_clk_init(void)
- {
- 	struct device_node *np = of_find_compatible_node(NULL, NULL,
- 					 "marvell,dove-gating-clock");
- 	struct of_phandle_args clkspec;
- 
- 	clkspec.np = np;
- 	clkspec.args_count = 1;
- 
- 	clkspec.args[0] = CLOCK_GATING_BIT_PCIE0;
- 	orion_clkdev_add("0", "pcie",
- 			 of_clk_get_from_provider(&clkspec));
- 
- 	clkspec.args[0] = CLOCK_GATING_BIT_PCIE1;
- 	orion_clkdev_add("1", "pcie",
- 			 of_clk_get_from_provider(&clkspec));
- }
- 
- static void __init dove_dt_init_early(void)
 -static void __init dove_dt_time_init(void)
--{
- 	mvebu_mbus_init("marvell,dove-mbus",
- 			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
- 			DOVE_MC_WINS_BASE, DOVE_MC_WINS_SZ);
 -	of_clk_init(NULL);
 -	clocksource_of_init();
--}
--
  static void __init dove_dt_init(void)
  {
  	pr_info("Dove 88AP510 SoC\n");
@@@ -73,7 -47,7 +37,6 @@@ static const char * const dove_dt_board
  
  DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
  	.map_io		= dove_map_io,
- 	.init_early	= dove_dt_init_early,
 -	.init_time	= dove_dt_time_init,
  	.init_machine	= dove_dt_init,
  	.restart	= dove_restart,
  	.dt_compat	= dove_dt_board_compat,
diff --cc arch/arm/mach-kirkwood/board-dt.c
index a32a3e5,2ac2a3f..9caa4fe
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@@ -13,8 -13,11 +13,10 @@@
  #include <linux/kernel.h>
  #include <linux/init.h>
  #include <linux/of.h>
+ #include <linux/of_address.h>
+ #include <linux/of_net.h>
  #include <linux/of_platform.h>
  #include <linux/clk-provider.h>
 -#include <linux/clocksource.h>
  #include <linux/dma-mapping.h>
  #include <linux/irqchip.h>
  #include <linux/kexec.h>
@@@ -65,13 -60,91 +59,85 @@@ static void __init kirkwood_legacy_clk_
  	clk_prepare_enable(clk);
  }
  
- static void __init kirkwood_dt_init_early(void)
+ #define MV643XX_ETH_MAC_ADDR_LOW	0x0414
+ #define MV643XX_ETH_MAC_ADDR_HIGH	0x0418
+ 
+ static void __init kirkwood_dt_eth_fixup(void)
  {
- 	mvebu_mbus_init("marvell,kirkwood-mbus",
- 			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
- 			DDR_WINDOW_CPU_BASE, DDR_WINDOW_CPU_SZ);
+ 	struct device_node *np;
+ 
+ 	/*
+ 	 * The ethernet interfaces forget the MAC address assigned by u-boot
+ 	 * if the clocks are turned off. Usually, u-boot on kirkwood boards
+ 	 * has no DT support to properly set local-mac-address property.
+ 	 * As a workaround, we get the MAC address from mv643xx_eth registers
+ 	 * and update the port device node if no valid MAC address is set.
+ 	 */
+ 	for_each_compatible_node(np, NULL, "marvell,kirkwood-eth-port") {
+ 		struct device_node *pnp = of_get_parent(np);
+ 		struct clk *clk;
+ 		struct property *pmac;
+ 		void __iomem *io;
+ 		u8 *macaddr;
+ 		u32 reg;
+ 
+ 		if (!pnp)
+ 			continue;
+ 
+ 		/* skip disabled nodes or nodes with valid MAC address*/
+ 		if (!of_device_is_available(pnp) || of_get_mac_address(np))
+ 			goto eth_fixup_skip;
+ 
+ 		clk = of_clk_get(pnp, 0);
+ 		if (IS_ERR(clk))
+ 			goto eth_fixup_skip;
+ 
+ 		io = of_iomap(pnp, 0);
+ 		if (!io)
+ 			goto eth_fixup_no_map;
+ 
+ 		/* ensure port clock is not gated to not hang CPU */
+ 		clk_prepare_enable(clk);
+ 
+ 		/* store MAC address register contents in local-mac-address */
+ 		pr_err(FW_INFO "%s: local-mac-address is not set\n",
+ 		       np->full_name);
+ 
+ 		pmac = kzalloc(sizeof(*pmac) + 6, GFP_KERNEL);
+ 		if (!pmac)
+ 			goto eth_fixup_no_mem;
+ 
+ 		pmac->value = pmac + 1;
+ 		pmac->length = 6;
+ 		pmac->name = kstrdup("local-mac-address", GFP_KERNEL);
+ 		if (!pmac->name) {
+ 			kfree(pmac);
+ 			goto eth_fixup_no_mem;
+ 		}
+ 
+ 		macaddr = pmac->value;
+ 		reg = readl(io + MV643XX_ETH_MAC_ADDR_HIGH);
+ 		macaddr[0] = (reg >> 24) & 0xff;
+ 		macaddr[1] = (reg >> 16) & 0xff;
+ 		macaddr[2] = (reg >> 8) & 0xff;
+ 		macaddr[3] = reg & 0xff;
+ 
+ 		reg = readl(io + MV643XX_ETH_MAC_ADDR_LOW);
+ 		macaddr[4] = (reg >> 8) & 0xff;
+ 		macaddr[5] = reg & 0xff;
+ 
+ 		of_update_property(np, pmac);
+ 
+ eth_fixup_no_mem:
+ 		iounmap(io);
+ 		clk_disable_unprepare(clk);
+ eth_fixup_no_map:
+ 		clk_put(clk);
+ eth_fixup_skip:
+ 		of_node_put(pnp);
+ 	}
  }
  
 -static void __init kirkwood_dt_time_init(void)
 -{
 -	of_clk_init(NULL);
 -	clocksource_of_init();
 -}
 -
  static void __init kirkwood_dt_init(void)
  {
  	pr_info("Kirkwood: %s, TCLK=%d.\n", kirkwood_id(), kirkwood_tclk);
@@@ -114,7 -187,7 +180,6 @@@ static const char * const kirkwood_dt_b
  DT_MACHINE_START(KIRKWOOD_DT, "Marvell Kirkwood (Flattened Device Tree)")
  	/* Maintainer: Jason Cooper <jason@lakedaemon.net> */
  	.map_io		= kirkwood_map_io,
- 	.init_early	= kirkwood_dt_init_early,
 -	.init_time	= kirkwood_dt_time_init,
  	.init_machine	= kirkwood_dt_init,
  	.restart	= kirkwood_restart,
  	.dt_compat	= kirkwood_dt_board_compat,
