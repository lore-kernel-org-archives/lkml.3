Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab3JPLFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:05:11 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:58815 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3JPLDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:36 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6/8] zorro: ZTWO_VADDR() should return "void __iomem *"
Date: Wed, 16 Oct 2013 13:03:23 +0200
Message-Id: <1381921405-11206-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZTWO_VADDR() converts from physical to virtual I/O addresses, so it should
return "void __iomem *" instead of "unsigned long".

This allows to drop several casts, but requires adding a few casts to
accomodate legacy driver frameworks that store "unsigned long" I/O
addresses.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c             |    2 +-
 arch/m68k/amiga/config.c              |    2 +-
 arch/m68k/include/asm/amigahw.h       |    2 +-
 drivers/block/z2ram.c                 |    4 ++--
 drivers/ide/buddha.c                  |    2 +-
 drivers/net/ethernet/8390/hydra.c     |    2 +-
 drivers/net/ethernet/8390/zorro8390.c |    4 ++--
 drivers/net/ethernet/amd/a2065.c      |    4 ++--
 drivers/net/ethernet/amd/ariadne.c    |    4 ++--
 drivers/parport/parport_mfc3.c        |    2 +-
 drivers/scsi/a2091.c                  |    2 +-
 drivers/scsi/a3000.c                  |    2 +-
 drivers/scsi/a4000t.c                 |    2 +-
 drivers/scsi/gvp11.c                  |    2 +-
 drivers/scsi/zorro7xx.c               |    2 +-
 drivers/video/amifb.c                 |    2 +-
 drivers/video/cirrusfb.c              |    4 ++--
 17 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index 99449fbf9a72..ba03cec3f711 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -87,7 +87,7 @@ void *amiga_chip_alloc_res(unsigned long size, struct resource *res)
 
 	atomic_sub(size, &chipavail);
 	pr_debug("amiga_chip_alloc_res: returning %pR\n", res);
-	return (void *)ZTWO_VADDR(res->start);
+	return ZTWO_VADDR(res->start);
 }
 
 void amiga_chip_free(void *ptr)
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index d956ddbfebe1..acd9c1640cfc 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -618,7 +618,7 @@ static int __init amiga_savekmsg_setup(char *arg)
 
 	/* Just steal the block, the chipram allocator isn't functional yet */
 	amiga_chip_size -= SAVEKMSG_MAXMEM;
-	savekmsg = (void *)ZTWO_VADDR(CHIP_PHYSADDR + amiga_chip_size);
+	savekmsg = ZTWO_VADDR(CHIP_PHYSADDR + amiga_chip_size);
 	savekmsg->magic1 = SAVEKMSG_MAGIC1;
 	savekmsg->magic2 = SAVEKMSG_MAGIC2;
 	savekmsg->magicptr = ZTWO_PADDR(savekmsg);
diff --git a/arch/m68k/include/asm/amigahw.h b/arch/m68k/include/asm/amigahw.h
index 7a19b5686a4a..3bef0b2ad945 100644
--- a/arch/m68k/include/asm/amigahw.h
+++ b/arch/m68k/include/asm/amigahw.h
@@ -266,7 +266,7 @@ struct CIA {
 
 #define zTwoBase (0x80000000)
 #define ZTWO_PADDR(x) (((unsigned long)(x))-zTwoBase)
-#define ZTWO_VADDR(x) (((unsigned long)(x))+zTwoBase)
+#define ZTWO_VADDR(x) ((void __iomem *)(((unsigned long)(x))+zTwoBase))
 
 #define CUSTOM_PHYSADDR     (0xdff000)
 #define amiga_custom ((*(volatile struct CUSTOM *)(zTwoBase+CUSTOM_PHYSADDR)))
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 5a95baf4b104..8b2a60cee3a0 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -116,8 +116,8 @@ get_z2ram( void )
 	if ( test_bit( i, zorro_unused_z2ram ) )
 	{
 	    z2_count++;
-	    z2ram_map[ z2ram_size++ ] = 
-		ZTWO_VADDR( Z2RAM_START ) + ( i << Z2RAM_CHUNKSHIFT );
+	    z2ram_map[z2ram_size++] = (unsigned long)ZTWO_VADDR(Z2RAM_START) +
+				      (i << Z2RAM_CHUNKSHIFT);
 	    clear_bit( i, zorro_unused_z2ram );
 	}
     }
diff --git a/drivers/ide/buddha.c b/drivers/ide/buddha.c
index b1d38590ac01..46eaf58d881b 100644
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -198,7 +198,7 @@ fail_base2:
 				continue;
 			}
 		}	  
-		buddha_board = ZTWO_VADDR(board);
+		buddha_board = (unsigned long)ZTWO_VADDR(board);
 		
 		/* write to BUDDHA_IRQ_MR to enable the board IRQ */
 		/* X-Surf doesn't have this.  IRQs are always on */
diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390/hydra.c
index fb3dd4399cf3..f615fdec0f1b 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -113,7 +113,7 @@ static const struct net_device_ops hydra_netdev_ops = {
 static int hydra_init(struct zorro_dev *z)
 {
     struct net_device *dev;
-    unsigned long board = ZTWO_VADDR(z->resource.start);
+    unsigned long board = (unsigned long)ZTWO_VADDR(z->resource.start);
     unsigned long ioaddr = board+HYDRA_NIC_BASE;
     const char name[] = "NE2000";
     int start_page, stop_page;
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index 85ec4c2d2645..ae2a12b7db62 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -287,7 +287,7 @@ static const struct net_device_ops zorro8390_netdev_ops = {
 };
 
 static int zorro8390_init(struct net_device *dev, unsigned long board,
-			  const char *name, unsigned long ioaddr)
+			  const char *name, void __iomem *ioaddr)
 {
 	int i;
 	int err;
@@ -354,7 +354,7 @@ static int zorro8390_init(struct net_device *dev, unsigned long board,
 	start_page = NESM_START_PG;
 	stop_page = NESM_STOP_PG;
 
-	dev->base_addr = ioaddr;
+	dev->base_addr = (unsigned long)ioaddr;
 	dev->irq = IRQ_AMIGA_PORTS;
 
 	/* Install the Interrupt handler */
diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index 0866e7627433..f492a19328e5 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -713,8 +713,8 @@ static int a2065_init_one(struct zorro_dev *z,
 	dev->dev_addr[3] = (z->rom.er_SerialNumber >> 16) & 0xff;
 	dev->dev_addr[4] = (z->rom.er_SerialNumber >> 8) & 0xff;
 	dev->dev_addr[5] = z->rom.er_SerialNumber & 0xff;
-	dev->base_addr = ZTWO_VADDR(base_addr);
-	dev->mem_start = ZTWO_VADDR(mem_start);
+	dev->base_addr = (unsigned long)ZTWO_VADDR(base_addr);
+	dev->mem_start = (unsigned long)ZTWO_VADDR(mem_start);
 	dev->mem_end = dev->mem_start + A2065_RAM_SIZE;
 
 	priv->ll = (volatile struct lance_regs *)dev->base_addr;
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index c178eb4c8166..33822cb69366 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -747,8 +747,8 @@ static int ariadne_init_one(struct zorro_dev *z,
 	dev->dev_addr[3] = (z->rom.er_SerialNumber >> 16) & 0xff;
 	dev->dev_addr[4] = (z->rom.er_SerialNumber >> 8) & 0xff;
 	dev->dev_addr[5] = z->rom.er_SerialNumber & 0xff;
-	dev->base_addr = ZTWO_VADDR(base_addr);
-	dev->mem_start = ZTWO_VADDR(mem_start);
+	dev->base_addr = (unsigned long)ZTWO_VADDR(base_addr);
+	dev->mem_start = (unsigned long)ZTWO_VADDR(mem_start);
 	dev->mem_end = dev->mem_start + ARIADNE_RAM_SIZE;
 
 	dev->netdev_ops = &ariadne_netdev_ops;
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 7578d79b3688..2f650f68af14 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -300,7 +300,7 @@ static int __init parport_mfc3_init(void)
 		if (!request_mem_region(piabase, sizeof(struct pia), "PIA"))
 			continue;
 
-		pp = (struct pia *)ZTWO_VADDR(piabase);
+		pp = ZTWO_VADDR(piabase);
 		pp->crb = 0;
 		pp->pddrb = 255; /* all data pins output */
 		pp->crb = PIA_DDR|32|8;
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 30fa38a0ad39..9176bfbd5745 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -201,7 +201,7 @@ static int a2091_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	instance->irq = IRQ_AMIGA_PORTS;
 	instance->unique_id = z->slotaddr;
 
-	regs = (struct a2091_scsiregs *)ZTWO_VADDR(z->resource.start);
+	regs = ZTWO_VADDR(z->resource.start);
 	regs->DAWR = DAWR_A2091;
 
 	wdregs.SASR = &regs->SASR;
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index c0f4f4290dd6..dd5b64726ddc 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -220,7 +220,7 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 
 	instance->irq = IRQ_AMIGA_PORTS;
 
-	regs = (struct a3000_scsiregs *)ZTWO_VADDR(res->start);
+	regs = ZTWO_VADDR(res->start);
 	regs->DAWR = DAWR_A3000;
 
 	wdregs.SASR = &regs->SASR;
diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 70c521f79f7c..f5a2ab41543b 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -56,7 +56,7 @@ static int __init amiga_a4000t_scsi_probe(struct platform_device *pdev)
 	scsi_addr = res->start + A4000T_SCSI_OFFSET;
 
 	/* Fill in the required pieces of hostdata */
-	hostdata->base = (void __iomem *)ZTWO_VADDR(scsi_addr);
+	hostdata->base = ZTWO_VADDR(scsi_addr);
 	hostdata->clock = 50;
 	hostdata->chip710 = 1;
 	hostdata->dmode_extra = DMODE_FC2;
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 2203ac281103..3b6f83ffddc4 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -310,7 +310,7 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	if (!request_mem_region(address, 256, "wd33c93"))
 		return -EBUSY;
 
-	regs = (struct gvp11_scsiregs *)(ZTWO_VADDR(address));
+	regs = ZTWO_VADDR(address);
 
 	error = check_wd33c93(regs);
 	if (error)
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index cbf3476c68cd..aff31991aea9 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -104,7 +104,7 @@ static int zorro7xx_init_one(struct zorro_dev *z,
 	if (ioaddr > 0x01000000)
 		hostdata->base = ioremap(ioaddr, zorro_resource_len(z));
 	else
-		hostdata->base = (void __iomem *)ZTWO_VADDR(ioaddr);
+		hostdata->base = ZTWO_VADDR(ioaddr);
 
 	hostdata->clock = 50;
 	hostdata->chip710 = 1;
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index a6780eecff0e..81ba95fd2b3b 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -3710,7 +3710,7 @@ default_chipset:
 	if (!videomemory) {
 		dev_warn(&pdev->dev,
 			 "Unable to map videomem cached writethrough\n");
-		info->screen_base = (char *)ZTWO_VADDR(info->fix.smem_start);
+		info->screen_base = ZTWO_VADDR(info->fix.smem_start);
 	} else
 		info->screen_base = (char *)videomemory;
 
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 97db3ba8f237..ce910327cc8e 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2262,7 +2262,7 @@ static int cirrusfb_zorro_register(struct zorro_dev *z,
 
 	info->fix.mmio_start = regbase;
 	cinfo->regbase = regbase > 16 * MB_ ? ioremap(regbase, 64 * 1024)
-					    : (caddr_t)ZTWO_VADDR(regbase);
+					    : ZTWO_VADDR(regbase);
 	if (!cinfo->regbase) {
 		dev_err(info->device, "Cannot map registers\n");
 		error = -EIO;
@@ -2272,7 +2272,7 @@ static int cirrusfb_zorro_register(struct zorro_dev *z,
 	info->fix.smem_start = rambase;
 	info->screen_size = ramsize;
 	info->screen_base = rambase > 16 * MB_ ? ioremap(rambase, ramsize)
-					       : (caddr_t)ZTWO_VADDR(rambase);
+					       : ZTWO_VADDR(rambase);
 	if (!info->screen_base) {
 		dev_err(info->device, "Cannot map video RAM\n");
 		error = -EIO;
-- 
1.7.9.5

