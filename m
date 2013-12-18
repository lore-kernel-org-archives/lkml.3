Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3LRM7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:59:09 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47118 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3LRM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:59:07 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, arm@kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, olof@lixom.net,
        soren.brinkmann@xilinx.com, peter.crosthwaite@xilinx.com,
        linux@roeck-us.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v6 0/2] ARM: mach-moxart: add MOXA ART SoC support
Date: Wed, 18 Dec 2013 13:58:44 +0100
Message-Id: <1387371526-15309-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the replies!

This should tick the boxes on feedback except for one detail
on the fixed rate clock:

Moving fixed-clock "ref12" from .dtsi to .dts proved problematic
for other clocks, this is why ref12 is still in SoC.

My assertion is that "fixed-clock" clocks are probed later when
placed in .dts (see diff and boot log below).
of_clk_get() from clk_pll in .dtsi fails, i.e. fixed-clock ref12
is not added as a provider in time before clk_pll loads.

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 1ed591a..89dc8ca 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -98,8 +98,10 @@ void of_fixed_clk_setup(struct device_node *node)
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT, rate);
-	if (!IS_ERR(clk))
+	if (!IS_ERR(clk)) {
+		pr_info("%s: of_clk_add_provider node=%p\n", __func__, node);
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	}
 }
 EXPORT_SYMBOL_GPL(of_fixed_clk_setup);
 CLK_OF_DECLARE(fixed_clk, "fixed-clock", of_fixed_clk_setup);

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8312736..bd6c0c6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2192,13 +2192,21 @@ struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 	/* Check if we have such a provider in our array */
 	mutex_lock(&of_clk_lock);
 	list_for_each_entry(provider, &of_clk_providers, link) {
+		pr_info("%s: provider->node=%p clkspec->np=%p\n", __func__, provider->node, clkspec->np);
 		if (provider->node == clkspec->np)
 			clk = provider->get(clkspec, provider->data);
-		if (!IS_ERR(clk))
+		if (!IS_ERR(clk)) {
 			break;
+		} else {
+			pr_info("%s: provider->get() failed\n", __func__);
+		}
 	}
 	mutex_unlock(&of_clk_lock);
 
+	if (IS_ERR(clk)) {
+		pr_info("%s: no providers\n", __func__);
+	}
+
 	return clk;
 }
 
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..57b2fc6 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -36,8 +36,10 @@ struct clk *of_clk_get(struct device_node *np, int index)
 
 	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
 					&clkspec);
-	if (rc)
+	if (rc) {
+		pr_info("%s: of_parse_phandle_with_args() failed\n", __func__);
 		return ERR_PTR(rc);
+	}
 
 	clk = of_clk_get_from_provider(&clkspec);
 	of_node_put(clkspec.np);

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.13.0-rc4-next-20131218+ (i@Ildjarn) (gcc version 4.6.3 (crosstool-NG 1.16.0) ) #1387 PREEMPT Wed Dec 18 12:20:50 CET 2013
[    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine model: MOXA UC-7112-LX
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: Data cache writeback
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
[    0.000000] Kernel command line: console=ttyS0,115200n8 earlyprintk root=/dev/mmcblk0p1 rw rootwait
[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Memory: 29616K/32768K available (2266K kernel code, 71K rwdata, 216K rodata, 103K init, 111K bss, 3152K reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0274c44   (2484 kB)
[    0.000000]       .init : 0xc0275000 - 0xc028ed50   ( 104 kB)
[    0.000000]       .data : 0xc0290000 - 0xc02a1ee0   (  72 kB)
[    0.000000]        .bss : 0xc02a1eec - 0xc02bdb64   ( 112 kB)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] of_clk_get_from_provider: no providers
[    0.000000] /soc/clk_pll@98100000: of_clk_get failed
[    0.000000] of_clk_get_from_provider: no providers
[    0.000000] /soc/clk_apb@98100000: of_clk_get failed
[    0.000000] of_fixed_clk_setup: of_clk_add_provider node=c02ff5bc
[    0.000000] of_clk_get_from_provider: provider->node=c02ff5bc clkspec->np=c02fe7dc
[    0.000000] of_clk_get_from_provider: provider->get() failed
[    0.000000] of_clk_get_from_provider: no providers
[    0.000000] Kernel panic - not syncing: /soc/timer@98400000: of_clk_get failed

Changes since v5:

1. change Makefile objects list order, sort alphabetically
2. add "clocks = <&ref12>" to clk_pll node in board file,
   remove it from SoC
3. move PHY nodes from SoC to board

Applies to next-20131218

Jonas Jensen (2):
  ARM: mach-moxart: add MOXA ART SoC platform files
  ARM: mach-moxart: add MOXA ART SoC device tree files

 Documentation/devicetree/bindings/arm/moxart.txt |  12 ++
 arch/arm/Kconfig                                 |   2 +
 arch/arm/Makefile                                |   1 +
 arch/arm/boot/dts/Makefile                       |   1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts            | 109 ++++++++++++++++
 arch/arm/boot/dts/moxart.dtsi                    | 154 +++++++++++++++++++++++
 arch/arm/configs/moxart_defconfig                | 149 ++++++++++++++++++++++
 arch/arm/mach-moxart/Kconfig                     |  31 +++++
 arch/arm/mach-moxart/Makefile                    |   3 +
 arch/arm/mach-moxart/moxart.c                    |  15 +++
 10 files changed, 477 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi
 create mode 100644 arch/arm/configs/moxart_defconfig
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/moxart.c

-- 
1.8.2.1

