Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3HMQ0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:26:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6276 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3HMQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:25:59 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=oS1AJIQN9ckA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GTO9e9BCcVgA:10 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=-v1EcLp3o2dEfdhCEj4A:9 a=CjuIK1q_8ugA:10 a=1TSTQ8KKaH4A:10 a=1bW_7M_RBKMSg_ol:21 a=86F4bXHT91Ycq5UJ:21 a=4M7Q7JwESyj7MRp7:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 12:25:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [00/88] 3.6.11.7-rc1-stable review
Message-ID: <20130813122554.6cf84125@gandalf.local.home>
In-Reply-To: <20130813155654.069291373@goodmis.org>
References: <20130813155654.069291373@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 61ed6f7..976cae9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6542,6 +6542,7 @@ STABLE BRANCH
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	stable@vger.kernel.org
 S:	Supported
+F:	Documentation/stable_kernel_rules.txt
 
 STAGING SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/Makefile b/Makefile
index 2f707c7..d7b785d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION = .6
+EXTRAVERSION = .7
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index e4448e1..76d7f24 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -305,9 +305,7 @@ static inline void flush_anon_page(struct vm_area_struct *vma,
 }
 
 #define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-}
+extern void flush_kernel_dcache_page(struct page *);
 
 #define flush_dcache_mmap_lock(mapping) \
 	spin_lock_irq(&(mapping)->tree_lock)
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 40ca11e..8f0d285 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -299,6 +299,39 @@ void flush_dcache_page(struct page *page)
 EXPORT_SYMBOL(flush_dcache_page);
 
 /*
+ * Ensure cache coherency for the kernel mapping of this page. We can
+ * assume that the page is pinned via kmap.
+ *
+ * If the page only exists in the page cache and there are no user
+ * space mappings, this is a no-op since the page was already marked
+ * dirty at creation.  Otherwise, we need to flush the dirty kernel
+ * cache lines directly.
+ */
+void flush_kernel_dcache_page(struct page *page)
+{
+	if (cache_is_vivt() || cache_is_vipt_aliasing()) {
+		struct address_space *mapping;
+
+		mapping = page_mapping(page);
+
+		if (!mapping || mapping_mapped(mapping)) {
+			void *addr;
+
+			addr = page_address(page);
+			/*
+			 * kmap_atomic() doesn't set the page virtual
+			 * address for highmem pages, and
+			 * kunmap_atomic() takes care of cache
+			 * flushing already.
+			 */
+			if (!IS_ENABLED(CONFIG_HIGHMEM) || addr)
+				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
+		}
+	}
+}
+EXPORT_SYMBOL(flush_kernel_dcache_page);
+
+/*
  * Flush an anonymous page so that users of get_user_pages()
  * can safely access the data.  The expected sequence is:
  *
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index d51225f..eb5293a 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -57,6 +57,12 @@ void flush_dcache_page(struct page *page)
 }
 EXPORT_SYMBOL(flush_dcache_page);
 
+void flush_kernel_dcache_page(struct page *page)
+{
+	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
+}
+EXPORT_SYMBOL(flush_kernel_dcache_page);
+
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long uaddr, void *dst, const void *src,
 		       unsigned long len)
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index dd5f0a3..b05d919 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -82,4 +82,6 @@ uint64_t __ashrdi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashrdi3);
 uint64_t __ashldi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashldi3);
+int __ffsdi2(uint64_t);
+EXPORT_SYMBOL(__ffsdi2);
 #endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50a1d1f..3ccdf39 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2156,6 +2156,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select BINFMT_ELF
 	select COMPAT_BINFMT_ELF
 	---help---
 	  Include code to run legacy 32-bit programs under a
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 5fb9bbb..38477e6 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -30,6 +30,7 @@ extern int irq_remapping_enabled;
 
 extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
+extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
 extern int irq_remapping_enable(void);
 extern void irq_remapping_disable(void);
@@ -58,6 +59,7 @@ extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 
 static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
+static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
 static inline int irq_remapping_enable(void) { return -ENODEV; }
 static inline void irq_remapping_disable(void) { }
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 3755ef4..94ab6b9 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -18,6 +18,7 @@
 #include <asm/apic.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/irq_remapping.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -192,6 +193,21 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
+static void __init intel_remapping_check(int num, int slot, int func)
+{
+	u8 revision;
+
+	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
+
+	/*
+	 * Revision 0x13 of this chipset supports irq remapping
+	 * but has an erratum that breaks its behavior, flag it as such
+	 */
+	if (revision == 0x13)
+		set_irq_remapping_broken();
+
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -221,6 +237,10 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{}
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7a361f..2dcd250 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -558,8 +558,6 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
 	xcr0 = xcr;
-	if (kvm_x86_ops->get_cpl(vcpu) != 0)
-		return 1;
 	if (!(xcr0 & XSTATE_FP))
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
@@ -573,7 +571,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (__kvm_set_xcr(vcpu, index, xcr)) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 054cc01..d50a821 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -36,9 +36,8 @@ static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
 /* snapshots of runstate info */
 static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
 
-/* unused ns of stolen and blocked time */
+/* unused ns of stolen time */
 static DEFINE_PER_CPU(u64, xen_residual_stolen);
-static DEFINE_PER_CPU(u64, xen_residual_blocked);
 
 /* return an consistent snapshot of 64-bit time/counter value */
 static u64 get64(const u64 *p)
@@ -115,7 +114,7 @@ static void do_stolen_accounting(void)
 {
 	struct vcpu_runstate_info state;
 	struct vcpu_runstate_info *snap;
-	s64 blocked, runnable, offline, stolen;
+	s64 runnable, offline, stolen;
 	cputime_t ticks;
 
 	get_runstate_snapshot(&state);
@@ -125,7 +124,6 @@ static void do_stolen_accounting(void)
 	snap = &__get_cpu_var(xen_runstate_snapshot);
 
 	/* work out how much time the VCPU has not been runn*ing*  */
-	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
 	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
 	offline = state.time[RUNSTATE_offline] - snap->time[RUNSTATE_offline];
 
@@ -141,17 +139,6 @@ static void do_stolen_accounting(void)
 	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
 	__this_cpu_write(xen_residual_stolen, stolen);
 	account_steal_ticks(ticks);
-
-	/* Add the appropriate number of ticks of blocked time,
-	   including any left-overs from last time. */
-	blocked += __this_cpu_read(xen_residual_blocked);
-
-	if (blocked < 0)
-		blocked = 0;
-
-	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
-	__this_cpu_write(xen_residual_blocked, blocked);
-	account_idle_ticks(ticks);
 }
 
 /* Get the TSC speed from Xen */
diff --git a/block/genhd.c b/block/genhd.c
index d839723..63d304e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -517,7 +517,7 @@ static void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
diff --git a/crypto/algapi.c b/crypto/algapi.c
index c3b9bfe..13e5766 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -495,7 +495,8 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name), "%s",
+				       name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 769219b..76fc0b2 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -45,10 +45,9 @@ struct cryptomgr_param {
 		} nu32;
 	} attrs[CRYPTO_MAX_ATTRS];
 
-	char larval[CRYPTO_MAX_ALG_NAME];
 	char template[CRYPTO_MAX_ALG_NAME];
 
-	struct completion *completion;
+	struct crypto_larval *larval;
 
 	u32 otype;
 	u32 omask;
@@ -87,7 +86,8 @@ static int cryptomgr_probe(void *data)
 	crypto_tmpl_put(tmpl);
 
 out:
-	complete_all(param->completion);
+	complete_all(&param->larval->completion);
+	crypto_alg_put(&param->larval->alg);
 	kfree(param);
 	module_put_and_exit(0);
 }
@@ -187,18 +187,19 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	param->otype = larval->alg.cra_flags;
 	param->omask = larval->mask;
 
-	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
-
-	param->completion = &larval->completion;
+	crypto_alg_get(&larval->alg);
+	param->larval = larval;
 
 	thread = kthread_run(cryptomgr_probe, param, "cryptomgr_probe");
 	if (IS_ERR(thread))
-		goto err_free_param;
+		goto err_put_larval;
 
 	wait_for_completion_interruptible(&larval->completion);
 
 	return NOTIFY_STOP;
 
+err_put_larval:
+	crypto_alg_put(&larval->alg);
 err_free_param:
 	kfree(param);
 err_put_module:
diff --git a/crypto/api.c b/crypto/api.c
index 033a714..3b61803 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -34,12 +34,6 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
-static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
-{
-	atomic_inc(&alg->cra_refcnt);
-	return alg;
-}
-
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
 {
 	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
diff --git a/crypto/internal.h b/crypto/internal.h
index 9ebedae..bd39bfc 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -103,6 +103,12 @@ int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
 int crypto_probing_notify(unsigned long val, void *v);
 
+static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
+{
+	atomic_inc(&alg->cra_refcnt);
+	return alg;
+}
+
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
 	if (atomic_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 1f165a7..c92753b 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -242,12 +242,14 @@ acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
 	    &acpi_sleep_dispatch[function_id];
 
 #if (!ACPI_REDUCED_HARDWARE)
-
 	/*
 	 * If the Hardware Reduced flag is set (from the FADT), we must
-	 * use the extended sleep registers
+	 * use the extended sleep registers (FADT). Note: As per the ACPI
+	 * specification, these extended registers are to be used for HW-reduced
+	 * platforms only. They are not general-purpose replacements for the
+	 * legacy PM register sleep support.
 	 */
-	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+	if (acpi_gbl_reduced_hardware) {
 		status = sleep_functions->extended_function(sleep_state);
 	} else {
 		/* Legacy sleep */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 555c07a..48a946a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1544,8 +1544,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		u32 fbs = readl(port_mmio + PORT_FBS);
 		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
 
-		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
-		    ata_link_online(&ap->pmp_link[pmp])) {
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links)) {
 			link = &ap->pmp_link[pmp];
 			fbs_need_dec = true;
 		}
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 926c9f5..05e20e6 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -153,8 +153,10 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait)
+	if (wait) {
 		ata_port_wait_eh(ap);
+		flush_work(&ap->hotplug_task.work);
+	}
 }
 
 static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
@@ -211,6 +213,37 @@ static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 	.uevent = ata_acpi_ap_uevent,
 };
 
+void ata_acpi_hotplug_init(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		acpi_handle handle;
+		struct ata_device *dev;
+
+		if (!ap)
+			continue;
+
+		handle = ata_ap_acpi_handle(ap);
+		if (handle) {
+			/* we might be on a docking station */
+			register_hotplug_dock_device(handle,
+						     &ata_acpi_ap_dock_ops, ap);
+		}
+
+		ata_for_each_dev(dev, &ap->link, ALL) {
+			handle = ata_dev_acpi_handle(dev);
+			if (!handle)
+				continue;
+
+			/* we might be on a docking station */
+			register_hotplug_dock_device(handle,
+						     &ata_acpi_dev_dock_ops, dev);
+		}
+	}
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b76e6ea..a55171d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6066,6 +6066,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	if (rc)
 		goto err_tadd;
 
+	ata_acpi_hotplug_init(host);
+
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 50e4dff..0fa6186 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -122,6 +122,7 @@ extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
 extern void ata_acpi_bind(struct ata_device *dev);
 extern void ata_acpi_unbind(struct ata_device *dev);
+extern void ata_acpi_hotplug_init(struct ata_host *host);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -134,6 +135,7 @@ static inline int ata_acpi_register(void) { return 0; }
 static inline void ata_acpi_unregister(void) { }
 static inline void ata_acpi_bind(struct ata_device *dev) { }
 static inline void ata_acpi_unbind(struct ata_device *dev) { }
+static inline void ata_acpi_hotplug_init(struct ata_host *host) {}
 #endif
 
 /* libata-scsi.c */
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0c03411..aec3470 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -594,6 +594,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
 		if (!nbd->sock)
 			return -EINVAL;
+
+		nbd->disconnect = 1;
+
 		nbd_send_req(nbd, &sreq);
                 return 0;
 	}
@@ -624,6 +627,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				nbd->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -670,7 +674,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 
 		mutex_unlock(&nbd->tx_lock);
 
-		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
+		thread = kthread_create(nbd_thread, nbd, "%s",
+					nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
@@ -694,6 +699,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		set_capacity(nbd->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		if (nbd->disconnect) /* user requested, ignore socket errors */
+			return 0;
 		return nbd->harderror;
 	}
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d620b44..8a3aff7 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2882,7 +2882,7 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index efdfd00..9c3104a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1542,6 +1542,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		/* XXX the notifier code should handle this better */
 		if (!cn->notifier_head.head) {
 			srcu_cleanup_notifier_head(&cn->notifier_head);
+			list_del(&cn->node);
 			kfree(cn);
 		}
 
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index f5843bc..de4ec1a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2462,10 +2462,10 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
 
-	spin_lock_irqsave(&pch->lock, flags);
-
 	tasklet_kill(&pch->task);
 
+	spin_lock_irqsave(&pch->lock, flags);
+
 	pl330_release_channel(pch->pl330_chid);
 	pch->pl330_chid = NULL;
 
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 43c431a..69ffa29 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -361,8 +361,18 @@ int radeon_ring_alloc(struct radeon_device *rdev, struct radeon_ring *ring, unsi
 {
 	int r;
 
+	/* make sure we aren't trying to allocate more space than there is on the ring */
+	if (ndw > (ring->ring_size / 4))
+		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
+	radeon_ring_free_size(rdev, ring);
+	if (ring->ring_free_dw == (ring->ring_size / 4)) {
+		/* This is an empty ring update lockup info to avoid
+		 * false positive.
+		 */
+		radeon_ring_lockup_update(ring);
+	}
 	ndw = (ndw + ring->align_mask) & ~ring->align_mask;
 	while (ndw > (ring->ring_free_dw - 1)) {
 		radeon_ring_free_size(rdev, ring);
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 7233c88..14aa6fe 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -454,7 +454,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index */
 	/*is updated */
-	smp_mb();
+	mb();
 
 	/* Update the read index */
 	hv_set_next_read_location(inring_info, next_read_location);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4748086..db5fc10 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -466,7 +466,7 @@ static void vmbus_on_msg_dpc(unsigned long data)
 		 * will not deliver any more messages since there is
 		 * no empty slot
 		 */
-		smp_mb();
+		mb();
 
 		if (msg->header.message_flags.msg_pending) {
 			/*
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index f030d9e..3f505d5 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -133,7 +133,7 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
 	memcpy(bl_cmd, bl_command, sizeof(bl_command));
 	if (ts->pdata->bl_keys)
 		memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
-			ts->pdata->bl_keys, sizeof(bl_command));
+			ts->pdata->bl_keys, CY_NUM_BL_KEYS);
 
 	error = ttsp_write_block_data(ts, CY_REG_BASE,
 				      sizeof(bl_cmd), bl_cmd);
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index af8904d..4c9379c 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -509,6 +509,16 @@ static int __init intel_irq_remapping_supported(void)
 
 	if (disable_irq_remap)
 		return 0;
+	if (irq_remap_broken) {
+		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
+			   "This system BIOS has enabled interrupt remapping\n"
+			   "on a chipset that contains an erratum making that\n"
+			   "feature unstable.  To maintain system stability\n"
+			   "interrupt remapping is being disabled.  Please\n"
+			   "contact your BIOS vendor for an update\n");
+		disable_irq_remap = 1;
+		return 0;
+	}
 
 	if (!dmar_ir_support())
 		return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 151690d..4a971f7 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -12,6 +12,7 @@
 int irq_remapping_enabled;
 
 int disable_irq_remap;
+int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
@@ -53,6 +54,11 @@ void __init setup_irq_remapping_ops(void)
 	remap_ops = &intel_irq_remap_ops;
 }
 
+void set_irq_remapping_broken(void)
+{
+	irq_remap_broken = 1;
+}
+
 int irq_remapping_supported(void)
 {
 	if (disable_irq_remap)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index b12974c..3fcf62c 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -32,6 +32,7 @@ struct pci_dev;
 struct msi_msg;
 
 extern int disable_irq_remap;
+extern int irq_remap_broken;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index d81c7af..d98b3f2 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -521,6 +521,7 @@ static int gianfar_ptp_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
+	iounmap(etsects->regs);
 no_ioremap:
 	release_resource(etsects->rsrc);
 no_resource:
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index a2679d8..dd3371b 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1100,6 +1100,7 @@ static void cp_clean_rings (struct cp_private *cp)
 			cp->dev->stats.tx_dropped++;
 		}
 	}
+	netdev_reset_queue(cp->dev);
 
 	memset(cp->rx_ring, 0, sizeof(struct cp_desc) * CP_RX_RING_SIZE);
 	memset(cp->tx_ring, 0, sizeof(struct cp_desc) * CP_TX_RING_SIZE);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index bad8f2e..cce72da 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1102,16 +1102,23 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status)
 		desc_status = edmac_to_cpu(mdp, rxdesc->status);
 		pkt_len = rxdesc->frame_length;
 
-#if defined(CONFIG_ARCH_R8A7740)
-		desc_status >>= 16;
-#endif
-
 		if (--boguscnt < 0)
 			break;
 
 		if (!(desc_status & RDFEND))
 			ndev->stats.rx_length_errors++;
 
+#if defined(CONFIG_ARCH_R8A7740)
+		/*
+		 * In case of almost all GETHER/ETHERs, the Receive Frame State
+		 * (RFS) bits in the Receive Descriptor 0 are from bit 9 to
+		 * bit 0. However, in case of the R8A7740's GETHER, the RFS
+		 * bits are from bit 25 to bit 16. So, the driver needs right
+		 * shifting by 16.
+		 */
+		desc_status >>= 16;
+#endif
+
 		if (desc_status & (RD_RFS1 | RD_RFS2 | RD_RFS3 | RD_RFS4 |
 				   RD_RFS5 | RD_RFS6 | RD_RFS10)) {
 			ndev->stats.rx_errors++;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7ca2ff9..ec95660 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1152,7 +1152,7 @@ int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
 		adv = phy_eee_to_adv(eee_adv);
 		lp = phy_eee_to_adv(eee_lp);
 		idx = phy_find_setting(phydev->speed, phydev->duplex);
-		if ((lp & adv & settings[idx].setting))
+		if (!(lp & adv & settings[idx].setting))
 			goto eee_exit;
 
 		if (clk_stop_enable) {
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8a11070..adeb533 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -945,8 +945,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 	}
 
 	port->index = -1;
-	team_port_enable(team, port);
 	list_add_tail_rcu(&port->list, &team->port_list);
+	team_port_enable(team, port);
 	__team_compute_features(team);
 	__team_port_change_port_added(port, !!netif_carrier_ok(port_dev));
 	__team_options_change_check(team);
diff --git a/drivers/net/team/team_mode_roundrobin.c b/drivers/net/team/team_mode_roundrobin.c
index ad7ed0e..dcbe6ba 100644
--- a/drivers/net/team/team_mode_roundrobin.c
+++ b/drivers/net/team/team_mode_roundrobin.c
@@ -52,6 +52,8 @@ static bool rr_transmit(struct team *team, struct sk_buff *skb)
 
 	port_index = rr_priv(team)->sent_packets++ % team->en_port_count;
 	port = team_get_port_by_index_rcu(team, port_index);
+	if (unlikely(!port))
+		goto drop;
 	port = __get_first_port_up(team, port);
 	if (unlikely(!port))
 		goto drop;
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 147614e..6a8a382 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -384,21 +384,37 @@ static int dlci_del(struct dlci_add *dlci)
 	struct frad_local	*flp;
 	struct net_device	*master, *slave;
 	int			err;
+	bool			found = false;
+
+	rtnl_lock();
 
 	/* validate slave device */
 	master = __dev_get_by_name(&init_net, dlci->devname);
-	if (!master)
-		return -ENODEV;
+	if (!master) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	list_for_each_entry(dlp, &dlci_devs, list) {
+		if (dlp->master == master) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	if (netif_running(master)) {
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
 	dlp = netdev_priv(master);
 	slave = dlp->slave;
 	flp = netdev_priv(slave);
 
-	rtnl_lock();
 	err = (*flp->deassoc)(slave, master);
 	if (!err) {
 		list_del(&dlp->list);
@@ -407,8 +423,8 @@ static int dlci_del(struct dlci_add *dlci)
 
 		dev_put(slave);
 	}
+out:
 	rtnl_unlock();
-
 	return err;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c785129..b132b43 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1193,7 +1193,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		mutex_lock(&priv->htc_pm_lock);
 
 		priv->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-		if (priv->ps_idle)
+		if (!priv->ps_idle)
 			chip_reset = true;
 
 		mutex_unlock(&priv->htc_pm_lock);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 6a86814..745e9dd 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -387,8 +387,7 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	u8 tid;
 
 	if (!(txinfo->flags & IEEE80211_TX_CTL_AMPDU) ||
-	    txinfo->flags & IEEE80211_TX_CTL_INJECTED ||
-	   (!(super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_AGGR))))
+	    txinfo->flags & IEEE80211_TX_CTL_INJECTED)
 		return;
 
 	rcu_read_lock();
@@ -982,30 +981,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 		SET_VAL(CARL9170_TX_SUPER_AMPDU_FACTOR,
 			txc->s.ampdu_settings, factor);
-
-		for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
-			txrate = &info->control.rates[i];
-			if (txrate->idx >= 0) {
-				txc->s.ri[i] =
-					CARL9170_TX_SUPER_RI_AMPDU;
-
-				if (WARN_ON(!(txrate->flags &
-					      IEEE80211_TX_RC_MCS))) {
-					/*
-					 * Not sure if it's even possible
-					 * to aggregate non-ht rates with
-					 * this HW.
-					 */
-					goto err_out;
-				}
-				continue;
-			}
-
-			txrate->idx = 0;
-			txrate->count = ar->hw->max_rate_tries;
-		}
-
-		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
 	}
 
 	/*
@@ -1013,11 +988,31 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	 * taken from mac_control. For all fallback rate, the firmware
 	 * updates the mac_control flags from the rate info field.
 	 */
-	for (i = 1; i < CARL9170_TX_MAX_RATES; i++) {
+	for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
+		__le32 phy_set;
 		txrate = &info->control.rates[i];
 		if (txrate->idx < 0)
 			break;
 
+		phy_set = carl9170_tx_physet(ar, info, txrate);
+		if (i == 0) {
+			/* first rate - part of the hw's frame header */
+			txc->f.phy_control = phy_set;
+
+			if (ampdu && txrate->flags & IEEE80211_TX_RC_MCS)
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
+			if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
+			else if (carl9170_tx_cts_check(ar, txrate))
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
+
+		} else {
+			/* fallback rates are stored in the firmware's
+			 * retry rate set array.
+			 */
+			txc->s.rr[i - 1] = phy_set;
+		}
+
 		SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[i],
 			txrate->count);
 
@@ -1028,21 +1023,13 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_CTS <<
 				CARL9170_TX_SUPER_RI_ERP_PROT_S);
 
-		txc->s.rr[i - 1] = carl9170_tx_physet(ar, info, txrate);
+		if (ampdu && (txrate->flags & IEEE80211_TX_RC_MCS))
+			txc->s.ri[i] |= CARL9170_TX_SUPER_RI_AMPDU;
 	}
 
-	txrate = &info->control.rates[0];
-	SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[0], txrate->count);
-
-	if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
-		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
-	else if (carl9170_tx_cts_check(ar, txrate))
-		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
-
 	txc->s.len = cpu_to_le16(skb->len);
 	txc->f.length = cpu_to_le16(len + FCS_LEN);
 	txc->f.mac_control = mac_tmp;
-	txc->f.phy_control = carl9170_tx_physet(ar, info, txrate);
 
 	arinfo = (void *)info->rate_driver_data;
 	arinfo->timeout = jiffies;
@@ -1382,9 +1369,9 @@ static void carl9170_tx(struct ar9170 *ar)
 }
 
 static bool carl9170_tx_ampdu_queue(struct ar9170 *ar,
-	struct ieee80211_sta *sta, struct sk_buff *skb)
+	struct ieee80211_sta *sta, struct sk_buff *skb,
+	struct ieee80211_tx_info *txinfo)
 {
-	struct _carl9170_tx_superframe *super = (void *) skb->data;
 	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *agg;
 	struct sk_buff *iter;
@@ -1451,7 +1438,7 @@ err_unlock:
 
 err_unlock_rcu:
 	rcu_read_unlock();
-	super->f.mac_control &= ~cpu_to_le16(AR9170_TX_MAC_AGGR);
+	txinfo->flags &= ~IEEE80211_TX_CTL_AMPDU;
 	carl9170_tx_status(ar, skb, false);
 	ar->tx_dropped++;
 	return false;
@@ -1485,7 +1472,7 @@ void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		run = carl9170_tx_ampdu_queue(ar, sta, skb);
+		run = carl9170_tx_ampdu_queue(ar, sta, skb, info);
 		if (run)
 			carl9170_tx_ampdu(ar);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 2830ea2..18eaca3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1377,7 +1377,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
-	if (!(priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED))
+	if (priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED)
 		return;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 506b9a0..4763426 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -104,7 +104,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			tx_agc[RF90_PATH_A] = 0x10101010;
 			tx_agc[RF90_PATH_B] = 0x10101010;
 		} else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-			   TXHIGHPWRLEVEL_LEVEL1) {
+			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
 		} else{
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 61859d0..3343302 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1671,8 +1671,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
 	error = device_register(&bridge->dev);
-	if (error)
-		goto bridge_dev_reg_err;
+	if (error) {
+		put_device(&bridge->dev);
+		goto err_out;
+	}
 	b->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(b->bridge);
 	pci_set_bus_of_node(b);
@@ -1728,8 +1730,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 class_dev_reg_err:
 	put_device(&bridge->dev);
 	device_unregister(&bridge->dev);
-bridge_dev_reg_err:
-	kfree(bridge);
 err_out:
 	kfree(b);
 	return NULL;
diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 9694c1e..fc50168 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -100,9 +100,9 @@ static int at91_cf_get_status(struct pcmcia_socket *s, u_int *sp)
 		int vcc	= gpio_is_valid(cf->board->vcc_pin);
 
 		*sp = SS_DETECT | SS_3VCARD;
-		if (!rdy || gpio_get_value(rdy))
+		if (!rdy || gpio_get_value(cf->board->irq_pin))
 			*sp |= SS_READY;
-		if (!vcc || gpio_get_value(vcc))
+		if (!vcc || gpio_get_value(cf->board->vcc_pin))
 			*sp |= SS_POWERON;
 	} else
 		*sp = 0;
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 526e5c9..25b1fea 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -368,7 +368,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 	strncpy(env_str, event, UEVENT_BUF_SIZE);
 	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
 
-	dev_info(cm->dev, event);
+	dev_info(cm->dev, "%s", event);
 }
 
 /**
diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index 0fbe57b..21d63d1 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -310,7 +310,7 @@ static int rv3029c2_rtc_i2c_set_alarm(struct i2c_client *client,
 		dev_dbg(&client->dev, "alarm IRQ armed\n");
 	} else {
 		/* disable AIE irq */
-		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 0);
 		if (ret)
 			return ret;
 
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index d4ed9eb..caac1b2 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -465,7 +465,7 @@ static int osd_probe(struct device *dev)
 	oud->class_dev.class = &osd_uld_class;
 	oud->class_dev.parent = dev;
 	oud->class_dev.release = __remove;
-	error = dev_set_name(&oud->class_dev, disk->disk_name);
+	error = dev_set_name(&oud->class_dev, "%s", disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
 		goto err_put_cdev;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7fa0672..bda062d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -688,8 +688,12 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		 * For FCP_READ with CHECK_CONDITION status, clear cmd->bufflen
 		 * for qla_tgt_xmit_response LLD code
 		 */
+		if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			se_cmd->se_cmd_flags &= ~SCF_OVERFLOW_BIT;
+			se_cmd->residual_count = 0;
+		}
 		se_cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-		se_cmd->residual_count = se_cmd->data_length;
+		se_cmd->residual_count += se_cmd->data_length;
 
 		cmd->bufflen = 0;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 88ced02..a2ecd324 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -141,7 +141,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
-	const char *temp = "temporary ";
+	static const char temp[] = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 1a02016..e768bfa 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -834,11 +834,11 @@ extern int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
 		return 0;
 
 	sess->time2retain_timer_flags |= ISCSI_TF_STOP;
-	spin_unlock_bh(&se_tpg->session_lock);
+	spin_unlock(&se_tpg->session_lock);
 
 	del_timer_sync(&sess->time2retain_timer);
 
-	spin_lock_bh(&se_tpg->session_lock);
+	spin_lock(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
 	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
 			sess->sid);
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 4f1142e..4d60ad3 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -433,6 +433,7 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -652,6 +653,7 @@ static int sleep_thread(struct fsg_common *common)
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 419d34a..e833270 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -364,6 +364,10 @@ static struct xhci_container_ctx *xhci_alloc_container_ctx(struct xhci_hcd *xhci
 		ctx->size += CTX_SIZE(xhci->hcc_params);
 
 	ctx->bytes = dma_pool_alloc(xhci->device_pool, flags, &ctx->dma);
+	if (!ctx->bytes) {
+		kfree(ctx);
+		return NULL;
+	}
 	memset(ctx->bytes, 0, ctx->size);
 	return ctx;
 }
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..93ad67e 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -179,6 +179,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	kfree(xhci);
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 722069c..c7550bf 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -180,7 +180,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
index b353e7e..4a2423e 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -52,7 +52,9 @@
 
 /* Abbott Diabetics vendor and product ids */
 #define ABBOTT_VENDOR_ID		0x1a61
-#define ABBOTT_PRODUCT_ID		0x3410
+#define ABBOTT_STEREO_PLUG_ID		0x3410
+#define ABBOTT_PRODUCT_ID		ABBOTT_STEREO_PLUG_ID
+#define ABBOTT_STRIP_PORT_ID		0x3420
 
 /* Commands */
 #define TI_GET_VERSION			0x01
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 4fb0974..fe8d627 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -327,14 +327,14 @@ UniToupper(register wchar_t uc)
 /*
  * UniStrupr:  Upper case a unicode string
  */
-static inline wchar_t *
-UniStrupr(register wchar_t *upin)
+static inline __le16 *
+UniStrupr(register __le16 *upin)
 {
-	register wchar_t *up;
+	register __le16 *up;
 
 	up = upin;
 	while (*up) {		/* For all characters */
-		*up = UniToupper(*up);
+		*up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
 		up++;
 	}
 	return upin;		/* Return input pointer */
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 6a0d741..9caf0c6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -394,7 +394,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
-	wchar_t *user;
+	__le16 *user;
 	wchar_t *domain;
 	wchar_t *server;
 
@@ -419,7 +419,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		return rc;
 	}
 
-	/* convert ses->user_name to unicode and uppercase */
+	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
@@ -429,7 +429,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	}
 
 	if (len) {
-		len = cifs_strtoUTF16((__le16 *)user, ses->user_name, len, nls_cp);
+		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
 		UniStrupr(user);
 	} else {
 		memset(user, '\0', 2);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8808dce..4a640e3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -545,6 +545,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 			fattr->cf_mode &= ~(S_IWUGO);
 
 		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+		if (fattr->cf_nlink < 1) {
+			cifserror("replacing bogus file nlink value %u\n",
+				fattr->cf_nlink);
+			fattr->cf_nlink = 1;
+		}
 	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;
diff --git a/fs/exec.c b/fs/exec.c
index 39b6a3c..6f238c8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1162,13 +1162,6 @@ void setup_new_exec(struct linux_binprm * bprm)
 			set_dumpable(current->mm, suid_dumpable);
 	}
 
-	/*
-	 * Flush performance counters when crossing a
-	 * security domain:
-	 */
-	if (!get_dumpable(current->mm))
-		perf_event_exit_task(current);
-
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
@@ -1217,6 +1210,15 @@ void install_exec_creds(struct linux_binprm *bprm)
 
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
+
+	/*
+	 * Disable monitoring for regular users
+	 * when executing setuid binaries. Must
+	 * wait until new credentials are committed
+	 * by commit_creds() above
+	 */
+	if (get_dumpable(current->mm) != SUID_DUMP_USER)
+		perf_event_exit_task(current);
 	/*
 	 * cred_guard_mutex must be held at least to this point to prevent
 	 * ptrace_attach() from altering our determination of the task's
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 8f4fdda..93e541b 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -573,11 +573,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse (bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4f7d479..345442f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4767,7 +4767,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		error = ext4_get_inode_loc(inode, &iloc);
 		if (error)
 			return error;
-		physical = iloc.bh->b_blocknr << blockbits;
+		physical = (__u64)iloc.bh->b_blocknr << blockbits;
 		offset = EXT4_GOOD_OLD_INODE_SIZE +
 				EXT4_I(inode)->i_extra_isize;
 		physical += offset;
@@ -4775,7 +4775,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
 		brelse(iloc.bh);
 	} else { /* external block */
-		physical = EXT4_I(inode)->i_file_acl << blockbits;
+		physical = (__u64)EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
 	}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 72c9d8d..b65a0f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4385,7 +4385,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
 	struct inode *inode;
-	unsigned long delalloc_blocks;
+	unsigned long long delalloc_blocks;
 
 	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
@@ -4403,7 +4403,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
 				EXT4_I(inode)->i_reserved_data_blocks);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits-9);
 	return 0;
 }
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bd62716..f7cfb2e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4641,11 +4641,16 @@ do_more:
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
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d13873d..b1aaccc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -859,11 +859,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 					 + ((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse(bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext4fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index 4acb19d..803d3da 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -17,7 +17,8 @@ __le32 *hpfs_map_bitmap(struct super_block *s, unsigned bmp_block,
 			 struct quad_buffer_head *qbh, char *id)
 {
 	secno sec;
-	if (hpfs_sb(s)->sb_chk) if (bmp_block * 16384 > hpfs_sb(s)->sb_fs_size) {
+	unsigned n_bands = (hpfs_sb(s)->sb_fs_size + 0x3fff) >> 14;
+	if (hpfs_sb(s)->sb_chk) if (bmp_block >= n_bands) {
 		hpfs_error(s, "hpfs_map_bitmap called with bad parameter: %08x at %s", bmp_block, id);
 		return NULL;
 	}
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..8d250192 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -552,7 +552,13 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	sbi->sb_cp_table = NULL;
 	sbi->sb_c_bitmap = -1;
 	sbi->sb_max_fwd_alloc = 0xffffff;
-	
+
+	if (sbi->sb_fs_size >= 0x80000000) {
+		hpfs_error(s, "invalid size in superblock: %08x",
+			(unsigned)sbi->sb_fs_size);
+		goto bail4;
+	}
+
 	/* Load bitmap directory */
 	if (!(sbi->sb_bmp_dir = hpfs_load_bitmap_directory(s, le32_to_cpu(superblock->bitmaps))))
 		goto bail4;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b2d3cbe..cebd59c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1304,6 +1304,7 @@ static int journal_reset(journal_t *journal)
 static void jbd2_write_superblock(journal_t *journal, int write_op)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
+	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
 	trace_jbd2_write_superblock(journal, write_op);
@@ -1325,6 +1326,7 @@ static void jbd2_write_superblock(journal_t *journal, int write_op)
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
 	}
+	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	ret = submit_bh(write_op, bh);
@@ -1421,7 +1423,6 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n",
 		  journal->j_errno);
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
-	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 9427cf1..718fe8f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -499,10 +499,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 		   &transaction->t_outstanding_credits);
 	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
+	tid = transaction->t_tid;
 	spin_unlock(&transaction->t_handle_lock);
 
 	jbd_debug(2, "restarting handle %p\n", handle);
-	tid = transaction->t_tid;
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 348937b..1f43627 100644
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
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0ba9ea1..8abed46 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6499,6 +6499,16 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 	}
 
 	new_oi = OCFS2_I(args->new_inode);
+	/*
+	 * Adjust extent record count to reserve space for extended attribute.
+	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
+	 */
+	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
+		struct ocfs2_extent_list *el = &new_di->id2.i_list;
+		le16_add_cpu(&el->l_count, -(inline_size /
+					sizeof(struct ocfs2_extent_rec)));
+	}
 	spin_lock(&new_oi->ip_lock);
 	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
 	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index c95681c..1f61701 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -349,31 +349,50 @@ static unsigned int vfs_dent_type(uint8_t type)
 static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 {
 	int err, over = 0;
+	loff_t pos = file->f_pos;
 	struct qstr nm;
 	union ubifs_key key;
 	struct ubifs_dent_node *dent;
 	struct inode *dir = file->f_path.dentry->d_inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 
-	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, file->f_pos);
+	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, pos);
 
-	if (file->f_pos > UBIFS_S_KEY_HASH_MASK || file->f_pos == 2)
+	if (pos > UBIFS_S_KEY_HASH_MASK || pos == 2)
 		/*
 		 * The directory was seek'ed to a senseless position or there
 		 * are no more entries.
 		 */
 		return 0;
 
+	if (file->f_version == 0) {
+		/*
+		 * The file was seek'ed, which means that @file->private_data
+		 * is now invalid. This may also be just the first
+		 * 'ubifs_readdir()' invocation, in which case
+		 * @file->private_data is NULL, and the below code is
+		 * basically a no-op.
+		 */
+		kfree(file->private_data);
+		file->private_data = NULL;
+	}
+
+	/*
+	 * 'generic_file_llseek()' unconditionally sets @file->f_version to
+	 * zero, and we use this for detecting whether the file was seek'ed.
+	 */
+	file->f_version = 1;
+
 	/* File positions 0 and 1 correspond to "." and ".." */
-	if (file->f_pos == 0) {
+	if (pos == 0) {
 		ubifs_assert(!file->private_data);
 		over = filldir(dirent, ".", 1, 0, dir->i_ino, DT_DIR);
 		if (over)
 			return 0;
-		file->f_pos = 1;
+		file->f_pos = pos = 1;
 	}
 
-	if (file->f_pos == 1) {
+	if (pos == 1) {
 		ubifs_assert(!file->private_data);
 		over = filldir(dirent, "..", 2, 1,
 			       parent_ino(file->f_path.dentry), DT_DIR);
@@ -389,7 +408,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			goto out;
 		}
 
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -397,17 +416,16 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	if (!dent) {
 		/*
 		 * The directory was seek'ed to and is now readdir'ed.
-		 * Find the entry corresponding to @file->f_pos or the
-		 * closest one.
+		 * Find the entry corresponding to @pos or the closest one.
 		 */
-		dent_key_init_hash(c, &key, dir->i_ino, file->f_pos);
+		dent_key_init_hash(c, &key, dir->i_ino, pos);
 		nm.name = NULL;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
 			err = PTR_ERR(dent);
 			goto out;
 		}
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -419,7 +437,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			     ubifs_inode(dir)->creat_sqnum);
 
 		nm.len = le16_to_cpu(dent->nlen);
-		over = filldir(dirent, dent->name, nm.len, file->f_pos,
+		over = filldir(dirent, dent->name, nm.len, pos,
 			       le64_to_cpu(dent->inum),
 			       vfs_dent_type(dent->type));
 		if (over)
@@ -435,9 +453,17 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		}
 
 		kfree(file->private_data);
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 		cond_resched();
+
+		if (file->f_version == 0)
+			/*
+			 * The file was seek'ed meanwhile, lets return and start
+			 * reading direntries from the new position on the next
+			 * invocation.
+			 */
+			return 0;
 	}
 
 out:
@@ -448,15 +474,13 @@ out:
 
 	kfree(file->private_data);
 	file->private_data = NULL;
+	/* 2 is a special value indicating that there are no more direntries */
 	file->f_pos = 2;
 	return 0;
 }
 
-/* If a directory is seeked, we have to free saved readdir() state */
 static loff_t ubifs_dir_llseek(struct file *file, loff_t offset, int origin)
 {
-	kfree(file->private_data);
-	file->private_data = NULL;
 	return generic_file_llseek(file, offset, origin);
 }
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2251648..2d7c263 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -341,6 +341,17 @@ static inline int hstate_index(struct hstate *h)
 	return h - hstates;
 }
 
+pgoff_t __basepage_index(struct page *page);
+
+/* Return page->index in PAGE_SIZE units */
+static inline pgoff_t basepage_index(struct page *page)
+{
+	if (!PageCompound(page))
+		return page->index;
+
+	return __basepage_index(page);
+}
+
 #else
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -360,6 +371,11 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 }
 #define hstate_index_to_shift(index) 0
 #define hstate_index(h) 0
+
+static inline pgoff_t basepage_index(struct page *page)
+{
+       return page->index;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index d146ca1..e6fe174 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -68,6 +68,7 @@ struct nbd_device {
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
 	int xmit_timeout;
+	int disconnect; /* a disconnect has been requested by user */
 };
 
 #endif
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bdb4161..9332017 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -953,8 +953,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 2ae1371..1c33dd7 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -105,9 +105,14 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  * @head:	the head for your list.
  * @member:	the name of the hlist_nulls_node within the struct.
  *
+ * The barrier() is needed to make sure compiler doesn't cache first element [1],
+ * as this loop can be restarted [2]
+ * [1] Documentation/atomic_ops.txt around line 114
+ * [2] Documentation/RCU/rculist_nulls.txt around line 146
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)			\
-	for (pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
+	for (({barrier();}),							\
+	     pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
 		(!is_a_nulls(pos)) &&						\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 9b9b3cb..3c9881f 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -337,6 +337,9 @@ extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec;
 
+/* The __sys_...msg variants allow MSG_CMSG_COMPAT */
+extern long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags);
+extern long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bfc0578..9cf9102 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3613,6 +3613,23 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
 }
 
 /*
+ * When dput() is called asynchronously, if umount has been done and
+ * then deactivate_super() in cgroup_free_fn() kills the superblock,
+ * there's a small window that vfs will see the root dentry with non-zero
+ * refcnt and trigger BUG().
+ *
+ * That's why we hold a reference before dput() and drop it right after.
+ */
+static void cgroup_dput(struct cgroup *cgrp)
+{
+	struct super_block *sb = cgrp->root->sb;
+
+	atomic_inc(&sb->s_active);
+	dput(cgrp->dentry);
+	deactivate_super(sb);
+}
+
+/*
  * Unregister event and free resources.
  *
  * Gets called from workqueue.
@@ -3627,7 +3644,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	dput(cgrp->dentry);
+	cgroup_dput(cgrp);
 }
 
 /*
@@ -3878,12 +3895,8 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
-	struct dentry *dentry = css->cgroup->dentry;
-	struct super_block *sb = dentry->d_sb;
 
-	atomic_inc(&sb->s_active);
-	dput(dentry);
-	deactivate_super(sb);
+	cgroup_dput(css->cgroup);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 44b3539..b1a7801 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -193,9 +193,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
-
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -2855,6 +2852,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -2879,15 +2877,30 @@ static void free_event(struct perf_event *event)
 		if (has_branch_stack(event)) {
 			static_key_slow_dec_deferred(&perf_sched_events);
 			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK))
+			if (!(event->attach_state & PERF_ATTACH_TASK)) {
 				atomic_dec(&per_cpu(perf_branch_stack_events,
 						    event->cpu));
+			}
 		}
 	}
 
 	if (event->rb) {
-		ring_buffer_put(event->rb);
-		event->rb = NULL;
+		struct ring_buffer *rb;
+
+		/*
+		 * Can happen when we close an event with re-directed output.
+		 *
+		 * Since we have a 0 refcount, perf_mmap_close() will skip
+		 * over us; possibly making our ring_buffer_put() the last.
+		 */
+		mutex_lock(&event->mmap_mutex);
+		rb = event->rb;
+		if (rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* could be last */
+		}
+		mutex_unlock(&event->mmap_mutex);
 	}
 
 	if (is_cgroup_event(event))
@@ -3125,30 +3138,13 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	unsigned int events = POLL_HUP;
 
 	/*
-	 * Race between perf_event_set_output() and perf_poll(): perf_poll()
-	 * grabs the rb reference but perf_event_set_output() overrides it.
-	 * Here is the timeline for two threads T1, T2:
-	 * t0: T1, rb = rcu_dereference(event->rb)
-	 * t1: T2, old_rb = event->rb
-	 * t2: T2, event->rb = new rb
-	 * t3: T2, ring_buffer_detach(old_rb)
-	 * t4: T1, ring_buffer_attach(rb1)
-	 * t5: T1, poll_wait(event->waitq)
-	 *
-	 * To avoid this problem, we grab mmap_mutex in perf_poll()
-	 * thereby ensuring that the assignment of the new ring buffer
-	 * and the detachment of the old buffer appear atomic to perf_poll()
+	 * Pin the event->rb by taking event->mmap_mutex; otherwise
+	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
 	 */
 	mutex_lock(&event->mmap_mutex);
-
-	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
-	if (rb) {
-		ring_buffer_attach(event, rb);
+	rb = event->rb;
+	if (rb)
 		events = atomic_xchg(&rb->poll, 0);
-	}
-	rcu_read_unlock();
-
 	mutex_unlock(&event->mmap_mutex);
 
 	poll_wait(file, &event->waitq, wait);
@@ -3464,16 +3460,12 @@ static void ring_buffer_attach(struct perf_event *event,
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	if (!list_empty(&event->rb_entry))
-		goto unlock;
-
-	list_add(&event->rb_entry, &rb->event_list);
-unlock:
+	if (list_empty(&event->rb_entry))
+		list_add(&event->rb_entry, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event,
-			       struct ring_buffer *rb)
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
 	unsigned long flags;
 
@@ -3492,13 +3484,10 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (!rb)
-		goto unlock;
-
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
-		wake_up_all(&event->waitq);
-
-unlock:
+	if (rb) {
+		list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
+			wake_up_all(&event->waitq);
+	}
 	rcu_read_unlock();
 }
 
@@ -3527,18 +3516,10 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 static void ring_buffer_put(struct ring_buffer *rb)
 {
-	struct perf_event *event, *n;
-	unsigned long flags;
-
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
-		list_del_init(&event->rb_entry);
-		wake_up_all(&event->waitq);
-	}
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	WARN_ON_ONCE(!list_empty(&rb->event_list));
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
@@ -3548,26 +3529,100 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	atomic_inc(&event->mmap_count);
+	atomic_inc(&event->rb->mmap_count);
 }
 
+/*
+ * A buffer can be mmap()ed multiple times; either directly through the same
+ * event, or through other events by use of perf_event_set_output().
+ *
+ * In order to undo the VM accounting done by perf_mmap() we need to destroy
+ * the buffer here, where we still have a VM context. This means we need
+ * to detach all events redirecting to us.
+ */
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->rb);
-		struct user_struct *user = event->mmap_user;
-		struct ring_buffer *rb = event->rb;
+	struct ring_buffer *rb = event->rb;
+	struct user_struct *mmap_user = rb->mmap_user;
+	int mmap_locked = rb->mmap_locked;
+	unsigned long size = perf_data_size(rb);
+
+	atomic_dec(&rb->mmap_count);
+
+	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
+		return;
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->rb, NULL);
-		ring_buffer_detach(event, rb);
+	/* Detach current event from the buffer. */
+	rcu_assign_pointer(event->rb, NULL);
+	ring_buffer_detach(event, rb);
+	mutex_unlock(&event->mmap_mutex);
+
+	/* If there's still other mmap()s of this buffer, we're done. */
+	if (atomic_read(&rb->mmap_count)) {
+		ring_buffer_put(rb); /* can't be last */
+		return;
+	}
+
+	/*
+	 * No other mmap()s, detach from all other events that might redirect
+	 * into the now unreachable buffer. Somewhat complicated by the
+	 * fact that rb::event_lock otherwise nests inside mmap_mutex.
+	 */
+again:
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		if (!atomic_long_inc_not_zero(&event->refcount)) {
+			/*
+			 * This event is en-route to free_event() which will
+			 * detach it and remove it from the list.
+			 */
+			continue;
+		}
+		rcu_read_unlock();
+
+		mutex_lock(&event->mmap_mutex);
+		/*
+		 * Check we didn't race with perf_event_set_output() which can
+		 * swizzle the rb from under us while we were waiting to
+		 * acquire mmap_mutex.
+		 *
+		 * If we find a different rb; ignore this event, a next
+		 * iteration will no longer find it on the list. We have to
+		 * still restart the iteration to make sure we're not now
+		 * iterating the wrong list.
+		 */
+		if (event->rb == rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* can't be last, we still have one */
+		}
 		mutex_unlock(&event->mmap_mutex);
+		put_event(event);
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		/*
+		 * Restart the iteration; either we're on the wrong list or
+		 * destroyed its integrity by doing a deletion.
+		 */
+		goto again;
 	}
+	rcu_read_unlock();
+
+	/*
+	 * It could be there's still a few 0-ref events on the list; they'll
+	 * get cleaned up by free_event() -- they'll also still have their
+	 * ref on the rb and will free it whenever they are done with it.
+	 *
+	 * Aside from that, this buffer is 'fully' detached and unmapped,
+	 * undo the VM accounting.
+	 */
+
+	atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+	vma->vm_mm->pinned_vm -= mmap_locked;
+	free_uid(mmap_user);
+
+	ring_buffer_put(rb); /* could be last */
 }
 
 static const struct vm_operations_struct perf_mmap_vmops = {
@@ -3617,12 +3672,24 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
+again:
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages == nr_pages)
-			atomic_inc(&event->rb->refcount);
-		else
+		if (event->rb->nr_pages != nr_pages) {
 			ret = -EINVAL;
+			goto unlock;
+		}
+
+		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+			/*
+			 * Raced against perf_mmap_close() through
+			 * perf_event_set_output(). Try again, hope for better
+			 * luck.
+			 */
+			mutex_unlock(&event->mmap_mutex);
+			goto again;
+		}
+
 		goto unlock;
 	}
 
@@ -3663,12 +3730,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->rb, rb);
+
+	atomic_set(&rb->mmap_count, 1);
+	rb->mmap_locked = extra;
+	rb->mmap_user = get_current_user();
 
 	atomic_long_add(user_extra, &user->locked_vm);
-	event->mmap_locked = extra;
-	event->mmap_user = get_current_user();
-	vma->vm_mm->pinned_vm += event->mmap_locked;
+	vma->vm_mm->pinned_vm += extra;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_update_userpage(event);
 
@@ -3677,7 +3748,11 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_RESERVED;
+	/*
+	 * Since pinned accounting is per vm we cannot allow fork() to copy our
+	 * vma.
+	 */
+	vma->vm_flags |= VM_DONTCOPY | VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
@@ -6191,6 +6266,8 @@ set:
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
 
+	old_rb = event->rb;
+
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb = ring_buffer_get(output_event);
@@ -6198,16 +6275,28 @@ set:
 			goto unlock;
 	}
 
-	old_rb = event->rb;
-	rcu_assign_pointer(event->rb, rb);
 	if (old_rb)
 		ring_buffer_detach(event, old_rb);
+
+	if (rb)
+		ring_buffer_attach(event, rb);
+
+	rcu_assign_pointer(event->rb, rb);
+
+	if (old_rb) {
+		ring_buffer_put(old_rb);
+		/*
+		 * Since we detached before setting the new rb, so that we
+		 * could attach the new rb, we could have missed a wakeup.
+		 * Provide it now.
+		 */
+		wake_up_all(&event->waitq);
+	}
+
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_rb)
-		ring_buffer_put(old_rb);
 out:
 	return ret;
 }
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9a7b487..4f06bf9 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -147,7 +147,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		return;
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -233,7 +233,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index a096c19..3657dfd 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -30,6 +30,10 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	atomic_t			mmap_count;
+	unsigned long			mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..1f71e4d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -60,6 +60,7 @@
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
+#include <linux/hugetlb.h>
 
 #include <asm/futex.h>
 
@@ -363,7 +364,7 @@ again:
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.inode = page_head->mapping->host;
-		key->shared.pgoff = page_head->index;
+		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..50a0a66 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -554,9 +554,9 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 		return 0;
 
 	if (irq_settings_can_request(desc)) {
-		if (desc->action)
-			if (irqflags & desc->action->flags & IRQF_SHARED)
-				canrequest =1;
+		if (!desc->action ||
+		    irqflags & desc->action->flags & IRQF_SHARED)
+			canrequest = 1;
 	}
 	irq_put_desc_unlock(desc, flags);
 	return canrequest;
diff --git a/kernel/timer.c b/kernel/timer.c
index 4cefc08..118237f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -146,9 +146,11 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	/*
+	 * Make sure j is still in the future. Otherwise return the
+	 * unmodified value.
+	 */
+	return time_is_after_jiffies(j) ? j : original;
 }
 
 /**
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7e5ff99..52b15a6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -685,6 +685,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
+pgoff_t __basepage_index(struct page *page)
+{
+	struct page *page_head = compound_head(page);
+	pgoff_t index = page_index(page_head);
+	unsigned long compound_idx;
+
+	if (!PageHuge(page_head))
+		return page_index(page);
+
+	if (compound_order(page_head) >= MAX_ORDER)
+		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
+	else
+		compound_idx = page - page_head;
+
+	return (index << compound_order(page_head)) + compound_idx;
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d2d8f54..74ebc00 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5936,6 +5936,10 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+#ifdef CONFIG_HIGHMEM
+		if (PageHighMem(page))
+			totalhigh_pages -= 1 << order;
+#endif
 		__mod_zone_page_state(zone, NR_FREE_PAGES,
 				      - (1UL << order));
 		for (i = 0; i < (1 << order); i++)
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 38c00f1..bca5c33 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2548,6 +2548,9 @@ static struct sk_buff *l2cap_build_cmd(struct l2cap_conn *conn, u8 code,
 	BT_DBG("conn %p, code 0x%2.2x, ident 0x%2.2x, len %u",
 	       conn, code, ident, dlen);
 
+	if (conn->mtu < L2CAP_HDR_SIZE + L2CAP_CMD_HDR_SIZE)
+		return NULL;
+
 	len = L2CAP_HDR_SIZE + L2CAP_CMD_HDR_SIZE + dlen;
 	count = min_t(unsigned int, conn->mtu, len);
 
diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index 925ca58..8c93fa8 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -39,6 +39,11 @@ static int should_authenticate(struct ceph_auth_client *ac)
 	return xi->starting;
 }
 
+static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
+{
+	return 0;
+}
+
 /*
  * the generic auth code decode the global_id, and we carry no actual
  * authenticate state, so nothing happens here.
@@ -106,6 +111,7 @@ static const struct ceph_auth_client_ops ceph_auth_none_ops = {
 	.destroy = destroy,
 	.is_authenticated = is_authenticated,
 	.should_authenticate = should_authenticate,
+	.build_request = build_request,
 	.handle_reply = handle_reply,
 	.create_authorizer = ceph_auth_none_create_authorizer,
 	.destroy_authorizer = ceph_auth_none_destroy_authorizer,
diff --git a/net/compat.c b/net/compat.c
index 74ed1d7..9c816e8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -735,19 +735,25 @@ static unsigned char nas[21] = {
 
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg, unsigned int flags)
 {
-	return sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned int vlen, unsigned int flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 			      flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg, unsigned int flags)
 {
-	return sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len, unsigned int flags)
@@ -769,6 +775,9 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	int datagrams;
 	struct timespec ktspec;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (COMPAT_USE_64BIT_TIME)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT,
diff --git a/net/core/sock.c b/net/core/sock.c
index be63d03..12e1fb5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -208,7 +208,7 @@ static const char *const af_family_key_strings[AF_MAX+1] = {
   "sk_lock-AF_TIPC"  , "sk_lock-AF_BLUETOOTH", "sk_lock-IUCV"        ,
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
   "sk_lock-AF_IEEE802154", "sk_lock-AF_CAIF" , "sk_lock-AF_ALG"      ,
-  "sk_lock-AF_NFC"   , "sk_lock-AF_MAX"
+  "sk_lock-AF_NFC"   , "sk_lock-AF_VSOCK"    , "sk_lock-AF_MAX"
 };
 static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_UNSPEC", "slock-AF_UNIX"     , "slock-AF_INET"     ,
@@ -224,7 +224,7 @@ static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
   "slock-AF_IEEE802154", "slock-AF_CAIF" , "slock-AF_ALG"      ,
-  "slock-AF_NFC"   , "slock-AF_MAX"
+  "slock-AF_NFC"   , "slock-AF_VSOCK"    ,"slock-AF_MAX"
 };
 static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_UNSPEC", "clock-AF_UNIX"     , "clock-AF_INET"     ,
@@ -240,7 +240,7 @@ static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
   "clock-AF_IEEE802154", "clock-AF_CAIF" , "clock-AF_ALG"      ,
-  "clock-AF_NFC"   , "clock-AF_MAX"
+  "clock-AF_NFC"   , "clock-AF_VSOCK"    , "clock-AF_MAX"
 };
 
 /*
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b062a98..4bdf061 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -756,6 +756,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -899,7 +900,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	skb_reset_transport_header(skb);
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 99af1f0..6cea400 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -481,6 +481,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -563,7 +564,6 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 39de0ca..59781e0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -741,10 +741,15 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 {
 	struct rtable *rt;
 	struct flowi4 fl4;
+	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	int oif = skb->dev->ifindex;
+	u8 tos = RT_TOS(iph->tos);
+	u8 prot = iph->protocol;
+	u32 mark = skb->mark;
 
 	rt = (struct rtable *) dst;
 
-	ip_rt_build_flow_key(&fl4, sk, skb);
+	__build_flow_key(&fl4, sk, iph, oif, tos, prot, mark, 0);
 	__ip_do_redirect(rt, skb, &fl4, true);
 }
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 094a01f..5871c25 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3368,8 +3368,11 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const struct skb_frag_struct *f = &shi->frags[i];
-		struct page *page = skb_frag_page(f);
-		sg_set_page(&sg, page, skb_frag_size(f), f->page_offset);
+		unsigned int offset = f->page_offset;
+		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
+
+		sg_set_page(&sg, page, skb_frag_size(f),
+			    offset_in_page(offset));
 		if (crypto_hash_update(desc, &sg, skb_frag_size(f)))
 			return 1;
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c30a56e..a5080e4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2924,8 +2924,8 @@ static void tcp_enter_recovery(struct sock *sk, bool ece_ack)
  * tcp_xmit_retransmit_queue().
  */
 static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
-				  int prior_sacked, bool is_dupack,
-				  int flag)
+				  int prior_sacked, int prior_packets,
+				  bool is_dupack, int flag)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -2991,7 +2991,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3013,7 +3014,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3632,10 +3634,11 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	bool is_dupack = false;
 	u32 prior_in_flight;
 	u32 prior_fackets;
-	int prior_packets;
+	int prior_packets = tp->packets_out;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
 	bool frto_cwnd = false;
+	int previous_packets_out = 0;
 
 	/* If the ack is older than previous acks
 	 * then we can probably ignore it.
@@ -3714,14 +3717,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	sk->sk_err_soft = 0;
 	icsk->icsk_probes_out = 0;
 	tp->rcv_tstamp = tcp_time_stamp;
-	prior_packets = tp->packets_out;
 	if (!prior_packets)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
+	previous_packets_out = tp->packets_out;
 	flag |= tcp_clean_rtx_queue(sk, prior_fackets, prior_snd_una);
 
-	pkts_acked = prior_packets - tp->packets_out;
+	pkts_acked = previous_packets_out - tp->packets_out;
 
 	if (tp->frto_counter)
 		frto_cwnd = tcp_process_frto(sk, flag);
@@ -3736,7 +3739,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
@@ -3753,7 +3756,7 @@ no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
 	 * it needs to be for normal retransmission.
@@ -3773,7 +3776,7 @@ old_ack:
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	}
 
 	SOCK_DEBUG(sk, "Ack %u before %u:%u\n", ack, tp->snd_una, tp->snd_nxt);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c7f1fe4..755d30f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1023,11 +1023,13 @@ static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
 							   &md5);
 	tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
 
-	if (tcp_packets_in_flight(tp) == 0) {
+	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
-		skb->ooo_okay = 1;
-	} else
-		skb->ooo_okay = 0;
+
+	/* if no packet is in qdisc/device queue, then allow XPS to select
+	 * another queue.
+	 */
+	skb->ooo_okay = sk_wmem_alloc_get(sk) == 0;
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dd8549a..72d9dea 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2430,8 +2430,10 @@ static void init_loopback(struct net_device *dev)
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
 			/* Failure cases are ignored */
-			if (!IS_ERR(sp_rt))
+			if (!IS_ERR(sp_rt)) {
+				sp_ifa->rt = sp_rt;
 				ip6_ins_rt(sp_rt);
+			}
 		}
 		read_unlock_bh(&idev->lock);
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3d485ec..a26d44c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1236,7 +1236,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
 
-			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			np->cork.opt = kzalloc(opt->tot_len, sk->sk_allocation);
 			if (unlikely(np->cork.opt == NULL))
 				return -ENOBUFS;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index e966602..955195c 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -345,19 +345,19 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	skb_put(skb, 2);
 
 	/* Copy user data into skb */
-	error = memcpy_fromiovec(skb->data, m->msg_iov, total_len);
+	error = memcpy_fromiovec(skb_put(skb, total_len), m->msg_iov,
+				 total_len);
 	if (error < 0) {
 		kfree_skb(skb);
 		goto error_put_sess_tun;
 	}
-	skb_put(skb, total_len);
 
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
 	sock_put(sk);
 
-	return error;
+	return total_len;
 
 error_put_sess_tun:
 	sock_put(ps->tunnel_sock);
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index d8d4243..6bb1d42 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -245,6 +245,71 @@ static void netlbl_domhsh_audit_add(struct netlbl_dom_map *entry,
 	}
 }
 
+/**
+ * netlbl_domhsh_validate - Validate a new domain mapping entry
+ * @entry: the entry to validate
+ *
+ * This function validates the new domain mapping entry to ensure that it is
+ * a valid entry.  Returns zero on success, negative values on failure.
+ *
+ */
+static int netlbl_domhsh_validate(const struct netlbl_dom_map *entry)
+{
+	struct netlbl_af4list *iter4;
+	struct netlbl_domaddr4_map *map4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct netlbl_af6list *iter6;
+	struct netlbl_domaddr6_map *map6;
+#endif /* IPv6 */
+
+	if (entry == NULL)
+		return -EINVAL;
+
+	switch (entry->type) {
+	case NETLBL_NLTYPE_UNLABELED:
+		if (entry->type_def.cipsov4 != NULL ||
+		    entry->type_def.addrsel != NULL)
+			return -EINVAL;
+		break;
+	case NETLBL_NLTYPE_CIPSOV4:
+		if (entry->type_def.cipsov4 == NULL)
+			return -EINVAL;
+		break;
+	case NETLBL_NLTYPE_ADDRSELECT:
+		netlbl_af4list_foreach(iter4, &entry->type_def.addrsel->list4) {
+			map4 = netlbl_domhsh_addr4_entry(iter4);
+			switch (map4->type) {
+			case NETLBL_NLTYPE_UNLABELED:
+				if (map4->type_def.cipsov4 != NULL)
+					return -EINVAL;
+				break;
+			case NETLBL_NLTYPE_CIPSOV4:
+				if (map4->type_def.cipsov4 == NULL)
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		netlbl_af6list_foreach(iter6, &entry->type_def.addrsel->list6) {
+			map6 = netlbl_domhsh_addr6_entry(iter6);
+			switch (map6->type) {
+			case NETLBL_NLTYPE_UNLABELED:
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+#endif /* IPv6 */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * Domain Hash Table Functions
  */
@@ -311,6 +376,10 @@ int netlbl_domhsh_add(struct netlbl_dom_map *entry,
 	struct netlbl_af6list *tmp6;
 #endif /* IPv6 */
 
+	ret_val = netlbl_domhsh_validate(entry);
+	if (ret_val != 0)
+		return ret_val;
+
 	/* XXX - we can remove this RCU read lock as the spinlock protects the
 	 *       entire function, but before we do we need to fixup the
 	 *       netlbl_af[4,6]list RCU functions to do "the right thing" with
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 13dee6a..a10ee11 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2848,12 +2848,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 		return -EOPNOTSUPP;
 
 	uaddr->sa_family = AF_PACKET;
+	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strncpy(uaddr->sa_data, dev->name, 14);
-	else
-		memset(uaddr->sa_data, 0, 14);
+		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 	rcu_read_unlock();
 	*uaddr_len = sizeof(*uaddr);
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e0902c9..d06b708 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -205,6 +205,8 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
  */
 void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 {
+	memset(q, 0, sizeof(struct sctp_outq));
+
 	q->asoc = asoc;
 	INIT_LIST_HEAD(&q->out_chunk_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
@@ -212,13 +214,9 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 	INIT_LIST_HEAD(&q->sacked);
 	INIT_LIST_HEAD(&q->abandoned);
 
-	q->fast_rtx = 0;
-	q->outstanding_bytes = 0;
 	q->empty = 1;
-	q->cork  = 0;
 
 	q->malloced = 0;
-	q->out_qlen = 0;
 }
 
 /* Free the outqueue structure and any related pending chunks.
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d32d86d..211acdc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3982,6 +3982,12 @@ SCTP_STATIC void sctp_destroy_sock(struct sock *sk)
 
 	/* Release our hold on the endpoint. */
 	sp = sctp_sk(sk);
+	/* This could happen during socket init, thus we bail out
+	 * early, since the rest of the below is not setup either.
+	 */
+	if (sp->ep == NULL)
+		return;
+
 	if (sp->do_auto_asconf) {
 		sp->do_auto_asconf = 0;
 		list_del(&sp->auto_asconf_list);
diff --git a/net/socket.c b/net/socket.c
index edc3c4a..48557e9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1897,7 +1897,7 @@ struct used_address {
 	unsigned int name_len;
 };
 
-static int __sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags,
 			 struct used_address *used_address)
 {
@@ -2012,22 +2012,30 @@ out:
  *	BSD sendmsg interface
  */
 
-SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, flags)
+long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
-	err = __sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
+	err = ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
 
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
 }
 
+SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, flags)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, msg, flags);
+}
+
 /*
  *	Linux sendmmsg interface
  */
@@ -2058,15 +2066,16 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	while (datagrams < vlen) {
 		if (MSG_CMSG_COMPAT & flags) {
-			err = __sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
+					     &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = __sys_sendmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock,
+					     (struct msghdr __user *)entry,
+					     &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);
@@ -2090,10 +2099,12 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, mmsg, vlen, flags);
 }
 
-static int __sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags, int nosec)
 {
 	struct compat_msghdr __user *msg_compat =
@@ -2185,23 +2196,31 @@ out:
  *	BSD recvmsg interface
  */
 
-SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
-		unsigned int, flags)
+long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
-	err = __sys_recvmsg(sock, msg, &msg_sys, flags, 0);
+	err = ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
 
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
 }
 
+SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
+		unsigned int, flags)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_recvmsg(fd, msg, flags);
+}
+
 /*
  *     Linux recvmmsg interface
  */
@@ -2239,17 +2258,18 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		 * No need to ask LSM for more than the first datagram.
 		 */
 		if (MSG_CMSG_COMPAT & flags) {
-			err = __sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags & ~MSG_WAITFORONE,
-					    datagrams);
+			err = ___sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
+					     &msg_sys, flags & ~MSG_WAITFORONE,
+					     datagrams);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = __sys_recvmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags & ~MSG_WAITFORONE,
-					    datagrams);
+			err = ___sys_recvmsg(sock,
+					     (struct msghdr __user *)entry,
+					     &msg_sys, flags & ~MSG_WAITFORONE,
+					     datagrams);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);
@@ -2316,6 +2336,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 
diff --git a/sound/usb/card.c b/sound/usb/card.c
index aa25e04..51241f4 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -150,14 +150,32 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
 		return -EINVAL;
 	}
 
+	alts = &iface->altsetting[0];
+	altsd = get_iface_desc(alts);
+
+	/*
+	 * Android with both accessory and audio interfaces enabled gets the
+	 * interface numbers wrong.
+	 */
+	if ((chip->usb_id == USB_ID(0x18d1, 0x2d04) ||
+	     chip->usb_id == USB_ID(0x18d1, 0x2d05)) &&
+	    interface == 0 &&
+	    altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC &&
+	    altsd->bInterfaceSubClass == USB_SUBCLASS_VENDOR_SPEC) {
+		interface = 2;
+		iface = usb_ifnum_to_if(dev, interface);
+		if (!iface)
+			return -EINVAL;
+		alts = &iface->altsetting[0];
+		altsd = get_iface_desc(alts);
+	}
+
 	if (usb_interface_claimed(iface)) {
 		snd_printdd(KERN_INFO "%d:%d:%d: skipping, already claimed\n",
 						dev->devnum, ctrlif, interface);
 		return -EINVAL;
 	}
 
-	alts = &iface->altsetting[0];
-	altsd = get_iface_desc(alts);
 	if ((altsd->bInterfaceClass == USB_CLASS_AUDIO ||
 	     altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC) &&
 	    altsd->bInterfaceSubClass == USB_SUBCLASS_MIDISTREAMING) {
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 9a9da0a..5285480 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -841,6 +841,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
+	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
 	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
