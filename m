Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab3HBJun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:50:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab3HBJuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:50:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.18
Date: Fri,  2 Aug 2013 10:50:15 +0100
Message-Id: <1375437015-5631-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375437015-5631-1-git-send-email-luis.henriques@canonical.com>
References: <1375437015-5631-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 5927882..058777c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6466,6 +6466,7 @@ STABLE BRANCH
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	stable@vger.kernel.org
 S:	Supported
+F:	Documentation/stable_kernel_rules.txt
 
 STAGING SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/Makefile b/Makefile
index c94eb01..928c4bf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .17
+EXTRAVERSION = .18
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
index dae9aa6..bf7f509 100644
--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -287,14 +287,14 @@ static struct gpio_em_config gio3_config = {
 static struct resource gio3_resources[] = {
 	[0] = {
 		.name	= "GIO_096",
-		.start	= 0xe0050100,
-		.end	= 0xe005012b,
+		.start	= 0xe0050180,
+		.end	= 0xe00501ab,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
 		.name	= "GIO_096",
-		.start	= 0xe0050140,
-		.end	= 0xe005015f,
+		.start	= 0xe00501c0,
+		.end	= 0xe00501df,
 		.flags	= IORESOURCE_MEM,
 	},
 	[2] = {
diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index 0192a4e..80de64b 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -87,10 +87,9 @@ struct exception_table_entry;
 void sort_ex_table(struct exception_table_entry *start,
 		   struct exception_table_entry *finish);
 
-#ifdef CONFIG_MODVERSIONS
+#if defined(CONFIG_MODVERSIONS) && defined(CONFIG_PPC64)
 #define ARCH_RELOCATES_KCRCTAB
-
-extern const unsigned long reloc_start[];
+#define reloc_start PHYSICAL_START
 #endif
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_MODULE_H */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 65d1c08..7703569 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -38,9 +38,6 @@ jiffies = jiffies_64 + 4;
 #endif
 SECTIONS
 {
-	. = 0;
-	reloc_start = .;
-
 	. = KERNELBASE;
 
 /*
diff --git a/arch/sparc/kernel/asm-offsets.c b/arch/sparc/kernel/asm-offsets.c
index 68f7e11..ce48203 100644
--- a/arch/sparc/kernel/asm-offsets.c
+++ b/arch/sparc/kernel/asm-offsets.c
@@ -34,6 +34,8 @@ int foo(void)
 	DEFINE(AOFF_task_thread, offsetof(struct task_struct, thread));
 	BLANK();
 	DEFINE(AOFF_mm_context, offsetof(struct mm_struct, context));
+	BLANK();
+	DEFINE(VMA_VM_MM,    offsetof(struct vm_area_struct, vm_mm));
 
 	/* DEFINE(NUM_USER_SEGMENTS, TASK_SIZE>>28); */
 	return 0;
diff --git a/arch/sparc/mm/hypersparc.S b/arch/sparc/mm/hypersparc.S
index 44aad32..969f964 100644
--- a/arch/sparc/mm/hypersparc.S
+++ b/arch/sparc/mm/hypersparc.S
@@ -74,7 +74,7 @@ hypersparc_flush_cache_mm_out:
 
 	/* The things we do for performance... */
 hypersparc_flush_cache_range:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 #ifndef CONFIG_SMP
 	ld	[%o0 + AOFF_mm_context], %g1
 	cmp	%g1, -1
@@ -163,7 +163,7 @@ hypersparc_flush_cache_range_out:
 	 */
 	/* Verified, my ass... */
 hypersparc_flush_cache_page:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	ld	[%o0 + AOFF_mm_context], %g2
 #ifndef CONFIG_SMP
 	cmp	%g2, -1
@@ -284,7 +284,7 @@ hypersparc_flush_tlb_mm_out:
 	 sta	%g5, [%g1] ASI_M_MMUREGS
 
 hypersparc_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
@@ -307,7 +307,7 @@ hypersparc_flush_tlb_range_out:
 	 sta	%g5, [%g1] ASI_M_MMUREGS
 
 hypersparc_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	andn	%o1, (PAGE_SIZE - 1), %o1
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index d58edf5..f2ace29 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1049,7 +1049,14 @@ static int __init grab_mblocks(struct mdesc_handle *md)
 		m->size = *val;
 		val = mdesc_get_property(md, node,
 					 "address-congruence-offset", NULL);
-		m->offset = *val;
+
+		/* The address-congruence-offset property is optional.
+		 * Explicity zero it be identifty this.
+		 */
+		if (val)
+			m->offset = *val;
+		else
+			m->offset = 0UL;
 
 		numadbg("MBLOCK[%d]: base[%llx] size[%llx] offset[%llx]\n",
 			count - 1, m->base, m->size, m->offset);
diff --git a/arch/sparc/mm/swift.S b/arch/sparc/mm/swift.S
index c801c39..5d2b88d 100644
--- a/arch/sparc/mm/swift.S
+++ b/arch/sparc/mm/swift.S
@@ -105,7 +105,7 @@ swift_flush_cache_mm_out:
 
 	.globl	swift_flush_cache_range
 swift_flush_cache_range:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	sub	%o2, %o1, %o2
 	sethi	%hi(4096), %o3
 	cmp	%o2, %o3
@@ -116,7 +116,7 @@ swift_flush_cache_range:
 
 	.globl	swift_flush_cache_page
 swift_flush_cache_page:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 70:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -219,7 +219,7 @@ swift_flush_sig_insns:
 	.globl	swift_flush_tlb_range
 	.globl	swift_flush_tlb_all
 swift_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 swift_flush_tlb_mm:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -233,7 +233,7 @@ swift_flush_tlb_all_out:
 
 	.globl	swift_flush_tlb_page
 swift_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	andn	%o1, (PAGE_SIZE - 1), %o1
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index afd021e..072f553 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -115,8 +115,8 @@ no_cache_flush:
 	}
 
 	if (!tb->active) {
-		global_flush_tlb_page(mm, vaddr);
 		flush_tsb_user_page(mm, vaddr);
+		global_flush_tlb_page(mm, vaddr);
 		goto out;
 	}
 
diff --git a/arch/sparc/mm/tsunami.S b/arch/sparc/mm/tsunami.S
index 4e55e8f..bf10a34 100644
--- a/arch/sparc/mm/tsunami.S
+++ b/arch/sparc/mm/tsunami.S
@@ -24,7 +24,7 @@
 	/* Sliiick... */
 tsunami_flush_cache_page:
 tsunami_flush_cache_range:
-	ld	[%o0 + 0x0], %o0	/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 tsunami_flush_cache_mm:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -46,7 +46,7 @@ tsunami_flush_sig_insns:
 
 	/* More slick stuff... */
 tsunami_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 tsunami_flush_tlb_mm:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -65,7 +65,7 @@ tsunami_flush_tlb_out:
 
 	/* This one can be done in a fine grained manner... */
 tsunami_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	andn	%o1, (PAGE_SIZE - 1), %o1
diff --git a/arch/sparc/mm/viking.S b/arch/sparc/mm/viking.S
index bf8ee06..852257f 100644
--- a/arch/sparc/mm/viking.S
+++ b/arch/sparc/mm/viking.S
@@ -108,7 +108,7 @@ viking_mxcc_flush_page:
 viking_flush_cache_page:
 viking_flush_cache_range:
 #ifndef CONFIG_SMP
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 #endif
 viking_flush_cache_mm:
 #ifndef CONFIG_SMP
@@ -148,7 +148,7 @@ viking_flush_tlb_mm:
 #endif
 
 viking_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
@@ -173,7 +173,7 @@ viking_flush_tlb_range:
 #endif
 
 viking_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
@@ -239,7 +239,7 @@ sun4dsmp_flush_tlb_range:
 	tst	%g5
 	bne	3f
 	 mov	SRMMU_CTX_REG, %g1
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
 	sethi	%hi(~((1 << SRMMU_PGDIR_SHIFT) - 1)), %o4
@@ -265,7 +265,7 @@ sun4dsmp_flush_tlb_page:
 	tst	%g5
 	bne	2f
 	 mov	SRMMU_CTX_REG, %g1
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
 	and	%o1, PAGE_MASK, %o1
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index d985713..f81597f 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -421,6 +421,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
+		device->driver_data = NULL;
 		kfree(mem_device);
 		return result;
 	}
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index dd99cbb..fdee8b4 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -352,7 +352,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
-	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4fd1dea..4ed7bf9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -399,7 +399,18 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 	unsigned long secure;
+	struct phys_req preq;
+
+	preq.sector_number = req->u.discard.sector_number;
+	preq.nr_sects      = req->u.discard.nr_sectors;
 
+	err = xen_vbd_translate(&preq, blkif, WRITE);
+	if (err) {
+		pr_warn(DRV_PFX "access denied: DISCARD [%llu->%llu] on dev=%04x\n",
+			preq.sector_number,
+			preq.sector_number + preq.nr_sects, blkif->vbd.pdevice);
+		goto fail_response;
+	}
 	blkif->st_ds_req++;
 
 	xen_blkif_get(blkif);
@@ -410,7 +421,7 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
 				   req->u.discard.nr_sectors,
 				   GFP_KERNEL, secure);
-
+fail_response:
 	if (err == -EOPNOTSUPP) {
 		pr_debug(DRV_PFX "discard op failed, not supported\n");
 		status = BLKIF_RSP_EOPNOTSUPP;
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 500cced..824d03c 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -45,6 +45,41 @@ static char *pre_emph_names[] = {
 };
 
 /***** radeon AUX functions *****/
+
+/* Atom needs data in little endian format
+ * so swap as appropriate when copying data to
+ * or from atom. Note that atom operates on
+ * dw units.
+ */
+static void radeon_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le)
+{
+#ifdef __BIG_ENDIAN
+	u8 src_tmp[20], dst_tmp[20]; /* used for byteswapping */
+	u32 *dst32, *src32;
+	int i;
+
+	memcpy(src_tmp, src, num_bytes);
+	src32 = (u32 *)src_tmp;
+	dst32 = (u32 *)dst_tmp;
+	if (to_le) {
+		for (i = 0; i < ((num_bytes + 3) / 4); i++)
+			dst32[i] = cpu_to_le32(src32[i]);
+		memcpy(dst, dst_tmp, num_bytes);
+	} else {
+		u8 dws = num_bytes & ~3;
+		for (i = 0; i < ((num_bytes + 3) / 4); i++)
+			dst32[i] = le32_to_cpu(src32[i]);
+		memcpy(dst, dst_tmp, dws);
+		if (num_bytes % 4) {
+			for (i = 0; i < (num_bytes % 4); i++)
+				dst[dws+i] = dst_tmp[dws+i];
+		}
+	}
+#else
+	memcpy(dst, src, num_bytes);
+#endif
+}
+
 union aux_channel_transaction {
 	PROCESS_AUX_CHANNEL_TRANSACTION_PS_ALLOCATION v1;
 	PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2 v2;
@@ -66,10 +101,10 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 
 	base = (unsigned char *)(rdev->mode_info.atom_context->scratch + 1);
 
-	memcpy(base, send, send_bytes);
+	radeon_copy_swap(base, send, send_bytes, true);
 
-	args.v1.lpAuxRequest = 0 + 4;
-	args.v1.lpDataOut = 16 + 4;
+	args.v1.lpAuxRequest = cpu_to_le16((u16)(0 + 4));
+	args.v1.lpDataOut = cpu_to_le16((u16)(16 + 4));
 	args.v1.ucDataOutLen = 0;
 	args.v1.ucChannelID = chan->rec.i2c_id;
 	args.v1.ucDelay = delay / 10;
@@ -103,7 +138,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 		recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		memcpy(recv, base + 16, recv_bytes);
+		radeon_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }
diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 65c5416..44b3b07 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -156,6 +156,9 @@ void evergreen_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	uint32_t offset;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (!dig->afmt->enabled)
 		return;
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 26ce6c1..949bf83 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -322,6 +322,9 @@ void r600_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode *mod
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	uint32_t offset;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (!dig->afmt->enabled)
 		return;
@@ -480,6 +483,9 @@ void r600_hdmi_enable(struct drm_encoder *encoder)
 	uint32_t offset;
 	u32 hdmi;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	if (ASIC_IS_DCE6(rdev))
 		return;
 
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 77c50cc..cf5dd63 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -147,7 +147,7 @@ static uint16_t combios_get_table_offset(struct drm_device *dev,
 					 enum radeon_combios_table_offset table)
 {
 	struct radeon_device *rdev = dev->dev_private;
-	int rev;
+	int rev, size;
 	uint16_t offset = 0, check_offset;
 
 	if (!rdev->bios)
@@ -156,174 +156,106 @@ static uint16_t combios_get_table_offset(struct drm_device *dev,
 	switch (table) {
 		/* absolute offset tables */
 	case COMBIOS_ASIC_INIT_1_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0xc);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0xc;
 		break;
 	case COMBIOS_BIOS_SUPPORT_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x14);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x14;
 		break;
 	case COMBIOS_DAC_PROGRAMMING_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x2a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x2a;
 		break;
 	case COMBIOS_MAX_COLOR_DEPTH_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x2c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x2c;
 		break;
 	case COMBIOS_CRTC_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x2e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x2e;
 		break;
 	case COMBIOS_PLL_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x30);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x30;
 		break;
 	case COMBIOS_TV_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x32);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x32;
 		break;
 	case COMBIOS_DFP_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x34);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x34;
 		break;
 	case COMBIOS_HW_CONFIG_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x36);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x36;
 		break;
 	case COMBIOS_MULTIMEDIA_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x38);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x38;
 		break;
 	case COMBIOS_TV_STD_PATCH_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x3e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x3e;
 		break;
 	case COMBIOS_LCD_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x40);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x40;
 		break;
 	case COMBIOS_MOBILE_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x42);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x42;
 		break;
 	case COMBIOS_PLL_INIT_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x46);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x46;
 		break;
 	case COMBIOS_MEM_CONFIG_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x48);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x48;
 		break;
 	case COMBIOS_SAVE_MASK_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x4a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x4a;
 		break;
 	case COMBIOS_HARDCODED_EDID_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x4c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x4c;
 		break;
 	case COMBIOS_ASIC_INIT_2_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x4e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x4e;
 		break;
 	case COMBIOS_CONNECTOR_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x50);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x50;
 		break;
 	case COMBIOS_DYN_CLK_1_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x52);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x52;
 		break;
 	case COMBIOS_RESERVED_MEM_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x54);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x54;
 		break;
 	case COMBIOS_EXT_TMDS_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x58);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x58;
 		break;
 	case COMBIOS_MEM_CLK_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x5a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x5a;
 		break;
 	case COMBIOS_EXT_DAC_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x5c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x5c;
 		break;
 	case COMBIOS_MISC_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x5e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x5e;
 		break;
 	case COMBIOS_CRT_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x60);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x60;
 		break;
 	case COMBIOS_INTEGRATED_SYSTEM_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x62);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x62;
 		break;
 	case COMBIOS_COMPONENT_VIDEO_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x64);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x64;
 		break;
 	case COMBIOS_FAN_SPEED_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x66);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x66;
 		break;
 	case COMBIOS_OVERDRIVE_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x68);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x68;
 		break;
 	case COMBIOS_OEM_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x6a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x6a;
 		break;
 	case COMBIOS_DYN_CLK_2_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x6c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x6c;
 		break;
 	case COMBIOS_POWER_CONNECTOR_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x6e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x6e;
 		break;
 	case COMBIOS_I2C_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x70);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x70;
 		break;
 		/* relative offset tables */
 	case COMBIOS_ASIC_INIT_3_TABLE:	/* offset from misc info */
@@ -439,11 +371,16 @@ static uint16_t combios_get_table_offset(struct drm_device *dev,
 		}
 		break;
 	default:
+		check_offset = 0;
 		break;
 	}
 
-	return offset;
+	size = RBIOS8(rdev->bios_header_start + 0x6);
+	/* check absolute offset tables */
+	if (table < COMBIOS_ASIC_INIT_3_TABLE && check_offset && check_offset < size)
+		offset = RBIOS16(rdev->bios_header_start + check_offset);
 
+	return offset;
 }
 
 bool radeon_combios_check_hardcoded_edid(struct radeon_device *rdev)
@@ -953,16 +890,22 @@ struct radeon_encoder_primary_dac *radeon_combios_get_primary_dac_info(struct
 			dac = RBIOS8(dac_info + 0x3) & 0xf;
 			p_dac->ps2_pdac_adj = (bg << 8) | (dac);
 		}
-		/* if the values are all zeros, use the table */
-		if (p_dac->ps2_pdac_adj)
+		/* if the values are zeros, use the table */
+		if ((dac == 0) || (bg == 0))
+			found = 0;
+		else
 			found = 1;
 	}
 
 	/* quirks */
+	/* Radeon 7000 (RV100) */
+	if (((dev->pdev->device == 0x5159) &&
+	    (dev->pdev->subsystem_vendor == 0x174B) &&
+	    (dev->pdev->subsystem_device == 0x7c28)) ||
 	/* Radeon 9100 (R200) */
-	if ((dev->pdev->device == 0x514D) &&
+	   ((dev->pdev->device == 0x514D) &&
 	    (dev->pdev->subsystem_vendor == 0x174B) &&
-	    (dev->pdev->subsystem_device == 0x7149)) {
+	    (dev->pdev->subsystem_device == 0x7149))) {
 		/* vbios value is bad, use the default */
 		found = 0;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index d13a348..30003b6 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -181,9 +181,6 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 	int i;
 	int r = 0;
 
-	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
-	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
-
 	spin_lock_init(&rdev->irq.sw_lock);
 	for (i = 0; i < rdev->num_crtc; i++)
 		spin_lock_init(&rdev->irq.pflip_lock[i]);
@@ -207,6 +204,10 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 		rdev->irq.installed = false;
 		return r;
 	}
+
+	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
+	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
+
 	DRM_INFO("radeon: irq initialized.\n");
 	return 0;
 }
@@ -219,8 +220,8 @@ void radeon_irq_kms_fini(struct radeon_device *rdev)
 		rdev->irq.installed = false;
 		if (rdev->msi_enabled)
 			pci_disable_msi(rdev->pdev);
+		flush_work_sync(&rdev->hotplug_work);
 	}
-	flush_work_sync(&rdev->hotplug_work);
 }
 
 void radeon_irq_kms_sw_irq_get(struct radeon_device *rdev, int ring)
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1ca41d2..93b3c2d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1526,7 +1526,6 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	unsigned long flags;
 	int r;
 
-again:
 	bdev = NULL;
 	mode = 0;
 	r = 0;
@@ -1544,7 +1543,7 @@ again:
 	}
 
 	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
-		r = -EAGAIN;
+		r = -ENOTCONN;
 	else if (!bdev)
 		r = -EIO;
 
@@ -1556,11 +1555,8 @@ again:
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -EAGAIN && !fatal_signal_pending(current)) {
+	if (r == -ENOTCONN && !fatal_signal_pending(current))
 		queue_work(kmultipathd, &m->process_queued_ios);
-		msleep(10);
-		goto again;
-	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index adb32e7..157007d 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -842,9 +842,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	for (i = v->levels - 1; i >= 0; i--) {
 		sector_t s;
 		v->hash_level_block[i] = hash_position;
-		s = verity_position_at_level(v, v->data_blocks, i);
-		s = (s >> v->hash_per_block_bits) +
-		    !!(s & ((1 << v->hash_per_block_bits) - 1));
+		s = (v->data_blocks + ((sector_t)1 << ((i + 1) * v->hash_per_block_bits)) - 1)
+					>> ((i + 1) * v->hash_per_block_bits);
 		if (hash_position + s < hash_position) {
 			ti->error = "Hash device offset overflow";
 			r = -E2BIG;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32370ea..9a7290b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -414,10 +414,12 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
-	struct dm_table *map = dm_get_live_table(md);
+	struct dm_table *map;
 	struct dm_target *tgt;
 	int r = -ENOTTY;
 
+retry:
+	map = dm_get_live_table(md);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -438,6 +440,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 out:
 	dm_table_put(map);
 
+	if (r == -ENOTCONN) {
+		msleep(10);
+		goto retry;
+	}
+
 	return r;
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a829557..5ad042c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2130,12 +2130,18 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	d = r10_bio->devs[1].devnum;
 	wbio = r10_bio->devs[1].bio;
 	wbio2 = r10_bio->devs[1].repl_bio;
+	/* Need to test wbio2->bi_end_io before we call
+	 * generic_make_request as if the former is NULL,
+	 * the latter is free to free wbio2.
+	 */
+	if (wbio2 && !wbio2->bi_end_io)
+		wbio2 = NULL;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
 		generic_make_request(wbio);
 	}
-	if (wbio2 && wbio2->bi_end_io) {
+	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
 			     wbio2->bi_size >> 9);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bcd096b..ecf09ec 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3372,6 +3372,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		set_bit(STRIPE_SYNCING, &sh->state);
 		clear_bit(STRIPE_INSYNC, &sh->state);
+		clear_bit(STRIPE_REPLACED, &sh->state);
 	}
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -3511,19 +3512,23 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_parity_checks5(conf, sh, &s, disks);
 	}
 
-	if (s.replacing && s.locked == 0
-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if ((s.replacing || s.syncing) && s.locked == 0
+	    && !test_bit(STRIPE_COMPUTE_RUN, &sh->state)
+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
 		/* Write out to replacement devices where possible */
 		for (i = 0; i < conf->raid_disks; i++)
-			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
-			    test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+			if (test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+				WARN_ON(!test_bit(R5_UPTODATE, &sh->dev[i].flags));
 				set_bit(R5_WantReplace, &sh->dev[i].flags);
 				set_bit(R5_LOCKED, &sh->dev[i].flags);
 				s.locked++;
 			}
-		set_bit(STRIPE_INSYNC, &sh->state);
+		if (s.replacing)
+			set_bit(STRIPE_INSYNC, &sh->state);
+		set_bit(STRIPE_REPLACED, &sh->state);
 	}
 	if ((s.syncing || s.replacing) && s.locked == 0 &&
+	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2164021..43d22fc 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -307,6 +307,7 @@ enum {
 	STRIPE_SYNC_REQUESTED,
 	STRIPE_SYNCING,
 	STRIPE_INSYNC,
+	STRIPE_REPLACED,
 	STRIPE_PREREAD_ACTIVE,
 	STRIPE_DELAYED,
 	STRIPE_DEGRADED,
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 73970cd..214df76 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -379,10 +379,8 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer2,
 					      buffer2_len);
 	}
-	if (ret < 0) {
-		dvb_ringbuffer_flush(&dmxdevfilter->buffer);
+	if (ret < 0)
 		dmxdevfilter->buffer.error = ret;
-	}
 	if (dmxdevfilter->params.sec.flags & DMX_ONESHOT)
 		dmxdevfilter->state = DMXDEV_STATE_DONE;
 	spin_unlock(&dmxdevfilter->dev->lock);
@@ -418,10 +416,8 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	ret = dvb_dmxdev_buffer_write(buffer, buffer1, buffer1_len);
 	if (ret == buffer1_len)
 		ret = dvb_dmxdev_buffer_write(buffer, buffer2, buffer2_len);
-	if (ret < 0) {
-		dvb_ringbuffer_flush(buffer);
+	if (ret < 0)
 		buffer->error = ret;
-	}
 	spin_unlock(&dmxdevfilter->dev->lock);
 	wake_up(&buffer->queue);
 	return 0;
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 10460fd..dbcdfbf 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -172,7 +172,9 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 		dprintk("irq: overrun [full=%d/%d] - Blocks in %d\n",dev->dmasound.read_count,
 			dev->dmasound.bufsize, dev->dmasound.blocks);
 		spin_unlock(&dev->slock);
+		snd_pcm_stream_lock(dev->dmasound.substream);
 		snd_pcm_stop(dev->dmasound.substream,SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(dev->dmasound.substream);
 		return;
 	}
 
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index bab0158..b33ad12 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -186,6 +186,8 @@ static int __init dummy_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
+	if (err < 0)
+		goto out;
 
 	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
@@ -193,6 +195,8 @@ static int __init dummy_init_module(void)
 	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 56b04c4..05e72c8 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1688,8 +1688,8 @@ check_sum:
 	return 0;
 }
 
-static void atl1e_tx_map(struct atl1e_adapter *adapter,
-		      struct sk_buff *skb, struct atl1e_tpd_desc *tpd)
+static int atl1e_tx_map(struct atl1e_adapter *adapter,
+			struct sk_buff *skb, struct atl1e_tpd_desc *tpd)
 {
 	struct atl1e_tpd_desc *use_tpd = NULL;
 	struct atl1e_tx_buffer *tx_buffer = NULL;
@@ -1700,6 +1700,8 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 	u16 nr_frags;
 	u16 f;
 	int segment;
+	int ring_start = adapter->tx_ring.next_to_use;
+	int ring_end;
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	segment = (tpd->word3 >> TPD_SEGMENT_EN_SHIFT) & TPD_SEGMENT_EN_MASK;
@@ -1712,6 +1714,9 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 		tx_buffer->length = map_len;
 		tx_buffer->dma = pci_map_single(adapter->pdev,
 					skb->data, hdr_len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma))
+			return -ENOSPC;
+
 		ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_SINGLE);
 		mapped_len += map_len;
 		use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
@@ -1738,6 +1743,22 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 		tx_buffer->dma =
 			pci_map_single(adapter->pdev, skb->data + mapped_len,
 					map_len, PCI_DMA_TODEVICE);
+
+		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
+			/* We need to unwind the mappings we've done */
+			ring_end = adapter->tx_ring.next_to_use;
+			adapter->tx_ring.next_to_use = ring_start;
+			while (adapter->tx_ring.next_to_use != ring_end) {
+				tpd = atl1e_get_tpd(adapter);
+				tx_buffer = atl1e_get_tx_buffer(adapter, tpd);
+				pci_unmap_single(adapter->pdev, tx_buffer->dma,
+						 tx_buffer->length, PCI_DMA_TODEVICE);
+			}
+			/* Reset the tx rings next pointer */
+			adapter->tx_ring.next_to_use = ring_start;
+			return -ENOSPC;
+		}
+
 		ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_SINGLE);
 		mapped_len  += map_len;
 		use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
@@ -1773,6 +1794,23 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 							  (i * MAX_TX_BUF_LEN),
 							  tx_buffer->length,
 							  DMA_TO_DEVICE);
+
+			if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
+				/* We need to unwind the mappings we've done */
+				ring_end = adapter->tx_ring.next_to_use;
+				adapter->tx_ring.next_to_use = ring_start;
+				while (adapter->tx_ring.next_to_use != ring_end) {
+					tpd = atl1e_get_tpd(adapter);
+					tx_buffer = atl1e_get_tx_buffer(adapter, tpd);
+					dma_unmap_page(&adapter->pdev->dev, tx_buffer->dma,
+						       tx_buffer->length, DMA_TO_DEVICE);
+				}
+
+				/* Reset the ring next to use pointer */
+				adapter->tx_ring.next_to_use = ring_start;
+				return -ENOSPC;
+			}
+
 			ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_PAGE);
 			use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
 			use_tpd->word2 = (use_tpd->word2 & (~TPD_BUFLEN_MASK)) |
@@ -1790,6 +1828,7 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 	/* The last buffer info contain the skb address,
 	   so it will be free after unmap */
 	tx_buffer->skb = skb;
+	return 0;
 }
 
 static void atl1e_tx_queue(struct atl1e_adapter *adapter, u16 count,
@@ -1857,10 +1896,15 @@ static netdev_tx_t atl1e_xmit_frame(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	atl1e_tx_map(adapter, skb, tpd);
+	if (atl1e_tx_map(adapter, skb, tpd)) {
+		dev_kfree_skb_any(skb);
+		goto out;
+	}
+
 	atl1e_tx_queue(adapter, tpd_req, tpd);
 
 	netdev->trans_start = jiffies; /* NETIF_F_LLTX driver :( */
+out:
 	spin_unlock_irqrestore(&adapter->tx_lock, flags);
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 2ff4f0b..8cfba14 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -88,8 +88,9 @@ static struct sh_eth_cpu_data sh_eth_my_cpu_data = {
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x01ff009f,
 
 	.tx_check	= EESR_FTC | EESR_CND | EESR_DLC | EESR_CD | EESR_RTO,
-	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RDE |
-			  EESR_RFRMER | EESR_TFE | EESR_TDE | EESR_ECI,
+	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
+			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE |
+			  EESR_ECI,
 	.tx_error_check	= EESR_TWB | EESR_TABT | EESR_TDE | EESR_TFE,
 
 	.apr		= 1,
@@ -137,8 +138,9 @@ static struct sh_eth_cpu_data sh_eth_my_cpu_data = {
 	.rmcr_value	= 0x00000001,
 
 	.tx_check	= EESR_FTC | EESR_CND | EESR_DLC | EESR_CD | EESR_RTO,
-	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RDE |
-			  EESR_RFRMER | EESR_TFE | EESR_TDE | EESR_ECI,
+	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
+			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE |
+			  EESR_ECI,
 	.tx_error_check	= EESR_TWB | EESR_TABT | EESR_TDE | EESR_TFE,
 
 	.apr		= 1,
@@ -252,9 +254,9 @@ static struct sh_eth_cpu_data sh_eth_my_cpu_data_giga = {
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x003fffff,
 
 	.tx_check	= EESR_TC1 | EESR_FTC,
-	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT | \
-			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE | \
-			  EESR_ECI,
+	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
+			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
+			  EESR_TDE | EESR_ECI,
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
 	.fdr_value	= 0x0000072f,
@@ -361,9 +363,9 @@ static struct sh_eth_cpu_data sh_eth_my_cpu_data = {
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x003fffff,
 
 	.tx_check	= EESR_TC1 | EESR_FTC,
-	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT | \
-			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE | \
-			  EESR_ECI,
+	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
+			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
+			  EESR_TDE | EESR_ECI,
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
 
@@ -478,9 +480,9 @@ static struct sh_eth_cpu_data sh_eth_my_cpu_data = {
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x003fffff,
 
 	.tx_check	= EESR_TC1 | EESR_FTC,
-	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT | \
-			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE | \
-			  EESR_ECI,
+	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
+			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
+			  EESR_TDE | EESR_ECI,
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.h b/drivers/net/ethernet/renesas/sh_eth.h
index 57b8e1f..8369e92 100644
--- a/drivers/net/ethernet/renesas/sh_eth.h
+++ b/drivers/net/ethernet/renesas/sh_eth.h
@@ -468,7 +468,7 @@ enum EESR_BIT {
 
 #define DEFAULT_TX_CHECK	(EESR_FTC | EESR_CND | EESR_DLC | EESR_CD | \
 				 EESR_RTO)
-#define DEFAULT_EESR_ERR_CHECK	(EESR_TWB | EESR_TABT | EESR_RABT | \
+#define DEFAULT_EESR_ERR_CHECK	(EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE | \
 				 EESR_RDE | EESR_RFRMER | EESR_ADE | \
 				 EESR_TFE | EESR_TDE | EESR_ECI)
 #define DEFAULT_TX_ERROR_CHECK	(EESR_TWB | EESR_TABT | EESR_ADE | EESR_TDE | \
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index a108db3..1d68059 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1243,6 +1243,8 @@ static int vnet_port_remove(struct vio_dev *vdev)
 		dev_set_drvdata(&vdev->dev, NULL);
 
 		kfree(port);
+
+		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 344dceb..635d01c 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -290,11 +290,17 @@ static int __init ifb_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&ifb_link_ops);
+	if (err < 0)
+		goto out;
 
-	for (i = 0; i < numifbs && !err; i++)
+	for (i = 0; i < numifbs && !err; i++) {
 		err = ifb_init_one(i);
+		cond_resched();
+	}
 	if (err)
 		__rtnl_link_unregister(&ifb_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 2ee56de..cc5b48d 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -534,8 +534,10 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 			return -EMSGSIZE;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
 		if (num_pages != size) {
-			for (i = 0; i < num_pages; i++)
-				put_page(page[i]);
+			int j;
+
+			for (j = 0; j < num_pages; j++)
+				put_page(page[i + j]);
 			return -EFAULT;
 		}
 		truesize = size * PAGE_SIZE;
@@ -655,6 +657,7 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 	int vnet_hdr_len = 0;
 	int copylen = 0;
 	bool zerocopy = false;
+	size_t linear;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = q->vnet_hdr_sz;
@@ -709,11 +712,14 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 			copylen = vnet_hdr.hdr_len;
 		if (!copylen)
 			copylen = GOODCOPY_LEN;
-	} else
+		linear = copylen;
+	} else {
 		copylen = len;
+		linear = vnet_hdr.hdr_len;
+	}
 
 	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, copylen,
-				vnet_hdr.hdr_len, noblock, &err);
+				linear, noblock, &err);
 	if (!skb)
 		goto err;
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4f7453b..557cfd3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1814,7 +1814,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
 		}
 
-		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
+		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
 
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 6bc74eb..efd9e9e 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -491,6 +491,7 @@ int isci_task_abort_task(struct sas_task *task)
 	struct isci_tmf           tmf;
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -505,9 +506,11 @@ int isci_task_abort_task(struct sas_task *task)
 	/* If task is already done, the request isn't valid */
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
-	    old_request)
+	    old_request) {
 		idev = isci_get_device(task->dev->lldd_dev);
-
+		target_done_already = test_bit(IREQ_COMPLETE_IN_TARGET,
+					       &old_request->flags);
+	}
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
@@ -561,7 +564,7 @@ int isci_task_abort_task(struct sas_task *task)
 
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags) ||
+	    target_done_already ||
 	    test_bit(IDEV_GONE, &idev->flags)) {
 
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ed38454..d525297 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4817,10 +4817,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 				    sense, sense_handle);
 	}
 
-	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		dma_free_coherent(&instance->pdev->dev,
-				    kern_sge32[i].length,
-				    kbuff_arr[i], kern_sge32[i].phys_addr);
+	for (i = 0; i < ioc->sge_count; i++) {
+		if (kbuff_arr[i])
+			dma_free_coherent(&instance->pdev->dev,
+					  kern_sge32[i].length,
+					  kbuff_arr[i],
+					  kern_sge32[i].phys_addr);
 	}
 
 	megasas_return_cmd(instance, cmd);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 70dbf53..f2254d2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -424,6 +424,8 @@ qla2x00_start_scsi(srb_t *sp)
 			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
 			break;
 		}
+	} else {
+		cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 	}
 
 	/* Load SCSI command packet. */
@@ -1353,11 +1355,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		    fcp_cmnd->task_attribute = TSK_ORDERED;
 		    break;
 		default:
-		    fcp_cmnd->task_attribute = 0;
+		    fcp_cmnd->task_attribute = TSK_SIMPLE;
 		    break;
 		}
 	} else {
-		fcp_cmnd->task_attribute = 0;
+		fcp_cmnd->task_attribute = TSK_SIMPLE;
 	}
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
@@ -1563,7 +1565,12 @@ qla24xx_start_scsi(srb_t *sp)
 		case ORDERED_QUEUE_TAG:
 			cmd_pkt->task = TSK_ORDERED;
 			break;
+		default:
+		    cmd_pkt->task = TSK_SIMPLE;
+		    break;
 		}
+	} else {
+		cmd_pkt->task = TSK_SIMPLE;
 	}
 
 	/* Load SCSI command packet. */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3977faa..8e18431 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -673,10 +673,17 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
+	struct scsi_cmnd *SCpnt = rq->special;
+
 	if (rq->cmd_flags & REQ_DISCARD) {
 		free_page((unsigned long)rq->buffer);
 		rq->buffer = NULL;
 	}
+	if (SCpnt->cmnd != rq->cmd) {
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
 }
 
 /**
@@ -1540,21 +1547,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
-	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
-
-		/* We have to print a failed command here as the
-		 * extended CDB gets freed before scsi_io_completion()
-		 * is called.
-		 */
-		if (result)
-			scsi_print_command(SCpnt);
-
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-
 	return good_bytes;
 }
 
diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index b2e71c6..6a3c74a 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -357,7 +357,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -376,6 +376,8 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first readable
 	 * entry after (what will be) the new write offset. We do this now
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index b08cbbe..8c38317 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1367,22 +1367,19 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 		DPRINTK("subdevice busy\n");
 		return -EBUSY;
 	}
-	s->busy = file;
 
 	/* make sure channel/gain list isn't too long */
 	if (user_cmd.chanlist_len > s->len_chanlist) {
 		DPRINTK("channel/gain list too long %u > %d\n",
 			user_cmd.chanlist_len, s->len_chanlist);
-		ret = -EINVAL;
-		goto cleanup;
+		return -EINVAL;
 	}
 
 	/* make sure channel/gain list isn't too short */
 	if (user_cmd.chanlist_len < 1) {
 		DPRINTK("channel/gain list too short %u < 1\n",
 			user_cmd.chanlist_len);
-		ret = -EINVAL;
-		goto cleanup;
+		return -EINVAL;
 	}
 
 	async->cmd = user_cmd;
@@ -1392,8 +1389,7 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 	    kmalloc(async->cmd.chanlist_len * sizeof(int), GFP_KERNEL);
 	if (!async->cmd.chanlist) {
 		DPRINTK("allocation failed\n");
-		ret = -ENOMEM;
-		goto cleanup;
+		return -ENOMEM;
 	}
 
 	if (copy_from_user(async->cmd.chanlist, user_cmd.chanlist,
@@ -1445,6 +1441,9 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 
 	comedi_set_subdevice_runflags(s, ~0, SRF_USER | SRF_RUNNING);
 
+	/* set s->busy _after_ setting SRF_RUNNING flag to avoid race with
+	 * comedi_read() or comedi_write() */
+	s->busy = file;
 	ret = s->do_cmd(dev, s);
 	if (ret == 0)
 		return 0;
@@ -1659,6 +1658,7 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 			   void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1675,7 +1675,11 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 	if (s->busy != file)
 		return -EBUSY;
 
-	return do_cancel(dev, s);
+	ret = do_cancel(dev, s);
+	if (comedi_get_subdevice_runflags(s) & SRF_USER)
+		wake_up_interruptible(&s->async->wait_head);
+
+	return ret;
 }
 
 /*
@@ -1942,6 +1946,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 
 		if (!(comedi_get_subdevice_runflags(s) & SRF_RUNNING)) {
 			if (count == 0) {
+				mutex_lock(&dev->mutex);
 				if (comedi_get_subdevice_runflags(s) &
 					SRF_ERROR) {
 					retval = -EPIPE;
@@ -1949,6 +1954,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 					retval = 0;
 				}
 				do_become_nonbusy(dev, s);
+				mutex_unlock(&dev->mutex);
 			}
 			break;
 		}
@@ -2063,6 +2069,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 
 		if (n == 0) {
 			if (!(comedi_get_subdevice_runflags(s) & SRF_RUNNING)) {
+				mutex_lock(&dev->mutex);
 				do_become_nonbusy(dev, s);
 				if (comedi_get_subdevice_runflags(s) &
 				    SRF_ERROR) {
@@ -2070,6 +2077,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 				} else {
 					retval = 0;
 				}
+				mutex_unlock(&dev->mutex);
 				break;
 			}
 			if (file->f_flags & O_NONBLOCK) {
@@ -2107,9 +2115,11 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 		buf += n;
 		break;		/* makes device work like a pipe */
 	}
-	if (!(comedi_get_subdevice_runflags(s) & (SRF_ERROR | SRF_RUNNING)) &&
-	    async->buf_read_count - async->buf_write_count == 0) {
-		do_become_nonbusy(dev, s);
+	if (!(comedi_get_subdevice_runflags(s) & (SRF_ERROR | SRF_RUNNING))) {
+		mutex_lock(&dev->mutex);
+		if (async->buf_read_count - async->buf_write_count == 0)
+			do_become_nonbusy(dev, s);
+		mutex_unlock(&dev->mutex);
 	}
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&async->wait_head, &wait);
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 5e319e3..01f00fd 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -378,8 +378,11 @@ static int snd_line6_pcm_free(struct snd_device *device)
 */
 static void pcm_disconnect_substream(struct snd_pcm_substream *substream)
 {
-	if (substream->runtime && snd_pcm_running(substream))
+	if (substream->runtime && snd_pcm_running(substream)) {
+		snd_pcm_stream_lock_irq(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+		snd_pcm_stream_unlock_irq(substream);
+	}
 }
 
 /*
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 69dc8e3..c17bccf 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -415,7 +415,7 @@ static ssize_t __iscsi_##prefix##_store_##name(				\
 	if (!capable(CAP_SYS_ADMIN))					\
 		return -EPERM;						\
 									\
-	snprintf(auth->name, PAGE_SIZE, "%s", page);			\
+	snprintf(auth->name, sizeof(auth->name), "%s", page);		\
 	if (!strncmp("NULL", auth->name, 4))				\
 		auth->naf_flags &= ~flags;				\
 	else								\
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 9d70788..d5515c0 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -710,6 +710,15 @@ resubmit:
 static inline int
 hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
 {
+	/* Need to clear both directions for control ep */
+	if (((devinfo >> 11) & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_CONTROL) {
+		int status = usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
+				HUB_CLEAR_TT_BUFFER, USB_RT_PORT,
+				devinfo ^ 0x8000, tt, NULL, 0, 1000);
+		if (status)
+			return status;
+	}
 	return usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
 			       HUB_CLEAR_TT_BUFFER, USB_RT_PORT, devinfo,
 			       tt, NULL, 0, 1000);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f69c877..3c9e37e 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -669,8 +669,8 @@ struct dwc3 {
 
 struct dwc3_event_type {
 	u32	is_devspec:1;
-	u32	type:6;
-	u32	reserved8_31:25;
+	u32	type:7;
+	u32	reserved8_31:24;
 } __packed;
 
 #define DWC3_DEPEVT_XFERCOMPLETE	0x01
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3530c2b..5a7755b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1445,6 +1445,7 @@ err1:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 
 err0:
+	dwc->gadget_driver = NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 349d3fe..c3a3a72 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -827,6 +827,7 @@ static int ehci_hub_control (
 				/* resume signaling for 20 msec */
 				ehci->reset_done[wIndex] = jiffies
 						+ msecs_to_jiffies(20);
+				set_bit(wIndex, &ehci->resuming_ports);
 				/* check the port again */
 				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
 						ehci->reset_done[wIndex]);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index dcb72f7..be08444 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -93,7 +93,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
-		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
 		xhci->quirks |= XHCI_SW_BW_CHECKING;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8d0b1e8..37cecce 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -434,7 +434,7 @@ static void ring_doorbell_for_active_rings(struct xhci_hcd *xhci,
 
 	/* A ring has pending URBs if its TD list is not empty */
 	if (!(ep->ep_state & EP_HAS_STREAMS)) {
-		if (!(list_empty(&ep->ring->td_list)))
+		if (ep->ring && !(list_empty(&ep->ring->td_list)))
 			xhci_ring_ep_doorbell(xhci, slot_id, ep_index, 0);
 		return;
 	}
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bd96077..585bd6c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1162,9 +1162,6 @@ static int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 	}
 
 	xhci = hcd_to_xhci(hcd);
-	if (xhci->xhc_state & XHCI_STATE_HALTED)
-		return -ENODEV;
-
 	if (check_virt_dev) {
 		if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
 			printk(KERN_DEBUG "xHCI %s called with unaddressed "
@@ -1180,6 +1177,9 @@ static int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 		}
 	}
 
+	if (xhci->xhc_state & XHCI_STATE_HALTED)
+		return -ENODEV;
+
 	return 1;
 }
 
@@ -4662,6 +4662,13 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	get_quirks(dev, xhci);
 
+	/* In xhci controllers which follow xhci 1.0 spec gives a spurious
+	 * success event after a short transfer. This quirk will ignore such
+	 * spurious event.
+	 */
+	if (xhci->hci_version > 0x96)
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
+
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
 	if (retval)
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index dd573ab..7af163d 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3247,6 +3247,7 @@ static const struct usb_device_id sisusb_table[] = {
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
+	{ USB_DEVICE(0x0711, 0x0950) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 489ab7d..2ab3af1 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -60,6 +60,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0489, 0xE003) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
+	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
 	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acceptor */
@@ -124,6 +125,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
@@ -154,6 +157,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index dada37f..297847b 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -973,20 +973,20 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset, &Data);
 	if (status < 0) {
 		dbg("Reading Spreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 
 	Data &= ~0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 	/* End of block to be checked */
 
@@ -995,7 +995,7 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 									&Data);
 	if (status < 0) {
 		dbg("Reading Controlreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x08;		/* Driver done bit */
 	Data |= 0x20;		/* rx_disable */
@@ -1003,7 +1003,7 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 				mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Controlreg failed");
-		return -1;
+		goto err;
 	}
 	/* do register settings here */
 	/* Set all regs to the device default values. */
@@ -1014,21 +1014,21 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	status = mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
 	if (status < 0) {
 		dbg("disabling interrupts failed");
-		return -1;
+		goto err;
 	}
 	/* Set FIFO_CONTROL_REGISTER to the default value */
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0xcf;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0x03;
@@ -1182,6 +1182,15 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 				serial, mos7840_port, port);
 
 	return 0;
+err:
+	for (j = 0; j < NUM_URBS; ++j) {
+		urb = mos7840_port->write_urb_pool[j];
+		if (!urb)
+			continue;
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+	}
+	return status;
 }
 
 /*****************************************************************************
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 71ae3ca..7785df0 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -347,17 +347,12 @@ static void option_instat_callback(struct urb *urb);
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
+#define OLIVETTI_PRODUCT_OLICARD200		0xc005
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
 #define CELOT_PRODUCT_CT680M			0x6801
 
-/* ONDA Communication vendor id */
-#define ONDA_VENDOR_ID       0x1ee8
-
-/* ONDA MT825UP HSDPA 14.2 modem */
-#define ONDA_MT825UP         0x000b
-
 /* Samsung products */
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889
@@ -450,7 +445,8 @@ static void option_instat_callback(struct urb *urb);
 
 /* Hyundai Petatel Inc. products */
 #define PETATEL_VENDOR_ID			0x1ff4
-#define PETATEL_PRODUCT_NP10T			0x600e
+#define PETATEL_PRODUCT_NP10T_600A		0x600a
+#define PETATEL_PRODUCT_NP10T_600E		0x600e
 
 /* TP-LINK Incorporated products */
 #define TPLINK_VENDOR_ID			0x2357
@@ -797,6 +793,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
@@ -832,7 +829,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0017, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0018, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0020, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0021, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
@@ -1278,8 +1276,8 @@ static const struct usb_device_id option_ids[] = {
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
-	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM610) },
@@ -1351,9 +1349,12 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
-	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
+	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
+	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
 	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(TPLINK_VENDOR_ID, 0x9000),					/* TP-Link MA260 */
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CHANGHONG_VENDOR_ID, CHANGHONG_PRODUCT_CH690) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d01, 0xff, 0x02, 0x01) },	/* D-Link DWM-156 (variant) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d01, 0xff, 0x00, 0x00) },	/* D-Link DWM-156 (variant) */
@@ -1361,6 +1362,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d02, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index a8c03e6..2f02f79 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -380,7 +380,7 @@ static int ti_startup(struct usb_serial *serial)
 	usb_set_serial_data(serial, tdev);
 
 	/* determine device type */
-	if (usb_match_id(serial->interface, ti_id_table_3410))
+	if (serial->type == &ti_1port_device)
 		tdev->td_is_3410 = 1;
 	dbg("%s - device type is %s", __func__,
 				tdev->td_is_3410 ? "3410" : "5052");
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 8c05e41..ae14acd 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -657,6 +657,13 @@ UNUSUAL_DEV(  0x054c, 0x016a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Submitted by Ren Bigcren <bigcren.ren@sonymobile.com> */
+UNUSUAL_DEV(  0x054c, 0x02a5, 0x0100, 0x0100,
+		"Sony Corp.",
+		"MicroVault Flash Drive",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_READ_CAPACITY_16 ),
+
 /* floppy reports multiple luns */
 UNUSUAL_DEV(  0x055d, 0x2020, 0x0000, 0x0210,
 		"SAMSUNG",
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1244094..7da78cf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -57,17 +57,24 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
+	bool wakeup_bdi = false;
 
 	if (unlikely(dst == old))		/* deadlock avoidance */
 		return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY)
+	if (inode->i_state & I_DIRTY) {
+		if (bdi_cap_writeback_dirty(dst) && !wb_has_dirty_io(&dst->wb))
+			wakeup_bdi = true;
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	}
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&old->wb.list_lock);
 	spin_unlock(&dst->wb.list_lock);
+
+	if (wakeup_bdi)
+		bdi_wakeup_thread_delayed(dst);
 }
 
 sector_t blkdev_max_block(struct block_device *bdev)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e99ea0..9b1dc7b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6905,6 +6905,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -6921,6 +6922,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6fbfbdb..293226e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -549,6 +549,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 			fattr->cf_mode &= ~(S_IWUGO);
 
 		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+		if (fattr->cf_nlink < 1) {
+			cFYI(1, "replacing bogus file nlink value %u\n",
+				fattr->cf_nlink);
+			fattr->cf_nlink = 1;
+		}
 	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4986dd3..aaece99 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4636,11 +4636,16 @@ do_more:
 		 * blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed
 		 */
+	retry:
 		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
 		if (!new_entry) {
-			ext4_mb_unload_buddy(&e4b);
-			err = -ENOMEM;
-			goto error_return;
+			/*
+			 * We use a retry loop because
+			 * ext4_free_blocks() is not allowed to fail.
+			 */
+			cond_resched();
+			congestion_wait(BLK_RW_ASYNC, HZ/50);
+			goto retry;
 		}
 		new_entry->efd_start_cluster = bit;
 		new_entry->efd_group = block_group;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 89abdd7..0689c5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1749,12 +1749,6 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
-
-	if (test_opt(sb, USRQUOTA))
-		seq_puts(seq, ",usrquota");
-
-	if (test_opt(sb, GRPQUOTA))
-		seq_puts(seq, ",grpquota");
 #endif
 }
 
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index e46353f..aff1c61 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -941,6 +941,7 @@ nlmsvc_retry_blocked(void)
 	unsigned long	timeout = MAX_SCHEDULE_TIMEOUT;
 	struct nlm_block *block;
 
+	spin_lock(&nlm_blocked_lock);
 	while (!list_empty(&nlm_blocked) && !kthread_should_stop()) {
 		block = list_entry(nlm_blocked.next, struct nlm_block, b_list);
 
@@ -950,6 +951,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
 			block, block->b_when);
@@ -959,7 +961,9 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		spin_lock(&nlm_blocked_lock);
 	}
+	spin_unlock(&nlm_blocked_lock);
 
 	return timeout;
 }
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b2ae2da..65ed9bf 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -161,8 +161,8 @@ static __be32 *read_buf(struct nfsd4_compoundargs *argp, u32 nbytes)
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->p = page_address(argp->pagelist[0]);
 	argp->pagelist++;
+	argp->p = page_address(argp->pagelist[0]);
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 0191ede..20c5092 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -794,9 +794,10 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	}
 	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt),
 			    flags, current_cred());
-	if (IS_ERR(*filp))
+	if (IS_ERR(*filp)) {
 		host_err = PTR_ERR(*filp);
-	else {
+		*filp = NULL;
+	} else {
 		host_err = ima_file_check(*filp, may_flags);
 
 		if (may_flags & NFSD_MAY_64BIT_COOKIE)
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3568c8a..48bc91d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -120,6 +120,7 @@ static int fill_event_metadata(struct fsnotify_group *group,
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->reserved = 0;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
 	if (unlikely(event->mask & FAN_Q_OVERFLOW))
diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 09c474c..b8b7544 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -140,11 +140,11 @@ struct pppoe_tag {
 
 struct pppoe_hdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 ver : 4;
 	__u8 type : 4;
+	__u8 ver : 4;
 #elif defined(__BIG_ENDIAN_BITFIELD)
-	__u8 type : 4;
 	__u8 ver : 4;
+	__u8 type : 4;
 #else
 #error	"Please fix <asm/byteorder.h>"
 #endif
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 91b2a85..cc24a34 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -81,6 +81,9 @@ extern int			ipv6_dev_get_saddr(struct net *net,
 					       const struct in6_addr *daddr,
 					       unsigned int srcprefs,
 					       struct in6_addr *saddr);
+extern int			__ipv6_get_lladdr(struct inet6_dev *idev,
+						  struct in6_addr *addr,
+						  unsigned char banned_flags);
 extern int			ipv6_get_lladdr(struct net_device *dev,
 						struct in6_addr *addr,
 						unsigned char banned_flags);
diff --git a/include/net/udp.h b/include/net/udp.h
index 065f379..ad99eed 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -181,6 +181,7 @@ extern int udp_get_port(struct sock *sk, unsigned short snum,
 extern void udp_err(struct sk_buff *, u32);
 extern int udp_sendmsg(struct kiocb *iocb, struct sock *sk,
 			    struct msghdr *msg, size_t len);
+extern int udp_push_pending_frames(struct sock *sk);
 extern void udp_flush_pending_frames(struct sock *sk);
 extern int udp_rcv(struct sk_buff *skb);
 extern int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f5505f7..00aa7e3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -723,8 +723,18 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
 {
 	struct perf_event_context *ctx;
 
-	rcu_read_lock();
 retry:
+	/*
+	 * One of the few rules of preemptible RCU is that one cannot do
+	 * rcu_read_unlock() while holding a scheduler (or nested) lock when
+	 * part of the read side critical section was preemptible -- see
+	 * rcu_read_unlock_special().
+	 *
+	 * Since ctx->lock nests under rq->lock we must ensure the entire read
+	 * side critical section is non-preemptible.
+	 */
+	preempt_disable();
+	rcu_read_lock();
 	ctx = rcu_dereference(task->perf_event_ctxp[ctxn]);
 	if (ctx) {
 		/*
@@ -740,6 +750,8 @@ retry:
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
+			rcu_read_unlock();
+			preempt_enable();
 			goto retry;
 		}
 
@@ -749,6 +761,7 @@ retry:
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 	return ctx;
 }
 
@@ -1706,7 +1719,16 @@ static int __perf_event_enable(void *info)
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
-	if (WARN_ON_ONCE(!ctx->is_active))
+	/*
+	 * There's a time window between 'ctx->is_active' check
+	 * in perf_event_enable function and this place having:
+	 *   - IRQs on
+	 *   - ctx->lock unlocked
+	 *
+	 * where the task could be killed and 'ctx' deactivated
+	 * by perf_event_exit_task.
+	 */
+	if (!ctx->is_active)
 		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
@@ -6936,7 +6958,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 60f7e32..a57ef25 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -707,17 +707,20 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
 /*
- * Called from timekeeping code to reprogramm the hrtimer interrupt
- * device. If called from the timer interrupt context we defer it to
- * softirq context.
+ * Called from timekeeping and resume code to reprogramm the hrtimer
+ * interrupt device on all cpus.
  */
 void clock_was_set_delayed(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	cpu_base->clock_was_set = 1;
-	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+	schedule_work(&hrtimer_work);
 }
 
 #else
@@ -766,8 +769,10 @@ void hrtimers_resume(void)
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
+	/* Retrigger on the local CPU */
 	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	/* And schedule a retrigger for all others */
+	clock_was_set_delayed();
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
@@ -1416,13 +1421,6 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	if (cpu_base->clock_was_set) {
-		cpu_base->clock_was_set = 0;
-		clock_was_set();
-	}
-
 	hrtimer_peek_ahead_timers();
 }
 
diff --git a/kernel/power/autosleep.c b/kernel/power/autosleep.c
index ca304046..ab79ecb 100644
--- a/kernel/power/autosleep.c
+++ b/kernel/power/autosleep.c
@@ -32,7 +32,8 @@ static void try_to_suspend(struct work_struct *work)
 
 	mutex_lock(&autosleep_lock);
 
-	if (!pm_save_wakeup_count(initial_count)) {
+	if (!pm_save_wakeup_count(initial_count) ||
+		system_state != SYSTEM_RUNNING) {
 		mutex_unlock(&autosleep_lock);
 		goto out;
 	}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 96fc733..ed3f02b 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -303,6 +303,8 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int size;
 	int syscall_nr;
 
@@ -318,8 +320,11 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->enter_event->event.type, size, 0, 0);
+			sys_data->enter_event->event.type, size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -329,7 +334,8 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
@@ -338,6 +344,8 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
@@ -350,8 +358,12 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type, sizeof(*entry),
+			irq_flags, pc);
 	if (!event)
 		return;
 
@@ -361,7 +373,8 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 int reg_event_syscall_enter(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2b36ac6..5c83613 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -243,8 +243,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		return -EINVAL;
 	}
 	arg = strchr(argv[1], ':');
-	if (!arg)
+	if (!arg) {
+		ret = -EINVAL;
 		goto fail_address_parse;
+	}
 
 	*arg++ = '\0';
 	filename = argv[1];
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 7005e08..b8cf84e 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_device *dev, struct sk_buff *skb)
 {
 	struct vlan_priority_tci_mapping *mp;
 
+	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priority() */
+
 	mp = vlan_dev_priv(dev)->egress_priority_map[(skb->priority & 0xF)];
 	while (mp) {
 		if (mp->priority == skb->priority) {
@@ -235,6 +237,11 @@ int vlan_dev_set_egress_priority(const struct net_device *dev,
 	np->next = mp;
 	np->priority = skb_prio;
 	np->vlan_qos = vlan_qos;
+	/* Before inserting this element in hash table, make sure all its fields
+	 * are committed to memory.
+	 * coupled with smp_rmb() in vlan_dev_get_egress_qos_mask()
+	 */
+	smp_wmb();
 	vlan->egress_priority_map[skb_prio & 0xF] = np;
 	if (vlan_qos)
 		vlan->nr_egress_mappings++;
diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index de8df95..2ee3879 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -24,11 +24,11 @@
  */
 void p9_release_pages(struct page **pages, int nr_pages)
 {
-	int i = 0;
-	while (pages[i] && nr_pages--) {
-		put_page(pages[i]);
-		i++;
-	}
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		if (pages[i])
+			put_page(pages[i]);
 }
 EXPORT_SYMBOL(p9_release_pages);
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b665812..4c1954b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -469,8 +469,9 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	skb_set_transport_header(skb, skb->len);
 	mldq = (struct mld_msg *) icmp6_hdr(skb);
 
-	interval = ipv6_addr_any(group) ? br->multicast_last_member_interval :
-					  br->multicast_query_response_interval;
+	interval = ipv6_addr_any(group) ?
+			br->multicast_query_response_interval :
+			br->multicast_last_member_interval;
 
 	mldq->mld_type = ICMPV6_MGM_QUERY;
 	mldq->mld_code = 0;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5c2dac3..c09f82b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -239,7 +239,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev)
 				   we must kill timers etc. and move
 				   it to safe state.
 				 */
-				skb_queue_purge(&n->arp_queue);
+				__skb_queue_purge(&n->arp_queue);
 				n->arp_queue_len_bytes = 0;
 				n->output = neigh_blackhole;
 				if (n->nud_state & NUD_VALID)
@@ -302,7 +302,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl, struct net_device
 	if (!n)
 		goto out_entries;
 
-	skb_queue_head_init(&n->arp_queue);
+	__skb_queue_head_init(&n->arp_queue);
 	rwlock_init(&n->lock);
 	seqlock_init(&n->ha_lock);
 	n->updated	  = n->used = now;
@@ -722,7 +722,9 @@ void neigh_destroy(struct neighbour *neigh)
 	if (neigh_del_timer(neigh))
 		pr_warn("Impossible event\n");
 
-	skb_queue_purge(&neigh->arp_queue);
+	write_lock_bh(&neigh->lock);
+	__skb_queue_purge(&neigh->arp_queue);
+	write_unlock_bh(&neigh->lock);
 	neigh->arp_queue_len_bytes = 0;
 
 	if (dev->netdev_ops->ndo_neigh_destroy)
@@ -868,7 +870,7 @@ static void neigh_invalidate(struct neighbour *neigh)
 		neigh->ops->error_report(neigh, skb);
 		write_lock(&neigh->lock);
 	}
-	skb_queue_purge(&neigh->arp_queue);
+	__skb_queue_purge(&neigh->arp_queue);
 	neigh->arp_queue_len_bytes = 0;
 }
 
@@ -1207,7 +1209,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
 
 			write_lock_bh(&neigh->lock);
 		}
-		skb_queue_purge(&neigh->arp_queue);
+		__skb_queue_purge(&neigh->arp_queue);
 		neigh->arp_queue_len_bytes = 0;
 	}
 out:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2a95340..f374da4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -989,7 +989,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, addr, family);
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
@@ -1034,7 +1034,7 @@ int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family)
 	struct tcp_md5sig_key *key;
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, addr, family);
 	if (!key)
 		return -ENOENT;
 	hlist_del_rcu(&key->node);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index eaca736..cd45011 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -769,7 +769,7 @@ send:
 /*
  * Push out all pending data as one UDP datagram. Socket is locked.
  */
-static int udp_push_pending_frames(struct sock *sk)
+int udp_push_pending_frames(struct sock *sk)
 {
 	struct udp_sock  *up = udp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
@@ -788,6 +788,7 @@ out:
 	up->pending = 0;
 	return err;
 }
+EXPORT_SYMBOL(udp_push_pending_frames);
 
 int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		size_t len)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 449df3f..5e23f99 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1231,6 +1231,23 @@ try_nextdev:
 }
 EXPORT_SYMBOL(ipv6_dev_get_saddr);
 
+int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
+		      unsigned char banned_flags)
+{
+	struct inet6_ifaddr *ifp;
+	int err = -EADDRNOTAVAIL;
+
+	list_for_each_entry(ifp, &idev->addr_list, if_list) {
+		if (ifp->scope == IFA_LINK &&
+		    !(ifp->flags & banned_flags)) {
+			*addr = ifp->addr;
+			err = 0;
+			break;
+		}
+	}
+	return err;
+}
+
 int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 		    unsigned char banned_flags)
 {
@@ -1240,17 +1257,8 @@ int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 	rcu_read_lock();
 	idev = __in6_dev_get(dev);
 	if (idev) {
-		struct inet6_ifaddr *ifp;
-
 		read_lock_bh(&idev->lock);
-		list_for_each_entry(ifp, &idev->addr_list, if_list) {
-			if (ifp->scope == IFA_LINK &&
-			    !(ifp->flags & banned_flags)) {
-				*addr = ifp->addr;
-				err = 0;
-				break;
-			}
-		}
+		err = __ipv6_get_lladdr(idev, addr, banned_flags);
 		read_unlock_bh(&idev->lock);
 	}
 	rcu_read_unlock();
@@ -2432,6 +2440,9 @@ static void init_loopback(struct net_device *dev)
 			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
 				continue;
 
+			if (sp_ifa->rt)
+				continue;
+
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
 			/* Failure cases are ignored */
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ccb2adb..8fa50aa 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -919,11 +919,17 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
 					  const struct flowi6 *fl6)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct rt6_info *rt = (struct rt6_info *)dst;
+	struct rt6_info *rt;
 
 	if (!dst)
 		goto out;
 
+	if (dst->ops->family != AF_INET6) {
+		dst_release(dst);
+		return NULL;
+	}
+
+	rt = (struct rt6_info *)dst;
 	/* Yes, checking route validity in not connected
 	 * case is not very simple. Take into account,
 	 * that we do not support routing by source, TOS,
@@ -1188,11 +1194,12 @@ static inline struct ipv6_rt_hdr *ip6_rthdr_dup(struct ipv6_rt_hdr *src,
 	return src ? kmemdup(src, (src->hdrlen + 1) * 8, gfp) : NULL;
 }
 
-static void ip6_append_data_mtu(int *mtu,
+static void ip6_append_data_mtu(unsigned int *mtu,
 				int *maxfraglen,
 				unsigned int fragheaderlen,
 				struct sk_buff *skb,
-				struct rt6_info *rt)
+				struct rt6_info *rt,
+				bool pmtuprobe)
 {
 	if (!(rt->dst.flags & DST_XFRM_TUNNEL)) {
 		if (skb == NULL) {
@@ -1204,7 +1211,9 @@ static void ip6_append_data_mtu(int *mtu,
 			 * this fragment is not first, the headers
 			 * space is regarded as data space.
 			 */
-			*mtu = dst_mtu(rt->dst.path);
+			*mtu = min(*mtu, pmtuprobe ?
+				   rt->dst.dev->mtu :
+				   dst_mtu(rt->dst.path));
 		}
 		*maxfraglen = ((*mtu - fragheaderlen) & ~7)
 			      + fragheaderlen - sizeof(struct frag_hdr);
@@ -1221,11 +1230,10 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_cork *cork;
 	struct sk_buff *skb, *skb_prev = NULL;
-	unsigned int maxfraglen, fragheaderlen;
+	unsigned int maxfraglen, fragheaderlen, mtu;
 	int exthdrlen;
 	int dst_exthdrlen;
 	int hh_len;
-	int mtu;
 	int copy;
 	int err;
 	int offset = 0;
@@ -1387,7 +1395,9 @@ alloc_new_skb:
 			/* update mtu and maxfraglen if necessary */
 			if (skb == NULL || skb_prev == NULL)
 				ip6_append_data_mtu(&mtu, &maxfraglen,
-						    fragheaderlen, skb, rt);
+						    fragheaderlen, skb, rt,
+						    np->pmtudisc ==
+						    IPV6_PMTUDISC_PROBE);
 
 			skb_prev = skb;
 
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 6d0f5dc..2e97228 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1334,8 +1334,9 @@ mld_scount(struct ifmcaddr6 *pmc, int type, int gdeleted, int sdeleted)
 	return scount;
 }
 
-static struct sk_buff *mld_newpack(struct net_device *dev, int size)
+static struct sk_buff *mld_newpack(struct inet6_dev *idev, int size)
 {
+	struct net_device *dev = idev->dev;
 	struct net *net = dev_net(dev);
 	struct sock *sk = net->ipv6.igmp_sk;
 	struct sk_buff *skb;
@@ -1360,7 +1361,7 @@ static struct sk_buff *mld_newpack(struct net_device *dev, int size)
 
 	skb_reserve(skb, hlen);
 
-	if (ipv6_get_lladdr(dev, &addr_buf, IFA_F_TENTATIVE)) {
+	if (__ipv6_get_lladdr(idev, &addr_buf, IFA_F_TENTATIVE)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
 		 * use unspecified address as the source address
 		 * when a valid link-local address is not available.
@@ -1456,7 +1457,7 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	struct mld2_grec *pgr;
 
 	if (!skb)
-		skb = mld_newpack(dev, dev->mtu);
+		skb = mld_newpack(pmc->idev, dev->mtu);
 	if (!skb)
 		return NULL;
 	pgr = (struct mld2_grec *)skb_put(skb, sizeof(struct mld2_grec));
@@ -1476,7 +1477,8 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	int type, int gdeleted, int sdeleted)
 {
-	struct net_device *dev = pmc->idev->dev;
+	struct inet6_dev *idev = pmc->idev;
+	struct net_device *dev = idev->dev;
 	struct mld2_report *pmr;
 	struct mld2_grec *pgr = NULL;
 	struct ip6_sf_list *psf, *psf_next, *psf_prev, **psf_list;
@@ -1505,7 +1507,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 		    AVAILABLE(skb) < grec_size(pmc, type, gdeleted, sdeleted)) {
 			if (skb)
 				mld_sendpack(skb);
-			skb = mld_newpack(dev, dev->mtu);
+			skb = mld_newpack(idev, dev->mtu);
 		}
 	}
 	first = 1;
@@ -1532,7 +1534,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 				pgr->grec_nsrcs = htons(scount);
 			if (skb)
 				mld_sendpack(skb);
-			skb = mld_newpack(dev, dev->mtu);
+			skb = mld_newpack(idev, dev->mtu);
 			first = 1;
 			scount = 0;
 		}
@@ -1587,8 +1589,8 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 	struct sk_buff *skb = NULL;
 	int type;
 
+	read_lock_bh(&idev->lock);
 	if (!pmc) {
-		read_lock_bh(&idev->lock);
 		for (pmc=idev->mc_list; pmc; pmc=pmc->next) {
 			if (pmc->mca_flags & MAF_NOREPORT)
 				continue;
@@ -1600,7 +1602,6 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 			skb = add_grec(skb, pmc, type, 0, 0);
 			spin_unlock_bh(&pmc->mca_lock);
 		}
-		read_unlock_bh(&idev->lock);
 	} else {
 		spin_lock_bh(&pmc->mca_lock);
 		if (pmc->mca_sfcount[MCAST_EXCLUDE])
@@ -1610,6 +1611,7 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 		skb = add_grec(skb, pmc, type, 0, 0);
 		spin_unlock_bh(&pmc->mca_lock);
 	}
+	read_unlock_bh(&idev->lock);
 	if (skb)
 		mld_sendpack(skb);
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 577bb2f..8253206 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1032,10 +1032,13 @@ static void ip6_link_failure(struct sk_buff *skb)
 
 	rt = (struct rt6_info *) skb_dst(skb);
 	if (rt) {
-		if (rt->rt6i_flags & RTF_CACHE)
-			rt6_update_expires(rt, 0);
-		else if (rt->rt6i_node && (rt->rt6i_flags & RTF_DEFAULT))
+		if (rt->rt6i_flags & RTF_CACHE) {
+			dst_hold(&rt->dst);
+			if (ip6_del_rt(rt))
+				dst_free(&rt->dst);
+		} else if (rt->rt6i_node && (rt->rt6i_flags & RTF_DEFAULT)) {
 			rt->rt6i_node->fn_sernum = -1;
+		}
 	}
 }
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3a5491d..a006a21 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -937,11 +937,16 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 	struct udphdr *uh;
 	struct udp_sock  *up = udp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	struct flowi6 *fl6 = &inet->cork.fl.u.ip6;
+	struct flowi6 *fl6;
 	int err = 0;
 	int is_udplite = IS_UDPLITE(sk);
 	__wsum csum = 0;
 
+	if (up->pending == AF_INET)
+		return udp_push_pending_frames(sk);
+
+	fl6 = &inet->cork.fl.u.ip6;
+
 	/* Grab the skbuff where UDP header space exists. */
 	if ((skb = skb_peek(&sk->sk_write_queue)) == NULL)
 		goto out;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 34e4185..7a09bbb 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1705,6 +1705,7 @@ static int key_notify_sa_flush(const struct km_event *c)
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
+	hdr->sadb_msg_reserved = 0;
 
 	pfkey_broadcast(skb, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
 
@@ -2686,6 +2687,7 @@ static int key_notify_policy_flush(const struct km_event *c)
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
+	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
 	return 0;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index ea7e244..286fec4 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1837,7 +1837,8 @@ static const struct proto_ops pppol2tp_ops = {
 
 static const struct pppox_proto pppol2tp_proto = {
 	.create		= pppol2tp_create,
-	.ioctl		= pppol2tp_ioctl
+	.ioctl		= pppol2tp_ioctl,
+	.owner		= THIS_MODULE,
 };
 
 #ifdef CONFIG_L2TP_V3
diff --git a/net/sunrpc/xprtrdma/svc_rdma_marshal.c b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
index 8d2eddd..65b1462 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
@@ -98,6 +98,7 @@ void svc_rdma_rcl_chunk_counts(struct rpcrdma_read_chunk *ch,
  */
 static u32 *decode_write_list(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 
 	struct rpcrdma_write_array *ary =
@@ -113,9 +114,12 @@ static u32 *decode_write_list(u32 *va, u32 *vaend)
 		return NULL;
 	}
 	nchunks = ntohl(ary->wc_nchunks);
-	if (((unsigned long)&ary->wc_array[0] +
-	     (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
-	    (unsigned long)vaend) {
+
+	start = (unsigned long)&ary->wc_array[0];
+	end = (unsigned long)vaend;
+	if (nchunks < 0 ||
+	    nchunks > (SIZE_MAX - start) / sizeof(struct rpcrdma_write_chunk) ||
+	    (start + (sizeof(struct rpcrdma_write_chunk) * nchunks)) > end) {
 		dprintk("svcrdma: ary=%p, wc_nchunks=%d, vaend=%p\n",
 			ary, nchunks, vaend);
 		return NULL;
@@ -129,6 +133,7 @@ static u32 *decode_write_list(u32 *va, u32 *vaend)
 
 static u32 *decode_reply_array(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 	struct rpcrdma_write_array *ary =
 		(struct rpcrdma_write_array *)va;
@@ -143,9 +148,12 @@ static u32 *decode_reply_array(u32 *va, u32 *vaend)
 		return NULL;
 	}
 	nchunks = ntohl(ary->wc_nchunks);
-	if (((unsigned long)&ary->wc_array[0] +
-	     (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
-	    (unsigned long)vaend) {
+
+	start = (unsigned long)&ary->wc_array[0];
+	end = (unsigned long)vaend;
+	if (nchunks < 0 ||
+	    nchunks > (SIZE_MAX - start) / sizeof(struct rpcrdma_write_chunk) ||
+	    (start + (sizeof(struct rpcrdma_write_chunk) * nchunks)) > end) {
 		dprintk("svcrdma: ary=%p, wc_nchunks=%d, vaend=%p\n",
 			ary, nchunks, vaend);
 		return NULL;
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index a306bc6..b943e3e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1586,11 +1586,11 @@ out_cud_release:
 	case SIOCX25CALLACCPTAPPRV: {
 		rc = -EINVAL;
 		lock_sock(sk);
-		if (sk->sk_state != TCP_CLOSE)
-			break;
-		clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
+		if (sk->sk_state == TCP_CLOSE) {
+			clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
+			rc = 0;
+		}
 		release_sock(sk);
-		rc = 0;
 		break;
 	}
 
@@ -1598,14 +1598,15 @@ out_cud_release:
 		rc = -EINVAL;
 		lock_sock(sk);
 		if (sk->sk_state != TCP_ESTABLISHED)
-			break;
+			goto out_sendcallaccpt_release;
 		/* must call accptapprv above */
 		if (test_bit(X25_ACCPT_APPRV_FLAG, &x25->flags))
-			break;
+			goto out_sendcallaccpt_release;
 		x25_write_internal(sk, X25_CALL_ACCEPTED);
 		x25->state = X25_STATE_3;
-		release_sock(sk);
 		rc = 0;
+out_sendcallaccpt_release:
+		release_sock(sk);
 		break;
 	}
 
diff --git a/sound/arm/pxa2xx-pcm-lib.c b/sound/arm/pxa2xx-pcm-lib.c
index 76e0d56..823359e 100644
--- a/sound/arm/pxa2xx-pcm-lib.c
+++ b/sound/arm/pxa2xx-pcm-lib.c
@@ -166,7 +166,9 @@ void pxa2xx_pcm_dma_irq(int dma_ch, void *dev_id)
 	} else {
 		printk(KERN_ERR "%s: DMA error on channel %d (DCSR=%#x)\n",
 			rtd->params->name, dma_ch, dcsr);
+		snd_pcm_stream_lock(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(substream);
 	}
 }
 EXPORT_SYMBOL(pxa2xx_pcm_dma_irq);
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index e8de831..05093bd 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -769,7 +769,10 @@ static void snd_card_asihpi_timer_function(unsigned long data)
 						s->number);
 				ds->drained_count++;
 				if (ds->drained_count > 20) {
+					unsigned long flags;
+					snd_pcm_stream_lock_irqsave(s, flags);
 					snd_pcm_stop(s, SNDRV_PCM_STATE_XRUN);
+					snd_pcm_stream_unlock_irqrestore(s, flags);
 					continue;
 				}
 			} else {
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 156a94f..e0ed83a 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -688,7 +688,9 @@ static void snd_atiixp_xrun_dma(struct atiixp *chip, struct atiixp_dma *dma)
 	if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp: XRUN detected (DMA %d)\n", dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 30a4fd9..f68704c 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -638,7 +638,9 @@ static void snd_atiixp_xrun_dma(struct atiixp_modem *chip,
 	if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp-modem: XRUN detected (DMA %d)\n", dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 2af1285..375e0ff 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1897,6 +1897,8 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0042, .name = "GPU 42 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0043, .name = "GPU 43 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0044, .name = "GPU 44 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x80860054, .name = "IbexPeak HDMI",	.patch = patch_generic_hdmi },
@@ -1943,6 +1945,8 @@ MODULE_ALIAS("snd-hda-codec-id:10de0041");
 MODULE_ALIAS("snd-hda-codec-id:10de0042");
 MODULE_ALIAS("snd-hda-codec-id:10de0043");
 MODULE_ALIAS("snd-hda-codec-id:10de0044");
+MODULE_ALIAS("snd-hda-codec-id:10de0051");
+MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:17e80047");
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4790568..8df4597 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1594,7 +1594,7 @@ static int max98088_dai2_digital_mute(struct snd_soc_dai *codec_dai, int mute)
 
 static void max98088_sync_cache(struct snd_soc_codec *codec)
 {
-       u16 *reg_cache = codec->reg_cache;
+       u8 *reg_cache = codec->reg_cache;
        int i;
 
        if (!codec->cache_sync)
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 8af6a52..ab5c078 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -37,7 +37,7 @@
 static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET] =  {
 	[SGTL5000_CHIP_CLK_CTRL] = 0x0008,
 	[SGTL5000_CHIP_I2S_CTRL] = 0x0010,
-	[SGTL5000_CHIP_SSS_CTRL] = 0x0008,
+	[SGTL5000_CHIP_SSS_CTRL] = 0x0010,
 	[SGTL5000_CHIP_DAC_VOL] = 0x3c3c,
 	[SGTL5000_CHIP_PAD_STRENGTH] = 0x015f,
 	[SGTL5000_CHIP_ANA_HP_CTRL] = 0x1818,
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 8a9f435..d3a68bb 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -347,7 +347,7 @@
 #define SGTL5000_PLL_INT_DIV_MASK		0xf800
 #define SGTL5000_PLL_INT_DIV_SHIFT		11
 #define SGTL5000_PLL_INT_DIV_WIDTH		5
-#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
+#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff
 #define SGTL5000_PLL_FRAC_DIV_SHIFT		0
 #define SGTL5000_PLL_FRAC_DIV_WIDTH		11
 
diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index 716da86..17f9348 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -128,7 +128,9 @@ static irqreturn_t s6000_pcm_irq(int irq, void *data)
 		    substream->runtime &&
 		    snd_pcm_running(substream)) {
 			dev_dbg(pcm->dev, "xrun\n");
+			snd_pcm_stream_lock(substream);
 			snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock(substream);
 			ret = IRQ_HANDLED;
 		}
 
diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index c97d05f..7c4f311 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -540,7 +540,7 @@ static snd_pcm_uframes_t usb6fire_pcm_pointer(
 	snd_pcm_uframes_t ret;
 
 	if (rt->panic || !sub)
-		return SNDRV_PCM_STATE_XRUN;
+		return SNDRV_PCM_POS_XRUN;
 
 	spin_lock_irqsave(&sub->lock, flags);
 	ret = sub->dma_off;
@@ -639,17 +639,25 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 void usb6fire_pcm_abort(struct sfire_chip *chip)
 {
 	struct pcm_runtime *rt = chip->pcm;
+	unsigned long flags;
 	int i;
 
 	if (rt) {
 		rt->panic = true;
 
-		if (rt->playback.instance)
+		if (rt->playback.instance) {
+			snd_pcm_stream_lock_irqsave(rt->playback.instance, flags);
 			snd_pcm_stop(rt->playback.instance,
 					SNDRV_PCM_STATE_XRUN);
-		if (rt->capture.instance)
+			snd_pcm_stream_unlock_irqrestore(rt->playback.instance, flags);
+		}
+
+		if (rt->capture.instance) {
+			snd_pcm_stream_lock_irqsave(rt->capture.instance, flags);
 			snd_pcm_stop(rt->capture.instance,
 					SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock_irqrestore(rt->capture.instance, flags);
+		}
 
 		for (i = 0; i < PCM_N_URBS; i++) {
 			usb_poison_urb(&rt->in_urbs[i].instance);
diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 8b81cb5..d97d35d 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -613,14 +613,24 @@ static int start_usb_playback(struct ua101 *ua)
 
 static void abort_alsa_capture(struct ua101 *ua)
 {
-	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states))
+	unsigned long flags;
+
+	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states)) {
+		snd_pcm_stream_lock_irqsave(ua->capture.substream, flags);
 		snd_pcm_stop(ua->capture.substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock_irqrestore(ua->capture.substream, flags);
+	}
 }
 
 static void abort_alsa_playback(struct ua101 *ua)
 {
-	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
+	unsigned long flags;
+
+	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
+		snd_pcm_stream_lock_irqsave(ua->playback.substream, flags);
 		snd_pcm_stop(ua->playback.substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock_irqrestore(ua->playback.substream, flags);
+	}
 }
 
 static int set_stream_hw(struct ua101 *ua, struct snd_pcm_substream *substream,
diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 520ef96..43d337d 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -273,7 +273,11 @@ static void usX2Y_clients_stop(struct usX2Ydev *usX2Y)
 		struct snd_usX2Y_substream *subs = usX2Y->subs[s];
 		if (subs) {
 			if (atomic_read(&subs->state) >= state_PRERUNNING) {
+				unsigned long flags;
+
+				snd_pcm_stream_lock_irqsave(subs->pcm_substream, flags);
 				snd_pcm_stop(subs->pcm_substream, SNDRV_PCM_STATE_XRUN);
+				snd_pcm_stream_unlock_irqrestore(subs->pcm_substream, flags);
 			}
 			for (u = 0; u < NRURBS; u++) {
 				struct urb *urb = subs->urb[u];
