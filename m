Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3K2KNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:13:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3K2KNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:13:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.26
Date: Fri, 29 Nov 2013 10:13:05 +0000
Message-Id: <1385719985-11391-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385719985-11391-1-git-send-email-luis.henriques@canonical.com>
References: <1385719985-11391-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d78841..99d8ab9 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -284,13 +284,24 @@ Default value is "/sbin/hotplug".
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
-exposing kernel addresses via /proc and other interfaces.  When
-kptr_restrict is set to (0), there are no restrictions.  When
-kptr_restrict is set to (1), the default, kernel pointers
-printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.  When kptr_restrict is set to
-(2), kernel pointers printed using %pK will be replaced with 0's
-regardless of privileges.
+exposing kernel addresses via /proc and other interfaces.
+
+When kptr_restrict is set to (0), the default, there are no restrictions.
+
+When kptr_restrict is set to (1), kernel pointers printed using the %pK
+format specifier will be replaced with 0's unless the user has CAP_SYSLOG
+and effective user and group ids are equal to the real ids. This is
+because %pK checks are done at read() time rather than open() time, so
+if permissions are elevated between the open() and the read() (e.g via
+a setuid binary) then %pK will not leak kernel pointers to unprivileged
+users. Note, this is a temporary solution only. The correct long-term
+solution is to do the permission checks at open() time. Consider removing
+world read permissions from files that use %pK, and using dmesg_restrict
+to protect against uses of %pK in dmesg(8) if leaking kernel pointer
+values to unprivileged users is a concern.
+
+When kptr_restrict is set to (2), kernel pointers printed using
+%pK will be replaced with 0's regardless of privileges.
 
 ==============================================================
 
diff --git a/Makefile b/Makefile
index e753078..8a0c61d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .25
+EXTRAVERSION = .26
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
index 650d592..94b0650 100644
--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -14,27 +14,15 @@
 
 	.text
 	.align	5
-	.word	0
-
-1:	subs	r2, r2, #4		@ 1 do we have enough
-	blt	5f			@ 1 bytes to align with?
-	cmp	r3, #2			@ 1
-	strltb	r1, [r0], #1		@ 1
-	strleb	r1, [r0], #1		@ 1
-	strb	r1, [r0], #1		@ 1
-	add	r2, r2, r3		@ 1 (r2 = r2 - (4 - r3))
-/*
- * The pointer is now aligned and the length is adjusted.  Try doing the
- * memset again.
- */
 
 ENTRY(memset)
 	ands	r3, r0, #3		@ 1 unaligned?
-	bne	1b			@ 1
+	mov	ip, r0			@ preserve r0 as return value
+	bne	6f			@ 1
 /*
- * we know that the pointer in r0 is aligned to a word boundary.
+ * we know that the pointer in ip is aligned to a word boundary.
  */
-	orr	r1, r1, r1, lsl #8
+1:	orr	r1, r1, r1, lsl #8
 	orr	r1, r1, r1, lsl #16
 	mov	r3, r1
 	cmp	r2, #16
@@ -43,29 +31,28 @@ ENTRY(memset)
 #if ! CALGN(1)+0
 
 /*
- * We need an extra register for this loop - save the return address and
- * use the LR
+ * We need 2 extra registers for this loop - use r8 and the LR
  */
-	str	lr, [sp, #-4]!
-	mov	ip, r1
+	stmfd	sp!, {r8, lr}
+	mov	r8, r1
 	mov	lr, r1
 
 2:	subs	r2, r2, #64
-	stmgeia	r0!, {r1, r3, ip, lr}	@ 64 bytes at a time.
-	stmgeia	r0!, {r1, r3, ip, lr}
-	stmgeia	r0!, {r1, r3, ip, lr}
-	stmgeia	r0!, {r1, r3, ip, lr}
+	stmgeia	ip!, {r1, r3, r8, lr}	@ 64 bytes at a time.
+	stmgeia	ip!, {r1, r3, r8, lr}
+	stmgeia	ip!, {r1, r3, r8, lr}
+	stmgeia	ip!, {r1, r3, r8, lr}
 	bgt	2b
-	ldmeqfd	sp!, {pc}		@ Now <64 bytes to go.
+	ldmeqfd	sp!, {r8, pc}		@ Now <64 bytes to go.
 /*
  * No need to correct the count; we're only testing bits from now on
  */
 	tst	r2, #32
-	stmneia	r0!, {r1, r3, ip, lr}
-	stmneia	r0!, {r1, r3, ip, lr}
+	stmneia	ip!, {r1, r3, r8, lr}
+	stmneia	ip!, {r1, r3, r8, lr}
 	tst	r2, #16
-	stmneia	r0!, {r1, r3, ip, lr}
-	ldr	lr, [sp], #4
+	stmneia	ip!, {r1, r3, r8, lr}
+	ldmfd	sp!, {r8, lr}
 
 #else
 
@@ -74,54 +61,63 @@ ENTRY(memset)
  * whole cache lines at once.
  */
 
-	stmfd	sp!, {r4-r7, lr}
+	stmfd	sp!, {r4-r8, lr}
 	mov	r4, r1
 	mov	r5, r1
 	mov	r6, r1
 	mov	r7, r1
-	mov	ip, r1
+	mov	r8, r1
 	mov	lr, r1
 
 	cmp	r2, #96
-	tstgt	r0, #31
+	tstgt	ip, #31
 	ble	3f
 
-	and	ip, r0, #31
-	rsb	ip, ip, #32
-	sub	r2, r2, ip
-	movs	ip, ip, lsl #(32 - 4)
-	stmcsia	r0!, {r4, r5, r6, r7}
-	stmmiia	r0!, {r4, r5}
-	tst	ip, #(1 << 30)
-	mov	ip, r1
-	strne	r1, [r0], #4
+	and	r8, ip, #31
+	rsb	r8, r8, #32
+	sub	r2, r2, r8
+	movs	r8, r8, lsl #(32 - 4)
+	stmcsia	ip!, {r4, r5, r6, r7}
+	stmmiia	ip!, {r4, r5}
+	tst	r8, #(1 << 30)
+	mov	r8, r1
+	strne	r1, [ip], #4
 
 3:	subs	r2, r2, #64
-	stmgeia	r0!, {r1, r3-r7, ip, lr}
-	stmgeia	r0!, {r1, r3-r7, ip, lr}
+	stmgeia	ip!, {r1, r3-r8, lr}
+	stmgeia	ip!, {r1, r3-r8, lr}
 	bgt	3b
-	ldmeqfd	sp!, {r4-r7, pc}
+	ldmeqfd	sp!, {r4-r8, pc}
 
 	tst	r2, #32
-	stmneia	r0!, {r1, r3-r7, ip, lr}
+	stmneia	ip!, {r1, r3-r8, lr}
 	tst	r2, #16
-	stmneia	r0!, {r4-r7}
-	ldmfd	sp!, {r4-r7, lr}
+	stmneia	ip!, {r4-r7}
+	ldmfd	sp!, {r4-r8, lr}
 
 #endif
 
 4:	tst	r2, #8
-	stmneia	r0!, {r1, r3}
+	stmneia	ip!, {r1, r3}
 	tst	r2, #4
-	strne	r1, [r0], #4
+	strne	r1, [ip], #4
 /*
  * When we get here, we've got less than 4 bytes to zero.  We
  * may have an unaligned pointer as well.
  */
 5:	tst	r2, #2
-	strneb	r1, [r0], #1
-	strneb	r1, [r0], #1
+	strneb	r1, [ip], #1
+	strneb	r1, [ip], #1
 	tst	r2, #1
-	strneb	r1, [r0], #1
+	strneb	r1, [ip], #1
 	mov	pc, lr
+
+6:	subs	r2, r2, #4		@ 1 do we have enough
+	blt	5b			@ 1 bytes to align with?
+	cmp	r3, #2			@ 1
+	strltb	r1, [ip], #1		@ 1
+	strleb	r1, [ip], #1		@ 1
+	strb	r1, [ip], #1		@ 1
+	add	r2, r2, r3		@ 1 (r2 = r2 - (4 - r3))
+	b	1b
 ENDPROC(memset)
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 6038a8c..4137499 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -232,7 +232,7 @@ static inline void omap_intc_handle_irq(void __iomem *base_addr, struct pt_regs
 			goto out;
 
 		irqnr = readl_relaxed(base_addr + 0xd8);
-#ifdef CONFIG_SOC_TI81XX
+#if IS_ENABLED(CONFIG_SOC_TI81XX) || IS_ENABLED(CONFIG_SOC_AM33XX)
 		if (irqnr)
 			goto out;
 		irqnr = readl_relaxed(base_addr + 0xf8);
diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index ac12ae2..db9a16c 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #include <asm/page.h>   /* for __va, __pa */
 #include <arch/io.h>
+#include <asm-generic/iomap.h>
 #include <linux/kernel.h>
 
 struct cris_io_operations
diff --git a/arch/parisc/kernel/head.S b/arch/parisc/kernel/head.S
index 37aabd7..d2d5825 100644
--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -195,6 +195,8 @@ common_stext:
 	ldw             MEM_PDC_HI(%r0),%r6
 	depd            %r6, 31, 32, %r3        /* move to upper word */
 
+	mfctl		%cr30,%r6		/* PCX-W2 firmware bug */
+
 	ldo             PDC_PSW(%r0),%arg0              /* 21 */
 	ldo             PDC_PSW_SET_DEFAULTS(%r0),%arg1 /* 2 */
 	ldo             PDC_PSW_WIDE_BIT(%r0),%arg2     /* 2 */
@@ -203,6 +205,8 @@ common_stext:
 	copy            %r0,%arg3
 
 stext_pdc_ret:
+	mtctl		%r6,%cr30		/* restore task thread info */
+
 	/* restore rfi target address*/
 	ldd             TI_TASK-THREAD_SZ_ALGN(%sp), %r10
 	tophys_r1       %r10
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index b161bae..4869c4e 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1521,12 +1521,12 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 
 	dn = dev->of_node;
 	if (!dn) {
-		strcat(buf, "\n");
+		strcpy(buf, "\n");
 		return strlen(buf);
 	}
 	cp = of_get_property(dn, "compatible", NULL);
 	if (!cp) {
-		strcat(buf, "\n");
+		strcpy(buf, "\n");
 		return strlen(buf);
 	}
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index fbdd74d..5da8e8d 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -613,13 +613,23 @@ static int __devinit pnv_ioda_configure_pe(struct pnv_phb *phb,
 		rid_end = pe->rid + 1;
 	}
 
-	/* Associate PE in PELT */
+	/*
+	 * Associate PE in PELT. We need add the PE into the
+	 * corresponding PELT-V as well. Otherwise, the error
+	 * originated from the PE might contribute to other
+	 * PEs.
+	 */
 	rc = opal_pci_set_pe(phb->opal_id, pe->pe_number, pe->rid,
 			     bcomp, dcomp, fcomp, OPAL_MAP_PE);
 	if (rc) {
 		pe_err(pe, "OPAL error %ld trying to setup PELT table\n", rc);
 		return -ENXIO;
 	}
+
+	rc = opal_pci_set_peltv(phb->opal_id, pe->pe_number,
+				pe->pe_number, OPAL_ADD_PE_TO_DOMAIN);
+	if (rc)
+		pe_warn(pe, "OPAL error %d adding self to PELTV\n", rc);
 	opal_pci_eeh_freeze_clear(phb->opal_id, pe->pe_number,
 				  OPAL_EEH_ACTION_CLEAR_FREEZE_ALL);
 
diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 829df49..41ebbfe 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -40,9 +40,11 @@ static ssize_t exitcode_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *end, buf[sizeof("nnnnn\0")];
+	size_t size;
 	int tmp;
 
-	if (copy_from_user(buf, buffer, count))
+	size = min(count, sizeof(buf));
+	if (copy_from_user(buf, buffer, size))
 		return -EFAULT;
 
 	tmp = simple_strtol(buf, &end, 0);
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index efe4e85..163cfc8 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -342,7 +342,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	sp = regs->areg[1];
 
-	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && ! on_sig_stack(sp)) {
+	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && sas_ss_flags(sp) == 0) {
 		sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 6ddd99e..c21f761 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -230,11 +230,11 @@ remainder:
 	 */
 	if (byte_count < DEFAULT_BLK_SZ) {
 empty_rbuf:
-		for (; ctx->rand_data_valid < DEFAULT_BLK_SZ;
-			ctx->rand_data_valid++) {
+		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
 			*ptr = ctx->rand_data[ctx->rand_data_valid];
 			ptr++;
 			byte_count--;
+			ctx->rand_data_valid++;
 			if (byte_count == 0)
 				goto done;
 		}
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9270f35..d0f8a93 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -301,6 +301,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x23a3), board_ahci }, /* Coleto Creek AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c83), board_ahci }, /* Wildcat Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c85), board_ahci }, /* Wildcat Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c87), board_ahci }, /* Wildcat Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c8f), board_ahci }, /* Wildcat Point-LP RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 47a1fb8..60f41cd 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1249,9 +1249,11 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
 	const char *reason = NULL;
 	unsigned long now, msecs;
 	struct ata_taskfile tf;
+	bool fbs_disabled = false;
 	int rc;
 
 	DPRINTK("ENTER\n");
@@ -1261,6 +1263,16 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	if (rc && rc != -EOPNOTSUPP)
 		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
 
+	/*
+	 * According to AHCI-1.2 9.3.9: if FBS is enable, software shall
+	 * clear PxFBS.EN to '0' prior to issuing software reset to devices
+	 * that is attached to port multiplier.
+	 */
+	if (!ata_is_host_link(link) && pp->fbs_enabled) {
+		ahci_disable_fbs(ap);
+		fbs_disabled = true;
+	}
+
 	ata_tf_init(link->device, &tf);
 
 	/* issue the first D2H Register FIS */
@@ -1301,6 +1313,10 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	} else
 		*class = ahci_dev_classify(ap);
 
+	/* re-enable FBS if disabled before */
+	if (fbs_disabled)
+		ahci_enable_fbs(ap);
+
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9e47300..705658d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4075,6 +4075,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
 	{ "QUANTUM DAT    DAT72-000", NULL,	ATA_HORKAGE_ATAPI_MOD16_DMA },
 	{ "Slimtype DVD A  DS8A8SH", NULL,	ATA_HORKAGE_MAX_SEC_LBA48 },
+	{ "Slimtype DVD A  DS8A9SH", NULL,	ATA_HORKAGE_MAX_SEC_LBA48 },
 
 	/* Devices we expect to fail diagnostics */
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 85fe5bc..1e2a1dd 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1287,14 +1287,14 @@ void ata_eh_qc_complete(struct ata_queued_cmd *qc)
  *	should be retried.  To be used from EH.
  *
  *	SCSI midlayer limits the number of retries to scmd->allowed.
- *	scmd->retries is decremented for commands which get retried
+ *	scmd->allowed is incremented for commands which get retried
  *	due to unrelated failures (qc->err_mask is zero).
  */
 void ata_eh_qc_retry(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
-	if (!qc->err_mask && scmd->retries)
-		scmd->retries--;
+	if (!qc->err_mask)
+		scmd->allowed++;
 	__ata_eh_qc_complete(qc);
 }
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index c341904..9215677 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -319,25 +319,25 @@ int ata_tport_add(struct device *parent,
 /*
  * ATA link attributes
  */
+static int noop(int x) { return x; }
 
-
-#define ata_link_show_linkspeed(field)					\
+#define ata_link_show_linkspeed(field, format)			        \
 static ssize_t								\
 show_ata_link_##field(struct device *dev,				\
 		      struct device_attribute *attr, char *buf)		\
 {									\
 	struct ata_link *link = transport_class_to_link(dev);		\
 									\
-	return sprintf(buf,"%s\n", sata_spd_string(fls(link->field)));	\
+	return sprintf(buf, "%s\n", sata_spd_string(format(link->field))); \
 }
 
-#define ata_link_linkspeed_attr(field)					\
-	ata_link_show_linkspeed(field)					\
+#define ata_link_linkspeed_attr(field, format)				\
+	ata_link_show_linkspeed(field, format)				\
 static DEVICE_ATTR(field, S_IRUGO, show_ata_link_##field, NULL)
 
-ata_link_linkspeed_attr(hw_sata_spd_limit);
-ata_link_linkspeed_attr(sata_spd_limit);
-ata_link_linkspeed_attr(sata_spd);
+ata_link_linkspeed_attr(hw_sata_spd_limit, fls);
+ata_link_linkspeed_attr(sata_spd_limit, fls);
+ata_link_linkspeed_attr(sata_spd, noop);
 
 
 static DECLARE_TRANSPORT_CLASS(ata_link_class,
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 8a9d079..df54da9 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -422,9 +422,16 @@ long drm_ioctl(struct file *filp,
 			asize = drv_size;
 	}
 	else if ((nr >= DRM_COMMAND_END) || (nr < DRM_COMMAND_BASE)) {
+		u32 drv_size;
+
 		ioctl = &drm_ioctls[nr];
-		cmd = ioctl->cmd;
+
+		drv_size = _IOC_SIZE(ioctl->cmd);
 		usize = asize = _IOC_SIZE(cmd);
+		if (drv_size > asize)
+			asize = drv_size;
+
+		cmd = ioctl->cmd;
 	} else
 		goto err_i1;
 
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 64bc2bd..3c4138f 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1430,7 +1430,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 			 * does the same thing and more.
 			 */
 			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
-			    (rdev->family != CHIP_RS880))
+			    (rdev->family != CHIP_RS780) && (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index db50604..40cefd4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -748,9 +748,17 @@ static void vmw_postclose(struct drm_device *dev,
 	struct vmw_fpriv *vmw_fp;
 
 	vmw_fp = vmw_fpriv(file_priv);
-	ttm_object_file_release(&vmw_fp->tfile);
-	if (vmw_fp->locked_master)
+
+	if (vmw_fp->locked_master) {
+		struct vmw_master *vmaster =
+			vmw_master(vmw_fp->locked_master);
+
+		ttm_lock_set_kill(&vmaster->lock, true, SIGTERM);
+		ttm_vt_unlock(&vmaster->lock);
 		drm_master_put(&vmw_fp->locked_master);
+	}
+
+	ttm_object_file_release(&vmw_fp->tfile);
 	kfree(vmw_fp);
 }
 
@@ -953,14 +961,13 @@ static void vmw_master_drop(struct drm_device *dev,
 
 	vmw_fp->locked_master = drm_master_get(file_priv->master);
 	ret = ttm_vt_lock(&vmaster->lock, false, vmw_fp->tfile);
-	vmw_execbuf_release_pinned_bo(dev_priv, false, 0);
-
 	if (unlikely((ret != 0))) {
 		DRM_ERROR("Unable to lock TTM at VT switch.\n");
 		drm_master_put(&vmw_fp->locked_master);
 	}
 
-	ttm_lock_set_kill(&vmaster->lock, true, SIGTERM);
+	ttm_lock_set_kill(&vmaster->lock, false, SIGTERM);
+	vmw_execbuf_release_pinned_bo(dev_priv, false, 0);
 
 	if (!dev_priv->enable_fb) {
 		ret = ttm_bo_evict_mm(&dev_priv->bdev, TTM_PL_VRAM);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cc4d68d..5f5e10e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8046,6 +8046,7 @@ static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
 	u64 *p;
 	int lo, hi;
 	int rv = 1;
+	unsigned long flags;
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
@@ -8060,7 +8061,7 @@ static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
 		sectors = next - s;
 	}
 
-	write_seqlock_irq(&bb->lock);
+	write_seqlock_irqsave(&bb->lock, flags);
 
 	p = bb->page;
 	lo = 0;
@@ -8176,7 +8177,7 @@ static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
 	bb->changed = 1;
 	if (!acknowledged)
 		bb->unacked_exist = 1;
-	write_sequnlock_irq(&bb->lock);
+	write_sequnlock_irqrestore(&bb->lock, flags);
 
 	return rv;
 }
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index aa58c02..0d15abe 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1354,6 +1354,7 @@ static int raid1_spare_active(struct mddev *mddev)
 			}
 		}
 		if (rdev
+		    && rdev->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5ad042c..2070e9c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1630,6 +1630,7 @@ static int raid10_spare_active(struct mddev *mddev)
 			}
 			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
 		} else if (tmp->rdev
+			   && tmp->rdev->recovery_offset == MaxSector
 			   && !test_bit(Faulty, &tmp->rdev->flags)
 			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 64647d4..91d1b5a 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -764,9 +764,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 			msg_ctrl_save = priv->read_reg(priv,
 					&priv->regs->ifregs[0].msg_cntrl);
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (msg_ctrl_save & IF_MCONT_MSGLST) {
 				c_can_handle_lost_msg_obj(dev, 0, msg_obj);
 				num_rx_pkts++;
@@ -774,6 +771,9 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 				continue;
 			}
 
+			if (msg_ctrl_save & IF_MCONT_EOB)
+				return num_rx_pkts;
+
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index efd3e34..9ac8801 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1252,6 +1252,7 @@ static void cp_tx_timeout(struct net_device *dev)
 	cp_clean_rings(cp);
 	rc = cp_init_rings(cp);
 	cp_start_hw(cp);
+	cp_enable_irq(cp);
 
 	netif_wake_queue(dev);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index e5e8ada..e6cb3f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -252,6 +252,12 @@ const struct iwl_cfg iwl6035_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
+const struct iwl_cfg iwl6035_2agn_sff_cfg = {
+	.name = "Intel(R) Centrino(R) Ultimate-N 6235 AGN",
+	IWL_DEVICE_6035,
+	.ht_params = &iwl6000_ht_params,
+};
+
 const struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	IWL_DEVICE_6030,
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index 82152311..a133e9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -106,6 +106,7 @@ extern const struct iwl_cfg iwl2000_2bgn_cfg;
 extern const struct iwl_cfg iwl2000_2bgn_d_cfg;
 extern const struct iwl_cfg iwl2030_2bgn_cfg;
 extern const struct iwl_cfg iwl6035_2agn_cfg;
+extern const struct iwl_cfg iwl6035_2agn_sff_cfg;
 extern const struct iwl_cfg iwl105_bgn_cfg;
 extern const struct iwl_cfg iwl105_bgn_d_cfg;
 extern const struct iwl_cfg iwl135_bgn_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 2b425da..8679184 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -140,13 +140,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 
 /* 6x00 Series */
 	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422B, 0x1108, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422B, 0x1121, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422B, 0x1128, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1301, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1306, iwl6000i_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1307, iwl6000i_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1321, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1326, iwl6000i_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x4238, 0x1118, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
 
@@ -154,12 +157,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6005_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1308, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1328, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1318, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0xC228, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x4820, iwl6005_2agn_d_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_mow1_cfg)},/* low 5GHz active */
 	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_mow2_cfg)},/* high 5GHz active */
@@ -241,8 +248,11 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 
 /* 6x35 Series */
 	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x406A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x426A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x446A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},
 
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d8594a2..dd2160c 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1253,7 +1253,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	 */
 	rxdesc->timestamp = ((u64)rx_high << 32) | rx_low;
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL) & ~0x08;
-	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
+	rxdesc->rssi = rt2x00_get_field32(word3, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index fe42f76..c30797e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -143,6 +143,8 @@ static bool rt2800usb_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 	return false;
 }
 
+#define TXSTATUS_READ_INTERVAL 1000000
+
 static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 						 int urb_status, u32 tx_status)
 {
@@ -170,8 +172,9 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 
 	if (rt2800usb_txstatus_pending(rt2x00dev)) {
-		/* Read register after 250 us */
-		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
+		/* Read register after 1 ms */
+		hrtimer_start(&rt2x00dev->txstatus_timer,
+			      ktime_set(0, TXSTATUS_READ_INTERVAL),
 			      HRTIMER_MODE_REL);
 		return false;
 	}
@@ -196,8 +199,9 @@ static void rt2800usb_async_read_tx_status(struct rt2x00_dev *rt2x00dev)
 	if (test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
 		return;
 
-	/* Read TX_STA_FIFO register after 500 us */
-	hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 500000),
+	/* Read TX_STA_FIFO register after 2 ms */
+	hrtimer_start(&rt2x00dev->txstatus_timer,
+		      ktime_set(0, 2*TXSTATUS_READ_INTERVAL),
 		      HRTIMER_MODE_REL);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index dd24b26..7832ee9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -781,6 +781,9 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
 
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return;
+
 	tx_queue_for_each(rt2x00dev, queue)
 		rt2x00queue_flush_queue(queue, drop);
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 21bc827..9adb21a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -343,7 +343,8 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 					(bool)GET_RX_DESC_PAGGR(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
-		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
+		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
+						     stats->rx_bufshift);
 		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
 						 p_drvinfo);
 	}
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 9d7f172..093bf0a 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -88,6 +88,7 @@ struct xenvif {
 	unsigned long   credit_usec;
 	unsigned long   remaining_credit;
 	struct timer_list credit_timeout;
+	u64 credit_window_start;
 
 	/* Statistics */
 	unsigned long rx_gso_checksum_fixup;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 221f426..cfaaf68 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -273,8 +273,7 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	vif->credit_bytes = vif->remaining_credit = ~0UL;
 	vif->credit_usec  = 0UL;
 	init_timer(&vif->credit_timeout);
-	/* Initialize 'expires' now: it's used to track the credit window. */
-	vif->credit_timeout.expires = jiffies;
+	vif->credit_window_start = get_jiffies_64();
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
 	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 228607b..3d0f22a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1364,9 +1364,8 @@ out:
 
 static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 {
-	unsigned long now = jiffies;
-	unsigned long next_credit =
-		vif->credit_timeout.expires +
+	u64 now = get_jiffies_64();
+	u64 next_credit = vif->credit_window_start +
 		msecs_to_jiffies(vif->credit_usec / 1000);
 
 	/* Timer could already be pending in rare cases. */
@@ -1374,8 +1373,8 @@ static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 		return true;
 
 	/* Passed the point where we can replenish credit? */
-	if (time_after_eq(now, next_credit)) {
-		vif->credit_timeout.expires = now;
+	if (time_after_eq64(now, next_credit)) {
+		vif->credit_window_start = now;
 		tx_add_credit(vif);
 	}
 
@@ -1387,6 +1386,7 @@ static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 			tx_credit_callback;
 		mod_timer(&vif->credit_timeout,
 			  next_credit);
+		vif->credit_window_start = next_credit;
 
 		return true;
 	}
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3389387..920d701 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -686,6 +686,7 @@ static int pci_pm_suspend(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -832,6 +833,7 @@ static int pci_pm_freeze(struct device *dev)
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -920,6 +922,7 @@ static int pci_pm_poweroff(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -1038,6 +1041,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);
 	if (error)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e118e1e..c3121f7 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4355,7 +4355,7 @@ int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
 	struct qeth_snmp_ureq *ureq;
-	int req_len;
+	unsigned int req_len;
 	struct qeth_arp_query_info qinfo = {0, };
 	int rc = 0;
 
@@ -4371,6 +4371,10 @@ int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	/* skip 4 bytes (data_len struct member) to get req_len */
 	if (copy_from_user(&req_len, udata + sizeof(int), sizeof(int)))
 		return -EFAULT;
+	if (req_len > (QETH_BUFSIZE - IPA_PDU_HEADER_SIZE -
+		       sizeof(struct qeth_ipacmd_hdr) -
+		       sizeof(struct qeth_ipacmd_setadpparms_hdr)))
+		return -EINVAL;
 	ureq = memdup_user(udata, req_len + sizeof(struct qeth_snmp_ureq_hdr));
 	if (IS_ERR(ureq)) {
 		QETH_CARD_TEXT(card, 2, "snmpnome");
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0d279c44..e9313f8 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -777,6 +777,8 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index cf30592..c0d612f 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1957,6 +1957,7 @@ cntrlEnd:
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
 
+		memset(&DevInfo, 0, sizeof(DevInfo));
 		DevInfo.MaxRDMBufferSize = BUFFER_4K;
 		DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
 		DevInfo.u32RxAlignmentCorrection = 0;
diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 27325f7..03dcd1b 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -150,6 +150,9 @@ ssize_t oz_cdev_write(struct file *filp, const char __user *buf, size_t count,
 	struct oz_app_hdr *app_hdr;
 	struct oz_serial_ctx *ctx;
 
+	if (count > sizeof(ei->data) - sizeof(*elt) - sizeof(*app_hdr))
+		return -EINVAL;
+
 	spin_lock_bh(&g_cdev.lock);
 	pd = g_cdev.active_pd;
 	if (pd)
diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index f30e5ee..e68c51e 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -570,6 +570,7 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 	ltv_t                   *pLtv;
 	bool_t                  ltvAllocated = FALSE;
 	ENCSTRCT                sEncryption;
+	size_t			len;
 
 #ifdef USE_WDS
 	hcf_16                  hcfPort  = HCF_PORT_0;
@@ -686,7 +687,8 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					break;
 				case CFG_CNF_OWN_NAME:
 					memset( lp->StationName, 0, sizeof( lp->StationName ));
-					memcpy( (void *)lp->StationName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					len = min_t(size_t, pLtv->u.u16[0], sizeof(lp->StationName));
+					strlcpy(lp->StationName, &pLtv->u.u8[2], len);
 					pLtv->u.u16[0] = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
 					break;
 				case CFG_CNF_LOAD_BALANCING:
@@ -1800,6 +1802,7 @@ int wvlan_set_station_nickname(struct net_device *dev,
 {
         struct wl_private *lp = wl_priv(dev);
         unsigned long flags;
+	size_t len;
         int         ret = 0;
 	/*------------------------------------------------------------------------*/
 
@@ -1811,7 +1814,8 @@ int wvlan_set_station_nickname(struct net_device *dev,
 
         memset( lp->StationName, 0, sizeof( lp->StationName ));
 
-        memcpy( lp->StationName, extra, wrqu->data.length);
+	len = min_t(size_t, wrqu->data.length, sizeof(lp->StationName));
+	strlcpy(lp->StationName, extra, len);
 
         /* Commit the adapter parameters */
         wl_apply( lp );
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 1835d84..6a04f2a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -128,10 +128,10 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 * pSCSI Host ID and enable for phba mode
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
-	if (IS_ERR(sh)) {
+	if (!sh) {
 		pr_err("pSCSI: Unable to locate SCSI Host for"
 			" phv_host_id: %d\n", phv->phv_host_id);
-		return PTR_ERR(sh);
+		return -EINVAL;
 	}
 
 	phv->phv_lld_host = sh;
@@ -562,10 +562,10 @@ static struct se_device *pscsi_create_virtdevice(
 			sh = phv->phv_lld_host;
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
-			if (IS_ERR(sh)) {
+			if (!sh) {
 				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return ERR_CAST(sh);
+				return ERR_PTR(-EINVAL);
 			}
 		}
 	} else {
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a783d53..7150752 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -650,16 +650,30 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	int mi = uio_find_mem_index(vma);
+	struct uio_mem *mem;
 	if (mi < 0)
 		return -EINVAL;
+	mem = idev->info->mem + mi;
+
+	if (vma->vm_end - vma->vm_start > mem->size)
+		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
+	/*
+	 * We cannot use the vm_iomap_memory() helper here,
+	 * because vma->vm_pgoff is the map index we looked
+	 * up above in uio_find_mem_index(), rather than an
+	 * actual page offset into the mmap.
+	 *
+	 * So we just do the physical mmap without a page
+	 * offset.
+	 */
 	return remap_pfn_range(vma,
 			       vma->vm_start,
-			       idev->info->mem[mi].addr >> PAGE_SHIFT,
+			       mem->addr >> PAGE_SHIFT,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot);
 }
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 7be4e11..b79aa83 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1142,6 +1142,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_ENABLE);
 		}
+		if (portchange & USB_PORT_STAT_C_RESET) {
+			need_debounce_delay = true;
+			clear_port_feature(hub->hdev, port1,
+					USB_PORT_FEAT_C_RESET);
+		}
 		if ((portchange & USB_PORT_STAT_C_BH_RESET) &&
 				hub_is_superspeed(hub->hdev)) {
 			need_debounce_delay = true;
@@ -1557,6 +1562,7 @@ static int hub_configure(struct usb_hub *hub,
 	return 0;
 
 fail:
+	hdev->maxchild = 0;
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */
@@ -4824,6 +4830,12 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 	}
 	parent_hub = hdev_to_hub(parent_hdev);
 
+	/* Disable USB2 hardware LPM.
+	 * It will be re-enabled by the enumeration process.
+	 */
+	if (udev->usb2_hw_lpm_enabled == 1)
+		usb_set_usb2_hardware_lpm(udev, 0);
+
 	/* Disable LPM while we reset the device and reinstall the alt settings.
 	 * Device-initiated LPM settings, and system exit latency settings are
 	 * cleared when the device is reset, so we have to set them up again.
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c57562a..6a979cd 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -914,6 +914,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1b8af46..a7019d1 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1307,3 +1307,9 @@
  * Manufacturer: Crucible Technologies
  */
 #define FTDI_CT_COMET_PID	0x8e08
+
+/*
+ * Product: Z3X Box
+ * Manufacturer: Smart GSM Team
+ */
+#define FTDI_Z3X_PID		0x0011
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index d9368be..08aad01 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1707,7 +1707,11 @@ static int mos7840_tiocmget(struct tty_struct *tty)
 		return -ENODEV;
 
 	status = mos7840_get_uart_reg(port, MODEM_STATUS_REGISTER, &msr);
+	if (status != 1)
+		return -EIO;
 	status = mos7840_get_uart_reg(port, MODEM_CONTROL_REGISTER, &mcr);
+	if (status != 1)
+		return -EIO;
 	result = ((mcr & MCR_DTR) ? TIOCM_DTR : 0)
 	    | ((mcr & MCR_RTS) ? TIOCM_RTS : 0)
 	    | ((mcr & MCR_LOOPBACK) ? TIOCM_LOOP : 0)
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index c4b313f..dbc6919 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1391,6 +1391,23 @@ static const struct usb_device_id option_ids[] = {
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1426, 0xff, 0xff, 0xff),  /* ZTE MF91 */
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1545, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1546, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1547, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1565, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1566, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1567, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1589, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1590, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1591, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1592, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1594, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1596, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1598, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1600, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff,
 	  0xff, 0xff), .driver_info = (kernel_ulong_t)&zte_k3765_z_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2003, 0xff, 0xff, 0xff) },
diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index f0d546c..ca1031b 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -332,7 +332,10 @@ static int rpipe_aim(struct wa_rpipe *rpipe, struct wahc *wa,
 	/* FIXME: compute so seg_size > ep->maxpktsize */
 	rpipe->descr.wBlocks = cpu_to_le16(16);		/* given */
 	/* ep0 maxpktsize is 0x200 (WUSB1.0[4.8.1]) */
-	rpipe->descr.wMaxPacketSize = cpu_to_le16(ep->desc.wMaxPacketSize);
+	if (usb_endpoint_xfer_isoc(&ep->desc))
+		rpipe->descr.wMaxPacketSize = epcd->wOverTheAirPacketSize;
+	else
+		rpipe->descr.wMaxPacketSize = ep->desc.wMaxPacketSize;
 	rpipe->descr.bHSHubAddress = 0;			/* reserved: zero */
 	rpipe->descr.bHSHubPort = wusb_port_no_to_idx(urb->dev->portnum);
 	/* FIXME: use maximum speed as supported or recommended by device */
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 1ebc17e..8cf9003 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -90,7 +90,8 @@
 #include "wusbhc.h"
 
 enum {
-	WA_SEGS_MAX = 255,
+	/* [WUSB] section 8.3.3 allocates 7 bits for the segment index. */
+	WA_SEGS_MAX = 128,
 };
 
 enum wa_seg_status {
@@ -444,7 +445,7 @@ static ssize_t __wa_xfer_setup_sizes(struct wa_xfer *xfer,
 	xfer->seg_size = (xfer->seg_size / maxpktsize) * maxpktsize;
 	xfer->segs = (urb->transfer_buffer_length + xfer->seg_size - 1)
 		/ xfer->seg_size;
-	if (xfer->segs >= WA_SEGS_MAX) {
+	if (xfer->segs > WA_SEGS_MAX) {
 		dev_err(dev, "BUG? ops, number of segments %d bigger than %d\n",
 			(int)(urb->transfer_buffer_length / xfer->seg_size),
 			WA_SEGS_MAX);
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index fe3b6ec..2169bc0 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -375,39 +375,15 @@ void au1100fb_fb_rotate(struct fb_info *fbi, int angle)
 int au1100fb_fb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 {
 	struct au1100fb_device *fbdev;
-	unsigned int len;
-	unsigned long start=0, off;
 
 	fbdev = to_au1100fb_device(fbi);
 
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT)) {
-		return -EINVAL;
-	}
-
-	start = fbdev->fb_phys & PAGE_MASK;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + fbdev->fb_len);
-
-	off = vma->vm_pgoff << PAGE_SHIFT;
-
-	if ((vma->vm_end - vma->vm_start + off) > len) {
-		return -EINVAL;
-	}
-
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	pgprot_val(vma->vm_page_prot) |= (6 << 9); //CCA=6
 
 	vma->vm_flags |= VM_IO;
 
-	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				vma->vm_end - vma->vm_start,
-				vma->vm_page_prot)) {
-		return -EAGAIN;
-	}
-
-	return 0;
+	return vm_iomap_memory(vma, fbdev->fb_phys, fbdev->fb_len);
 }
 
 static struct fb_ops au1100fb_ops =
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 7ca79f0..117be3d 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1233,36 +1233,15 @@ static int au1200fb_fb_blank(int blank_mode, struct fb_info *fbi)
  * method mainly to allow the use of the TLB streaming flag (CCA=6)
  */
 static int au1200fb_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-
 {
-	unsigned int len;
-	unsigned long start=0, off;
 	struct au1200fb_device *fbdev = info->par;
 
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT)) {
-		return -EINVAL;
-	}
-
-	start = fbdev->fb_phys & PAGE_MASK;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + fbdev->fb_len);
-
-	off = vma->vm_pgoff << PAGE_SHIFT;
-
-	if ((vma->vm_end - vma->vm_start + off) > len) {
-		return -EINVAL;
-	}
-
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	pgprot_val(vma->vm_page_prot) |= _CACHE_MASK; /* CCA=7 */
 
 	vma->vm_flags |= VM_IO;
 
-	return io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
+	return vm_iomap_memory(vma, fbdev->fb_phys, fbdev->fb_len);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 0443a4f..dab3a0c 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 {
 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
-	u8 intensity;
+	u32 intensity;
 
 	if (pwmbl->pdata->pwm_active_low) {
 		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
@@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
 	}
 
-	return intensity;
+	return intensity & 0xffff;
 }
 
 static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
@@ -211,7 +211,8 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
 	if (pwmbl->gpio_on != -1) {
-		gpio_set_value(pwmbl->gpio_on, 0);
+		gpio_set_value(pwmbl->gpio_on,
+					0 ^ pwmbl->pdata->on_active_low);
 		gpio_free(pwmbl->gpio_on);
 	}
 	pwm_channel_disable(&pwmbl->pwmc);
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 979c1e3..1ed9d5e 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -483,6 +483,7 @@ static void devpts_kill_sb(struct super_block *sb)
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
+	ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
 	kill_litter_super(sb);
 }
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 2333203..d28fc34 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1149,7 +1149,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
-	char *payload;
+	char *payload = NULL;
 	size_t payload_len;
 	int rc;
 
@@ -1204,6 +1204,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 out:
 	if (msg)
 		kfree(msg);
+	kfree(payload);
 	return rc;
 }
 
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index c1a3e60..7f464c5 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -95,7 +95,7 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 
 	if (insert_inode_locked(inode) < 0) {
 		rc = -EINVAL;
-		goto fail_unlock;
+		goto fail_put;
 	}
 
 	inode_init_owner(inode, parent, mode);
@@ -156,7 +156,6 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-fail_unlock:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 fail_put:
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 30bd45a..cc5e43e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -224,6 +224,8 @@ nfs_find_actor(struct inode *inode, void *opaque)
 
 	if (NFS_FILEID(inode) != fattr->fileid)
 		return 0;
+	if ((S_IFMT & inode->i_mode) != (S_IFMT & fattr->mode))
+		return 0;
 	if (nfs_compare_fh(NFS_FH(inode), fh))
 		return 0;
 	if (is_bad_inode(inode) || NFS_STALE(inode))
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index fda63e9..c7eb313 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -24,14 +24,14 @@
 
 #define NFSDBG_FACILITY		NFSDBG_PROC
 
-/* A wrapper to handle the EJUKEBOX and EKEYEXPIRED error messages */
+/* A wrapper to handle the EJUKEBOX error messages */
 static int
 nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 {
 	int res;
 	do {
 		res = rpc_call_sync(clnt, msg, flags);
-		if (res != -EJUKEBOX && res != -EKEYEXPIRED)
+		if (res != -EJUKEBOX)
 			break;
 		freezable_schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
 		res = -ERESTARTSYS;
@@ -44,7 +44,7 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 static int
 nfs3_async_handle_jukebox(struct rpc_task *task, struct inode *inode)
 {
-	if (task->tk_status != -EJUKEBOX && task->tk_status != -EKEYEXPIRED)
+	if (task->tk_status != -EJUKEBOX)
 		return 0;
 	if (task->tk_status == -EJUKEBOX)
 		nfs_inc_stats(inode, NFSIOS_DELAY);
diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index e134029..8445359 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -169,7 +169,6 @@ static int filelayout_async_handle_error(struct rpc_task *task,
 		break;
 	case -NFS4ERR_DELAY:
 	case -NFS4ERR_GRACE:
-	case -EKEYEXPIRED:
 		rpc_delay(task, FILELAYOUT_POLL_RETRY_MAX);
 		break;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 871d50c..a89661e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -341,7 +341,6 @@ static int nfs4_handle_exception(struct nfs_server *server, int errorcode, struc
 			}
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_DELAY:
-		case -EKEYEXPIRED:
 			ret = nfs4_delay(server->client, &exception->timeout);
 			if (ret != 0)
 				break;
@@ -1371,13 +1370,6 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state
 				nfs_inode_find_state_and_recover(state->inode,
 						stateid);
 				nfs4_schedule_stateid_recovery(server, state);
-			case -EKEYEXPIRED:
-				/*
-				 * User RPCSEC_GSS context has expired.
-				 * We cannot recover this stateid now, so
-				 * skip it and allow recovery thread to
-				 * proceed.
-				 */
 			case -ENOMEM:
 				err = 0;
 				goto out;
@@ -3949,7 +3941,6 @@ nfs4_async_handle_error(struct rpc_task *task, const struct nfs_server *server,
 		case -NFS4ERR_DELAY:
 			nfs_inc_server_stats(server, NFSIOS_DELAY);
 		case -NFS4ERR_GRACE:
-		case -EKEYEXPIRED:
 			rpc_delay(task, NFS4_POLL_RETRY_MAX);
 			task->tk_status = 0;
 			return -EAGAIN;
@@ -4250,6 +4241,7 @@ static int _nfs4_proc_getlk(struct nfs4_state *state, int cmd, struct file_lock
 			status = 0;
 	}
 	request->fl_ops->fl_release_private(request);
+	request->fl_ops = NULL;
 out:
 	return status;
 }
@@ -4905,15 +4897,6 @@ int nfs4_lock_delegation_recall(struct nfs4_state *state, struct file_lock *fl)
 				nfs4_schedule_stateid_recovery(server, state);
 				err = 0;
 				goto out;
-			case -EKEYEXPIRED:
-				/*
-				 * User RPCSEC_GSS context has expired.
-				 * We cannot recover this stateid now, so
-				 * skip it and allow recovery thread to
-				 * proceed.
-				 */
-				err = 0;
-				goto out;
 			case -ENOMEM:
 			case -NFS4ERR_DENIED:
 				/* kill_proc(fl->fl_pid, SIGLOST, 1); */
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 9bc63d3..e9c3916 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1315,14 +1315,6 @@ restart:
 				/* Mark the file as being 'closed' */
 				state->state = 0;
 				break;
-			case -EKEYEXPIRED:
-				/*
-				 * User RPCSEC_GSS context has expired.
-				 * We cannot recover this stateid now, so
-				 * skip it and allow recovery thread to
-				 * proceed.
-				 */
-				break;
 			case -NFS4ERR_ADMIN_REVOKED:
 			case -NFS4ERR_STALE_STATEID:
 			case -NFS4ERR_BAD_STATEID:
@@ -1475,14 +1467,6 @@ static void nfs4_state_start_reclaim_nograce(struct nfs_client *clp)
 	nfs4_state_mark_reclaim_helper(clp, nfs4_state_mark_reclaim_nograce);
 }
 
-static void nfs4_warn_keyexpired(const char *s)
-{
-	printk_ratelimited(KERN_WARNING "Error: state manager"
-			" encountered RPCSEC_GSS session"
-			" expired against NFSv4 server %s.\n",
-			s);
-}
-
 static int nfs4_recovery_handle_error(struct nfs_client *clp, int error)
 {
 	switch (error) {
@@ -1516,10 +1500,6 @@ static int nfs4_recovery_handle_error(struct nfs_client *clp, int error)
 		case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
 			set_bit(NFS4CLNT_BIND_CONN_TO_SESSION, &clp->cl_state);
 			break;
-		case -EKEYEXPIRED:
-			/* Nothing we can do */
-			nfs4_warn_keyexpired(clp->cl_hostname);
-			break;
 		default:
 			dprintk("%s: failed to handle error %d for server %s\n",
 					__func__, error, clp->cl_hostname);
@@ -1627,8 +1607,6 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
 		dprintk("%s: exit with error %d for server %s\n",
 				__func__, -EPROTONOSUPPORT, clp->cl_hostname);
 		return -EPROTONOSUPPORT;
-	case -EKEYEXPIRED:
-		nfs4_warn_keyexpired(clp->cl_hostname);
 	case -NFS4ERR_NOT_SAME: /* FixMe: implement recovery
 				 * in nfs4_exchange_id */
 	default:
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 617c741..b6d96f3 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -47,39 +47,6 @@
 #define NFSDBG_FACILITY		NFSDBG_PROC
 
 /*
- * wrapper to handle the -EKEYEXPIRED error message. This should generally
- * only happen if using krb5 auth and a user's TGT expires. NFSv2 doesn't
- * support the NFSERR_JUKEBOX error code, but we handle this situation in the
- * same way that we handle that error with NFSv3.
- */
-static int
-nfs_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
-{
-	int res;
-	do {
-		res = rpc_call_sync(clnt, msg, flags);
-		if (res != -EKEYEXPIRED)
-			break;
-		freezable_schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
-		res = -ERESTARTSYS;
-	} while (!fatal_signal_pending(current));
-	return res;
-}
-
-#define rpc_call_sync(clnt, msg, flags)	nfs_rpc_wrapper(clnt, msg, flags)
-
-static int
-nfs_async_handle_expired_key(struct rpc_task *task)
-{
-	if (task->tk_status != -EKEYEXPIRED)
-		return 0;
-	task->tk_status = 0;
-	rpc_restart_call(task);
-	rpc_delay(task, NFS_JUKEBOX_RETRY_TIME);
-	return 1;
-}
-
-/*
  * Bare-bones access to getattr: this is for nfs_read_super.
  */
 static int
@@ -364,8 +331,6 @@ static void nfs_proc_unlink_rpc_prepare(struct rpc_task *task, struct nfs_unlink
 
 static int nfs_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 {
-	if (nfs_async_handle_expired_key(task))
-		return 0;
 	nfs_mark_for_revalidate(dir);
 	return 1;
 }
@@ -385,8 +350,6 @@ static int
 nfs_proc_rename_done(struct rpc_task *task, struct inode *old_dir,
 		     struct inode *new_dir)
 {
-	if (nfs_async_handle_expired_key(task))
-		return 0;
 	nfs_mark_for_revalidate(old_dir);
 	nfs_mark_for_revalidate(new_dir);
 	return 1;
@@ -642,9 +605,6 @@ static int nfs_read_done(struct rpc_task *task, struct nfs_read_data *data)
 {
 	struct inode *inode = data->header->inode;
 
-	if (nfs_async_handle_expired_key(task))
-		return -EAGAIN;
-
 	nfs_invalidate_atime(inode);
 	if (task->tk_status >= 0) {
 		nfs_refresh_inode(inode, data->res.fattr);
@@ -671,9 +631,6 @@ static int nfs_write_done(struct rpc_task *task, struct nfs_write_data *data)
 {
 	struct inode *inode = data->header->inode;
 
-	if (nfs_async_handle_expired_key(task))
-		return -EAGAIN;
-
 	if (task->tk_status >= 0)
 		nfs_post_op_update_inode_force_wcc(inode, data->res.fattr);
 	return 0;
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 3d6301b..f604a1a 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -223,6 +223,8 @@ struct drm_mode_get_connector {
 	__u32 connection;
 	__u32 mm_width, mm_height; /**< HxW in millimeters */
 	__u32 subpixel;
+
+	__u32 pad;
 };
 
 #define DRM_MODE_PROP_PENDING	(1<<0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 17fd887..65b8b69 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -925,9 +925,11 @@ static inline loff_t i_size_read(const struct inode *inode)
 static inline void i_size_write(struct inode *inode, loff_t i_size)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	preempt_disable();
 	write_seqcount_begin(&inode->i_size_seqcount);
 	inode->i_size = i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
 	preempt_disable();
 	inode->i_size = i_size;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3faf0d4..7e72637 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -393,13 +393,15 @@ struct perf_event_mmap_page {
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading the @data_head value should issue an rmb(), on
-	 * SMP capable platforms, after reading this value -- see
-	 * perf_event_wakeup().
+	 * User-space reading the @data_head value should issue an smp_rmb(),
+	 * after reading this value.
 	 *
 	 * When the mapping is PROT_WRITE the @data_tail value should be
-	 * written by userspace to reflect the last read data. In this case
-	 * the kernel will not over-write unread data.
+	 * written by userspace to reflect the last read data, after issueing
+	 * an smp_mb() to separate the data read from the ->data_tail store.
+	 * In this case the kernel will not over-write unread data.
+	 *
+	 * See perf_output_put_handle() for the data ordering.
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 6ddaba4..4636ecc 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -75,10 +75,31 @@ again:
 		goto out;
 
 	/*
-	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the rb->head read and this
-	 * write.
+	 * Since the mmap() consumer (userspace) can run on a different CPU:
+	 *
+	 *   kernel				user
+	 *
+	 *   READ ->data_tail			READ ->data_head
+	 *   smp_mb()	(A)			smp_rmb()	(C)
+	 *   WRITE $data			READ $data
+	 *   smp_wmb()	(B)			smp_mb()	(D)
+	 *   STORE ->data_head			WRITE ->data_tail
+	 *
+	 * Where A pairs with D, and B pairs with C.
+	 *
+	 * I don't think A needs to be a full barrier because we won't in fact
+	 * write data until we see the store from userspace. So we simply don't
+	 * issue the data WRITE until we observe it. Be conservative for now.
+	 *
+	 * OTOH, D needs to be a full barrier since it separates the data READ
+	 * from the tail WRITE.
+	 *
+	 * For B a WMB is sufficient since it separates two WRITEs, and for C
+	 * an RMB is sufficient since it separates two READs.
+	 *
+	 * See perf_output_begin().
 	 */
+	smp_wmb();
 	rb->user_page->data_head = head;
 
 	/*
@@ -142,9 +163,11 @@ int perf_output_begin(struct perf_output_handle *handle,
 		 * Userspace could choose to issue a mb() before updating the
 		 * tail pointer. So that all reads will be completed before the
 		 * write is issued.
+		 *
+		 * See perf_output_put_handle().
 		 */
 		tail = ACCESS_ONCE(rb->user_page->data_tail);
-		smp_rmb();
+		smp_mb();
 		offset = head = local_read(&rb->head);
 		head += size;
 		if (unlikely(!perf_output_space(rb, tail, offset, head)))
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index aa27d39..2cfe9a5 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -474,7 +474,7 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	return hrtimer_get_res(baseid, tp);
 }
@@ -491,7 +491,7 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 7e1ce01..9b7a7fb 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -30,29 +30,64 @@ static RAW_NOTIFIER_HEAD(clockevents_chain);
 /* Protection for the above */
 static DEFINE_RAW_SPINLOCK(clockevents_lock);
 
-/**
- * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
- * @latch:	value to convert
- * @evt:	pointer to clock event device descriptor
- *
- * Math helper, returns latch value converted to nanoseconds (bound checked)
- */
-u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
+static u64 cev_delta2ns(unsigned long latch, struct clock_event_device *evt,
+			bool ismax)
 {
 	u64 clc = (u64) latch << evt->shift;
+	u64 rnd;
 
 	if (unlikely(!evt->mult)) {
 		evt->mult = 1;
 		WARN_ON(1);
 	}
+	rnd = (u64) evt->mult - 1;
+
+	/*
+	 * Upper bound sanity check. If the backwards conversion is
+	 * not equal latch, we know that the above shift overflowed.
+	 */
+	if ((clc >> evt->shift) != (u64)latch)
+		clc = ~0ULL;
+
+	/*
+	 * Scaled math oddities:
+	 *
+	 * For mult <= (1 << shift) we can safely add mult - 1 to
+	 * prevent integer rounding loss. So the backwards conversion
+	 * from nsec to device ticks will be correct.
+	 *
+	 * For mult > (1 << shift), i.e. device frequency is > 1GHz we
+	 * need to be careful. Adding mult - 1 will result in a value
+	 * which when converted back to device ticks can be larger
+	 * than latch by up to (mult - 1) >> shift. For the min_delta
+	 * calculation we still want to apply this in order to stay
+	 * above the minimum device ticks limit. For the upper limit
+	 * we would end up with a latch value larger than the upper
+	 * limit of the device, so we omit the add to stay below the
+	 * device upper boundary.
+	 *
+	 * Also omit the add if it would overflow the u64 boundary.
+	 */
+	if ((~0ULL - clc > rnd) &&
+	    (!ismax || evt->mult <= (1U << evt->shift)))
+		clc += rnd;
 
 	do_div(clc, evt->mult);
-	if (clc < 1000)
-		clc = 1000;
-	if (clc > KTIME_MAX)
-		clc = KTIME_MAX;
 
-	return clc;
+	/* Deltas less than 1usec are pointless noise */
+	return clc > 1000 ? clc : 1000;
+}
+
+/**
+ * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
+ * @latch:	value to convert
+ * @evt:	pointer to clock event device descriptor
+ *
+ * Math helper, returns latch value converted to nanoseconds (bound checked)
+ */
+u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
+{
+	return cev_delta2ns(latch, evt, false);
 }
 EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
@@ -317,8 +352,8 @@ void clockevents_config(struct clock_event_device *dev, u32 freq)
 		sec = 600;
 
 	clockevents_calc_mult_shift(dev, freq, sec);
-	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
-	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
+	dev->min_delta_ns = cev_delta2ns(dev->min_delta_ticks, dev, false);
+	dev->max_delta_ns = cev_delta2ns(dev->max_delta_ticks, dev, true);
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 09739c6..d570df8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -578,9 +578,12 @@ int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
 	if (isspace(ch)) {
 		parser->buffer[parser->idx] = 0;
 		parser->cont = false;
-	} else {
+	} else if (parser->idx < parser->size - 1) {
 		parser->cont = true;
 		parser->buffer[parser->idx++] = ch;
+	} else {
+		ret = -EINVAL;
+		goto out;
 	}
 
 	*ppos += read;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index fee3752..d01adb7 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -26,7 +26,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 {
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event) &&
-	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* No tracing, just counting, so no obvious leak */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 6096e89..8c2f278 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -419,7 +419,8 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
 
-		if (miter->__flags & SG_MITER_TO_SG)
+		if ((miter->__flags & SG_MITER_TO_SG) &&
+		    !PageSlab(miter->page))
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 598a73e..b82f4ba 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -25,6 +25,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
+#include <linux/cred.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1036,11 +1037,37 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
+
+		switch (kptr_restrict) {
+		case 0:
+			/* Always print %pK values */
+			break;
+		case 1: {
+			/*
+			 * Only print the real pointer value if the current
+			 * process has CAP_SYSLOG and is running with the
+			 * same credentials it started with. This is because
+			 * access to files is checked at open() time, but %pK
+			 * checks permission at read() time. We don't want to
+			 * leak pointer values if a binary opens a file using
+			 * %pK and then elevates privileges before reading it.
+			 */
+			const struct cred *cred = current_cred();
+
+			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+			    !uid_eq(cred->euid, cred->uid) ||
+			    !gid_eq(cred->egid, cred->gid))
+				ptr = NULL;
+			break;
+		}
+		case 2:
+		default:
+			/* Always print 0's for %pK */
 			ptr = NULL;
+			break;
+		}
 		break;
+
 	case 'N':
 		switch (fmt[1]) {
 		case 'F':
diff --git a/mm/mmap.c b/mm/mmap.c
index 7e24763..758ff55 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1443,7 +1443,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1452,7 +1452,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
@@ -1517,7 +1517,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	unsigned long addr = addr0, start_addr;
 
 	/* requested length too big for entire address space */
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1527,7 +1527,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 				(!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2774788..200707c 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -35,7 +35,7 @@ again:
 		struct iphdr _iph;
 ip:
 		iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
-		if (!iph)
+		if (!iph || iph->ihl < 5)
 			return false;
 
 		if (ip_is_fragment(iph))
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0042e61..a461c10 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2847,6 +2847,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, peer);
+	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
 		rcu_read_unlock();
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 38ba70e..73d195e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -808,6 +808,8 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
+ *	cancelled.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -815,6 +817,7 @@ enum {
 	SCAN_ONCHANNEL_SCANNING,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_HW_CANCELLED,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d419c47..ee8f525a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2823,6 +2823,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return 0;
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		}
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b73ce0a..27b796f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -233,6 +233,9 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
+	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
+		return false;
+
 	do {
 		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
 			return false;
@@ -888,7 +891,23 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	if (!local->scan_req)
 		goto out;
 
+	/*
+	 * We have a scan running and the driver already reported completion,
+	 * but the worker hasn't run yet or is stuck on the mutex - mark it as
+	 * cancelled.
+	 */
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning) &&
+	    test_bit(SCAN_COMPLETED, &local->scanning)) {
+		set_bit(SCAN_HW_CANCELLED, &local->scanning);
+		goto out;
+	}
+
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning)) {
+		/*
+		 * Make sure that __ieee80211_scan_completed doesn't trigger a
+		 * scan on another band.
+		 */
+		set_bit(SCAN_HW_CANCELLED, &local->scanning);
 		if (local->ops->cancel_hw_scan)
 			drv_cancel_hw_scan(local, local->scan_sdata);
 		goto out;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index f98b326..619badc 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -183,6 +183,9 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sta->last_rx = jiffies;
+
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d417c48..83755a5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1156,7 +1156,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+	} else if (info->flags & (IEEE80211_TX_CTL_INJECTED |
+				  IEEE80211_TX_INTFL_NL80211_FRAME_TX) ||
 		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 93faf6a..4a8c55b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1468,7 +1468,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 
 		msglen = origlen = end - dptr;
 		if (msglen > datalen)
-			return NF_DROP;
+			return NF_ACCEPT;
 
 		ret = process_sip_msg(skb, ct, dataoff, &dptr, &msglen);
 		if (ret != NF_ACCEPT)
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 631a75d..6b0dd20 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1334,6 +1334,7 @@ call_refreshresult(struct rpc_task *task)
 		return;
 	case -ETIMEDOUT:
 		rpc_delay(task, 3*HZ);
+	case -EKEYEXPIRED:
 	case -EAGAIN:
 		status = -EACCES;
 		if (!task->tk_cred_retry)
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index c4ad795..617a310 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -95,6 +95,10 @@ int ieee80211_radiotap_iterator_init(
 	struct ieee80211_radiotap_header *radiotap_header,
 	int max_length, const struct ieee80211_radiotap_vendor_namespaces *vns)
 {
+	/* check the radiotap header can actually be present */
+	if (max_length < sizeof(struct ieee80211_radiotap_header))
+		return -EINVAL;
+
 	/* Linux only supports version 0 radiotap format */
 	if (radiotap_header->it_version)
 		return -EINVAL;
@@ -129,7 +133,8 @@ int ieee80211_radiotap_iterator_init(
 			 */
 
 			if ((unsigned long)iterator->_arg -
-			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)iterator->_rtheader +
+			    sizeof(uint32_t) >
 			    (unsigned long)iterator->_max_length)
 				return -EINVAL;
 		}
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..9a11f9f 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -55,6 +55,7 @@ static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
+static unsigned long long kernel_start_addr = 0;
 
 int token_profit[0x10000];
 
@@ -65,7 +66,10 @@ unsigned char best_table_len[256];
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--symbol-prefix=<prefix char>] < in.map > out.S\n");
+	fprintf(stderr, "Usage: kallsyms [--all-symbols] "
+			"[--symbol-prefix=<prefix char>] "
+			"[--page-offset=<CONFIG_PAGE_OFFSET>] "
+			"< in.map > out.S\n");
 	exit(1);
 }
 
@@ -194,6 +198,9 @@ static int symbol_valid(struct sym_entry *s)
 	int i;
 	int offset = 1;
 
+	if (s->addr < kernel_start_addr)
+		return 0;
+
 	/* skip prefix char */
 	if (symbol_prefix_char && *(s->sym + 1) == symbol_prefix_char)
 		offset++;
@@ -646,6 +653,9 @@ int main(int argc, char **argv)
 				if ((*p == '"' && *(p+2) == '"') || (*p == '\'' && *(p+2) == '\''))
 					p++;
 				symbol_prefix_char = *p;
+			} else if (strncmp(argv[i], "--page-offset=", 14) == 0) {
+				const char *p = &argv[i][14];
+				kernel_start_addr = strtoull(p, NULL, 16);
 			} else
 				usage();
 		}
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index cd9c6c6..7a9f7f9 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -78,6 +78,8 @@ kallsyms()
 		kallsymopt=--all-symbols
 	fi
 
+	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index e30e1be..6355540 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -49,6 +49,8 @@ static struct snd_pcm *snd_pcm_get(struct snd_card *card, int device)
 	struct snd_pcm *pcm;
 
 	list_for_each_entry(pcm, &snd_pcm_devices, list) {
+		if (pcm->internal)
+			continue;
 		if (pcm->card == card && pcm->device == device)
 			return pcm;
 	}
@@ -60,6 +62,8 @@ static int snd_pcm_next(struct snd_card *card, int device)
 	struct snd_pcm *pcm;
 
 	list_for_each_entry(pcm, &snd_pcm_devices, list) {
+		if (pcm->internal)
+			continue;
 		if (pcm->card == card && pcm->device > device)
 			return pcm->device;
 		else if (pcm->card->number > card->number)
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 5fb90c6..5a48081 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4594,6 +4594,8 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15115, .name = "CX20757",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f151d7, .name = "CX20952",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -4620,6 +4622,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15111");
 MODULE_ALIAS("snd-hda-codec-id:14f15113");
 MODULE_ALIAS("snd-hda-codec-id:14f15114");
 MODULE_ALIAS("snd-hda-codec-id:14f15115");
+MODULE_ALIAS("snd-hda-codec-id:14f151d7");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c3cd1f8..769ba9b 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1283,23 +1283,34 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
 	return 0;
 }
 
-static int generic_hdmi_init(struct hda_codec *codec)
+static int generic_hdmi_init_per_pins(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx;
 
 	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
 		struct hdmi_spec_per_pin *per_pin = &spec->pins[pin_idx];
-		hda_nid_t pin_nid = per_pin->pin_nid;
 		struct hdmi_eld *eld = &per_pin->sink_eld;
 
-		hdmi_init_pin(codec, pin_nid);
-		snd_hda_jack_detect_enable(codec, pin_nid, pin_nid);
-
 		per_pin->codec = codec;
 		INIT_DELAYED_WORK(&per_pin->work, hdmi_repoll_eld);
 		snd_hda_eld_proc_new(codec, eld, pin_idx);
 	}
+	return 0;
+}
+
+static int generic_hdmi_init(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec = codec->spec;
+	int pin_idx;
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hdmi_spec_per_pin *per_pin = &spec->pins[pin_idx];
+		hda_nid_t pin_nid = per_pin->pin_nid;
+
+		hdmi_init_pin(codec, pin_nid);
+		snd_hda_jack_detect_enable(codec, pin_nid, pin_nid);
+	}
 	snd_hda_jack_report_sync(codec);
 	return 0;
 }
@@ -1344,6 +1355,7 @@ static int patch_generic_hdmi(struct hda_codec *codec)
 		return -EINVAL;
 	}
 	codec->patch_ops = generic_hdmi_patch_ops;
+	generic_hdmi_init_per_pins(codec);
 
 	init_channel_allocations();
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index accddc0..72694bd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6729,6 +6729,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x1043, 0x1477, "ASUS N56VZ", ALC662_FIXUP_ASUS_MODE4),
+	SND_PCI_QUIRK(0x1043, 0x1bf3, "ASUS N76VZ", ALC662_FIXUP_ASUS_MODE4),
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index b3e24f2..7e4245f 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -262,7 +262,7 @@ static int ak4642_dai_startup(struct snd_pcm_substream *substream,
 		 * This operation came from example code of
 		 * "ASAHI KASEI AK4642" (japanese) manual p94.
 		 */
-		snd_soc_write(codec, SG_SL1, PMMP | MGAIN0);
+		snd_soc_update_bits(codec, SG_SL1, PMMP | MGAIN0, PMMP | MGAIN0);
 		snd_soc_write(codec, TIMER, ZTM(0x3) | WTM(0x3));
 		snd_soc_write(codec, ALC_CTL1, ALC | LMTH0);
 		snd_soc_update_bits(codec, PW_MGMT1, PMADL, PMADL);
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 932a535..d011a0d 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -502,6 +502,7 @@ static int hp_supply_event(struct snd_soc_dapm_widget *w,
 				hubs->hp_startup_mode);
 			break;
 		}
+		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
 		snd_soc_update_bits(codec, WM8993_CHARGE_PUMP_1,
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 9ddc1a8..8423a2a 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1692,7 +1692,7 @@ static ssize_t dapm_widget_power_read_file(struct file *file,
 				w->active ? "active" : "inactive");
 
 	list_for_each_entry(p, &w->sources, list_sink) {
-		if (p->connected && !p->connected(w, p->sink))
+		if (p->connected && !p->connected(w, p->source))
 			continue;
 
 		if (p->connect)
diff --git a/sound/usb/6fire/chip.c b/sound/usb/6fire/chip.c
index fc8cc82..f803348 100644
--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -101,7 +101,7 @@ static int __devinit usb6fire_chip_probe(struct usb_interface *intf,
 			usb_set_intfdata(intf, chips[i]);
 			mutex_unlock(&register_mutex);
 			return 0;
-		} else if (regidx < 0)
+		} else if (!devices[i] && regidx < 0)
 			regidx = i;
 	}
 	if (regidx < 0) {
