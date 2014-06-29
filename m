Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaF2Q5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:57:53 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:52047 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaF2Q5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:57:45 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@gmail.com>
Subject: [PATCH 1/2] MIPS: Alchemy: au1000 header file cleanup
Date: Sun, 29 Jun 2014 18:57:34 +0200
Message-Id: <1404061055-89797-2-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
References: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove the custom au_read/write{bwl} accessors as well as au_sync,
  and replace them with __raw_readl/writel/wmb in all users.
- changes absolute register addresses to offsets from their base:
  - rename the SYS_xxx definitions to AU1000_SYS_ so people know
    that addresses have changed.
  - add helpers to read/write SYS registers, and use them.
- removes unused register/bit definitions (unused hw blocks, ...)
- moves ethernet register/bit descriptions to au1000_eth driver.
  It's not used there either, but I didn't want to lose it.

No functional changes.

Tested on DB1300 and DB1500.

---
 arch/mips/alchemy/board-mtx1.c                  |    4 +-
 arch/mips/alchemy/board-xxs1500.c               |    4 +-
 arch/mips/alchemy/common/clocks.c               |    7 +-
 arch/mips/alchemy/common/dbdma.c                |   22 +-
 arch/mips/alchemy/common/dma.c                  |   15 +-
 arch/mips/alchemy/common/irq.c                  |    4 +-
 arch/mips/alchemy/common/platform.c             |    2 +-
 arch/mips/alchemy/common/power.c                |   88 +-
 arch/mips/alchemy/common/setup.c                |    3 +-
 arch/mips/alchemy/common/time.c                 |   25 +-
 arch/mips/alchemy/devboards/db1000.c            |    5 +-
 arch/mips/alchemy/devboards/db1200.c            |   29 +-
 arch/mips/alchemy/devboards/db1300.c            |   10 +-
 arch/mips/alchemy/devboards/db1550.c            |   25 +-
 arch/mips/alchemy/devboards/pm.c                |   39 +-
 arch/mips/include/asm/mach-au1x00/au1000.h      | 2571 ++++++++++-------------
 arch/mips/include/asm/mach-au1x00/au1000_dma.h  |   51 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1000.h |   66 +-
 arch/mips/pci/pci-alchemy.c                     |   65 +-
 drivers/mmc/host/au1xmmc.c                      |  168 +-
 drivers/mtd/nand/au1550nd.c                     |   52 +-
 drivers/net/ethernet/amd/au1000_eth.c           |  155 +-
 drivers/rtc/rtc-au1xxx.c                        |   18 +-
 drivers/spi/spi-au1550.c                        |   66 +-
 drivers/video/fbdev/au1100fb.c                  |   15 +-
 drivers/video/fbdev/au1200fb.c                  |   34 +-
 sound/soc/au1x/psc-ac97.c                       |  140 +-
 sound/soc/au1x/psc-i2s.c                        |  100 +-
 sound/soc/au1x/psc.h                            |   22 +-
 29 files changed, 1826 insertions(+), 1979 deletions(-)

diff --git a/arch/mips/alchemy/board-mtx1.c b/arch/mips/alchemy/board-mtx1.c
index 25a59a2..962cefa 100644
--- a/arch/mips/alchemy/board-mtx1.c
+++ b/arch/mips/alchemy/board-mtx1.c
@@ -85,10 +85,10 @@ void __init board_setup(void)
 #endif /* IS_ENABLED(CONFIG_USB_OHCI_HCD) */
 
 	/* Initialize sys_pinfunc */
-	au_writel(SYS_PF_NI2, SYS_PINFUNC);
+	AU1X_WRSYS(SYS_PF_NI2, AU1000_SYS_PINFUNC);
 
 	/* Initialize GPIO */
-	au_writel(~0, KSEG1ADDR(AU1000_SYS_PHYS_ADDR) + SYS_TRIOUTCLR);
+	AU1X_WRSYS(~0, AU1000_SYS_TRIOUTCLR);
 	alchemy_gpio_direction_output(0, 0);	/* Disable M66EN (PCI 66MHz) */
 	alchemy_gpio_direction_output(3, 1);	/* Disable PCI CLKRUN# */
 	alchemy_gpio_direction_output(1, 1);	/* Enable EXT_IO3 */
diff --git a/arch/mips/alchemy/board-xxs1500.c b/arch/mips/alchemy/board-xxs1500.c
index 3fb814b..b4cd364 100644
--- a/arch/mips/alchemy/board-xxs1500.c
+++ b/arch/mips/alchemy/board-xxs1500.c
@@ -87,9 +87,9 @@ void __init board_setup(void)
 	alchemy_gpio2_enable();
 
 	/* Set multiple use pins (UART3/GPIO) to UART (it's used as UART too) */
-	pin_func  = au_readl(SYS_PINFUNC) & ~SYS_PF_UR3;
+	pin_func  = AU1X_RDSYS(AU1000_SYS_PINFUNC) & ~SYS_PF_UR3;
 	pin_func |= SYS_PF_UR3;
-	au_writel(pin_func, SYS_PINFUNC);
+	AU1X_WRSYS(pin_func, AU1000_SYS_PINFUNC);
 
 	/* Enable UART */
 	alchemy_uart_enable(AU1000_UART3_PHYS_ADDR);
diff --git a/arch/mips/alchemy/common/clocks.c b/arch/mips/alchemy/common/clocks.c
index f38298a..35db35b 100644
--- a/arch/mips/alchemy/common/clocks.c
+++ b/arch/mips/alchemy/common/clocks.c
@@ -91,13 +91,14 @@ unsigned long au1xxx_calc_clock(void)
 	if (au1xxx_cpu_has_pll_wo())
 		cpu_speed = 396000000;
 	else
-		cpu_speed = (au_readl(SYS_CPUPLL) & 0x0000003f) * AU1000_SRC_CLK;
+		cpu_speed = (AU1X_RDSYS(AU1000_SYS_CPUPLL) & 0x0000003f)
+				* AU1000_SRC_CLK;
 
 	/* On Alchemy CPU:counter ratio is 1:1 */
 	mips_hpt_frequency = cpu_speed;
 	/* Equation: Baudrate = CPU / (SD * 2 * CLKDIV * 16) */
-	set_au1x00_uart_baud_base(cpu_speed / (2 * ((int)(au_readl(SYS_POWERCTRL)
-							  & 0x03) + 2) * 16));
+	set_au1x00_uart_baud_base(cpu_speed /
+		(2 * ((AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 0x03) + 2) * 16));
 
 	set_au1x00_speed(cpu_speed);
 
diff --git a/arch/mips/alchemy/common/dbdma.c b/arch/mips/alchemy/common/dbdma.c
index 19d5642..508955e 100644
--- a/arch/mips/alchemy/common/dbdma.c
+++ b/arch/mips/alchemy/common/dbdma.c
@@ -341,7 +341,7 @@ u32 au1xxx_dbdma_chan_alloc(u32 srcid, u32 destid,
 			(dtp->dev_flags & DEV_FLAGS_SYNC))
 				i |= DDMA_CFG_SYNC;
 		cp->ddma_cfg = i;
-		au_sync();
+		wmb();
 
 		/*
 		 * Return a non-zero value that can be used to find the channel
@@ -631,7 +631,7 @@ u32 au1xxx_dbdma_put_source(u32 chanid, dma_addr_t buf, int nbytes, u32 flags)
 	 */
 	dma_cache_wback_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
-	au_sync();
+	wmb();
 	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
 
@@ -693,7 +693,7 @@ u32 au1xxx_dbdma_put_dest(u32 chanid, dma_addr_t buf, int nbytes, u32 flags)
 	 */
 	dma_cache_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
-	au_sync();
+	wmb();
 	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
 
@@ -760,7 +760,7 @@ void au1xxx_dbdma_stop(u32 chanid)
 
 	cp = ctp->chan_ptr;
 	cp->ddma_cfg &= ~DDMA_CFG_EN;	/* Disable channel */
-	au_sync();
+	wmb();
 	while (!(cp->ddma_stat & DDMA_STAT_H)) {
 		udelay(1);
 		halt_timeout++;
@@ -771,7 +771,7 @@ void au1xxx_dbdma_stop(u32 chanid)
 	}
 	/* clear current desc valid and doorbell */
 	cp->ddma_stat |= (DDMA_STAT_DB | DDMA_STAT_V);
-	au_sync();
+	wmb();
 }
 EXPORT_SYMBOL(au1xxx_dbdma_stop);
 
@@ -789,9 +789,9 @@ void au1xxx_dbdma_start(u32 chanid)
 	cp = ctp->chan_ptr;
 	cp->ddma_desptr = virt_to_phys(ctp->cur_ptr);
 	cp->ddma_cfg |= DDMA_CFG_EN;	/* Enable channel */
-	au_sync();
+	wmb();
 	cp->ddma_dbell = 0;
-	au_sync();
+	wmb();
 }
 EXPORT_SYMBOL(au1xxx_dbdma_start);
 
@@ -832,7 +832,7 @@ u32 au1xxx_get_dma_residue(u32 chanid)
 
 	/* This is only valid if the channel is stopped. */
 	rv = cp->ddma_bytecnt;
-	au_sync();
+	wmb();
 
 	return rv;
 }
@@ -868,7 +868,7 @@ static irqreturn_t dbdma_interrupt(int irq, void *dev_id)
 	au1x_dma_chan_t *cp;
 
 	intstat = dbdma_gptr->ddma_intstat;
-	au_sync();
+	wmb();
 	chan_index = __ffs(intstat);
 
 	ctp = chan_tab_ptr[chan_index];
@@ -877,7 +877,7 @@ static irqreturn_t dbdma_interrupt(int irq, void *dev_id)
 
 	/* Reset interrupt. */
 	cp->ddma_irq = 0;
-	au_sync();
+	wmb();
 
 	if (ctp->chan_callback)
 		ctp->chan_callback(irq, ctp->chan_callparam);
@@ -1061,7 +1061,7 @@ static int __init dbdma_setup(unsigned int irq, dbdev_tab_t *idtable)
 	dbdma_gptr->ddma_config = 0;
 	dbdma_gptr->ddma_throttle = 0;
 	dbdma_gptr->ddma_inten = 0xffff;
-	au_sync();
+	wmb();
 
 	ret = request_irq(irq, dbdma_interrupt, 0, "dbdma", (void *)dbdma_gptr);
 	if (ret)
diff --git a/arch/mips/alchemy/common/dma.c b/arch/mips/alchemy/common/dma.c
index 9b624e2..7d0ffb8 100644
--- a/arch/mips/alchemy/common/dma.c
+++ b/arch/mips/alchemy/common/dma.c
@@ -141,17 +141,17 @@ void dump_au1000_dma_channel(unsigned int dmanr)
 
 	printk(KERN_INFO "Au1000 DMA%d Register Dump:\n", dmanr);
 	printk(KERN_INFO "  mode = 0x%08x\n",
-	       au_readl(chan->io + DMA_MODE_SET));
+	       __raw_readl(chan->io + DMA_MODE_SET));
 	printk(KERN_INFO "  addr = 0x%08x\n",
-	       au_readl(chan->io + DMA_PERIPHERAL_ADDR));
+	       __raw_readl(chan->io + DMA_PERIPHERAL_ADDR));
 	printk(KERN_INFO "  start0 = 0x%08x\n",
-	       au_readl(chan->io + DMA_BUFFER0_START));
+	       __raw_readl(chan->io + DMA_BUFFER0_START));
 	printk(KERN_INFO "  start1 = 0x%08x\n",
-	       au_readl(chan->io + DMA_BUFFER1_START));
+	       __raw_readl(chan->io + DMA_BUFFER1_START));
 	printk(KERN_INFO "  count0 = 0x%08x\n",
-	       au_readl(chan->io + DMA_BUFFER0_COUNT));
+	       __raw_readl(chan->io + DMA_BUFFER0_COUNT));
 	printk(KERN_INFO "  count1 = 0x%08x\n",
-	       au_readl(chan->io + DMA_BUFFER1_COUNT));
+	       __raw_readl(chan->io + DMA_BUFFER1_COUNT));
 }
 
 /*
@@ -204,7 +204,8 @@ int request_au1000_dma(int dev_id, const char *dev_str,
 	}
 
 	/* fill it in */
-	chan->io = KSEG1ADDR(AU1000_DMA_PHYS_ADDR) + i * DMA_CHANNEL_LEN;
+	chan->io = (void __iomem *)(KSEG1ADDR(AU1000_DMA_PHYS_ADDR) +
+				    i * DMA_CHANNEL_LEN);
 	chan->dev_id = dev_id;
 	chan->dev_str = dev_str;
 	chan->fifo_addr = dev->fifo_addr;
diff --git a/arch/mips/alchemy/common/irq.c b/arch/mips/alchemy/common/irq.c
index 63a7181..f98c211 100644
--- a/arch/mips/alchemy/common/irq.c
+++ b/arch/mips/alchemy/common/irq.c
@@ -389,12 +389,12 @@ static int au1x_ic1_setwake(struct irq_data *d, unsigned int on)
 		return -EINVAL;
 
 	local_irq_save(flags);
-	wakemsk = __raw_readl((void __iomem *)SYS_WAKEMSK);
+	wakemsk = AU1X_RDSYS(AU1000_SYS_WAKEMSK);
 	if (on)
 		wakemsk |= 1 << bit;
 	else
 		wakemsk &= ~(1 << bit);
-	__raw_writel(wakemsk, (void __iomem *)SYS_WAKEMSK);
+	AU1X_WRSYS(wakemsk, AU1000_SYS_WAKEMSK);
 	wmb();
 	local_irq_restore(flags);
 
diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index 9837a13..4cdc8fd 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -420,7 +420,7 @@ static void __init alchemy_setup_macs(int ctype)
 		memcpy(au1xxx_eth1_platform_data.mac, ethaddr, 6);
 
 	/* Register second MAC if enabled in pinfunc */
-	if (!(au_readl(SYS_PINFUNC) & (u32)SYS_PF_NI2)) {
+	if (!(AU1X_RDSYS(AU1000_SYS_PINFUNC) & SYS_PF_NI2)) {
 		ret = platform_device_register(&au1xxx_eth1_device);
 		if (ret)
 			printk(KERN_INFO "Alchemy: failed to register MAC1\n");
diff --git a/arch/mips/alchemy/common/power.c b/arch/mips/alchemy/common/power.c
index bdb28dee..4798a90 100644
--- a/arch/mips/alchemy/common/power.c
+++ b/arch/mips/alchemy/common/power.c
@@ -50,32 +50,46 @@ static unsigned int sleep_sys_clocks[5];
 static unsigned int sleep_sys_pinfunc;
 static unsigned int sleep_static_memctlr[4][3];
 
+static inline unsigned long AU1X_RDMST(unsigned long ofs)
+{
+	void __iomem *b = (void __iomem *)
+			KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	return __raw_readl(b + ofs);
+}
+
+static inline void AU1X_WRMST(unsigned long d, unsigned long ofs)
+{
+	void __iomem *b = (void __iomem *)
+			KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	__raw_writel(d, b + ofs);
+	wmb();
+}
 
 static void save_core_regs(void)
 {
 	/* Clocks and PLLs. */
-	sleep_sys_clocks[0] = au_readl(SYS_FREQCTRL0);
-	sleep_sys_clocks[1] = au_readl(SYS_FREQCTRL1);
-	sleep_sys_clocks[2] = au_readl(SYS_CLKSRC);
-	sleep_sys_clocks[3] = au_readl(SYS_CPUPLL);
-	sleep_sys_clocks[4] = au_readl(SYS_AUXPLL);
+	sleep_sys_clocks[0] = AU1X_RDSYS(AU1000_SYS_FREQCTRL0);
+	sleep_sys_clocks[1] = AU1X_RDSYS(AU1000_SYS_FREQCTRL1);
+	sleep_sys_clocks[2] = AU1X_RDSYS(AU1000_SYS_CLKSRC);
+	sleep_sys_clocks[3] = AU1X_RDSYS(AU1000_SYS_CPUPLL);
+	sleep_sys_clocks[4] = AU1X_RDSYS(AU1000_SYS_AUXPLL);
 
 	/* pin mux config */
-	sleep_sys_pinfunc = au_readl(SYS_PINFUNC);
+	sleep_sys_pinfunc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
 
 	/* Save the static memory controller configuration. */
-	sleep_static_memctlr[0][0] = au_readl(MEM_STCFG0);
-	sleep_static_memctlr[0][1] = au_readl(MEM_STTIME0);
-	sleep_static_memctlr[0][2] = au_readl(MEM_STADDR0);
-	sleep_static_memctlr[1][0] = au_readl(MEM_STCFG1);
-	sleep_static_memctlr[1][1] = au_readl(MEM_STTIME1);
-	sleep_static_memctlr[1][2] = au_readl(MEM_STADDR1);
-	sleep_static_memctlr[2][0] = au_readl(MEM_STCFG2);
-	sleep_static_memctlr[2][1] = au_readl(MEM_STTIME2);
-	sleep_static_memctlr[2][2] = au_readl(MEM_STADDR2);
-	sleep_static_memctlr[3][0] = au_readl(MEM_STCFG3);
-	sleep_static_memctlr[3][1] = au_readl(MEM_STTIME3);
-	sleep_static_memctlr[3][2] = au_readl(MEM_STADDR3);
+	sleep_static_memctlr[0][0] = AU1X_RDMST(AU1000_MEM_STCFG0);
+	sleep_static_memctlr[0][1] = AU1X_RDMST(AU1000_MEM_STTIME0);
+	sleep_static_memctlr[0][2] = AU1X_RDMST(AU1000_MEM_STADDR0);
+	sleep_static_memctlr[1][0] = AU1X_RDMST(AU1000_MEM_STCFG1);
+	sleep_static_memctlr[1][1] = AU1X_RDMST(AU1000_MEM_STTIME1);
+	sleep_static_memctlr[1][2] = AU1X_RDMST(AU1000_MEM_STADDR1);
+	sleep_static_memctlr[2][0] = AU1X_RDMST(AU1000_MEM_STCFG2);
+	sleep_static_memctlr[2][1] = AU1X_RDMST(AU1000_MEM_STTIME2);
+	sleep_static_memctlr[2][2] = AU1X_RDMST(AU1000_MEM_STADDR2);
+	sleep_static_memctlr[3][0] = AU1X_RDMST(AU1000_MEM_STCFG3);
+	sleep_static_memctlr[3][1] = AU1X_RDMST(AU1000_MEM_STTIME3);
+	sleep_static_memctlr[3][2] = AU1X_RDMST(AU1000_MEM_STADDR3);
 }
 
 static void restore_core_regs(void)
@@ -85,30 +99,28 @@ static void restore_core_regs(void)
 	 * one of those Au1000 with a write-only PLL, where we dont
 	 * have a valid value)
 	 */
-	au_writel(sleep_sys_clocks[0], SYS_FREQCTRL0);
-	au_writel(sleep_sys_clocks[1], SYS_FREQCTRL1);
-	au_writel(sleep_sys_clocks[2], SYS_CLKSRC);
-	au_writel(sleep_sys_clocks[4], SYS_AUXPLL);
+	AU1X_WRSYS(sleep_sys_clocks[0], AU1000_SYS_FREQCTRL0);
+	AU1X_WRSYS(sleep_sys_clocks[1], AU1000_SYS_FREQCTRL1);
+	AU1X_WRSYS(sleep_sys_clocks[2], AU1000_SYS_CLKSRC);
+	AU1X_WRSYS(sleep_sys_clocks[4], AU1000_SYS_AUXPLL);
 	if (!au1xxx_cpu_has_pll_wo())
-		au_writel(sleep_sys_clocks[3], SYS_CPUPLL);
-	au_sync();
+		AU1X_WRSYS(sleep_sys_clocks[3], AU1000_SYS_CPUPLL);
 
-	au_writel(sleep_sys_pinfunc, SYS_PINFUNC);
-	au_sync();
+	AU1X_WRSYS(sleep_sys_pinfunc, AU1000_SYS_PINFUNC);
 
 	/* Restore the static memory controller configuration. */
-	au_writel(sleep_static_memctlr[0][0], MEM_STCFG0);
-	au_writel(sleep_static_memctlr[0][1], MEM_STTIME0);
-	au_writel(sleep_static_memctlr[0][2], MEM_STADDR0);
-	au_writel(sleep_static_memctlr[1][0], MEM_STCFG1);
-	au_writel(sleep_static_memctlr[1][1], MEM_STTIME1);
-	au_writel(sleep_static_memctlr[1][2], MEM_STADDR1);
-	au_writel(sleep_static_memctlr[2][0], MEM_STCFG2);
-	au_writel(sleep_static_memctlr[2][1], MEM_STTIME2);
-	au_writel(sleep_static_memctlr[2][2], MEM_STADDR2);
-	au_writel(sleep_static_memctlr[3][0], MEM_STCFG3);
-	au_writel(sleep_static_memctlr[3][1], MEM_STTIME3);
-	au_writel(sleep_static_memctlr[3][2], MEM_STADDR3);
+	AU1X_WRMST(sleep_static_memctlr[0][0], AU1000_MEM_STCFG0);
+	AU1X_WRMST(sleep_static_memctlr[0][1], AU1000_MEM_STTIME0);
+	AU1X_WRMST(sleep_static_memctlr[0][2], AU1000_MEM_STADDR0);
+	AU1X_WRMST(sleep_static_memctlr[1][0], AU1000_MEM_STCFG1);
+	AU1X_WRMST(sleep_static_memctlr[1][1], AU1000_MEM_STTIME1);
+	AU1X_WRMST(sleep_static_memctlr[1][2], AU1000_MEM_STADDR1);
+	AU1X_WRMST(sleep_static_memctlr[2][0], AU1000_MEM_STCFG2);
+	AU1X_WRMST(sleep_static_memctlr[2][1], AU1000_MEM_STTIME2);
+	AU1X_WRMST(sleep_static_memctlr[2][2], AU1000_MEM_STADDR2);
+	AU1X_WRMST(sleep_static_memctlr[3][0], AU1000_MEM_STCFG3);
+	AU1X_WRMST(sleep_static_memctlr[3][1], AU1000_MEM_STTIME3);
+	AU1X_WRMST(sleep_static_memctlr[3][2], AU1000_MEM_STADDR3);
 }
 
 void au_sleep(void)
diff --git a/arch/mips/alchemy/common/setup.c b/arch/mips/alchemy/common/setup.c
index 8267e3c..6f8b91d 100644
--- a/arch/mips/alchemy/common/setup.c
+++ b/arch/mips/alchemy/common/setup.c
@@ -34,10 +34,9 @@
 #include <asm/mipsregs.h>
 #include <asm/time.h>
 
-#include <au1000.h>
+#include <asm/mach-au1x00/au1000.h>
 
 extern void __init board_setup(void);
-extern void set_cpuspec(void);
 
 void __init plat_mem_setup(void)
 {
diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
index 93fa586..4d9c303 100644
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -46,7 +46,7 @@
 
 static cycle_t au1x_counter1_read(struct clocksource *cs)
 {
-	return au_readl(SYS_RTCREAD);
+	return AU1X_RDSYS(AU1000_SYS_RTCREAD);
 }
 
 static struct clocksource au1x_counter1_clocksource = {
@@ -60,12 +60,11 @@ static struct clocksource au1x_counter1_clocksource = {
 static int au1x_rtcmatch2_set_next_event(unsigned long delta,
 					 struct clock_event_device *cd)
 {
-	delta += au_readl(SYS_RTCREAD);
+	delta += AU1X_RDSYS(AU1000_SYS_RTCREAD);
 	/* wait for register access */
-	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_M21)
-		;
-	au_writel(delta, SYS_RTCMATCH2);
-	au_sync();
+	while (AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_M21)
+		asm volatile ("nop");
+	AU1X_WRSYS(delta, AU1000_SYS_RTCMATCH2);
 
 	return 0;
 }
@@ -112,31 +111,29 @@ static int __init alchemy_time_init(unsigned int m2int)
 	 * (the 32S bit seems to be stuck set to 1 once a single clock-
 	 * edge is detected, hence the timeouts).
 	 */
-	if (CNTR_OK != (au_readl(SYS_COUNTER_CNTRL) & CNTR_OK))
+	if (CNTR_OK != (AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & CNTR_OK))
 		goto cntr_err;
 
 	/*
 	 * setup counter 1 (RTC) to tick at full speed
 	 */
 	t = 0xffffff;
-	while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T1S) && --t)
+	while ((AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_T1S) && --t)
 		asm volatile ("nop");
 	if (!t)
 		goto cntr_err;
 
-	au_writel(0, SYS_RTCTRIM);	/* 32.768 kHz */
-	au_sync();
+	AU1X_WRSYS(0, AU1000_SYS_RTCTRIM);	/* 32.768 kHz */
 
 	t = 0xffffff;
-	while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C1S) && --t)
+	while ((AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_C1S) && --t)
 		asm volatile ("nop");
 	if (!t)
 		goto cntr_err;
-	au_writel(0, SYS_RTCWRITE);
-	au_sync();
+	AU1X_WRSYS(0, AU1000_SYS_RTCWRITE);
 
 	t = 0xffffff;
-	while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C1S) && --t)
+	while ((AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_C1S) && --t)
 		asm volatile ("nop");
 	if (!t)
 		goto cntr_err;
diff --git a/arch/mips/alchemy/devboards/db1000.c b/arch/mips/alchemy/devboards/db1000.c
index 92dd929..6e55bcc 100644
--- a/arch/mips/alchemy/devboards/db1000.c
+++ b/arch/mips/alchemy/devboards/db1000.c
@@ -518,10 +518,9 @@ int __init db1000_dev_setup(void)
 		gpio_direction_input(20);	/* sd1 cd# */
 
 		/* spi_gpio on SSI0 pins */
-		pfc = __raw_readl((void __iomem *)SYS_PINFUNC);
+		pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
 		pfc |= (1 << 0);	/* SSI0 pins as GPIOs */
-		__raw_writel(pfc, (void __iomem *)SYS_PINFUNC);
-		wmb();
+		AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
 
 		spi_register_board_info(db1100_spi_info,
 					ARRAY_SIZE(db1100_spi_info));
diff --git a/arch/mips/alchemy/devboards/db1200.c b/arch/mips/alchemy/devboards/db1200.c
index 9e46667..8c71cde 100644
--- a/arch/mips/alchemy/devboards/db1200.c
+++ b/arch/mips/alchemy/devboards/db1200.c
@@ -150,12 +150,11 @@ int __init db1200_board_setup(void)
 		(whoami >> 4) & 0xf, (whoami >> 8) & 0xf, whoami & 0xf);
 
 	/* SMBus/SPI on PSC0, Audio on PSC1 */
-	pfc = __raw_readl((void __iomem *)SYS_PINFUNC);
+	pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
 	pfc &= ~(SYS_PINFUNC_P0A | SYS_PINFUNC_P0B);
 	pfc &= ~(SYS_PINFUNC_P1A | SYS_PINFUNC_P1B | SYS_PINFUNC_FS3);
 	pfc |= SYS_PINFUNC_P1C; /* SPI is configured later */
-	__raw_writel(pfc, (void __iomem *)SYS_PINFUNC);
-	wmb();
+	AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
 
 	/* Clock configurations: PSC0: ~50MHz via Clkgen0, derived from
 	 * CPU clock; all other clock generators off/unused.
@@ -166,16 +165,13 @@ int __init db1200_board_setup(void)
 	div = ((div >> 1) - 1) & 0xff;
 
 	freq0 = div << SYS_FC_FRDIV0_BIT;
-	__raw_writel(freq0, (void __iomem *)SYS_FREQCTRL0);
-	wmb();
+	AU1X_WRSYS(freq0, AU1000_SYS_FREQCTRL0);
 	freq0 |= SYS_FC_FE0;	/* enable F0 */
-	__raw_writel(freq0, (void __iomem *)SYS_FREQCTRL0);
-	wmb();
+	AU1X_WRSYS(freq0, AU1000_SYS_FREQCTRL0);
 
 	/* psc0_intclk comes 1:1 from F0 */
 	clksrc = SYS_CS_MUX_FQ0 << SYS_CS_ME0_BIT;
-	__raw_writel(clksrc, (void __iomem *)SYS_CLKSRC);
-	wmb();
+	AU1X_WRSYS(clksrc, AU1000_SYS_CLKSRC);
 
 	return 0;
 }
@@ -234,12 +230,12 @@ static void au1200_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
 	ioaddr &= 0xffffff00;
 
 	if (ctrl & NAND_CLE) {
-		ioaddr += MEM_STNAND_CMD;
+		ioaddr += AU1000_MEM_STNAND_CMD;
 	} else if (ctrl & NAND_ALE) {
-		ioaddr += MEM_STNAND_ADDR;
+		ioaddr += AU1000_MEM_STNAND_ADDR;
 	} else {
 		/* assume we want to r/w real data  by default */
-		ioaddr += MEM_STNAND_DATA;
+		ioaddr += AU1000_MEM_STNAND_DATA;
 	}
 	this->IO_ADDR_R = this->IO_ADDR_W = (void __iomem *)ioaddr;
 	if (cmd != NAND_CMD_NONE) {
@@ -250,7 +246,9 @@ static void au1200_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
 
 static int au1200_nand_device_ready(struct mtd_info *mtd)
 {
-	return __raw_readl((void __iomem *)MEM_STSTAT) & 1;
+	void __iomem *b = (void __iomem *)
+		KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	return __raw_readl(b + AU1000_MEM_STSTAT) & 1;
 }
 
 static struct mtd_partition db1200_nand_parts[] = {
@@ -886,7 +884,7 @@ int __init db1200_dev_setup(void)
 	 * As a result, in SPI mode, OTG simply won't work (PSC0 uses
 	 * it as an input pin which is pulled high on the boards).
 	 */
-	pfc = __raw_readl((void __iomem *)SYS_PINFUNC) & ~SYS_PINFUNC_P0A;
+	pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC) & ~SYS_PINFUNC_P0A;
 
 	/* switch off OTG VBUS supply */
 	gpio_request(215, "otg-vbus");
@@ -912,8 +910,7 @@ int __init db1200_dev_setup(void)
 		printk(KERN_INFO " S6.8 ON : PSC0 mode SPI\n");
 		printk(KERN_INFO "   OTG port VBUS supply disabled\n");
 	}
-	__raw_writel(pfc, (void __iomem *)SYS_PINFUNC);
-	wmb();
+	AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
 
 	/* Audio: DIP7 selects I2S(0)/AC97(1), but need I2C for I2S!
 	 * so: DIP7=1 || DIP8=0 => AC97, DIP7=0 && DIP8=1 => I2S
diff --git a/arch/mips/alchemy/devboards/db1300.c b/arch/mips/alchemy/devboards/db1300.c
index f3525ca..a00ff77 100644
--- a/arch/mips/alchemy/devboards/db1300.c
+++ b/arch/mips/alchemy/devboards/db1300.c
@@ -154,12 +154,12 @@ static void au1300_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
 	ioaddr &= 0xffffff00;
 
 	if (ctrl & NAND_CLE) {
-		ioaddr += MEM_STNAND_CMD;
+		ioaddr += AU1000_MEM_STNAND_CMD;
 	} else if (ctrl & NAND_ALE) {
-		ioaddr += MEM_STNAND_ADDR;
+		ioaddr += AU1000_MEM_STNAND_ADDR;
 	} else {
 		/* assume we want to r/w real data  by default */
-		ioaddr += MEM_STNAND_DATA;
+		ioaddr += AU1000_MEM_STNAND_DATA;
 	}
 	this->IO_ADDR_R = this->IO_ADDR_W = (void __iomem *)ioaddr;
 	if (cmd != NAND_CMD_NONE) {
@@ -170,7 +170,9 @@ static void au1300_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
 
 static int au1300_nand_device_ready(struct mtd_info *mtd)
 {
-	return __raw_readl((void __iomem *)MEM_STSTAT) & 1;
+	void __iomem *b = (void __iomem *)
+		KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	return __raw_readl(b + AU1000_MEM_STSTAT) & 1;
 }
 
 static struct mtd_partition db1300_nand_parts[] = {
diff --git a/arch/mips/alchemy/devboards/db1550.c b/arch/mips/alchemy/devboards/db1550.c
index bbd8d98..e70708f 100644
--- a/arch/mips/alchemy/devboards/db1550.c
+++ b/arch/mips/alchemy/devboards/db1550.c
@@ -31,16 +31,16 @@
 static void __init db1550_hw_setup(void)
 {
 	void __iomem *base;
+	unsigned long v;
 
 	/* complete SPI setup: link psc0_intclk to a 48MHz source,
 	 * and assign GPIO16 to PSC0_SYNC1 (SPI cs# line) as well as PSC1_SYNC
 	 * for AC97 on PB1550.
 	 */
-	base = (void __iomem *)SYS_CLKSRC;
-	__raw_writel(__raw_readl(base) | 0x000001e0, base);
-	base = (void __iomem *)SYS_PINFUNC;
-	__raw_writel(__raw_readl(base) | 1 | SYS_PF_PSC1_S1, base);
-	wmb();
+	v = AU1X_RDSYS(AU1000_SYS_CLKSRC);
+	AU1X_WRSYS(v | 0x000001e0, AU1000_SYS_CLKSRC);
+	v = AU1X_RDSYS(AU1000_SYS_PINFUNC);
+	AU1X_WRSYS(v | 1 | SYS_PF_PSC1_S1, AU1000_SYS_PINFUNC);
 
 	/* reset the AC97 codec now, the reset time in the psc-ac97 driver
 	 * is apparently too short although it's ridiculous as it is.
@@ -135,12 +135,12 @@ static void au1550_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
 	ioaddr &= 0xffffff00;
 
 	if (ctrl & NAND_CLE) {
-		ioaddr += MEM_STNAND_CMD;
+		ioaddr += AU1000_MEM_STNAND_CMD;
 	} else if (ctrl & NAND_ALE) {
-		ioaddr += MEM_STNAND_ADDR;
+		ioaddr += AU1000_MEM_STNAND_ADDR;
 	} else {
 		/* assume we want to r/w real data  by default */
-		ioaddr += MEM_STNAND_DATA;
+		ioaddr += AU1000_MEM_STNAND_DATA;
 	}
 	this->IO_ADDR_R = this->IO_ADDR_W = (void __iomem *)ioaddr;
 	if (cmd != NAND_CMD_NONE) {
@@ -151,7 +151,9 @@ static void au1550_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
 
 static int au1550_nand_device_ready(struct mtd_info *mtd)
 {
-	return __raw_readl((void __iomem *)MEM_STSTAT) & 1;
+	void __iomem *b = (void __iomem *)
+		KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	return __raw_readl(b + AU1000_MEM_STSTAT) & 1;
 }
 
 static struct mtd_partition db1550_nand_parts[] = {
@@ -217,7 +219,10 @@ static struct platform_device pb1550_nand_dev = {
 
 static void __init pb1550_nand_setup(void)
 {
-	int boot_swapboot = (au_readl(MEM_STSTAT) & (0x7 << 1)) |
+	void __iomem *b = (void __iomem *)
+		(KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR)
+		+ AU1000_MEM_STSTAT);
+	int boot_swapboot = (__raw_readl(b) & (0x7 << 1)) |
 			    ((bcsr_read(BCSR_STATUS) >> 6) & 0x1);
 
 	gpio_direction_input(206);	/* de-assert NAND CS# */
diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index 61e90fe..38053472 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -45,23 +45,20 @@ static int db1x_pm_enter(suspend_state_t state)
 	alchemy_gpio1_input_enable();
 
 	/* clear and setup wake cause and source */
-	au_writel(0, SYS_WAKEMSK);
-	au_sync();
-	au_writel(0, SYS_WAKESRC);
-	au_sync();
+	AU1X_WRSYS(0, AU1000_SYS_WAKEMSK);
+	AU1X_WRSYS(0, AU1000_SYS_WAKESRC);
 
-	au_writel(db1x_pm_wakemsk, SYS_WAKEMSK);
-	au_sync();
+	AU1X_WRSYS(db1x_pm_wakemsk, AU1000_SYS_WAKEMSK);
 
 	/* setup 1Hz-timer-based wakeup: wait for reg access */
-	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_M20)
+	while (AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_M20)
 		asm volatile ("nop");
 
-	au_writel(au_readl(SYS_TOYREAD) + db1x_pm_sleep_secs, SYS_TOYMATCH2);
-	au_sync();
+	db1x_pm_sleep_secs += AU1X_RDSYS(AU1000_SYS_TOYREAD);
+	AU1X_WRSYS(db1x_pm_sleep_secs, AU1000_SYS_TOYMATCH2);
 
 	/* wait for value to really hit the register */
-	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_M20)
+	while (AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_M20)
 		asm volatile ("nop");
 
 	/* ...and now the sandman can come! */
@@ -102,12 +99,10 @@ static void db1x_pm_end(void)
 	/* read and store wakeup source, the clear the register. To
 	 * be able to clear it, WAKEMSK must be cleared first.
 	 */
-	db1x_pm_last_wakesrc = au_readl(SYS_WAKESRC);
-
-	au_writel(0, SYS_WAKEMSK);
-	au_writel(0, SYS_WAKESRC);
-	au_sync();
+	db1x_pm_last_wakesrc = AU1X_RDSYS(AU1000_SYS_WAKESRC);
 
+	AU1X_WRSYS(0, AU1000_SYS_WAKEMSK);
+	AU1X_WRSYS(0, AU1000_SYS_WAKESRC);
 }
 
 static const struct platform_suspend_ops db1x_pm_ops = {
@@ -242,17 +237,13 @@ static int __init pm_init(void)
 	 * for confirmation since there's plenty of time from here to
 	 * the next suspend cycle.
 	 */
-	if (au_readl(SYS_TOYTRIM) != 32767) {
-		au_writel(32767, SYS_TOYTRIM);
-		au_sync();
-	}
+	if (AU1X_RDSYS(AU1000_SYS_TOYTRIM) != 32767)
+		AU1X_WRSYS(32767, AU1000_SYS_TOYTRIM);
 
-	db1x_pm_last_wakesrc = au_readl(SYS_WAKESRC);
+	db1x_pm_last_wakesrc = AU1X_RDSYS(AU1000_SYS_WAKESRC);
 
-	au_writel(0, SYS_WAKESRC);
-	au_sync();
-	au_writel(0, SYS_WAKEMSK);
-	au_sync();
+	AU1X_WRSYS(0, AU1000_SYS_WAKESRC);
+	AU1X_WRSYS(0, AU1000_SYS_WAKEMSK);
 
 	suspend_set_ops(&db1x_pm_ops);
 
diff --git a/arch/mips/include/asm/mach-au1x00/au1000.h b/arch/mips/include/asm/mach-au1x00/au1000.h
index b4c3ecb..d3b5284 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000.h
@@ -35,1528 +35,1217 @@
 #define _AU1000_H_
 
 
-#ifndef _LANGUAGE_ASSEMBLY
+/* SOC Interrupt numbers */
+/* Au1000-style (IC0/1): 2 controllers with 32 sources each */
+#define AU1000_INTC0_INT_BASE	(MIPS_CPU_IRQ_BASE + 8)
+#define AU1000_INTC0_INT_LAST	(AU1000_INTC0_INT_BASE + 31)
+#define AU1000_INTC1_INT_BASE	(AU1000_INTC0_INT_LAST + 1)
+#define AU1000_INTC1_INT_LAST	(AU1000_INTC1_INT_BASE + 31)
+#define AU1000_MAX_INTR		AU1000_INTC1_INT_LAST
 
-#include <linux/delay.h>
-#include <linux/types.h>
+/* Au1300-style (GPIC): 1 controller with up to 128 sources */
+#define ALCHEMY_GPIC_INT_BASE	(MIPS_CPU_IRQ_BASE + 8)
+#define ALCHEMY_GPIC_INT_NUM	128
+#define ALCHEMY_GPIC_INT_LAST	(ALCHEMY_GPIC_INT_BASE + ALCHEMY_GPIC_INT_NUM - 1)
 
-#include <linux/io.h>
-#include <linux/irq.h>
+/* Au1300 peripheral interrupt numbers */
+#define AU1300_FIRST_INT	(ALCHEMY_GPIC_INT_BASE)
+#define AU1300_UART1_INT	(AU1300_FIRST_INT + 17)
+#define AU1300_UART2_INT	(AU1300_FIRST_INT + 25)
+#define AU1300_UART3_INT	(AU1300_FIRST_INT + 27)
+#define AU1300_SD1_INT		(AU1300_FIRST_INT + 32)
+#define AU1300_SD2_INT		(AU1300_FIRST_INT + 38)
+#define AU1300_PSC0_INT		(AU1300_FIRST_INT + 48)
+#define AU1300_PSC1_INT		(AU1300_FIRST_INT + 52)
+#define AU1300_PSC2_INT		(AU1300_FIRST_INT + 56)
+#define AU1300_PSC3_INT		(AU1300_FIRST_INT + 60)
+#define AU1300_NAND_INT		(AU1300_FIRST_INT + 62)
+#define AU1300_DDMA_INT		(AU1300_FIRST_INT + 75)
+#define AU1300_MMU_INT		(AU1300_FIRST_INT + 76)
+#define AU1300_MPU_INT		(AU1300_FIRST_INT + 77)
+#define AU1300_GPU_INT		(AU1300_FIRST_INT + 78)
+#define AU1300_UDMA_INT		(AU1300_FIRST_INT + 79)
+#define AU1300_TOY_INT		(AU1300_FIRST_INT + 80)
+#define AU1300_TOY_MATCH0_INT	(AU1300_FIRST_INT + 81)
+#define AU1300_TOY_MATCH1_INT	(AU1300_FIRST_INT + 82)
+#define AU1300_TOY_MATCH2_INT	(AU1300_FIRST_INT + 83)
+#define AU1300_RTC_INT		(AU1300_FIRST_INT + 84)
+#define AU1300_RTC_MATCH0_INT	(AU1300_FIRST_INT + 85)
+#define AU1300_RTC_MATCH1_INT	(AU1300_FIRST_INT + 86)
+#define AU1300_RTC_MATCH2_INT	(AU1300_FIRST_INT + 87)
+#define AU1300_UART0_INT	(AU1300_FIRST_INT + 88)
+#define AU1300_SD0_INT		(AU1300_FIRST_INT + 89)
+#define AU1300_USB_INT		(AU1300_FIRST_INT + 90)
+#define AU1300_LCD_INT		(AU1300_FIRST_INT + 91)
+#define AU1300_BSA_INT		(AU1300_FIRST_INT + 92)
+#define AU1300_MPE_INT		(AU1300_FIRST_INT + 93)
+#define AU1300_ITE_INT		(AU1300_FIRST_INT + 94)
+#define AU1300_AES_INT		(AU1300_FIRST_INT + 95)
+#define AU1300_CIM_INT		(AU1300_FIRST_INT + 96)
 
-#include <asm/cpu.h>
+/**********************************************************************/
 
-/* cpu pipeline flush */
-void static inline au_sync(void)
-{
-	__asm__ volatile ("sync");
-}
+/*
+ * Physical base addresses for integrated peripherals
+ * 0..au1000 1..au1500 2..au1100 3..au1550 4..au1200 5..au1300
+ */
 
-void static inline au_sync_udelay(int us)
-{
-	__asm__ volatile ("sync");
-	udelay(us);
-}
+#define AU1000_AC97_PHYS_ADDR		0x10000000 /* 012 */
+#define AU1300_ROM_PHYS_ADDR		0x10000000 /* 5 */
+#define AU1300_OTP_PHYS_ADDR		0x10002000 /* 5 */
+#define AU1300_VSS_PHYS_ADDR		0x10003000 /* 5 */
+#define AU1300_UART0_PHYS_ADDR		0x10100000 /* 5 */
+#define AU1300_UART1_PHYS_ADDR		0x10101000 /* 5 */
+#define AU1300_UART2_PHYS_ADDR		0x10102000 /* 5 */
+#define AU1300_UART3_PHYS_ADDR		0x10103000 /* 5 */
+#define AU1000_USB_OHCI_PHYS_ADDR	0x10100000 /* 012 */
+#define AU1000_USB_UDC_PHYS_ADDR	0x10200000 /* 0123 */
+#define AU1300_GPIC_PHYS_ADDR		0x10200000 /* 5 */
+#define AU1000_IRDA_PHYS_ADDR		0x10300000 /* 02 */
+#define AU1200_AES_PHYS_ADDR		0x10300000 /* 45 */
+#define AU1000_IC0_PHYS_ADDR		0x10400000 /* 01234 */
+#define AU1300_GPU_PHYS_ADDR		0x10500000 /* 5 */
+#define AU1000_MAC0_PHYS_ADDR		0x10500000 /* 023 */
+#define AU1000_MAC1_PHYS_ADDR		0x10510000 /* 023 */
+#define AU1000_MACEN_PHYS_ADDR		0x10520000 /* 023 */
+#define AU1100_SD0_PHYS_ADDR		0x10600000 /* 245 */
+#define AU1300_SD1_PHYS_ADDR		0x10601000 /* 5 */
+#define AU1300_SD2_PHYS_ADDR		0x10602000 /* 5 */
+#define AU1100_SD1_PHYS_ADDR		0x10680000 /* 24 */
+#define AU1300_SYS_PHYS_ADDR		0x10900000 /* 5 */
+#define AU1550_PSC2_PHYS_ADDR		0x10A00000 /* 3 */
+#define AU1550_PSC3_PHYS_ADDR		0x10B00000 /* 3 */
+#define AU1300_PSC0_PHYS_ADDR		0x10A00000 /* 5 */
+#define AU1300_PSC1_PHYS_ADDR		0x10A01000 /* 5 */
+#define AU1300_PSC2_PHYS_ADDR		0x10A02000 /* 5 */
+#define AU1300_PSC3_PHYS_ADDR		0x10A03000 /* 5 */
+#define AU1000_I2S_PHYS_ADDR		0x11000000 /* 02 */
+#define AU1500_MAC0_PHYS_ADDR		0x11500000 /* 1 */
+#define AU1500_MAC1_PHYS_ADDR		0x11510000 /* 1 */
+#define AU1500_MACEN_PHYS_ADDR		0x11520000 /* 1 */
+#define AU1000_UART0_PHYS_ADDR		0x11100000 /* 01234 */
+#define AU1200_SWCNT_PHYS_ADDR		0x1110010C /* 4 */
+#define AU1000_UART1_PHYS_ADDR		0x11200000 /* 0234 */
+#define AU1000_UART2_PHYS_ADDR		0x11300000 /* 0 */
+#define AU1000_UART3_PHYS_ADDR		0x11400000 /* 0123 */
+#define AU1000_SSI0_PHYS_ADDR		0x11600000 /* 02 */
+#define AU1000_SSI1_PHYS_ADDR		0x11680000 /* 02 */
+#define AU1500_GPIO2_PHYS_ADDR		0x11700000 /* 1234 */
+#define AU1000_IC1_PHYS_ADDR		0x11800000 /* 01234 */
+#define AU1000_SYS_PHYS_ADDR		0x11900000 /* 012345 */
+#define AU1550_PSC0_PHYS_ADDR		0x11A00000 /* 34 */
+#define AU1550_PSC1_PHYS_ADDR		0x11B00000 /* 34 */
+#define AU1000_MEM_PHYS_ADDR		0x14000000 /* 012345 */
+#define AU1000_STATIC_MEM_PHYS_ADDR	0x14001000 /* 012345 */
+#define AU1300_UDMA_PHYS_ADDR		0x14001800 /* 5 */
+#define AU1000_DMA_PHYS_ADDR		0x14002000 /* 012 */
+#define AU1550_DBDMA_PHYS_ADDR		0x14002000 /* 345 */
+#define AU1550_DBDMA_CONF_PHYS_ADDR	0x14003000 /* 345 */
+#define AU1000_MACDMA0_PHYS_ADDR	0x14004000 /* 0123 */
+#define AU1000_MACDMA1_PHYS_ADDR	0x14004200 /* 0123 */
+#define AU1200_CIM_PHYS_ADDR		0x14004000 /* 45 */
+#define AU1500_PCI_PHYS_ADDR		0x14005000 /* 13 */
+#define AU1550_PE_PHYS_ADDR		0x14008000 /* 3 */
+#define AU1200_MAEBE_PHYS_ADDR		0x14010000 /* 4 */
+#define AU1200_MAEFE_PHYS_ADDR		0x14012000 /* 4 */
+#define AU1300_MAEITE_PHYS_ADDR		0x14010000 /* 5 */
+#define AU1300_MAEMPE_PHYS_ADDR		0x14014000 /* 5 */
+#define AU1550_USB_OHCI_PHYS_ADDR	0x14020000 /* 3 */
+#define AU1200_USB_CTL_PHYS_ADDR	0x14020000 /* 4 */
+#define AU1200_USB_OTG_PHYS_ADDR	0x14020020 /* 4 */
+#define AU1200_USB_OHCI_PHYS_ADDR	0x14020100 /* 4 */
+#define AU1200_USB_EHCI_PHYS_ADDR	0x14020200 /* 4 */
+#define AU1200_USB_UDC_PHYS_ADDR	0x14022000 /* 4 */
+#define AU1300_USB_EHCI_PHYS_ADDR	0x14020000 /* 5 */
+#define AU1300_USB_OHCI0_PHYS_ADDR	0x14020400 /* 5 */
+#define AU1300_USB_OHCI1_PHYS_ADDR	0x14020800 /* 5 */
+#define AU1300_USB_CTL_PHYS_ADDR	0x14021000 /* 5 */
+#define AU1300_USB_OTG_PHYS_ADDR	0x14022000 /* 5 */
+#define AU1300_MAEBSA_PHYS_ADDR		0x14030000 /* 5 */
+#define AU1100_LCD_PHYS_ADDR		0x15000000 /* 2 */
+#define AU1200_LCD_PHYS_ADDR		0x15000000 /* 45 */
+#define AU1500_PCI_MEM_PHYS_ADDR	0x400000000ULL /* 13 */
+#define AU1500_PCI_IO_PHYS_ADDR		0x500000000ULL /* 13 */
+#define AU1500_PCI_CONFIG0_PHYS_ADDR	0x600000000ULL /* 13 */
+#define AU1500_PCI_CONFIG1_PHYS_ADDR	0x680000000ULL /* 13 */
+#define AU1000_PCMCIA_IO_PHYS_ADDR	0xF00000000ULL /* 012345 */
+#define AU1000_PCMCIA_ATTR_PHYS_ADDR	0xF40000000ULL /* 012345 */
+#define AU1000_PCMCIA_MEM_PHYS_ADDR	0xF80000000ULL /* 012345 */
 
-void static inline au_sync_delay(int ms)
-{
-	__asm__ volatile ("sync");
-	mdelay(ms);
-}
 
-void static inline au_writeb(u8 val, unsigned long reg)
-{
-	*(volatile u8 *)reg = val;
-}
+/**********************************************************************/
 
-void static inline au_writew(u16 val, unsigned long reg)
-{
-	*(volatile u16 *)reg = val;
-}
 
-void static inline au_writel(u32 val, unsigned long reg)
-{
-	*(volatile u32 *)reg = val;
-}
+/*
+ * Au1300 GPIO+INT controller (GPIC) register offsets and bits
+ * Registers are 128bits (0x10 bytes), divided into 4 "banks".
+ */
+#define AU1300_GPIC_PINVAL	0x0000
+#define AU1300_GPIC_PINVALCLR	0x0010
+#define AU1300_GPIC_IPEND	0x0020
+#define AU1300_GPIC_PRIENC	0x0030
+#define AU1300_GPIC_IEN		0x0040	/* int_mask in manual */
+#define AU1300_GPIC_IDIS	0x0050	/* int_maskclr in manual */
+#define AU1300_GPIC_DMASEL	0x0060
+#define AU1300_GPIC_DEVSEL	0x0080
+#define AU1300_GPIC_DEVCLR	0x0090
+#define AU1300_GPIC_RSTVAL	0x00a0
+/* pin configuration space. one 32bit register for up to 128 IRQs */
+#define AU1300_GPIC_PINCFG	0x1000
 
-static inline u8 au_readb(unsigned long reg)
-{
-	return *(volatile u8 *)reg;
-}
+#define GPIC_GPIO_TO_BIT(gpio)	\
+	(1 << ((gpio) & 0x1f))
 
-static inline u16 au_readw(unsigned long reg)
-{
-	return *(volatile u16 *)reg;
-}
+#define GPIC_GPIO_BANKOFF(gpio) \
+	(((gpio) >> 5) * 4)
 
-static inline u32 au_readl(unsigned long reg)
-{
-	return *(volatile u32 *)reg;
-}
+/* Pin Control bits: who owns the pin, what does it do */
+#define GPIC_CFG_PC_GPIN		0
+#define GPIC_CFG_PC_DEV			1
+#define GPIC_CFG_PC_GPOLOW		2
+#define GPIC_CFG_PC_GPOHIGH		3
+#define GPIC_CFG_PC_MASK		3
 
-/* Early Au1000 have a write-only SYS_CPUPLL register. */
-static inline int au1xxx_cpu_has_pll_wo(void)
-{
-	switch (read_c0_prid()) {
-	case 0x00030100:	/* Au1000 DA */
-	case 0x00030201:	/* Au1000 HA */
-	case 0x00030202:	/* Au1000 HB */
-		return 1;
-	}
-	return 0;
-}
+/* assign pin to MIPS IRQ line */
+#define GPIC_CFG_IL_SET(x)	(((x) & 3) << 2)
+#define GPIC_CFG_IL_MASK	(3 << 2)
 
-/* does CPU need CONFIG[OD] set to fix tons of errata? */
-static inline int au1xxx_cpu_needs_config_od(void)
-{
-	/*
-	 * c0_config.od (bit 19) was write only (and read as 0) on the
-	 * early revisions of Alchemy SOCs.  It disables the bus trans-
-	 * action overlapping and needs to be set to fix various errata.
-	 */
-	switch (read_c0_prid()) {
-	case 0x00030100: /* Au1000 DA */
-	case 0x00030201: /* Au1000 HA */
-	case 0x00030202: /* Au1000 HB */
-	case 0x01030200: /* Au1500 AB */
-	/*
-	 * Au1100/Au1200 errata actually keep silence about this bit,
-	 * so we set it just in case for those revisions that require
-	 * it to be set according to the (now gone) cpu_table.
-	 */
-	case 0x02030200: /* Au1100 AB */
-	case 0x02030201: /* Au1100 BA */
-	case 0x02030202: /* Au1100 BC */
-	case 0x04030201: /* Au1200 AC */
-		return 1;
-	}
-	return 0;
-}
+/* pin interrupt type setup */
+#define GPIC_CFG_IC_OFF		(0 << 4)
+#define GPIC_CFG_IC_LEVEL_LOW	(1 << 4)
+#define GPIC_CFG_IC_LEVEL_HIGH	(2 << 4)
+#define GPIC_CFG_IC_EDGE_FALL	(5 << 4)
+#define GPIC_CFG_IC_EDGE_RISE	(6 << 4)
+#define GPIC_CFG_IC_EDGE_BOTH	(7 << 4)
+#define GPIC_CFG_IC_MASK	(7 << 4)
 
-#define ALCHEMY_CPU_UNKNOWN	-1
-#define ALCHEMY_CPU_AU1000	0
-#define ALCHEMY_CPU_AU1500	1
-#define ALCHEMY_CPU_AU1100	2
-#define ALCHEMY_CPU_AU1550	3
-#define ALCHEMY_CPU_AU1200	4
-#define ALCHEMY_CPU_AU1300	5
+/* allow interrupt to wake cpu from 'wait' */
+#define GPIC_CFG_IDLEWAKE	(1 << 7)
 
-static inline int alchemy_get_cputype(void)
-{
-	switch (read_c0_prid() & (PRID_OPT_MASK | PRID_COMP_MASK)) {
-	case 0x00030000:
-		return ALCHEMY_CPU_AU1000;
-		break;
-	case 0x01030000:
-		return ALCHEMY_CPU_AU1500;
-		break;
-	case 0x02030000:
-		return ALCHEMY_CPU_AU1100;
-		break;
-	case 0x03030000:
-		return ALCHEMY_CPU_AU1550;
-		break;
-	case 0x04030000:
-	case 0x05030000:
-		return ALCHEMY_CPU_AU1200;
-		break;
-	case 0x800c0000:
-		return ALCHEMY_CPU_AU1300;
-		break;
-	}
+/***********************************************************************/
 
-	return ALCHEMY_CPU_UNKNOWN;
-}
+/* Au1000 SDRAM memory controller register offsets */
+#define AU1000_MEM_SDMODE0	0x0000
+#define AU1000_MEM_SDMODE1	0x0004
+#define AU1000_MEM_SDMODE2	0x0008
+#define AU1000_MEM_SDADDR0	0x000C
+#define AU1000_MEM_SDADDR1	0x0010
+#define AU1000_MEM_SDADDR2	0x0014
+#define AU1000_MEM_SDREFCFG	0x0018
+#define AU1000_MEM_SDPRECMD	0x001C
+#define AU1000_MEM_SDAUTOREF	0x0020
+#define AU1000_MEM_SDWRMD0	0x0024
+#define AU1000_MEM_SDWRMD1	0x0028
+#define AU1000_MEM_SDWRMD2	0x002C
+#define AU1000_MEM_SDSLEEP	0x0030
+#define AU1000_MEM_SDSMCKE	0x0034
 
-/* return number of uarts on a given cputype */
-static inline int alchemy_get_uarts(int type)
-{
-	switch (type) {
-	case ALCHEMY_CPU_AU1000:
-	case ALCHEMY_CPU_AU1300:
-		return 4;
-	case ALCHEMY_CPU_AU1500:
-	case ALCHEMY_CPU_AU1200:
-		return 2;
-	case ALCHEMY_CPU_AU1100:
-	case ALCHEMY_CPU_AU1550:
-		return 3;
-	}
-	return 0;
-}
+/* MEM_SDMODE register content definitions */
+#define MEM_SDMODE_F		(1 << 22)
+#define MEM_SDMODE_SR		(1 << 21)
+#define MEM_SDMODE_BS		(1 << 20)
+#define MEM_SDMODE_RS		(3 << 18)
+#define MEM_SDMODE_CS		(7 << 15)
+#define MEM_SDMODE_TRAS		(15 << 11)
+#define MEM_SDMODE_TMRD		(3 << 9)
+#define MEM_SDMODE_TWR		(3 << 7)
+#define MEM_SDMODE_TRP		(3 << 5)
+#define MEM_SDMODE_TRCD		(3 << 3)
+#define MEM_SDMODE_TCL		(7 << 0)
 
-/* enable an UART block if it isn't already */
-static inline void alchemy_uart_enable(u32 uart_phys)
-{
-	void __iomem *addr = (void __iomem *)KSEG1ADDR(uart_phys);
+#define MEM_SDMODE_BS_2Bank	(0 << 20)
+#define MEM_SDMODE_BS_4Bank	(1 << 20)
+#define MEM_SDMODE_RS_11Row	(0 << 18)
+#define MEM_SDMODE_RS_12Row	(1 << 18)
+#define MEM_SDMODE_RS_13Row	(2 << 18)
+#define MEM_SDMODE_RS_N(N)	((N) << 18)
+#define MEM_SDMODE_CS_7Col	(0 << 15)
+#define MEM_SDMODE_CS_8Col	(1 << 15)
+#define MEM_SDMODE_CS_9Col	(2 << 15)
+#define MEM_SDMODE_CS_10Col	(3 << 15)
+#define MEM_SDMODE_CS_11Col	(4 << 15)
+#define MEM_SDMODE_CS_N(N)	((N) << 15)
+#define MEM_SDMODE_TRAS_N(N)	((N) << 11)
+#define MEM_SDMODE_TMRD_N(N)	((N) << 9)
+#define MEM_SDMODE_TWR_N(N)	((N) << 7)
+#define MEM_SDMODE_TRP_N(N)	((N) << 5)
+#define MEM_SDMODE_TRCD_N(N)	((N) << 3)
+#define MEM_SDMODE_TCL_N(N)	((N) << 0)
 
-	/* reset, enable clock, deassert reset */
-	if ((__raw_readl(addr + 0x100) & 3) != 3) {
-		__raw_writel(0, addr + 0x100);
-		wmb();
-		__raw_writel(1, addr + 0x100);
-		wmb();
-	}
-	__raw_writel(3, addr + 0x100);
-	wmb();
-}
+/* MEM_SDADDR register contents definitions */
+#define MEM_SDADDR_E		(1 << 20)
+#define MEM_SDADDR_CSBA		(0x03FF << 10)
+#define MEM_SDADDR_CSMASK	(0x03FF << 0)
+#define MEM_SDADDR_CSBA_N(N)	((N) & (0x03FF << 22) >> 12)
+#define MEM_SDADDR_CSMASK_N(N)	((N)&(0x03FF << 22) >> 22)
 
-static inline void alchemy_uart_disable(u32 uart_phys)
-{
-	void __iomem *addr = (void __iomem *)KSEG1ADDR(uart_phys);
-	__raw_writel(0, addr + 0x100);	/* UART_MOD_CNTRL */
-	wmb();
-}
+/* MEM_SDREFCFG register content definitions */
+#define MEM_SDREFCFG_TRC	(15 << 28)
+#define MEM_SDREFCFG_TRPM	(3 << 26)
+#define MEM_SDREFCFG_E		(1 << 25)
+#define MEM_SDREFCFG_RE		(0x1ffffff << 0)
+#define MEM_SDREFCFG_TRC_N(N)	((N) << MEM_SDREFCFG_TRC)
+#define MEM_SDREFCFG_TRPM_N(N)	((N) << MEM_SDREFCFG_TRPM)
+#define MEM_SDREFCFG_REF_N(N)	(N)
 
-static inline void alchemy_uart_putchar(u32 uart_phys, u8 c)
-{
-	void __iomem *base = (void __iomem *)KSEG1ADDR(uart_phys);
-	int timeout, i;
+/* Au1550/Au1200 SDRAM Register Offsets */
+#define AU1550_MEM_SDMODE0	0x0800
+#define AU1550_MEM_SDMODE1	0x0808
+#define AU1550_MEM_SDMODE2	0x0810
+#define AU1550_MEM_SDADDR0	0x0820
+#define AU1550_MEM_SDADDR1	0x0828
+#define AU1550_MEM_SDADDR2	0x0830
+#define AU1550_MEM_SDCONFIGA	0x0840
+#define AU1550_MEM_SDCONFIGB	0x0848
+#define AU1550_MEM_SDSTAT	0x0850
+#define AU1550_MEM_SDERRADDR	0x0858
+#define AU1550_MEM_SDSTRIDE0	0x0860
+#define AU1550_MEM_SDSTRIDE1	0x0868
+#define AU1550_MEM_SDSTRIDE2	0x0870
+#define AU1550_MEM_SDWRMD0	0x0880
+#define AU1550_MEM_SDWRMD1	0x0888
+#define AU1550_MEM_SDWRMD2	0x0890
+#define AU1550_MEM_SDPRECMD	0x08C0
+#define AU1550_MEM_SDAUTOREF	0x08C8
+#define AU1550_MEM_SDSREF	0x08D0
+#define AU1550_MEM_SDSLEEP	AU1550_MEM_SDSREF
+
+/* Static Bus Controller register offsets */
+#define AU1000_MEM_STCFG0	0x0000
+#define AU1000_MEM_STTIME0	0x0004
+#define AU1000_MEM_STADDR0	0x0008
+#define AU1000_MEM_STCFG1	0x0010
+#define AU1000_MEM_STTIME1	0x0014
+#define AU1000_MEM_STADDR1	0x0018
+#define AU1000_MEM_STCFG2	0x0020
+#define AU1000_MEM_STTIME2	0x0024
+#define AU1000_MEM_STADDR2	0x0028
+#define AU1000_MEM_STCFG3	0x0030
+#define AU1000_MEM_STTIME3	0x0034
+#define AU1000_MEM_STADDR3	0x0038
+#define AU1000_MEM_STNDCTL	0x0100
+#define AU1000_MEM_STSTAT	0x0104
+
+/* NAND registers: offsets from programmed chipselect physical base */
+#define AU1000_MEM_STNAND_CMD	0x0000
+#define AU1000_MEM_STNAND_ADDR	0x0004
+#define AU1000_MEM_STNAND_DATA	0x0020
+
+
+/* Au1000 SYS_ Area ***************************************************/
+
+/* Programmable Counters 0 and 1 (RTC and TOY counters) */
+#define AU1000_SYS_CNTRCTRL	0x0014
+#define SYS_CNTRL_E1S		(1 << 23)
+#define SYS_CNTRL_T1S		(1 << 20)
+#define SYS_CNTRL_M21		(1 << 19)
+#define SYS_CNTRL_M11		(1 << 18)
+#define SYS_CNTRL_M01		(1 << 17)
+#define SYS_CNTRL_C1S		(1 << 16)
+#define SYS_CNTRL_BP		(1 << 14)
+#define SYS_CNTRL_EN1		(1 << 13)
+#define SYS_CNTRL_BT1		(1 << 12)
+#define SYS_CNTRL_EN0		(1 << 11)
+#define SYS_CNTRL_BT0		(1 << 10)
+#define SYS_CNTRL_E0		(1 << 8)
+#define SYS_CNTRL_E0S		(1 << 7)
+#define SYS_CNTRL_32S		(1 << 5)
+#define SYS_CNTRL_T0S		(1 << 4)
+#define SYS_CNTRL_M20		(1 << 3)
+#define SYS_CNTRL_M10		(1 << 2)
+#define SYS_CNTRL_M00		(1 << 1)
+#define SYS_CNTRL_C0S		(1 << 0)
+
+/* Programmable Counter 0 Register offsets */
+#define AU1000_SYS_TOYTRIM	0x0000
+#define AU1000_SYS_TOYWRITE	0x0004
+#define AU1000_SYS_TOYMATCH0	0x0008
+#define AU1000_SYS_TOYMATCH1	0x000C
+#define AU1000_SYS_TOYMATCH2	0x0010
+#define AU1000_SYS_TOYREAD	0x0040
+
+/* Programmable Counter 1 Register offsets */
+#define AU1000_SYS_RTCTRIM	0x0044
+#define AU1000_SYS_RTCWRITE	0x0048
+#define AU1000_SYS_RTCMATCH0	0x004C
+#define AU1000_SYS_RTCMATCH1	0x0050
+#define AU1000_SYS_RTCMATCH2	0x0054
+#define AU1000_SYS_RTCREAD	0x0058
+
+
+/* GPIO/Pin Function assignment */
+#define AU1000_SYS_PINFUNC	0x002C
+#  define SYS_PF_USB		(1 << 15)	/* 2nd USB device/host */
+#  define SYS_PF_U3		(1 << 14)	/* GPIO23/U3TXD */
+#  define SYS_PF_U2		(1 << 13)	/* GPIO22/U2TXD */
+#  define SYS_PF_U1		(1 << 12)	/* GPIO21/U1TXD */
+#  define SYS_PF_SRC		(1 << 11)	/* GPIO6/SROMCKE */
+#  define SYS_PF_CK5		(1 << 10)	/* GPIO3/CLK5 */
+#  define SYS_PF_CK4		(1 << 9)	/* GPIO2/CLK4 */
+#  define SYS_PF_IRF		(1 << 8)	/* GPIO15/IRFIRSEL */
+#  define SYS_PF_UR3		(1 << 7)	/* GPIO[14:9]/UART3 */
+#  define SYS_PF_I2D		(1 << 6)	/* GPIO8/I2SDI */
+#  define SYS_PF_I2S		(1 << 5)	/* I2S/GPIO[29:31] */
+#  define SYS_PF_NI2		(1 << 4)	/* NI2/GPIO[24:28] */
+#  define SYS_PF_U0		(1 << 3)	/* U0TXD/GPIO20 */
+#  define SYS_PF_RD		(1 << 2)	/* IRTXD/GPIO19 */
+#  define SYS_PF_A97		(1 << 1)	/* AC97/SSL1 */
+#  define SYS_PF_S0		(1 << 0)	/* SSI_0/GPIO[16:18] */
 
-	/* check LSR TX_EMPTY bit */
-	timeout = 0xffffff;
-	do {
-		if (__raw_readl(base + 0x1c) & 0x20)
-			break;
-		/* slow down */
-		for (i = 10000; i; i--)
-			asm volatile ("nop");
-	} while (--timeout);
+/* Au1100 only */
+#  define SYS_PF_PC		(1 << 18)	/* PCMCIA/GPIO[207:204] */
+#  define SYS_PF_LCD		(1 << 17)	/* extern lcd/GPIO[203:200] */
+#  define SYS_PF_CS		(1 << 16)	/* EXTCLK0/32KHz to gpio2 */
+#  define SYS_PF_EX0		(1 << 9)	/* GPIO2/clock */
 
-	__raw_writel(c, base + 0x04);	/* tx */
-	wmb();
-}
+/* Au1550 only.	 Redefines lots of pins */
+#  define SYS_PF_PSC2_MASK	(7 << 17)
+#  define SYS_PF_PSC2_AC97	0
+#  define SYS_PF_PSC2_SPI	0
+#  define SYS_PF_PSC2_I2S	(1 << 17)
+#  define SYS_PF_PSC2_SMBUS	(3 << 17)
+#  define SYS_PF_PSC2_GPIO	(7 << 17)
+#  define SYS_PF_PSC3_MASK	(7 << 20)
+#  define SYS_PF_PSC3_AC97	0
+#  define SYS_PF_PSC3_SPI	0
+#  define SYS_PF_PSC3_I2S	(1 << 20)
+#  define SYS_PF_PSC3_SMBUS	(3 << 20)
+#  define SYS_PF_PSC3_GPIO	(7 << 20)
+#  define SYS_PF_PSC1_S1	(1 << 1)
+#  define SYS_PF_MUST_BE_SET	((1 << 5) | (1 << 2))
 
-/* return number of ethernet MACs on a given cputype */
-static inline int alchemy_get_macs(int type)
-{
-	switch (type) {
-	case ALCHEMY_CPU_AU1000:
-	case ALCHEMY_CPU_AU1500:
-	case ALCHEMY_CPU_AU1550:
-		return 2;
-	case ALCHEMY_CPU_AU1100:
-		return 1;
-	}
-	return 0;
-}
+/* Au1200 only */
+#define SYS_PINFUNC_DMA		(1 << 31)
+#define SYS_PINFUNC_S0A		(1 << 30)
+#define SYS_PINFUNC_S1A		(1 << 29)
+#define SYS_PINFUNC_LP0		(1 << 28)
+#define SYS_PINFUNC_LP1		(1 << 27)
+#define SYS_PINFUNC_LD16	(1 << 26)
+#define SYS_PINFUNC_LD8		(1 << 25)
+#define SYS_PINFUNC_LD1		(1 << 24)
+#define SYS_PINFUNC_LD0		(1 << 23)
+#define SYS_PINFUNC_P1A		(3 << 21)
+#define SYS_PINFUNC_P1B		(1 << 20)
+#define SYS_PINFUNC_FS3		(1 << 19)
+#define SYS_PINFUNC_P0A		(3 << 17)
+#define SYS_PINFUNC_CS		(1 << 16)
+#define SYS_PINFUNC_CIM		(1 << 15)
+#define SYS_PINFUNC_P1C		(1 << 14)
+#define SYS_PINFUNC_U1T		(1 << 12)
+#define SYS_PINFUNC_U1R		(1 << 11)
+#define SYS_PINFUNC_EX1		(1 << 10)
+#define SYS_PINFUNC_EX0		(1 << 9)
+#define SYS_PINFUNC_U0R		(1 << 8)
+#define SYS_PINFUNC_MC		(1 << 7)
+#define SYS_PINFUNC_S0B		(1 << 6)
+#define SYS_PINFUNC_S0C		(1 << 5)
+#define SYS_PINFUNC_P0B		(1 << 4)
+#define SYS_PINFUNC_U0T		(1 << 3)
+#define SYS_PINFUNC_S1B		(1 << 2)
 
-/* arch/mips/au1000/common/clocks.c */
-extern void set_au1x00_speed(unsigned int new_freq);
-extern unsigned int get_au1x00_speed(void);
-extern void set_au1x00_uart_baud_base(unsigned long new_baud_base);
-extern unsigned long get_au1x00_uart_baud_base(void);
-extern unsigned long au1xxx_calc_clock(void);
+/* Power Management */
+#define AU1000_SYS_SCRATCH0	0x0018
+#define AU1000_SYS_SCRATCH1	0x001C
+#define AU1000_SYS_WAKEMSK	0x0034
+#define AU1000_SYS_ENDIAN	0x0038
+#define AU1000_SYS_POWERCTRL	0x003C
+#define AU1000_SYS_WAKESRC	0x005C
+#define AU1000_SYS_SLPPWR	0x0078
+#define AU1000_SYS_SLEEP	0x007C
 
-/* PM: arch/mips/alchemy/common/sleeper.S, power.c, irq.c */
-void alchemy_sleep_au1000(void);
-void alchemy_sleep_au1550(void);
-void alchemy_sleep_au1300(void);
-void au_sleep(void);
+#define SYS_WAKEMSK_D2		(1 << 9)
+#define SYS_WAKEMSK_M2		(1 << 8)
+#define SYS_WAKEMSK_GPIO(x)	(1 << (x))
 
-/* USB: drivers/usb/host/alchemy-common.c */
-enum alchemy_usb_block {
-	ALCHEMY_USB_OHCI0,
-	ALCHEMY_USB_UDC0,
-	ALCHEMY_USB_EHCI0,
-	ALCHEMY_USB_OTG0,
-	ALCHEMY_USB_OHCI1,
-};
-int alchemy_usb_control(int block, int enable);
+/* Clock Controller/frequency dividers offsets */
+#define AU1000_SYS_FREQCTRL0	0x0020
+#define AU1000_SYS_FREQCTRL1	0x0024
+#define AU1000_SYS_CLKSRC	0x0028
+#define AU1000_SYS_CPUPLL	0x0060
+#define AU1000_SYS_AUXPLL	0x0064
 
-/* PCI controller platform data */
-struct alchemy_pci_platdata {
-	int (*board_map_irq)(const struct pci_dev *d, u8 slot, u8 pin);
-	int (*board_pci_idsel)(unsigned int devsel, int assert);
-	/* bits to set/clear in PCI_CONFIG register */
-	unsigned long pci_cfg_set;
-	unsigned long pci_cfg_clr;
-};
+/* SYS_FREQCTRLx bits */
+#  define SYS_FC_FRDIV2_BIT	22
+#  define SYS_FC_FRDIV2_MASK	(0xff << SYS_FC_FRDIV2_BIT)
+#  define SYS_FC_FE2		(1 << 21)
+#  define SYS_FC_FS2		(1 << 20)
+#  define SYS_FC_FRDIV1_BIT	12
+#  define SYS_FC_FRDIV1_MASK	(0xff << SYS_FC_FRDIV1_BIT)
+#  define SYS_FC_FE1		(1 << 11)
+#  define SYS_FC_FS1		(1 << 10)
+#  define SYS_FC_FRDIV0_BIT	2
+#  define SYS_FC_FRDIV0_MASK	(0xff << SYS_FC_FRDIV0_BIT)
+#  define SYS_FC_FE0		(1 << 1)
+#  define SYS_FC_FS0		(1 << 0)
+#  define SYS_FC_FRDIV5_BIT	22
+#  define SYS_FC_FRDIV5_MASK	(0xff << SYS_FC_FRDIV5_BIT)
+#  define SYS_FC_FE5		(1 << 21)
+#  define SYS_FC_FS5		(1 << 20)
+#  define SYS_FC_FRDIV4_BIT	12
+#  define SYS_FC_FRDIV4_MASK	(0xff << SYS_FC_FRDIV4_BIT)
+#  define SYS_FC_FE4		(1 << 11)
+#  define SYS_FC_FS4		(1 << 10)
+#  define SYS_FC_FRDIV3_BIT	2
+#  define SYS_FC_FRDIV3_MASK	(0xff << SYS_FC_FRDIV3_BIT)
+#  define SYS_FC_FE3		(1 << 1)
+#  define SYS_FC_FS3		(1 << 0)
 
-/* Multifunction pins: Each of these pins can either be assigned to the
- * GPIO controller or a on-chip peripheral.
- * Call "au1300_pinfunc_to_dev()" or "au1300_pinfunc_to_gpio()" to
- * assign one of these to either the GPIO controller or the device.
- */
-enum au1300_multifunc_pins {
-	/* wake-from-str pins 0-3 */
-	AU1300_PIN_WAKE0 = 0, AU1300_PIN_WAKE1, AU1300_PIN_WAKE2,
-	AU1300_PIN_WAKE3,
-	/* external clock sources for PSCs: 4-5 */
-	AU1300_PIN_EXTCLK0, AU1300_PIN_EXTCLK1,
-	/* 8bit MMC interface on SD0: 6-9 */
-	AU1300_PIN_SD0DAT4, AU1300_PIN_SD0DAT5, AU1300_PIN_SD0DAT6,
-	AU1300_PIN_SD0DAT7,
-	/* aux clk input for freqgen 3: 10 */
-	AU1300_PIN_FG3AUX,
-	/* UART1 pins: 11-18 */
-	AU1300_PIN_U1RI, AU1300_PIN_U1DCD, AU1300_PIN_U1DSR,
-	AU1300_PIN_U1CTS, AU1300_PIN_U1RTS, AU1300_PIN_U1DTR,
-	AU1300_PIN_U1RX, AU1300_PIN_U1TX,
-	/* UART0 pins: 19-24 */
-	AU1300_PIN_U0RI, AU1300_PIN_U0DCD, AU1300_PIN_U0DSR,
-	AU1300_PIN_U0CTS, AU1300_PIN_U0RTS, AU1300_PIN_U0DTR,
-	/* UART2: 25-26 */
-	AU1300_PIN_U2RX, AU1300_PIN_U2TX,
-	/* UART3: 27-28 */
-	AU1300_PIN_U3RX, AU1300_PIN_U3TX,
-	/* LCD controller PWMs, ext pixclock: 29-31 */
-	AU1300_PIN_LCDPWM0, AU1300_PIN_LCDPWM1, AU1300_PIN_LCDCLKIN,
-	/* SD1 interface: 32-37 */
-	AU1300_PIN_SD1DAT0, AU1300_PIN_SD1DAT1, AU1300_PIN_SD1DAT2,
-	AU1300_PIN_SD1DAT3, AU1300_PIN_SD1CMD, AU1300_PIN_SD1CLK,
-	/* SD2 interface: 38-43 */
-	AU1300_PIN_SD2DAT0, AU1300_PIN_SD2DAT1, AU1300_PIN_SD2DAT2,
-	AU1300_PIN_SD2DAT3, AU1300_PIN_SD2CMD, AU1300_PIN_SD2CLK,
-	/* PSC0/1 clocks: 44-45 */
-	AU1300_PIN_PSC0CLK, AU1300_PIN_PSC1CLK,
-	/* PSCs: 46-49/50-53/54-57/58-61 */
-	AU1300_PIN_PSC0SYNC0, AU1300_PIN_PSC0SYNC1, AU1300_PIN_PSC0D0,
-	AU1300_PIN_PSC0D1,
-	AU1300_PIN_PSC1SYNC0, AU1300_PIN_PSC1SYNC1, AU1300_PIN_PSC1D0,
-	AU1300_PIN_PSC1D1,
-	AU1300_PIN_PSC2SYNC0, AU1300_PIN_PSC2SYNC1, AU1300_PIN_PSC2D0,
-	AU1300_PIN_PSC2D1,
-	AU1300_PIN_PSC3SYNC0, AU1300_PIN_PSC3SYNC1, AU1300_PIN_PSC3D0,
-	AU1300_PIN_PSC3D1,
-	/* PCMCIA interface: 62-70 */
-	AU1300_PIN_PCE2, AU1300_PIN_PCE1, AU1300_PIN_PIOS16,
-	AU1300_PIN_PIOR, AU1300_PIN_PWE, AU1300_PIN_PWAIT,
-	AU1300_PIN_PREG, AU1300_PIN_POE, AU1300_PIN_PIOW,
-	/* camera interface H/V sync inputs: 71-72 */
-	AU1300_PIN_CIMLS, AU1300_PIN_CIMFS,
-	/* PSC2/3 clocks: 73-74 */
-	AU1300_PIN_PSC2CLK, AU1300_PIN_PSC3CLK,
-};
+/* SYS_CLKSRC bits */
+#  define SYS_CS_ME1_BIT	27
+#  define SYS_CS_ME1_MASK	(0x7 << SYS_CS_ME1_BIT)
+#  define SYS_CS_DE1		(1 << 26)
+#  define SYS_CS_CE1		(1 << 25)
+#  define SYS_CS_ME0_BIT	22
+#  define SYS_CS_ME0_MASK	(0x7 << SYS_CS_ME0_BIT)
+#  define SYS_CS_DE0		(1 << 21)
+#  define SYS_CS_CE0		(1 << 20)
+#  define SYS_CS_MI2_BIT	17
+#  define SYS_CS_MI2_MASK	(0x7 << SYS_CS_MI2_BIT)
+#  define SYS_CS_DI2		(1 << 16)
+#  define SYS_CS_CI2		(1 << 15)
+#  define SYS_CS_ML_BIT		7
+#  define SYS_CS_ML_MASK	(0x7 << SYS_CS_ML_BIT)
+#  define SYS_CS_DL		(1 << 6)
+#  define SYS_CS_CL		(1 << 5)
+#  define SYS_CS_MUH_BIT	12
+#  define SYS_CS_MUH_MASK	(0x7 << SYS_CS_MUH_BIT)
+#  define SYS_CS_DUH		(1 << 11)
+#  define SYS_CS_CUH		(1 << 10)
+#  define SYS_CS_MUD_BIT	7
+#  define SYS_CS_MUD_MASK	(0x7 << SYS_CS_MUD_BIT)
+#  define SYS_CS_DUD		(1 << 6)
+#  define SYS_CS_CUD		(1 << 5)
+#  define SYS_CS_MIR_BIT	2
+#  define SYS_CS_MIR_MASK	(0x7 << SYS_CS_MIR_BIT)
+#  define SYS_CS_DIR		(1 << 1)
+#  define SYS_CS_CIR		(1 << 0)
+#  define SYS_CS_MUX_AUX	0x1
+#  define SYS_CS_MUX_FQ0	0x2
+#  define SYS_CS_MUX_FQ1	0x3
+#  define SYS_CS_MUX_FQ2	0x4
+#  define SYS_CS_MUX_FQ3	0x5
+#  define SYS_CS_MUX_FQ4	0x6
+#  define SYS_CS_MUX_FQ5	0x7
 
-/* GPIC (Au1300) pin management: arch/mips/alchemy/common/gpioint.c */
-extern void au1300_pinfunc_to_gpio(enum au1300_multifunc_pins gpio);
-extern void au1300_pinfunc_to_dev(enum au1300_multifunc_pins gpio);
-extern void au1300_set_irq_priority(unsigned int irq, int p);
-extern void au1300_set_dbdma_gpio(int dchan, unsigned int gpio);
 
-/* Au1300 allows to disconnect certain blocks from internal power supply */
-enum au1300_vss_block {
-	AU1300_VSS_MPE = 0,
-	AU1300_VSS_BSA,
-	AU1300_VSS_GPE,
-	AU1300_VSS_MGP,
-};
+/* Au15x0 PCI *********************************************************/
 
-extern void au1300_vss_block_control(int block, int enable);
 
+/* The PCI chip selects are outside the 32bit space, and since we can't
+ * just program the 36bit addresses into BARs, we have to take a chunk
+ * out of the 32bit space and reserve it for PCI.  When these addresses
+ * are ioremap()ed, they'll be fixed up to the real 36bit address before
+ * being passed to the real ioremap function.
+ */
+#define ALCHEMY_PCI_MEMWIN_START	(AU1500_PCI_MEM_PHYS_ADDR >> 4)
+#define ALCHEMY_PCI_MEMWIN_END		(ALCHEMY_PCI_MEMWIN_START + 0x0FFFFFFF)
 
-/* SOC Interrupt numbers */
-/* Au1000-style (IC0/1): 2 controllers with 32 sources each */
-#define AU1000_INTC0_INT_BASE	(MIPS_CPU_IRQ_BASE + 8)
-#define AU1000_INTC0_INT_LAST	(AU1000_INTC0_INT_BASE + 31)
-#define AU1000_INTC1_INT_BASE	(AU1000_INTC0_INT_LAST + 1)
-#define AU1000_INTC1_INT_LAST	(AU1000_INTC1_INT_BASE + 31)
-#define AU1000_MAX_INTR		AU1000_INTC1_INT_LAST
+/* for PCI IO it's simpler because we get to do the ioremap ourselves and then
+ * adjust the device's resources.
+ */
+#define ALCHEMY_PCI_IOWIN_START		0x00001000
+#define ALCHEMY_PCI_IOWIN_END		0x0000FFFF
 
-/* Au1300-style (GPIC): 1 controller with up to 128 sources */
-#define ALCHEMY_GPIC_INT_BASE	(MIPS_CPU_IRQ_BASE + 8)
-#define ALCHEMY_GPIC_INT_NUM	128
-#define ALCHEMY_GPIC_INT_LAST	(ALCHEMY_GPIC_INT_BASE + ALCHEMY_GPIC_INT_NUM - 1)
+#ifdef CONFIG_PCI
 
-enum soc_au1000_ints {
-	AU1000_FIRST_INT	= AU1000_INTC0_INT_BASE,
-	AU1000_UART0_INT	= AU1000_FIRST_INT,
-	AU1000_UART1_INT,
-	AU1000_UART2_INT,
-	AU1000_UART3_INT,
-	AU1000_SSI0_INT,
-	AU1000_SSI1_INT,
-	AU1000_DMA_INT_BASE,
+#define IOPORT_RESOURCE_START	0x00001000	/* skip legacy probing */
+#define IOPORT_RESOURCE_END	0xffffffff
+#define IOMEM_RESOURCE_START	0x10000000
+#define IOMEM_RESOURCE_END	0xfffffffffULL
 
-	AU1000_TOY_INT		= AU1000_FIRST_INT + 14,
-	AU1000_TOY_MATCH0_INT,
-	AU1000_TOY_MATCH1_INT,
-	AU1000_TOY_MATCH2_INT,
-	AU1000_RTC_INT,
-	AU1000_RTC_MATCH0_INT,
-	AU1000_RTC_MATCH1_INT,
-	AU1000_RTC_MATCH2_INT,
-	AU1000_IRDA_TX_INT,
-	AU1000_IRDA_RX_INT,
-	AU1000_USB_DEV_REQ_INT,
-	AU1000_USB_DEV_SUS_INT,
-	AU1000_USB_HOST_INT,
-	AU1000_ACSYNC_INT,
-	AU1000_MAC0_DMA_INT,
-	AU1000_MAC1_DMA_INT,
-	AU1000_I2S_UO_INT,
-	AU1000_AC97C_INT,
-	AU1000_GPIO0_INT,
-	AU1000_GPIO1_INT,
-	AU1000_GPIO2_INT,
-	AU1000_GPIO3_INT,
-	AU1000_GPIO4_INT,
-	AU1000_GPIO5_INT,
-	AU1000_GPIO6_INT,
-	AU1000_GPIO7_INT,
-	AU1000_GPIO8_INT,
-	AU1000_GPIO9_INT,
-	AU1000_GPIO10_INT,
-	AU1000_GPIO11_INT,
-	AU1000_GPIO12_INT,
-	AU1000_GPIO13_INT,
-	AU1000_GPIO14_INT,
-	AU1000_GPIO15_INT,
-	AU1000_GPIO16_INT,
-	AU1000_GPIO17_INT,
-	AU1000_GPIO18_INT,
-	AU1000_GPIO19_INT,
-	AU1000_GPIO20_INT,
-	AU1000_GPIO21_INT,
-	AU1000_GPIO22_INT,
-	AU1000_GPIO23_INT,
-	AU1000_GPIO24_INT,
-	AU1000_GPIO25_INT,
-	AU1000_GPIO26_INT,
-	AU1000_GPIO27_INT,
-	AU1000_GPIO28_INT,
-	AU1000_GPIO29_INT,
-	AU1000_GPIO30_INT,
-	AU1000_GPIO31_INT,
-};
+#else
 
-enum soc_au1100_ints {
-	AU1100_FIRST_INT	= AU1000_INTC0_INT_BASE,
-	AU1100_UART0_INT	= AU1100_FIRST_INT,
-	AU1100_UART1_INT,
-	AU1100_SD_INT,
-	AU1100_UART3_INT,
-	AU1100_SSI0_INT,
-	AU1100_SSI1_INT,
-	AU1100_DMA_INT_BASE,
+/* Don't allow any legacy ports probing */
+#define IOPORT_RESOURCE_START	0x10000000
+#define IOPORT_RESOURCE_END	0xffffffff
+#define IOMEM_RESOURCE_START	0x10000000
+#define IOMEM_RESOURCE_END	0xfffffffffULL
 
-	AU1100_TOY_INT		= AU1100_FIRST_INT + 14,
-	AU1100_TOY_MATCH0_INT,
-	AU1100_TOY_MATCH1_INT,
-	AU1100_TOY_MATCH2_INT,
-	AU1100_RTC_INT,
-	AU1100_RTC_MATCH0_INT,
-	AU1100_RTC_MATCH1_INT,
-	AU1100_RTC_MATCH2_INT,
-	AU1100_IRDA_TX_INT,
-	AU1100_IRDA_RX_INT,
-	AU1100_USB_DEV_REQ_INT,
-	AU1100_USB_DEV_SUS_INT,
-	AU1100_USB_HOST_INT,
-	AU1100_ACSYNC_INT,
-	AU1100_MAC0_DMA_INT,
-	AU1100_GPIO208_215_INT,
-	AU1100_LCD_INT,
-	AU1100_AC97C_INT,
-	AU1100_GPIO0_INT,
-	AU1100_GPIO1_INT,
-	AU1100_GPIO2_INT,
-	AU1100_GPIO3_INT,
-	AU1100_GPIO4_INT,
-	AU1100_GPIO5_INT,
-	AU1100_GPIO6_INT,
-	AU1100_GPIO7_INT,
-	AU1100_GPIO8_INT,
-	AU1100_GPIO9_INT,
-	AU1100_GPIO10_INT,
-	AU1100_GPIO11_INT,
-	AU1100_GPIO12_INT,
-	AU1100_GPIO13_INT,
-	AU1100_GPIO14_INT,
-	AU1100_GPIO15_INT,
-	AU1100_GPIO16_INT,
-	AU1100_GPIO17_INT,
-	AU1100_GPIO18_INT,
-	AU1100_GPIO19_INT,
-	AU1100_GPIO20_INT,
-	AU1100_GPIO21_INT,
-	AU1100_GPIO22_INT,
-	AU1100_GPIO23_INT,
-	AU1100_GPIO24_INT,
-	AU1100_GPIO25_INT,
-	AU1100_GPIO26_INT,
-	AU1100_GPIO27_INT,
-	AU1100_GPIO28_INT,
-	AU1100_GPIO29_INT,
-	AU1100_GPIO30_INT,
-	AU1100_GPIO31_INT,
-};
+#endif
 
-enum soc_au1500_ints {
-	AU1500_FIRST_INT	= AU1000_INTC0_INT_BASE,
-	AU1500_UART0_INT	= AU1500_FIRST_INT,
-	AU1500_PCI_INTA,
-	AU1500_PCI_INTB,
-	AU1500_UART3_INT,
-	AU1500_PCI_INTC,
-	AU1500_PCI_INTD,
-	AU1500_DMA_INT_BASE,
+/* PCI controller block register offsets */
+#define AU1500_PCI_CMEM			0x0000
+#define AU1500_PCI_CONFIG		0x0004
+#define AU1500_PCI_B2BMASK_CCH		0x0008
+#define AU1500_PCI_B2BBASE0_VID		0x000C
+#define AU1500_PCI_B2BBASE1_SID		0x0010
+#define AU1500_PCI_MWMASK_DEV		0x0014
+#define AU1500_PCI_MWBASE_REV_CCL	0x0018
+#define AU1500_PCI_ERR_ADDR		0x001C
+#define AU1500_PCI_SPEC_INTACK		0x0020
+#define AU1500_PCI_ID			0x0100
+#define AU1500_PCI_STATCMD		0x0104
+#define AU1500_PCI_CLASSREV		0x0108
+#define AU1500_PCI_PARAM		0x010C
+#define AU1500_PCI_MBAR			0x0110
+#define AU1500_PCI_TIMEOUT		0x0140
 
-	AU1500_TOY_INT		= AU1500_FIRST_INT + 14,
-	AU1500_TOY_MATCH0_INT,
-	AU1500_TOY_MATCH1_INT,
-	AU1500_TOY_MATCH2_INT,
-	AU1500_RTC_INT,
-	AU1500_RTC_MATCH0_INT,
-	AU1500_RTC_MATCH1_INT,
-	AU1500_RTC_MATCH2_INT,
-	AU1500_PCI_ERR_INT,
-	AU1500_RESERVED_INT,
-	AU1500_USB_DEV_REQ_INT,
-	AU1500_USB_DEV_SUS_INT,
-	AU1500_USB_HOST_INT,
-	AU1500_ACSYNC_INT,
-	AU1500_MAC0_DMA_INT,
-	AU1500_MAC1_DMA_INT,
-	AU1500_AC97C_INT	= AU1500_FIRST_INT + 31,
-	AU1500_GPIO0_INT,
-	AU1500_GPIO1_INT,
-	AU1500_GPIO2_INT,
-	AU1500_GPIO3_INT,
-	AU1500_GPIO4_INT,
-	AU1500_GPIO5_INT,
-	AU1500_GPIO6_INT,
-	AU1500_GPIO7_INT,
-	AU1500_GPIO8_INT,
-	AU1500_GPIO9_INT,
-	AU1500_GPIO10_INT,
-	AU1500_GPIO11_INT,
-	AU1500_GPIO12_INT,
-	AU1500_GPIO13_INT,
-	AU1500_GPIO14_INT,
-	AU1500_GPIO15_INT,
-	AU1500_GPIO200_INT,
-	AU1500_GPIO201_INT,
-	AU1500_GPIO202_INT,
-	AU1500_GPIO203_INT,
-	AU1500_GPIO20_INT,
-	AU1500_GPIO204_INT,
-	AU1500_GPIO205_INT,
-	AU1500_GPIO23_INT,
-	AU1500_GPIO24_INT,
-	AU1500_GPIO25_INT,
-	AU1500_GPIO26_INT,
-	AU1500_GPIO27_INT,
-	AU1500_GPIO28_INT,
-	AU1500_GPIO206_INT,
-	AU1500_GPIO207_INT,
-	AU1500_GPIO208_215_INT,
-};
-
-enum soc_au1550_ints {
-	AU1550_FIRST_INT	= AU1000_INTC0_INT_BASE,
-	AU1550_UART0_INT	= AU1550_FIRST_INT,
-	AU1550_PCI_INTA,
-	AU1550_PCI_INTB,
-	AU1550_DDMA_INT,
-	AU1550_CRYPTO_INT,
-	AU1550_PCI_INTC,
-	AU1550_PCI_INTD,
-	AU1550_PCI_RST_INT,
-	AU1550_UART1_INT,
-	AU1550_UART3_INT,
-	AU1550_PSC0_INT,
-	AU1550_PSC1_INT,
-	AU1550_PSC2_INT,
-	AU1550_PSC3_INT,
-	AU1550_TOY_INT,
-	AU1550_TOY_MATCH0_INT,
-	AU1550_TOY_MATCH1_INT,
-	AU1550_TOY_MATCH2_INT,
-	AU1550_RTC_INT,
-	AU1550_RTC_MATCH0_INT,
-	AU1550_RTC_MATCH1_INT,
-	AU1550_RTC_MATCH2_INT,
-
-	AU1550_NAND_INT		= AU1550_FIRST_INT + 23,
-	AU1550_USB_DEV_REQ_INT,
-	AU1550_USB_DEV_SUS_INT,
-	AU1550_USB_HOST_INT,
-	AU1550_MAC0_DMA_INT,
-	AU1550_MAC1_DMA_INT,
-	AU1550_GPIO0_INT	= AU1550_FIRST_INT + 32,
-	AU1550_GPIO1_INT,
-	AU1550_GPIO2_INT,
-	AU1550_GPIO3_INT,
-	AU1550_GPIO4_INT,
-	AU1550_GPIO5_INT,
-	AU1550_GPIO6_INT,
-	AU1550_GPIO7_INT,
-	AU1550_GPIO8_INT,
-	AU1550_GPIO9_INT,
-	AU1550_GPIO10_INT,
-	AU1550_GPIO11_INT,
-	AU1550_GPIO12_INT,
-	AU1550_GPIO13_INT,
-	AU1550_GPIO14_INT,
-	AU1550_GPIO15_INT,
-	AU1550_GPIO200_INT,
-	AU1550_GPIO201_205_INT, /* Logical or of GPIO201:205 */
-	AU1550_GPIO16_INT,
-	AU1550_GPIO17_INT,
-	AU1550_GPIO20_INT,
-	AU1550_GPIO21_INT,
-	AU1550_GPIO22_INT,
-	AU1550_GPIO23_INT,
-	AU1550_GPIO24_INT,
-	AU1550_GPIO25_INT,
-	AU1550_GPIO26_INT,
-	AU1550_GPIO27_INT,
-	AU1550_GPIO28_INT,
-	AU1550_GPIO206_INT,
-	AU1550_GPIO207_INT,
-	AU1550_GPIO208_215_INT, /* Logical or of GPIO208:215 */
-};
-
-enum soc_au1200_ints {
-	AU1200_FIRST_INT	= AU1000_INTC0_INT_BASE,
-	AU1200_UART0_INT	= AU1200_FIRST_INT,
-	AU1200_SWT_INT,
-	AU1200_SD_INT,
-	AU1200_DDMA_INT,
-	AU1200_MAE_BE_INT,
-	AU1200_GPIO200_INT,
-	AU1200_GPIO201_INT,
-	AU1200_GPIO202_INT,
-	AU1200_UART1_INT,
-	AU1200_MAE_FE_INT,
-	AU1200_PSC0_INT,
-	AU1200_PSC1_INT,
-	AU1200_AES_INT,
-	AU1200_CAMERA_INT,
-	AU1200_TOY_INT,
-	AU1200_TOY_MATCH0_INT,
-	AU1200_TOY_MATCH1_INT,
-	AU1200_TOY_MATCH2_INT,
-	AU1200_RTC_INT,
-	AU1200_RTC_MATCH0_INT,
-	AU1200_RTC_MATCH1_INT,
-	AU1200_RTC_MATCH2_INT,
-	AU1200_GPIO203_INT,
-	AU1200_NAND_INT,
-	AU1200_GPIO204_INT,
-	AU1200_GPIO205_INT,
-	AU1200_GPIO206_INT,
-	AU1200_GPIO207_INT,
-	AU1200_GPIO208_215_INT, /* Logical OR of 208:215 */
-	AU1200_USB_INT,
-	AU1200_LCD_INT,
-	AU1200_MAE_BOTH_INT,
-	AU1200_GPIO0_INT,
-	AU1200_GPIO1_INT,
-	AU1200_GPIO2_INT,
-	AU1200_GPIO3_INT,
-	AU1200_GPIO4_INT,
-	AU1200_GPIO5_INT,
-	AU1200_GPIO6_INT,
-	AU1200_GPIO7_INT,
-	AU1200_GPIO8_INT,
-	AU1200_GPIO9_INT,
-	AU1200_GPIO10_INT,
-	AU1200_GPIO11_INT,
-	AU1200_GPIO12_INT,
-	AU1200_GPIO13_INT,
-	AU1200_GPIO14_INT,
-	AU1200_GPIO15_INT,
-	AU1200_GPIO16_INT,
-	AU1200_GPIO17_INT,
-	AU1200_GPIO18_INT,
-	AU1200_GPIO19_INT,
-	AU1200_GPIO20_INT,
-	AU1200_GPIO21_INT,
-	AU1200_GPIO22_INT,
-	AU1200_GPIO23_INT,
-	AU1200_GPIO24_INT,
-	AU1200_GPIO25_INT,
-	AU1200_GPIO26_INT,
-	AU1200_GPIO27_INT,
-	AU1200_GPIO28_INT,
-	AU1200_GPIO29_INT,
-	AU1200_GPIO30_INT,
-	AU1200_GPIO31_INT,
-};
-
-#endif /* !defined (_LANGUAGE_ASSEMBLY) */
-
-/* Au1300 peripheral interrupt numbers */
-#define AU1300_FIRST_INT	(ALCHEMY_GPIC_INT_BASE)
-#define AU1300_UART1_INT	(AU1300_FIRST_INT + 17)
-#define AU1300_UART2_INT	(AU1300_FIRST_INT + 25)
-#define AU1300_UART3_INT	(AU1300_FIRST_INT + 27)
-#define AU1300_SD1_INT		(AU1300_FIRST_INT + 32)
-#define AU1300_SD2_INT		(AU1300_FIRST_INT + 38)
-#define AU1300_PSC0_INT		(AU1300_FIRST_INT + 48)
-#define AU1300_PSC1_INT		(AU1300_FIRST_INT + 52)
-#define AU1300_PSC2_INT		(AU1300_FIRST_INT + 56)
-#define AU1300_PSC3_INT		(AU1300_FIRST_INT + 60)
-#define AU1300_NAND_INT		(AU1300_FIRST_INT + 62)
-#define AU1300_DDMA_INT		(AU1300_FIRST_INT + 75)
-#define AU1300_MMU_INT		(AU1300_FIRST_INT + 76)
-#define AU1300_MPU_INT		(AU1300_FIRST_INT + 77)
-#define AU1300_GPU_INT		(AU1300_FIRST_INT + 78)
-#define AU1300_UDMA_INT		(AU1300_FIRST_INT + 79)
-#define AU1300_TOY_INT		(AU1300_FIRST_INT + 80)
-#define AU1300_TOY_MATCH0_INT	(AU1300_FIRST_INT + 81)
-#define AU1300_TOY_MATCH1_INT	(AU1300_FIRST_INT + 82)
-#define AU1300_TOY_MATCH2_INT	(AU1300_FIRST_INT + 83)
-#define AU1300_RTC_INT		(AU1300_FIRST_INT + 84)
-#define AU1300_RTC_MATCH0_INT	(AU1300_FIRST_INT + 85)
-#define AU1300_RTC_MATCH1_INT	(AU1300_FIRST_INT + 86)
-#define AU1300_RTC_MATCH2_INT	(AU1300_FIRST_INT + 87)
-#define AU1300_UART0_INT	(AU1300_FIRST_INT + 88)
-#define AU1300_SD0_INT		(AU1300_FIRST_INT + 89)
-#define AU1300_USB_INT		(AU1300_FIRST_INT + 90)
-#define AU1300_LCD_INT		(AU1300_FIRST_INT + 91)
-#define AU1300_BSA_INT		(AU1300_FIRST_INT + 92)
-#define AU1300_MPE_INT		(AU1300_FIRST_INT + 93)
-#define AU1300_ITE_INT		(AU1300_FIRST_INT + 94)
-#define AU1300_AES_INT		(AU1300_FIRST_INT + 95)
-#define AU1300_CIM_INT		(AU1300_FIRST_INT + 96)
-
-/**********************************************************************/
-
-/*
- * Physical base addresses for integrated peripherals
- * 0..au1000 1..au1500 2..au1100 3..au1550 4..au1200 5..au1300
- */
-
-#define AU1000_AC97_PHYS_ADDR		0x10000000 /* 012 */
-#define AU1300_ROM_PHYS_ADDR		0x10000000 /* 5 */
-#define AU1300_OTP_PHYS_ADDR		0x10002000 /* 5 */
-#define AU1300_VSS_PHYS_ADDR		0x10003000 /* 5 */
-#define AU1300_UART0_PHYS_ADDR		0x10100000 /* 5 */
-#define AU1300_UART1_PHYS_ADDR		0x10101000 /* 5 */
-#define AU1300_UART2_PHYS_ADDR		0x10102000 /* 5 */
-#define AU1300_UART3_PHYS_ADDR		0x10103000 /* 5 */
-#define AU1000_USB_OHCI_PHYS_ADDR	0x10100000 /* 012 */
-#define AU1000_USB_UDC_PHYS_ADDR	0x10200000 /* 0123 */
-#define AU1300_GPIC_PHYS_ADDR		0x10200000 /* 5 */
-#define AU1000_IRDA_PHYS_ADDR		0x10300000 /* 02 */
-#define AU1200_AES_PHYS_ADDR		0x10300000 /* 45 */
-#define AU1000_IC0_PHYS_ADDR		0x10400000 /* 01234 */
-#define AU1300_GPU_PHYS_ADDR		0x10500000 /* 5 */
-#define AU1000_MAC0_PHYS_ADDR		0x10500000 /* 023 */
-#define AU1000_MAC1_PHYS_ADDR		0x10510000 /* 023 */
-#define AU1000_MACEN_PHYS_ADDR		0x10520000 /* 023 */
-#define AU1100_SD0_PHYS_ADDR		0x10600000 /* 245 */
-#define AU1300_SD1_PHYS_ADDR		0x10601000 /* 5 */
-#define AU1300_SD2_PHYS_ADDR		0x10602000 /* 5 */
-#define AU1100_SD1_PHYS_ADDR		0x10680000 /* 24 */
-#define AU1300_SYS_PHYS_ADDR		0x10900000 /* 5 */
-#define AU1550_PSC2_PHYS_ADDR		0x10A00000 /* 3 */
-#define AU1550_PSC3_PHYS_ADDR		0x10B00000 /* 3 */
-#define AU1300_PSC0_PHYS_ADDR		0x10A00000 /* 5 */
-#define AU1300_PSC1_PHYS_ADDR		0x10A01000 /* 5 */
-#define AU1300_PSC2_PHYS_ADDR		0x10A02000 /* 5 */
-#define AU1300_PSC3_PHYS_ADDR		0x10A03000 /* 5 */
-#define AU1000_I2S_PHYS_ADDR		0x11000000 /* 02 */
-#define AU1500_MAC0_PHYS_ADDR		0x11500000 /* 1 */
-#define AU1500_MAC1_PHYS_ADDR		0x11510000 /* 1 */
-#define AU1500_MACEN_PHYS_ADDR		0x11520000 /* 1 */
-#define AU1000_UART0_PHYS_ADDR		0x11100000 /* 01234 */
-#define AU1200_SWCNT_PHYS_ADDR		0x1110010C /* 4 */
-#define AU1000_UART1_PHYS_ADDR		0x11200000 /* 0234 */
-#define AU1000_UART2_PHYS_ADDR		0x11300000 /* 0 */
-#define AU1000_UART3_PHYS_ADDR		0x11400000 /* 0123 */
-#define AU1000_SSI0_PHYS_ADDR		0x11600000 /* 02 */
-#define AU1000_SSI1_PHYS_ADDR		0x11680000 /* 02 */
-#define AU1500_GPIO2_PHYS_ADDR		0x11700000 /* 1234 */
-#define AU1000_IC1_PHYS_ADDR		0x11800000 /* 01234 */
-#define AU1000_SYS_PHYS_ADDR		0x11900000 /* 012345 */
-#define AU1550_PSC0_PHYS_ADDR		0x11A00000 /* 34 */
-#define AU1550_PSC1_PHYS_ADDR		0x11B00000 /* 34 */
-#define AU1000_MEM_PHYS_ADDR		0x14000000 /* 01234 */
-#define AU1000_STATIC_MEM_PHYS_ADDR	0x14001000 /* 01234 */
-#define AU1300_UDMA_PHYS_ADDR		0x14001800 /* 5 */
-#define AU1000_DMA_PHYS_ADDR		0x14002000 /* 012 */
-#define AU1550_DBDMA_PHYS_ADDR		0x14002000 /* 345 */
-#define AU1550_DBDMA_CONF_PHYS_ADDR	0x14003000 /* 345 */
-#define AU1000_MACDMA0_PHYS_ADDR	0x14004000 /* 0123 */
-#define AU1000_MACDMA1_PHYS_ADDR	0x14004200 /* 0123 */
-#define AU1200_CIM_PHYS_ADDR		0x14004000 /* 45 */
-#define AU1500_PCI_PHYS_ADDR		0x14005000 /* 13 */
-#define AU1550_PE_PHYS_ADDR		0x14008000 /* 3 */
-#define AU1200_MAEBE_PHYS_ADDR		0x14010000 /* 4 */
-#define AU1200_MAEFE_PHYS_ADDR		0x14012000 /* 4 */
-#define AU1300_MAEITE_PHYS_ADDR		0x14010000 /* 5 */
-#define AU1300_MAEMPE_PHYS_ADDR		0x14014000 /* 5 */
-#define AU1550_USB_OHCI_PHYS_ADDR	0x14020000 /* 3 */
-#define AU1200_USB_CTL_PHYS_ADDR	0x14020000 /* 4 */
-#define AU1200_USB_OTG_PHYS_ADDR	0x14020020 /* 4 */
-#define AU1200_USB_OHCI_PHYS_ADDR	0x14020100 /* 4 */
-#define AU1200_USB_EHCI_PHYS_ADDR	0x14020200 /* 4 */
-#define AU1200_USB_UDC_PHYS_ADDR	0x14022000 /* 4 */
-#define AU1300_USB_EHCI_PHYS_ADDR	0x14020000 /* 5 */
-#define AU1300_USB_OHCI0_PHYS_ADDR	0x14020400 /* 5 */
-#define AU1300_USB_OHCI1_PHYS_ADDR	0x14020800 /* 5 */
-#define AU1300_USB_CTL_PHYS_ADDR	0x14021000 /* 5 */
-#define AU1300_USB_OTG_PHYS_ADDR	0x14022000 /* 5 */
-#define AU1300_MAEBSA_PHYS_ADDR		0x14030000 /* 5 */
-#define AU1100_LCD_PHYS_ADDR		0x15000000 /* 2 */
-#define AU1200_LCD_PHYS_ADDR		0x15000000 /* 45 */
-#define AU1500_PCI_MEM_PHYS_ADDR	0x400000000ULL /* 13 */
-#define AU1500_PCI_IO_PHYS_ADDR		0x500000000ULL /* 13 */
-#define AU1500_PCI_CONFIG0_PHYS_ADDR	0x600000000ULL /* 13 */
-#define AU1500_PCI_CONFIG1_PHYS_ADDR	0x680000000ULL /* 13 */
-#define AU1000_PCMCIA_IO_PHYS_ADDR	0xF00000000ULL /* 012345 */
-#define AU1000_PCMCIA_ATTR_PHYS_ADDR	0xF40000000ULL /* 012345 */
-#define AU1000_PCMCIA_MEM_PHYS_ADDR	0xF80000000ULL /* 012345 */
+/* PCI controller block register bits */
+#define PCI_CMEM_E		(1 << 28)	/* enable cacheable memory */
+#define PCI_CMEM_CMBASE(x)	(((x) & 0x3fff) << 14)
+#define PCI_CMEM_CMMASK(x)	((x) & 0x3fff)
+#define PCI_CONFIG_ERD		(1 << 27) /* pci error during R/W */
+#define PCI_CONFIG_ET		(1 << 26) /* error in target mode */
+#define PCI_CONFIG_EF		(1 << 25) /* fatal error */
+#define PCI_CONFIG_EP		(1 << 24) /* parity error */
+#define PCI_CONFIG_EM		(1 << 23) /* multiple errors */
+#define PCI_CONFIG_BM		(1 << 22) /* bad master error */
+#define PCI_CONFIG_PD		(1 << 20) /* PCI Disable */
+#define PCI_CONFIG_BME		(1 << 19) /* Byte Mask Enable for reads */
+#define PCI_CONFIG_NC		(1 << 16) /* mark mem access non-coherent */
+#define PCI_CONFIG_IA		(1 << 15) /* INTA# enabled (target mode) */
+#define PCI_CONFIG_IP		(1 << 13) /* int on PCI_PERR# */
+#define PCI_CONFIG_IS		(1 << 12) /* int on PCI_SERR# */
+#define PCI_CONFIG_IMM		(1 << 11) /* int on master abort */
+#define PCI_CONFIG_ITM		(1 << 10) /* int on target abort (as master) */
+#define PCI_CONFIG_ITT		(1 << 9)  /* int on target abort (as target) */
+#define PCI_CONFIG_IPB		(1 << 8)  /* int on PERR# in bus master acc */
+#define PCI_CONFIG_SIC_NO	(0 << 6)  /* no byte mask changes */
+#define PCI_CONFIG_SIC_BA_ADR	(1 << 6)  /* on byte/hw acc, invert adr bits */
+#define PCI_CONFIG_SIC_HWA_DAT	(2 << 6)  /* on halfword acc, swap data */
+#define PCI_CONFIG_SIC_ALL	(3 << 6)  /* swap data bytes on all accesses */
+#define PCI_CONFIG_ST		(1 << 5)  /* swap data by target transactions */
+#define PCI_CONFIG_SM		(1 << 4)  /* swap data from PCI ctl */
+#define PCI_CONFIG_AEN		(1 << 3)  /* enable internal arbiter */
+#define PCI_CONFIG_R2H		(1 << 2)  /* REQ2# to hi-prio arbiter */
+#define PCI_CONFIG_R1H		(1 << 1)  /* REQ1# to hi-prio arbiter */
+#define PCI_CONFIG_CH		(1 << 0)  /* PCI ctl to hi-prio arbiter */
+#define PCI_B2BMASK_B2BMASK(x)	(((x) & 0xffff) << 16)
+#define PCI_B2BMASK_CCH(x)	((x) & 0xffff) /* 16 upper bits of class code */
+#define PCI_B2BBASE0_VID_B0(x)	(((x) & 0xffff) << 16)
+#define PCI_B2BBASE0_VID_SV(x)	((x) & 0xffff)
+#define PCI_B2BBASE1_SID_B1(x)	(((x) & 0xffff) << 16)
+#define PCI_B2BBASE1_SID_SI(x)	((x) & 0xffff)
+#define PCI_MWMASKDEV_MWMASK(x) (((x) & 0xffff) << 16)
+#define PCI_MWMASKDEV_DEVID(x)	((x) & 0xffff)
+#define PCI_MWBASEREVCCL_BASE(x) (((x) & 0xffff) << 16)
+#define PCI_MWBASEREVCCL_REV(x)	 (((x) & 0xff) << 8)
+#define PCI_MWBASEREVCCL_CCL(x)	 ((x) & 0xff)
+#define PCI_ID_DID(x)		(((x) & 0xffff) << 16)
+#define PCI_ID_VID(x)		((x) & 0xffff)
+#define PCI_STATCMD_STATUS(x)	(((x) & 0xffff) << 16)
+#define PCI_STATCMD_CMD(x)	((x) & 0xffff)
+#define PCI_CLASSREV_CLASS(x)	(((x) & 0x00ffffff) << 8)
+#define PCI_CLASSREV_REV(x)	((x) & 0xff)
+#define PCI_PARAM_BIST(x)	(((x) & 0xff) << 24)
+#define PCI_PARAM_HT(x)		(((x) & 0xff) << 16)
+#define PCI_PARAM_LT(x)		(((x) & 0xff) << 8)
+#define PCI_PARAM_CLS(x)	((x) & 0xff)
+#define PCI_TIMEOUT_RETRIES(x)	(((x) & 0xff) << 8)	/* max retries */
+#define PCI_TIMEOUT_TO(x)	((x) & 0xff)	/* target ready timeout */
 
 /**********************************************************************/
 
+#ifndef _LANGUAGE_ASSEMBLY
 
-/*
- * Au1300 GPIO+INT controller (GPIC) register offsets and bits
- * Registers are 128bits (0x10 bytes), divided into 4 "banks".
- */
-#define AU1300_GPIC_PINVAL	0x0000
-#define AU1300_GPIC_PINVALCLR	0x0010
-#define AU1300_GPIC_IPEND	0x0020
-#define AU1300_GPIC_PRIENC	0x0030
-#define AU1300_GPIC_IEN		0x0040	/* int_mask in manual */
-#define AU1300_GPIC_IDIS	0x0050	/* int_maskclr in manual */
-#define AU1300_GPIC_DMASEL	0x0060
-#define AU1300_GPIC_DEVSEL	0x0080
-#define AU1300_GPIC_DEVCLR	0x0090
-#define AU1300_GPIC_RSTVAL	0x00a0
-/* pin configuration space. one 32bit register for up to 128 IRQs */
-#define AU1300_GPIC_PINCFG	0x1000
-
-#define GPIC_GPIO_TO_BIT(gpio)	\
-	(1 << ((gpio) & 0x1f))
-
-#define GPIC_GPIO_BANKOFF(gpio) \
-	(((gpio) >> 5) * 4)
-
-/* Pin Control bits: who owns the pin, what does it do */
-#define GPIC_CFG_PC_GPIN		0
-#define GPIC_CFG_PC_DEV			1
-#define GPIC_CFG_PC_GPOLOW		2
-#define GPIC_CFG_PC_GPOHIGH		3
-#define GPIC_CFG_PC_MASK		3
+#include <linux/delay.h>
+#include <linux/types.h>
 
-/* assign pin to MIPS IRQ line */
-#define GPIC_CFG_IL_SET(x)	(((x) & 3) << 2)
-#define GPIC_CFG_IL_MASK	(3 << 2)
+#include <linux/io.h>
+#include <linux/irq.h>
 
-/* pin interrupt type setup */
-#define GPIC_CFG_IC_OFF		(0 << 4)
-#define GPIC_CFG_IC_LEVEL_LOW	(1 << 4)
-#define GPIC_CFG_IC_LEVEL_HIGH	(2 << 4)
-#define GPIC_CFG_IC_EDGE_FALL	(5 << 4)
-#define GPIC_CFG_IC_EDGE_RISE	(6 << 4)
-#define GPIC_CFG_IC_EDGE_BOTH	(7 << 4)
-#define GPIC_CFG_IC_MASK	(7 << 4)
+#include <asm/cpu.h>
 
-/* allow interrupt to wake cpu from 'wait' */
-#define GPIC_CFG_IDLEWAKE	(1 << 7)
 
-/***********************************************************************/
+/* Helpers to read/write from SYS_ registers */
+static inline unsigned long AU1X_RDSYS(unsigned long ofs)
+{
+	void __iomem *b = (void __iomem *)KSEG1ADDR(AU1000_SYS_PHYS_ADDR);
 
-/* Au1000 SDRAM memory controller register offsets */
-#define AU1000_MEM_SDMODE0		0x0000
-#define AU1000_MEM_SDMODE1		0x0004
-#define AU1000_MEM_SDMODE2		0x0008
-#define AU1000_MEM_SDADDR0		0x000C
-#define AU1000_MEM_SDADDR1		0x0010
-#define AU1000_MEM_SDADDR2		0x0014
-#define AU1000_MEM_SDREFCFG		0x0018
-#define AU1000_MEM_SDPRECMD		0x001C
-#define AU1000_MEM_SDAUTOREF		0x0020
-#define AU1000_MEM_SDWRMD0		0x0024
-#define AU1000_MEM_SDWRMD1		0x0028
-#define AU1000_MEM_SDWRMD2		0x002C
-#define AU1000_MEM_SDSLEEP		0x0030
-#define AU1000_MEM_SDSMCKE		0x0034
+	return __raw_readl(b + ofs);
+}
 
-/* MEM_SDMODE register content definitions */
-#define MEM_SDMODE_F		(1 << 22)
-#define MEM_SDMODE_SR		(1 << 21)
-#define MEM_SDMODE_BS		(1 << 20)
-#define MEM_SDMODE_RS		(3 << 18)
-#define MEM_SDMODE_CS		(7 << 15)
-#define MEM_SDMODE_TRAS		(15 << 11)
-#define MEM_SDMODE_TMRD		(3 << 9)
-#define MEM_SDMODE_TWR		(3 << 7)
-#define MEM_SDMODE_TRP		(3 << 5)
-#define MEM_SDMODE_TRCD		(3 << 3)
-#define MEM_SDMODE_TCL		(7 << 0)
+static inline void AU1X_WRSYS(unsigned long d, unsigned long ofs)
+{
+	void __iomem *b = (void __iomem *)KSEG1ADDR(AU1000_SYS_PHYS_ADDR);
 
-#define MEM_SDMODE_BS_2Bank	(0 << 20)
-#define MEM_SDMODE_BS_4Bank	(1 << 20)
-#define MEM_SDMODE_RS_11Row	(0 << 18)
-#define MEM_SDMODE_RS_12Row	(1 << 18)
-#define MEM_SDMODE_RS_13Row	(2 << 18)
-#define MEM_SDMODE_RS_N(N)	((N) << 18)
-#define MEM_SDMODE_CS_7Col	(0 << 15)
-#define MEM_SDMODE_CS_8Col	(1 << 15)
-#define MEM_SDMODE_CS_9Col	(2 << 15)
-#define MEM_SDMODE_CS_10Col	(3 << 15)
-#define MEM_SDMODE_CS_11Col	(4 << 15)
-#define MEM_SDMODE_CS_N(N)	((N) << 15)
-#define MEM_SDMODE_TRAS_N(N)	((N) << 11)
-#define MEM_SDMODE_TMRD_N(N)	((N) << 9)
-#define MEM_SDMODE_TWR_N(N)	((N) << 7)
-#define MEM_SDMODE_TRP_N(N)	((N) << 5)
-#define MEM_SDMODE_TRCD_N(N)	((N) << 3)
-#define MEM_SDMODE_TCL_N(N)	((N) << 0)
+	__raw_writel(d, b + ofs);
+	wmb();	/* drain write buffer */
+}
 
-/* MEM_SDADDR register contents definitions */
-#define MEM_SDADDR_E		(1 << 20)
-#define MEM_SDADDR_CSBA		(0x03FF << 10)
-#define MEM_SDADDR_CSMASK	(0x03FF << 0)
-#define MEM_SDADDR_CSBA_N(N)	((N) & (0x03FF << 22) >> 12)
-#define MEM_SDADDR_CSMASK_N(N)	((N)&(0x03FF << 22) >> 22)
+/* Early Au1000 have a write-only SYS_CPUPLL register. */
+static inline int au1xxx_cpu_has_pll_wo(void)
+{
+	switch (read_c0_prid()) {
+	case 0x00030100:	/* Au1000 DA */
+	case 0x00030201:	/* Au1000 HA */
+	case 0x00030202:	/* Au1000 HB */
+		return 1;
+	}
+	return 0;
+}
 
-/* MEM_SDREFCFG register content definitions */
-#define MEM_SDREFCFG_TRC	(15 << 28)
-#define MEM_SDREFCFG_TRPM	(3 << 26)
-#define MEM_SDREFCFG_E		(1 << 25)
-#define MEM_SDREFCFG_RE		(0x1ffffff << 0)
-#define MEM_SDREFCFG_TRC_N(N)	((N) << MEM_SDREFCFG_TRC)
-#define MEM_SDREFCFG_TRPM_N(N)	((N) << MEM_SDREFCFG_TRPM)
-#define MEM_SDREFCFG_REF_N(N)	(N)
+/* does CPU need CONFIG[OD] set to fix tons of errata? */
+static inline int au1xxx_cpu_needs_config_od(void)
+{
+	/*
+	 * c0_config.od (bit 19) was write only (and read as 0) on the
+	 * early revisions of Alchemy SOCs.  It disables the bus trans-
+	 * action overlapping and needs to be set to fix various errata.
+	 */
+	switch (read_c0_prid()) {
+	case 0x00030100: /* Au1000 DA */
+	case 0x00030201: /* Au1000 HA */
+	case 0x00030202: /* Au1000 HB */
+	case 0x01030200: /* Au1500 AB */
+	/*
+	 * Au1100/Au1200 errata actually keep silence about this bit,
+	 * so we set it just in case for those revisions that require
+	 * it to be set according to the (now gone) cpu_table.
+	 */
+	case 0x02030200: /* Au1100 AB */
+	case 0x02030201: /* Au1100 BA */
+	case 0x02030202: /* Au1100 BC */
+	case 0x04030201: /* Au1200 AC */
+		return 1;
+	}
+	return 0;
+}
 
-/* Au1550 SDRAM Register Offsets */
-#define AU1550_MEM_SDMODE0		0x0800
-#define AU1550_MEM_SDMODE1		0x0808
-#define AU1550_MEM_SDMODE2		0x0810
-#define AU1550_MEM_SDADDR0		0x0820
-#define AU1550_MEM_SDADDR1		0x0828
-#define AU1550_MEM_SDADDR2		0x0830
-#define AU1550_MEM_SDCONFIGA		0x0840
-#define AU1550_MEM_SDCONFIGB		0x0848
-#define AU1550_MEM_SDSTAT		0x0850
-#define AU1550_MEM_SDERRADDR		0x0858
-#define AU1550_MEM_SDSTRIDE0		0x0860
-#define AU1550_MEM_SDSTRIDE1		0x0868
-#define AU1550_MEM_SDSTRIDE2		0x0870
-#define AU1550_MEM_SDWRMD0		0x0880
-#define AU1550_MEM_SDWRMD1		0x0888
-#define AU1550_MEM_SDWRMD2		0x0890
-#define AU1550_MEM_SDPRECMD		0x08C0
-#define AU1550_MEM_SDAUTOREF		0x08C8
-#define AU1550_MEM_SDSREF		0x08D0
-#define AU1550_MEM_SDSLEEP		MEM_SDSREF
-
-/* Static Bus Controller */
-#define MEM_STCFG0		0xB4001000
-#define MEM_STTIME0		0xB4001004
-#define MEM_STADDR0		0xB4001008
-
-#define MEM_STCFG1		0xB4001010
-#define MEM_STTIME1		0xB4001014
-#define MEM_STADDR1		0xB4001018
-
-#define MEM_STCFG2		0xB4001020
-#define MEM_STTIME2		0xB4001024
-#define MEM_STADDR2		0xB4001028
-
-#define MEM_STCFG3		0xB4001030
-#define MEM_STTIME3		0xB4001034
-#define MEM_STADDR3		0xB4001038
-
-#define MEM_STNDCTL		0xB4001100
-#define MEM_STSTAT		0xB4001104
-
-#define MEM_STNAND_CMD		0x0
-#define MEM_STNAND_ADDR		0x4
-#define MEM_STNAND_DATA		0x20
-
-
-/* Programmable Counters 0 and 1 */
-#define SYS_BASE		0xB1900000
-#define SYS_COUNTER_CNTRL	(SYS_BASE + 0x14)
-#  define SYS_CNTRL_E1S		(1 << 23)
-#  define SYS_CNTRL_T1S		(1 << 20)
-#  define SYS_CNTRL_M21		(1 << 19)
-#  define SYS_CNTRL_M11		(1 << 18)
-#  define SYS_CNTRL_M01		(1 << 17)
-#  define SYS_CNTRL_C1S		(1 << 16)
-#  define SYS_CNTRL_BP		(1 << 14)
-#  define SYS_CNTRL_EN1		(1 << 13)
-#  define SYS_CNTRL_BT1		(1 << 12)
-#  define SYS_CNTRL_EN0		(1 << 11)
-#  define SYS_CNTRL_BT0		(1 << 10)
-#  define SYS_CNTRL_E0		(1 << 8)
-#  define SYS_CNTRL_E0S		(1 << 7)
-#  define SYS_CNTRL_32S		(1 << 5)
-#  define SYS_CNTRL_T0S		(1 << 4)
-#  define SYS_CNTRL_M20		(1 << 3)
-#  define SYS_CNTRL_M10		(1 << 2)
-#  define SYS_CNTRL_M00		(1 << 1)
-#  define SYS_CNTRL_C0S		(1 << 0)
-
-/* Programmable Counter 0 Registers */
-#define SYS_TOYTRIM		(SYS_BASE + 0)
-#define SYS_TOYWRITE		(SYS_BASE + 4)
-#define SYS_TOYMATCH0		(SYS_BASE + 8)
-#define SYS_TOYMATCH1		(SYS_BASE + 0xC)
-#define SYS_TOYMATCH2		(SYS_BASE + 0x10)
-#define SYS_TOYREAD		(SYS_BASE + 0x40)
-
-/* Programmable Counter 1 Registers */
-#define SYS_RTCTRIM		(SYS_BASE + 0x44)
-#define SYS_RTCWRITE		(SYS_BASE + 0x48)
-#define SYS_RTCMATCH0		(SYS_BASE + 0x4C)
-#define SYS_RTCMATCH1		(SYS_BASE + 0x50)
-#define SYS_RTCMATCH2		(SYS_BASE + 0x54)
-#define SYS_RTCREAD		(SYS_BASE + 0x58)
-
-/* I2S Controller */
-#define I2S_DATA		0xB1000000
-#  define I2S_DATA_MASK		0xffffff
-#define I2S_CONFIG		0xB1000004
-#  define I2S_CONFIG_XU		(1 << 25)
-#  define I2S_CONFIG_XO		(1 << 24)
-#  define I2S_CONFIG_RU		(1 << 23)
-#  define I2S_CONFIG_RO		(1 << 22)
-#  define I2S_CONFIG_TR		(1 << 21)
-#  define I2S_CONFIG_TE		(1 << 20)
-#  define I2S_CONFIG_TF		(1 << 19)
-#  define I2S_CONFIG_RR		(1 << 18)
-#  define I2S_CONFIG_RE		(1 << 17)
-#  define I2S_CONFIG_RF		(1 << 16)
-#  define I2S_CONFIG_PD		(1 << 11)
-#  define I2S_CONFIG_LB		(1 << 10)
-#  define I2S_CONFIG_IC		(1 << 9)
-#  define I2S_CONFIG_FM_BIT	7
-#  define I2S_CONFIG_FM_MASK	(0x3 << I2S_CONFIG_FM_BIT)
-#    define I2S_CONFIG_FM_I2S	(0x0 << I2S_CONFIG_FM_BIT)
-#    define I2S_CONFIG_FM_LJ	(0x1 << I2S_CONFIG_FM_BIT)
-#    define I2S_CONFIG_FM_RJ	(0x2 << I2S_CONFIG_FM_BIT)
-#  define I2S_CONFIG_TN		(1 << 6)
-#  define I2S_CONFIG_RN		(1 << 5)
-#  define I2S_CONFIG_SZ_BIT	0
-#  define I2S_CONFIG_SZ_MASK	(0x1F << I2S_CONFIG_SZ_BIT)
-
-#define I2S_CONTROL		0xB1000008
-#  define I2S_CONTROL_D		(1 << 1)
-#  define I2S_CONTROL_CE	(1 << 0)
-
-
-/* Ethernet Controllers  */
-
-/* 4 byte offsets from AU1000_ETH_BASE */
-#define MAC_CONTROL		0x0
-#  define MAC_RX_ENABLE		(1 << 2)
-#  define MAC_TX_ENABLE		(1 << 3)
-#  define MAC_DEF_CHECK		(1 << 5)
-#  define MAC_SET_BL(X)		(((X) & 0x3) << 6)
-#  define MAC_AUTO_PAD		(1 << 8)
-#  define MAC_DISABLE_RETRY	(1 << 10)
-#  define MAC_DISABLE_BCAST	(1 << 11)
-#  define MAC_LATE_COL		(1 << 12)
-#  define MAC_HASH_MODE		(1 << 13)
-#  define MAC_HASH_ONLY		(1 << 15)
-#  define MAC_PASS_ALL		(1 << 16)
-#  define MAC_INVERSE_FILTER	(1 << 17)
-#  define MAC_PROMISCUOUS	(1 << 18)
-#  define MAC_PASS_ALL_MULTI	(1 << 19)
-#  define MAC_FULL_DUPLEX	(1 << 20)
-#  define MAC_NORMAL_MODE	0
-#  define MAC_INT_LOOPBACK	(1 << 21)
-#  define MAC_EXT_LOOPBACK	(1 << 22)
-#  define MAC_DISABLE_RX_OWN	(1 << 23)
-#  define MAC_BIG_ENDIAN	(1 << 30)
-#  define MAC_RX_ALL		(1 << 31)
-#define MAC_ADDRESS_HIGH	0x4
-#define MAC_ADDRESS_LOW		0x8
-#define MAC_MCAST_HIGH		0xC
-#define MAC_MCAST_LOW		0x10
-#define MAC_MII_CNTRL		0x14
-#  define MAC_MII_BUSY		(1 << 0)
-#  define MAC_MII_READ		0
-#  define MAC_MII_WRITE		(1 << 1)
-#  define MAC_SET_MII_SELECT_REG(X) (((X) & 0x1f) << 6)
-#  define MAC_SET_MII_SELECT_PHY(X) (((X) & 0x1f) << 11)
-#define MAC_MII_DATA		0x18
-#define MAC_FLOW_CNTRL		0x1C
-#  define MAC_FLOW_CNTRL_BUSY	(1 << 0)
-#  define MAC_FLOW_CNTRL_ENABLE (1 << 1)
-#  define MAC_PASS_CONTROL	(1 << 2)
-#  define MAC_SET_PAUSE(X)	(((X) & 0xffff) << 16)
-#define MAC_VLAN1_TAG		0x20
-#define MAC_VLAN2_TAG		0x24
-
-/* Ethernet Controller Enable */
-
-#  define MAC_EN_CLOCK_ENABLE	(1 << 0)
-#  define MAC_EN_RESET0		(1 << 1)
-#  define MAC_EN_TOSS		(0 << 2)
-#  define MAC_EN_CACHEABLE	(1 << 3)
-#  define MAC_EN_RESET1		(1 << 4)
-#  define MAC_EN_RESET2		(1 << 5)
-#  define MAC_DMA_RESET		(1 << 6)
-
-/* Ethernet Controller DMA Channels */
-
-#define MAC0_TX_DMA_ADDR	0xB4004000
-#define MAC1_TX_DMA_ADDR	0xB4004200
-/* offsets from MAC_TX_RING_ADDR address */
-#define MAC_TX_BUFF0_STATUS	0x0
-#  define TX_FRAME_ABORTED	(1 << 0)
-#  define TX_JAB_TIMEOUT	(1 << 1)
-#  define TX_NO_CARRIER		(1 << 2)
-#  define TX_LOSS_CARRIER	(1 << 3)
-#  define TX_EXC_DEF		(1 << 4)
-#  define TX_LATE_COLL_ABORT	(1 << 5)
-#  define TX_EXC_COLL		(1 << 6)
-#  define TX_UNDERRUN		(1 << 7)
-#  define TX_DEFERRED		(1 << 8)
-#  define TX_LATE_COLL		(1 << 9)
-#  define TX_COLL_CNT_MASK	(0xF << 10)
-#  define TX_PKT_RETRY		(1 << 31)
-#define MAC_TX_BUFF0_ADDR	0x4
-#  define TX_DMA_ENABLE		(1 << 0)
-#  define TX_T_DONE		(1 << 1)
-#  define TX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
-#define MAC_TX_BUFF0_LEN	0x8
-#define MAC_TX_BUFF1_STATUS	0x10
-#define MAC_TX_BUFF1_ADDR	0x14
-#define MAC_TX_BUFF1_LEN	0x18
-#define MAC_TX_BUFF2_STATUS	0x20
-#define MAC_TX_BUFF2_ADDR	0x24
-#define MAC_TX_BUFF2_LEN	0x28
-#define MAC_TX_BUFF3_STATUS	0x30
-#define MAC_TX_BUFF3_ADDR	0x34
-#define MAC_TX_BUFF3_LEN	0x38
-
-#define MAC0_RX_DMA_ADDR	0xB4004100
-#define MAC1_RX_DMA_ADDR	0xB4004300
-/* offsets from MAC_RX_RING_ADDR */
-#define MAC_RX_BUFF0_STATUS	0x0
-#  define RX_FRAME_LEN_MASK	0x3fff
-#  define RX_WDOG_TIMER		(1 << 14)
-#  define RX_RUNT		(1 << 15)
-#  define RX_OVERLEN		(1 << 16)
-#  define RX_COLL		(1 << 17)
-#  define RX_ETHER		(1 << 18)
-#  define RX_MII_ERROR		(1 << 19)
-#  define RX_DRIBBLING		(1 << 20)
-#  define RX_CRC_ERROR		(1 << 21)
-#  define RX_VLAN1		(1 << 22)
-#  define RX_VLAN2		(1 << 23)
-#  define RX_LEN_ERROR		(1 << 24)
-#  define RX_CNTRL_FRAME	(1 << 25)
-#  define RX_U_CNTRL_FRAME	(1 << 26)
-#  define RX_MCAST_FRAME	(1 << 27)
-#  define RX_BCAST_FRAME	(1 << 28)
-#  define RX_FILTER_FAIL	(1 << 29)
-#  define RX_PACKET_FILTER	(1 << 30)
-#  define RX_MISSED_FRAME	(1 << 31)
-
-#  define RX_ERROR (RX_WDOG_TIMER | RX_RUNT | RX_OVERLEN |  \
-		    RX_COLL | RX_MII_ERROR | RX_CRC_ERROR | \
-		    RX_LEN_ERROR | RX_U_CNTRL_FRAME | RX_MISSED_FRAME)
-#define MAC_RX_BUFF0_ADDR	0x4
-#  define RX_DMA_ENABLE		(1 << 0)
-#  define RX_T_DONE		(1 << 1)
-#  define RX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
-#  define RX_SET_BUFF_ADDR(X)	((X) & 0xffffffc0)
-#define MAC_RX_BUFF1_STATUS	0x10
-#define MAC_RX_BUFF1_ADDR	0x14
-#define MAC_RX_BUFF2_STATUS	0x20
-#define MAC_RX_BUFF2_ADDR	0x24
-#define MAC_RX_BUFF3_STATUS	0x30
-#define MAC_RX_BUFF3_ADDR	0x34
-
-/* SSIO */
-#define SSI0_STATUS		0xB1600000
-#  define SSI_STATUS_BF		(1 << 4)
-#  define SSI_STATUS_OF		(1 << 3)
-#  define SSI_STATUS_UF		(1 << 2)
-#  define SSI_STATUS_D		(1 << 1)
-#  define SSI_STATUS_B		(1 << 0)
-#define SSI0_INT		0xB1600004
-#  define SSI_INT_OI		(1 << 3)
-#  define SSI_INT_UI		(1 << 2)
-#  define SSI_INT_DI		(1 << 1)
-#define SSI0_INT_ENABLE		0xB1600008
-#  define SSI_INTE_OIE		(1 << 3)
-#  define SSI_INTE_UIE		(1 << 2)
-#  define SSI_INTE_DIE		(1 << 1)
-#define SSI0_CONFIG		0xB1600020
-#  define SSI_CONFIG_AO		(1 << 24)
-#  define SSI_CONFIG_DO		(1 << 23)
-#  define SSI_CONFIG_ALEN_BIT	20
-#  define SSI_CONFIG_ALEN_MASK	(0x7 << 20)
-#  define SSI_CONFIG_DLEN_BIT	16
-#  define SSI_CONFIG_DLEN_MASK	(0x7 << 16)
-#  define SSI_CONFIG_DD		(1 << 11)
-#  define SSI_CONFIG_AD		(1 << 10)
-#  define SSI_CONFIG_BM_BIT	8
-#  define SSI_CONFIG_BM_MASK	(0x3 << 8)
-#  define SSI_CONFIG_CE		(1 << 7)
-#  define SSI_CONFIG_DP		(1 << 6)
-#  define SSI_CONFIG_DL		(1 << 5)
-#  define SSI_CONFIG_EP		(1 << 4)
-#define SSI0_ADATA		0xB1600024
-#  define SSI_AD_D		(1 << 24)
-#  define SSI_AD_ADDR_BIT	16
-#  define SSI_AD_ADDR_MASK	(0xff << 16)
-#  define SSI_AD_DATA_BIT	0
-#  define SSI_AD_DATA_MASK	(0xfff << 0)
-#define SSI0_CLKDIV		0xB1600028
-#define SSI0_CONTROL		0xB1600100
-#  define SSI_CONTROL_CD	(1 << 1)
-#  define SSI_CONTROL_E		(1 << 0)
-
-/* SSI1 */
-#define SSI1_STATUS		0xB1680000
-#define SSI1_INT		0xB1680004
-#define SSI1_INT_ENABLE		0xB1680008
-#define SSI1_CONFIG		0xB1680020
-#define SSI1_ADATA		0xB1680024
-#define SSI1_CLKDIV		0xB1680028
-#define SSI1_ENABLE		0xB1680100
+#define ALCHEMY_CPU_UNKNOWN	-1
+#define ALCHEMY_CPU_AU1000	0
+#define ALCHEMY_CPU_AU1500	1
+#define ALCHEMY_CPU_AU1100	2
+#define ALCHEMY_CPU_AU1550	3
+#define ALCHEMY_CPU_AU1200	4
+#define ALCHEMY_CPU_AU1300	5
 
-/*
- * Register content definitions
- */
-#define SSI_STATUS_BF		(1 << 4)
-#define SSI_STATUS_OF		(1 << 3)
-#define SSI_STATUS_UF		(1 << 2)
-#define SSI_STATUS_D		(1 << 1)
-#define SSI_STATUS_B		(1 << 0)
-
-/* SSI_INT */
-#define SSI_INT_OI		(1 << 3)
-#define SSI_INT_UI		(1 << 2)
-#define SSI_INT_DI		(1 << 1)
-
-/* SSI_INTEN */
-#define SSI_INTEN_OIE		(1 << 3)
-#define SSI_INTEN_UIE		(1 << 2)
-#define SSI_INTEN_DIE		(1 << 1)
-
-#define SSI_CONFIG_AO		(1 << 24)
-#define SSI_CONFIG_DO		(1 << 23)
-#define SSI_CONFIG_ALEN		(7 << 20)
-#define SSI_CONFIG_DLEN		(15 << 16)
-#define SSI_CONFIG_DD		(1 << 11)
-#define SSI_CONFIG_AD		(1 << 10)
-#define SSI_CONFIG_BM		(3 << 8)
-#define SSI_CONFIG_CE		(1 << 7)
-#define SSI_CONFIG_DP		(1 << 6)
-#define SSI_CONFIG_DL		(1 << 5)
-#define SSI_CONFIG_EP		(1 << 4)
-#define SSI_CONFIG_ALEN_N(N)	((N-1) << 20)
-#define SSI_CONFIG_DLEN_N(N)	((N-1) << 16)
-#define SSI_CONFIG_BM_HI	(0 << 8)
-#define SSI_CONFIG_BM_LO	(1 << 8)
-#define SSI_CONFIG_BM_CY	(2 << 8)
-
-#define SSI_ADATA_D		(1 << 24)
-#define SSI_ADATA_ADDR		(0xFF << 16)
-#define SSI_ADATA_DATA		0x0FFF
-#define SSI_ADATA_ADDR_N(N)	(N << 16)
-
-#define SSI_ENABLE_CD		(1 << 1)
-#define SSI_ENABLE_E		(1 << 0)
+static inline int alchemy_get_cputype(void)
+{
+	switch (read_c0_prid() & (PRID_OPT_MASK | PRID_COMP_MASK)) {
+	case 0x00030000:
+		return ALCHEMY_CPU_AU1000;
+		break;
+	case 0x01030000:
+		return ALCHEMY_CPU_AU1500;
+		break;
+	case 0x02030000:
+		return ALCHEMY_CPU_AU1100;
+		break;
+	case 0x03030000:
+		return ALCHEMY_CPU_AU1550;
+		break;
+	case 0x04030000:
+	case 0x05030000:
+		return ALCHEMY_CPU_AU1200;
+		break;
+	case 0x800c0000:
+		return ALCHEMY_CPU_AU1300;
+		break;
+	}
 
+	return ALCHEMY_CPU_UNKNOWN;
+}
 
-/*
- * The IrDA peripheral has an IRFIRSEL pin, but on the DB/PB boards it's not
- * used to select FIR/SIR mode on the transceiver but as a GPIO.  Instead a
- * CPLD has to be told about the mode.
- */
-#define AU1000_IRDA_PHY_MODE_OFF	0
-#define AU1000_IRDA_PHY_MODE_SIR	1
-#define AU1000_IRDA_PHY_MODE_FIR	2
+/* return number of uarts on a given cputype */
+static inline int alchemy_get_uarts(int type)
+{
+	switch (type) {
+	case ALCHEMY_CPU_AU1000:
+	case ALCHEMY_CPU_AU1300:
+		return 4;
+	case ALCHEMY_CPU_AU1500:
+	case ALCHEMY_CPU_AU1200:
+		return 2;
+	case ALCHEMY_CPU_AU1100:
+	case ALCHEMY_CPU_AU1550:
+		return 3;
+	}
+	return 0;
+}
 
-struct au1k_irda_platform_data {
-	void(*set_phy_mode)(int mode);
-};
+/* enable an UART block if it isn't already */
+static inline void alchemy_uart_enable(u32 uart_phys)
+{
+	void __iomem *addr = (void __iomem *)KSEG1ADDR(uart_phys);
 
+	/* reset, enable clock, deassert reset */
+	if ((__raw_readl(addr + 0x100) & 3) != 3) {
+		__raw_writel(0, addr + 0x100);
+		wmb();
+		__raw_writel(1, addr + 0x100);
+		wmb();
+	}
+	__raw_writel(3, addr + 0x100);
+	wmb();
+}
 
-/* GPIO */
-#define SYS_PINFUNC		0xB190002C
-#  define SYS_PF_USB		(1 << 15)	/* 2nd USB device/host */
-#  define SYS_PF_U3		(1 << 14)	/* GPIO23/U3TXD */
-#  define SYS_PF_U2		(1 << 13)	/* GPIO22/U2TXD */
-#  define SYS_PF_U1		(1 << 12)	/* GPIO21/U1TXD */
-#  define SYS_PF_SRC		(1 << 11)	/* GPIO6/SROMCKE */
-#  define SYS_PF_CK5		(1 << 10)	/* GPIO3/CLK5 */
-#  define SYS_PF_CK4		(1 << 9)	/* GPIO2/CLK4 */
-#  define SYS_PF_IRF		(1 << 8)	/* GPIO15/IRFIRSEL */
-#  define SYS_PF_UR3		(1 << 7)	/* GPIO[14:9]/UART3 */
-#  define SYS_PF_I2D		(1 << 6)	/* GPIO8/I2SDI */
-#  define SYS_PF_I2S		(1 << 5)	/* I2S/GPIO[29:31] */
-#  define SYS_PF_NI2		(1 << 4)	/* NI2/GPIO[24:28] */
-#  define SYS_PF_U0		(1 << 3)	/* U0TXD/GPIO20 */
-#  define SYS_PF_RD		(1 << 2)	/* IRTXD/GPIO19 */
-#  define SYS_PF_A97		(1 << 1)	/* AC97/SSL1 */
-#  define SYS_PF_S0		(1 << 0)	/* SSI_0/GPIO[16:18] */
+static inline void alchemy_uart_disable(u32 uart_phys)
+{
+	void __iomem *addr = (void __iomem *)KSEG1ADDR(uart_phys);
+	__raw_writel(0, addr + 0x100);	/* UART_MOD_CNTRL */
+	wmb();
+}
 
-/* Au1100 only */
-#  define SYS_PF_PC		(1 << 18)	/* PCMCIA/GPIO[207:204] */
-#  define SYS_PF_LCD		(1 << 17)	/* extern lcd/GPIO[203:200] */
-#  define SYS_PF_CS		(1 << 16)	/* EXTCLK0/32KHz to gpio2 */
-#  define SYS_PF_EX0		(1 << 9)	/* GPIO2/clock */
+static inline void alchemy_uart_putchar(u32 uart_phys, u8 c)
+{
+	void __iomem *base = (void __iomem *)KSEG1ADDR(uart_phys);
+	int timeout, i;
 
-/* Au1550 only.	 Redefines lots of pins */
-#  define SYS_PF_PSC2_MASK	(7 << 17)
-#  define SYS_PF_PSC2_AC97	0
-#  define SYS_PF_PSC2_SPI	0
-#  define SYS_PF_PSC2_I2S	(1 << 17)
-#  define SYS_PF_PSC2_SMBUS	(3 << 17)
-#  define SYS_PF_PSC2_GPIO	(7 << 17)
-#  define SYS_PF_PSC3_MASK	(7 << 20)
-#  define SYS_PF_PSC3_AC97	0
-#  define SYS_PF_PSC3_SPI	0
-#  define SYS_PF_PSC3_I2S	(1 << 20)
-#  define SYS_PF_PSC3_SMBUS	(3 << 20)
-#  define SYS_PF_PSC3_GPIO	(7 << 20)
-#  define SYS_PF_PSC1_S1	(1 << 1)
-#  define SYS_PF_MUST_BE_SET	((1 << 5) | (1 << 2))
+	/* check LSR TX_EMPTY bit */
+	timeout = 0xffffff;
+	do {
+		if (__raw_readl(base + 0x1c) & 0x20)
+			break;
+		/* slow down */
+		for (i = 10000; i; i--)
+			asm volatile ("nop");
+	} while (--timeout);
 
-/* Au1200 only */
-#define SYS_PINFUNC_DMA		(1 << 31)
-#define SYS_PINFUNC_S0A		(1 << 30)
-#define SYS_PINFUNC_S1A		(1 << 29)
-#define SYS_PINFUNC_LP0		(1 << 28)
-#define SYS_PINFUNC_LP1		(1 << 27)
-#define SYS_PINFUNC_LD16	(1 << 26)
-#define SYS_PINFUNC_LD8		(1 << 25)
-#define SYS_PINFUNC_LD1		(1 << 24)
-#define SYS_PINFUNC_LD0		(1 << 23)
-#define SYS_PINFUNC_P1A		(3 << 21)
-#define SYS_PINFUNC_P1B		(1 << 20)
-#define SYS_PINFUNC_FS3		(1 << 19)
-#define SYS_PINFUNC_P0A		(3 << 17)
-#define SYS_PINFUNC_CS		(1 << 16)
-#define SYS_PINFUNC_CIM		(1 << 15)
-#define SYS_PINFUNC_P1C		(1 << 14)
-#define SYS_PINFUNC_U1T		(1 << 12)
-#define SYS_PINFUNC_U1R		(1 << 11)
-#define SYS_PINFUNC_EX1		(1 << 10)
-#define SYS_PINFUNC_EX0		(1 << 9)
-#define SYS_PINFUNC_U0R		(1 << 8)
-#define SYS_PINFUNC_MC		(1 << 7)
-#define SYS_PINFUNC_S0B		(1 << 6)
-#define SYS_PINFUNC_S0C		(1 << 5)
-#define SYS_PINFUNC_P0B		(1 << 4)
-#define SYS_PINFUNC_U0T		(1 << 3)
-#define SYS_PINFUNC_S1B		(1 << 2)
+	__raw_writel(c, base + 0x04);	/* tx */
+	wmb();
+}
 
-/* Power Management */
-#define SYS_SCRATCH0		0xB1900018
-#define SYS_SCRATCH1		0xB190001C
-#define SYS_WAKEMSK		0xB1900034
-#define SYS_ENDIAN		0xB1900038
-#define SYS_POWERCTRL		0xB190003C
-#define SYS_WAKESRC		0xB190005C
-#define SYS_SLPPWR		0xB1900078
-#define SYS_SLEEP		0xB190007C
+/* return number of ethernet MACs on a given cputype */
+static inline int alchemy_get_macs(int type)
+{
+	switch (type) {
+	case ALCHEMY_CPU_AU1000:
+	case ALCHEMY_CPU_AU1500:
+	case ALCHEMY_CPU_AU1550:
+		return 2;
+	case ALCHEMY_CPU_AU1100:
+		return 1;
+	}
+	return 0;
+}
 
-#define SYS_WAKEMSK_D2		(1 << 9)
-#define SYS_WAKEMSK_M2		(1 << 8)
-#define SYS_WAKEMSK_GPIO(x)	(1 << (x))
+/* arch/mips/au1000/common/clocks.c */
+extern void set_au1x00_speed(unsigned int new_freq);
+extern unsigned int get_au1x00_speed(void);
+extern void set_au1x00_uart_baud_base(unsigned long new_baud_base);
+extern unsigned long get_au1x00_uart_baud_base(void);
+extern unsigned long au1xxx_calc_clock(void);
 
-/* Clock Controller */
-#define SYS_FREQCTRL0		0xB1900020
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
-#define SYS_FREQCTRL1		0xB1900024
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
-#define SYS_CLKSRC		0xB1900028
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
+/* PM: arch/mips/alchemy/common/sleeper.S, power.c, irq.c */
+void alchemy_sleep_au1000(void);
+void alchemy_sleep_au1550(void);
+void alchemy_sleep_au1300(void);
+void au_sleep(void);
 
-#  define SYS_CS_ML_BIT		7
-#  define SYS_CS_ML_MASK	(0x7 << SYS_CS_ML_BIT)
-#  define SYS_CS_DL		(1 << 6)
-#  define SYS_CS_CL		(1 << 5)
+/* USB: drivers/usb/host/alchemy-common.c */
+enum alchemy_usb_block {
+	ALCHEMY_USB_OHCI0,
+	ALCHEMY_USB_UDC0,
+	ALCHEMY_USB_EHCI0,
+	ALCHEMY_USB_OTG0,
+	ALCHEMY_USB_OHCI1,
+};
+int alchemy_usb_control(int block, int enable);
 
-#  define SYS_CS_MUH_BIT	12
-#  define SYS_CS_MUH_MASK	(0x7 << SYS_CS_MUH_BIT)
-#  define SYS_CS_DUH		(1 << 11)
-#  define SYS_CS_CUH		(1 << 10)
-#  define SYS_CS_MUD_BIT	7
-#  define SYS_CS_MUD_MASK	(0x7 << SYS_CS_MUD_BIT)
-#  define SYS_CS_DUD		(1 << 6)
-#  define SYS_CS_CUD		(1 << 5)
+/* PCI controller platform data */
+struct alchemy_pci_platdata {
+	int (*board_map_irq)(const struct pci_dev *d, u8 slot, u8 pin);
+	int (*board_pci_idsel)(unsigned int devsel, int assert);
+	/* bits to set/clear in PCI_CONFIG register */
+	unsigned long pci_cfg_set;
+	unsigned long pci_cfg_clr;
+};
 
-#  define SYS_CS_MIR_BIT	2
-#  define SYS_CS_MIR_MASK	(0x7 << SYS_CS_MIR_BIT)
-#  define SYS_CS_DIR		(1 << 1)
-#  define SYS_CS_CIR		(1 << 0)
+/*
+ * The IrDA peripheral has an IRFIRSEL pin, but on the DB/PB boards it's
+ * not used to select FIR/SIR mode on the transceiver but as a GPIO.
+ * Instead a CPLD has to be told about the mode.
+ */
+#define AU1000_IRDA_PHY_MODE_OFF	0
+#define AU1000_IRDA_PHY_MODE_SIR	1
+#define AU1000_IRDA_PHY_MODE_FIR	2
 
-#  define SYS_CS_MUX_AUX	0x1
-#  define SYS_CS_MUX_FQ0	0x2
-#  define SYS_CS_MUX_FQ1	0x3
-#  define SYS_CS_MUX_FQ2	0x4
-#  define SYS_CS_MUX_FQ3	0x5
-#  define SYS_CS_MUX_FQ4	0x6
-#  define SYS_CS_MUX_FQ5	0x7
-#define SYS_CPUPLL		0xB1900060
-#define SYS_AUXPLL		0xB1900064
-
-/* AC97 Controller */
-#define AC97C_CONFIG		0xB0000000
-#  define AC97C_RECV_SLOTS_BIT	13
-#  define AC97C_RECV_SLOTS_MASK (0x3ff << AC97C_RECV_SLOTS_BIT)
-#  define AC97C_XMIT_SLOTS_BIT	3
-#  define AC97C_XMIT_SLOTS_MASK (0x3ff << AC97C_XMIT_SLOTS_BIT)
-#  define AC97C_SG		(1 << 2)
-#  define AC97C_SYNC		(1 << 1)
-#  define AC97C_RESET		(1 << 0)
-#define AC97C_STATUS		0xB0000004
-#  define AC97C_XU		(1 << 11)
-#  define AC97C_XO		(1 << 10)
-#  define AC97C_RU		(1 << 9)
-#  define AC97C_RO		(1 << 8)
-#  define AC97C_READY		(1 << 7)
-#  define AC97C_CP		(1 << 6)
-#  define AC97C_TR		(1 << 5)
-#  define AC97C_TE		(1 << 4)
-#  define AC97C_TF		(1 << 3)
-#  define AC97C_RR		(1 << 2)
-#  define AC97C_RE		(1 << 1)
-#  define AC97C_RF		(1 << 0)
-#define AC97C_DATA		0xB0000008
-#define AC97C_CMD		0xB000000C
-#  define AC97C_WD_BIT		16
-#  define AC97C_READ		(1 << 7)
-#  define AC97C_INDEX_MASK	0x7f
-#define AC97C_CNTRL		0xB0000010
-#  define AC97C_RS		(1 << 1)
-#  define AC97C_CE		(1 << 0)
+struct au1k_irda_platform_data {
+	void (*set_phy_mode)(int mode);
+};
 
 
-/* The PCI chip selects are outside the 32bit space, and since we can't
- * just program the 36bit addresses into BARs, we have to take a chunk
- * out of the 32bit space and reserve it for PCI.  When these addresses
- * are ioremap()ed, they'll be fixed up to the real 36bit address before
- * being passed to the real ioremap function.
+/* Multifunction pins: Each of these pins can either be assigned to the
+ * GPIO controller or a on-chip peripheral.
+ * Call "au1300_pinfunc_to_dev()" or "au1300_pinfunc_to_gpio()" to
+ * assign one of these to either the GPIO controller or the device.
  */
-#define ALCHEMY_PCI_MEMWIN_START	(AU1500_PCI_MEM_PHYS_ADDR >> 4)
-#define ALCHEMY_PCI_MEMWIN_END		(ALCHEMY_PCI_MEMWIN_START + 0x0FFFFFFF)
+enum au1300_multifunc_pins {
+	/* wake-from-str pins 0-3 */
+	AU1300_PIN_WAKE0 = 0, AU1300_PIN_WAKE1, AU1300_PIN_WAKE2,
+	AU1300_PIN_WAKE3,
+	/* external clock sources for PSCs: 4-5 */
+	AU1300_PIN_EXTCLK0, AU1300_PIN_EXTCLK1,
+	/* 8bit MMC interface on SD0: 6-9 */
+	AU1300_PIN_SD0DAT4, AU1300_PIN_SD0DAT5, AU1300_PIN_SD0DAT6,
+	AU1300_PIN_SD0DAT7,
+	/* aux clk input for freqgen 3: 10 */
+	AU1300_PIN_FG3AUX,
+	/* UART1 pins: 11-18 */
+	AU1300_PIN_U1RI, AU1300_PIN_U1DCD, AU1300_PIN_U1DSR,
+	AU1300_PIN_U1CTS, AU1300_PIN_U1RTS, AU1300_PIN_U1DTR,
+	AU1300_PIN_U1RX, AU1300_PIN_U1TX,
+	/* UART0 pins: 19-24 */
+	AU1300_PIN_U0RI, AU1300_PIN_U0DCD, AU1300_PIN_U0DSR,
+	AU1300_PIN_U0CTS, AU1300_PIN_U0RTS, AU1300_PIN_U0DTR,
+	/* UART2: 25-26 */
+	AU1300_PIN_U2RX, AU1300_PIN_U2TX,
+	/* UART3: 27-28 */
+	AU1300_PIN_U3RX, AU1300_PIN_U3TX,
+	/* LCD controller PWMs, ext pixclock: 29-31 */
+	AU1300_PIN_LCDPWM0, AU1300_PIN_LCDPWM1, AU1300_PIN_LCDCLKIN,
+	/* SD1 interface: 32-37 */
+	AU1300_PIN_SD1DAT0, AU1300_PIN_SD1DAT1, AU1300_PIN_SD1DAT2,
+	AU1300_PIN_SD1DAT3, AU1300_PIN_SD1CMD, AU1300_PIN_SD1CLK,
+	/* SD2 interface: 38-43 */
+	AU1300_PIN_SD2DAT0, AU1300_PIN_SD2DAT1, AU1300_PIN_SD2DAT2,
+	AU1300_PIN_SD2DAT3, AU1300_PIN_SD2CMD, AU1300_PIN_SD2CLK,
+	/* PSC0/1 clocks: 44-45 */
+	AU1300_PIN_PSC0CLK, AU1300_PIN_PSC1CLK,
+	/* PSCs: 46-49/50-53/54-57/58-61 */
+	AU1300_PIN_PSC0SYNC0, AU1300_PIN_PSC0SYNC1, AU1300_PIN_PSC0D0,
+	AU1300_PIN_PSC0D1,
+	AU1300_PIN_PSC1SYNC0, AU1300_PIN_PSC1SYNC1, AU1300_PIN_PSC1D0,
+	AU1300_PIN_PSC1D1,
+	AU1300_PIN_PSC2SYNC0, AU1300_PIN_PSC2SYNC1, AU1300_PIN_PSC2D0,
+	AU1300_PIN_PSC2D1,
+	AU1300_PIN_PSC3SYNC0, AU1300_PIN_PSC3SYNC1, AU1300_PIN_PSC3D0,
+	AU1300_PIN_PSC3D1,
+	/* PCMCIA interface: 62-70 */
+	AU1300_PIN_PCE2, AU1300_PIN_PCE1, AU1300_PIN_PIOS16,
+	AU1300_PIN_PIOR, AU1300_PIN_PWE, AU1300_PIN_PWAIT,
+	AU1300_PIN_PREG, AU1300_PIN_POE, AU1300_PIN_PIOW,
+	/* camera interface H/V sync inputs: 71-72 */
+	AU1300_PIN_CIMLS, AU1300_PIN_CIMFS,
+	/* PSC2/3 clocks: 73-74 */
+	AU1300_PIN_PSC2CLK, AU1300_PIN_PSC3CLK,
+};
 
-/* for PCI IO it's simpler because we get to do the ioremap ourselves and then
- * adjust the device's resources.
- */
-#define ALCHEMY_PCI_IOWIN_START		0x00001000
-#define ALCHEMY_PCI_IOWIN_END		0x0000FFFF
+/* GPIC (Au1300) pin management: arch/mips/alchemy/common/gpioint.c */
+extern void au1300_pinfunc_to_gpio(enum au1300_multifunc_pins gpio);
+extern void au1300_pinfunc_to_dev(enum au1300_multifunc_pins gpio);
+extern void au1300_set_irq_priority(unsigned int irq, int p);
+extern void au1300_set_dbdma_gpio(int dchan, unsigned int gpio);
 
-#ifdef CONFIG_PCI
+/* Au1300 allows to disconnect certain blocks from internal power supply */
+enum au1300_vss_block {
+	AU1300_VSS_MPE = 0,
+	AU1300_VSS_BSA,
+	AU1300_VSS_GPE,
+	AU1300_VSS_MGP,
+};
 
-#define IOPORT_RESOURCE_START	0x00001000	/* skip legacy probing */
-#define IOPORT_RESOURCE_END	0xffffffff
-#define IOMEM_RESOURCE_START	0x10000000
-#define IOMEM_RESOURCE_END	0xfffffffffULL
+extern void au1300_vss_block_control(int block, int enable);
+
+
+enum soc_au1000_ints {
+	AU1000_FIRST_INT	= AU1000_INTC0_INT_BASE,
+	AU1000_UART0_INT	= AU1000_FIRST_INT,
+	AU1000_UART1_INT,
+	AU1000_UART2_INT,
+	AU1000_UART3_INT,
+	AU1000_SSI0_INT,
+	AU1000_SSI1_INT,
+	AU1000_DMA_INT_BASE,
+
+	AU1000_TOY_INT		= AU1000_FIRST_INT + 14,
+	AU1000_TOY_MATCH0_INT,
+	AU1000_TOY_MATCH1_INT,
+	AU1000_TOY_MATCH2_INT,
+	AU1000_RTC_INT,
+	AU1000_RTC_MATCH0_INT,
+	AU1000_RTC_MATCH1_INT,
+	AU1000_RTC_MATCH2_INT,
+	AU1000_IRDA_TX_INT,
+	AU1000_IRDA_RX_INT,
+	AU1000_USB_DEV_REQ_INT,
+	AU1000_USB_DEV_SUS_INT,
+	AU1000_USB_HOST_INT,
+	AU1000_ACSYNC_INT,
+	AU1000_MAC0_DMA_INT,
+	AU1000_MAC1_DMA_INT,
+	AU1000_I2S_UO_INT,
+	AU1000_AC97C_INT,
+	AU1000_GPIO0_INT,
+	AU1000_GPIO1_INT,
+	AU1000_GPIO2_INT,
+	AU1000_GPIO3_INT,
+	AU1000_GPIO4_INT,
+	AU1000_GPIO5_INT,
+	AU1000_GPIO6_INT,
+	AU1000_GPIO7_INT,
+	AU1000_GPIO8_INT,
+	AU1000_GPIO9_INT,
+	AU1000_GPIO10_INT,
+	AU1000_GPIO11_INT,
+	AU1000_GPIO12_INT,
+	AU1000_GPIO13_INT,
+	AU1000_GPIO14_INT,
+	AU1000_GPIO15_INT,
+	AU1000_GPIO16_INT,
+	AU1000_GPIO17_INT,
+	AU1000_GPIO18_INT,
+	AU1000_GPIO19_INT,
+	AU1000_GPIO20_INT,
+	AU1000_GPIO21_INT,
+	AU1000_GPIO22_INT,
+	AU1000_GPIO23_INT,
+	AU1000_GPIO24_INT,
+	AU1000_GPIO25_INT,
+	AU1000_GPIO26_INT,
+	AU1000_GPIO27_INT,
+	AU1000_GPIO28_INT,
+	AU1000_GPIO29_INT,
+	AU1000_GPIO30_INT,
+	AU1000_GPIO31_INT,
+};
+
+enum soc_au1100_ints {
+	AU1100_FIRST_INT	= AU1000_INTC0_INT_BASE,
+	AU1100_UART0_INT	= AU1100_FIRST_INT,
+	AU1100_UART1_INT,
+	AU1100_SD_INT,
+	AU1100_UART3_INT,
+	AU1100_SSI0_INT,
+	AU1100_SSI1_INT,
+	AU1100_DMA_INT_BASE,
+
+	AU1100_TOY_INT		= AU1100_FIRST_INT + 14,
+	AU1100_TOY_MATCH0_INT,
+	AU1100_TOY_MATCH1_INT,
+	AU1100_TOY_MATCH2_INT,
+	AU1100_RTC_INT,
+	AU1100_RTC_MATCH0_INT,
+	AU1100_RTC_MATCH1_INT,
+	AU1100_RTC_MATCH2_INT,
+	AU1100_IRDA_TX_INT,
+	AU1100_IRDA_RX_INT,
+	AU1100_USB_DEV_REQ_INT,
+	AU1100_USB_DEV_SUS_INT,
+	AU1100_USB_HOST_INT,
+	AU1100_ACSYNC_INT,
+	AU1100_MAC0_DMA_INT,
+	AU1100_GPIO208_215_INT,
+	AU1100_LCD_INT,
+	AU1100_AC97C_INT,
+	AU1100_GPIO0_INT,
+	AU1100_GPIO1_INT,
+	AU1100_GPIO2_INT,
+	AU1100_GPIO3_INT,
+	AU1100_GPIO4_INT,
+	AU1100_GPIO5_INT,
+	AU1100_GPIO6_INT,
+	AU1100_GPIO7_INT,
+	AU1100_GPIO8_INT,
+	AU1100_GPIO9_INT,
+	AU1100_GPIO10_INT,
+	AU1100_GPIO11_INT,
+	AU1100_GPIO12_INT,
+	AU1100_GPIO13_INT,
+	AU1100_GPIO14_INT,
+	AU1100_GPIO15_INT,
+	AU1100_GPIO16_INT,
+	AU1100_GPIO17_INT,
+	AU1100_GPIO18_INT,
+	AU1100_GPIO19_INT,
+	AU1100_GPIO20_INT,
+	AU1100_GPIO21_INT,
+	AU1100_GPIO22_INT,
+	AU1100_GPIO23_INT,
+	AU1100_GPIO24_INT,
+	AU1100_GPIO25_INT,
+	AU1100_GPIO26_INT,
+	AU1100_GPIO27_INT,
+	AU1100_GPIO28_INT,
+	AU1100_GPIO29_INT,
+	AU1100_GPIO30_INT,
+	AU1100_GPIO31_INT,
+};
 
-#else
+enum soc_au1500_ints {
+	AU1500_FIRST_INT	= AU1000_INTC0_INT_BASE,
+	AU1500_UART0_INT	= AU1500_FIRST_INT,
+	AU1500_PCI_INTA,
+	AU1500_PCI_INTB,
+	AU1500_UART3_INT,
+	AU1500_PCI_INTC,
+	AU1500_PCI_INTD,
+	AU1500_DMA_INT_BASE,
 
-/* Don't allow any legacy ports probing */
-#define IOPORT_RESOURCE_START	0x10000000
-#define IOPORT_RESOURCE_END	0xffffffff
-#define IOMEM_RESOURCE_START	0x10000000
-#define IOMEM_RESOURCE_END	0xfffffffffULL
+	AU1500_TOY_INT		= AU1500_FIRST_INT + 14,
+	AU1500_TOY_MATCH0_INT,
+	AU1500_TOY_MATCH1_INT,
+	AU1500_TOY_MATCH2_INT,
+	AU1500_RTC_INT,
+	AU1500_RTC_MATCH0_INT,
+	AU1500_RTC_MATCH1_INT,
+	AU1500_RTC_MATCH2_INT,
+	AU1500_PCI_ERR_INT,
+	AU1500_RESERVED_INT,
+	AU1500_USB_DEV_REQ_INT,
+	AU1500_USB_DEV_SUS_INT,
+	AU1500_USB_HOST_INT,
+	AU1500_ACSYNC_INT,
+	AU1500_MAC0_DMA_INT,
+	AU1500_MAC1_DMA_INT,
+	AU1500_AC97C_INT	= AU1500_FIRST_INT + 31,
+	AU1500_GPIO0_INT,
+	AU1500_GPIO1_INT,
+	AU1500_GPIO2_INT,
+	AU1500_GPIO3_INT,
+	AU1500_GPIO4_INT,
+	AU1500_GPIO5_INT,
+	AU1500_GPIO6_INT,
+	AU1500_GPIO7_INT,
+	AU1500_GPIO8_INT,
+	AU1500_GPIO9_INT,
+	AU1500_GPIO10_INT,
+	AU1500_GPIO11_INT,
+	AU1500_GPIO12_INT,
+	AU1500_GPIO13_INT,
+	AU1500_GPIO14_INT,
+	AU1500_GPIO15_INT,
+	AU1500_GPIO200_INT,
+	AU1500_GPIO201_INT,
+	AU1500_GPIO202_INT,
+	AU1500_GPIO203_INT,
+	AU1500_GPIO20_INT,
+	AU1500_GPIO204_INT,
+	AU1500_GPIO205_INT,
+	AU1500_GPIO23_INT,
+	AU1500_GPIO24_INT,
+	AU1500_GPIO25_INT,
+	AU1500_GPIO26_INT,
+	AU1500_GPIO27_INT,
+	AU1500_GPIO28_INT,
+	AU1500_GPIO206_INT,
+	AU1500_GPIO207_INT,
+	AU1500_GPIO208_215_INT,
+};
 
-#endif
+enum soc_au1550_ints {
+	AU1550_FIRST_INT	= AU1000_INTC0_INT_BASE,
+	AU1550_UART0_INT	= AU1550_FIRST_INT,
+	AU1550_PCI_INTA,
+	AU1550_PCI_INTB,
+	AU1550_DDMA_INT,
+	AU1550_CRYPTO_INT,
+	AU1550_PCI_INTC,
+	AU1550_PCI_INTD,
+	AU1550_PCI_RST_INT,
+	AU1550_UART1_INT,
+	AU1550_UART3_INT,
+	AU1550_PSC0_INT,
+	AU1550_PSC1_INT,
+	AU1550_PSC2_INT,
+	AU1550_PSC3_INT,
+	AU1550_TOY_INT,
+	AU1550_TOY_MATCH0_INT,
+	AU1550_TOY_MATCH1_INT,
+	AU1550_TOY_MATCH2_INT,
+	AU1550_RTC_INT,
+	AU1550_RTC_MATCH0_INT,
+	AU1550_RTC_MATCH1_INT,
+	AU1550_RTC_MATCH2_INT,
 
-/* PCI controller block register offsets */
-#define PCI_REG_CMEM		0x0000
-#define PCI_REG_CONFIG		0x0004
-#define PCI_REG_B2BMASK_CCH	0x0008
-#define PCI_REG_B2BBASE0_VID	0x000C
-#define PCI_REG_B2BBASE1_SID	0x0010
-#define PCI_REG_MWMASK_DEV	0x0014
-#define PCI_REG_MWBASE_REV_CCL	0x0018
-#define PCI_REG_ERR_ADDR	0x001C
-#define PCI_REG_SPEC_INTACK	0x0020
-#define PCI_REG_ID		0x0100
-#define PCI_REG_STATCMD		0x0104
-#define PCI_REG_CLASSREV	0x0108
-#define PCI_REG_PARAM		0x010C
-#define PCI_REG_MBAR		0x0110
-#define PCI_REG_TIMEOUT		0x0140
+	AU1550_NAND_INT		= AU1550_FIRST_INT + 23,
+	AU1550_USB_DEV_REQ_INT,
+	AU1550_USB_DEV_SUS_INT,
+	AU1550_USB_HOST_INT,
+	AU1550_MAC0_DMA_INT,
+	AU1550_MAC1_DMA_INT,
+	AU1550_GPIO0_INT	= AU1550_FIRST_INT + 32,
+	AU1550_GPIO1_INT,
+	AU1550_GPIO2_INT,
+	AU1550_GPIO3_INT,
+	AU1550_GPIO4_INT,
+	AU1550_GPIO5_INT,
+	AU1550_GPIO6_INT,
+	AU1550_GPIO7_INT,
+	AU1550_GPIO8_INT,
+	AU1550_GPIO9_INT,
+	AU1550_GPIO10_INT,
+	AU1550_GPIO11_INT,
+	AU1550_GPIO12_INT,
+	AU1550_GPIO13_INT,
+	AU1550_GPIO14_INT,
+	AU1550_GPIO15_INT,
+	AU1550_GPIO200_INT,
+	AU1550_GPIO201_205_INT, /* Logical or of GPIO201:205 */
+	AU1550_GPIO16_INT,
+	AU1550_GPIO17_INT,
+	AU1550_GPIO20_INT,
+	AU1550_GPIO21_INT,
+	AU1550_GPIO22_INT,
+	AU1550_GPIO23_INT,
+	AU1550_GPIO24_INT,
+	AU1550_GPIO25_INT,
+	AU1550_GPIO26_INT,
+	AU1550_GPIO27_INT,
+	AU1550_GPIO28_INT,
+	AU1550_GPIO206_INT,
+	AU1550_GPIO207_INT,
+	AU1550_GPIO208_215_INT, /* Logical or of GPIO208:215 */
+};
 
-/* PCI controller block register bits */
-#define PCI_CMEM_E		(1 << 28)	/* enable cacheable memory */
-#define PCI_CMEM_CMBASE(x)	(((x) & 0x3fff) << 14)
-#define PCI_CMEM_CMMASK(x)	((x) & 0x3fff)
-#define PCI_CONFIG_ERD		(1 << 27) /* pci error during R/W */
-#define PCI_CONFIG_ET		(1 << 26) /* error in target mode */
-#define PCI_CONFIG_EF		(1 << 25) /* fatal error */
-#define PCI_CONFIG_EP		(1 << 24) /* parity error */
-#define PCI_CONFIG_EM		(1 << 23) /* multiple errors */
-#define PCI_CONFIG_BM		(1 << 22) /* bad master error */
-#define PCI_CONFIG_PD		(1 << 20) /* PCI Disable */
-#define PCI_CONFIG_BME		(1 << 19) /* Byte Mask Enable for reads */
-#define PCI_CONFIG_NC		(1 << 16) /* mark mem access non-coherent */
-#define PCI_CONFIG_IA		(1 << 15) /* INTA# enabled (target mode) */
-#define PCI_CONFIG_IP		(1 << 13) /* int on PCI_PERR# */
-#define PCI_CONFIG_IS		(1 << 12) /* int on PCI_SERR# */
-#define PCI_CONFIG_IMM		(1 << 11) /* int on master abort */
-#define PCI_CONFIG_ITM		(1 << 10) /* int on target abort (as master) */
-#define PCI_CONFIG_ITT		(1 << 9)  /* int on target abort (as target) */
-#define PCI_CONFIG_IPB		(1 << 8)  /* int on PERR# in bus master acc */
-#define PCI_CONFIG_SIC_NO	(0 << 6)  /* no byte mask changes */
-#define PCI_CONFIG_SIC_BA_ADR	(1 << 6)  /* on byte/hw acc, invert adr bits */
-#define PCI_CONFIG_SIC_HWA_DAT	(2 << 6)  /* on halfword acc, swap data */
-#define PCI_CONFIG_SIC_ALL	(3 << 6)  /* swap data bytes on all accesses */
-#define PCI_CONFIG_ST		(1 << 5)  /* swap data by target transactions */
-#define PCI_CONFIG_SM		(1 << 4)  /* swap data from PCI ctl */
-#define PCI_CONFIG_AEN		(1 << 3)  /* enable internal arbiter */
-#define PCI_CONFIG_R2H		(1 << 2)  /* REQ2# to hi-prio arbiter */
-#define PCI_CONFIG_R1H		(1 << 1)  /* REQ1# to hi-prio arbiter */
-#define PCI_CONFIG_CH		(1 << 0)  /* PCI ctl to hi-prio arbiter */
-#define PCI_B2BMASK_B2BMASK(x)	(((x) & 0xffff) << 16)
-#define PCI_B2BMASK_CCH(x)	((x) & 0xffff) /* 16 upper bits of class code */
-#define PCI_B2BBASE0_VID_B0(x)	(((x) & 0xffff) << 16)
-#define PCI_B2BBASE0_VID_SV(x)	((x) & 0xffff)
-#define PCI_B2BBASE1_SID_B1(x)	(((x) & 0xffff) << 16)
-#define PCI_B2BBASE1_SID_SI(x)	((x) & 0xffff)
-#define PCI_MWMASKDEV_MWMASK(x) (((x) & 0xffff) << 16)
-#define PCI_MWMASKDEV_DEVID(x)	((x) & 0xffff)
-#define PCI_MWBASEREVCCL_BASE(x) (((x) & 0xffff) << 16)
-#define PCI_MWBASEREVCCL_REV(x)	 (((x) & 0xff) << 8)
-#define PCI_MWBASEREVCCL_CCL(x)	 ((x) & 0xff)
-#define PCI_ID_DID(x)		(((x) & 0xffff) << 16)
-#define PCI_ID_VID(x)		((x) & 0xffff)
-#define PCI_STATCMD_STATUS(x)	(((x) & 0xffff) << 16)
-#define PCI_STATCMD_CMD(x)	((x) & 0xffff)
-#define PCI_CLASSREV_CLASS(x)	(((x) & 0x00ffffff) << 8)
-#define PCI_CLASSREV_REV(x)	((x) & 0xff)
-#define PCI_PARAM_BIST(x)	(((x) & 0xff) << 24)
-#define PCI_PARAM_HT(x)		(((x) & 0xff) << 16)
-#define PCI_PARAM_LT(x)		(((x) & 0xff) << 8)
-#define PCI_PARAM_CLS(x)	((x) & 0xff)
-#define PCI_TIMEOUT_RETRIES(x)	(((x) & 0xff) << 8)	/* max retries */
-#define PCI_TIMEOUT_TO(x)	((x) & 0xff)	/* target ready timeout */
+enum soc_au1200_ints {
+	AU1200_FIRST_INT	= AU1000_INTC0_INT_BASE,
+	AU1200_UART0_INT	= AU1200_FIRST_INT,
+	AU1200_SWT_INT,
+	AU1200_SD_INT,
+	AU1200_DDMA_INT,
+	AU1200_MAE_BE_INT,
+	AU1200_GPIO200_INT,
+	AU1200_GPIO201_INT,
+	AU1200_GPIO202_INT,
+	AU1200_UART1_INT,
+	AU1200_MAE_FE_INT,
+	AU1200_PSC0_INT,
+	AU1200_PSC1_INT,
+	AU1200_AES_INT,
+	AU1200_CAMERA_INT,
+	AU1200_TOY_INT,
+	AU1200_TOY_MATCH0_INT,
+	AU1200_TOY_MATCH1_INT,
+	AU1200_TOY_MATCH2_INT,
+	AU1200_RTC_INT,
+	AU1200_RTC_MATCH0_INT,
+	AU1200_RTC_MATCH1_INT,
+	AU1200_RTC_MATCH2_INT,
+	AU1200_GPIO203_INT,
+	AU1200_NAND_INT,
+	AU1200_GPIO204_INT,
+	AU1200_GPIO205_INT,
+	AU1200_GPIO206_INT,
+	AU1200_GPIO207_INT,
+	AU1200_GPIO208_215_INT, /* Logical OR of 208:215 */
+	AU1200_USB_INT,
+	AU1200_LCD_INT,
+	AU1200_MAE_BOTH_INT,
+	AU1200_GPIO0_INT,
+	AU1200_GPIO1_INT,
+	AU1200_GPIO2_INT,
+	AU1200_GPIO3_INT,
+	AU1200_GPIO4_INT,
+	AU1200_GPIO5_INT,
+	AU1200_GPIO6_INT,
+	AU1200_GPIO7_INT,
+	AU1200_GPIO8_INT,
+	AU1200_GPIO9_INT,
+	AU1200_GPIO10_INT,
+	AU1200_GPIO11_INT,
+	AU1200_GPIO12_INT,
+	AU1200_GPIO13_INT,
+	AU1200_GPIO14_INT,
+	AU1200_GPIO15_INT,
+	AU1200_GPIO16_INT,
+	AU1200_GPIO17_INT,
+	AU1200_GPIO18_INT,
+	AU1200_GPIO19_INT,
+	AU1200_GPIO20_INT,
+	AU1200_GPIO21_INT,
+	AU1200_GPIO22_INT,
+	AU1200_GPIO23_INT,
+	AU1200_GPIO24_INT,
+	AU1200_GPIO25_INT,
+	AU1200_GPIO26_INT,
+	AU1200_GPIO27_INT,
+	AU1200_GPIO28_INT,
+	AU1200_GPIO29_INT,
+	AU1200_GPIO30_INT,
+	AU1200_GPIO31_INT,
+};
+#endif /* _LANGUAGE_ASSEMBLY */
 
-#endif
+#endif /* _AU1000_H_ */
diff --git a/arch/mips/include/asm/mach-au1x00/au1000_dma.h b/arch/mips/include/asm/mach-au1x00/au1000_dma.h
index 7cedca5..aa58e55 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000_dma.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000_dma.h
@@ -106,7 +106,7 @@ enum {
 struct dma_chan {
 	int dev_id;		/* this channel is allocated if >= 0, */
 				/* free otherwise */
-	unsigned int io;
+	void __iomem *io;
 	const char *dev_str;
 	int irq;
 	void *irq_dev;
@@ -157,7 +157,7 @@ static inline void enable_dma_buffer0(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_BE0, chan->io + DMA_MODE_SET);
+	__raw_writel(DMA_BE0, chan->io + DMA_MODE_SET);
 }
 
 static inline void enable_dma_buffer1(unsigned int dmanr)
@@ -166,7 +166,7 @@ static inline void enable_dma_buffer1(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_BE1, chan->io + DMA_MODE_SET);
+	__raw_writel(DMA_BE1, chan->io + DMA_MODE_SET);
 }
 static inline void enable_dma_buffers(unsigned int dmanr)
 {
@@ -174,7 +174,7 @@ static inline void enable_dma_buffers(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_BE0 | DMA_BE1, chan->io + DMA_MODE_SET);
+	__raw_writel(DMA_BE0 | DMA_BE1, chan->io + DMA_MODE_SET);
 }
 
 static inline void start_dma(unsigned int dmanr)
@@ -183,7 +183,7 @@ static inline void start_dma(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_GO, chan->io + DMA_MODE_SET);
+	__raw_writel(DMA_GO, chan->io + DMA_MODE_SET);
 }
 
 #define DMA_HALT_POLL 0x5000
@@ -195,11 +195,11 @@ static inline void halt_dma(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_GO, chan->io + DMA_MODE_CLEAR);
+	__raw_writel(DMA_GO, chan->io + DMA_MODE_CLEAR);
 
 	/* Poll the halt bit */
 	for (i = 0; i < DMA_HALT_POLL; i++)
-		if (au_readl(chan->io + DMA_MODE_READ) & DMA_HALT)
+		if (__raw_readl(chan->io + DMA_MODE_READ) & DMA_HALT)
 			break;
 	if (i == DMA_HALT_POLL)
 		printk(KERN_INFO "halt_dma: HALT poll expired!\n");
@@ -215,7 +215,7 @@ static inline void disable_dma(unsigned int dmanr)
 	halt_dma(dmanr);
 
 	/* Now we can disable the buffers */
-	au_writel(~DMA_GO, chan->io + DMA_MODE_CLEAR);
+	__raw_writel(~DMA_GO, chan->io + DMA_MODE_CLEAR);
 }
 
 static inline int dma_halted(unsigned int dmanr)
@@ -224,7 +224,7 @@ static inline int dma_halted(unsigned int dmanr)
 
 	if (!chan)
 		return 1;
-	return (au_readl(chan->io + DMA_MODE_READ) & DMA_HALT) ? 1 : 0;
+	return (__raw_readl(chan->io + DMA_MODE_READ) & DMA_HALT) ? 1 : 0;
 }
 
 /* Initialize a DMA channel. */
@@ -239,14 +239,15 @@ static inline void init_dma(unsigned int dmanr)
 	disable_dma(dmanr);
 
 	/* Set device FIFO address */
-	au_writel(CPHYSADDR(chan->fifo_addr), chan->io + DMA_PERIPHERAL_ADDR);
+	__raw_writel(CPHYSADDR(chan->fifo_addr),
+		    chan->io + DMA_PERIPHERAL_ADDR);
 
 	mode = chan->mode | (chan->dev_id << DMA_DID_BIT);
 	if (chan->irq)
 		mode |= DMA_IE;
 
-	au_writel(~mode, chan->io + DMA_MODE_CLEAR);
-	au_writel(mode,	 chan->io + DMA_MODE_SET);
+	__raw_writel(~mode, chan->io + DMA_MODE_CLEAR);
+	__raw_writel(mode,	 chan->io + DMA_MODE_SET);
 }
 
 /*
@@ -283,7 +284,7 @@ static inline int get_dma_active_buffer(unsigned int dmanr)
 
 	if (!chan)
 		return -1;
-	return (au_readl(chan->io + DMA_MODE_READ) & DMA_AB) ? 1 : 0;
+	return (__raw_readl(chan->io + DMA_MODE_READ) & DMA_AB) ? 1 : 0;
 }
 
 /*
@@ -304,7 +305,7 @@ static inline void set_dma_fifo_addr(unsigned int dmanr, unsigned int a)
 	if (chan->dev_id != DMA_ID_GP04 && chan->dev_id != DMA_ID_GP05)
 		return;
 
-	au_writel(CPHYSADDR(a), chan->io + DMA_PERIPHERAL_ADDR);
+	__raw_writel(CPHYSADDR(a), chan->io + DMA_PERIPHERAL_ADDR);
 }
 
 /*
@@ -316,7 +317,7 @@ static inline void clear_dma_done0(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_D0, chan->io + DMA_MODE_CLEAR);
+	__raw_writel(DMA_D0, chan->io + DMA_MODE_CLEAR);
 }
 
 static inline void clear_dma_done1(unsigned int dmanr)
@@ -325,7 +326,7 @@ static inline void clear_dma_done1(unsigned int dmanr)
 
 	if (!chan)
 		return;
-	au_writel(DMA_D1, chan->io + DMA_MODE_CLEAR);
+	__raw_writel(DMA_D1, chan->io + DMA_MODE_CLEAR);
 }
 
 /*
@@ -344,7 +345,7 @@ static inline void set_dma_addr0(unsigned int dmanr, unsigned int a)
 
 	if (!chan)
 		return;
-	au_writel(a, chan->io + DMA_BUFFER0_START);
+	__raw_writel(a, chan->io + DMA_BUFFER0_START);
 }
 
 /*
@@ -356,7 +357,7 @@ static inline void set_dma_addr1(unsigned int dmanr, unsigned int a)
 
 	if (!chan)
 		return;
-	au_writel(a, chan->io + DMA_BUFFER1_START);
+	__raw_writel(a, chan->io + DMA_BUFFER1_START);
 }
 
 
@@ -370,7 +371,7 @@ static inline void set_dma_count0(unsigned int dmanr, unsigned int count)
 	if (!chan)
 		return;
 	count &= DMA_COUNT_MASK;
-	au_writel(count, chan->io + DMA_BUFFER0_COUNT);
+	__raw_writel(count, chan->io + DMA_BUFFER0_COUNT);
 }
 
 /*
@@ -383,7 +384,7 @@ static inline void set_dma_count1(unsigned int dmanr, unsigned int count)
 	if (!chan)
 		return;
 	count &= DMA_COUNT_MASK;
-	au_writel(count, chan->io + DMA_BUFFER1_COUNT);
+	__raw_writel(count, chan->io + DMA_BUFFER1_COUNT);
 }
 
 /*
@@ -396,8 +397,8 @@ static inline void set_dma_count(unsigned int dmanr, unsigned int count)
 	if (!chan)
 		return;
 	count &= DMA_COUNT_MASK;
-	au_writel(count, chan->io + DMA_BUFFER0_COUNT);
-	au_writel(count, chan->io + DMA_BUFFER1_COUNT);
+	__raw_writel(count, chan->io + DMA_BUFFER0_COUNT);
+	__raw_writel(count, chan->io + DMA_BUFFER1_COUNT);
 }
 
 /*
@@ -410,7 +411,7 @@ static inline unsigned int get_dma_buffer_done(unsigned int dmanr)
 
 	if (!chan)
 		return 0;
-	return au_readl(chan->io + DMA_MODE_READ) & (DMA_D0 | DMA_D1);
+	return __raw_readl(chan->io + DMA_MODE_READ) & (DMA_D0 | DMA_D1);
 }
 
 
@@ -437,10 +438,10 @@ static inline int get_dma_residue(unsigned int dmanr)
 	if (!chan)
 		return 0;
 
-	curBufCntReg = (au_readl(chan->io + DMA_MODE_READ) & DMA_AB) ?
+	curBufCntReg = (__raw_readl(chan->io + DMA_MODE_READ) & DMA_AB) ?
 	    DMA_BUFFER1_COUNT : DMA_BUFFER0_COUNT;
 
-	count = au_readl(chan->io + curBufCntReg) & DMA_COUNT_MASK;
+	count = __raw_readl(chan->io + curBufCntReg) & DMA_COUNT_MASK;
 
 	if ((chan->mode & DMA_DW_MASK) == DMA_DW16)
 		count <<= 1;
diff --git a/arch/mips/include/asm/mach-au1x00/gpio-au1000.h b/arch/mips/include/asm/mach-au1x00/gpio-au1000.h
index 796afd0..6934181 100644
--- a/arch/mips/include/asm/mach-au1x00/gpio-au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/gpio-au1000.h
@@ -25,20 +25,20 @@
 #define MAKE_IRQ(intc, off)	(AU1000_INTC##intc##_INT_BASE + (off))
 
 /* GPIO1 registers within SYS_ area */
-#define SYS_TRIOUTRD		0x100
-#define SYS_TRIOUTCLR		0x100
-#define SYS_OUTPUTRD		0x108
-#define SYS_OUTPUTSET		0x108
-#define SYS_OUTPUTCLR		0x10C
-#define SYS_PINSTATERD		0x110
-#define SYS_PININPUTEN		0x110
+#define AU1000_SYS_TRIOUTRD		0x0100
+#define AU1000_SYS_TRIOUTCLR		0x0100
+#define AU1000_SYS_OUTPUTRD		0x0108
+#define AU1000_SYS_OUTPUTSET		0x0108
+#define AU1000_SYS_OUTPUTCLR		0x010C
+#define AU1000_SYS_PINSTATERD		0x0110
+#define AU1000_SYS_PININPUTEN		0x0110
 
 /* register offsets within GPIO2 block */
-#define GPIO2_DIR		0x00
-#define GPIO2_OUTPUT		0x08
-#define GPIO2_PINSTATE		0x0C
-#define GPIO2_INTENABLE		0x10
-#define GPIO2_ENABLE		0x14
+#define AU1500_GPIO2_DIR		0x0000
+#define AU1500_GPIO2_OUTPUT		0x0008
+#define AU1500_GPIO2_PINSTATE		0x000C
+#define AU1500_GPIO2_INTENABLE		0x0010
+#define AU1500_GPIO2_ENABLE		0x0014
 
 struct gpio;
 
@@ -217,26 +217,24 @@ static inline int au1200_irq_to_gpio(int irq)
  */
 static inline void alchemy_gpio1_set_value(int gpio, int v)
 {
-	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1000_SYS_PHYS_ADDR);
 	unsigned long mask = 1 << (gpio - ALCHEMY_GPIO1_BASE);
-	unsigned long r = v ? SYS_OUTPUTSET : SYS_OUTPUTCLR;
-	__raw_writel(mask, base + r);
-	wmb();
+	unsigned long r = v ? AU1000_SYS_OUTPUTSET : AU1000_SYS_OUTPUTCLR;
+
+	AU1X_WRSYS(mask, r);
 }
 
 static inline int alchemy_gpio1_get_value(int gpio)
 {
-	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1000_SYS_PHYS_ADDR);
 	unsigned long mask = 1 << (gpio - ALCHEMY_GPIO1_BASE);
-	return __raw_readl(base + SYS_PINSTATERD) & mask;
+
+	return AU1X_RDSYS(AU1000_SYS_PINSTATERD) & mask;
 }
 
 static inline int alchemy_gpio1_direction_input(int gpio)
 {
-	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1000_SYS_PHYS_ADDR);
 	unsigned long mask = 1 << (gpio - ALCHEMY_GPIO1_BASE);
-	__raw_writel(mask, base + SYS_TRIOUTCLR);
-	wmb();
+
+	AU1X_WRSYS(mask, AU1000_SYS_TRIOUTCLR);
 	return 0;
 }
 
@@ -279,13 +277,13 @@ static inline void __alchemy_gpio2_mod_dir(int gpio, int to_out)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1500_GPIO2_PHYS_ADDR);
 	unsigned long mask = 1 << (gpio - ALCHEMY_GPIO2_BASE);
-	unsigned long d = __raw_readl(base + GPIO2_DIR);
+	unsigned long d = __raw_readl(base + AU1500_GPIO2_DIR);
 
 	if (to_out)
 		d |= mask;
 	else
 		d &= ~mask;
-	__raw_writel(d, base + GPIO2_DIR);
+	__raw_writel(d, base + AU1500_GPIO2_DIR);
 	wmb();
 }
 
@@ -293,15 +291,18 @@ static inline void alchemy_gpio2_set_value(int gpio, int v)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1500_GPIO2_PHYS_ADDR);
 	unsigned long mask;
+
 	mask = ((v) ? 0x00010001 : 0x00010000) << (gpio - ALCHEMY_GPIO2_BASE);
-	__raw_writel(mask, base + GPIO2_OUTPUT);
-	wmb();
+	__raw_writel(mask, base + AU1500_GPIO2_OUTPUT);
+	wmb(); /* wait for it hit hardware */
 }
 
 static inline int alchemy_gpio2_get_value(int gpio)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1500_GPIO2_PHYS_ADDR);
-	return __raw_readl(base + GPIO2_PINSTATE) & (1 << (gpio - ALCHEMY_GPIO2_BASE));
+
+	return __raw_readl(base + AU1500_GPIO2_PINSTATE) &
+			  (1 << (gpio - ALCHEMY_GPIO2_BASE));
 }
 
 static inline int alchemy_gpio2_direction_input(int gpio)
@@ -352,12 +353,12 @@ static inline int alchemy_gpio2_to_irq(int gpio)
 static inline void __alchemy_gpio2_mod_int(int gpio2, int en)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1500_GPIO2_PHYS_ADDR);
-	unsigned long r = __raw_readl(base + GPIO2_INTENABLE);
+	unsigned long r = __raw_readl(base + AU1500_GPIO2_INTENABLE);
 	if (en)
 		r |= 1 << gpio2;
 	else
 		r &= ~(1 << gpio2);
-	__raw_writel(r, base + GPIO2_INTENABLE);
+	__raw_writel(r, base + AU1500_GPIO2_INTENABLE);
 	wmb();
 }
 
@@ -434,9 +435,9 @@ static inline void alchemy_gpio2_disable_int(int gpio2)
 static inline void alchemy_gpio2_enable(void)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1500_GPIO2_PHYS_ADDR);
-	__raw_writel(3, base + GPIO2_ENABLE);	/* reset, clock enabled */
+	__raw_writel(3, base + AU1500_GPIO2_ENABLE); /* reset, clock */
 	wmb();
-	__raw_writel(1, base + GPIO2_ENABLE);	/* clock enabled */
+	__raw_writel(1, base + AU1500_GPIO2_ENABLE); /* clock */
 	wmb();
 }
 
@@ -448,8 +449,9 @@ static inline void alchemy_gpio2_enable(void)
 static inline void alchemy_gpio2_disable(void)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(AU1500_GPIO2_PHYS_ADDR);
-	__raw_writel(2, base + GPIO2_ENABLE);	/* reset, clock disabled */
-	wmb();
+
+	__raw_writel(2, base + AU1500_GPIO2_ENABLE);	/* reset */
+	wmb(); /* let it hit hardware */
 }
 
 /**********************************************************************/
diff --git a/arch/mips/pci/pci-alchemy.c b/arch/mips/pci/pci-alchemy.c
index 563d1f6..912c5f2 100644
--- a/arch/mips/pci/pci-alchemy.c
+++ b/arch/mips/pci/pci-alchemy.c
@@ -109,9 +109,9 @@ static int config_access(unsigned char access_type, struct pci_bus *bus,
 	}
 
 	local_irq_save(flags);
-	r = __raw_readl(ctx->regs + PCI_REG_STATCMD) & 0x0000ffff;
+	r = __raw_readl(ctx->regs + AU1500_PCI_STATCMD) & 0x0000ffff;
 	r |= PCI_STATCMD_STATUS(0x2000);
-	__raw_writel(r, ctx->regs + PCI_REG_STATCMD);
+	__raw_writel(r, ctx->regs + AU1500_PCI_STATCMD);
 	wmb();
 
 	/* Allow board vendors to implement their own off-chip IDSEL.
@@ -159,7 +159,7 @@ static int config_access(unsigned char access_type, struct pci_bus *bus,
 	    access_type, bus->number, device, where, *data, offset);
 
 	/* check for errors, master abort */
-	status = __raw_readl(ctx->regs + PCI_REG_STATCMD);
+	status = __raw_readl(ctx->regs + AU1500_PCI_STATCMD);
 	if (status & (1 << 29)) {
 		*data = 0xffffffff;
 		error = -1;
@@ -170,7 +170,8 @@ static int config_access(unsigned char access_type, struct pci_bus *bus,
 		    device, (status >> 28) & 0xf);
 
 		/* clear errors */
-		__raw_writel(status & 0xf000ffff, ctx->regs + PCI_REG_STATCMD);
+		__raw_writel(status & 0xf000ffff,
+			     ctx->regs + AU1500_PCI_STATCMD);
 
 		*data = 0xffffffff;
 		error = -1;
@@ -308,18 +309,18 @@ static int alchemy_pci_suspend(void)
 	if (!ctx)
 		return 0;
 
-	ctx->pm[0]  = __raw_readl(ctx->regs + PCI_REG_CMEM);
-	ctx->pm[1]  = __raw_readl(ctx->regs + PCI_REG_CONFIG) & 0x0009ffff;
-	ctx->pm[2]  = __raw_readl(ctx->regs + PCI_REG_B2BMASK_CCH);
-	ctx->pm[3]  = __raw_readl(ctx->regs + PCI_REG_B2BBASE0_VID);
-	ctx->pm[4]  = __raw_readl(ctx->regs + PCI_REG_B2BBASE1_SID);
-	ctx->pm[5]  = __raw_readl(ctx->regs + PCI_REG_MWMASK_DEV);
-	ctx->pm[6]  = __raw_readl(ctx->regs + PCI_REG_MWBASE_REV_CCL);
-	ctx->pm[7]  = __raw_readl(ctx->regs + PCI_REG_ID);
-	ctx->pm[8]  = __raw_readl(ctx->regs + PCI_REG_CLASSREV);
-	ctx->pm[9]  = __raw_readl(ctx->regs + PCI_REG_PARAM);
-	ctx->pm[10] = __raw_readl(ctx->regs + PCI_REG_MBAR);
-	ctx->pm[11] = __raw_readl(ctx->regs + PCI_REG_TIMEOUT);
+	ctx->pm[0]  = __raw_readl(ctx->regs + AU1500_PCI_CMEM);
+	ctx->pm[1]  = __raw_readl(ctx->regs + AU1500_PCI_CONFIG) & 0x0009ffff;
+	ctx->pm[2]  = __raw_readl(ctx->regs + AU1500_PCI_B2BMASK_CCH);
+	ctx->pm[3]  = __raw_readl(ctx->regs + AU1500_PCI_B2BBASE0_VID);
+	ctx->pm[4]  = __raw_readl(ctx->regs + AU1500_PCI_B2BBASE1_SID);
+	ctx->pm[5]  = __raw_readl(ctx->regs + AU1500_PCI_MWMASK_DEV);
+	ctx->pm[6]  = __raw_readl(ctx->regs + AU1500_PCI_MWBASE_REV_CCL);
+	ctx->pm[7]  = __raw_readl(ctx->regs + AU1500_PCI_ID);
+	ctx->pm[8]  = __raw_readl(ctx->regs + AU1500_PCI_CLASSREV);
+	ctx->pm[9]  = __raw_readl(ctx->regs + AU1500_PCI_PARAM);
+	ctx->pm[10] = __raw_readl(ctx->regs + AU1500_PCI_MBAR);
+	ctx->pm[11] = __raw_readl(ctx->regs + AU1500_PCI_TIMEOUT);
 
 	return 0;
 }
@@ -330,19 +331,19 @@ static void alchemy_pci_resume(void)
 	if (!ctx)
 		return;
 
-	__raw_writel(ctx->pm[0],  ctx->regs + PCI_REG_CMEM);
-	__raw_writel(ctx->pm[2],  ctx->regs + PCI_REG_B2BMASK_CCH);
-	__raw_writel(ctx->pm[3],  ctx->regs + PCI_REG_B2BBASE0_VID);
-	__raw_writel(ctx->pm[4],  ctx->regs + PCI_REG_B2BBASE1_SID);
-	__raw_writel(ctx->pm[5],  ctx->regs + PCI_REG_MWMASK_DEV);
-	__raw_writel(ctx->pm[6],  ctx->regs + PCI_REG_MWBASE_REV_CCL);
-	__raw_writel(ctx->pm[7],  ctx->regs + PCI_REG_ID);
-	__raw_writel(ctx->pm[8],  ctx->regs + PCI_REG_CLASSREV);
-	__raw_writel(ctx->pm[9],  ctx->regs + PCI_REG_PARAM);
-	__raw_writel(ctx->pm[10], ctx->regs + PCI_REG_MBAR);
-	__raw_writel(ctx->pm[11], ctx->regs + PCI_REG_TIMEOUT);
+	__raw_writel(ctx->pm[0],  ctx->regs + AU1500_PCI_CMEM);
+	__raw_writel(ctx->pm[2],  ctx->regs + AU1500_PCI_B2BMASK_CCH);
+	__raw_writel(ctx->pm[3],  ctx->regs + AU1500_PCI_B2BBASE0_VID);
+	__raw_writel(ctx->pm[4],  ctx->regs + AU1500_PCI_B2BBASE1_SID);
+	__raw_writel(ctx->pm[5],  ctx->regs + AU1500_PCI_MWMASK_DEV);
+	__raw_writel(ctx->pm[6],  ctx->regs + AU1500_PCI_MWBASE_REV_CCL);
+	__raw_writel(ctx->pm[7],  ctx->regs + AU1500_PCI_ID);
+	__raw_writel(ctx->pm[8],  ctx->regs + AU1500_PCI_CLASSREV);
+	__raw_writel(ctx->pm[9],  ctx->regs + AU1500_PCI_PARAM);
+	__raw_writel(ctx->pm[10], ctx->regs + AU1500_PCI_MBAR);
+	__raw_writel(ctx->pm[11], ctx->regs + AU1500_PCI_TIMEOUT);
 	wmb();
-	__raw_writel(ctx->pm[1],  ctx->regs + PCI_REG_CONFIG);
+	__raw_writel(ctx->pm[1],  ctx->regs + AU1500_PCI_CONFIG);
 	wmb();
 
 	/* YAMON on all db1xxx boards wipes the TLB and writes zero to C0_wired
@@ -415,9 +416,9 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 	/* Au1500 revisions older than AD have borked coherent PCI */
 	if ((alchemy_get_cputype() == ALCHEMY_CPU_AU1500) &&
 	    (read_c0_prid() < 0x01030202) && !coherentio) {
-		val = __raw_readl(ctx->regs + PCI_REG_CONFIG);
+		val = __raw_readl(ctx->regs + AU1500_PCI_CONFIG);
 		val |= PCI_CONFIG_NC;
-		__raw_writel(val, ctx->regs + PCI_REG_CONFIG);
+		__raw_writel(val, ctx->regs + AU1500_PCI_CONFIG);
 		wmb();
 		dev_info(&pdev->dev, "non-coherent PCI on Au1500 AA/AB/AC\n");
 	}
@@ -453,11 +454,11 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 	set_io_port_base((unsigned long)ctx->alchemy_pci_ctrl.io_map_base);
 
 	/* board may want to modify bits in the config register, do it now */
-	val = __raw_readl(ctx->regs + PCI_REG_CONFIG);
+	val = __raw_readl(ctx->regs + AU1500_PCI_CONFIG);
 	val &= ~pd->pci_cfg_clr;
 	val |= pd->pci_cfg_set;
 	val &= ~PCI_CONFIG_PD;		/* clear disable bit */
-	__raw_writel(val, ctx->regs + PCI_REG_CONFIG);
+	__raw_writel(val, ctx->regs + AU1500_PCI_CONFIG);
 	wmb();
 
 	__alchemy_pci_ctx = ctx;
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index f5443a6..1837309 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -90,7 +90,7 @@ struct au1xmmc_host {
 	struct mmc_request *mrq;
 
 	u32 flags;
-	u32 iobase;
+	void __iomem *iobase;
 	u32 clock;
 	u32 bus_width;
 	u32 power_mode;
@@ -162,32 +162,33 @@ static inline int has_dbdma(void)
 
 static inline void IRQ_ON(struct au1xmmc_host *host, u32 mask)
 {
-	u32 val = au_readl(HOST_CONFIG(host));
+	u32 val = __raw_readl(HOST_CONFIG(host));
 	val |= mask;
-	au_writel(val, HOST_CONFIG(host));
-	au_sync();
+	__raw_writel(val, HOST_CONFIG(host));
+	wmb();
 }
 
 static inline void FLUSH_FIFO(struct au1xmmc_host *host)
 {
-	u32 val = au_readl(HOST_CONFIG2(host));
+	u32 val = __raw_readl(HOST_CONFIG2(host));
 
-	au_writel(val | SD_CONFIG2_FF, HOST_CONFIG2(host));
-	au_sync_delay(1);
+	__raw_writel(val | SD_CONFIG2_FF, HOST_CONFIG2(host));
+	wmb();
+	mdelay(1);
 
 	/* SEND_STOP will turn off clock control - this re-enables it */
 	val &= ~SD_CONFIG2_DF;
 
-	au_writel(val, HOST_CONFIG2(host));
-	au_sync();
+	__raw_writel(val, HOST_CONFIG2(host));
+	wmb();
 }
 
 static inline void IRQ_OFF(struct au1xmmc_host *host, u32 mask)
 {
-	u32 val = au_readl(HOST_CONFIG(host));
+	u32 val = __raw_readl(HOST_CONFIG(host));
 	val &= ~mask;
-	au_writel(val, HOST_CONFIG(host));
-	au_sync();
+	__raw_writel(val, HOST_CONFIG(host));
+	wmb();
 }
 
 static inline void SEND_STOP(struct au1xmmc_host *host)
@@ -197,12 +198,12 @@ static inline void SEND_STOP(struct au1xmmc_host *host)
 	WARN_ON(host->status != HOST_S_DATA);
 	host->status = HOST_S_STOP;
 
-	config2 = au_readl(HOST_CONFIG2(host));
-	au_writel(config2 | SD_CONFIG2_DF, HOST_CONFIG2(host));
-	au_sync();
+	config2 = __raw_readl(HOST_CONFIG2(host));
+	__raw_writel(config2 | SD_CONFIG2_DF, HOST_CONFIG2(host));
+	wmb();
 
 	/* Send the stop command */
-	au_writel(STOP_CMD, HOST_CMD(host));
+	__raw_writel(STOP_CMD, HOST_CMD(host));
 }
 
 static void au1xmmc_set_power(struct au1xmmc_host *host, int state)
@@ -296,28 +297,28 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
 		}
 	}
 
-	au_writel(cmd->arg, HOST_CMDARG(host));
-	au_sync();
+	__raw_writel(cmd->arg, HOST_CMDARG(host));
+	wmb();
 
 	if (wait)
 		IRQ_OFF(host, SD_CONFIG_CR);
 
-	au_writel((mmccmd | SD_CMD_GO), HOST_CMD(host));
-	au_sync();
+	__raw_writel((mmccmd | SD_CMD_GO), HOST_CMD(host));
+	wmb();
 
 	/* Wait for the command to go on the line */
-	while (au_readl(HOST_CMD(host)) & SD_CMD_GO)
+	while (__raw_readl(HOST_CMD(host)) & SD_CMD_GO)
 		/* nop */;
 
 	/* Wait for the command to come back */
 	if (wait) {
-		u32 status = au_readl(HOST_STATUS(host));
+		u32 status = __raw_readl(HOST_STATUS(host));
 
 		while (!(status & SD_STATUS_CR))
-			status = au_readl(HOST_STATUS(host));
+			status = __raw_readl(HOST_STATUS(host));
 
 		/* Clear the CR status */
-		au_writel(SD_STATUS_CR, HOST_STATUS(host));
+		__raw_writel(SD_STATUS_CR, HOST_STATUS(host));
 
 		IRQ_ON(host, SD_CONFIG_CR);
 	}
@@ -339,11 +340,11 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 	data = mrq->cmd->data;
 
 	if (status == 0)
-		status = au_readl(HOST_STATUS(host));
+		status = __raw_readl(HOST_STATUS(host));
 
 	/* The transaction is really over when the SD_STATUS_DB bit is clear */
 	while ((host->flags & HOST_F_XMIT) && (status & SD_STATUS_DB))
-		status = au_readl(HOST_STATUS(host));
+		status = __raw_readl(HOST_STATUS(host));
 
 	data->error = 0;
 	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma.dir);
@@ -357,7 +358,7 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 		data->error = -EILSEQ;
 
 	/* Clear the CRC bits */
-	au_writel(SD_STATUS_WC | SD_STATUS_RC, HOST_STATUS(host));
+	__raw_writel(SD_STATUS_WC | SD_STATUS_RC, HOST_STATUS(host));
 
 	data->bytes_xfered = 0;
 
@@ -380,7 +381,7 @@ static void au1xmmc_tasklet_data(unsigned long param)
 {
 	struct au1xmmc_host *host = (struct au1xmmc_host *)param;
 
-	u32 status = au_readl(HOST_STATUS(host));
+	u32 status = __raw_readl(HOST_STATUS(host));
 	au1xmmc_data_complete(host, status);
 }
 
@@ -412,15 +413,15 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 		max = AU1XMMC_MAX_TRANSFER;
 
 	for (count = 0; count < max; count++) {
-		status = au_readl(HOST_STATUS(host));
+		status = __raw_readl(HOST_STATUS(host));
 
 		if (!(status & SD_STATUS_TH))
 			break;
 
 		val = *sg_ptr++;
 
-		au_writel((unsigned long)val, HOST_TXPORT(host));
-		au_sync();
+		__raw_writel((unsigned long)val, HOST_TXPORT(host));
+		wmb();
 	}
 
 	host->pio.len -= count;
@@ -472,7 +473,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 		max = AU1XMMC_MAX_TRANSFER;
 
 	for (count = 0; count < max; count++) {
-		status = au_readl(HOST_STATUS(host));
+		status = __raw_readl(HOST_STATUS(host));
 
 		if (!(status & SD_STATUS_NE))
 			break;
@@ -494,7 +495,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 			break;
 		}
 
-		val = au_readl(HOST_RXPORT(host));
+		val = __raw_readl(HOST_RXPORT(host));
 
 		if (sg_ptr)
 			*sg_ptr++ = (unsigned char)(val & 0xFF);
@@ -537,10 +538,10 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
-			r[0] = au_readl(host->iobase + SD_RESP3);
-			r[1] = au_readl(host->iobase + SD_RESP2);
-			r[2] = au_readl(host->iobase + SD_RESP1);
-			r[3] = au_readl(host->iobase + SD_RESP0);
+			r[0] = __raw_readl(host->iobase + SD_RESP3);
+			r[1] = __raw_readl(host->iobase + SD_RESP2);
+			r[2] = __raw_readl(host->iobase + SD_RESP1);
+			r[3] = __raw_readl(host->iobase + SD_RESP0);
 
 			/* The CRC is omitted from the response, so really
 			 * we only got 120 bytes, but the engine expects
@@ -559,7 +560,7 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 			 * that means that the OSR data starts at bit 31,
 			 * so we can just read RESP0 and return that.
 			 */
-			cmd->resp[0] = au_readl(host->iobase + SD_RESP0);
+			cmd->resp[0] = __raw_readl(host->iobase + SD_RESP0);
 		}
 	}
 
@@ -586,7 +587,7 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 			u32 mask = SD_STATUS_DB | SD_STATUS_NE;
 
 			while((status & mask) != mask)
-				status = au_readl(HOST_STATUS(host));
+				status = __raw_readl(HOST_STATUS(host));
 		}
 
 		au1xxx_dbdma_start(channel);
@@ -602,17 +603,17 @@ static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 	/* From databook:
 	 * divisor = ((((cpuclock / sbus_divisor) / 2) / mmcclock) / 2) - 1
 	 */
-	pbus /= ((au_readl(SYS_POWERCTRL) & 0x3) + 2);
+	pbus /= ((AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 0x3) + 2);
 	pbus /= 2;
 	divisor = ((pbus / rate) / 2) - 1;
 
-	config = au_readl(HOST_CONFIG(host));
+	config = __raw_readl(HOST_CONFIG(host));
 
 	config &= ~(SD_CONFIG_DIV);
 	config |= (divisor & SD_CONFIG_DIV) | SD_CONFIG_DE;
 
-	au_writel(config, HOST_CONFIG(host));
-	au_sync();
+	__raw_writel(config, HOST_CONFIG(host));
+	wmb();
 }
 
 static int au1xmmc_prepare_data(struct au1xmmc_host *host,
@@ -636,7 +637,7 @@ static int au1xmmc_prepare_data(struct au1xmmc_host *host,
 	if (host->dma.len == 0)
 		return -ETIMEDOUT;
 
-	au_writel(data->blksz - 1, HOST_BLKSIZE(host));
+	__raw_writel(data->blksz - 1, HOST_BLKSIZE(host));
 
 	if (host->flags & (HOST_F_DMA | HOST_F_DBDMA)) {
 		int i;
@@ -723,31 +724,34 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 {
 	/* Apply the clock */
-	au_writel(SD_ENABLE_CE, HOST_ENABLE(host));
-        au_sync_delay(1);
+	__raw_writel(SD_ENABLE_CE, HOST_ENABLE(host));
+	wmb();
+	mdelay(1);
 
-	au_writel(SD_ENABLE_R | SD_ENABLE_CE, HOST_ENABLE(host));
-	au_sync_delay(5);
+	__raw_writel(SD_ENABLE_R | SD_ENABLE_CE, HOST_ENABLE(host));
+	wmb();
+	mdelay(5);
 
-	au_writel(~0, HOST_STATUS(host));
-	au_sync();
+	__raw_writel(~0, HOST_STATUS(host));
+	wmb();
 
-	au_writel(0, HOST_BLKSIZE(host));
-	au_writel(0x001fffff, HOST_TIMEOUT(host));
-	au_sync();
+	__raw_writel(0, HOST_BLKSIZE(host));
+	__raw_writel(0x001fffff, HOST_TIMEOUT(host));
+	wmb();
 
-	au_writel(SD_CONFIG2_EN, HOST_CONFIG2(host));
-        au_sync();
+	__raw_writel(SD_CONFIG2_EN, HOST_CONFIG2(host));
+	wmb();
 
-	au_writel(SD_CONFIG2_EN | SD_CONFIG2_FF, HOST_CONFIG2(host));
-	au_sync_delay(1);
+	__raw_writel(SD_CONFIG2_EN | SD_CONFIG2_FF, HOST_CONFIG2(host));
+	wmb();
+	mdelay(1);
 
-	au_writel(SD_CONFIG2_EN, HOST_CONFIG2(host));
-	au_sync();
+	__raw_writel(SD_CONFIG2_EN, HOST_CONFIG2(host));
+	wmb();
 
 	/* Configure interrupts */
-	au_writel(AU1XMMC_INTERRUPTS, HOST_CONFIG(host));
-	au_sync();
+	__raw_writel(AU1XMMC_INTERRUPTS, HOST_CONFIG(host));
+	wmb();
 }
 
 
@@ -767,7 +771,7 @@ static void au1xmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->clock = ios->clock;
 	}
 
-	config2 = au_readl(HOST_CONFIG2(host));
+	config2 = __raw_readl(HOST_CONFIG2(host));
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_8:
 		config2 |= SD_CONFIG2_BB;
@@ -780,8 +784,8 @@ static void au1xmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		config2 &= ~(SD_CONFIG2_WB | SD_CONFIG2_BB);
 		break;
 	}
-	au_writel(config2, HOST_CONFIG2(host));
-	au_sync();
+	__raw_writel(config2, HOST_CONFIG2(host));
+	wmb();
 }
 
 #define STATUS_TIMEOUT (SD_STATUS_RAT | SD_STATUS_DT)
@@ -793,7 +797,7 @@ static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 	struct au1xmmc_host *host = dev_id;
 	u32 status;
 
-	status = au_readl(HOST_STATUS(host));
+	status = __raw_readl(HOST_STATUS(host));
 
 	if (!(status & SD_STATUS_I))
 		return IRQ_NONE;	/* not ours */
@@ -839,8 +843,8 @@ static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 				status);
 	}
 
-	au_writel(status, HOST_STATUS(host));
-	au_sync();
+	__raw_writel(status, HOST_STATUS(host));
+	wmb();
 
 	return IRQ_HANDLED;
 }
@@ -976,7 +980,7 @@ static int au1xmmc_probe(struct platform_device *pdev)
 		goto out1;
 	}
 
-	host->iobase = (unsigned long)ioremap(r->start, 0x3c);
+	host->iobase = ioremap(r->start, 0x3c);
 	if (!host->iobase) {
 		dev_err(&pdev->dev, "cannot remap mmio\n");
 		goto out2;
@@ -1075,7 +1079,7 @@ static int au1xmmc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, host);
 
-	pr_info(DRIVER_NAME ": MMC Controller %d set up at %8.8X"
+	pr_info(DRIVER_NAME ": MMC Controller %d set up at %p"
 		" (mode=%s)\n", pdev->id, host->iobase,
 		host->flags & HOST_F_DMA ? "dma" : "pio");
 
@@ -1087,10 +1091,10 @@ out6:
 		led_classdev_unregister(host->platdata->led);
 out5:
 #endif
-	au_writel(0, HOST_ENABLE(host));
-	au_writel(0, HOST_CONFIG(host));
-	au_writel(0, HOST_CONFIG2(host));
-	au_sync();
+	__raw_writel(0, HOST_ENABLE(host));
+	__raw_writel(0, HOST_CONFIG(host));
+	__raw_writel(0, HOST_CONFIG2(host));
+	wmb();
 
 	if (host->flags & HOST_F_DBDMA)
 		au1xmmc_dbdma_shutdown(host);
@@ -1130,10 +1134,10 @@ static int au1xmmc_remove(struct platform_device *pdev)
 		    !(host->mmc->caps & MMC_CAP_NEEDS_POLL))
 			host->platdata->cd_setup(host->mmc, 0);
 
-		au_writel(0, HOST_ENABLE(host));
-		au_writel(0, HOST_CONFIG(host));
-		au_writel(0, HOST_CONFIG2(host));
-		au_sync();
+		__raw_writel(0, HOST_ENABLE(host));
+		__raw_writel(0, HOST_CONFIG(host));
+		__raw_writel(0, HOST_CONFIG2(host));
+		wmb();
 
 		tasklet_kill(&host->data_task);
 		tasklet_kill(&host->finish_task);
@@ -1158,11 +1162,11 @@ static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct au1xmmc_host *host = platform_get_drvdata(pdev);
 
-	au_writel(0, HOST_CONFIG2(host));
-	au_writel(0, HOST_CONFIG(host));
-	au_writel(0xffffffff, HOST_STATUS(host));
-	au_writel(0, HOST_ENABLE(host));
-	au_sync();
+	__raw_writel(0, HOST_CONFIG2(host));
+	__raw_writel(0, HOST_CONFIG(host));
+	__raw_writel(0xffffffff, HOST_STATUS(host));
+	__raw_writel(0, HOST_ENABLE(host));
+	wmb();
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index bc5c518..98f3167 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -31,6 +31,22 @@ struct au1550nd_ctx {
 	void (*write_byte)(struct mtd_info *, u_char);
 };
 
+
+static inline unsigned long AU1X_RDMST(unsigned long ofs)
+{
+	void __iomem *b = (void __iomem *)
+			KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	return __raw_readl(b + ofs);
+}
+
+static inline void AU1X_WRMST(unsigned long d, unsigned long ofs)
+{
+	void __iomem *b = (void __iomem *)
+			KSEG1ADDR(AU1000_STATIC_MEM_PHYS_ADDR);
+	__raw_writel(d, b + ofs);
+}
+
+
 /**
  * au_read_byte -  read one byte from the chip
  * @mtd:	MTD device structure
@@ -41,7 +57,7 @@ static u_char au_read_byte(struct mtd_info *mtd)
 {
 	struct nand_chip *this = mtd->priv;
 	u_char ret = readb(this->IO_ADDR_R);
-	au_sync();
+	wmb();
 	return ret;
 }
 
@@ -56,7 +72,7 @@ static void au_write_byte(struct mtd_info *mtd, u_char byte)
 {
 	struct nand_chip *this = mtd->priv;
 	writeb(byte, this->IO_ADDR_W);
-	au_sync();
+	wmb();
 }
 
 /**
@@ -69,7 +85,7 @@ static u_char au_read_byte16(struct mtd_info *mtd)
 {
 	struct nand_chip *this = mtd->priv;
 	u_char ret = (u_char) cpu_to_le16(readw(this->IO_ADDR_R));
-	au_sync();
+	wmb();
 	return ret;
 }
 
@@ -84,7 +100,7 @@ static void au_write_byte16(struct mtd_info *mtd, u_char byte)
 {
 	struct nand_chip *this = mtd->priv;
 	writew(le16_to_cpu((u16) byte), this->IO_ADDR_W);
-	au_sync();
+	wmb();
 }
 
 /**
@@ -97,7 +113,7 @@ static u16 au_read_word(struct mtd_info *mtd)
 {
 	struct nand_chip *this = mtd->priv;
 	u16 ret = readw(this->IO_ADDR_R);
-	au_sync();
+	wmb();
 	return ret;
 }
 
@@ -116,7 +132,7 @@ static void au_write_buf(struct mtd_info *mtd, const u_char *buf, int len)
 
 	for (i = 0; i < len; i++) {
 		writeb(buf[i], this->IO_ADDR_W);
-		au_sync();
+		wmb();
 	}
 }
 
@@ -135,7 +151,7 @@ static void au_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 
 	for (i = 0; i < len; i++) {
 		buf[i] = readb(this->IO_ADDR_R);
-		au_sync();
+		wmb();
 	}
 }
 
@@ -156,7 +172,7 @@ static void au_write_buf16(struct mtd_info *mtd, const u_char *buf, int len)
 
 	for (i = 0; i < len; i++) {
 		writew(p[i], this->IO_ADDR_W);
-		au_sync();
+		wmb();
 	}
 
 }
@@ -178,7 +194,7 @@ static void au_read_buf16(struct mtd_info *mtd, u_char *buf, int len)
 
 	for (i = 0; i < len; i++) {
 		p[i] = readw(this->IO_ADDR_R);
-		au_sync();
+		wmb();
 	}
 }
 
@@ -203,19 +219,19 @@ static void au1550_hwcontrol(struct mtd_info *mtd, int cmd)
 	switch (cmd) {
 
 	case NAND_CTL_SETCLE:
-		this->IO_ADDR_W = ctx->base + MEM_STNAND_CMD;
+		this->IO_ADDR_W = ctx->base + AU1000_MEM_STNAND_CMD;
 		break;
 
 	case NAND_CTL_CLRCLE:
-		this->IO_ADDR_W = ctx->base + MEM_STNAND_DATA;
+		this->IO_ADDR_W = ctx->base + AU1000_MEM_STNAND_DATA;
 		break;
 
 	case NAND_CTL_SETALE:
-		this->IO_ADDR_W = ctx->base + MEM_STNAND_ADDR;
+		this->IO_ADDR_W = ctx->base + AU1000_MEM_STNAND_ADDR;
 		break;
 
 	case NAND_CTL_CLRALE:
-		this->IO_ADDR_W = ctx->base + MEM_STNAND_DATA;
+		this->IO_ADDR_W = ctx->base + AU1000_MEM_STNAND_DATA;
 		/* FIXME: Nobody knows why this is necessary,
 		 * but it works only that way */
 		udelay(1);
@@ -223,25 +239,25 @@ static void au1550_hwcontrol(struct mtd_info *mtd, int cmd)
 
 	case NAND_CTL_SETNCE:
 		/* assert (force assert) chip enable */
-		au_writel((1 << (4 + ctx->cs)), MEM_STNDCTL);
+		AU1X_WRMST((1 << (4 + ctx->cs)), AU1000_MEM_STNDCTL);
 		break;
 
 	case NAND_CTL_CLRNCE:
 		/* deassert chip enable */
-		au_writel(0, MEM_STNDCTL);
+		AU1X_WRMST(0, AU1000_MEM_STNDCTL);
 		break;
 	}
 
 	this->IO_ADDR_R = this->IO_ADDR_W;
 
 	/* Drain the writebuffer */
-	au_sync();
+	wmb();
 }
 
 int au1550_device_ready(struct mtd_info *mtd)
 {
-	int ret = (au_readl(MEM_STSTAT) & 0x1) ? 1 : 0;
-	au_sync();
+	int ret = (AU1X_RDMST(AU1000_MEM_STSTAT) & 0x1) ? 1 : 0;
+	wmb();
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index a78e4c1..5682839 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -89,6 +89,130 @@ MODULE_DESCRIPTION(DRV_DESC);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
+/* Ethernet MAC registers offsets and bits */
+#define MAC_CONTROL		0x0
+#  define MAC_RX_ENABLE		(1 << 2)
+#  define MAC_TX_ENABLE		(1 << 3)
+#  define MAC_DEF_CHECK		(1 << 5)
+#  define MAC_SET_BL(X)		(((X) & 0x3) << 6)
+#  define MAC_AUTO_PAD		(1 << 8)
+#  define MAC_DISABLE_RETRY	(1 << 10)
+#  define MAC_DISABLE_BCAST	(1 << 11)
+#  define MAC_LATE_COL		(1 << 12)
+#  define MAC_HASH_MODE		(1 << 13)
+#  define MAC_HASH_ONLY		(1 << 15)
+#  define MAC_PASS_ALL		(1 << 16)
+#  define MAC_INVERSE_FILTER	(1 << 17)
+#  define MAC_PROMISCUOUS	(1 << 18)
+#  define MAC_PASS_ALL_MULTI	(1 << 19)
+#  define MAC_FULL_DUPLEX	(1 << 20)
+#  define MAC_NORMAL_MODE	0
+#  define MAC_INT_LOOPBACK	(1 << 21)
+#  define MAC_EXT_LOOPBACK	(1 << 22)
+#  define MAC_DISABLE_RX_OWN	(1 << 23)
+#  define MAC_BIG_ENDIAN	(1 << 30)
+#  define MAC_RX_ALL		(1 << 31)
+#define MAC_ADDRESS_HIGH	0x4
+#define MAC_ADDRESS_LOW		0x8
+#define MAC_MCAST_HIGH		0xC
+#define MAC_MCAST_LOW		0x10
+#define MAC_MII_CNTRL		0x14
+#  define MAC_MII_BUSY		(1 << 0)
+#  define MAC_MII_READ		0
+#  define MAC_MII_WRITE		(1 << 1)
+#  define MAC_SET_MII_SELECT_REG(X) (((X) & 0x1f) << 6)
+#  define MAC_SET_MII_SELECT_PHY(X) (((X) & 0x1f) << 11)
+#define MAC_MII_DATA		0x18
+#define MAC_FLOW_CNTRL		0x1C
+#  define MAC_FLOW_CNTRL_BUSY	(1 << 0)
+#  define MAC_FLOW_CNTRL_ENABLE (1 << 1)
+#  define MAC_PASS_CONTROL	(1 << 2)
+#  define MAC_SET_PAUSE(X)	(((X) & 0xffff) << 16)
+#define MAC_VLAN1_TAG		0x20
+#define MAC_VLAN2_TAG		0x24
+
+/* Ethernet Controller Enable */
+
+#  define MAC_EN_CLOCK_ENABLE	(1 << 0)
+#  define MAC_EN_RESET0		(1 << 1)
+#  define MAC_EN_TOSS		(0 << 2)
+#  define MAC_EN_CACHEABLE	(1 << 3)
+#  define MAC_EN_RESET1		(1 << 4)
+#  define MAC_EN_RESET2		(1 << 5)
+#  define MAC_DMA_RESET		(1 << 6)
+
+/* Ethernet Controller DMA Channels */
+#define MAC0_TX_DMA_ADDR	0xB4004000
+#define MAC1_TX_DMA_ADDR	0xB4004200
+/* offsets from MAC_TX_RING_ADDR address */
+#define MAC_TX_BUFF0_STATUS	0x0
+#  define TX_FRAME_ABORTED	(1 << 0)
+#  define TX_JAB_TIMEOUT	(1 << 1)
+#  define TX_NO_CARRIER		(1 << 2)
+#  define TX_LOSS_CARRIER	(1 << 3)
+#  define TX_EXC_DEF		(1 << 4)
+#  define TX_LATE_COLL_ABORT	(1 << 5)
+#  define TX_EXC_COLL		(1 << 6)
+#  define TX_UNDERRUN		(1 << 7)
+#  define TX_DEFERRED		(1 << 8)
+#  define TX_LATE_COLL		(1 << 9)
+#  define TX_COLL_CNT_MASK	(0xF << 10)
+#  define TX_PKT_RETRY		(1 << 31)
+#define MAC_TX_BUFF0_ADDR	0x4
+#  define TX_DMA_ENABLE		(1 << 0)
+#  define TX_T_DONE		(1 << 1)
+#  define TX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
+#define MAC_TX_BUFF0_LEN	0x8
+#define MAC_TX_BUFF1_STATUS	0x10
+#define MAC_TX_BUFF1_ADDR	0x14
+#define MAC_TX_BUFF1_LEN	0x18
+#define MAC_TX_BUFF2_STATUS	0x20
+#define MAC_TX_BUFF2_ADDR	0x24
+#define MAC_TX_BUFF2_LEN	0x28
+#define MAC_TX_BUFF3_STATUS	0x30
+#define MAC_TX_BUFF3_ADDR	0x34
+#define MAC_TX_BUFF3_LEN	0x38
+
+#define MAC0_RX_DMA_ADDR	0xB4004100
+#define MAC1_RX_DMA_ADDR	0xB4004300
+/* offsets from MAC_RX_RING_ADDR */
+#define MAC_RX_BUFF0_STATUS	0x0
+#  define RX_FRAME_LEN_MASK	0x3fff
+#  define RX_WDOG_TIMER		(1 << 14)
+#  define RX_RUNT		(1 << 15)
+#  define RX_OVERLEN		(1 << 16)
+#  define RX_COLL		(1 << 17)
+#  define RX_ETHER		(1 << 18)
+#  define RX_MII_ERROR		(1 << 19)
+#  define RX_DRIBBLING		(1 << 20)
+#  define RX_CRC_ERROR		(1 << 21)
+#  define RX_VLAN1		(1 << 22)
+#  define RX_VLAN2		(1 << 23)
+#  define RX_LEN_ERROR		(1 << 24)
+#  define RX_CNTRL_FRAME	(1 << 25)
+#  define RX_U_CNTRL_FRAME	(1 << 26)
+#  define RX_MCAST_FRAME	(1 << 27)
+#  define RX_BCAST_FRAME	(1 << 28)
+#  define RX_FILTER_FAIL	(1 << 29)
+#  define RX_PACKET_FILTER	(1 << 30)
+#  define RX_MISSED_FRAME	(1 << 31)
+
+#  define RX_ERROR (RX_WDOG_TIMER | RX_RUNT | RX_OVERLEN |  \
+		    RX_COLL | RX_MII_ERROR | RX_CRC_ERROR | \
+		    RX_LEN_ERROR | RX_U_CNTRL_FRAME | RX_MISSED_FRAME)
+#define MAC_RX_BUFF0_ADDR	0x4
+#  define RX_DMA_ENABLE		(1 << 0)
+#  define RX_T_DONE		(1 << 1)
+#  define RX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
+#  define RX_SET_BUFF_ADDR(X)	((X) & 0xffffffc0)
+#define MAC_RX_BUFF1_STATUS	0x10
+#define MAC_RX_BUFF1_ADDR	0x14
+#define MAC_RX_BUFF2_STATUS	0x20
+#define MAC_RX_BUFF2_ADDR	0x24
+#define MAC_RX_BUFF3_STATUS	0x30
+#define MAC_RX_BUFF3_ADDR	0x34
+
+
 /*
  * Theory of operation
  *
@@ -152,10 +276,12 @@ static void au1000_enable_mac(struct net_device *dev, int force_reset)
 
 	if (force_reset || (!aup->mac_enabled)) {
 		writel(MAC_EN_CLOCK_ENABLE, aup->enable);
-		au_sync_delay(2);
+		wmb();
+		mdelay(2);
 		writel((MAC_EN_RESET0 | MAC_EN_RESET1 | MAC_EN_RESET2
 				| MAC_EN_CLOCK_ENABLE), aup->enable);
-		au_sync_delay(2);
+		wmb();
+		mdelay(2);
 
 		aup->mac_enabled = 1;
 	}
@@ -273,7 +399,8 @@ static void au1000_hard_stop(struct net_device *dev)
 	reg = readl(&aup->mac->control);
 	reg &= ~(MAC_RX_ENABLE | MAC_TX_ENABLE);
 	writel(reg, &aup->mac->control);
-	au_sync_delay(10);
+	wmb();
+	mdelay(10);
 }
 
 static void au1000_enable_rx_tx(struct net_device *dev)
@@ -286,7 +413,8 @@ static void au1000_enable_rx_tx(struct net_device *dev)
 	reg = readl(&aup->mac->control);
 	reg |= (MAC_RX_ENABLE | MAC_TX_ENABLE);
 	writel(reg, &aup->mac->control);
-	au_sync_delay(10);
+	wmb();
+	mdelay(10);
 }
 
 static void
@@ -336,7 +464,8 @@ au1000_adjust_link(struct net_device *dev)
 			reg |= MAC_DISABLE_RX_OWN;
 		}
 		writel(reg, &aup->mac->control);
-		au_sync_delay(1);
+		wmb();
+		mdelay(1);
 
 		au1000_enable_rx_tx(dev);
 		aup->old_duplex = phydev->duplex;
@@ -500,9 +629,11 @@ static void au1000_reset_mac_unlocked(struct net_device *dev)
 	au1000_hard_stop(dev);
 
 	writel(MAC_EN_CLOCK_ENABLE, aup->enable);
-	au_sync_delay(2);
+	wmb();
+	mdelay(2);
 	writel(0, aup->enable);
-	au_sync_delay(2);
+	wmb();
+	mdelay(2);
 
 	aup->tx_full = 0;
 	for (i = 0; i < NUM_RX_DMA; i++) {
@@ -652,7 +783,7 @@ static int au1000_init(struct net_device *dev)
 	for (i = 0; i < NUM_RX_DMA; i++)
 		aup->rx_dma_ring[i]->buff_stat |= RX_DMA_ENABLE;
 
-	au_sync();
+	wmb();
 
 	control = MAC_RX_ENABLE | MAC_TX_ENABLE;
 #ifndef CONFIG_CPU_LITTLE_ENDIAN
@@ -669,7 +800,7 @@ static int au1000_init(struct net_device *dev)
 
 	writel(control, &aup->mac->control);
 	writel(0x8100, &aup->mac->vlan1_tag); /* activate vlan support */
-	au_sync();
+	wmb();
 
 	spin_unlock_irqrestore(&aup->lock, flags);
 	return 0;
@@ -760,7 +891,7 @@ static int au1000_rx(struct net_device *dev)
 		}
 		prxd->buff_stat = (u32)(pDB->dma_addr | RX_DMA_ENABLE);
 		aup->rx_head = (aup->rx_head + 1) & (NUM_RX_DMA - 1);
-		au_sync();
+		wmb();
 
 		/* next descriptor */
 		prxd = aup->rx_dma_ring[aup->rx_head];
@@ -808,7 +939,7 @@ static void au1000_tx_ack(struct net_device *dev)
 		au1000_update_tx_stats(dev, ptxd->status);
 		ptxd->buff_stat &= ~TX_T_DONE;
 		ptxd->len = 0;
-		au_sync();
+		wmb();
 
 		aup->tx_tail = (aup->tx_tail + 1) & (NUM_TX_DMA - 1);
 		ptxd = aup->tx_dma_ring[aup->tx_tail];
@@ -939,7 +1070,7 @@ static netdev_tx_t au1000_tx(struct sk_buff *skb, struct net_device *dev)
 	ps->tx_bytes += ptxd->len;
 
 	ptxd->buff_stat = pDB->dma_addr | TX_DMA_ENABLE;
-	au_sync();
+	wmb();
 	dev_kfree_skb(skb);
 	aup->tx_head = (aup->tx_head + 1) & (NUM_TX_DMA - 1);
 	return NETDEV_TX_OK;
diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index ed526a1..52f14c9 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -32,7 +32,7 @@ static int au1xtoy_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned long t;
 
-	t = au_readl(SYS_TOYREAD);
+	t = AU1X_RDSYS(AU1000_SYS_TOYREAD);
 
 	rtc_time_to_tm(t, tm);
 
@@ -45,13 +45,12 @@ static int au1xtoy_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	rtc_tm_to_time(tm, &t);
 
-	au_writel(t, SYS_TOYWRITE);
-	au_sync();
+	AU1X_WRSYS(t, AU1000_SYS_TOYWRITE);
 
 	/* wait for the pending register write to succeed.  This can
 	 * take up to 6 seconds...
 	 */
-	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C0S)
+	while (AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_C0S)
 		msleep(1);
 
 	return 0;
@@ -68,7 +67,7 @@ static int au1xtoy_rtc_probe(struct platform_device *pdev)
 	unsigned long t;
 	int ret;
 
-	t = au_readl(SYS_COUNTER_CNTRL);
+	t = AU1X_RDSYS(AU1000_SYS_CNTRCTRL);
 	if (!(t & CNTR_OK)) {
 		dev_err(&pdev->dev, "counters not working; aborting.\n");
 		ret = -ENODEV;
@@ -78,10 +77,10 @@ static int au1xtoy_rtc_probe(struct platform_device *pdev)
 	ret = -ETIMEDOUT;
 
 	/* set counter0 tickrate to 1Hz if necessary */
-	if (au_readl(SYS_TOYTRIM) != 32767) {
+	if (AU1X_RDSYS(AU1000_SYS_TOYTRIM) != 32767) {
 		/* wait until hardware gives access to TRIM register */
 		t = 0x00100000;
-		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && --t)
+		while ((AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_T0S) && --t)
 			msleep(1);
 
 		if (!t) {
@@ -93,12 +92,11 @@ static int au1xtoy_rtc_probe(struct platform_device *pdev)
 		}
 
 		/* set 1Hz TOY tick rate */
-		au_writel(32767, SYS_TOYTRIM);
-		au_sync();
+		AU1X_WRSYS(32767, AU1000_SYS_TOYTRIM);
 	}
 
 	/* wait until the hardware allows writes to the counter reg */
-	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C0S)
+	while (AU1X_RDSYS(AU1000_SYS_CNTRCTRL) & SYS_CNTRL_C0S)
 		msleep(1);
 
 	rtcdev = devm_rtc_device_register(&pdev->dev, "rtc-au1xxx",
diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index 67375a1..df97e0a 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -141,13 +141,13 @@ static inline void au1550_spi_mask_ack_all(struct au1550_spi *hw)
 		  PSC_SPIMSK_MM | PSC_SPIMSK_RR | PSC_SPIMSK_RO
 		| PSC_SPIMSK_RU | PSC_SPIMSK_TR | PSC_SPIMSK_TO
 		| PSC_SPIMSK_TU | PSC_SPIMSK_SD | PSC_SPIMSK_MD;
-	au_sync();
+	wmb();
 
 	hw->regs->psc_spievent =
 		  PSC_SPIEVNT_MM | PSC_SPIEVNT_RR | PSC_SPIEVNT_RO
 		| PSC_SPIEVNT_RU | PSC_SPIEVNT_TR | PSC_SPIEVNT_TO
 		| PSC_SPIEVNT_TU | PSC_SPIEVNT_SD | PSC_SPIEVNT_MD;
-	au_sync();
+	wmb();
 }
 
 static void au1550_spi_reset_fifos(struct au1550_spi *hw)
@@ -155,10 +155,10 @@ static void au1550_spi_reset_fifos(struct au1550_spi *hw)
 	u32 pcr;
 
 	hw->regs->psc_spipcr = PSC_SPIPCR_RC | PSC_SPIPCR_TC;
-	au_sync();
+	wmb();
 	do {
 		pcr = hw->regs->psc_spipcr;
-		au_sync();
+		wmb();
 	} while (pcr != 0);
 }
 
@@ -188,9 +188,9 @@ static void au1550_spi_chipsel(struct spi_device *spi, int value)
 		au1550_spi_bits_handlers_set(hw, spi->bits_per_word);
 
 		cfg = hw->regs->psc_spicfg;
-		au_sync();
+		wmb();
 		hw->regs->psc_spicfg = cfg & ~PSC_SPICFG_DE_ENABLE;
-		au_sync();
+		wmb();
 
 		if (spi->mode & SPI_CPOL)
 			cfg |= PSC_SPICFG_BI;
@@ -218,10 +218,10 @@ static void au1550_spi_chipsel(struct spi_device *spi, int value)
 		cfg |= au1550_spi_baudcfg(hw, spi->max_speed_hz);
 
 		hw->regs->psc_spicfg = cfg | PSC_SPICFG_DE_ENABLE;
-		au_sync();
+		wmb();
 		do {
 			stat = hw->regs->psc_spistat;
-			au_sync();
+			wmb();
 		} while ((stat & PSC_SPISTAT_DR) == 0);
 
 		if (hw->pdata->activate_cs)
@@ -252,9 +252,9 @@ static int au1550_spi_setupxfer(struct spi_device *spi, struct spi_transfer *t)
 	au1550_spi_bits_handlers_set(hw, spi->bits_per_word);
 
 	cfg = hw->regs->psc_spicfg;
-	au_sync();
+	wmb();
 	hw->regs->psc_spicfg = cfg & ~PSC_SPICFG_DE_ENABLE;
-	au_sync();
+	wmb();
 
 	if (hw->usedma && bpw <= 8)
 		cfg &= ~PSC_SPICFG_DD_DISABLE;
@@ -268,12 +268,12 @@ static int au1550_spi_setupxfer(struct spi_device *spi, struct spi_transfer *t)
 	cfg |= au1550_spi_baudcfg(hw, hz);
 
 	hw->regs->psc_spicfg = cfg;
-	au_sync();
+	wmb();
 
 	if (cfg & PSC_SPICFG_DE_ENABLE) {
 		do {
 			stat = hw->regs->psc_spistat;
-			au_sync();
+			wmb();
 		} while ((stat & PSC_SPISTAT_DR) == 0);
 	}
 
@@ -396,11 +396,11 @@ static int au1550_spi_dma_txrxb(struct spi_device *spi, struct spi_transfer *t)
 
 	/* by default enable nearly all events interrupt */
 	hw->regs->psc_spimsk = PSC_SPIMSK_SD;
-	au_sync();
+	wmb();
 
 	/* start the transfer */
 	hw->regs->psc_spipcr = PSC_SPIPCR_MS;
-	au_sync();
+	wmb();
 
 	wait_for_completion(&hw->master_done);
 
@@ -429,7 +429,7 @@ static irqreturn_t au1550_spi_dma_irq_callback(struct au1550_spi *hw)
 
 	stat = hw->regs->psc_spistat;
 	evnt = hw->regs->psc_spievent;
-	au_sync();
+	wmb();
 	if ((stat & PSC_SPISTAT_DI) == 0) {
 		dev_err(hw->dev, "Unexpected IRQ!\n");
 		return IRQ_NONE;
@@ -484,7 +484,7 @@ static irqreturn_t au1550_spi_dma_irq_callback(struct au1550_spi *hw)
 static void au1550_spi_rx_word_##size(struct au1550_spi *hw)		\
 {									\
 	u32 fifoword = hw->regs->psc_spitxrx & (u32)(mask);		\
-	au_sync();							\
+	wmb();							\
 	if (hw->rx) {							\
 		*(u##size *)hw->rx = (u##size)fifoword;			\
 		hw->rx += (size) / 8;					\
@@ -504,7 +504,7 @@ static void au1550_spi_tx_word_##size(struct au1550_spi *hw)		\
 	if (hw->tx_count >= hw->len)					\
 		fifoword |= PSC_SPITXRX_LC;				\
 	hw->regs->psc_spitxrx = fifoword;				\
-	au_sync();							\
+	wmb();							\
 }
 
 AU1550_SPI_RX_WORD(8,0xff)
@@ -539,18 +539,18 @@ static int au1550_spi_pio_txrxb(struct spi_device *spi, struct spi_transfer *t)
 		}
 
 		stat = hw->regs->psc_spistat;
-		au_sync();
+		wmb();
 		if (stat & PSC_SPISTAT_TF)
 			break;
 	}
 
 	/* enable event interrupts */
 	hw->regs->psc_spimsk = mask;
-	au_sync();
+	wmb();
 
 	/* start the transfer */
 	hw->regs->psc_spipcr = PSC_SPIPCR_MS;
-	au_sync();
+	wmb();
 
 	wait_for_completion(&hw->master_done);
 
@@ -564,7 +564,7 @@ static irqreturn_t au1550_spi_pio_irq_callback(struct au1550_spi *hw)
 
 	stat = hw->regs->psc_spistat;
 	evnt = hw->regs->psc_spievent;
-	au_sync();
+	wmb();
 	if ((stat & PSC_SPISTAT_DI) == 0) {
 		dev_err(hw->dev, "Unexpected IRQ!\n");
 		return IRQ_NONE;
@@ -594,7 +594,7 @@ static irqreturn_t au1550_spi_pio_irq_callback(struct au1550_spi *hw)
 	do {
 		busy = 0;
 		stat = hw->regs->psc_spistat;
-		au_sync();
+		wmb();
 
 		/*
 		 * Take care to not let the Rx FIFO overflow.
@@ -615,7 +615,7 @@ static irqreturn_t au1550_spi_pio_irq_callback(struct au1550_spi *hw)
 	} while (busy);
 
 	hw->regs->psc_spievent = PSC_SPIEVNT_RR | PSC_SPIEVNT_TR;
-	au_sync();
+	wmb();
 
 	/*
 	 * Restart the SPI transmission in case of a transmit underflow.
@@ -634,9 +634,9 @@ static irqreturn_t au1550_spi_pio_irq_callback(struct au1550_spi *hw)
 	 */
 	if (evnt & PSC_SPIEVNT_TU) {
 		hw->regs->psc_spievent = PSC_SPIEVNT_TU | PSC_SPIEVNT_MD;
-		au_sync();
+		wmb();
 		hw->regs->psc_spipcr = PSC_SPIPCR_MS;
-		au_sync();
+		wmb();
 	}
 
 	if (hw->rx_count >= hw->len) {
@@ -690,19 +690,19 @@ static void au1550_spi_setup_psc_as_spi(struct au1550_spi *hw)
 
 	/* set up the PSC for SPI mode */
 	hw->regs->psc_ctrl = PSC_CTRL_DISABLE;
-	au_sync();
+	wmb();
 	hw->regs->psc_sel = PSC_SEL_PS_SPIMODE;
-	au_sync();
+	wmb();
 
 	hw->regs->psc_spicfg = 0;
-	au_sync();
+	wmb();
 
 	hw->regs->psc_ctrl = PSC_CTRL_ENABLE;
-	au_sync();
+	wmb();
 
 	do {
 		stat = hw->regs->psc_spistat;
-		au_sync();
+		wmb();
 	} while ((stat & PSC_SPISTAT_SR) == 0);
 
 
@@ -717,16 +717,16 @@ static void au1550_spi_setup_psc_as_spi(struct au1550_spi *hw)
 #endif
 
 	hw->regs->psc_spicfg = cfg;
-	au_sync();
+	wmb();
 
 	au1550_spi_mask_ack_all(hw);
 
 	hw->regs->psc_spicfg |= PSC_SPICFG_DE_ENABLE;
-	au_sync();
+	wmb();
 
 	do {
 		stat = hw->regs->psc_spistat;
-		au_sync();
+		wmb();
 	} while ((stat & PSC_SPISTAT_DR) == 0);
 
 	au1550_spi_reset_fifos(hw);
diff --git a/drivers/video/fbdev/au1100fb.c b/drivers/video/fbdev/au1100fb.c
index 372d4ae..2c2804b 100644
--- a/drivers/video/fbdev/au1100fb.c
+++ b/drivers/video/fbdev/au1100fb.c
@@ -113,7 +113,7 @@ static int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
 	case VESA_NO_BLANKING:
 		/* Turn on panel */
 		fbdev->regs->lcd_control |= LCD_CONTROL_GO;
-		au_sync();
+		wmb();
 		break;
 
 	case VESA_VSYNC_SUSPEND:
@@ -121,7 +121,7 @@ static int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
 	case VESA_POWERDOWN:
 		/* Turn off panel */
 		fbdev->regs->lcd_control &= ~LCD_CONTROL_GO;
-		au_sync();
+		wmb();
 		break;
 	default:
 		break;
@@ -507,8 +507,9 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	print_dbg("phys=0x%08x, size=%dK", fbdev->fb_phys, fbdev->fb_len / 1024);
 
 	/* Setup LCD clock to AUX (48 MHz) */
-	sys_clksrc = au_readl(SYS_CLKSRC) & ~(SYS_CS_ML_MASK | SYS_CS_DL | SYS_CS_CL);
-	au_writel((sys_clksrc | (1 << SYS_CS_ML_BIT)), SYS_CLKSRC);
+	sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC) &
+			~(SYS_CS_ML_MASK | SYS_CS_DL | SYS_CS_CL);
+	AU1X_WRSYS((sys_clksrc | (1 << SYS_CS_ML_BIT)), AU1000_SYS_CLKSRC);
 
 	/* load the panel info into the var struct */
 	au1100fb_var.bits_per_pixel = fbdev->panel->bpp;
@@ -591,13 +592,13 @@ int au1100fb_drv_suspend(struct platform_device *dev, pm_message_t state)
 		return 0;
 
 	/* Save the clock source state */
-	sys_clksrc = au_readl(SYS_CLKSRC);
+	sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC);
 
 	/* Blank the LCD */
 	au1100fb_fb_blank(VESA_POWERDOWN, &fbdev->info);
 
 	/* Stop LCD clocking */
-	au_writel(sys_clksrc & ~SYS_CS_ML_MASK, SYS_CLKSRC);
+	AU1X_WRSYS(sys_clksrc & ~SYS_CS_ML_MASK, AU1000_SYS_CLKSRC);
 
 	memcpy(&fbregs, fbdev->regs, sizeof(struct au1100fb_regs));
 
@@ -614,7 +615,7 @@ int au1100fb_drv_resume(struct platform_device *dev)
 	memcpy(fbdev->regs, &fbregs, sizeof(struct au1100fb_regs));
 
 	/* Restart LCD clocking */
-	au_writel(sys_clksrc, SYS_CLKSRC);
+	AU1X_WRSYS(sys_clksrc, AU1000_SYS_CLKSRC);
 
 	/* Unblank the LCD */
 	au1100fb_fb_blank(VESA_NO_BLANKING, &fbdev->info);
diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 4cfba78..230cfa8 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -764,7 +764,7 @@ static int au1200_setlocation (struct au1200fb_device *fbdev, int plane,
 
 	/* Disable the window while making changes, then restore WINEN */
 	winenable = lcd->winenable & (1 << plane);
-	au_sync();
+	wmb();
 	lcd->winenable &= ~(1 << plane);
 	lcd->window[plane].winctrl0 = winctrl0;
 	lcd->window[plane].winctrl1 = winctrl1;
@@ -772,7 +772,7 @@ static int au1200_setlocation (struct au1200fb_device *fbdev, int plane,
 	lcd->window[plane].winbuf1 = fbdev->fb_phys;
 	lcd->window[plane].winbufctrl = 0; /* select winbuf0 */
 	lcd->winenable |= winenable;
-	au_sync();
+	wmb();
 
 	return 0;
 }
@@ -788,7 +788,7 @@ static void au1200_setpanel(struct panel_settings *newpanel,
 	/* Make sure all windows disabled */
 	winenable = lcd->winenable;
 	lcd->winenable = 0;
-	au_sync();
+	wmb();
 	/*
 	 * Ensure everything is disabled before reconfiguring
 	 */
@@ -796,14 +796,14 @@ static void au1200_setpanel(struct panel_settings *newpanel,
 		/* Wait for vertical sync period */
 		lcd->intstatus = LCD_INT_SS;
 		while ((lcd->intstatus & LCD_INT_SS) == 0) {
-			au_sync();
+			wmb();
 		}
 
 		lcd->screen &= ~LCD_SCREEN_SEN;	/*disable the controller*/
 
 		do {
 			lcd->intstatus = lcd->intstatus; /*clear interrupts*/
-			au_sync();
+			wmb();
 		/*wait for controller to shut down*/
 		} while ((lcd->intstatus & LCD_INT_SD) == 0);
 
@@ -830,10 +830,10 @@ static void au1200_setpanel(struct panel_settings *newpanel,
 	if (!(panel->mode_clkcontrol & LCD_CLKCONTROL_EXT))
 	{
 		uint32 sys_clksrc;
-		au_writel(panel->mode_auxpll, SYS_AUXPLL);
-		sys_clksrc = au_readl(SYS_CLKSRC) & ~0x0000001f;
+		AU1X_WRSYS(panel->mode_auxpll, AU1000_SYS_AUXPLL);
+		sys_clksrc = AU1X_RDSYS(AU1000_SYS_CLKSRC) & ~0x0000001f;
 		sys_clksrc |= panel->mode_toyclksrc;
-		au_writel(sys_clksrc, SYS_CLKSRC);
+		AU1X_WRSYS(sys_clksrc, AU1000_SYS_CLKSRC);
 	}
 
 	/*
@@ -847,7 +847,7 @@ static void au1200_setpanel(struct panel_settings *newpanel,
 	lcd->pwmhi = panel->mode_pwmhi;
 	lcd->outmask = panel->mode_outmask;
 	lcd->fifoctrl = panel->mode_fifoctrl;
-	au_sync();
+	wmb();
 
 	/* fixme: Check window settings to make sure still valid
 	 * for new geometry */
@@ -863,7 +863,7 @@ static void au1200_setpanel(struct panel_settings *newpanel,
 	 * Re-enable screen now that it is configured
 	 */
 	lcd->screen |= LCD_SCREEN_SEN;
-	au_sync();
+	wmb();
 
 	/* Call init of panel */
 	if (pd->panel_init)
@@ -956,7 +956,7 @@ static void au1200_setmode(struct au1200fb_device *fbdev)
 		| LCD_WINCTRL2_SCY_1
 		) ;
 	lcd->winenable |= win->w[plane].mode_winenable;
-	au_sync();
+	wmb();
 }
 
 
@@ -1270,7 +1270,7 @@ static void set_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)
 
 	if (pdata->flags & SCREEN_MASK)
 		lcd->colorkeymsk = pdata->mask;
-	au_sync();
+	wmb();
 }
 
 static void get_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)
@@ -1288,7 +1288,7 @@ static void get_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)
 	hi1 = (lcd->pwmhi >> 16) + 1;
 	divider = (lcd->pwmdiv & 0x3FFFF) + 1;
 	pdata->brightness = ((hi1 << 8) / divider) - 1;
-	au_sync();
+	wmb();
 }
 
 static void set_window(unsigned int plane,
@@ -1387,7 +1387,7 @@ static void set_window(unsigned int plane,
 		val |= (pdata->enable & 1) << plane;
 		lcd->winenable = val;
 	}
-	au_sync();
+	wmb();
 }
 
 static void get_window(unsigned int plane,
@@ -1414,7 +1414,7 @@ static void get_window(unsigned int plane,
 	pdata->ram_array_mode = (lcd->window[plane].winctrl2 & LCD_WINCTRL2_RAM) >> 21;
 
 	pdata->enable = (lcd->winenable >> plane) & 1;
-	au_sync();
+	wmb();
 }
 
 static int au1200fb_ioctl(struct fb_info *info, unsigned int cmd,
@@ -1511,7 +1511,7 @@ static irqreturn_t au1200fb_handle_irq(int irq, void* dev_id)
 {
 	/* Nothing to do for now, just clear any pending interrupt */
 	lcd->intstatus = lcd->intstatus;
-	au_sync();
+	wmb();
 
 	return IRQ_HANDLED;
 }
@@ -1809,7 +1809,7 @@ static int au1200fb_drv_suspend(struct device *dev)
 	au1200_setpanel(NULL, pd);
 
 	lcd->outmask = 0;
-	au_sync();
+	wmb();
 
 	return 0;
 }
diff --git a/sound/soc/au1x/psc-ac97.c b/sound/soc/au1x/psc-ac97.c
index 986dcec..243c089 100644
--- a/sound/soc/au1x/psc-ac97.c
+++ b/sound/soc/au1x/psc-ac97.c
@@ -79,28 +79,28 @@ static unsigned short au1xpsc_ac97_read(struct snd_ac97 *ac97,
 	unsigned short retry, tmo;
 	unsigned long data;
 
-	au_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
-	au_sync();
+	__raw_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
+	wmb();
 
 	retry = AC97_RW_RETRIES;
 	do {
 		mutex_lock(&pscdata->lock);
 
-		au_writel(PSC_AC97CDC_RD | PSC_AC97CDC_INDX(reg),
+		__raw_writel(PSC_AC97CDC_RD | PSC_AC97CDC_INDX(reg),
 			  AC97_CDC(pscdata));
-		au_sync();
+		wmb();
 
 		tmo = 20;
 		do {
 			udelay(21);
-			if (au_readl(AC97_EVNT(pscdata)) & PSC_AC97EVNT_CD)
+			if (__raw_readl(AC97_EVNT(pscdata)) & PSC_AC97EVNT_CD)
 				break;
 		} while (--tmo);
 
-		data = au_readl(AC97_CDC(pscdata));
+		data = __raw_readl(AC97_CDC(pscdata));
 
-		au_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
-		au_sync();
+		__raw_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
+		wmb();
 
 		mutex_unlock(&pscdata->lock);
 
@@ -119,26 +119,26 @@ static void au1xpsc_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
 	struct au1xpsc_audio_data *pscdata = ac97_to_pscdata(ac97);
 	unsigned int tmo, retry;
 
-	au_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
-	au_sync();
+	__raw_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
+	wmb();
 
 	retry = AC97_RW_RETRIES;
 	do {
 		mutex_lock(&pscdata->lock);
 
-		au_writel(PSC_AC97CDC_INDX(reg) | (val & 0xffff),
+		__raw_writel(PSC_AC97CDC_INDX(reg) | (val & 0xffff),
 			  AC97_CDC(pscdata));
-		au_sync();
+		wmb();
 
 		tmo = 20;
 		do {
 			udelay(21);
-			if (au_readl(AC97_EVNT(pscdata)) & PSC_AC97EVNT_CD)
+			if (__raw_readl(AC97_EVNT(pscdata)) & PSC_AC97EVNT_CD)
 				break;
 		} while (--tmo);
 
-		au_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
-		au_sync();
+		__raw_writel(PSC_AC97EVNT_CD, AC97_EVNT(pscdata));
+		wmb();
 
 		mutex_unlock(&pscdata->lock);
 	} while (--retry && !tmo);
@@ -149,11 +149,11 @@ static void au1xpsc_ac97_warm_reset(struct snd_ac97 *ac97)
 {
 	struct au1xpsc_audio_data *pscdata = ac97_to_pscdata(ac97);
 
-	au_writel(PSC_AC97RST_SNC, AC97_RST(pscdata));
-	au_sync();
+	__raw_writel(PSC_AC97RST_SNC, AC97_RST(pscdata));
+	wmb();
 	msleep(10);
-	au_writel(0, AC97_RST(pscdata));
-	au_sync();
+	__raw_writel(0, AC97_RST(pscdata));
+	wmb();
 }
 
 static void au1xpsc_ac97_cold_reset(struct snd_ac97 *ac97)
@@ -162,25 +162,25 @@ static void au1xpsc_ac97_cold_reset(struct snd_ac97 *ac97)
 	int i;
 
 	/* disable PSC during cold reset */
-	au_writel(0, AC97_CFG(au1xpsc_ac97_workdata));
-	au_sync();
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(pscdata));
-	au_sync();
+	__raw_writel(0, AC97_CFG(au1xpsc_ac97_workdata));
+	wmb();
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(pscdata));
+	wmb();
 
 	/* issue cold reset */
-	au_writel(PSC_AC97RST_RST, AC97_RST(pscdata));
-	au_sync();
+	__raw_writel(PSC_AC97RST_RST, AC97_RST(pscdata));
+	wmb();
 	msleep(500);
-	au_writel(0, AC97_RST(pscdata));
-	au_sync();
+	__raw_writel(0, AC97_RST(pscdata));
+	wmb();
 
 	/* enable PSC */
-	au_writel(PSC_CTRL_ENABLE, PSC_CTRL(pscdata));
-	au_sync();
+	__raw_writel(PSC_CTRL_ENABLE, PSC_CTRL(pscdata));
+	wmb();
 
 	/* wait for PSC to indicate it's ready */
 	i = 1000;
-	while (!((au_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_SR)) && (--i))
+	while (!((__raw_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_SR)) && (--i))
 		msleep(1);
 
 	if (i == 0) {
@@ -189,12 +189,12 @@ static void au1xpsc_ac97_cold_reset(struct snd_ac97 *ac97)
 	}
 
 	/* enable the ac97 function */
-	au_writel(pscdata->cfg | PSC_AC97CFG_DE_ENABLE, AC97_CFG(pscdata));
-	au_sync();
+	__raw_writel(pscdata->cfg | PSC_AC97CFG_DE_ENABLE, AC97_CFG(pscdata));
+	wmb();
 
 	/* wait for AC97 core to become ready */
 	i = 1000;
-	while (!((au_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_DR)) && (--i))
+	while (!((__raw_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_DR)) && (--i))
 		msleep(1);
 	if (i == 0)
 		printk(KERN_ERR "au1xpsc-ac97: AC97 ctrl not ready\n");
@@ -218,8 +218,8 @@ static int au1xpsc_ac97_hw_params(struct snd_pcm_substream *substream,
 
 	chans = params_channels(params);
 
-	r = ro = au_readl(AC97_CFG(pscdata));
-	stat = au_readl(AC97_STAT(pscdata));
+	r = ro = __raw_readl(AC97_CFG(pscdata));
+	stat = __raw_readl(AC97_STAT(pscdata));
 
 	/* already active? */
 	if (stat & (PSC_AC97STAT_TB | PSC_AC97STAT_RB)) {
@@ -252,28 +252,28 @@ static int au1xpsc_ac97_hw_params(struct snd_pcm_substream *substream,
 		mutex_lock(&pscdata->lock);
 
 		/* disable AC97 device controller first... */
-		au_writel(r & ~PSC_AC97CFG_DE_ENABLE, AC97_CFG(pscdata));
-		au_sync();
+		__raw_writel(r & ~PSC_AC97CFG_DE_ENABLE, AC97_CFG(pscdata));
+		wmb();
 
 		/* ...wait for it... */
 		t = 100;
-		while ((au_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_DR) && --t)
+		while ((__raw_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_DR) && --t)
 			msleep(1);
 
 		if (!t)
 			printk(KERN_ERR "PSC-AC97: can't disable!\n");
 
 		/* ...write config... */
-		au_writel(r, AC97_CFG(pscdata));
-		au_sync();
+		__raw_writel(r, AC97_CFG(pscdata));
+		wmb();
 
 		/* ...enable the AC97 controller again... */
-		au_writel(r | PSC_AC97CFG_DE_ENABLE, AC97_CFG(pscdata));
-		au_sync();
+		__raw_writel(r | PSC_AC97CFG_DE_ENABLE, AC97_CFG(pscdata));
+		wmb();
 
 		/* ...and wait for ready bit */
 		t = 100;
-		while ((!(au_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_DR)) && --t)
+		while ((!(__raw_readl(AC97_STAT(pscdata)) & PSC_AC97STAT_DR)) && --t)
 			msleep(1);
 
 		if (!t)
@@ -300,21 +300,21 @@ static int au1xpsc_ac97_trigger(struct snd_pcm_substream *substream,
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
-		au_writel(AC97PCR_CLRFIFO(stype), AC97_PCR(pscdata));
-		au_sync();
-		au_writel(AC97PCR_START(stype), AC97_PCR(pscdata));
-		au_sync();
+		__raw_writel(AC97PCR_CLRFIFO(stype), AC97_PCR(pscdata));
+		wmb();
+		__raw_writel(AC97PCR_START(stype), AC97_PCR(pscdata));
+		wmb();
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-		au_writel(AC97PCR_STOP(stype), AC97_PCR(pscdata));
-		au_sync();
+		__raw_writel(AC97PCR_STOP(stype), AC97_PCR(pscdata));
+		wmb();
 
-		while (au_readl(AC97_STAT(pscdata)) & AC97STAT_BUSY(stype))
+		while (__raw_readl(AC97_STAT(pscdata)) & AC97STAT_BUSY(stype))
 			asm volatile ("nop");
 
-		au_writel(AC97PCR_CLRFIFO(stype), AC97_PCR(pscdata));
-		au_sync();
+		__raw_writel(AC97PCR_CLRFIFO(stype), AC97_PCR(pscdata));
+		wmb();
 
 		break;
 	default:
@@ -398,13 +398,13 @@ static int au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 		  PSC_AC97CFG_DE_ENABLE;
 
 	/* preserve PSC clock source set up by platform	 */
-	sel = au_readl(PSC_SEL(wd)) & PSC_SEL_CLK_MASK;
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
-	au_writel(0, PSC_SEL(wd));
-	au_sync();
-	au_writel(PSC_SEL_PS_AC97MODE | sel, PSC_SEL(wd));
-	au_sync();
+	sel = __raw_readl(PSC_SEL(wd)) & PSC_SEL_CLK_MASK;
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
+	__raw_writel(0, PSC_SEL(wd));
+	wmb();
+	__raw_writel(PSC_SEL_PS_AC97MODE | sel, PSC_SEL(wd));
+	wmb();
 
 	/* name the DAI like this device instance ("au1xpsc-ac97.PSCINDEX") */
 	memcpy(&wd->dai_drv, &au1xpsc_ac97_dai_template,
@@ -433,10 +433,10 @@ static int au1xpsc_ac97_drvremove(struct platform_device *pdev)
 	snd_soc_unregister_component(&pdev->dev);
 
 	/* disable PSC completely */
-	au_writel(0, AC97_CFG(wd));
-	au_sync();
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
+	__raw_writel(0, AC97_CFG(wd));
+	wmb();
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
 
 	au1xpsc_ac97_workdata = NULL;	/* MDEV */
 
@@ -449,12 +449,12 @@ static int au1xpsc_ac97_drvsuspend(struct device *dev)
 	struct au1xpsc_audio_data *wd = dev_get_drvdata(dev);
 
 	/* save interesting registers and disable PSC */
-	wd->pm[0] = au_readl(PSC_SEL(wd));
+	wd->pm[0] = __raw_readl(PSC_SEL(wd));
 
-	au_writel(0, AC97_CFG(wd));
-	au_sync();
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
+	__raw_writel(0, AC97_CFG(wd));
+	wmb();
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
 
 	return 0;
 }
@@ -464,8 +464,8 @@ static int au1xpsc_ac97_drvresume(struct device *dev)
 	struct au1xpsc_audio_data *wd = dev_get_drvdata(dev);
 
 	/* restore PSC clock config */
-	au_writel(wd->pm[0] | PSC_SEL_PS_AC97MODE, PSC_SEL(wd));
-	au_sync();
+	__raw_writel(wd->pm[0] | PSC_SEL_PS_AC97MODE, PSC_SEL(wd));
+	wmb();
 
 	/* after this point the ac97 core will cold-reset the codec.
 	 * During cold-reset the PSC is reinitialized and the last
diff --git a/sound/soc/au1x/psc-i2s.c b/sound/soc/au1x/psc-i2s.c
index fe923a7..879e983 100644
--- a/sound/soc/au1x/psc-i2s.c
+++ b/sound/soc/au1x/psc-i2s.c
@@ -120,10 +120,10 @@ static int au1xpsc_i2s_hw_params(struct snd_pcm_substream *substream,
 	unsigned long stat;
 
 	/* check if the PSC is already streaming data */
-	stat = au_readl(I2S_STAT(pscdata));
+	stat = __raw_readl(I2S_STAT(pscdata));
 	if (stat & (PSC_I2SSTAT_TB | PSC_I2SSTAT_RB)) {
 		/* reject parameters not currently set up in hardware */
-		cfgbits = au_readl(I2S_CFG(pscdata));
+		cfgbits = __raw_readl(I2S_CFG(pscdata));
 		if ((PSC_I2SCFG_GET_LEN(cfgbits) != params->msbits) ||
 		    (params_rate(params) != pscdata->rate))
 			return -EINVAL;
@@ -149,33 +149,33 @@ static int au1xpsc_i2s_configure(struct au1xpsc_audio_data *pscdata)
 	unsigned long tmo;
 
 	/* bring PSC out of sleep, and configure I2S unit */
-	au_writel(PSC_CTRL_ENABLE, PSC_CTRL(pscdata));
-	au_sync();
+	__raw_writel(PSC_CTRL_ENABLE, PSC_CTRL(pscdata));
+	wmb();
 
 	tmo = 1000000;
-	while (!(au_readl(I2S_STAT(pscdata)) & PSC_I2SSTAT_SR) && tmo)
+	while (!(__raw_readl(I2S_STAT(pscdata)) & PSC_I2SSTAT_SR) && tmo)
 		tmo--;
 
 	if (!tmo)
 		goto psc_err;
 
-	au_writel(0, I2S_CFG(pscdata));
-	au_sync();
-	au_writel(pscdata->cfg | PSC_I2SCFG_DE_ENABLE, I2S_CFG(pscdata));
-	au_sync();
+	__raw_writel(0, I2S_CFG(pscdata));
+	wmb();
+	__raw_writel(pscdata->cfg | PSC_I2SCFG_DE_ENABLE, I2S_CFG(pscdata));
+	wmb();
 
 	/* wait for I2S controller to become ready */
 	tmo = 1000000;
-	while (!(au_readl(I2S_STAT(pscdata)) & PSC_I2SSTAT_DR) && tmo)
+	while (!(__raw_readl(I2S_STAT(pscdata)) & PSC_I2SSTAT_DR) && tmo)
 		tmo--;
 
 	if (tmo)
 		return 0;
 
 psc_err:
-	au_writel(0, I2S_CFG(pscdata));
-	au_writel(PSC_CTRL_SUSPEND, PSC_CTRL(pscdata));
-	au_sync();
+	__raw_writel(0, I2S_CFG(pscdata));
+	__raw_writel(PSC_CTRL_SUSPEND, PSC_CTRL(pscdata));
+	wmb();
 	return -ETIMEDOUT;
 }
 
@@ -187,26 +187,26 @@ static int au1xpsc_i2s_start(struct au1xpsc_audio_data *pscdata, int stype)
 	ret = 0;
 
 	/* if both TX and RX are idle, configure the PSC  */
-	stat = au_readl(I2S_STAT(pscdata));
+	stat = __raw_readl(I2S_STAT(pscdata));
 	if (!(stat & (PSC_I2SSTAT_TB | PSC_I2SSTAT_RB))) {
 		ret = au1xpsc_i2s_configure(pscdata);
 		if (ret)
 			goto out;
 	}
 
-	au_writel(I2SPCR_CLRFIFO(stype), I2S_PCR(pscdata));
-	au_sync();
-	au_writel(I2SPCR_START(stype), I2S_PCR(pscdata));
-	au_sync();
+	__raw_writel(I2SPCR_CLRFIFO(stype), I2S_PCR(pscdata));
+	wmb();
+	__raw_writel(I2SPCR_START(stype), I2S_PCR(pscdata));
+	wmb();
 
 	/* wait for start confirmation */
 	tmo = 1000000;
-	while (!(au_readl(I2S_STAT(pscdata)) & I2SSTAT_BUSY(stype)) && tmo)
+	while (!(__raw_readl(I2S_STAT(pscdata)) & I2SSTAT_BUSY(stype)) && tmo)
 		tmo--;
 
 	if (!tmo) {
-		au_writel(I2SPCR_STOP(stype), I2S_PCR(pscdata));
-		au_sync();
+		__raw_writel(I2SPCR_STOP(stype), I2S_PCR(pscdata));
+		wmb();
 		ret = -ETIMEDOUT;
 	}
 out:
@@ -217,21 +217,21 @@ static int au1xpsc_i2s_stop(struct au1xpsc_audio_data *pscdata, int stype)
 {
 	unsigned long tmo, stat;
 
-	au_writel(I2SPCR_STOP(stype), I2S_PCR(pscdata));
-	au_sync();
+	__raw_writel(I2SPCR_STOP(stype), I2S_PCR(pscdata));
+	wmb();
 
 	/* wait for stop confirmation */
 	tmo = 1000000;
-	while ((au_readl(I2S_STAT(pscdata)) & I2SSTAT_BUSY(stype)) && tmo)
+	while ((__raw_readl(I2S_STAT(pscdata)) & I2SSTAT_BUSY(stype)) && tmo)
 		tmo--;
 
 	/* if both TX and RX are idle, disable PSC */
-	stat = au_readl(I2S_STAT(pscdata));
+	stat = __raw_readl(I2S_STAT(pscdata));
 	if (!(stat & (PSC_I2SSTAT_TB | PSC_I2SSTAT_RB))) {
-		au_writel(0, I2S_CFG(pscdata));
-		au_sync();
-		au_writel(PSC_CTRL_SUSPEND, PSC_CTRL(pscdata));
-		au_sync();
+		__raw_writel(0, I2S_CFG(pscdata));
+		wmb();
+		__raw_writel(PSC_CTRL_SUSPEND, PSC_CTRL(pscdata));
+		wmb();
 	}
 	return 0;
 }
@@ -332,12 +332,12 @@ static int au1xpsc_i2s_drvprobe(struct platform_device *pdev)
 	/* preserve PSC clock source set up by platform (dev.platform_data
 	 * is already occupied by soc layer)
 	 */
-	sel = au_readl(PSC_SEL(wd)) & PSC_SEL_CLK_MASK;
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
-	au_writel(PSC_SEL_PS_I2SMODE | sel, PSC_SEL(wd));
-	au_writel(0, I2S_CFG(wd));
-	au_sync();
+	sel = __raw_readl(PSC_SEL(wd)) & PSC_SEL_CLK_MASK;
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
+	__raw_writel(PSC_SEL_PS_I2SMODE | sel, PSC_SEL(wd));
+	__raw_writel(0, I2S_CFG(wd));
+	wmb();
 
 	/* preconfigure: set max rx/tx fifo depths */
 	wd->cfg |= PSC_I2SCFG_RT_FIFO8 | PSC_I2SCFG_TT_FIFO8;
@@ -364,10 +364,10 @@ static int au1xpsc_i2s_drvremove(struct platform_device *pdev)
 
 	snd_soc_unregister_component(&pdev->dev);
 
-	au_writel(0, I2S_CFG(wd));
-	au_sync();
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
+	__raw_writel(0, I2S_CFG(wd));
+	wmb();
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
 
 	return 0;
 }
@@ -378,12 +378,12 @@ static int au1xpsc_i2s_drvsuspend(struct device *dev)
 	struct au1xpsc_audio_data *wd = dev_get_drvdata(dev);
 
 	/* save interesting register and disable PSC */
-	wd->pm[0] = au_readl(PSC_SEL(wd));
+	wd->pm[0] = __raw_readl(PSC_SEL(wd));
 
-	au_writel(0, I2S_CFG(wd));
-	au_sync();
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
+	__raw_writel(0, I2S_CFG(wd));
+	wmb();
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
 
 	return 0;
 }
@@ -393,12 +393,12 @@ static int au1xpsc_i2s_drvresume(struct device *dev)
 	struct au1xpsc_audio_data *wd = dev_get_drvdata(dev);
 
 	/* select I2S mode and PSC clock */
-	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
-	au_sync();
-	au_writel(0, PSC_SEL(wd));
-	au_sync();
-	au_writel(wd->pm[0], PSC_SEL(wd));
-	au_sync();
+	__raw_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
+	wmb();
+	__raw_writel(0, PSC_SEL(wd));
+	wmb();
+	__raw_writel(wd->pm[0], PSC_SEL(wd));
+	wmb();
 
 	return 0;
 }
diff --git a/sound/soc/au1x/psc.h b/sound/soc/au1x/psc.h
index b16b2e0..74dffeb 100644
--- a/sound/soc/au1x/psc.h
+++ b/sound/soc/au1x/psc.h
@@ -27,16 +27,16 @@ struct au1xpsc_audio_data {
 };
 
 /* easy access macros */
-#define PSC_CTRL(x)	((unsigned long)((x)->mmio) + PSC_CTRL_OFFSET)
-#define PSC_SEL(x)	((unsigned long)((x)->mmio) + PSC_SEL_OFFSET)
-#define I2S_STAT(x)	((unsigned long)((x)->mmio) + PSC_I2SSTAT_OFFSET)
-#define I2S_CFG(x)	((unsigned long)((x)->mmio) + PSC_I2SCFG_OFFSET)
-#define I2S_PCR(x)	((unsigned long)((x)->mmio) + PSC_I2SPCR_OFFSET)
-#define AC97_CFG(x)	((unsigned long)((x)->mmio) + PSC_AC97CFG_OFFSET)
-#define AC97_CDC(x)	((unsigned long)((x)->mmio) + PSC_AC97CDC_OFFSET)
-#define AC97_EVNT(x)	((unsigned long)((x)->mmio) + PSC_AC97EVNT_OFFSET)
-#define AC97_PCR(x)	((unsigned long)((x)->mmio) + PSC_AC97PCR_OFFSET)
-#define AC97_RST(x)	((unsigned long)((x)->mmio) + PSC_AC97RST_OFFSET)
-#define AC97_STAT(x)	((unsigned long)((x)->mmio) + PSC_AC97STAT_OFFSET)
+#define PSC_CTRL(x)	((x)->mmio + PSC_CTRL_OFFSET)
+#define PSC_SEL(x)	((x)->mmio + PSC_SEL_OFFSET)
+#define I2S_STAT(x)	((x)->mmio + PSC_I2SSTAT_OFFSET)
+#define I2S_CFG(x)	((x)->mmio + PSC_I2SCFG_OFFSET)
+#define I2S_PCR(x)	((x)->mmio + PSC_I2SPCR_OFFSET)
+#define AC97_CFG(x)	((x)->mmio + PSC_AC97CFG_OFFSET)
+#define AC97_CDC(x)	((x)->mmio + PSC_AC97CDC_OFFSET)
+#define AC97_EVNT(x)	((x)->mmio + PSC_AC97EVNT_OFFSET)
+#define AC97_PCR(x)	((x)->mmio + PSC_AC97PCR_OFFSET)
+#define AC97_RST(x)	((x)->mmio + PSC_AC97RST_OFFSET)
+#define AC97_STAT(x)	((x)->mmio + PSC_AC97STAT_OFFSET)
 
 #endif
-- 
2.0.0

