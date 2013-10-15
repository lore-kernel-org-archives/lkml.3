Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3JOLA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:00:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab3JOLAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:00:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.23
Date: Tue, 15 Oct 2013 12:00:36 +0100
Message-Id: <1381834836-18835-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381834836-18835-1-git-send-email-luis.henriques@canonical.com>
References: <1381834836-18835-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 539f784..6da3d8e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .22
+EXTRAVERSION = .23
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 359f078..b2f4a8ed 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -501,7 +501,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	/* number of bytes needed for the bitmap */
 	sz = (tbl->it_size + 7) >> 3;
 
-	page = alloc_pages_node(nid, GFP_ATOMIC, get_order(sz));
+	page = alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
 	if (!page)
 		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
 	tbl->it_map = page_address(page);
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 8302af6..bbe9965 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -17,6 +17,7 @@
 #include <asm/machdep.h>
 #include <asm/smp.h>
 #include <asm/pmc.h>
+#include <asm/firmware.h>
 
 #include "cacheinfo.h"
 
@@ -179,15 +180,25 @@ SYSFS_PMCSETUP(spurr, SPRN_SPURR);
 SYSFS_PMCSETUP(dscr, SPRN_DSCR);
 SYSFS_PMCSETUP(pir, SPRN_PIR);
 
+/*
+  Lets only enable read for phyp resources and
+  enable write when needed with a separate function.
+  Lets be conservative and default to pseries.
+*/
 static DEVICE_ATTR(mmcra, 0600, show_mmcra, store_mmcra);
 static DEVICE_ATTR(spurr, 0600, show_spurr, NULL);
 static DEVICE_ATTR(dscr, 0600, show_dscr, store_dscr);
-static DEVICE_ATTR(purr, 0600, show_purr, store_purr);
+static DEVICE_ATTR(purr, 0400, show_purr, store_purr);
 static DEVICE_ATTR(pir, 0400, show_pir, NULL);
 
 unsigned long dscr_default = 0;
 EXPORT_SYMBOL(dscr_default);
 
+static void add_write_permission_dev_attr(struct device_attribute *attr)
+{
+	attr->attr.mode |= 0200;
+}
+
 static ssize_t show_dscr_default(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -394,8 +405,11 @@ static void __cpuinit register_cpu_online(unsigned int cpu)
 	if (cpu_has_feature(CPU_FTR_MMCRA))
 		device_create_file(s, &dev_attr_mmcra);
 
-	if (cpu_has_feature(CPU_FTR_PURR))
+	if (cpu_has_feature(CPU_FTR_PURR)) {
+		if (!firmware_has_feature(FW_FEATURE_LPAR))
+			add_write_permission_dev_attr(&dev_attr_purr);
 		device_create_file(s, &dev_attr_purr);
+	}
 
 	if (cpu_has_feature(CPU_FTR_SPURR))
 		device_create_file(s, &dev_attr_spurr);
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index cb87301..b161bae 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1520,11 +1520,15 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 	const char *cp;
 
 	dn = dev->of_node;
-	if (!dn)
-		return -ENODEV;
+	if (!dn) {
+		strcat(buf, "\n");
+		return strlen(buf);
+	}
 	cp = of_get_property(dn, "compatible", NULL);
-	if (!cp)
-		return -ENODEV;
+	if (!cp) {
+		strcat(buf, "\n");
+		return strlen(buf);
+	}
 
 	return sprintf(buf, "vio:T%sS%s\n", vio_dev->type, cp);
 }
diff --git a/arch/powerpc/lib/checksum_64.S b/arch/powerpc/lib/checksum_64.S
index 18245af..afa2eba 100644
--- a/arch/powerpc/lib/checksum_64.S
+++ b/arch/powerpc/lib/checksum_64.S
@@ -272,8 +272,8 @@ _GLOBAL(csum_partial_copy_generic)
 	rldicl. r6,r3,64-1,64-2		/* r6 = (r3 & 0x3) >> 1 */
 	beq	.Lcopy_aligned
 
-	li	r7,4
-	sub	r6,r7,r6
+	li	r9,4
+	sub	r6,r9,r6
 	mtctr	r6
 
 1:
diff --git a/arch/sparc/kernel/entry.S b/arch/sparc/kernel/entry.S
index dcaa1cf..1670d10 100644
--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -860,7 +860,7 @@ sys_sigreturn:
 	 nop
 
 	call	syscall_trace
-	 nop
+	 mov	1, %o1
 
 1:
 	/* We don't want to muck with user registers like a
diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 79f3103..7c00735 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -25,11 +25,10 @@ kvmap_itlb:
 	 */
 kvmap_itlb_4v:
 
-kvmap_itlb_nonlinear:
 	/* Catch kernel NULL pointer calls.  */
 	sethi		%hi(PAGE_SIZE), %g5
 	cmp		%g4, %g5
-	bleu,pn		%xcc, kvmap_dtlb_longpath
+	blu,pn		%xcc, kvmap_itlb_longpath
 	 nop
 
 	KERN_TSB_LOOKUP_TL1(%g4, %g6, %g5, %g1, %g2, %g3, kvmap_itlb_load)
diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 7f5f65d..817187d 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -147,7 +147,7 @@ linux_syscall_trace32:
 	srl	%i4, 0, %o4
 	srl	%i1, 0, %o1
 	srl	%i2, 0, %o2
-	ba,pt	%xcc, 2f
+	ba,pt	%xcc, 5f
 	 srl	%i3, 0, %o3
 
 linux_syscall_trace:
@@ -177,13 +177,13 @@ linux_sparc_syscall32:
 	srl	%i1, 0, %o1				! IEU0	Group
 	ldx	[%g6 + TI_FLAGS], %l0		! Load
 
-	srl	%i5, 0, %o5				! IEU1
+	srl	%i3, 0, %o3				! IEU0
 	srl	%i2, 0, %o2				! IEU0	Group
 	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %g0
 	bne,pn	%icc, linux_syscall_trace32		! CTI
 	 mov	%i0, %l5				! IEU1
-	call	%l7					! CTI	Group brk forced
-	 srl	%i3, 0, %o3				! IEU0
+5:	call	%l7					! CTI	Group brk forced
+	 srl	%i5, 0, %o5				! IEU1
 	ba,a,pt	%xcc, 3f
 
 	/* Linux native system calls enter here... */
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index da1b781..8fa84a3 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -131,7 +131,6 @@ startup_continue:
 	clr		%l5
 	sethi		%hi(num_kernel_image_mappings), %l6
 	lduw		[%l6 + %lo(num_kernel_image_mappings)], %l6
-	add		%l6, 1, %l6
 
 	mov		15, %l7
 	BRANCH_IF_ANY_CHEETAH(g1,g5,2f)
@@ -224,7 +223,6 @@ niagara_lock_tlb:
 	clr		%l5
 	sethi		%hi(num_kernel_image_mappings), %l6
 	lduw		[%l6 + %lo(num_kernel_image_mappings)], %l6
-	add		%l6, 1, %l6
 
 1:
 	mov		HV_FAST_MMU_MAP_PERM_ADDR, %o5
diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 3b31218..6a169df 100644
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -98,15 +98,6 @@ EXPORT_SYMBOL(___copy_from_user);
 EXPORT_SYMBOL(___copy_in_user);
 EXPORT_SYMBOL(__clear_user);
 
-/* RW semaphores */
-EXPORT_SYMBOL(__down_read);
-EXPORT_SYMBOL(__down_read_trylock);
-EXPORT_SYMBOL(__down_write);
-EXPORT_SYMBOL(__down_write_trylock);
-EXPORT_SYMBOL(__up_read);
-EXPORT_SYMBOL(__up_write);
-EXPORT_SYMBOL(__downgrade_write);
-
 /* Atomic counter implementation. */
 EXPORT_SYMBOL(atomic_add);
 EXPORT_SYMBOL(atomic_add_ret);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2a29384..d1ef8a7 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -459,6 +459,22 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
+	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ca4e1ad..cfe8b9c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -861,10 +861,13 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+#ifdef CONFIG_X86_64
+			if (md->type != EFI_BOOT_SERVICES_CODE &&
+			    md->type != EFI_BOOT_SERVICES_DATA)
+#endif
+				continue;
+		}
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..4d27120 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1484,7 +1484,7 @@ static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 
 	if (samples) {
 		v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
-		do_div(v, samples);
+		v = div64_u64(v, samples);
 	}
 	__blkg_prfill_u64(sf, pd, v);
 	return 0;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d3446f6..d7ad865 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1186,6 +1186,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 9125bbe..504bc16 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1195,6 +1195,7 @@ out_passthru:
 		ida_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		memset(&pciinfo, 0, sizeof(pciinfo));
 		pciinfo.bus = host->pci_dev->bus->number;
 		pciinfo.dev_fn = host->pci_dev->devfn;
 		pciinfo.board_id = host->board_id;
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 5a757be..8c5508b 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -85,6 +85,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x04CA, 0x3008) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
+	{ USB_DEVICE(0x0CF3, 0xE005) },
 	{ USB_DEVICE(0x0930, 0x0219) },
 	{ USB_DEVICE(0x0489, 0xe057) },
 	{ USB_DEVICE(0x13d3, 0x3393) },
@@ -126,6 +127,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e17340f..a5eef4e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,6 +108,7 @@ static struct usb_device_id btusb_table[] = {
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0b05, 0x17b5) },
+	{ USB_DEVICE(0x0b05, 0x17cb) },
 	{ USB_DEVICE(0x04ca, 0x2003) },
 	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x413c, 0x8197) },
@@ -154,6 +155,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 4058430..fffd143 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -169,9 +169,9 @@ static void atc_desc_put(struct at_dma_chan *atchan, struct at_desc *desc)
 }
 
 /**
- * atc_desc_chain - build chain adding a descripor
- * @first: address of first descripor of the chain
- * @prev: address of previous descripor of the chain
+ * atc_desc_chain - build chain adding a descriptor
+ * @first: address of first descriptor of the chain
+ * @prev: address of previous descriptor of the chain
  * @desc: descriptor to queue
  *
  * Called from prep_* functions
@@ -797,7 +797,7 @@ err_out:
 }
 
 /**
- * atc_dma_cyclic_fill_desc - Fill one period decriptor
+ * atc_dma_cyclic_fill_desc - Fill one period descriptor
  */
 static int
 atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index c64917e..bb02fd9 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -1118,7 +1118,7 @@ fail:
  * @chan: channel
  * @dma_addr: DMA mapped address of the buffer
  * @buf_len: length of the buffer (in bytes)
- * @period_len: lenght of a single period
+ * @period_len: length of a single period
  * @dir: direction of the operation
  * @context: operation context (ignored)
  *
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8f84761..094437b 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1015,7 +1015,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	/*
 	 * Programming Error
 	 * The DMA_INTERRUPT async_tx is a NULL transfer, which will
-	 * triger a PE interrupt.
+	 * trigger a PE interrupt.
 	 */
 	if (stat & FSL_DMA_SR_PE) {
 		chan_dbg(chan, "irq: Programming Error INT\n");
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 8aa9113..39e07e5 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -374,17 +374,18 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	int chno = imxdmac->channel;
 	struct imxdma_desc *desc;
+	unsigned long flags;
 
-	spin_lock(&imxdma->lock);
+	spin_lock_irqsave(&imxdma->lock, flags);
 	if (list_empty(&imxdmac->ld_active)) {
-		spin_unlock(&imxdma->lock);
+		spin_unlock_irqrestore(&imxdma->lock, flags);
 		goto out;
 	}
 
 	desc = list_first_entry(&imxdmac->ld_active,
 				struct imxdma_desc,
 				node);
-	spin_unlock(&imxdma->lock);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
 
 	if (desc->sg) {
 		u32 tmp;
@@ -456,7 +457,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
-	unsigned long flags;
 	int slot = -1;
 	int i;
 
@@ -464,7 +464,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	switch (d->type) {
 	case IMXDMA_DESC_INTERLEAVED:
 		/* Try to get a free 2D slot */
-		spin_lock_irqsave(&imxdma->lock, flags);
 		for (i = 0; i < IMX_DMA_2D_SLOTS; i++) {
 			if ((imxdma->slots_2d[i].count > 0) &&
 			((imxdma->slots_2d[i].xsr != d->x) ||
@@ -474,10 +473,8 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 			slot = i;
 			break;
 		}
-		if (slot < 0) {
-			spin_unlock_irqrestore(&imxdma->lock, flags);
+		if (slot < 0)
 			return -EBUSY;
-		}
 
 		imxdma->slots_2d[slot].xsr = d->x;
 		imxdma->slots_2d[slot].ysr = d->y;
@@ -486,7 +483,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 
 		imxdmac->slot_2d = slot;
 		imxdmac->enabled_2d = true;
-		spin_unlock_irqrestore(&imxdma->lock, flags);
 
 		if (slot == IMX_DMA_2D_SLOT_A) {
 			d->config_mem &= ~CCR_MSEL_B;
@@ -562,20 +558,19 @@ static void imxdma_tasklet(unsigned long data)
 	struct imxdma_channel *imxdmac = (void *)data;
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc;
+	unsigned long flags;
 
-	spin_lock(&imxdma->lock);
+	spin_lock_irqsave(&imxdma->lock, flags);
 
 	if (list_empty(&imxdmac->ld_active)) {
 		/* Someone might have called terminate all */
-		goto out;
+		spin_unlock_irqrestore(&imxdma->lock, flags);
+		return;
 	}
 	desc = list_first_entry(&imxdmac->ld_active, struct imxdma_desc, node);
 
-	if (desc->desc.callback)
-		desc->desc.callback(desc->desc.callback_param);
-
-	/* If we are dealing with a cyclic descriptor keep it on ld_active
-	 * and dont mark the descripor as complete.
+	/* If we are dealing with a cyclic descriptor, keep it on ld_active
+	 * and dont mark the descriptor as complete.
 	 * Only in non-cyclic cases it would be marked as complete
 	 */
 	if (imxdma_chan_is_doing_cyclic(imxdmac))
@@ -600,7 +595,11 @@ static void imxdma_tasklet(unsigned long data)
 				 __func__, imxdmac->channel);
 	}
 out:
-	spin_unlock(&imxdma->lock);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
+
+	if (desc->desc.callback)
+		desc->desc.callback(desc->desc.callback_param);
+
 }
 
 static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
@@ -824,7 +823,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 		kfree(imxdmac->sg_list);
 
 	imxdmac->sg_list = kcalloc(periods + 1,
-			sizeof(struct scatterlist), GFP_KERNEL);
+			sizeof(struct scatterlist), GFP_ATOMIC);
 	if (!imxdmac->sg_list)
 		return NULL;
 
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
index 1bfa926..17b4219 100644
--- a/drivers/dma/intel_mid_dma_regs.h
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -168,9 +168,9 @@ union intel_mid_dma_cfg_hi {
  * @active_list: current active descriptors
  * @queue: current queued up descriptors
  * @free_list: current free descriptors
- * @slave: dma slave struture
- * @descs_allocated: total number of decsiptors allocated
- * @dma: dma device struture pointer
+ * @slave: dma slave structure
+ * @descs_allocated: total number of descriptors allocated
+ * @dma: dma device structure pointer
  * @busy: bool representing if ch is busy (active txn) or not
  * @in_use: bool representing if ch is in use or not
  * @raw_tfr: raw trf interrupt received
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index de4ec1a..0d5a996 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -522,7 +522,7 @@ enum desc_status {
 	/* In the DMAC pool */
 	FREE,
 	/*
-	 * Allocted to some channel during prep_xxx
+	 * Allocated to some channel during prep_xxx
 	 * Also may be sitting on the work_list.
 	 */
 	PREP,
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index ced9882..f72348d 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4446,7 +4446,7 @@ static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev)
 		ret = -ENOMEM;
 		goto err_dma_alloc;
 	}
-	dev_dbg(&ofdev->dev, "allocted descriptor pool virt 0x%p phys 0x%llx\n",
+	dev_dbg(&ofdev->dev, "allocated descriptor pool virt 0x%p phys 0x%llx\n",
 		adev->dma_desc_pool_virt, (u64)adev->dma_desc_pool);
 
 	regs = ioremap(res.start, resource_size(&res));
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 51e8e53..6d47373 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -202,7 +202,7 @@
 /* LLI related structures */
 
 /**
- * struct d40_phy_lli - The basic configration register for each physical
+ * struct d40_phy_lli - The basic configuration register for each physical
  * channel.
  *
  * @reg_cfg: The configuration register.
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 85a6eeb..49920a7 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -176,7 +176,7 @@ uint8_t ast_get_index_reg_mask(struct ast_private *ast,
 
 static inline void ast_open_key(struct ast_private *ast)
 {
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xA1, 0xFF, 0x04);
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0x80, 0xA8);
 }
 
 #define AST_VIDMEM_SIZE_8M    0x00800000
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index b6f6963..0224d43 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -631,7 +631,18 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
 			DRM_DEBUG_KMS("aux_ch native nack\n");
 			return -EREMOTEIO;
 		case AUX_NATIVE_REPLY_DEFER:
-			udelay(100);
+			/*
+			 * For now, just give more slack to branch devices. We
+			 * could check the DPCD for I2C bit rate capabilities,
+			 * and if available, adjust the interval. We could also
+			 * be more careful with DP-to-Legacy adapters where a
+			 * long legacy cable may force very low I2C bit rates.
+			 */
+			if (intel_dp->dpcd[DP_DOWNSTREAMPORT_PRESENT] &
+			    DP_DWN_STRM_PORT_PRESENT)
+				usleep_range(500, 600);
+			else
+				usleep_range(300, 400);
 			continue;
 		default:
 			DRM_ERROR("aux_ch invalid native reply 0x%02x\n",
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 66ecc38..64bc2bd 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1425,8 +1425,12 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 			atombios_dig_encoder_setup(encoder, ATOM_ENABLE, 0);
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, 0, 0);
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
-			/* some early dce3.2 boards have a bug in their transmitter control table */
-			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730))
+			/* some dce3.x boards have a bug in their transmitter control table.
+			 * ACTION_ENABLE_OUTPUT can probably be dropped since ACTION_ENABLE
+			 * does the same thing and more.
+			 */
+			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
+			    (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index a7e797c..bfe1f75 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1479,6 +1479,24 @@ struct drm_connector_funcs radeon_dp_connector_funcs = {
 	.force = radeon_dvi_force,
 };
 
+static const struct drm_connector_funcs radeon_edp_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = radeon_dp_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = radeon_lvds_set_property,
+	.destroy = radeon_dp_connector_destroy,
+	.force = radeon_dvi_force,
+};
+
+static const struct drm_connector_funcs radeon_lvds_bridge_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = radeon_dp_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = radeon_lvds_set_property,
+	.destroy = radeon_dp_connector_destroy,
+	.force = radeon_dvi_force,
+};
+
 void
 radeon_add_atom_connector(struct drm_device *dev,
 			  uint32_t connector_id,
@@ -1570,8 +1588,6 @@ radeon_add_atom_connector(struct drm_device *dev,
 			goto failed;
 		radeon_dig_connector->igp_lane_info = igp_lane_info;
 		radeon_connector->con_priv = radeon_dig_connector;
-		drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
-		drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 		if (i2c_bus->valid) {
 			/* add DP i2c bus */
 			if (connector_type == DRM_MODE_CONNECTOR_eDP)
@@ -1588,6 +1604,10 @@ radeon_add_atom_connector(struct drm_device *dev,
 		case DRM_MODE_CONNECTOR_VGA:
 		case DRM_MODE_CONNECTOR_DVIA:
 		default:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_dp_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			connector->interlace_allowed = true;
 			connector->doublescan_allowed = true;
 			radeon_connector->dac_load_detect = true;
@@ -1600,6 +1620,10 @@ radeon_add_atom_connector(struct drm_device *dev,
 		case DRM_MODE_CONNECTOR_HDMIA:
 		case DRM_MODE_CONNECTOR_HDMIB:
 		case DRM_MODE_CONNECTOR_DisplayPort:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_dp_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			drm_connector_attach_property(&radeon_connector->base,
 						      rdev->mode_info.underscan_property,
 						      UNDERSCAN_OFF);
@@ -1624,6 +1648,10 @@ radeon_add_atom_connector(struct drm_device *dev,
 			break;
 		case DRM_MODE_CONNECTOR_LVDS:
 		case DRM_MODE_CONNECTOR_eDP:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_lvds_bridge_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			drm_connector_attach_property(&radeon_connector->base,
 						      dev->mode_config.scaling_mode_property,
 						      DRM_MODE_SCALE_FULLSCREEN);
@@ -1787,7 +1815,7 @@ radeon_add_atom_connector(struct drm_device *dev,
 				goto failed;
 			radeon_dig_connector->igp_lane_info = igp_lane_info;
 			radeon_connector->con_priv = radeon_dig_connector;
-			drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
+			drm_connector_init(dev, &radeon_connector->base, &radeon_edp_connector_funcs, connector_type);
 			drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 			if (i2c_bus->valid) {
 				/* add DP i2c bus */
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index d14044e..719702d1 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -834,13 +834,22 @@ int radeon_device_init(struct radeon_device *rdev,
 			return r;
 	}
 	if ((radeon_testing & 1)) {
-		radeon_test_moves(rdev);
+		if (rdev->accel_working)
+			radeon_test_moves(rdev);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping move tests\n");
 	}
 	if ((radeon_testing & 2)) {
-		radeon_test_syncing(rdev);
+		if (rdev->accel_working)
+			radeon_test_syncing(rdev);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping sync tests\n");
 	}
 	if (radeon_benchmarking) {
-		radeon_benchmark(rdev, radeon_benchmarking);
+		if (rdev->accel_working)
+			radeon_benchmark(rdev, radeon_benchmarking);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping benchmarks\n");
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index fa09daf..ea10bbe 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -170,7 +170,7 @@ void ttm_tt_destroy(struct ttm_tt *ttm)
 		ttm_tt_unbind(ttm);
 	}
 
-	if (likely(ttm->pages != NULL)) {
+	if (ttm->state == tt_unbound) {
 		ttm->bdev->driver->ttm_tt_unpopulate(ttm);
 	}
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0d76d3f..adca1b0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
 static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
 {
 	struct hid_field *field;
+	int i;
 
 	if (report->maxfield == HID_MAX_FIELDS) {
 		hid_err(report->device, "too many fields in report\n");
@@ -112,6 +113,9 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
 	field->value = (s32 *)(field->usage + usages);
 	field->report = report;
 
+	for (i = 0; i < usages; i++)
+		field->usage[i].usage_index = i;
+
 	return field;
 }
 
@@ -222,9 +226,9 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 {
 	struct hid_report *report;
 	struct hid_field *field;
-	int usages;
+	unsigned usages;
 	unsigned offset;
-	int i;
+	unsigned i;
 
 	report = hid_register_report(parser->device, report_type, parser->global.report_id);
 	if (!report) {
@@ -251,7 +255,8 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
 
-	usages = max_t(int, parser->local.usage_index, parser->global.report_count);
+	usages = max_t(unsigned, parser->local.usage_index,
+				 parser->global.report_count);
 
 	field = hid_register_field(report, usages, parser->global.report_count);
 	if (!field)
@@ -262,13 +267,14 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	field->application = hid_lookup_collection(parser, HID_COLLECTION_APPLICATION);
 
 	for (i = 0; i < usages; i++) {
-		int j = i;
+		unsigned j = i;
 		/* Duplicate the last usage we parsed if we have excess values */
 		if (i >= parser->local.usage_index)
 			j = parser->local.usage_index - 1;
 		field->usage[i].hid = parser->local.usage[j];
 		field->usage[i].collection_index =
 			parser->local.collection_index[j];
+		field->usage[i].usage_index = i;
 	}
 
 	field->maxusage = usages;
@@ -743,6 +749,64 @@ int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size)
 }
 EXPORT_SYMBOL_GPL(hid_parse_report);
 
+static const char * const hid_report_names[] = {
+	"HID_INPUT_REPORT",
+	"HID_OUTPUT_REPORT",
+	"HID_FEATURE_REPORT",
+};
+/**
+ * hid_validate_values - validate existing device report's value indexes
+ *
+ * @device: hid device
+ * @type: which report type to examine
+ * @id: which report ID to examine (0 for first)
+ * @field_index: which report field to examine
+ * @report_counts: expected number of values
+ *
+ * Validate the number of values in a given field of a given report, after
+ * parsing.
+ */
+struct hid_report *hid_validate_values(struct hid_device *hid,
+				       unsigned int type, unsigned int id,
+				       unsigned int field_index,
+				       unsigned int report_counts)
+{
+	struct hid_report *report;
+
+	if (type > HID_FEATURE_REPORT) {
+		hid_err(hid, "invalid HID report type %u\n", type);
+		return NULL;
+	}
+
+	if (id >= HID_MAX_IDS) {
+		hid_err(hid, "invalid HID report id %u\n", id);
+		return NULL;
+	}
+
+	/*
+	 * Explicitly not using hid_get_report() here since it depends on
+	 * ->numbered being checked, which may not always be the case when
+	 * drivers go to access report values.
+	 */
+	report = hid->report_enum[type].report_id_hash[id];
+	if (!report) {
+		hid_err(hid, "missing %s %u\n", hid_report_names[type], id);
+		return NULL;
+	}
+	if (report->maxfield <= field_index) {
+		hid_err(hid, "not enough fields in %s %u\n",
+			hid_report_names[type], id);
+		return NULL;
+	}
+	if (report->field[field_index]->report_count < report_counts) {
+		hid_err(hid, "not enough values in %s %u field %u\n",
+			hid_report_names[type], id, field_index);
+		return NULL;
+	}
+	return report;
+}
+EXPORT_SYMBOL_GPL(hid_validate_values);
+
 /**
  * hid_open_report - open a driver-specific device report
  *
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7561d73..16641fd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -610,6 +610,7 @@
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16   0x0012
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17   0x0013
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18   0x0014
+#define USB_DEVICE_ID_NTRIG_DUOSENSE 0x1500
 
 #define USB_VENDOR_ID_ONTRAK		0x0a07
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c460b74..0c218f8 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -470,6 +470,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	if (field->flags & HID_MAIN_ITEM_CONSTANT)
 		goto ignore;
 
+	/* Ignore if report count is out of bounds. */
+	if (field->report_count < 1)
+		goto ignore;
+
 	/* only LED usages are supported in output fields */
 	if (field->report_type == HID_OUTPUT_REPORT &&
 			(usage->hid & HID_USAGE_PAGE) != HID_UP_LED) {
@@ -1134,7 +1138,11 @@ static void report_features(struct hid_device *hid)
 
 	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
 	list_for_each_entry(rep, &rep_enum->report_list, list)
-		for (i = 0; i < rep->maxfield; i++)
+		for (i = 0; i < rep->maxfield; i++) {
+			/* Ignore if report count is out of bounds. */
+			if (rep->field[i]->report_count < 1)
+				continue;
+
 			for (j = 0; j < rep->field[i]->maxusage; j++) {
 				/* Verify if Battery Strength feature is available */
 				hidinput_setup_battery(hid, HID_FEATURE_REPORT, rep->field[i]);
@@ -1143,6 +1151,7 @@ static void report_features(struct hid_device *hid)
 					drv->feature_mapping(hid, rep->field[i],
 							     rep->field[i]->usage + j);
 			}
+		}
 }
 
 /*
diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 3c31bc6..128f011 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -66,26 +66,13 @@ int lg2ff_init(struct hid_device *hid)
 	struct hid_report *report;
 	struct hid_input *hidinput = list_entry(hid->inputs.next,
 						struct hid_input, list);
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
 	int error;
 
-	if (list_empty(report_list)) {
-		hid_err(hid, "no output report found\n");
+	/* Check that the report looks ok */
+	report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7);
+	if (!report)
 		return -ENODEV;
-	}
-
-	report = list_entry(report_list->next, struct hid_report, list);
-
-	if (report->maxfield < 1) {
-		hid_err(hid, "output report is empty\n");
-		return -ENODEV;
-	}
-	if (report->field[0]->report_count < 7) {
-		hid_err(hid, "not enough values in the field\n");
-		return -ENODEV;
-	}
 
 	lg2ff = kmalloc(sizeof(struct lg2ff_device), GFP_KERNEL);
 	if (!lg2ff)
diff --git a/drivers/hid/hid-lg3ff.c b/drivers/hid/hid-lg3ff.c
index f98644c..91f981f 100644
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -68,10 +68,11 @@ static int hid_lg3ff_play(struct input_dev *dev, void *data,
 	int x, y;
 
 /*
- * Maxusage should always be 63 (maximum fields)
- * likely a better way to ensure this data is clean
+ * Available values in the field should always be 63, but we only use up to
+ * 35. Instead, clear the entire area, however big it is.
  */
-	memset(report->field[0]->value, 0, sizeof(__s32)*report->field[0]->maxusage);
+	memset(report->field[0]->value, 0,
+	       sizeof(__s32) * report->field[0]->report_count);
 
 	switch (effect->type) {
 	case FF_CONSTANT:
@@ -131,32 +132,14 @@ static const signed short ff3_joystick_ac[] = {
 int lg3ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	const signed short *ff_bits = ff3_joystick_ac;
 	int error;
 	int i;
 
-	/* Find the report to use */
-	if (list_empty(report_list)) {
-		hid_err(hid, "No output report found\n");
-		return -1;
-	}
-
 	/* Check that the report looks ok */
-	report = list_entry(report_list->next, struct hid_report, list);
-	if (!report) {
-		hid_err(hid, "NULL output report\n");
-		return -1;
-	}
-
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
-		return -1;
-	}
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 35))
+		return -ENODEV;
 
 	/* Assume single fixed device G940 */
 	for (i = 0; ff_bits[i] >= 0; i++)
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index f3390ee..e092923 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -424,34 +424,16 @@ static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cde
 int lg4ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	struct lg4ff_device_entry *entry;
 	struct lg_drv_data *drv_data;
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
 	__u16 bcdDevice, rev_maj, rev_min;
 
-	/* Find the report to use */
-	if (list_empty(report_list)) {
-		hid_err(hid, "No output report found\n");
-		return -1;
-	}
-
 	/* Check that the report looks ok */
-	report = list_entry(report_list->next, struct hid_report, list);
-	if (!report) {
-		hid_err(hid, "NULL output report\n");
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -1;
-	}
-
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
-		return -1;
-	}
 
 	/* Check what wheel has been connected */
 	for (i = 0; i < ARRAY_SIZE(lg4ff_devices); i++) {
diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
index 27bc54f..1d978daa 100644
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -130,27 +130,14 @@ static void hid_lgff_set_autocenter(struct input_dev *dev, u16 magnitude)
 int lgff_init(struct hid_device* hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	const signed short *ff_bits = ff_joystick;
 	int error;
 	int i;
 
-	/* Find the report to use */
-	if (list_empty(report_list)) {
-		hid_err(hid, "No output report found\n");
-		return -1;
-	}
-
 	/* Check that the report looks ok */
-	report = list_entry(report_list->next, struct hid_report, list);
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
-		return -1;
-	}
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
+		return -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(devices); i++) {
 		if (dev->id.vendor == devices[i].idVendor &&
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 8758f38c..4288123 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -462,7 +462,7 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 	struct hid_report *report;
 	struct hid_report_enum *output_report_enum;
 	u8 *data = (u8 *)(&dj_report->device_index);
-	int i;
+	unsigned int i;
 
 	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
 	report = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
@@ -472,7 +472,7 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 		return -ENODEV;
 	}
 
-	for (i = 0; i < report->field[0]->report_count; i++)
+	for (i = 0; i < DJREPORT_SHORT_LENGTH - 1; i++)
 		report->field[0]->value[i] = data[i];
 
 	usbhid_submit_report(hdev, report, USB_DIR_OUT);
@@ -784,6 +784,12 @@ static int logi_dj_probe(struct hid_device *hdev,
 		goto hid_parse_fail;
 	}
 
+	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, REPORT_ID_DJ_SHORT,
+				 0, DJREPORT_SHORT_LENGTH - 1)) {
+		retval = -ENODEV;
+		goto hid_parse_fail;
+	}
+
 	/* Starts the usb device and connects to upper interfaces hiddev and
 	 * hidraw */
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 348550a..fa3c904 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -82,9 +82,9 @@ struct mt_device {
 					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
-	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
-	__s8 inputmode_index;	/* InputMode HID feature index in the report */
-	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
+	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
+	__s16 inputmode_index;	/* InputMode HID feature index in the report */
+	__s16 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
@@ -261,20 +261,18 @@ static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
-	int i;
 
 	switch (usage->hid) {
 	case HID_DG_INPUTMODE:
-		td->inputmode = field->report->id;
-		td->inputmode_index = 0; /* has to be updated below */
-
-		for (i=0; i < field->maxusage; i++) {
-			if (field->usage[i].hid == usage->hid) {
-				td->inputmode_index = i;
-				break;
-			}
+		/* Ignore if value index is out of bounds. */
+		if (usage->usage_index >= field->report_count) {
+			dev_err(&hdev->dev, "HID_DG_INPUTMODE out of range\n");
+			break;
 		}
 
+		td->inputmode = field->report->id;
+		td->inputmode_index = usage->usage_index;
+
 		break;
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
@@ -425,6 +423,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
+			/* Ignore if indexes are out of bounds. */
+			if (field->index >= field->report->maxfield ||
+			    usage->usage_index >= field->report_count)
+				return 1;
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
diff --git a/drivers/hid/hid-speedlink.c b/drivers/hid/hid-speedlink.c
index 6020137..2b03c9b 100644
--- a/drivers/hid/hid-speedlink.c
+++ b/drivers/hid/hid-speedlink.c
@@ -3,7 +3,7 @@
  *  Fixes "jumpy" cursor and removes nonexistent keyboard LEDS from
  *  the HID descriptor.
  *
- *  Copyright (c) 2011 Stefan Kriwanek <mail@stefankriwanek.de>
+ *  Copyright (c) 2011, 2013 Stefan Kriwanek <dev@stefankriwanek.de>
  */
 
 /*
@@ -48,8 +48,13 @@ static int speedlink_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
 	/* No other conditions due to usage_table. */
-	/* Fix "jumpy" cursor (invalid events sent by device). */
-	if (value == 256)
+
+	/* This fixes the "jumpy" cursor occuring due to invalid events sent
+	 * by the device. Some devices only send them with value==+256, others
+	 * don't. However, catching abs(value)>=256 is restrictive enough not
+	 * to interfere with devices that were bug-free (has been tested).
+	 */
+	if (abs(value) >= 256)
 		return 1;
 	/* Drop useless distance 0 events (on button clicks etc.) as well */
 	if (value == 0)
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index f6ba81d..f348f7f 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -70,21 +70,13 @@ static int zpff_init(struct hid_device *hid)
 	struct hid_report *report;
 	struct hid_input *hidinput = list_entry(hid->inputs.next,
 						struct hid_input, list);
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	int error;
+	int i, error;
 
-	if (list_empty(report_list)) {
-		hid_err(hid, "no output report found\n");
-		return -ENODEV;
-	}
-
-	report = list_entry(report_list->next, struct hid_report, list);
-
-	if (report->maxfield < 4) {
-		hid_err(hid, "not enough fields in report\n");
-		return -ENODEV;
+	for (i = 0; i < 4; i++) {
+		report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, i, 1);
+		if (!report)
+			return -ENODEV;
 	}
 
 	zpff = kzalloc(sizeof(struct zpff_device), GFP_KERNEL);
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0401e3f..4c37560 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -106,6 +106,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+
 	{ 0, 0 }
 };
 
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2cde9ec..0882b25 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -489,16 +489,25 @@ static int applesmc_init_smcreg_try(void)
 {
 	struct applesmc_registers *s = &smcreg;
 	bool left_light_sensor, right_light_sensor;
+	unsigned int count;
 	u8 tmp[1];
 	int ret;
 
 	if (s->init_complete)
 		return 0;
 
-	ret = read_register_count(&s->key_count);
+	ret = read_register_count(&count);
 	if (ret)
 		return ret;
 
+	if (s->cache && s->key_count != count) {
+		pr_warn("key count changed from %d to %d\n",
+			s->key_count, count);
+		kfree(s->cache);
+		s->cache = NULL;
+	}
+	s->key_count = count;
+
 	if (!s->cache)
 		s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
 	if (!s->cache)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 5f6b7f6..10f88e6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1609,7 +1609,7 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 	int resp_data_len;
 	int resp_len;
 
-	resp_data_len = (rsp_code == SRP_TSK_MGMT_SUCCESS) ? 0 : 4;
+	resp_data_len = 4;
 	resp_len = sizeof(*srp_rsp) + resp_data_len;
 
 	srp_rsp = ioctx->ioctx.buf;
@@ -1621,11 +1621,9 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 				    + atomic_xchg(&ch->req_lim_delta, 0));
 	srp_rsp->tag = tag;
 
-	if (rsp_code != SRP_TSK_MGMT_SUCCESS) {
-		srp_rsp->flags |= SRP_RSP_FLAG_RSPVALID;
-		srp_rsp->resp_data_len = cpu_to_be32(resp_data_len);
-		srp_rsp->data[3] = rsp_code;
-	}
+	srp_rsp->flags |= SRP_RSP_FLAG_RSPVALID;
+	srp_rsp->resp_data_len = cpu_to_be32(resp_data_len);
+	srp_rsp->data[3] = rsp_code;
 
 	return resp_len;
 }
@@ -2372,6 +2370,8 @@ static void srpt_release_channel_work(struct work_struct *w)
 	transport_deregister_session(ch->sess);
 	ch->sess = NULL;
 
+	ib_destroy_cm_id(ch->cm_id);
+
 	srpt_destroy_ch_ib(ch);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
@@ -2382,8 +2382,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 	list_del(&ch->list);
 	spin_unlock_irq(&sdev->spinlock);
 
-	ib_destroy_cm_id(ch->cm_id);
-
 	if (ch->release_done)
 		complete(ch->release_done);
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3ac4156..4caa8e6 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -256,7 +256,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
 	 */
 	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
-	flush_work(&req.work);
+	flush_workqueue(ps->metadata_wq);
 
 	return req.result;
 }
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 8bd2d5f..330bfd6 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -721,17 +721,16 @@ static int calc_max_buckets(void)
  */
 static int init_hash_tables(struct dm_snapshot *s)
 {
-	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
+	sector_t hash_size, cow_dev_size, max_buckets;
 
 	/*
 	 * Calculate based on the size of the original volume or
 	 * the COW volume...
 	 */
 	cow_dev_size = get_dev_size(s->cow->bdev);
-	origin_dev_size = get_dev_size(s->origin->bdev);
 	max_buckets = calc_max_buckets();
 
-	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
+	hash_size = cow_dev_size >> s->store->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
 	if (hash_size < 64)
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c7fd229c..5edf072 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1942,6 +1942,7 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	struct sockaddr addr;
+	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
 
 	/* slave is not a slave or master is not master of this slave */
@@ -2075,12 +2076,18 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	 * already taken care of above when we detached the slave
 	 */
 	if (!USES_PRIMARY(bond->params.mode)) {
-		/* unset promiscuity level from slave */
-		if (bond_dev->flags & IFF_PROMISC)
+		/* unset promiscuity level from slave
+		 * NOTE: The NETDEV_CHANGEADDR call above may change the value
+		 * of the IFF_PROMISC flag in the bond_dev, but we need the
+		 * value of that flag before that change, as that was the value
+		 * when this slave was attached, so we cache at the start of the
+		 * function and use it here. Same goes for ALLMULTI below
+		 */
+		if (old_flags & IFF_PROMISC)
 			dev_set_promiscuity(slave_dev, -1);
 
 		/* unset allmulti level from slave */
-		if (bond_dev->flags & IFF_ALLMULTI)
+		if (old_flags & IFF_ALLMULTI)
 			dev_set_allmulti(slave_dev, -1);
 
 		/* flush master's mc_list from slave */
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 504b4f0..18657a9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2783,6 +2783,20 @@ static bool tg3_phy_power_bug(struct tg3 *tp)
 	return false;
 }
 
+static bool tg3_phy_led_bug(struct tg3 *tp)
+{
+	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
+	case ASIC_REV_5719:
+	case ASIC_REV_5720:
+		if ((tp->phy_flags & TG3_PHYFLG_MII_SERDES) &&
+		    !tp->pci_fn)
+			return true;
+		return false;
+	}
+
+	return false;
+}
+
 static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 {
 	u32 val;
@@ -2827,8 +2841,9 @@ static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 		}
 		return;
 	} else if (do_low_power) {
-		tg3_writephy(tp, MII_TG3_EXT_CTRL,
-			     MII_TG3_EXT_CTRL_FORCE_LED_OFF);
+		if (!tg3_phy_led_bug(tp))
+			tg3_writephy(tp, MII_TG3_EXT_CTRL,
+				     MII_TG3_EXT_CTRL_FORCE_LED_OFF);
 
 		val = MII_TG3_AUXCTL_PCTL_100TX_LPWR |
 		      MII_TG3_AUXCTL_PCTL_SPR_ISOLATE |
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index ccc2b3b..285049f 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -394,7 +394,13 @@ static void gfar_init_mac(struct net_device *ndev)
 	if (ndev->features & NETIF_F_IP_CSUM)
 		tctrl |= TCTRL_INIT_CSUM;
 
-	tctrl |= TCTRL_TXSCHED_PRIO;
+	if (priv->prio_sched_en)
+		tctrl |= TCTRL_TXSCHED_PRIO;
+	else {
+		tctrl |= TCTRL_TXSCHED_WRRS;
+		gfar_write(&regs->tr03wt, DEFAULT_WRRS_WEIGHT);
+		gfar_write(&regs->tr47wt, DEFAULT_WRRS_WEIGHT);
+	}
 
 	gfar_write(&regs->tctrl, tctrl);
 
@@ -1153,6 +1159,9 @@ static int gfar_probe(struct platform_device *ofdev)
 	priv->rx_filer_enable = 1;
 	/* Enable most messages by default */
 	priv->msg_enable = (NETIF_MSG_IFUP << 1 ) - 1;
+	/* use pritority h/w tx queue scheduling for single queue devices */
+	if (priv->num_tx_queues == 1)
+		priv->prio_sched_en = 1;
 
 	/* Carrier starts down, phylib will bring it up */
 	netif_carrier_off(dev);
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 27d8aeb..22eabc1 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -301,8 +301,16 @@ extern const char gfar_driver_version[];
 #define TCTRL_TFCPAUSE		0x00000008
 #define TCTRL_TXSCHED_MASK	0x00000006
 #define TCTRL_TXSCHED_INIT	0x00000000
+/* priority scheduling */
 #define TCTRL_TXSCHED_PRIO	0x00000002
+/* weighted round-robin scheduling (WRRS) */
 #define TCTRL_TXSCHED_WRRS	0x00000004
+/* default WRRS weight and policy setting,
+ * tailored to the tr03wt and tr47wt registers:
+ * equal weight for all Tx Qs, measured in 64byte units
+ */
+#define DEFAULT_WRRS_WEIGHT	0x18181818
+
 #define TCTRL_INIT_CSUM		(TCTRL_TUCSEN | TCTRL_IPCSEN)
 
 #define IEVENT_INIT_CLEAR	0xffffffff
@@ -1096,7 +1104,8 @@ struct gfar_private {
 		extended_hash:1,
 		bd_stash_en:1,
 		rx_filer_enable:1,
-		wol_en:1; /* Wake-on-LAN enabled */
+		wol_en:1, /* Wake-on-LAN enabled */
+		prio_sched_en:1; /* Enable priorty based Tx scheduling in Hw */
 	unsigned short padding;
 
 	/* PHY stuff */
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index f8f7fc8..617e625 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -306,8 +306,9 @@ static void efx_resurrect_rx_buffer(struct efx_rx_queue *rx_queue,
 
 	index = rx_queue->added_count & rx_queue->ptr_mask;
 	new_buf = efx_rx_buffer(rx_queue, index);
-	new_buf->dma_addr = rx_buf->dma_addr ^ (PAGE_SIZE >> 1);
 	new_buf->u.page = rx_buf->u.page;
+	new_buf->page_offset = rx_buf->page_offset ^ (PAGE_SIZE >> 1);
+	new_buf->dma_addr = state->dma_addr + new_buf->page_offset;
 	new_buf->len = rx_buf->len;
 	new_buf->flags = EFX_RX_BUF_PAGE;
 	++rx_queue->added_count;
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 046526e0..4c1099e 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -32,7 +32,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME	"via-rhine"
-#define DRV_VERSION	"1.5.0"
+#define DRV_VERSION	"1.5.1"
 #define DRV_RELDATE	"2010-10-09"
 
 #include <linux/types.h>
@@ -1684,7 +1684,12 @@ static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
 		cpu_to_le32(TXDESC | (skb->len >= ETH_ZLEN ? skb->len : ETH_ZLEN));
 
 	if (unlikely(vlan_tx_tag_present(skb))) {
-		rp->tx_ring[entry].tx_status = cpu_to_le32((vlan_tx_tag_get(skb)) << 16);
+		u16 vid_pcp = vlan_tx_tag_get(skb);
+
+		/* drop CFI/DEI bit, register needs VID and PCP */
+		vid_pcp = (vid_pcp & VLAN_VID_MASK) |
+			  ((vid_pcp & VLAN_PRIO_MASK) >> 1);
+		rp->tx_ring[entry].tx_status = cpu_to_le32((vid_pcp) << 16);
 		/* request tagging */
 		rp->tx_ring[entry].desc_length |= cpu_to_le32(0x020000);
 	}
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1eaf712..26e487b 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -308,6 +308,12 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
 	lp->dma_out(lp, TX_CURDESC_PTR, lp->tx_bd_p);
 
+	/* Init descriptor indexes */
+	lp->tx_bd_ci = 0;
+	lp->tx_bd_next = 0;
+	lp->tx_bd_tail = 0;
+	lp->rx_bd_ci = 0;
+
 	return 0;
 
 out:
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 162464f..7f10588 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -281,7 +281,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	nf_reset(skb);
 
 	skb->ip_summed = CHECKSUM_NONE;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 	ip_send_check(iph);
 
 	ip_local_out(skb);
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index e7d4238..81182fb 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -707,6 +707,11 @@ static const struct usb_device_id	products [] = {
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE,
 	.driver_info = (unsigned long)&wwan_info,
 }, {
+	/* Telit modules */
+	USB_VENDOR_AND_INTERFACE_INFO(0x1bc7, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = (kernel_ulong_t) &wwan_info,
+}, {
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long) &cdc_info,
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index e0433ce..e55db3a 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -384,7 +384,7 @@ static void dm9601_set_multicast(struct net_device *net)
 		rx_ctl |= 0x02;
 	} else if (net->flags & IFF_ALLMULTI ||
 		   netdev_mc_count(net) > DM_MAX_MCAST) {
-		rx_ctl |= 0x04;
+		rx_ctl |= 0x08;
 	} else if (!netdev_mc_empty(net)) {
 		struct netdev_hw_addr *ha;
 
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index ab84eb9..8a0667c 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -153,7 +153,7 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
  */
 int
 mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
+			  struct mwifiex_ra_list_tbl *pra_list,
 			  int ptrindex, unsigned long ra_list_flags)
 			  __releases(&priv->wmm.ra_list_spinlock)
 {
@@ -163,6 +163,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	int pad = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
 
 	skb_src = skb_peek(&pra_list->skb_head);
 	if (!skb_src) {
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 900e1c6..892098d 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -26,7 +26,7 @@
 int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 				struct sk_buff *skb);
 int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			      struct mwifiex_ra_list_tbl *ptr, int headroom,
+			      struct mwifiex_ra_list_tbl *ptr,
 			      int ptr_index, unsigned long flags)
 			      __releases(&priv->wmm.ra_list_spinlock);
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4be4d43..20e50e5 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -571,9 +571,8 @@ static void mwifiex_set_multicast_list(struct net_device *dev)
 		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
 	} else {
 		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
-		if (netdev_mc_count(dev))
-			mcast_list.num_multicast_addr =
-				mwifiex_copy_mcast_addr(&mcast_list, dev);
+		mcast_list.num_multicast_addr =
+			mwifiex_copy_mcast_addr(&mcast_list, dev);
 	}
 	mwifiex_request_set_multicast_list(priv, &mcast_list);
 }
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fc6ae9b..2ea3a20 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -113,16 +113,14 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 		} else {
 			priv->curr_pkt_filter &=
 				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-			if (mcast_list->num_multicast_addr) {
-				dev_dbg(priv->adapter->dev,
-					"info: Set multicast list=%d\n",
-				       mcast_list->num_multicast_addr);
-				/* Send multicast addresses to firmware */
-				ret = mwifiex_send_cmd_async(priv,
-					HostCmd_CMD_MAC_MULTICAST_ADR,
-					HostCmd_ACT_GEN_SET, 0,
-					mcast_list);
-			}
+			dev_dbg(priv->adapter->dev,
+				"info: Set multicast list=%d\n",
+				mcast_list->num_multicast_addr);
+			/* Send multicast addresses to firmware */
+			ret = mwifiex_send_cmd_async(priv,
+				HostCmd_CMD_MAC_MULTICAST_ADR,
+				HostCmd_ACT_GEN_SET, 0,
+				mcast_list);
 		}
 	}
 	dev_dbg(priv->adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 22a5916..7fda0ab 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -446,9 +446,6 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	 */
 	adapter->is_suspended = true;
 
-	for (i = 0; i < adapter->priv_num; i++)
-		netif_carrier_off(adapter->priv[i]->netdev);
-
 	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
 		usb_kill_urb(card->rx_cmd.urb);
 
@@ -508,10 +505,6 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 						  MWIFIEX_RX_CMD_BUF_SIZE);
 	}
 
-	for (i = 0; i < adapter->priv_num; i++)
-		if (adapter->priv[i]->media_connected)
-			netif_carrier_on(adapter->priv[i]->netdev);
-
 	/* Disable Host Sleep */
 	if (adapter->hs_activated)
 		mwifiex_cancel_hs(mwifiex_get_priv(adapter,
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 3fa4d41..8ac61da 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1246,8 +1246,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		if (mwifiex_is_amsdu_allowed(priv, tid) &&
 		    mwifiex_is_11n_aggragation_possible(priv, ptr,
 							adapter->tx_buf_size))
-			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
-						  ptr_index, flags);
+			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_11n_aggregate_pkt() */
 		else
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 3d4dd4d..a8f1702d 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -83,6 +83,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x07aa, 0x0020)},	/* Corega WLUSB2GTST USB */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index cdaa21f..dec7c55 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1701,7 +1701,7 @@ struct rtl_priv {
 	   that it points to the data allocated
 	   beyond  this structure like:
 	   rtl_pci_priv or rtl_usb_priv */
-	u8 priv[0];
+	u8 priv[0] __aligned(sizeof(void *));
 };
 
 #define rtl_priv(hw)		(((struct rtl_priv *)(hw)->priv))
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 34552bf..55548dc 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -530,7 +530,7 @@ static int esp_need_to_nego_sync(struct esp_target_data *tp)
 static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 			     struct esp_lun_data *lp)
 {
-	if (!ent->tag[0]) {
+	if (!ent->orig_tag[0]) {
 		/* Non-tagged, slot already taken?  */
 		if (lp->non_tagged_cmd)
 			return -EBUSY;
@@ -564,9 +564,9 @@ static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 			return -EBUSY;
 	}
 
-	BUG_ON(lp->tagged_cmds[ent->tag[1]]);
+	BUG_ON(lp->tagged_cmds[ent->orig_tag[1]]);
 
-	lp->tagged_cmds[ent->tag[1]] = ent;
+	lp->tagged_cmds[ent->orig_tag[1]] = ent;
 	lp->num_tagged++;
 
 	return 0;
@@ -575,9 +575,9 @@ static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 static void esp_free_lun_tag(struct esp_cmd_entry *ent,
 			     struct esp_lun_data *lp)
 {
-	if (ent->tag[0]) {
-		BUG_ON(lp->tagged_cmds[ent->tag[1]] != ent);
-		lp->tagged_cmds[ent->tag[1]] = NULL;
+	if (ent->orig_tag[0]) {
+		BUG_ON(lp->tagged_cmds[ent->orig_tag[1]] != ent);
+		lp->tagged_cmds[ent->orig_tag[1]] = NULL;
 		lp->num_tagged--;
 	} else {
 		BUG_ON(lp->non_tagged_cmd != ent);
@@ -667,6 +667,8 @@ static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
 			ent->tag[0] = 0;
 			ent->tag[1] = 0;
 		}
+		ent->orig_tag[0] = ent->tag[0];
+		ent->orig_tag[1] = ent->tag[1];
 
 		if (esp_alloc_lun_tag(ent, lp) < 0)
 			continue;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 28e22ac..cd68805 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -271,6 +271,7 @@ struct esp_cmd_entry {
 #define ESP_CMD_FLAG_AUTOSENSE	0x04 /* Doing automatic REQUEST_SENSE */
 
 	u8			tag[2];
+	u8			orig_tag[2];
 
 	u8			status;
 	u8			message;
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 0d27a93..c36efe0 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -411,29 +411,25 @@ static int ni_65xx_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-	unsigned base_bitfield_channel;
-	const unsigned max_ports_per_bitfield = 5;
+	int base_bitfield_channel;
 	unsigned read_bits = 0;
-	unsigned j;
+	int last_port_offset = ni_65xx_port_by_channel(s->n_chan - 1);
+	int port_offset;
+
 	if (insn->n != 2)
 		return -EINVAL;
 	base_bitfield_channel = CR_CHAN(insn->chanspec);
-	for (j = 0; j < max_ports_per_bitfield; ++j) {
-		const unsigned port_offset =
-			ni_65xx_port_by_channel(base_bitfield_channel) + j;
-		const unsigned port =
-			sprivate(s)->base_port + port_offset;
-		unsigned base_port_channel;
+	for (port_offset = ni_65xx_port_by_channel(base_bitfield_channel);
+	     port_offset <= last_port_offset; port_offset++) {
+		unsigned port = sprivate(s)->base_port + port_offset;
+		int base_port_channel = port_offset * ni_65xx_channels_per_port;
 		unsigned port_mask, port_data, port_read_bits;
-		int bitshift;
-		if (port >= ni_65xx_total_num_ports(board(dev)))
+		int bitshift = base_port_channel - base_bitfield_channel;
+
+		if (bitshift >= 32)
 			break;
-		base_port_channel = port_offset * ni_65xx_channels_per_port;
 		port_mask = data[0];
 		port_data = data[1];
-		bitshift = base_port_channel - base_bitfield_channel;
-		if (bitshift >= 32 || bitshift <= -32)
-			break;
 		if (bitshift > 0) {
 			port_mask >>= bitshift;
 			port_data >>= bitshift;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fa6dbe0..c829863 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1220,6 +1220,8 @@ device_release_WPADEV(pDevice);
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
+	pDevice->flags &= ~DEVICE_FLAGS_OPENED;
+
     device_free_tx_bufs(pDevice);
     device_free_rx_bufs(pDevice);
     device_free_int_bufs(pDevice);
@@ -1231,7 +1233,6 @@ device_release_WPADEV(pDevice);
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
-    pDevice->flags &=(~DEVICE_FLAGS_OPENED);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close2 \n");
 
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4798e94..206c58c 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -643,11 +643,12 @@ static int dma_push_rx(struct eg20t_port *priv, int size)
 		dev_warn(port->dev, "Rx overrun: dropping %u bytes\n",
 			 size - room);
 	if (!room)
-		return room;
+		goto out;
 
 	tty_insert_flip_string(tty, sg_virt(&priv->sg_rx), size);
 
 	port->icount.rx += room;
+out:
 	tty_kref_put(tty);
 
 	return room;
@@ -1064,6 +1065,8 @@ static void pch_uart_err_ir(struct eg20t_port *priv, unsigned int lsr)
 	if (tty == NULL) {
 		for (i = 0; error_msg[i] != NULL; i++)
 			dev_err(&priv->pdev->dev, error_msg[i]);
+	} else {
+		tty_kref_put(tty);
 	}
 }
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index f70b887..ea97827 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -684,6 +684,22 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 		if ((index & ~USB_DIR_IN) == 0)
 			return 0;
 		ret = findintfep(ps->dev, index);
+		if (ret < 0) {
+			/*
+			 * Some not fully compliant Win apps seem to get
+			 * index wrong and have the endpoint number here
+			 * rather than the endpoint address (with the
+			 * correct direction). Win does let this through,
+			 * so we'll not reject it here but leave it to
+			 * the device to not break KVM. But we warn.
+			 */
+			ret = findintfep(ps->dev, index ^ 0x80);
+			if (ret >= 0)
+				dev_info(&ps->dev->dev,
+					"%s: process %i (%s) requesting ep %02x but needs %02x\n",
+					__func__, task_pid_nr(current),
+					current->comm, index, index ^ 0x80);
+		}
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
 		break;
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index a9ca9ad..5699bc4 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -47,6 +47,7 @@
 /* FIXME define these in <linux/pci_ids.h> */
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
+#define PCI_DEVICE_ID_INTEL_BYT		0x0f37
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -155,6 +156,7 @@ static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_id_table) = {
 		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS,
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 4ad1f1c..1e0f8cd 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -921,8 +921,9 @@ static int dummy_udc_stop(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
-			driver->driver.name);
+	if (driver)
+		dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
+				driver->driver.name);
 
 	dum->driver = NULL;
 
@@ -1011,9 +1012,9 @@ static int dummy_udc_remove(struct platform_device *pdev)
 {
 	struct dummy	*dum = platform_get_drvdata(pdev);
 
-	usb_del_gadget_udc(&dum->gadget);
 	platform_set_drvdata(pdev, NULL);
 	device_remove_file(&dum->gadget.dev, &dev_attr_function);
+	usb_del_gadget_udc(&dum->gadget);
 	device_unregister(&dum->gadget.dev);
 	return 0;
 }
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index dcd1c7f..3df7513 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1031,37 +1031,19 @@ struct ffs_sb_fill_data {
 	struct ffs_file_perms perms;
 	umode_t root_mode;
 	const char *dev_name;
-	union {
-		/* set by ffs_fs_mount(), read by ffs_sb_fill() */
-		void *private_data;
-		/* set by ffs_sb_fill(), read by ffs_fs_mount */
-		struct ffs_data *ffs_data;
-	};
+	struct ffs_data *ffs_data;
 };
 
 static int ffs_sb_fill(struct super_block *sb, void *_data, int silent)
 {
 	struct ffs_sb_fill_data *data = _data;
 	struct inode	*inode;
-	struct ffs_data	*ffs;
+	struct ffs_data	*ffs = data->ffs_data;
 
 	ENTER();
 
-	/* Initialise data */
-	ffs = ffs_data_new();
-	if (unlikely(!ffs))
-		goto Enomem;
-
 	ffs->sb              = sb;
-	ffs->dev_name        = kstrdup(data->dev_name, GFP_KERNEL);
-	if (unlikely(!ffs->dev_name))
-		goto Enomem;
-	ffs->file_perms      = data->perms;
-	ffs->private_data    = data->private_data;
-
-	/* used by the caller of this function */
-	data->ffs_data       = ffs;
-
+	data->ffs_data       = NULL;
 	sb->s_fs_info        = ffs;
 	sb->s_blocksize      = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -1077,17 +1059,14 @@ static int ffs_sb_fill(struct super_block *sb, void *_data, int silent)
 				  &data->perms);
 	sb->s_root = d_make_root(inode);
 	if (unlikely(!sb->s_root))
-		goto Enomem;
+		return -ENOMEM;
 
 	/* EP0 file */
 	if (unlikely(!ffs_sb_create_file(sb, "ep0", ffs,
 					 &ffs_ep0_operations, NULL)))
-		goto Enomem;
+		return -ENOMEM;
 
 	return 0;
-
-Enomem:
-	return -ENOMEM;
 }
 
 static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
@@ -1182,6 +1161,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	struct dentry *rv;
 	int ret;
 	void *ffs_dev;
+	struct ffs_data	*ffs;
 
 	ENTER();
 
@@ -1189,18 +1169,30 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	if (unlikely(ret < 0))
 		return ERR_PTR(ret);
 
+	ffs = ffs_data_new();
+	if (unlikely(!ffs))
+		return ERR_PTR(-ENOMEM);
+	ffs->file_perms = data.perms;
+
+	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
+	if (unlikely(!ffs->dev_name)) {
+		ffs_data_put(ffs);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	ffs_dev = functionfs_acquire_dev_callback(dev_name);
-	if (IS_ERR(ffs_dev))
-		return ffs_dev;
+	if (IS_ERR(ffs_dev)) {
+		ffs_data_put(ffs);
+		return ERR_CAST(ffs_dev);
+	}
+	ffs->private_data = ffs_dev;
+	data.ffs_data = ffs;
 
-	data.dev_name = dev_name;
-	data.private_data = ffs_dev;
 	rv = mount_nodev(t, flags, &data, ffs_sb_fill);
-
-	/* data.ffs_data is set by ffs_sb_fill */
-	if (IS_ERR(rv))
+	if (IS_ERR(rv) && data.ffs_data) {
 		functionfs_release_dev_callback(data.ffs_data);
-
+		ffs_data_put(data.ffs_data);
+	}
 	return rv;
 }
 
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 0909783..3302c27 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -549,7 +549,7 @@ static struct pci_driver ehci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	.shutdown = 	usb_hcd_pci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
index c300bd2f7..0f228c4 100644
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -293,7 +293,7 @@ static struct pci_driver uhci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	.shutdown =	uhci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 7534bb4..b83a7b8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -287,7 +287,7 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue)
 			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
 	}
-	cmd->command_trb = xhci->cmd_ring->enqueue;
+	cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
 	xhci_queue_stop_endpoint(xhci, slot_id, 0, suspend);
 	xhci_ring_cmd_db(xhci);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index be08444..5e3ef3e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -343,7 +343,7 @@ static struct pci_driver xhci_pci_driver = {
 	/* suspend and resume implemented later */
 
 	.shutdown = 	usb_hcd_pci_shutdown,
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver = {
 		.pm = &usb_hcd_pci_pm_ops
 	},
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 37cecce..fde2282 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -122,6 +122,16 @@ static int enqueue_is_link_trb(struct xhci_ring *ring)
 	return TRB_TYPE_LINK_LE32(link->control);
 }
 
+union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring)
+{
+	/* Enqueue pointer can be left pointing to the link TRB,
+	 * we must handle that
+	 */
+	if (TRB_TYPE_LINK_LE32(ring->enqueue->link.control))
+		return ring->enq_seg->next->trbs;
+	return ring->enqueue;
+}
+
 /* Updates trb to point to the next TRB in the ring, and updates seg if the next
  * TRB is in a new segment.  This does not skip over link TRBs, and it does not
  * effect the ring dequeue or enqueue pointers.
@@ -847,8 +857,12 @@ remove_finished_td:
 		/* Otherwise ring the doorbell(s) to restart queued transfers */
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
-	ep->stopped_td = NULL;
-	ep->stopped_trb = NULL;
+
+	/* Clear stopped_td and stopped_trb if endpoint is not halted */
+	if (!(ep->ep_state & EP_HALTED)) {
+		ep->stopped_td = NULL;
+		ep->stopped_trb = NULL;
+	}
 
 	/*
 	 * Drop the lock and complete the URBs in the cancelled TD list.
@@ -1390,6 +1404,12 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 			inc_deq(xhci, xhci->cmd_ring);
 			return;
 		}
+		/* There is no command to handle if we get a stop event when the
+		 * command ring is empty, event->cmd_trb points to the next
+		 * unset command
+		 */
+		if (xhci->cmd_ring->dequeue == xhci->cmd_ring->enqueue)
+			return;
 	}
 
 	switch (le32_to_cpu(xhci->cmd_ring->dequeue->generic.field[3])
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2acae4d..eb31daa 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2582,15 +2582,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	if (command) {
 		cmd_completion = command->completion;
 		cmd_status = &command->status;
-		command->command_trb = xhci->cmd_ring->enqueue;
-
-		/* Enqueue pointer can be left pointing to the link TRB,
-		 * we must handle that
-		 */
-		if (TRB_TYPE_LINK_LE32(command->command_trb->link.control))
-			command->command_trb =
-				xhci->cmd_ring->enq_seg->next->trbs;
-
+		command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 		list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
 	} else {
 		cmd_completion = &virt_dev->cmd_completion;
@@ -2598,7 +2590,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	}
 	init_completion(cmd_completion);
 
-	cmd_trb = xhci->cmd_ring->dequeue;
+	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	if (!ctx_change)
 		ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,
 				udev->slot_id, must_succeed);
@@ -3383,14 +3375,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 
 	/* Attempt to submit the Reset Device command to the command ring */
 	spin_lock_irqsave(&xhci->lock, flags);
-	reset_device_cmd->command_trb = xhci->cmd_ring->enqueue;
-
-	/* Enqueue pointer can be left pointing to the link TRB,
-	 * we must handle that
-	 */
-	if (TRB_TYPE_LINK_LE32(reset_device_cmd->command_trb->link.control))
-		reset_device_cmd->command_trb =
-			xhci->cmd_ring->enq_seg->next->trbs;
+	reset_device_cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 
 	list_add_tail(&reset_device_cmd->cmd_list, &virt_dev->cmd_list);
 	ret = xhci_queue_reset_device(xhci, slot_id);
@@ -3594,7 +3579,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	union xhci_trb *cmd_trb;
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	cmd_trb = xhci->cmd_ring->dequeue;
+	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	ret = xhci_queue_slot_control(xhci, TRB_ENABLE_SLOT, 0);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
@@ -3721,7 +3706,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx, 2);
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	cmd_trb = xhci->cmd_ring->dequeue;
+	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	ret = xhci_queue_address_device(xhci, virt_dev->in_ctx->dma,
 					udev->slot_id);
 	if (ret) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 30c3a1d..9a97918 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1819,6 +1819,7 @@ int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
 		union xhci_trb *cmd_trb);
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, unsigned int stream_id);
+union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring);
 
 /* xHCI roothub code */
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 7785df0..d0c2d20 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -81,6 +81,7 @@ static void option_instat_callback(struct urb *urb);
 
 #define HUAWEI_VENDOR_ID			0x12D1
 #define HUAWEI_PRODUCT_E173			0x140C
+#define HUAWEI_PRODUCT_E1750			0x1406
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
@@ -581,6 +582,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1750, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1441, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1442, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff),
diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index fc2c4381..dc7b4fc 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -616,6 +616,7 @@ static int __devinit mxsfb_restore_mode(struct mxsfb_info *host)
 		break;
 	case 3:
 		bits_per_pixel = 32;
+		break;
 	case 1:
 	default:
 		return -EINVAL;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 43a35db..27a99f7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2432,7 +2432,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	int err = 0;
 
 	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle))
+	if (handle && !ext4_handle_valid(handle) &&
+	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 29037c3..e92a342 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -119,8 +119,8 @@ static void destroy_inodecache(void)
 
 static int isofs_remount(struct super_block *sb, int *flags, char *data)
 {
-	/* we probably want a lot more here */
-	*flags |= MS_RDONLY;
+	if (!(*flags & MS_RDONLY))
+		return -EROFS;
 	return 0;
 }
 
@@ -769,15 +769,6 @@ root_found:
 	 */
 	s->s_maxbytes = 0x80000000000LL;
 
-	/*
-	 * The CDROM is read-only, has no nodes (devices) on it, and since
-	 * all of the files appear to be owned by root, we really do not want
-	 * to allow suid.  (suid or devices will not show up unless we have
-	 * Rock Ridge extensions)
-	 */
-
-	s->s_flags |= MS_RDONLY /* | MS_NODEV | MS_NOSUID */;
-
 	/* Set this for reference. Its not currently used except on write
 	   which we don't have .. */
 
@@ -1536,6 +1527,9 @@ struct inode *isofs_iget(struct super_block *sb,
 static struct dentry *isofs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
+	/* We don't support read-write mounts */
+	if (!(flags & MS_RDONLY))
+		return ERR_PTR(-EACCES);
 	return mount_bdev(fs_type, flags, dev_name, data, isofs_fill_super);
 }
 
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index a506360..0c2f912 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -18,6 +18,12 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 	    old->tgid == new->tgid) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_PATH):
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+			/* dont merge two permission events */
+			if ((old->mask & FAN_ALL_PERM_EVENTS) &&
+			    (new->mask & FAN_ALL_PERM_EVENTS))
+				return false;
+#endif
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 69b6e30..be1afbc 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -378,6 +378,7 @@ struct hid_collection {
 struct hid_usage {
 	unsigned  hid;			/* hid usage code */
 	unsigned  collection_index;	/* index into collection array */
+	unsigned  usage_index;		/* index into usage array */
 	/* hidinput data */
 	__u16     code;			/* input driver code */
 	__u8      type;			/* input driver type */
@@ -745,6 +746,10 @@ void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
+struct hid_report *hid_validate_values(struct hid_device *hid,
+				       unsigned int type, unsigned int id,
+				       unsigned int field_index,
+				       unsigned int report_counts);
 int hid_open_report(struct hid_device *device);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c65c7d1..3faf0d4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1065,7 +1065,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
-	struct pmu			*active_pmu;
+	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
 
diff --git a/include/net/ip.h b/include/net/ip.h
index 83e0619..d34f531 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -246,9 +246,11 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
 
 extern void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more);
 
-static inline void ip_select_ident(struct iphdr *iph, struct dst_entry *dst, struct sock *sk)
+static inline void ip_select_ident(struct sk_buff *skb, struct dst_entry *dst, struct sock *sk)
 {
-	if (iph->frag_off & htons(IP_DF)) {
+	struct iphdr *iph = ip_hdr(skb);
+
+	if ((iph->frag_off & htons(IP_DF)) && !skb->local_df) {
 		/* This is only to work around buggy Windows95/2000
 		 * VJ compression implementations.  If the ID field
 		 * does not change, they drop every other packet in
@@ -260,9 +262,11 @@ static inline void ip_select_ident(struct iphdr *iph, struct dst_entry *dst, str
 		__ip_select_ident(iph, dst, 0);
 }
 
-static inline void ip_select_ident_more(struct iphdr *iph, struct dst_entry *dst, struct sock *sk, int more)
+static inline void ip_select_ident_more(struct sk_buff *skb, struct dst_entry *dst, struct sock *sk, int more)
 {
-	if (iph->frag_off & htons(IP_DF)) {
+	struct iphdr *iph = ip_hdr(skb);
+
+	if ((iph->frag_off & htons(IP_DF)) && !skb->local_df) {
 		if (sk && inet_sk(sk)->inet_daddr) {
 			iph->id = htons(inet_sk(sk)->inet_id);
 			inet_sk(sk)->inet_id += 1 + more;
diff --git a/include/net/ipip.h b/include/net/ipip.h
index a93cf6d..1157ab8 100644
--- a/include/net/ipip.h
+++ b/include/net/ipip.h
@@ -50,7 +50,7 @@ struct ip_tunnel_prl_entry {
 	int pkt_len = skb->len - skb_transport_offset(skb);		\
 									\
 	skb->ip_summed = CHECKSUM_NONE;					\
-	ip_select_ident(iph, &rt->dst, NULL);				\
+	ip_select_ident(skb, &rt->dst, NULL);				\
 									\
 	err = ip_local_out(skb);					\
 	if (likely(net_xmit_eval(err) == 0)) {				\
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3b3fa5b..7720f52 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3712,6 +3712,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3767,6 +3768,16 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 		goto fail;
 	}
 
+	/*
+	 * The file to be monitored must be in the same cgroup as
+	 * cgroup.event_control is.
+	 */
+	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
+	if (cgrp_cfile != cgrp) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	if (!event->cft->register_event || !event->cft->unregister_event) {
 		ret = -EINVAL;
 		goto fail;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd815c3..3ea14c1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -368,6 +368,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->unique_pmu != pmu)
+			continue; /* ensure we process each cpuctx once */
 
 		/*
 		 * perf_cgroup_events says at least one
@@ -391,9 +393,10 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 
 			if (mode & PERF_CGROUP_SWIN) {
 				WARN_ON_ONCE(cpuctx->cgrp);
-				/* set cgrp before ctxsw in to
-				 * allow event_filter_match() to not
-				 * have to pass task around
+				/*
+				 * set cgrp before ctxsw in to allow
+				 * event_filter_match() to not have to pass
+				 * task around
 				 */
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
@@ -4331,7 +4334,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
@@ -4477,7 +4480,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
@@ -4673,7 +4676,7 @@ got_name:
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
@@ -5748,8 +5751,8 @@ static void update_pmu_context(struct pmu *pmu, struct pmu *old_pmu)
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 
-		if (cpuctx->active_pmu == old_pmu)
-			cpuctx->active_pmu = pmu;
+		if (cpuctx->unique_pmu == old_pmu)
+			cpuctx->unique_pmu = pmu;
 	}
 }
 
@@ -5885,7 +5888,7 @@ skip_type:
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
-		cpuctx->active_pmu = pmu;
+		cpuctx->unique_pmu = pmu;
 	}
 
 got_cpu_context:
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eb12b9e..811a254 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4929,11 +4929,15 @@ static void task_fork_fair(struct task_struct *p)
 	cfs_rq = task_cfs_rq(current);
 	curr = cfs_rq->curr;
 
-	if (unlikely(task_cpu(p) != this_cpu)) {
-		rcu_read_lock();
-		__set_task_cpu(p, this_cpu);
-		rcu_read_unlock();
-	}
+	/*
+	 * Not only the cpu but also the task_group of the parent might have
+	 * been changed after parent->se.parent,cfs_rq were copied to
+	 * child->se.parent,cfs_rq. So call __set_task_cpu() to make those
+	 * of child point to valid ones.
+	 */
+	rcu_read_lock();
+	__set_task_cpu(p, this_cpu);
+	rcu_read_unlock();
 
 	update_curr(cfs_rq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0395ca8..89743ae 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1920,6 +1920,15 @@ __acquires(&gcwq->lock)
 		dump_stack();
 	}
 
+	/*
+	 * The following prevents a kworker from hogging CPU on !PREEMPT
+	 * kernels, where a requeueing work item waiting for something to
+	 * happen could deadlock with stop_machine as such work item could
+	 * indefinitely requeue itself while all other CPUs are trapped in
+	 * stop_machine.
+	 */
+	cond_resched();
+
 	spin_lock_irq(&gcwq->lock);
 
 	/* clear cpu intensive status */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ac300c9..b45c813 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -549,11 +549,11 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct task_struct *p;
 
 	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current)) {
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 843d048..7797c9d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3452,7 +3452,11 @@ static inline void hci_le_ltk_request_evt(struct hci_dev *hdev,
 	cp.handle = cpu_to_le16(conn->handle);
 
 	if (ltk->authenticated)
-		conn->sec_level = BT_SECURITY_HIGH;
+		conn->pending_sec_level = BT_SECURITY_HIGH;
+	else
+		conn->pending_sec_level = BT_SECURITY_MEDIUM;
+
+	conn->enc_key_size = ltk->enc_size;
 
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a768b24..68d9266 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -512,6 +512,7 @@ extern struct net_bridge_port *br_get_port(struct net_bridge *br,
 extern void br_init_port(struct net_bridge_port *p);
 extern void br_become_designated_port(struct net_bridge_port *p);
 
+extern void __br_set_forward_delay(struct net_bridge *br, unsigned long t);
 extern int br_set_forward_delay(struct net_bridge *br, unsigned long x);
 extern int br_set_hello_time(struct net_bridge *br, unsigned long x);
 extern int br_set_max_age(struct net_bridge *br, unsigned long x);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index af9a120..73920c2 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -189,7 +189,7 @@ static void br_record_config_information(struct net_bridge_port *p,
 	p->designated_age = jiffies - bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
-		  + (p->br->max_age - bpdu->message_age));
+		  + (bpdu->max_age - bpdu->message_age));
 }
 
 /* called under bridge lock */
@@ -517,18 +517,27 @@ int br_set_max_age(struct net_bridge *br, unsigned long val)
 
 }
 
+void __br_set_forward_delay(struct net_bridge *br, unsigned long t)
+{
+	br->bridge_forward_delay = t;
+	if (br_is_root_bridge(br))
+		br->forward_delay = br->bridge_forward_delay;
+}
+
 int br_set_forward_delay(struct net_bridge *br, unsigned long val)
 {
 	unsigned long t = clock_t_to_jiffies(val);
+	int err = -ERANGE;
 
+	spin_lock_bh(&br->lock);
 	if (br->stp_enabled != BR_NO_STP &&
 	    (t < BR_MIN_FORWARD_DELAY || t > BR_MAX_FORWARD_DELAY))
-		return -ERANGE;
+		goto unlock;
 
-	spin_lock_bh(&br->lock);
-	br->bridge_forward_delay = t;
-	if (br_is_root_bridge(br))
-		br->forward_delay = br->bridge_forward_delay;
+	__br_set_forward_delay(br, t);
+	err = 0;
+
+unlock:
 	spin_unlock_bh(&br->lock);
-	return 0;
+	return err;
 }
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 9d5a414..7ba2ed5 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -129,6 +129,14 @@ static void br_stp_start(struct net_bridge *br)
 	char *envp[] = { NULL };
 
 	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
+
+	spin_lock_bh(&br->lock);
+
+	if (br->bridge_forward_delay < BR_MIN_FORWARD_DELAY)
+		__br_set_forward_delay(br, BR_MIN_FORWARD_DELAY);
+	else if (br->bridge_forward_delay < BR_MAX_FORWARD_DELAY)
+		__br_set_forward_delay(br, BR_MAX_FORWARD_DELAY);
+
 	if (r == 0) {
 		br->stp_enabled = BR_USER_STP;
 		br_debug(br, "userspace STP started\n");
@@ -137,10 +145,10 @@ static void br_stp_start(struct net_bridge *br)
 		br_debug(br, "using kernel STP\n");
 
 		/* To start timers on any ports left in blocking */
-		spin_lock_bh(&br->lock);
 		br_port_state_selection(br);
-		spin_unlock_bh(&br->lock);
 	}
+
+	spin_unlock_bh(&br->lock);
 }
 
 static void br_stp_stop(struct net_bridge *br)
diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 047cd0e..61fe8d2 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -291,9 +291,10 @@ int cfctrl_linkup_request(struct cflayer *layer,
 
 		count = cfctrl_cancel_req(&cfctrl->serv.layer,
 						user_layer);
-		if (count != 1)
+		if (count != 1) {
 			pr_err("Could not remove request (%d)", count);
 			return -ENODEV;
+		}
 	}
 	return 0;
 }
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index a225089..2774788 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -133,8 +133,8 @@ ipv6:
 	if (poff >= 0) {
 		__be32 *ports, _ports;
 
-		nhoff += poff;
-		ports = skb_header_pointer(skb, nhoff, sizeof(_ports), &_ports);
+		ports = skb_header_pointer(skb, nhoff + poff,
+					   sizeof(_ports), &_ports);
 		if (ports)
 			flow->ports = *ports;
 	}
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index f9f40b9..5e81c49 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -920,15 +920,14 @@ EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 
 void netpoll_cleanup(struct netpoll *np)
 {
-	if (!np->dev)
-		return;
-
 	rtnl_lock();
+	if (!np->dev)
+		goto out;
 	__netpoll_cleanup(np);
-	rtnl_unlock();
-
 	dev_put(np->dev);
 	np->dev = NULL;
+out:
+	rtnl_unlock();
 }
 EXPORT_SYMBOL(netpoll_cleanup);
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6699f23..be7dba8 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -343,7 +343,7 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, int size)
 	pip->saddr    = fl4.saddr;
 	pip->protocol = IPPROTO_IGMP;
 	pip->tot_len  = 0;	/* filled in later */
-	ip_select_ident(pip, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 	((u8 *)&pip[1])[0] = IPOPT_RA;
 	((u8 *)&pip[1])[1] = 4;
 	((u8 *)&pip[1])[2] = 0;
@@ -687,7 +687,7 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	iph->daddr    = dst;
 	iph->saddr    = fl4.saddr;
 	iph->protocol = IPPROTO_IGMP;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 	((u8 *)&iph[1])[0] = IPOPT_RA;
 	((u8 *)&iph[1])[1] = 4;
 	((u8 *)&iph[1])[2] = 0;
@@ -709,7 +709,7 @@ static void igmp_gq_timer_expire(unsigned long data)
 
 	in_dev->mr_gq_running = 0;
 	igmpv3_send_report(in_dev, NULL);
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_timer_expire(unsigned long data)
@@ -721,7 +721,7 @@ static void igmp_ifc_timer_expire(unsigned long data)
 		in_dev->mr_ifc_count--;
 		igmp_ifc_start_timer(in_dev, IGMP_Unsolicited_Report_Interval);
 	}
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_event(struct in_device *in_dev)
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index dfba343..d63a926 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -32,8 +32,8 @@
  *  At the moment of writing this notes identifier of IP packets is generated
  *  to be unpredictable using this code only for packets subjected
  *  (actually or potentially) to defragmentation.  I.e. DF packets less than
- *  PMTU in size uses a constant ID and do not use this code (see
- *  ip_select_ident() in include/net/ip.h).
+ *  PMTU in size when local fragmentation is disabled use a constant ID and do
+ *  not use this code (see ip_select_ident() in include/net/ip.h).
  *
  *  Route cache entries hold references to our nodes.
  *  New cache entries get references via lookup by destination IP address in
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 451f97c..7ee32c6 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -161,7 +161,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	ip_select_ident(iph, &rt->dst, sk);
+	ip_select_ident(skb, &rt->dst, sk);
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
@@ -403,7 +403,7 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
-	ip_select_ident_more(iph, &rt->dst, sk,
+	ip_select_ident_more(skb, &rt->dst, sk,
 			     (skb_shinfo(skb)->gso_segs ?: 1) - 1);
 
 	skb->priority = sk->sk_priority;
@@ -1342,12 +1342,12 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	else
 		ttl = ip_select_ttl(inet, &rt->dst);
 
-	iph = (struct iphdr *)skb->data;
+	iph = ip_hdr(skb);
 	iph->version = 4;
 	iph->ihl = 5;
 	iph->tos = inet->tos;
 	iph->frag_off = df;
-	ip_select_ident(iph, &rt->dst, sk);
+	ip_select_ident(skb, &rt->dst, sk);
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 9be3d17..f780fa3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1572,7 +1572,7 @@ static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
 	iph->protocol	=	IPPROTO_IPIP;
 	iph->ihl	=	5;
 	iph->tot_len	=	htons(skb->len);
-	ip_select_ident(iph, skb_dst(skb), NULL);
+	ip_select_ident(skb, skb_dst(skb), NULL);
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index d53aa77..0753bd7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -384,7 +384,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 		iph->check   = 0;
 		iph->tot_len = htons(length);
 		if (!iph->id)
-			ip_select_ident(iph, &rt->dst, NULL);
+			ip_select_ident(skb, &rt->dst, NULL);
 
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index ed4bf11..938553e 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -54,7 +54,7 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
-	ip_select_ident(top_iph, dst->child, NULL);
+	ip_select_ident(skb, dst->child, NULL);
 
 	top_iph->ttl = ip4_dst_hoplimit(dst->child);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8fa50aa..d00f1ad 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1135,6 +1135,8 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 	 * udp datagram
 	 */
 	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL) {
+		struct frag_hdr fhdr;
+
 		skb = sock_alloc_send_skb(sk,
 			hh_len + fragheaderlen + transhdrlen + 20,
 			(flags & MSG_DONTWAIT), &err);
@@ -1155,12 +1157,6 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum = 0;
-	}
-
-	err = skb_append_datato_frags(sk,skb, getfrag, from,
-				      (length - transhdrlen));
-	if (!err) {
-		struct frag_hdr fhdr;
 
 		/* Specify the length of each IPv6 datagram fragment.
 		 * It has to be a multiple of 8.
@@ -1171,15 +1167,10 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 		ipv6_select_ident(&fhdr, rt);
 		skb_shinfo(skb)->ip6_frag_id = fhdr.identification;
 		__skb_queue_tail(&sk->sk_write_queue, skb);
-
-		return 0;
 	}
-	/* There is not enough support do UPD LSO,
-	 * so follow normal path
-	 */
-	kfree_skb(skb);
 
-	return err;
+	return skb_append_datato_frags(sk, skb, getfrag, from,
+				       (length - transhdrlen));
 }
 
 static inline struct ipv6_opt_hdr *ip6_opt_dup(struct ipv6_opt_hdr *src,
@@ -1351,27 +1342,27 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	 * --yoshfuji
 	 */
 
-	cork->length += length;
-	if (length > mtu) {
-		int proto = sk->sk_protocol;
-		if (dontfrag && (proto == IPPROTO_UDP || proto == IPPROTO_RAW)){
-			ipv6_local_rxpmtu(sk, fl6, mtu-exthdrlen);
-			return -EMSGSIZE;
-		}
-
-		if (proto == IPPROTO_UDP &&
-		    (rt->dst.dev->features & NETIF_F_UFO)) {
+	if ((length > mtu) && dontfrag && (sk->sk_protocol == IPPROTO_UDP ||
+					   sk->sk_protocol == IPPROTO_RAW)) {
+		ipv6_local_rxpmtu(sk, fl6, mtu-exthdrlen);
+		return -EMSGSIZE;
+	}
 
-			err = ip6_ufo_append_data(sk, getfrag, from, length,
-						  hh_len, fragheaderlen,
-						  transhdrlen, mtu, flags, rt);
-			if (err)
-				goto error;
-			return 0;
-		}
+	skb = skb_peek_tail(&sk->sk_write_queue);
+	cork->length += length;
+	if (((length > mtu) ||
+	     (skb && skb_is_gso(skb))) &&
+	    (sk->sk_protocol == IPPROTO_UDP) &&
+	    (rt->dst.dev->features & NETIF_F_UFO)) {
+		err = ip6_ufo_append_data(sk, getfrag, from, length,
+					  hh_len, fragheaderlen,
+					  transhdrlen, mtu, flags, rt);
+		if (err)
+			goto error;
+		return 0;
 	}
 
-	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL)
+	if (!skb)
 		goto alloc_new_skb;
 
 	while (length > 0) {
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 2e97228..4441a0f 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2149,7 +2149,7 @@ static void mld_gq_timer_expire(unsigned long data)
 
 	idev->mc_gq_running = 0;
 	mld_send_report(idev, NULL);
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_timer_expire(unsigned long data)
@@ -2162,7 +2162,7 @@ static void mld_ifc_timer_expire(unsigned long data)
 		if (idev->mc_ifc_count)
 			mld_ifc_start_timer(idev, idev->mc_maxdelay);
 	}
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_event(struct inet6_dev *idev)
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 7fd66de..ec78ab6 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -853,7 +853,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	iph->daddr		=	cp->daddr.ip;
 	iph->saddr		=	saddr;
 	iph->ttl		=	old_iph->ttl;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 91f4791..53a7f03 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -205,45 +205,24 @@ out:
 		in6_dev_put(idev);
 }
 
-/* Based on tcp_v6_xmit() in tcp_ipv6.c. */
 static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 {
 	struct sock *sk = skb->sk;
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct flowi6 fl6;
-
-	memset(&fl6, 0, sizeof(fl6));
-
-	fl6.flowi6_proto = sk->sk_protocol;
-
-	/* Fill in the dest address from the route entry passed with the skb
-	 * and the source address from the transport.
-	 */
-	fl6.daddr = transport->ipaddr.v6.sin6_addr;
-	fl6.saddr = transport->saddr.v6.sin6_addr;
-
-	fl6.flowlabel = np->flow_label;
-	IP6_ECN_flow_xmit(sk, fl6.flowlabel);
-	if (ipv6_addr_type(&fl6.saddr) & IPV6_ADDR_LINKLOCAL)
-		fl6.flowi6_oif = transport->saddr.v6.sin6_scope_id;
-	else
-		fl6.flowi6_oif = sk->sk_bound_dev_if;
-
-	if (np->opt && np->opt->srcrt) {
-		struct rt0_hdr *rt0 = (struct rt0_hdr *) np->opt->srcrt;
-		fl6.daddr = *rt0->addr;
-	}
+	struct flowi6 *fl6 = &transport->fl.u.ip6;
 
 	SCTP_DEBUG_PRINTK("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n",
 			  __func__, skb, skb->len,
-			  &fl6.saddr, &fl6.daddr);
+			  &fl6->saddr, &fl6->daddr);
 
-	SCTP_INC_STATS(SCTP_MIB_OUTSCTPPACKS);
+	IP6_ECN_flow_xmit(sk, fl6->flowlabel);
 
 	if (!(transport->param_flags & SPP_PMTUD_ENABLE))
 		skb->local_df = 1;
 
-	return ip6_xmit(sk, skb, &fl6, np->opt, np->tclass);
+	SCTP_INC_STATS(SCTP_MIB_OUTSCTPPACKS);
+
+	return ip6_xmit(sk, skb, fl6, np->opt, np->tclass);
 }
 
 /* Returns the dst cache entry for the given source and destination ip
@@ -256,10 +235,12 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	struct dst_entry *dst = NULL;
 	struct flowi6 *fl6 = &fl->u.ip6;
 	struct sctp_bind_addr *bp;
+	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sctp_sockaddr_entry *laddr;
 	union sctp_addr *baddr = NULL;
 	union sctp_addr *daddr = &t->ipaddr;
 	union sctp_addr dst_saddr;
+	struct in6_addr *final_p, final;
 	__u8 matchlen = 0;
 	__u8 bmatchlen;
 	sctp_scope_t scope;
@@ -282,7 +263,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		SCTP_DEBUG_PRINTK("SRC=%pI6 - ", &fl6->saddr);
 	}
 
-	dst = ip6_dst_lookup_flow(sk, fl6, NULL, false);
+	final_p = fl6_update_dst(fl6, np->opt, &final);
+	dst = ip6_dst_lookup_flow(sk, fl6, final_p, false);
 	if (!asoc || saddr)
 		goto out;
 
@@ -333,10 +315,12 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		}
 	}
 	rcu_read_unlock();
+
 	if (baddr) {
 		fl6->saddr = baddr->v6.sin6_addr;
 		fl6->fl6_sport = baddr->v6.sin6_port;
-		dst = ip6_dst_lookup_flow(sk, fl6, NULL, false);
+		final_p = fl6_update_dst(fl6, np->opt, &final);
+		dst = ip6_dst_lookup_flow(sk, fl6, final_p, false);
 	}
 
 out:
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index c461b1c..8716da1 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1609,9 +1609,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
-			chunk->subh.sack_hdr = &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_CHUNK(chunk));
+					SCTP_SACKH(&sackh));
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7e40284..d01802a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -814,6 +814,9 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 			goto skip_mkasconf;
 		}
 
+		if (laddr == NULL)
+			return -EINVAL;
+
 		/* We do not need RCU protection throughout this loop
 		 * because this is done under a socket lock from the
 		 * setsockopt call.
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index cb6d904..fccf04f 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -819,7 +819,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	if (format == SMK_FIXED24_FMT)
 		rule += SMK_LABELLEN;
 	else
-		rule += strlen(skp->smk_known);
+		rule += strlen(skp->smk_known) + 1;
 
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 956c75d..794f37a 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -665,7 +665,8 @@ static int snd_compress_dev_disconnect(struct snd_device *device)
 	struct snd_compr *compr;
 
 	compr = device->device_data;
-	snd_unregister_device(compr->direction, compr->card, compr->device);
+	snd_unregister_device(SNDRV_DEVICE_TYPE_COMPRESS, compr->card,
+		compr->device);
 	return 0;
 }
 
diff --git a/sound/soc/codecs/88pm860x-codec.c b/sound/soc/codecs/88pm860x-codec.c
index 9fd3b68..3ff2b94 100644
--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -351,6 +351,9 @@ static int snd_soc_put_volsw_2r_st(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	val2 = ucontrol->value.integer.value[1];
 
+	if (val >= ARRAY_SIZE(st_table) || val2 >= ARRAY_SIZE(st_table))
+		return -EINVAL;
+
 	err = snd_soc_update_bits(codec, reg, 0x3f, st_table[val].m);
 	if (err < 0)
 		return err;
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 35179e2..bf80366 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1863,7 +1863,7 @@ static int max98095_put_eq_enum(struct snd_kcontrol *kcontrol,
 	struct max98095_pdata *pdata = max98095->pdata;
 	int channel = max98095_get_eq_channel(kcontrol->id.name);
 	struct max98095_cdata *cdata;
-	int sel = ucontrol->value.integer.value[0];
+	unsigned int sel = ucontrol->value.integer.value[0];
 	struct max98095_eq_cfg *coef_set;
 	int fs, best, best_val, i;
 	int regmask, regsave;
@@ -2016,7 +2016,7 @@ static int max98095_put_bq_enum(struct snd_kcontrol *kcontrol,
 	struct max98095_pdata *pdata = max98095->pdata;
 	int channel = max98095_get_bq_channel(codec, kcontrol->id.name);
 	struct max98095_cdata *cdata;
-	int sel = ucontrol->value.integer.value[0];
+	unsigned int sel = ucontrol->value.integer.value[0];
 	struct max98095_biquad_cfg *coef_set;
 	int fs, best, best_val, i;
 	int regmask, regsave;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 81072b6..34d8298 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -16,6 +16,7 @@ const char *map_type__name[MAP__NR_TYPES] = {
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
