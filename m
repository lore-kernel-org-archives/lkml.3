Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaLSN77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:59:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:34399 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaLSN7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:59:55 -0500
Date: Fri, 19 Dec 2014 14:59:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [GIT pull] x86 apic for 3.19
Message-ID: <alpine.DEB.2.11.1412191423560.17382@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

After stopping the full x86/apic branch, I took some time to go
through the first block of patches again, which are mostly cleanups
and preparatory work for the irqdomain conversion and ioapic hotplug
support. Unfortunaly one of the real problematic commits was right at
the beginning, so I rebased this portion of the pending patches
without the offenders.

It would be great to get this into 3.19. That makes reworking the
problematic parts simpler. The usual tip testing did not unearth any
issues and it is fully bisectible now.

I'm pretty confident that this wont affect the calmness of the
xmas season.

Changes:
 - Split the convoluted io_apic.c code into domain specific
   parts (vector, ioapic, msi, htirq)
 - Introduce proper helper functions to retrieve irq specific data
   instead of open coded dereferencing of pointers
 - Preparatory work for ioapic hotplug and irqdomain conversion
 - Removal of the non functional pci-ioapic driver
 - Removal of unused irq entry stubs
 - Make native_smp_prepare_cpus() preemtible to avoid GFP_ATOMIC
   allocations for everything which is called from there.
 - Small cleanups and fixes 

Thanks,

	tglx

------------------>
Jan Beulich (2):
      x86: irq: Fix placement of mp_should_keep_irq()
      x86: Avoid building unused IRQ entry stubs

Jiang Liu (29):
      ACPI: Correct return value of acpi_dev_resource_address_space()
      x86, irq: Provide empty send_cleanup_vector() stub for UP builds
      x86, irq, ACPI: Fix building warning of unused code
      PCI: Remove PCI ioapic driver
      ACPI: Fix minor syntax issues in processor_core.c
      x86, irq: Remove __init marker for functions will be used by IOAPIC hotplug
      x86, irq: Keep balance of IOAPIC pin reference count
      x86, irq: Refine mp_register_ioapic() to prepare for IOAPIC hotplug
      x86, irq, ACPI: Introduce a mutex to protect IOAPIC operations from hotplug
      x86, irq, ACPI: Implement interface to support ACPI based IOAPIC hot-addition
      x86, irq, ACPI: Implement interfaces to support ACPI based IOAPIC hot-removal
      x86, irq: Introduce helper to check whether an IOAPIC has been registered
      x86, irq, acpi: Get rid of special handling of GSI for ACPI SCI
      x86, irq: Kill useless parameter 'irq_attr' of IO_APIC_get_PCI_irq_vector()
      x86, irq: Refine hw_irq.h to prepare for irqdomain support
      x86, irq: Rename local APIC related functions in io_apic.c as apic_xxx()
      x86, irq: Protect __clear_irq_vector() with vector_lock
      x86, irq: Introduce helpers to access struct irq_cfg
      x86, irq: Move local APIC related code from io_apic.c into vector.c
      x86, irq: Replace printk(KERN_LVL) with pr_lvl() utilities
      x86, irq: Move PCI MSI related code from io_apic.c into msi.c
      x86, irq: Move HT IRQ related code from io_apic.c into htirq.c
      x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
      x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
      x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
      x86, irq: Use helpers to access irq_cfg data structure associated with IRQ
      x86: irq_remapping: Use helpers to access irq_cfg data structure associated with IRQ
      iommu/vt-d: Use helpers to access irq_cfg data structure associated with IRQ
      iommu/amd: Use helpers to access irq_cfg data structure associated with IRQ

Thomas Gleixner (2):
      x86, smpboot: Remove pointless preempt_disable() in native_smp_prepare_cpus()
      x86, irq: Make UP version of irq_complete_move() an inline stub

Yinghai Lu (3):
      x86, irq: Split out alloc_ioapic_save_registers()
      x86, irq: Prefer assigned ID in APIC ID register for x86_64
      x86, irq: Convert irq_2_pin list to generic list


 arch/x86/Kconfig                    |    6 +-
 arch/x86/include/asm/hw_irq.h       |   84 +--
 arch/x86/include/asm/io_apic.h      |   35 +-
 arch/x86/include/asm/irq_vectors.h  |    6 +
 arch/x86/include/asm/pci.h          |    3 +
 arch/x86/include/asm/pci_x86.h      |    2 +
 arch/x86/kernel/acpi/boot.c         |   99 ++-
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/apic.c         |   22 +-
 arch/x86/kernel/apic/htirq.c        |  107 +++
 arch/x86/kernel/apic/io_apic.c      | 1368 +++++++----------------------------
 arch/x86/kernel/apic/msi.c          |  286 ++++++++
 arch/x86/kernel/apic/vector.c       |  719 ++++++++++++++++++
 arch/x86/kernel/crash.c             |    1 +
 arch/x86/kernel/entry_32.S          |    4 +-
 arch/x86/kernel/entry_64.S          |    4 +-
 arch/x86/kernel/irqinit.c           |   35 +-
 arch/x86/kernel/machine_kexec_32.c  |    1 +
 arch/x86/kernel/machine_kexec_64.c  |    1 +
 arch/x86/kernel/reboot.c            |    1 +
 arch/x86/kernel/smpboot.c           |    8 +-
 arch/x86/lguest/boot.c              |    2 +-
 arch/x86/pci/intel_mid_pci.c        |   10 +-
 arch/x86/pci/irq.c                  |   25 +-
 arch/x86/platform/uv/uv_irq.c       |    6 +-
 drivers/acpi/pci_irq.c              |   11 +-
 drivers/acpi/pci_root.c             |   16 +-
 drivers/acpi/processor_core.c       |    9 +-
 drivers/acpi/resource.c             |    2 +-
 drivers/iommu/amd_iommu.c           |   14 +-
 drivers/iommu/dmar.c                |  532 +++++++++++---
 drivers/iommu/intel-iommu.c         |  299 ++++++--
 drivers/iommu/intel_irq_remapping.c |  259 +++++--
 drivers/iommu/irq_remapping.c       |    6 +-
 drivers/pci/Kconfig                 |    9 +-
 drivers/pci/Makefile                |    2 -
 drivers/pci/hotplug/ibmphp_core.c   |    6 +-
 drivers/pci/ioapic.c                |  121 ----
 include/linux/acpi.h                |    1 +
 include/linux/dmar.h                |   50 +-
 include/linux/pci.h                 |    1 +
 41 files changed, 2512 insertions(+), 1665 deletions(-)
 create mode 100644 arch/x86/kernel/apic/htirq.c
 create mode 100644 arch/x86/kernel/apic/msi.c
 create mode 100644 arch/x86/kernel/apic/vector.c
 delete mode 100644 drivers/pci/ioapic.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bea3a0159496..a39b7e5e95b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -886,11 +886,11 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
+	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 
 config X86_IO_APIC
-	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
-	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+	def_bool X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
+	depends on X86_LOCAL_APIC
 	select IRQ_DOMAIN
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 4615906d83df..9662290e0b20 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -94,30 +94,7 @@ extern void trace_call_function_single_interrupt(void);
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
 #endif /* CONFIG_TRACING */
 
-/* IOAPIC */
-#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
-extern unsigned long io_apic_irqs;
-
-extern void setup_IO_APIC(void);
-extern void disable_IO_APIC(void);
-
-struct io_apic_irq_attr {
-	int ioapic;
-	int ioapic_pin;
-	int trigger;
-	int polarity;
-};
-
-static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
-					int ioapic, int ioapic_pin,
-					int trigger, int polarity)
-{
-	irq_attr->ioapic	= ioapic;
-	irq_attr->ioapic_pin	= ioapic_pin;
-	irq_attr->trigger	= trigger;
-	irq_attr->polarity	= polarity;
-}
-
+#ifdef CONFIG_IRQ_REMAP
 /* Intel specific interrupt remapping information */
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
@@ -131,14 +108,12 @@ struct irq_2_irte {
 	u16 devid; /* Device ID for IRTE table */
 	u16 index; /* Index into IRTE table*/
 };
+#endif	/* CONFIG_IRQ_REMAP */
+
+#ifdef	CONFIG_X86_LOCAL_APIC
+struct irq_data;
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * Most irqs are mapped 1:1 with pins.
- */
 struct irq_cfg {
-	struct irq_pin_list	*irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
 	u8			vector;
@@ -150,18 +125,39 @@ struct irq_cfg {
 		struct irq_2_irte  irq_2_irte;
 	};
 #endif
+	union {
+#ifdef CONFIG_X86_IO_APIC
+		struct {
+			struct list_head	irq_2_pin;
+		};
+#endif
+	};
 };
 
+extern struct irq_cfg *irq_cfg(unsigned int irq);
+extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
+extern struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
+extern void lock_vector_lock(void);
+extern void unlock_vector_lock(void);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
+extern void clear_irq_vector(int irq, struct irq_cfg *cfg);
+extern void setup_vector_irq(int cpu);
+#ifdef CONFIG_SMP
 extern void send_cleanup_vector(struct irq_cfg *);
+extern void irq_complete_move(struct irq_cfg *cfg);
+#else
+static inline void send_cleanup_vector(struct irq_cfg *c) { }
+static inline void irq_complete_move(struct irq_cfg *c) { }
+#endif
 
-struct irq_data;
-int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
-			  unsigned int *dest_id);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
-extern void setup_ioapic_dest(void);
-
-extern void enable_IO_APIC(void);
+extern int apic_retrigger_irq(struct irq_data *data);
+extern void apic_ack_edge(struct irq_data *data);
+extern int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			     unsigned int *dest_id);
+#else	/*  CONFIG_X86_LOCAL_APIC */
+static inline void lock_vector_lock(void) {}
+static inline void unlock_vector_lock(void) {}
+#endif	/* CONFIG_X86_LOCAL_APIC */
 
 /* Statistics */
 extern atomic_t irq_err_count;
@@ -185,7 +181,8 @@ extern __visible void smp_call_function_single_interrupt(struct pt_regs *);
 extern __visible void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
-extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
+extern void (*__initconst interrupt[FIRST_SYSTEM_VECTOR
+				    - FIRST_EXTERNAL_VECTOR])(void);
 #ifdef CONFIG_TRACING
 #define trace_interrupt interrupt
 #endif
@@ -195,17 +192,6 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern void setup_vector_irq(int cpu);
-
-#ifdef CONFIG_X86_IO_APIC
-extern void lock_vector_lock(void);
-extern void unlock_vector_lock(void);
-extern void __setup_vector_irq(int cpu);
-#else
-static inline void lock_vector_lock(void) {}
-static inline void unlock_vector_lock(void) {}
-static inline void __setup_vector_irq(int cpu) {}
-#endif
 
 #endif /* !ASSEMBLY_ */
 
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1733ab49ac5e..bf006cce9418 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -132,6 +132,10 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
+extern unsigned long io_apic_irqs;
+
+#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
+
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
@@ -139,18 +143,15 @@ extern int noioapicreroute;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-struct io_apic_irq_attr;
 struct irq_cfg;
 extern void ioapic_insert_resources(void);
+extern int arch_early_ioapic_init(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
 				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
-extern void native_compose_msi_msg(struct pci_dev *pdev,
-				   unsigned int irq, unsigned int dest,
-				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
 
 extern int save_ioapic_entries(void);
@@ -160,6 +161,13 @@ extern int restore_ioapic_entries(void);
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
+struct io_apic_irq_attr {
+	int ioapic;
+	int ioapic_pin;
+	int trigger;
+	int polarity;
+};
+
 enum ioapic_domain_type {
 	IOAPIC_DOMAIN_INVALID,
 	IOAPIC_DOMAIN_LEGACY,
@@ -188,8 +196,10 @@ extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void mp_unmap_irq(int irq);
-extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-				      struct ioapic_domain_cfg *cfg);
+extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			      struct ioapic_domain_cfg *cfg);
+extern int mp_unregister_ioapic(u32 gsi_base);
+extern int mp_ioapic_registered(u32 gsi_base);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
@@ -227,19 +237,25 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
+extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
+extern void disable_IO_APIC(void);
+extern void setup_ioapic_dest(void);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
+extern void print_IO_APICs(void);
 #else  /* !CONFIG_X86_IO_APIC */
 
+#define IO_APIC_IRQ(x)		0
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static inline void ioapic_insert_resources(void) { }
+static inline int arch_early_ioapic_init(void) { return 0; }
+static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 static inline void mp_unmap_irq(int irq) { }
-static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
 static inline int save_ioapic_entries(void)
 {
@@ -262,7 +278,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
-#define native_compose_msi_msg		NULL
 #define native_eoi_ioapic_pin		NULL
 #endif
 
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 5702d7e3111d..666c89ec4bd7 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -126,6 +126,12 @@
 
 #define NR_VECTORS			 256
 
+#ifdef CONFIG_X86_LOCAL_APIC
+#define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
+#else
+#define FIRST_SYSTEM_VECTOR		NR_VECTORS
+#endif
+
 #define FPU_IRQ				  13
 
 #define	FIRST_VM86_IRQ			   3
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 0892ea0e683f..4e370a5d8117 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,12 +96,15 @@ extern void pci_iommu_alloc(void);
 #ifdef CONFIG_PCI_MSI
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
+void native_compose_msi_msg(struct pci_dev *pdev, unsigned int irq,
+			    unsigned int dest, struct msi_msg *msg, u8 hpet_id);
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev);
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 		  unsigned int irq_base, unsigned int irq_offset);
 #else
+#define native_compose_msi_msg		NULL
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
 #endif
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index fa1195dae425..164e3f8d3c3d 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -93,6 +93,8 @@ extern raw_spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
+extern bool mp_should_keep_irq(struct device *dev);
+
 struct pci_raw_ops {
 	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a142e77693e1..4433a4be8171 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -76,6 +76,19 @@ int acpi_fix_pin2_polarity __initdata;
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #endif
 
+/*
+ * Locks related to IOAPIC hotplug
+ * Hotplug side:
+ *	->device_hotplug_lock
+ *		->acpi_ioapic_lock
+ *			->ioapic_lock
+ * Interrupt mapping side:
+ *	->acpi_ioapic_lock
+ *		->ioapic_mutex
+ *			->ioapic_lock
+ */
+static DEFINE_MUTEX(acpi_ioapic_lock);
+
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -395,10 +408,6 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
 
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
-
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
 	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
@@ -411,7 +420,8 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (irq < 0)
 		return irq;
 
-	if (enable_update_mptable)
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (enable_update_mptable && acpi_gbl_FADT.sci_interrupt != gsi)
 		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
 	return irq;
@@ -424,9 +434,6 @@ static void mp_unregister_gsi(u32 gsi)
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return;
 
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return;
-
 	irq = mp_map_gsi_to_irq(gsi, 0);
 	if (irq > 0)
 		mp_unmap_irq(irq);
@@ -609,8 +616,10 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
 		*irqp = gsi;
 	} else {
+		mutex_lock(&acpi_ioapic_lock);
 		irq = mp_map_gsi_to_irq(gsi,
 					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		mutex_unlock(&acpi_ioapic_lock);
 		if (irq < 0)
 			return -1;
 		*irqp = irq;
@@ -650,7 +659,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	int irq = gsi;
 
 #ifdef CONFIG_X86_IO_APIC
+	mutex_lock(&acpi_ioapic_lock);
 	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	mutex_unlock(&acpi_ioapic_lock);
 #endif
 
 	return irq;
@@ -659,7 +670,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	mutex_lock(&acpi_ioapic_lock);
 	mp_unregister_gsi(gsi);
+	mutex_unlock(&acpi_ioapic_lock);
 #endif
 }
 
@@ -690,6 +703,7 @@ void acpi_unregister_gsi(u32 gsi)
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
@@ -697,6 +711,7 @@ static void __init acpi_set_irq_model_ioapic(void)
 	__acpi_unregister_gsi = acpi_unregister_gsi_ioapic;
 	acpi_ioapic = 1;
 }
+#endif
 
 /*
  *  ACPI based hotplug support for CPU
@@ -759,20 +774,74 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
-}
+	int ret = -ENOSYS;
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+	int ioapic_id;
+	u64 addr;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &acpi_irqdomain_ops,
+	};
+
+	ioapic_id = acpi_get_ioapic_id(handle, gsi_base, &addr);
+	if (ioapic_id < 0) {
+		unsigned long long uid;
+		acpi_status status;
 
+		status = acpi_evaluate_integer(handle, METHOD_NAME__UID,
+					       NULL, &uid);
+		if (ACPI_FAILURE(status)) {
+			acpi_handle_warn(handle, "failed to get IOAPIC ID.\n");
+			return -EINVAL;
+		}
+		ioapic_id = (int)uid;
+	}
+
+	mutex_lock(&acpi_ioapic_lock);
+	ret  = mp_register_ioapic(ioapic_id, phys_addr, gsi_base, &cfg);
+	mutex_unlock(&acpi_ioapic_lock);
+#endif
+
+	return ret;
+}
 EXPORT_SYMBOL(acpi_register_ioapic);
 
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
-}
+	int ret = -ENOSYS;
 
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+	mutex_lock(&acpi_ioapic_lock);
+	ret  = mp_unregister_ioapic(gsi_base);
+	mutex_unlock(&acpi_ioapic_lock);
+#endif
+
+	return ret;
+}
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
+/**
+ * acpi_ioapic_registered - Check whether IOAPIC assoicatied with @gsi_base
+ *			    has been registered
+ * @handle:	ACPI handle of the IOAPIC deivce
+ * @gsi_base:	GSI base associated with the IOAPIC
+ *
+ * Assume caller holds some type of lock to serialize acpi_ioapic_registered()
+ * with acpi_register_ioapic()/acpi_unregister_ioapic().
+ */
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base)
+{
+	int ret = 0;
+
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+	mutex_lock(&acpi_ioapic_lock);
+	ret  = mp_ioapic_registered(gsi_base);
+	mutex_unlock(&acpi_ioapic_lock);
+#endif
+
+	return ret;
+}
+
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
 {
 	struct acpi_table_boot *sb;
@@ -1185,7 +1254,9 @@ static void __init acpi_process_madt(void)
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
+			mutex_lock(&acpi_ioapic_lock);
 			error = acpi_parse_madt_ioapic_entries();
+			mutex_unlock(&acpi_ioapic_lock);
 			if (!error) {
 				acpi_set_irq_model_ioapic();
 
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index dcb5b15401ce..8bb12ddc5db8 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,10 +2,12 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o vector.o
 obj-y				+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
+obj-$(CONFIG_PCI_MSI)		+= msi.o
+obj-$(CONFIG_HT_IRQ)		+= htirq.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ba6cc041edb1..29b5b18afa27 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -196,7 +196,7 @@ static int disable_apic_timer __initdata;
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
-int first_system_vector = 0xfe;
+int first_system_vector = FIRST_SYSTEM_VECTOR;
 
 /*
  * Debug level, exported for io_apic.c
@@ -1930,7 +1930,7 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-static inline void __smp_spurious_interrupt(void)
+static inline void __smp_spurious_interrupt(u8 vector)
 {
 	u32 v;
 
@@ -1939,30 +1939,32 @@ static inline void __smp_spurious_interrupt(void)
 	 * if it is a vectored one.  Just in case...
 	 * Spurious interrupts should not be ACKed.
 	 */
-	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
-	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
+	v = apic_read(APIC_ISR + ((vector & ~0x1f) >> 1));
+	if (v & (1 << (vector & 0x1f)))
 		ack_APIC_irq();
 
 	inc_irq_stat(irq_spurious_count);
 
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	pr_info("spurious APIC interrupt on CPU#%d, "
-		"should never happen.\n", smp_processor_id());
+	pr_info("spurious APIC interrupt through vector %02x on CPU#%d, "
+		"should never happen.\n", vector, smp_processor_id());
 }
 
 __visible void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
-	__smp_spurious_interrupt();
+	__smp_spurious_interrupt(~regs->orig_ax);
 	exiting_irq();
 }
 
 __visible void smp_trace_spurious_interrupt(struct pt_regs *regs)
 {
+	u8 vector = ~regs->orig_ax;
+
 	entering_irq();
-	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
-	__smp_spurious_interrupt();
-	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
+	trace_spurious_apic_entry(vector);
+	__smp_spurious_interrupt(vector);
+	trace_spurious_apic_exit(vector);
 	exiting_irq();
 }
 
diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
new file mode 100644
index 000000000000..816f36e979ad
--- /dev/null
+++ b/arch/x86/kernel/apic/htirq.c
@@ -0,0 +1,107 @@
+/*
+ * Support Hypertransport IRQ
+ *
+ * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
+ *	Moved from arch/x86/kernel/apic/io_apic.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/htirq.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/hypertransport.h>
+
+/*
+ * Hypertransport interrupt support
+ */
+static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+{
+	struct ht_irq_msg msg;
+
+	fetch_ht_irq_msg(irq, &msg);
+
+	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
+	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
+
+	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
+	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
+
+	write_ht_irq_msg(irq, &msg);
+}
+
+static int
+ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+	unsigned int dest;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	target_ht_irq(data->irq, dest, cfg->vector);
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+static struct irq_chip ht_irq_chip = {
+	.name			= "PCI-HT",
+	.irq_mask		= mask_ht_irq,
+	.irq_unmask		= unmask_ht_irq,
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= ht_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
+{
+	struct irq_cfg *cfg;
+	struct ht_irq_msg msg;
+	unsigned dest;
+	int err;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	cfg = irq_cfg(irq);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
+
+	msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
+
+	msg.address_lo =
+		HT_IRQ_LOW_BASE |
+		HT_IRQ_LOW_DEST_ID(dest) |
+		HT_IRQ_LOW_VECTOR(cfg->vector) |
+		((apic->irq_dest_mode == 0) ?
+			HT_IRQ_LOW_DM_PHYSICAL :
+			HT_IRQ_LOW_DM_LOGICAL) |
+		HT_IRQ_LOW_RQEOI_EDGE |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			HT_IRQ_LOW_MT_FIXED :
+			HT_IRQ_LOW_MT_ARBITRATED) |
+		HT_IRQ_LOW_IRQ_MASKED;
+
+	write_ht_irq_msg(irq, &msg);
+
+	irq_set_chip_and_handler_name(irq, &ht_irq_chip,
+				      handle_edge_irq, "edge");
+
+	dev_dbg(&dev->dev, "irq %d for HT\n", irq);
+
+	return 0;
+}
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7ffe0a2b870f..3f5f60406ab1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -32,15 +32,11 @@
 #include <linux/module.h>
 #include <linux/syscore_ops.h>
 #include <linux/irqdomain.h>
-#include <linux/msi.h>
-#include <linux/htirq.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
 #include <linux/bootmem.h>
-#include <linux/dmar.h>
-#include <linux/hpet.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -52,17 +48,12 @@
 #include <asm/dma.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
-#include <asm/msidef.h>
-#include <asm/hypertransport.h>
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
-#include <asm/hpet.h>
 #include <asm/hw_irq.h>
 
 #include <asm/apic.h>
 
-#define __apicdebuginit(type) static type __init
-
 #define	for_each_ioapic(idx)		\
 	for ((idx) = 0; (idx) < nr_ioapics; (idx)++)
 #define	for_each_ioapic_reverse(idx)	\
@@ -74,7 +65,7 @@
 		for_each_pin((idx), (pin))
 
 #define for_each_irq_pin(entry, head) \
-	for (entry = head; entry; entry = entry->next)
+	list_for_each_entry(entry, &head, list)
 
 /*
  *      Is the SiS APIC rmw bug present ?
@@ -83,7 +74,6 @@
 int sis_apic_bug = -1;
 
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
-static DEFINE_RAW_SPINLOCK(vector_lock);
 static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
 static int ioapic_initialized;
@@ -112,6 +102,7 @@ static struct ioapic {
 	struct ioapic_domain_cfg irqdomain_cfg;
 	struct irq_domain *irqdomain;
 	struct mp_pin_info *pin_info;
+	struct resource *iomem_res;
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
@@ -205,8 +196,6 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
-
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
 {
@@ -228,8 +217,8 @@ void mp_save_irq(struct mpc_intsrc *m)
 }
 
 struct irq_pin_list {
+	struct list_head list;
 	int apic, pin;
-	struct irq_pin_list *next;
 };
 
 static struct irq_pin_list *alloc_irq_pin_list(int node)
@@ -237,7 +226,26 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
-int __init arch_early_irq_init(void)
+static void alloc_ioapic_saved_registers(int idx)
+{
+	size_t size;
+
+	if (ioapics[idx].saved_registers)
+		return;
+
+	size = sizeof(struct IO_APIC_route_entry) * ioapics[idx].nr_registers;
+	ioapics[idx].saved_registers = kzalloc(size, GFP_KERNEL);
+	if (!ioapics[idx].saved_registers)
+		pr_err("IOAPIC %d: suspend/resume impossible!\n", idx);
+}
+
+static void free_ioapic_saved_registers(int idx)
+{
+	kfree(ioapics[idx].saved_registers);
+	ioapics[idx].saved_registers = NULL;
+}
+
+int __init arch_early_ioapic_init(void)
 {
 	struct irq_cfg *cfg;
 	int i, node = cpu_to_node(0);
@@ -245,13 +253,8 @@ int __init arch_early_irq_init(void)
 	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
 
-	for_each_ioapic(i) {
-		ioapics[i].saved_registers =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				ioapics[i].nr_registers, GFP_KERNEL);
-		if (!ioapics[i].saved_registers)
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
+	for_each_ioapic(i)
+		alloc_ioapic_saved_registers(i);
 
 	/*
 	 * For legacy IRQ's, start with assigning irq0 to irq15 to
@@ -266,61 +269,6 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-static inline struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irq_get_chip_data(irq);
-}
-
-static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
-{
-	struct irq_cfg *cfg;
-
-	cfg = kzalloc_node(sizeof(*cfg), GFP_KERNEL, node);
-	if (!cfg)
-		return NULL;
-	if (!zalloc_cpumask_var_node(&cfg->domain, GFP_KERNEL, node))
-		goto out_cfg;
-	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
-		goto out_domain;
-	return cfg;
-out_domain:
-	free_cpumask_var(cfg->domain);
-out_cfg:
-	kfree(cfg);
-	return NULL;
-}
-
-static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
-{
-	if (!cfg)
-		return;
-	irq_set_chip_data(at, NULL);
-	free_cpumask_var(cfg->domain);
-	free_cpumask_var(cfg->old_domain);
-	kfree(cfg);
-}
-
-static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
-{
-	int res = irq_alloc_desc_at(at, node);
-	struct irq_cfg *cfg;
-
-	if (res < 0) {
-		if (res != -EEXIST)
-			return NULL;
-		cfg = irq_cfg(at);
-		if (cfg)
-			return cfg;
-	}
-
-	cfg = alloc_irq_cfg(at, node);
-	if (cfg)
-		irq_set_chip_data(at, cfg);
-	else
-		irq_free_desc(at);
-	return cfg;
-}
-
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -445,15 +393,12 @@ static void ioapic_mask_entry(int apic, int pin)
  */
 static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	struct irq_pin_list **last, *entry;
+	struct irq_pin_list *entry;
 
 	/* don't allow duplicates */
-	last = &cfg->irq_2_pin;
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
+	for_each_irq_pin(entry, cfg->irq_2_pin)
 		if (entry->apic == apic && entry->pin == pin)
 			return 0;
-		last = &entry->next;
-	}
 
 	entry = alloc_irq_pin_list(node);
 	if (!entry) {
@@ -464,22 +409,19 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
 	entry->apic = apic;
 	entry->pin = pin;
 
-	*last = entry;
+	list_add_tail(&entry->list, &cfg->irq_2_pin);
 	return 0;
 }
 
 static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
 {
-	struct irq_pin_list **last, *entry;
+	struct irq_pin_list *tmp, *entry;
 
-	last = &cfg->irq_2_pin;
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	list_for_each_entry_safe(entry, tmp, &cfg->irq_2_pin, list)
 		if (entry->apic == apic && entry->pin == pin) {
-			*last = entry->next;
+			list_del(&entry->list);
 			kfree(entry);
 			return;
-		} else {
-			last = &entry->next;
 		}
 }
 
@@ -559,7 +501,7 @@ static void mask_ioapic(struct irq_cfg *cfg)
 
 static void mask_ioapic_irq(struct irq_data *data)
 {
-	mask_ioapic(data->chip_data);
+	mask_ioapic(irqd_cfg(data));
 }
 
 static void __unmask_ioapic(struct irq_cfg *cfg)
@@ -578,7 +520,7 @@ static void unmask_ioapic(struct irq_cfg *cfg)
 
 static void unmask_ioapic_irq(struct irq_data *data)
 {
-	unmask_ioapic(data->chip_data);
+	unmask_ioapic(irqd_cfg(data));
 }
 
 /*
@@ -1164,8 +1106,7 @@ void mp_unmap_irq(int irq)
  * Find a specific PCI IRQ entry.
  * Not an __init, possibly needed by modules
  */
-int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
-				struct io_apic_irq_attr *irq_attr)
+int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 {
 	int irq, i, best_ioapic = -1, best_idx = -1;
 
@@ -1219,195 +1160,11 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 		return -1;
 
 out:
-	irq = pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
-			IOAPIC_MAP_ALLOC);
-	if (irq > 0)
-		set_io_apic_irq_attr(irq_attr, best_ioapic,
-				     mp_irqs[best_idx].dstirq,
-				     irq_trigger(best_idx),
-				     irq_polarity(best_idx));
-	return irq;
+	return pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
+			 IOAPIC_MAP_ALLOC);
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
-void lock_vector_lock(void)
-{
-	/* Used to the online set of cpus does not change
-	 * during assign_irq_vector.
-	 */
-	raw_spin_lock(&vector_lock);
-}
-
-void unlock_vector_lock(void)
-{
-	raw_spin_unlock(&vector_lock);
-}
-
-static int
-__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
-{
-	/*
-	 * NOTE! The local APIC isn't very good at handling
-	 * multiple interrupts at the same interrupt level.
-	 * As the interrupt level is determined by taking the
-	 * vector number and shifting that right by 4, we
-	 * want to spread these out a bit so that they don't
-	 * all fall in the same interrupt level.
-	 *
-	 * Also, we've got to be careful not to trash gate
-	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
-	 */
-	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
-	static int current_offset = VECTOR_OFFSET_START % 16;
-	int cpu, err;
-	cpumask_var_t tmp_mask;
-
-	if (cfg->move_in_progress)
-		return -EBUSY;
-
-	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
-		return -ENOMEM;
-
-	/* Only try and allocate irqs on cpus that are present */
-	err = -ENOSPC;
-	cpumask_clear(cfg->old_domain);
-	cpu = cpumask_first_and(mask, cpu_online_mask);
-	while (cpu < nr_cpu_ids) {
-		int new_cpu, vector, offset;
-
-		apic->vector_allocation_domain(cpu, tmp_mask, mask);
-
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
-			err = 0;
-			if (cpumask_equal(tmp_mask, cfg->domain))
-				break;
-			/*
-			 * New cpumask using the vector is a proper subset of
-			 * the current in use mask. So cleanup the vector
-			 * allocation for the members that are not used anymore.
-			 */
-			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
-			cfg->move_in_progress =
-			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
-			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
-			break;
-		}
-
-		vector = current_vector;
-		offset = current_offset;
-next:
-		vector += 16;
-		if (vector >= first_system_vector) {
-			offset = (offset + 1) % 16;
-			vector = FIRST_EXTERNAL_VECTOR + offset;
-		}
-
-		if (unlikely(current_vector == vector)) {
-			cpumask_or(cfg->old_domain, cfg->old_domain, tmp_mask);
-			cpumask_andnot(tmp_mask, mask, cfg->old_domain);
-			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
-			continue;
-		}
-
-		if (test_bit(vector, used_vectors))
-			goto next;
-
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
-			if (per_cpu(vector_irq, new_cpu)[vector] > VECTOR_UNDEFINED)
-				goto next;
-		}
-		/* Found one! */
-		current_vector = vector;
-		current_offset = offset;
-		if (cfg->vector) {
-			cpumask_copy(cfg->old_domain, cfg->domain);
-			cfg->move_in_progress =
-			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
-		}
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			per_cpu(vector_irq, new_cpu)[vector] = irq;
-		cfg->vector = vector;
-		cpumask_copy(cfg->domain, tmp_mask);
-		err = 0;
-		break;
-	}
-	free_cpumask_var(tmp_mask);
-	return err;
-}
-
-int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
-{
-	int err;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-	return err;
-}
-
-static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
-{
-	int cpu, vector;
-
-	BUG_ON(!cfg->vector);
-
-	vector = cfg->vector;
-	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
-		per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
-
-	cfg->vector = 0;
-	cpumask_clear(cfg->domain);
-
-	if (likely(!cfg->move_in_progress))
-		return;
-	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-			if (per_cpu(vector_irq, cpu)[vector] != irq)
-				continue;
-			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
-			break;
-		}
-	}
-	cfg->move_in_progress = 0;
-}
-
-void __setup_vector_irq(int cpu)
-{
-	/* Initialize vector_irq on a new cpu */
-	int irq, vector;
-	struct irq_cfg *cfg;
-
-	/*
-	 * vector_lock will make sure that we don't run into irq vector
-	 * assignments that might be happening on another cpu in parallel,
-	 * while we setup our initial vector to irq mappings.
-	 */
-	raw_spin_lock(&vector_lock);
-	/* Mark the inuse vectors */
-	for_each_active_irq(irq) {
-		cfg = irq_cfg(irq);
-		if (!cfg)
-			continue;
-
-		if (!cpumask_test_cpu(cpu, cfg->domain))
-			continue;
-		vector = cfg->vector;
-		per_cpu(vector_irq, cpu)[vector] = irq;
-	}
-	/* Mark the free vectors */
-	for (vector = 0; vector < NR_VECTORS; ++vector) {
-		irq = per_cpu(vector_irq, cpu)[vector];
-		if (irq <= VECTOR_UNDEFINED)
-			continue;
-
-		cfg = irq_cfg(irq);
-		if (!cpumask_test_cpu(cpu, cfg->domain))
-			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
-	}
-	raw_spin_unlock(&vector_lock);
-}
-
 static struct irq_chip ioapic_chip;
 
 #ifdef CONFIG_X86_32
@@ -1496,7 +1253,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 					 &dest)) {
 		pr_warn("Failed to obtain apicid for ioapic %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		__clear_irq_vector(irq, cfg);
+		clear_irq_vector(irq, cfg);
 
 		return;
 	}
@@ -1510,7 +1267,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (x86_io_apic_ops.setup_entry(irq, &entry, dest, cfg->vector, attr)) {
 		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		__clear_irq_vector(irq, cfg);
+		clear_irq_vector(irq, cfg);
 
 		return;
 	}
@@ -1641,7 +1398,7 @@ void ioapic_zap_locks(void)
 	raw_spin_lock_init(&ioapic_lock);
 }
 
-__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
+static void __init print_IO_APIC(int ioapic_idx)
 {
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
@@ -1698,7 +1455,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 	x86_io_apic_ops.print_entries(ioapic_idx, reg_01.bits.entries);
 }
 
-__apicdebuginit(void) print_IO_APICs(void)
+void __init print_IO_APICs(void)
 {
 	int ioapic_idx;
 	struct irq_cfg *cfg;
@@ -1731,8 +1488,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
-		entry = cfg->irq_2_pin;
-		if (!entry)
+		if (list_empty(&cfg->irq_2_pin))
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
 		for_each_irq_pin(entry, cfg->irq_2_pin)
@@ -1743,205 +1499,6 @@ __apicdebuginit(void) print_IO_APICs(void)
 	printk(KERN_INFO ".................................... done.\n");
 }
 
-__apicdebuginit(void) print_APIC_field(int base)
-{
-	int i;
-
-	printk(KERN_DEBUG);
-
-	for (i = 0; i < 8; i++)
-		pr_cont("%08x", apic_read(base + i*0x10));
-
-	pr_cont("\n");
-}
-
-__apicdebuginit(void) print_local_APIC(void *dummy)
-{
-	unsigned int i, v, ver, maxlvt;
-	u64 icr;
-
-	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
-		smp_processor_id(), hard_smp_processor_id());
-	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
-	v = apic_read(APIC_LVR);
-	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
-	ver = GET_APIC_VERSION(v);
-	maxlvt = lapic_get_maxlvt();
-
-	v = apic_read(APIC_TASKPRI);
-	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
-
-	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
-		if (!APIC_XAPIC(ver)) {
-			v = apic_read(APIC_ARBPRI);
-			printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
-			       v & APIC_ARBPRI_MASK);
-		}
-		v = apic_read(APIC_PROCPRI);
-		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
-	}
-
-	/*
-	 * Remote read supported only in the 82489DX and local APIC for
-	 * Pentium processors.
-	 */
-	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
-		v = apic_read(APIC_RRR);
-		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
-	}
-
-	v = apic_read(APIC_LDR);
-	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
-	if (!x2apic_enabled()) {
-		v = apic_read(APIC_DFR);
-		printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
-	}
-	v = apic_read(APIC_SPIV);
-	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
-
-	printk(KERN_DEBUG "... APIC ISR field:\n");
-	print_APIC_field(APIC_ISR);
-	printk(KERN_DEBUG "... APIC TMR field:\n");
-	print_APIC_field(APIC_TMR);
-	printk(KERN_DEBUG "... APIC IRR field:\n");
-	print_APIC_field(APIC_IRR);
-
-	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
-		if (maxlvt > 3)         /* Due to the Pentium erratum 3AP. */
-			apic_write(APIC_ESR, 0);
-
-		v = apic_read(APIC_ESR);
-		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
-	}
-
-	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
-
-	v = apic_read(APIC_LVTT);
-	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
-
-	if (maxlvt > 3) {                       /* PC is LVT#4. */
-		v = apic_read(APIC_LVTPC);
-		printk(KERN_DEBUG "... APIC LVTPC: %08x\n", v);
-	}
-	v = apic_read(APIC_LVT0);
-	printk(KERN_DEBUG "... APIC LVT0: %08x\n", v);
-	v = apic_read(APIC_LVT1);
-	printk(KERN_DEBUG "... APIC LVT1: %08x\n", v);
-
-	if (maxlvt > 2) {			/* ERR is LVT#3. */
-		v = apic_read(APIC_LVTERR);
-		printk(KERN_DEBUG "... APIC LVTERR: %08x\n", v);
-	}
-
-	v = apic_read(APIC_TMICT);
-	printk(KERN_DEBUG "... APIC TMICT: %08x\n", v);
-	v = apic_read(APIC_TMCCT);
-	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
-	v = apic_read(APIC_TDCR);
-	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
-
-	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
-		v = apic_read(APIC_EFEAT);
-		maxlvt = (v >> 16) & 0xff;
-		printk(KERN_DEBUG "... APIC EFEAT: %08x\n", v);
-		v = apic_read(APIC_ECTRL);
-		printk(KERN_DEBUG "... APIC ECTRL: %08x\n", v);
-		for (i = 0; i < maxlvt; i++) {
-			v = apic_read(APIC_EILVTn(i));
-			printk(KERN_DEBUG "... APIC EILVT%d: %08x\n", i, v);
-		}
-	}
-	pr_cont("\n");
-}
-
-__apicdebuginit(void) print_local_APICs(int maxcpu)
-{
-	int cpu;
-
-	if (!maxcpu)
-		return;
-
-	preempt_disable();
-	for_each_online_cpu(cpu) {
-		if (cpu >= maxcpu)
-			break;
-		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
-	}
-	preempt_enable();
-}
-
-__apicdebuginit(void) print_PIC(void)
-{
-	unsigned int v;
-	unsigned long flags;
-
-	if (!nr_legacy_irqs())
-		return;
-
-	printk(KERN_DEBUG "\nprinting PIC contents\n");
-
-	raw_spin_lock_irqsave(&i8259A_lock, flags);
-
-	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
-
-	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
-
-	outb(0x0b,0xa0);
-	outb(0x0b,0x20);
-	v = inb(0xa0) << 8 | inb(0x20);
-	outb(0x0a,0xa0);
-	outb(0x0a,0x20);
-
-	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
-
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
-
-	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
-}
-
-static int __initdata show_lapic = 1;
-static __init int setup_show_lapic(char *arg)
-{
-	int num = -1;
-
-	if (strcmp(arg, "all") == 0) {
-		show_lapic = CONFIG_NR_CPUS;
-	} else {
-		get_option(&arg, &num);
-		if (num >= 0)
-			show_lapic = num;
-	}
-
-	return 1;
-}
-__setup("show_lapic=", setup_show_lapic);
-
-__apicdebuginit(int) print_ICs(void)
-{
-	if (apic_verbosity == APIC_QUIET)
-		return 0;
-
-	print_PIC();
-
-	/* don't print out if apic is not there */
-	if (!cpu_has_apic && !apic_from_smp_config())
-		return 0;
-
-	print_local_APICs(show_lapic);
-	print_IO_APICs();
-
-	return 0;
-}
-
-late_initcall(print_ICs);
-
-
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
@@ -2244,26 +1801,12 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
-	__unmask_ioapic(data->chip_data);
+	__unmask_ioapic(irqd_cfg(data));
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(struct irq_data *data)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned long flags;
-	int cpu;
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	cpu = cpumask_first_and(cfg->domain, cpu_online_mask);
-	apic->send_IPI_mask(cpumask_of(cpu), cfg->vector);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-
-	return 1;
-}
-
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
  * so we use two separate IRQ descriptors. Edge triggered IRQs can be
@@ -2273,113 +1816,6 @@ static int ioapic_retrigger_irq(struct irq_data *data)
  * races.
  */
 
-#ifdef CONFIG_SMP
-void send_cleanup_vector(struct irq_cfg *cfg)
-{
-	cpumask_var_t cleanup_mask;
-
-	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
-		unsigned int i;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
-	} else {
-		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		free_cpumask_var(cleanup_mask);
-	}
-	cfg->move_in_progress = 0;
-}
-
-asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
-{
-	unsigned vector, me;
-
-	ack_APIC_irq();
-	irq_enter();
-	exit_idle();
-
-	me = smp_processor_id();
-	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		int irq;
-		unsigned int irr;
-		struct irq_desc *desc;
-		struct irq_cfg *cfg;
-		irq = __this_cpu_read(vector_irq[vector]);
-
-		if (irq <= VECTOR_UNDEFINED)
-			continue;
-
-		desc = irq_to_desc(irq);
-		if (!desc)
-			continue;
-
-		cfg = irq_cfg(irq);
-		if (!cfg)
-			continue;
-
-		raw_spin_lock(&desc->lock);
-
-		/*
-		 * Check if the irq migration is in progress. If so, we
-		 * haven't received the cleanup request yet for this irq.
-		 */
-		if (cfg->move_in_progress)
-			goto unlock;
-
-		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
-			goto unlock;
-
-		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
-		/*
-		 * Check if the vector that needs to be cleanedup is
-		 * registered at the cpu's IRR. If so, then this is not
-		 * the best time to clean it up. Lets clean it up in the
-		 * next attempt by sending another IRQ_MOVE_CLEANUP_VECTOR
-		 * to myself.
-		 */
-		if (irr  & (1 << (vector % 32))) {
-			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
-			goto unlock;
-		}
-		__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
-unlock:
-		raw_spin_unlock(&desc->lock);
-	}
-
-	irq_exit();
-}
-
-static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
-{
-	unsigned me;
-
-	if (likely(!cfg->move_in_progress))
-		return;
-
-	me = smp_processor_id();
-
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
-		send_cleanup_vector(cfg);
-}
-
-static void irq_complete_move(struct irq_cfg *cfg)
-{
-	__irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
-}
-
-void irq_force_complete_move(int irq)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	if (!cfg)
-		return;
-
-	__irq_complete_move(cfg, cfg->vector);
-}
-#else
-static inline void irq_complete_move(struct irq_cfg *cfg) { }
-#endif
-
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
 {
 	int apic, pin;
@@ -2400,71 +1836,29 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	}
 }
 
-/*
- * Either sets data->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
- * leaves data->affinity untouched.
- */
-int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			  unsigned int *dest_id)
+int native_ioapic_set_affinity(struct irq_data *data,
+			       const struct cpumask *mask,
+			       bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int irq = data->irq;
-	int err;
-
-	if (!config_enabled(CONFIG_SMP))
-		return -EPERM;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -EINVAL;
-
-	err = assign_irq_vector(irq, cfg, mask);
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(mask, cfg->domain, dest_id);
-	if (err) {
-		if (assign_irq_vector(irq, cfg, data->affinity))
-			pr_err("Failed to recover vector for irq %d\n", irq);
-		return err;
-	}
-
-	cpumask_copy(data->affinity, mask);
-
-	return 0;
-}
-
-
-int native_ioapic_set_affinity(struct irq_data *data,
-			       const struct cpumask *mask,
-			       bool force)
-{
-	unsigned int dest, irq = data->irq;
-	unsigned long flags;
-	int ret;
+	unsigned int dest, irq = data->irq;
+	unsigned long flags;
+	int ret;
 
 	if (!config_enabled(CONFIG_SMP))
 		return -EPERM;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, data->chip_data);
+		__target_IO_APIC_irq(irq, dest, irqd_cfg(data));
 		ret = IRQ_SET_MASK_OK_NOCOPY;
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return ret;
 }
 
-static void ack_apic_edge(struct irq_data *data)
-{
-	irq_complete_move(data->chip_data);
-	irq_move_irq(data);
-	ack_APIC_irq();
-}
-
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -2547,9 +1941,9 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 }
 #endif
 
-static void ack_apic_level(struct irq_data *data)
+static void ack_ioapic_level(struct irq_data *data)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	int i, irq = data->irq;
 	unsigned long v;
 	bool masked;
@@ -2619,10 +2013,10 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_startup		= startup_ioapic_irq,
 	.irq_mask		= mask_ioapic_irq,
 	.irq_unmask		= unmask_ioapic_irq,
-	.irq_ack		= ack_apic_edge,
-	.irq_eoi		= ack_apic_level,
+	.irq_ack		= apic_ack_edge,
+	.irq_eoi		= ack_ioapic_level,
 	.irq_set_affinity	= native_ioapic_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -2965,6 +2359,16 @@ static int mp_irqdomain_create(int ioapic)
 	return 0;
 }
 
+static void ioapic_destroy_irqdomain(int idx)
+{
+	if (ioapics[idx].irqdomain) {
+		irq_domain_remove(ioapics[idx].irqdomain);
+		ioapics[idx].irqdomain = NULL;
+	}
+	kfree(ioapics[idx].pin_info);
+	ioapics[idx].pin_info = NULL;
+}
+
 void __init setup_IO_APIC(void)
 {
 	int ioapic;
@@ -3044,399 +2448,6 @@ static int __init ioapic_init_ops(void)
 
 device_initcall(ioapic_init_ops);
 
-/*
- * Dynamic irq allocate and deallocation. Should be replaced by irq domains!
- */
-int arch_setup_hwirq(unsigned int irq, int node)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	int ret;
-
-	cfg = alloc_irq_cfg(irq, node);
-	if (!cfg)
-		return -ENOMEM;
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	ret = __assign_irq_vector(irq, cfg, apic->target_cpus());
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-
-	if (!ret)
-		irq_set_chip_data(irq, cfg);
-	else
-		free_irq_cfg(irq, cfg);
-	return ret;
-}
-
-void arch_teardown_hwirq(unsigned int irq)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-	unsigned long flags;
-
-	free_remapped_irq(irq);
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, cfg);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-	free_irq_cfg(irq, cfg);
-}
-
-/*
- * MSI message composition
- */
-void native_compose_msi_msg(struct pci_dev *pdev,
-			    unsigned int irq, unsigned int dest,
-			    struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	msg->address_hi = MSI_ADDR_BASE_HI;
-
-	if (x2apic_enabled())
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
-
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		((apic->irq_dest_mode == 0) ?
-			MSI_ADDR_DEST_MODE_PHYSICAL:
-			MSI_ADDR_DEST_MODE_LOGICAL) |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_ADDR_REDIRECTION_CPU:
-			MSI_ADDR_REDIRECTION_LOWPRI) |
-		MSI_ADDR_DEST_ID(dest);
-
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_DATA_DELIVERY_FIXED:
-			MSI_DATA_DELIVERY_LOWPRI) |
-		MSI_DATA_VECTOR(cfg->vector);
-}
-
-#ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg;
-	int err;
-	unsigned dest;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-
-	return 0;
-}
-
-static int
-msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	struct msi_msg msg;
-	unsigned int dest;
-	int ret;
-
-	ret = __ioapic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	__get_cached_msi_msg(data->msi_desc, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
-
-	__pci_write_msi_msg(data->msi_desc, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-/*
- * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
- * which implement the MSI or MSI-X Capability Structure.
- */
-static struct irq_chip msi_chip = {
-	.name			= "PCI-MSI",
-	.irq_unmask		= pci_msi_unmask_irq,
-	.irq_mask		= pci_msi_mask_irq,
-	.irq_ack		= ack_apic_edge,
-	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-		  unsigned int irq_base, unsigned int irq_offset)
-{
-	struct irq_chip *chip = &msi_chip;
-	struct msi_msg msg;
-	unsigned int irq = irq_base + irq_offset;
-	int ret;
-
-	ret = msi_compose_msg(dev, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
-
-	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
-
-	/*
-	 * MSI-X message is written per-IRQ, the offset is always 0.
-	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
-	 */
-	if (!irq_offset)
-		pci_write_msi_msg(irq, &msg);
-
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
-
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
-
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
-
-	return 0;
-}
-
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-{
-	struct msi_desc *msidesc;
-	unsigned int irq;
-	int node, ret;
-
-	/* Multiple MSI vectors only supported with interrupt remapping */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
-
-	node = dev_to_node(&dev->dev);
-
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_alloc_hwirq(node);
-		if (!irq)
-			return -ENOSPC;
-
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0) {
-			irq_free_hwirq(irq);
-			return ret;
-		}
-
-	}
-	return 0;
-}
-
-void native_teardown_msi_irq(unsigned int irq)
-{
-	irq_free_hwirq(irq);
-}
-
-#ifdef CONFIG_DMAR_TABLE
-static int
-dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		      bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest, irq = data->irq;
-	struct msi_msg msg;
-	int ret;
-
-	ret = __ioapic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	dmar_msi_read(irq, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
-	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
-
-	dmar_msi_write(irq, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-static struct irq_chip dmar_msi_type = {
-	.name			= "DMAR_MSI",
-	.irq_unmask		= dmar_msi_unmask,
-	.irq_mask		= dmar_msi_mask,
-	.irq_ack		= ack_apic_edge,
-	.irq_set_affinity	= dmar_msi_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
-int arch_setup_dmar_msi(unsigned int irq)
-{
-	int ret;
-	struct msi_msg msg;
-
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
-	dmar_msi_write(irq, &msg);
-	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
-				      "edge");
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_HPET_TIMER
-
-static int hpet_msi_set_affinity(struct irq_data *data,
-				 const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	struct msi_msg msg;
-	unsigned int dest;
-	int ret;
-
-	ret = __ioapic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	hpet_msi_read(data->handler_data, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
-
-	hpet_msi_write(data->handler_data, &msg);
-
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-static struct irq_chip hpet_msi_type = {
-	.name = "HPET_MSI",
-	.irq_unmask = hpet_msi_unmask,
-	.irq_mask = hpet_msi_mask,
-	.irq_ack = ack_apic_edge,
-	.irq_set_affinity = hpet_msi_set_affinity,
-	.irq_retrigger = ioapic_retrigger_irq,
-	.flags = IRQCHIP_SKIP_SET_WAKE,
-};
-
-int default_setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	struct irq_chip *chip = &hpet_msi_type;
-	struct msi_msg msg;
-	int ret;
-
-	ret = msi_compose_msg(NULL, irq, &msg, id);
-	if (ret < 0)
-		return ret;
-
-	hpet_msi_write(irq_get_handler_data(irq), &msg);
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
-
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
-	return 0;
-}
-#endif
-
-#endif /* CONFIG_PCI_MSI */
-/*
- * Hypertransport interrupt support
- */
-#ifdef CONFIG_HT_IRQ
-
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
-{
-	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
-
-	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
-	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
-
-	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
-	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
-
-	write_ht_irq_msg(irq, &msg);
-}
-
-static int
-ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest;
-	int ret;
-
-	ret = __ioapic_set_affinity(data, mask, &dest);
-	if (ret)
-		return ret;
-
-	target_ht_irq(data->irq, dest, cfg->vector);
-	return IRQ_SET_MASK_OK_NOCOPY;
-}
-
-static struct irq_chip ht_irq_chip = {
-	.name			= "PCI-HT",
-	.irq_mask		= mask_ht_irq,
-	.irq_unmask		= unmask_ht_irq,
-	.irq_ack		= ack_apic_edge,
-	.irq_set_affinity	= ht_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
-};
-
-int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
-{
-	struct irq_cfg *cfg;
-	struct ht_irq_msg msg;
-	unsigned dest;
-	int err;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
-
-	msg.address_lo =
-		HT_IRQ_LOW_BASE |
-		HT_IRQ_LOW_DEST_ID(dest) |
-		HT_IRQ_LOW_VECTOR(cfg->vector) |
-		((apic->irq_dest_mode == 0) ?
-			HT_IRQ_LOW_DM_PHYSICAL :
-			HT_IRQ_LOW_DM_LOGICAL) |
-		HT_IRQ_LOW_RQEOI_EDGE |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			HT_IRQ_LOW_MT_FIXED :
-			HT_IRQ_LOW_MT_ARBITRATED) |
-		HT_IRQ_LOW_IRQ_MASKED;
-
-	write_ht_irq_msg(irq, &msg);
-
-	irq_set_chip_and_handler_name(irq, &ht_irq_chip,
-				      handle_edge_irq, "edge");
-
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
-
-	return 0;
-}
-#endif /* CONFIG_HT_IRQ */
-
 static int
 io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 {
@@ -3451,7 +2462,7 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-static int __init io_apic_get_redir_entries(int ioapic)
+static int io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3476,28 +2487,8 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
 	return ioapic_initialized ? ioapic_dynirq_base : gsi_top;
 }
 
-int __init arch_probe_nr_irqs(void)
-{
-	int nr;
-
-	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
-		nr_irqs = NR_VECTORS * nr_cpu_ids;
-
-	nr = (gsi_top + nr_legacy_irqs()) + 8 * nr_cpu_ids;
-#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
-	/*
-	 * for MSI and HT dyn irq
-	 */
-	nr += gsi_top * 16;
-#endif
-	if (nr < nr_irqs)
-		nr_irqs = nr;
-
-	return 0;
-}
-
 #ifdef CONFIG_X86_32
-static int __init io_apic_get_unique_id(int ioapic, int apic_id)
+static int io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -3572,30 +2563,63 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	return apic_id;
 }
 
-static u8 __init io_apic_unique_id(u8 id)
+static u8 io_apic_unique_id(int idx, u8 id)
 {
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return io_apic_get_unique_id(nr_ioapics, id);
+		return io_apic_get_unique_id(idx, id);
 	else
 		return id;
 }
 #else
-static u8 __init io_apic_unique_id(u8 id)
+static u8 io_apic_unique_id(int idx, u8 id)
 {
-	int i;
+	union IO_APIC_reg_00 reg_00;
 	DECLARE_BITMAP(used, 256);
+	unsigned long flags;
+	u8 new_id;
+	int i;
 
 	bitmap_zero(used, 256);
 	for_each_ioapic(i)
 		__set_bit(mpc_ioapic_id(i), used);
+
+	/* Hand out the requested id if available */
 	if (!test_bit(id, used))
 		return id;
-	return find_first_zero_bit(used, 256);
+
+	/*
+	 * Read the current id from the ioapic and keep it if
+	 * available.
+	 */
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	reg_00.raw = io_apic_read(idx, 0);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+	new_id = reg_00.bits.ID;
+	if (!test_bit(new_id, used)) {
+		apic_printk(APIC_VERBOSE, KERN_INFO
+			"IOAPIC[%d]: Using reg apic_id %d instead of %d\n",
+			 idx, new_id, id);
+		return new_id;
+	}
+
+	/*
+	 * Get the next free id and write it to the ioapic.
+	 */
+	new_id = find_first_zero_bit(used, 256);
+	reg_00.bits.ID = new_id;
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	io_apic_write(idx, 0, reg_00.raw);
+	reg_00.raw = io_apic_read(idx, 0);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+	/* Sanity check */
+	BUG_ON(reg_00.bits.ID != new_id);
+
+	return new_id;
 }
 #endif
 
-static int __init io_apic_get_version(int ioapic)
+static int io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3702,6 +2726,7 @@ static struct resource * __init ioapic_setup_resources(void)
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
 		num++;
+		ioapics[i].iomem_res = res;
 	}
 
 	ioapic_resources = res;
@@ -3799,21 +2824,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
-			MAX_IO_APICS, nr_ioapics);
-		return 1;
-	}
-	if (!address) {
-		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
-}
-
-static __init int bad_ioapic_register(int idx)
+static int bad_ioapic_register(int idx)
 {
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
@@ -3832,32 +2843,61 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			       struct ioapic_domain_cfg *cfg)
+static int find_free_ioapic_entry(void)
 {
-	int idx = 0;
-	int entries;
+	int idx;
+
+	for (idx = 0; idx < MAX_IO_APICS; idx++)
+		if (ioapics[idx].nr_registers == 0)
+			return idx;
+
+	return MAX_IO_APICS;
+}
+
+/**
+ * mp_register_ioapic - Register an IOAPIC device
+ * @id:		hardware IOAPIC ID
+ * @address:	physical address of IOAPIC register area
+ * @gsi_base:	base of GSI associated with the IOAPIC
+ * @cfg:	configuration information for the IOAPIC
+ */
+int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+		       struct ioapic_domain_cfg *cfg)
+{
+	bool hotplug = !!ioapic_initialized;
 	struct mp_ioapic_gsi *gsi_cfg;
+	int idx, ioapic, entries;
+	u32 gsi_end;
 
-	if (bad_ioapic(address))
-		return;
+	if (!address) {
+		pr_warn("Bogus (zero) I/O APIC address found, skipping!\n");
+		return -EINVAL;
+	}
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].mp_config.apicaddr == address) {
+			pr_warn("address 0x%x conflicts with IOAPIC%d\n",
+				address, ioapic);
+			return -EEXIST;
+		}
 
-	idx = nr_ioapics;
+	idx = find_free_ioapic_entry();
+	if (idx >= MAX_IO_APICS) {
+		pr_warn("Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
+			MAX_IO_APICS, idx);
+		return -ENOSPC;
+	}
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
-	ioapics[idx].irqdomain = NULL;
-	ioapics[idx].irqdomain_cfg = *cfg;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-
 	if (bad_ioapic_register(idx)) {
 		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
+		return -ENODEV;
 	}
 
-	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
+	ioapics[idx].mp_config.apicid = io_apic_unique_id(idx, id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
 	/*
@@ -3865,24 +2905,112 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
+	gsi_end = gsi_base + entries - 1;
+	for_each_ioapic(ioapic) {
+		gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+		if ((gsi_base >= gsi_cfg->gsi_base &&
+		     gsi_base <= gsi_cfg->gsi_end) ||
+		    (gsi_end >= gsi_cfg->gsi_base &&
+		     gsi_end <= gsi_cfg->gsi_end)) {
+			pr_warn("GSI range [%u-%u] for new IOAPIC conflicts with GSI[%u-%u]\n",
+				gsi_base, gsi_end,
+				gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+			return -ENOSPC;
+		}
+	}
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
-	gsi_cfg->gsi_end = gsi_base + entries - 1;
+	gsi_cfg->gsi_end = gsi_end;
+
+	ioapics[idx].irqdomain = NULL;
+	ioapics[idx].irqdomain_cfg = *cfg;
 
 	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
+	 * If mp_register_ioapic() is called during early boot stage when
+	 * walking ACPI/SFI/DT tables, it's too early to create irqdomain,
+	 * we are still using bootmem allocator. So delay it to setup_IO_APIC().
 	 */
-	ioapics[idx].nr_registers = entries;
+	if (hotplug) {
+		if (mp_irqdomain_create(idx)) {
+			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+			return -ENOMEM;
+		}
+		alloc_ioapic_saved_registers(idx);
+	}
 
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
+	if (nr_ioapics <= idx)
+		nr_ioapics = idx + 1;
+
+	/* Set nr_registers to mark entry present */
+	ioapics[idx].nr_registers = entries;
 
 	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
 		idx, mpc_ioapic_id(idx),
 		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
-	nr_ioapics++;
+	return 0;
+}
+
+int mp_unregister_ioapic(u32 gsi_base)
+{
+	int ioapic, pin;
+	int found = 0;
+	struct mp_pin_info *pin_info;
+
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].gsi_config.gsi_base == gsi_base) {
+			found = 1;
+			break;
+		}
+	if (!found) {
+		pr_warn("can't find IOAPIC for GSI %d\n", gsi_base);
+		return -ENODEV;
+	}
+
+	for_each_pin(ioapic, pin) {
+		pin_info = mp_pin_info(ioapic, pin);
+		if (pin_info->count) {
+			pr_warn("pin%d on IOAPIC%d is still in use.\n",
+				pin, ioapic);
+			return -EBUSY;
+		}
+	}
+
+	/* Mark entry not present */
+	ioapics[ioapic].nr_registers  = 0;
+	ioapic_destroy_irqdomain(ioapic);
+	free_ioapic_saved_registers(ioapic);
+	if (ioapics[ioapic].iomem_res)
+		release_resource(ioapics[ioapic].iomem_res);
+	clear_fixmap(FIX_IO_APIC_BASE_0 + ioapic);
+	memset(&ioapics[ioapic], 0, sizeof(ioapics[ioapic]));
+
+	return 0;
+}
+
+int mp_ioapic_registered(u32 gsi_base)
+{
+	int ioapic;
+
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].gsi_config.gsi_base == gsi_base)
+			return 1;
+
+	return 0;
+}
+
+static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
+					int ioapic, int ioapic_pin,
+					int trigger, int polarity)
+{
+	irq_attr->ioapic	= ioapic;
+	irq_attr->ioapic_pin	= ioapic_pin;
+	irq_attr->trigger	= trigger;
+	irq_attr->polarity	= polarity;
 }
 
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
@@ -3931,7 +3059,7 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 
 	ioapic_mask_entry(ioapic, pin);
 	__remove_pin_from_irq(cfg, ioapic, pin);
-	WARN_ON(cfg->irq_2_pin != NULL);
+	WARN_ON(!list_empty(&cfg->irq_2_pin));
 	arch_teardown_hwirq(virq);
 }
 
@@ -3964,18 +3092,6 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 	return ret;
 }
 
-bool mp_should_keep_irq(struct device *dev)
-{
-	if (dev->power.is_prepared)
-		return true;
-#ifdef	CONFIG_PM_RUNTIME
-	if (dev->power.runtime_status == RPM_SUSPENDING)
-		return true;
-#endif
-
-	return false;
-}
-
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
new file mode 100644
index 000000000000..d6ba2d660dc5
--- /dev/null
+++ b/arch/x86/kernel/apic/msi.c
@@ -0,0 +1,286 @@
+/*
+ * Support of MSI, HPET and DMAR interrupts.
+ *
+ * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
+ *	Moved from arch/x86/kernel/apic/io_apic.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/dmar.h>
+#include <linux/hpet.h>
+#include <linux/msi.h>
+#include <asm/msidef.h>
+#include <asm/hpet.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/irq_remapping.h>
+
+void native_compose_msi_msg(struct pci_dev *pdev,
+			    unsigned int irq, unsigned int dest,
+			    struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg = irq_cfg(irq);
+
+	msg->address_hi = MSI_ADDR_BASE_HI;
+
+	if (x2apic_enabled())
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
+
+	msg->address_lo =
+		MSI_ADDR_BASE_LO |
+		((apic->irq_dest_mode == 0) ?
+			MSI_ADDR_DEST_MODE_PHYSICAL :
+			MSI_ADDR_DEST_MODE_LOGICAL) |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_ADDR_REDIRECTION_CPU :
+			MSI_ADDR_REDIRECTION_LOWPRI) |
+		MSI_ADDR_DEST_ID(dest);
+
+	msg->data =
+		MSI_DATA_TRIGGER_EDGE |
+		MSI_DATA_LEVEL_ASSERT |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_DATA_DELIVERY_FIXED :
+			MSI_DATA_DELIVERY_LOWPRI) |
+		MSI_DATA_VECTOR(cfg->vector);
+}
+
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+			   struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg;
+	int err;
+	unsigned dest;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	cfg = irq_cfg(irq);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
+
+	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+
+	return 0;
+}
+
+static int
+msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+	struct msi_msg msg;
+	unsigned int dest;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	__get_cached_msi_msg(data->msi_desc, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	__pci_write_msi_msg(data->msi_desc, &msg);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+/*
+ * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
+ * which implement the MSI or MSI-X Capability Structure.
+ */
+static struct irq_chip msi_chip = {
+	.name			= "PCI-MSI",
+	.irq_unmask		= pci_msi_unmask_irq,
+	.irq_mask		= pci_msi_mask_irq,
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= msi_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+		  unsigned int irq_base, unsigned int irq_offset)
+{
+	struct irq_chip *chip = &msi_chip;
+	struct msi_msg msg;
+	unsigned int irq = irq_base + irq_offset;
+	int ret;
+
+	ret = msi_compose_msg(dev, irq, &msg, -1);
+	if (ret < 0)
+		return ret;
+
+	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
+
+	/*
+	 * MSI-X message is written per-IRQ, the offset is always 0.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (!irq_offset)
+		pci_write_msi_msg(irq, &msg);
+
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
+
+	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
+
+	dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", irq);
+
+	return 0;
+}
+
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_desc *msidesc;
+	unsigned int irq;
+	int node, ret;
+
+	/* Multiple MSI vectors only supported with interrupt remapping */
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
+	node = dev_to_node(&dev->dev);
+
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = irq_alloc_hwirq(node);
+		if (!irq)
+			return -ENOSPC;
+
+		ret = setup_msi_irq(dev, msidesc, irq, 0);
+		if (ret < 0) {
+			irq_free_hwirq(irq);
+			return ret;
+		}
+
+	}
+	return 0;
+}
+
+void native_teardown_msi_irq(unsigned int irq)
+{
+	irq_free_hwirq(irq);
+}
+
+#ifdef CONFIG_DMAR_TABLE
+static int
+dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      bool force)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+	unsigned int dest, irq = data->irq;
+	struct msi_msg msg;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	dmar_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
+
+	dmar_msi_write(irq, &msg);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+static struct irq_chip dmar_msi_type = {
+	.name			= "DMAR_MSI",
+	.irq_unmask		= dmar_msi_unmask,
+	.irq_mask		= dmar_msi_mask,
+	.irq_ack		= apic_ack_edge,
+	.irq_set_affinity	= dmar_msi_set_affinity,
+	.irq_retrigger		= apic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+int arch_setup_dmar_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg, -1);
+	if (ret < 0)
+		return ret;
+	dmar_msi_write(irq, &msg);
+	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+				      "edge");
+	return 0;
+}
+#endif
+
+/*
+ * MSI message composition
+ */
+#ifdef CONFIG_HPET_TIMER
+
+static int hpet_msi_set_affinity(struct irq_data *data,
+				 const struct cpumask *mask, bool force)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+	struct msi_msg msg;
+	unsigned int dest;
+	int ret;
+
+	ret = apic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
+
+	hpet_msi_read(data->handler_data, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	hpet_msi_write(data->handler_data, &msg);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
+}
+
+static struct irq_chip hpet_msi_type = {
+	.name = "HPET_MSI",
+	.irq_unmask = hpet_msi_unmask,
+	.irq_mask = hpet_msi_mask,
+	.irq_ack = apic_ack_edge,
+	.irq_set_affinity = hpet_msi_set_affinity,
+	.irq_retrigger = apic_retrigger_irq,
+	.flags = IRQCHIP_SKIP_SET_WAKE,
+};
+
+int default_setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct irq_chip *chip = &hpet_msi_type;
+	struct msi_msg msg;
+	int ret;
+
+	ret = msi_compose_msg(NULL, irq, &msg, id);
+	if (ret < 0)
+		return ret;
+
+	hpet_msi_write(irq_get_handler_data(irq), &msg);
+	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
+
+	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
+	return 0;
+}
+#endif
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
new file mode 100644
index 000000000000..6cedd7914581
--- /dev/null
+++ b/arch/x86/kernel/apic/vector.c
@@ -0,0 +1,719 @@
+/*
+ * Local APIC related interfaces to support IOAPIC, MSI, HT_IRQ etc.
+ *
+ * Copyright (C) 1997, 1998, 1999, 2000, 2009 Ingo Molnar, Hajnalka Szabo
+ *	Moved from arch/x86/kernel/apic/io_apic.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/compiler.h>
+#include <linux/irqdomain.h>
+#include <linux/slab.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/i8259.h>
+#include <asm/desc.h>
+#include <asm/irq_remapping.h>
+
+static DEFINE_RAW_SPINLOCK(vector_lock);
+
+void lock_vector_lock(void)
+{
+	/* Used to the online set of cpus does not change
+	 * during assign_irq_vector.
+	 */
+	raw_spin_lock(&vector_lock);
+}
+
+void unlock_vector_lock(void)
+{
+	raw_spin_unlock(&vector_lock);
+}
+
+struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	return irq_get_chip_data(irq);
+}
+
+struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
+{
+	return irq_data->chip_data;
+}
+
+static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
+{
+	struct irq_cfg *cfg;
+
+	cfg = kzalloc_node(sizeof(*cfg), GFP_KERNEL, node);
+	if (!cfg)
+		return NULL;
+	if (!zalloc_cpumask_var_node(&cfg->domain, GFP_KERNEL, node))
+		goto out_cfg;
+	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
+		goto out_domain;
+#ifdef	CONFIG_X86_IO_APIC
+	INIT_LIST_HEAD(&cfg->irq_2_pin);
+#endif
+	return cfg;
+out_domain:
+	free_cpumask_var(cfg->domain);
+out_cfg:
+	kfree(cfg);
+	return NULL;
+}
+
+struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
+{
+	int res = irq_alloc_desc_at(at, node);
+	struct irq_cfg *cfg;
+
+	if (res < 0) {
+		if (res != -EEXIST)
+			return NULL;
+		cfg = irq_cfg(at);
+		if (cfg)
+			return cfg;
+	}
+
+	cfg = alloc_irq_cfg(at, node);
+	if (cfg)
+		irq_set_chip_data(at, cfg);
+	else
+		irq_free_desc(at);
+	return cfg;
+}
+
+static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
+{
+	if (!cfg)
+		return;
+	irq_set_chip_data(at, NULL);
+	free_cpumask_var(cfg->domain);
+	free_cpumask_var(cfg->old_domain);
+	kfree(cfg);
+}
+
+static int
+__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+{
+	/*
+	 * NOTE! The local APIC isn't very good at handling
+	 * multiple interrupts at the same interrupt level.
+	 * As the interrupt level is determined by taking the
+	 * vector number and shifting that right by 4, we
+	 * want to spread these out a bit so that they don't
+	 * all fall in the same interrupt level.
+	 *
+	 * Also, we've got to be careful not to trash gate
+	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
+	 */
+	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
+	static int current_offset = VECTOR_OFFSET_START % 16;
+	int cpu, err;
+	cpumask_var_t tmp_mask;
+
+	if (cfg->move_in_progress)
+		return -EBUSY;
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
+	/* Only try and allocate irqs on cpus that are present */
+	err = -ENOSPC;
+	cpumask_clear(cfg->old_domain);
+	cpu = cpumask_first_and(mask, cpu_online_mask);
+	while (cpu < nr_cpu_ids) {
+		int new_cpu, vector, offset;
+
+		apic->vector_allocation_domain(cpu, tmp_mask, mask);
+
+		if (cpumask_subset(tmp_mask, cfg->domain)) {
+			err = 0;
+			if (cpumask_equal(tmp_mask, cfg->domain))
+				break;
+			/*
+			 * New cpumask using the vector is a proper subset of
+			 * the current in use mask. So cleanup the vector
+			 * allocation for the members that are not used anymore.
+			 */
+			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
+			cfg->move_in_progress =
+			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
+			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
+			break;
+		}
+
+		vector = current_vector;
+		offset = current_offset;
+next:
+		vector += 16;
+		if (vector >= first_system_vector) {
+			offset = (offset + 1) % 16;
+			vector = FIRST_EXTERNAL_VECTOR + offset;
+		}
+
+		if (unlikely(current_vector == vector)) {
+			cpumask_or(cfg->old_domain, cfg->old_domain, tmp_mask);
+			cpumask_andnot(tmp_mask, mask, cfg->old_domain);
+			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
+			continue;
+		}
+
+		if (test_bit(vector, used_vectors))
+			goto next;
+
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
+			if (per_cpu(vector_irq, new_cpu)[vector] >
+			    VECTOR_UNDEFINED)
+				goto next;
+		}
+		/* Found one! */
+		current_vector = vector;
+		current_offset = offset;
+		if (cfg->vector) {
+			cpumask_copy(cfg->old_domain, cfg->domain);
+			cfg->move_in_progress =
+			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
+		}
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+			per_cpu(vector_irq, new_cpu)[vector] = irq;
+		cfg->vector = vector;
+		cpumask_copy(cfg->domain, tmp_mask);
+		err = 0;
+		break;
+	}
+	free_cpumask_var(tmp_mask);
+
+	return err;
+}
+
+int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+{
+	int err;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	err = __assign_irq_vector(irq, cfg, mask);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+	return err;
+}
+
+void clear_irq_vector(int irq, struct irq_cfg *cfg)
+{
+	int cpu, vector;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	BUG_ON(!cfg->vector);
+
+	vector = cfg->vector;
+	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
+		per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
+
+	cfg->vector = 0;
+	cpumask_clear(cfg->domain);
+
+	if (likely(!cfg->move_in_progress)) {
+		raw_spin_unlock_irqrestore(&vector_lock, flags);
+		return;
+	}
+
+	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
+		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
+		     vector++) {
+			if (per_cpu(vector_irq, cpu)[vector] != irq)
+				continue;
+			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
+			break;
+		}
+	}
+	cfg->move_in_progress = 0;
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+}
+
+int __init arch_probe_nr_irqs(void)
+{
+	int nr;
+
+	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
+		nr_irqs = NR_VECTORS * nr_cpu_ids;
+
+	nr = (gsi_top + nr_legacy_irqs()) + 8 * nr_cpu_ids;
+#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
+	/*
+	 * for MSI and HT dyn irq
+	 */
+	if (gsi_top <= NR_IRQS_LEGACY)
+		nr +=  8 * nr_cpu_ids;
+	else
+		nr += gsi_top * 16;
+#endif
+	if (nr < nr_irqs)
+		nr_irqs = nr;
+
+	return nr_legacy_irqs();
+}
+
+int __init arch_early_irq_init(void)
+{
+	return arch_early_ioapic_init();
+}
+
+static void __setup_vector_irq(int cpu)
+{
+	/* Initialize vector_irq on a new cpu */
+	int irq, vector;
+	struct irq_cfg *cfg;
+
+	/*
+	 * vector_lock will make sure that we don't run into irq vector
+	 * assignments that might be happening on another cpu in parallel,
+	 * while we setup our initial vector to irq mappings.
+	 */
+	raw_spin_lock(&vector_lock);
+	/* Mark the inuse vectors */
+	for_each_active_irq(irq) {
+		cfg = irq_cfg(irq);
+		if (!cfg)
+			continue;
+
+		if (!cpumask_test_cpu(cpu, cfg->domain))
+			continue;
+		vector = cfg->vector;
+		per_cpu(vector_irq, cpu)[vector] = irq;
+	}
+	/* Mark the free vectors */
+	for (vector = 0; vector < NR_VECTORS; ++vector) {
+		irq = per_cpu(vector_irq, cpu)[vector];
+		if (irq <= VECTOR_UNDEFINED)
+			continue;
+
+		cfg = irq_cfg(irq);
+		if (!cpumask_test_cpu(cpu, cfg->domain))
+			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
+	}
+	raw_spin_unlock(&vector_lock);
+}
+
+/*
+ * Setup the vector to irq mappings.
+ */
+void setup_vector_irq(int cpu)
+{
+	int irq;
+
+	/*
+	 * On most of the platforms, legacy PIC delivers the interrupts on the
+	 * boot cpu. But there are certain platforms where PIC interrupts are
+	 * delivered to multiple cpu's. If the legacy IRQ is handled by the
+	 * legacy PIC, for the new cpu that is coming online, setup the static
+	 * legacy vector to irq mapping:
+	 */
+	for (irq = 0; irq < nr_legacy_irqs(); irq++)
+		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
+
+	__setup_vector_irq(cpu);
+}
+
+int apic_retrigger_irq(struct irq_data *data)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+	unsigned long flags;
+	int cpu;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	cpu = cpumask_first_and(cfg->domain, cpu_online_mask);
+	apic->send_IPI_mask(cpumask_of(cpu), cfg->vector);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+
+	return 1;
+}
+
+void apic_ack_edge(struct irq_data *data)
+{
+	irq_complete_move(irqd_cfg(data));
+	irq_move_irq(data);
+	ack_APIC_irq();
+}
+
+/*
+ * Either sets data->affinity to a valid value, and returns
+ * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
+ * leaves data->affinity untouched.
+ */
+int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      unsigned int *dest_id)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+	unsigned int irq = data->irq;
+	int err;
+
+	if (!config_enabled(CONFIG_SMP))
+		return -EPERM;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return -EINVAL;
+
+	err = assign_irq_vector(irq, cfg, mask);
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(mask, cfg->domain, dest_id);
+	if (err) {
+		if (assign_irq_vector(irq, cfg, data->affinity))
+			pr_err("Failed to recover vector for irq %d\n", irq);
+		return err;
+	}
+
+	cpumask_copy(data->affinity, mask);
+
+	return 0;
+}
+
+#ifdef CONFIG_SMP
+void send_cleanup_vector(struct irq_cfg *cfg)
+{
+	cpumask_var_t cleanup_mask;
+
+	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
+		unsigned int i;
+
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			apic->send_IPI_mask(cpumask_of(i),
+					    IRQ_MOVE_CLEANUP_VECTOR);
+	} else {
+		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		free_cpumask_var(cleanup_mask);
+	}
+	cfg->move_in_progress = 0;
+}
+
+asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
+{
+	unsigned vector, me;
+
+	ack_APIC_irq();
+	irq_enter();
+	exit_idle();
+
+	me = smp_processor_id();
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		int irq;
+		unsigned int irr;
+		struct irq_desc *desc;
+		struct irq_cfg *cfg;
+
+		irq = __this_cpu_read(vector_irq[vector]);
+
+		if (irq <= VECTOR_UNDEFINED)
+			continue;
+
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		cfg = irq_cfg(irq);
+		if (!cfg)
+			continue;
+
+		raw_spin_lock(&desc->lock);
+
+		/*
+		 * Check if the irq migration is in progress. If so, we
+		 * haven't received the cleanup request yet for this irq.
+		 */
+		if (cfg->move_in_progress)
+			goto unlock;
+
+		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
+			goto unlock;
+
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		/*
+		 * Check if the vector that needs to be cleanedup is
+		 * registered at the cpu's IRR. If so, then this is not
+		 * the best time to clean it up. Lets clean it up in the
+		 * next attempt by sending another IRQ_MOVE_CLEANUP_VECTOR
+		 * to myself.
+		 */
+		if (irr  & (1 << (vector % 32))) {
+			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
+			goto unlock;
+		}
+		__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
+unlock:
+		raw_spin_unlock(&desc->lock);
+	}
+
+	irq_exit();
+}
+
+static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
+{
+	unsigned me;
+
+	if (likely(!cfg->move_in_progress))
+		return;
+
+	me = smp_processor_id();
+
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
+		send_cleanup_vector(cfg);
+}
+
+void irq_complete_move(struct irq_cfg *cfg)
+{
+	__irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
+}
+
+void irq_force_complete_move(int irq)
+{
+	struct irq_cfg *cfg = irq_cfg(irq);
+
+	if (!cfg)
+		return;
+
+	__irq_complete_move(cfg, cfg->vector);
+}
+#endif
+
+/*
+ * Dynamic irq allocate and deallocation. Should be replaced by irq domains!
+ */
+int arch_setup_hwirq(unsigned int irq, int node)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	int ret;
+
+	cfg = alloc_irq_cfg(irq, node);
+	if (!cfg)
+		return -ENOMEM;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	ret = __assign_irq_vector(irq, cfg, apic->target_cpus());
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+
+	if (!ret)
+		irq_set_chip_data(irq, cfg);
+	else
+		free_irq_cfg(irq, cfg);
+	return ret;
+}
+
+void arch_teardown_hwirq(unsigned int irq)
+{
+	struct irq_cfg *cfg = irq_cfg(irq);
+
+	free_remapped_irq(irq);
+	clear_irq_vector(irq, cfg);
+	free_irq_cfg(irq, cfg);
+}
+
+static void __init print_APIC_field(int base)
+{
+	int i;
+
+	printk(KERN_DEBUG);
+
+	for (i = 0; i < 8; i++)
+		pr_cont("%08x", apic_read(base + i*0x10));
+
+	pr_cont("\n");
+}
+
+static void __init print_local_APIC(void *dummy)
+{
+	unsigned int i, v, ver, maxlvt;
+	u64 icr;
+
+	pr_debug("printing local APIC contents on CPU#%d/%d:\n",
+		 smp_processor_id(), hard_smp_processor_id());
+	v = apic_read(APIC_ID);
+	pr_info("... APIC ID:      %08x (%01x)\n", v, read_apic_id());
+	v = apic_read(APIC_LVR);
+	pr_info("... APIC VERSION: %08x\n", v);
+	ver = GET_APIC_VERSION(v);
+	maxlvt = lapic_get_maxlvt();
+
+	v = apic_read(APIC_TASKPRI);
+	pr_debug("... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
+
+	/* !82489DX */
+	if (APIC_INTEGRATED(ver)) {
+		if (!APIC_XAPIC(ver)) {
+			v = apic_read(APIC_ARBPRI);
+			pr_debug("... APIC ARBPRI: %08x (%02x)\n",
+				 v, v & APIC_ARBPRI_MASK);
+		}
+		v = apic_read(APIC_PROCPRI);
+		pr_debug("... APIC PROCPRI: %08x\n", v);
+	}
+
+	/*
+	 * Remote read supported only in the 82489DX and local APIC for
+	 * Pentium processors.
+	 */
+	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
+		v = apic_read(APIC_RRR);
+		pr_debug("... APIC RRR: %08x\n", v);
+	}
+
+	v = apic_read(APIC_LDR);
+	pr_debug("... APIC LDR: %08x\n", v);
+	if (!x2apic_enabled()) {
+		v = apic_read(APIC_DFR);
+		pr_debug("... APIC DFR: %08x\n", v);
+	}
+	v = apic_read(APIC_SPIV);
+	pr_debug("... APIC SPIV: %08x\n", v);
+
+	pr_debug("... APIC ISR field:\n");
+	print_APIC_field(APIC_ISR);
+	pr_debug("... APIC TMR field:\n");
+	print_APIC_field(APIC_TMR);
+	pr_debug("... APIC IRR field:\n");
+	print_APIC_field(APIC_IRR);
+
+	/* !82489DX */
+	if (APIC_INTEGRATED(ver)) {
+		/* Due to the Pentium erratum 3AP. */
+		if (maxlvt > 3)
+			apic_write(APIC_ESR, 0);
+
+		v = apic_read(APIC_ESR);
+		pr_debug("... APIC ESR: %08x\n", v);
+	}
+
+	icr = apic_icr_read();
+	pr_debug("... APIC ICR: %08x\n", (u32)icr);
+	pr_debug("... APIC ICR2: %08x\n", (u32)(icr >> 32));
+
+	v = apic_read(APIC_LVTT);
+	pr_debug("... APIC LVTT: %08x\n", v);
+
+	if (maxlvt > 3) {
+		/* PC is LVT#4. */
+		v = apic_read(APIC_LVTPC);
+		pr_debug("... APIC LVTPC: %08x\n", v);
+	}
+	v = apic_read(APIC_LVT0);
+	pr_debug("... APIC LVT0: %08x\n", v);
+	v = apic_read(APIC_LVT1);
+	pr_debug("... APIC LVT1: %08x\n", v);
+
+	if (maxlvt > 2) {
+		/* ERR is LVT#3. */
+		v = apic_read(APIC_LVTERR);
+		pr_debug("... APIC LVTERR: %08x\n", v);
+	}
+
+	v = apic_read(APIC_TMICT);
+	pr_debug("... APIC TMICT: %08x\n", v);
+	v = apic_read(APIC_TMCCT);
+	pr_debug("... APIC TMCCT: %08x\n", v);
+	v = apic_read(APIC_TDCR);
+	pr_debug("... APIC TDCR: %08x\n", v);
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		v = apic_read(APIC_EFEAT);
+		maxlvt = (v >> 16) & 0xff;
+		pr_debug("... APIC EFEAT: %08x\n", v);
+		v = apic_read(APIC_ECTRL);
+		pr_debug("... APIC ECTRL: %08x\n", v);
+		for (i = 0; i < maxlvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			pr_debug("... APIC EILVT%d: %08x\n", i, v);
+		}
+	}
+	pr_cont("\n");
+}
+
+static void __init print_local_APICs(int maxcpu)
+{
+	int cpu;
+
+	if (!maxcpu)
+		return;
+
+	preempt_disable();
+	for_each_online_cpu(cpu) {
+		if (cpu >= maxcpu)
+			break;
+		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
+	}
+	preempt_enable();
+}
+
+static void __init print_PIC(void)
+{
+	unsigned int v;
+	unsigned long flags;
+
+	if (!nr_legacy_irqs())
+		return;
+
+	pr_debug("\nprinting PIC contents\n");
+
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
+
+	v = inb(0xa1) << 8 | inb(0x21);
+	pr_debug("... PIC  IMR: %04x\n", v);
+
+	v = inb(0xa0) << 8 | inb(0x20);
+	pr_debug("... PIC  IRR: %04x\n", v);
+
+	outb(0x0b, 0xa0);
+	outb(0x0b, 0x20);
+	v = inb(0xa0) << 8 | inb(0x20);
+	outb(0x0a, 0xa0);
+	outb(0x0a, 0x20);
+
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
+
+	pr_debug("... PIC  ISR: %04x\n", v);
+
+	v = inb(0x4d1) << 8 | inb(0x4d0);
+	pr_debug("... PIC ELCR: %04x\n", v);
+}
+
+static int show_lapic __initdata = 1;
+static __init int setup_show_lapic(char *arg)
+{
+	int num = -1;
+
+	if (strcmp(arg, "all") == 0) {
+		show_lapic = CONFIG_NR_CPUS;
+	} else {
+		get_option(&arg, &num);
+		if (num >= 0)
+			show_lapic = num;
+	}
+
+	return 1;
+}
+__setup("show_lapic=", setup_show_lapic);
+
+static int __init print_ICs(void)
+{
+	if (apic_verbosity == APIC_QUIET)
+		return 0;
+
+	print_PIC();
+
+	/* don't print out if apic is not there */
+	if (!cpu_has_apic && !apic_from_smp_config())
+		return 0;
+
+	print_local_APICs(show_lapic);
+	print_IO_APICs();
+
+	return 0;
+}
+
+late_initcall(print_ICs);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index f5ab56d14287..aceb2f90c716 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,6 +28,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/cpu.h>
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 344b63f18d14..1ea4488bbb90 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -732,10 +732,10 @@ ENTRY(interrupt)
 ENTRY(irq_entries_start)
 	RING0_INT_FRAME
 vector=FIRST_EXTERNAL_VECTOR
-.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+.rept (FIRST_SYSTEM_VECTOR-FIRST_EXTERNAL_VECTOR+6)/7
 	.balign 32
   .rept	7
-    .if vector < NR_VECTORS
+    .if vector < FIRST_SYSTEM_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -4
       .endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c0226ab54106..e61c14aa1ef9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -712,10 +712,10 @@ ENTRY(interrupt)
 ENTRY(irq_entries_start)
 	INTR_FRAME
 vector=FIRST_EXTERNAL_VECTOR
-.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+.rept (FIRST_SYSTEM_VECTOR-FIRST_EXTERNAL_VECTOR+6)/7
 	.balign 32
   .rept	7
-    .if vector < NR_VECTORS
+    .if vector < FIRST_SYSTEM_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -8
       .endif
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 4de73ee78361..70e181ea1eac 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -99,32 +99,9 @@ void __init init_IRQ(void)
 	x86_init.irqs.intr_init();
 }
 
-/*
- * Setup the vector to irq mappings.
- */
-void setup_vector_irq(int cpu)
-{
-#ifndef CONFIG_X86_IO_APIC
-	int irq;
-
-	/*
-	 * On most of the platforms, legacy PIC delivers the interrupts on the
-	 * boot cpu. But there are certain platforms where PIC interrupts are
-	 * delivered to multiple cpu's. If the legacy IRQ is handled by the
-	 * legacy PIC, for the new cpu that is coming online, setup the static
-	 * legacy vector to irq mapping:
-	 */
-	for (irq = 0; irq < nr_legacy_irqs(); irq++)
-		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
-#endif
-
-	__setup_vector_irq(cpu);
-}
-
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -144,7 +121,6 @@ static void __init smp_intr_init(void)
 
 	/* IPI used for rebooting/stopping */
 	alloc_intr_gate(REBOOT_VECTOR, reboot_interrupt);
-#endif
 #endif /* CONFIG_SMP */
 }
 
@@ -159,7 +135,7 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
+#ifdef CONFIG_X86_LOCAL_APIC
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
@@ -197,10 +173,17 @@ void __init native_init_IRQ(void)
 	 * 'special' SMP interrupts)
 	 */
 	i = FIRST_EXTERNAL_VECTOR;
-	for_each_clear_bit_from(i, used_vectors, NR_VECTORS) {
+#ifndef CONFIG_X86_LOCAL_APIC
+#define first_system_vector NR_VECTORS
+#endif
+	for_each_clear_bit_from(i, used_vectors, first_system_vector) {
 		/* IA32_SYSCALL_VECTOR could be used in trap_init already. */
 		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
+#ifdef CONFIG_X86_LOCAL_APIC
+	for_each_clear_bit_from(i, used_vectors, NR_VECTORS)
+		set_intr_gate(i, spurious_interrupt);
+#endif
 
 	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs())
 		setup_irq(2, &irq2);
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 72e8e310258d..469b23d6acc2 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/cacheflush.h>
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 485981059a40..415480d3ea84 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -22,6 +22,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/io_apic.h>
 #include <asm/debugreg.h>
 #include <asm/kexec-bzimage64.h>
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 17962e667a91..bae6c609888e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7a8f5845e8eb..6d7022c683e3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1084,7 +1084,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned int i;
 
-	preempt_disable();
 	smp_cpu_index_default();
 
 	/*
@@ -1102,22 +1101,19 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
-
 	if (smp_sanity_check(max_cpus) < 0) {
 		pr_info("SMP disabled\n");
 		disable_smp();
-		goto out;
+		return;
 	}
 
 	default_setup_apic_routing();
 
-	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
 		     read_apic_id(), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
-	preempt_enable();
 
 	connect_bsp_APIC();
 
@@ -1151,8 +1147,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		uv_system_init();
 
 	set_mtrr_aps_delayed_init();
-out:
-	preempt_enable();
 }
 
 void arch_enable_nonboot_cpus_begin(void)
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index aae94132bc24..c1c1544b8485 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -841,7 +841,7 @@ static void __init lguest_init_IRQ(void)
 {
 	unsigned int i;
 
-	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+	for (i = FIRST_EXTERNAL_VECTOR; i < FIRST_SYSTEM_VECTOR; i++) {
 		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
 		__this_cpu_write(vector_irq[i], i - FIRST_EXTERNAL_VECTOR);
 		if (i != SYSCALL_VECTOR)
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index b9958c364075..44b9271580b5 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -210,6 +210,9 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 {
 	int polarity;
 
+	if (dev->irq_managed && dev->irq > 0)
+		return 0;
+
 	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
 		polarity = 0; /* active high */
 	else
@@ -224,13 +227,18 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
 		return -EBUSY;
 
+	dev->irq_managed = 1;
+
 	return 0;
 }
 
 static void intel_mid_pci_irq_disable(struct pci_dev *dev)
 {
-	if (!mp_should_keep_irq(&dev->dev) && dev->irq > 0)
+	if (!mp_should_keep_irq(&dev->dev) && dev->irq_managed &&
+	    dev->irq > 0) {
 		mp_unmap_irq(dev->irq);
+		dev->irq_managed = 0;
+	}
 }
 
 struct pci_ops intel_mid_pci_ops = {
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index eb500c2592ad..77148eccdf23 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1200,11 +1200,12 @@ static int pirq_enable_irq(struct pci_dev *dev)
 #ifdef CONFIG_X86_IO_APIC
 			struct pci_dev *temp_dev;
 			int irq;
-			struct io_apic_irq_attr irq_attr;
+
+			if (dev->irq_managed && dev->irq > 0)
+				return 0;
 
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-						PCI_SLOT(dev->devfn),
-						pin - 1, &irq_attr);
+						PCI_SLOT(dev->devfn), pin - 1);
 			/*
 			 * Busses behind bridges are typically not listed in the MP-table.
 			 * In this case we have to look up the IRQ based on the parent bus,
@@ -1218,7 +1219,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn),
-						pin - 1, &irq_attr);
+						pin - 1);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
@@ -1228,6 +1229,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
+				dev->irq_managed = 1;
 				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
@@ -1254,11 +1256,24 @@ static int pirq_enable_irq(struct pci_dev *dev)
 	return 0;
 }
 
+bool mp_should_keep_irq(struct device *dev)
+{
+	if (dev->power.is_prepared)
+		return true;
+#ifdef CONFIG_PM_RUNTIME
+	if (dev->power.runtime_status == RPM_SUSPENDING)
+		return true;
+#endif
+
+	return false;
+}
+
 static void pirq_disable_irq(struct pci_dev *dev)
 {
 	if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
-	    dev->irq) {
+	    dev->irq_managed && dev->irq) {
 		mp_unmap_irq(dev->irq);
 		dev->irq = 0;
+		dev->irq_managed = 0;
 	}
 }
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index b233681af4de..0ce673645432 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -131,7 +131,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode, err;
@@ -198,13 +198,13 @@ static int
 uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 		    bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest;
 	unsigned long mmr_value, mmr_offset;
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
+	if (apic_set_affinity(data, mask, &dest))
 		return -1;
 
 	mmr_value = 0;
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 6e6b80eb0bba..5f1fdca65e5f 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -413,6 +413,9 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return 0;
 	}
 
+	if (dev->irq_managed && dev->irq > 0)
+		return 0;
+
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry) {
 		/*
@@ -456,6 +459,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return rc;
 	}
 	dev->irq = rc;
+	dev->irq_managed = 1;
 
 	if (link)
 		snprintf(link_desc, sizeof(link_desc), " -> Link[%s]", link);
@@ -478,7 +482,7 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	u8 pin;
 
 	pin = dev->pin;
-	if (!pin)
+	if (!pin || !dev->irq_managed || dev->irq <= 0)
 		return;
 
 	/* Keep IOAPIC pin configuration when suspending */
@@ -506,6 +510,9 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 */
 
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
-	if (gsi >= 0 && dev->irq > 0)
+	if (gsi >= 0) {
 		acpi_unregister_gsi(gsi);
+		dev->irq = 0;
+		dev->irq_managed = 0;
+	}
 }
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index cd4de7e038ea..c6bcb8c719d8 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/pci-acpi.h>
 #include <linux/pci-aspm.h>
+#include <linux/dmar.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <linux/dmi.h>
@@ -525,6 +526,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	struct acpi_pci_root *root;
 	acpi_handle handle = device->handle;
 	int no_aspm = 0, clear_aspm = 0;
+	bool hotadd = system_state != SYSTEM_BOOTING;
 
 	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
 	if (!root)
@@ -571,6 +573,11 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
 	device->driver_data = root;
 
+	if (hotadd && dmar_device_add(handle)) {
+		result = -ENXIO;
+		goto end;
+	}
+
 	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       root->segment, &root->secondary);
@@ -597,7 +604,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 			root->segment, (unsigned int)root->secondary.start);
 		device->driver_data = NULL;
 		result = -ENODEV;
-		goto end;
+		goto remove_dmar;
 	}
 
 	if (clear_aspm) {
@@ -611,7 +618,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
 
-	if (system_state != SYSTEM_BOOTING) {
+	if (hotadd) {
 		pcibios_resource_survey_bus(root->bus);
 		pci_assign_unassigned_root_bus_resources(root->bus);
 	}
@@ -621,6 +628,9 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	pci_unlock_rescan_remove();
 	return 1;
 
+remove_dmar:
+	if (hotadd)
+		dmar_device_remove(handle);
 end:
 	kfree(root);
 	return result;
@@ -639,6 +649,8 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_remove_root_bus(root->bus);
 
+	dmar_device_remove(device->handle);
+
 	pci_unlock_rescan_remove();
 
 	kfree(root);
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ef58f46c8442..342942f90a10 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -125,13 +125,12 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 	}
 
 	header = (struct acpi_subtable_header *)obj->buffer.pointer;
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
 		map_lapic_id(header, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
 		map_lsapic_id(header, type, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC)
 		map_x2apic_id(header, type, acpi_id, &apic_id);
-	}
 
 exit:
 	kfree(buffer.pointer);
@@ -164,7 +163,7 @@ int acpi_map_cpuid(int apic_id, u32 acpi_id)
 		 * For example,
 		 *
 		 * Scope (_PR)
-                 * {
+		 * {
 		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
 		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
 		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 2ba8f02ced36..782a0d15c25f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -200,7 +200,7 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 
 	status = acpi_resource_to_address64(ares, &addr);
 	if (ACPI_FAILURE(status))
-		return true;
+		return false;
 
 	res->start = addr.minimum;
 	res->end = addr.maximum;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 2d84c9edf3b8..d65f76643664 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4069,7 +4069,7 @@ static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	int devid;
 	int ret;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4132,7 +4132,7 @@ static int set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (!config_enabled(CONFIG_SMP))
 		return -1;
 
-	cfg       = data->chip_data;
+	cfg       = irqd_cfg(data);
 	irq       = data->irq;
 	irte_info = &cfg->irq_2_irte;
 
@@ -4170,7 +4170,7 @@ static int free_irq(int irq)
 	struct irq_2_irte *irte_info;
 	struct irq_cfg *cfg;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4189,7 +4189,7 @@ static void compose_msi_msg(struct pci_dev *pdev,
 	struct irq_cfg *cfg;
 	union irte irte;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return;
 
@@ -4218,7 +4218,7 @@ static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4238,7 +4238,7 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4261,7 +4261,7 @@ static int alloc_hpet_msi(unsigned int irq, unsigned int id)
 	struct irq_cfg *cfg;
 	int index, devid;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index c5c61cabd6e3..9847613085e1 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -44,6 +44,14 @@
 
 #include "irq_remapping.h"
 
+typedef int (*dmar_res_handler_t)(struct acpi_dmar_header *, void *);
+struct dmar_res_callback {
+	dmar_res_handler_t	cb[ACPI_DMAR_TYPE_RESERVED];
+	void			*arg[ACPI_DMAR_TYPE_RESERVED];
+	bool			ignore_unhandled;
+	bool			print_entry;
+};
+
 /*
  * Assumptions:
  * 1) The hotplug framework guarentees that DMAR unit will be hot-added
@@ -62,11 +70,12 @@ LIST_HEAD(dmar_drhd_units);
 struct acpi_table_header * __initdata dmar_tbl;
 static acpi_size dmar_tbl_size;
 static int dmar_dev_scope_status = 1;
+static unsigned long dmar_seq_ids[BITS_TO_LONGS(DMAR_UNITS_SUPPORTED)];
 
 static int alloc_iommu(struct dmar_drhd_unit *drhd);
 static void free_iommu(struct intel_iommu *iommu);
 
-static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
+static void dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
 	/*
 	 * add INCLUDE_ALL at the tail, so scan the list will find it at
@@ -344,24 +353,45 @@ static struct notifier_block dmar_pci_bus_nb = {
 	.priority = INT_MIN,
 };
 
+static struct dmar_drhd_unit *
+dmar_find_dmaru(struct acpi_dmar_hardware_unit *drhd)
+{
+	struct dmar_drhd_unit *dmaru;
+
+	list_for_each_entry_rcu(dmaru, &dmar_drhd_units, list)
+		if (dmaru->segment == drhd->segment &&
+		    dmaru->reg_base_addr == drhd->address)
+			return dmaru;
+
+	return NULL;
+}
+
 /**
  * dmar_parse_one_drhd - parses exactly one DMA remapping hardware definition
  * structure which uniquely represent one DMA remapping hardware unit
  * present in the platform
  */
-static int __init
-dmar_parse_one_drhd(struct acpi_dmar_header *header)
+static int dmar_parse_one_drhd(struct acpi_dmar_header *header, void *arg)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct dmar_drhd_unit *dmaru;
 	int ret = 0;
 
 	drhd = (struct acpi_dmar_hardware_unit *)header;
-	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
+	dmaru = dmar_find_dmaru(drhd);
+	if (dmaru)
+		goto out;
+
+	dmaru = kzalloc(sizeof(*dmaru) + header->length, GFP_KERNEL);
 	if (!dmaru)
 		return -ENOMEM;
 
-	dmaru->hdr = header;
+	/*
+	 * If header is allocated from slab by ACPI _DSM method, we need to
+	 * copy the content because the memory buffer will be freed on return.
+	 */
+	dmaru->hdr = (void *)(dmaru + 1);
+	memcpy(dmaru->hdr, header, header->length);
 	dmaru->reg_base_addr = drhd->address;
 	dmaru->segment = drhd->segment;
 	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
@@ -381,6 +411,11 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 		return ret;
 	}
 	dmar_register_drhd_unit(dmaru);
+
+out:
+	if (arg)
+		(*(int *)arg)++;
+
 	return 0;
 }
 
@@ -393,7 +428,8 @@ static void dmar_free_drhd(struct dmar_drhd_unit *dmaru)
 	kfree(dmaru);
 }
 
-static int __init dmar_parse_one_andd(struct acpi_dmar_header *header)
+static int __init dmar_parse_one_andd(struct acpi_dmar_header *header,
+				      void *arg)
 {
 	struct acpi_dmar_andd *andd = (void *)header;
 
@@ -414,8 +450,7 @@ static int __init dmar_parse_one_andd(struct acpi_dmar_header *header)
 }
 
 #ifdef CONFIG_ACPI_NUMA
-static int __init
-dmar_parse_one_rhsa(struct acpi_dmar_header *header)
+static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
 {
 	struct acpi_dmar_rhsa *rhsa;
 	struct dmar_drhd_unit *drhd;
@@ -442,6 +477,8 @@ dmar_parse_one_rhsa(struct acpi_dmar_header *header)
 
 	return 0;
 }
+#else
+#define	dmar_parse_one_rhsa		dmar_res_noop
 #endif
 
 static void __init
@@ -503,6 +540,52 @@ static int __init dmar_table_detect(void)
 	return (ACPI_SUCCESS(status) ? 1 : 0);
 }
 
+static int dmar_walk_remapping_entries(struct acpi_dmar_header *start,
+				       size_t len, struct dmar_res_callback *cb)
+{
+	int ret = 0;
+	struct acpi_dmar_header *iter, *next;
+	struct acpi_dmar_header *end = ((void *)start) + len;
+
+	for (iter = start; iter < end && ret == 0; iter = next) {
+		next = (void *)iter + iter->length;
+		if (iter->length == 0) {
+			/* Avoid looping forever on bad ACPI tables */
+			pr_debug(FW_BUG "Invalid 0-length structure\n");
+			break;
+		} else if (next > end) {
+			/* Avoid passing table end */
+			pr_warn(FW_BUG "record passes table end\n");
+			ret = -EINVAL;
+			break;
+		}
+
+		if (cb->print_entry)
+			dmar_table_print_dmar_entry(iter);
+
+		if (iter->type >= ACPI_DMAR_TYPE_RESERVED) {
+			/* continue for forward compatibility */
+			pr_debug("Unknown DMAR structure type %d\n",
+				 iter->type);
+		} else if (cb->cb[iter->type]) {
+			ret = cb->cb[iter->type](iter, cb->arg[iter->type]);
+		} else if (!cb->ignore_unhandled) {
+			pr_warn("No handler for DMAR structure type %d\n",
+				iter->type);
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+static inline int dmar_walk_dmar_table(struct acpi_table_dmar *dmar,
+				       struct dmar_res_callback *cb)
+{
+	return dmar_walk_remapping_entries((void *)(dmar + 1),
+			dmar->header.length - sizeof(*dmar), cb);
+}
+
 /**
  * parse_dmar_table - parses the DMA reporting table
  */
@@ -510,9 +593,18 @@ static int __init
 parse_dmar_table(void)
 {
 	struct acpi_table_dmar *dmar;
-	struct acpi_dmar_header *entry_header;
 	int ret = 0;
 	int drhd_count = 0;
+	struct dmar_res_callback cb = {
+		.print_entry = true,
+		.ignore_unhandled = true,
+		.arg[ACPI_DMAR_TYPE_HARDWARE_UNIT] = &drhd_count,
+		.cb[ACPI_DMAR_TYPE_HARDWARE_UNIT] = &dmar_parse_one_drhd,
+		.cb[ACPI_DMAR_TYPE_RESERVED_MEMORY] = &dmar_parse_one_rmrr,
+		.cb[ACPI_DMAR_TYPE_ROOT_ATS] = &dmar_parse_one_atsr,
+		.cb[ACPI_DMAR_TYPE_HARDWARE_AFFINITY] = &dmar_parse_one_rhsa,
+		.cb[ACPI_DMAR_TYPE_NAMESPACE] = &dmar_parse_one_andd,
+	};
 
 	/*
 	 * Do it again, earlier dmar_tbl mapping could be mapped with
@@ -536,51 +628,10 @@ parse_dmar_table(void)
 	}
 
 	pr_info("Host address width %d\n", dmar->width + 1);
-
-	entry_header = (struct acpi_dmar_header *)(dmar + 1);
-	while (((unsigned long)entry_header) <
-			(((unsigned long)dmar) + dmar_tbl->length)) {
-		/* Avoid looping forever on bad ACPI tables */
-		if (entry_header->length == 0) {
-			pr_warn("Invalid 0-length structure\n");
-			ret = -EINVAL;
-			break;
-		}
-
-		dmar_table_print_dmar_entry(entry_header);
-
-		switch (entry_header->type) {
-		case ACPI_DMAR_TYPE_HARDWARE_UNIT:
-			drhd_count++;
-			ret = dmar_parse_one_drhd(entry_header);
-			break;
-		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
-			ret = dmar_parse_one_rmrr(entry_header);
-			break;
-		case ACPI_DMAR_TYPE_ROOT_ATS:
-			ret = dmar_parse_one_atsr(entry_header);
-			break;
-		case ACPI_DMAR_TYPE_HARDWARE_AFFINITY:
-#ifdef CONFIG_ACPI_NUMA
-			ret = dmar_parse_one_rhsa(entry_header);
-#endif
-			break;
-		case ACPI_DMAR_TYPE_NAMESPACE:
-			ret = dmar_parse_one_andd(entry_header);
-			break;
-		default:
-			pr_warn("Unknown DMAR structure type %d\n",
-				entry_header->type);
-			ret = 0; /* for forward compatibility */
-			break;
-		}
-		if (ret)
-			break;
-
-		entry_header = ((void *)entry_header + entry_header->length);
-	}
-	if (drhd_count == 0)
+	ret = dmar_walk_dmar_table(dmar, &cb);
+	if (ret == 0 && drhd_count == 0)
 		pr_warn(FW_BUG "No DRHD structure found in DMAR table\n");
+
 	return ret;
 }
 
@@ -778,76 +829,68 @@ static void warn_invalid_dmar(u64 addr, const char *message)
 		dmi_get_system_info(DMI_PRODUCT_VERSION));
 }
 
-static int __init check_zero_address(void)
+static int __ref
+dmar_validate_one_drhd(struct acpi_dmar_header *entry, void *arg)
 {
-	struct acpi_table_dmar *dmar;
-	struct acpi_dmar_header *entry_header;
 	struct acpi_dmar_hardware_unit *drhd;
+	void __iomem *addr;
+	u64 cap, ecap;
 
-	dmar = (struct acpi_table_dmar *)dmar_tbl;
-	entry_header = (struct acpi_dmar_header *)(dmar + 1);
-
-	while (((unsigned long)entry_header) <
-			(((unsigned long)dmar) + dmar_tbl->length)) {
-		/* Avoid looping forever on bad ACPI tables */
-		if (entry_header->length == 0) {
-			pr_warn("Invalid 0-length structure\n");
-			return 0;
-		}
+	drhd = (void *)entry;
+	if (!drhd->address) {
+		warn_invalid_dmar(0, "");
+		return -EINVAL;
+	}
 
-		if (entry_header->type == ACPI_DMAR_TYPE_HARDWARE_UNIT) {
-			void __iomem *addr;
-			u64 cap, ecap;
+	if (arg)
+		addr = ioremap(drhd->address, VTD_PAGE_SIZE);
+	else
+		addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
+	if (!addr) {
+		pr_warn("IOMMU: can't validate: %llx\n", drhd->address);
+		return -EINVAL;
+	}
 
-			drhd = (void *)entry_header;
-			if (!drhd->address) {
-				warn_invalid_dmar(0, "");
-				goto failed;
-			}
+	cap = dmar_readq(addr + DMAR_CAP_REG);
+	ecap = dmar_readq(addr + DMAR_ECAP_REG);
 
-			addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
-			if (!addr ) {
-				printk("IOMMU: can't validate: %llx\n", drhd->address);
-				goto failed;
-			}
-			cap = dmar_readq(addr + DMAR_CAP_REG);
-			ecap = dmar_readq(addr + DMAR_ECAP_REG);
-			early_iounmap(addr, VTD_PAGE_SIZE);
-			if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
-				warn_invalid_dmar(drhd->address,
-						  " returns all ones");
-				goto failed;
-			}
-		}
+	if (arg)
+		iounmap(addr);
+	else
+		early_iounmap(addr, VTD_PAGE_SIZE);
 
-		entry_header = ((void *)entry_header + entry_header->length);
+	if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
+		warn_invalid_dmar(drhd->address, " returns all ones");
+		return -EINVAL;
 	}
-	return 1;
 
-failed:
 	return 0;
 }
 
 int __init detect_intel_iommu(void)
 {
 	int ret;
+	struct dmar_res_callback validate_drhd_cb = {
+		.cb[ACPI_DMAR_TYPE_HARDWARE_UNIT] = &dmar_validate_one_drhd,
+		.ignore_unhandled = true,
+	};
 
 	down_write(&dmar_global_lock);
 	ret = dmar_table_detect();
 	if (ret)
-		ret = check_zero_address();
-	{
-		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
-			iommu_detected = 1;
-			/* Make sure ACS will be enabled */
-			pci_request_acs();
-		}
+		ret = !dmar_walk_dmar_table((struct acpi_table_dmar *)dmar_tbl,
+					    &validate_drhd_cb);
+	if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
+		iommu_detected = 1;
+		/* Make sure ACS will be enabled */
+		pci_request_acs();
+	}
 
 #ifdef CONFIG_X86
-		if (ret)
-			x86_init.iommu.iommu_init = intel_iommu_init;
+	if (ret)
+		x86_init.iommu.iommu_init = intel_iommu_init;
 #endif
-	}
+
 	early_acpi_os_unmap_memory((void __iomem *)dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
 	up_write(&dmar_global_lock);
@@ -931,11 +974,32 @@ out:
 	return err;
 }
 
+static int dmar_alloc_seq_id(struct intel_iommu *iommu)
+{
+	iommu->seq_id = find_first_zero_bit(dmar_seq_ids,
+					    DMAR_UNITS_SUPPORTED);
+	if (iommu->seq_id >= DMAR_UNITS_SUPPORTED) {
+		iommu->seq_id = -1;
+	} else {
+		set_bit(iommu->seq_id, dmar_seq_ids);
+		sprintf(iommu->name, "dmar%d", iommu->seq_id);
+	}
+
+	return iommu->seq_id;
+}
+
+static void dmar_free_seq_id(struct intel_iommu *iommu)
+{
+	if (iommu->seq_id >= 0) {
+		clear_bit(iommu->seq_id, dmar_seq_ids);
+		iommu->seq_id = -1;
+	}
+}
+
 static int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	u32 ver, sts;
-	static int iommu_allocated = 0;
 	int agaw = 0;
 	int msagaw = 0;
 	int err;
@@ -949,13 +1013,16 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	if (!iommu)
 		return -ENOMEM;
 
-	iommu->seq_id = iommu_allocated++;
-	sprintf (iommu->name, "dmar%d", iommu->seq_id);
+	if (dmar_alloc_seq_id(iommu) < 0) {
+		pr_err("IOMMU: failed to allocate seq_id\n");
+		err = -ENOSPC;
+		goto error;
+	}
 
 	err = map_iommu(iommu, drhd->reg_base_addr);
 	if (err) {
 		pr_err("IOMMU: failed to map %s\n", iommu->name);
-		goto error;
+		goto error_free_seq_id;
 	}
 
 	err = -EINVAL;
@@ -1005,9 +1072,11 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	return 0;
 
- err_unmap:
+err_unmap:
 	unmap_iommu(iommu);
- error:
+error_free_seq_id:
+	dmar_free_seq_id(iommu);
+error:
 	kfree(iommu);
 	return err;
 }
@@ -1031,6 +1100,7 @@ static void free_iommu(struct intel_iommu *iommu)
 	if (iommu->reg)
 		unmap_iommu(iommu);
 
+	dmar_free_seq_id(iommu);
 	kfree(iommu);
 }
 
@@ -1661,12 +1731,17 @@ int __init dmar_ir_support(void)
 	return dmar->flags & 0x1;
 }
 
+/* Check whether DMAR units are in use */
+static inline bool dmar_in_use(void)
+{
+	return irq_remapping_enabled || intel_iommu_enabled;
+}
+
 static int __init dmar_free_unused_resources(void)
 {
 	struct dmar_drhd_unit *dmaru, *dmaru_n;
 
-	/* DMAR units are in use */
-	if (irq_remapping_enabled || intel_iommu_enabled)
+	if (dmar_in_use())
 		return 0;
 
 	if (dmar_dev_scope_status != 1 && !list_empty(&dmar_drhd_units))
@@ -1684,3 +1759,242 @@ static int __init dmar_free_unused_resources(void)
 
 late_initcall(dmar_free_unused_resources);
 IOMMU_INIT_POST(detect_intel_iommu);
+
+/*
+ * DMAR Hotplug Support
+ * For more details, please refer to Intel(R) Virtualization Technology
+ * for Directed-IO Architecture Specifiction, Rev 2.2, Section 8.8
+ * "Remapping Hardware Unit Hot Plug".
+ */
+static u8 dmar_hp_uuid[] = {
+	/* 0000 */    0xA6, 0xA3, 0xC1, 0xD8, 0x9B, 0xBE, 0x9B, 0x4C,
+	/* 0008 */    0x91, 0xBF, 0xC3, 0xCB, 0x81, 0xFC, 0x5D, 0xAF
+};
+
+/*
+ * Currently there's only one revision and BIOS will not check the revision id,
+ * so use 0 for safety.
+ */
+#define	DMAR_DSM_REV_ID			0
+#define	DMAR_DSM_FUNC_DRHD		1
+#define	DMAR_DSM_FUNC_ATSR		2
+#define	DMAR_DSM_FUNC_RHSA		3
+
+static inline bool dmar_detect_dsm(acpi_handle handle, int func)
+{
+	return acpi_check_dsm(handle, dmar_hp_uuid, DMAR_DSM_REV_ID, 1 << func);
+}
+
+static int dmar_walk_dsm_resource(acpi_handle handle, int func,
+				  dmar_res_handler_t handler, void *arg)
+{
+	int ret = -ENODEV;
+	union acpi_object *obj;
+	struct acpi_dmar_header *start;
+	struct dmar_res_callback callback;
+	static int res_type[] = {
+		[DMAR_DSM_FUNC_DRHD] = ACPI_DMAR_TYPE_HARDWARE_UNIT,
+		[DMAR_DSM_FUNC_ATSR] = ACPI_DMAR_TYPE_ROOT_ATS,
+		[DMAR_DSM_FUNC_RHSA] = ACPI_DMAR_TYPE_HARDWARE_AFFINITY,
+	};
+
+	if (!dmar_detect_dsm(handle, func))
+		return 0;
+
+	obj = acpi_evaluate_dsm_typed(handle, dmar_hp_uuid, DMAR_DSM_REV_ID,
+				      func, NULL, ACPI_TYPE_BUFFER);
+	if (!obj)
+		return -ENODEV;
+
+	memset(&callback, 0, sizeof(callback));
+	callback.cb[res_type[func]] = handler;
+	callback.arg[res_type[func]] = arg;
+	start = (struct acpi_dmar_header *)obj->buffer.pointer;
+	ret = dmar_walk_remapping_entries(start, obj->buffer.length, &callback);
+
+	ACPI_FREE(obj);
+
+	return ret;
+}
+
+static int dmar_hp_add_drhd(struct acpi_dmar_header *header, void *arg)
+{
+	int ret;
+	struct dmar_drhd_unit *dmaru;
+
+	dmaru = dmar_find_dmaru((struct acpi_dmar_hardware_unit *)header);
+	if (!dmaru)
+		return -ENODEV;
+
+	ret = dmar_ir_hotplug(dmaru, true);
+	if (ret == 0)
+		ret = dmar_iommu_hotplug(dmaru, true);
+
+	return ret;
+}
+
+static int dmar_hp_remove_drhd(struct acpi_dmar_header *header, void *arg)
+{
+	int i, ret;
+	struct device *dev;
+	struct dmar_drhd_unit *dmaru;
+
+	dmaru = dmar_find_dmaru((struct acpi_dmar_hardware_unit *)header);
+	if (!dmaru)
+		return 0;
+
+	/*
+	 * All PCI devices managed by this unit should have been destroyed.
+	 */
+	if (!dmaru->include_all && dmaru->devices && dmaru->devices_cnt)
+		for_each_active_dev_scope(dmaru->devices,
+					  dmaru->devices_cnt, i, dev)
+			return -EBUSY;
+
+	ret = dmar_ir_hotplug(dmaru, false);
+	if (ret == 0)
+		ret = dmar_iommu_hotplug(dmaru, false);
+
+	return ret;
+}
+
+static int dmar_hp_release_drhd(struct acpi_dmar_header *header, void *arg)
+{
+	struct dmar_drhd_unit *dmaru;
+
+	dmaru = dmar_find_dmaru((struct acpi_dmar_hardware_unit *)header);
+	if (dmaru) {
+		list_del_rcu(&dmaru->list);
+		synchronize_rcu();
+		dmar_free_drhd(dmaru);
+	}
+
+	return 0;
+}
+
+static int dmar_hotplug_insert(acpi_handle handle)
+{
+	int ret;
+	int drhd_count = 0;
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+				     &dmar_validate_one_drhd, (void *)1);
+	if (ret)
+		goto out;
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+				     &dmar_parse_one_drhd, (void *)&drhd_count);
+	if (ret == 0 && drhd_count == 0) {
+		pr_warn(FW_BUG "No DRHD structures in buffer returned by _DSM method\n");
+		goto out;
+	} else if (ret) {
+		goto release_drhd;
+	}
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_RHSA,
+				     &dmar_parse_one_rhsa, NULL);
+	if (ret)
+		goto release_drhd;
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
+				     &dmar_parse_one_atsr, NULL);
+	if (ret)
+		goto release_atsr;
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+				     &dmar_hp_add_drhd, NULL);
+	if (!ret)
+		return 0;
+
+	dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+			       &dmar_hp_remove_drhd, NULL);
+release_atsr:
+	dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
+			       &dmar_release_one_atsr, NULL);
+release_drhd:
+	dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+			       &dmar_hp_release_drhd, NULL);
+out:
+	return ret;
+}
+
+static int dmar_hotplug_remove(acpi_handle handle)
+{
+	int ret;
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
+				     &dmar_check_one_atsr, NULL);
+	if (ret)
+		return ret;
+
+	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+				     &dmar_hp_remove_drhd, NULL);
+	if (ret == 0) {
+		WARN_ON(dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
+					       &dmar_release_one_atsr, NULL));
+		WARN_ON(dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+					       &dmar_hp_release_drhd, NULL));
+	} else {
+		dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
+				       &dmar_hp_add_drhd, NULL);
+	}
+
+	return ret;
+}
+
+static acpi_status dmar_get_dsm_handle(acpi_handle handle, u32 lvl,
+				       void *context, void **retval)
+{
+	acpi_handle *phdl = retval;
+
+	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
+		*phdl = handle;
+		return AE_CTRL_TERMINATE;
+	}
+
+	return AE_OK;
+}
+
+static int dmar_device_hotplug(acpi_handle handle, bool insert)
+{
+	int ret;
+	acpi_handle tmp = NULL;
+	acpi_status status;
+
+	if (!dmar_in_use())
+		return 0;
+
+	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
+		tmp = handle;
+	} else {
+		status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+					     ACPI_UINT32_MAX,
+					     dmar_get_dsm_handle,
+					     NULL, NULL, &tmp);
+		if (ACPI_FAILURE(status)) {
+			pr_warn("Failed to locate _DSM method.\n");
+			return -ENXIO;
+		}
+	}
+	if (tmp == NULL)
+		return 0;
+
+	down_write(&dmar_global_lock);
+	if (insert)
+		ret = dmar_hotplug_insert(tmp);
+	else
+		ret = dmar_hotplug_remove(tmp);
+	up_write(&dmar_global_lock);
+
+	return ret;
+}
+
+int dmar_device_add(acpi_handle handle)
+{
+	return dmar_device_hotplug(handle, true);
+}
+
+int dmar_device_remove(acpi_handle handle)
+{
+	return dmar_device_hotplug(handle, false);
+}
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 02cd26a17fe0..ea3b13afd940 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -195,6 +195,7 @@ static inline void set_root_present(struct root_entry *root)
 }
 static inline void set_root_value(struct root_entry *root, unsigned long value)
 {
+	root->val &= ~VTD_PAGE_MASK;
 	root->val |= value & VTD_PAGE_MASK;
 }
 
@@ -247,6 +248,7 @@ static inline void context_set_translation_type(struct context_entry *context,
 static inline void context_set_address_root(struct context_entry *context,
 					    unsigned long value)
 {
+	context->lo &= ~VTD_PAGE_MASK;
 	context->lo |= value & VTD_PAGE_MASK;
 }
 
@@ -328,17 +330,10 @@ static int hw_pass_through = 1;
 /* si_domain contains mulitple devices */
 #define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 1)
 
-/* define the limit of IOMMUs supported in each domain */
-#ifdef	CONFIG_X86
-# define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
-#else
-# define	IOMMU_UNITS_SUPPORTED	64
-#endif
-
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
+	DECLARE_BITMAP(iommu_bmp, DMAR_UNITS_SUPPORTED);
 					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
@@ -1132,8 +1127,11 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 	unsigned long flags;
 
 	root = (struct root_entry *)alloc_pgtable_page(iommu->node);
-	if (!root)
+	if (!root) {
+		pr_err("IOMMU: allocating root entry for %s failed\n",
+			iommu->name);
 		return -ENOMEM;
+	}
 
 	__iommu_flush_cache(iommu, root, ROOT_SIZE);
 
@@ -1473,7 +1471,7 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	return 0;
 }
 
-static void free_dmar_iommu(struct intel_iommu *iommu)
+static void disable_dmar_iommu(struct intel_iommu *iommu)
 {
 	struct dmar_domain *domain;
 	int i;
@@ -1497,11 +1495,16 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 	if (iommu->gcmd & DMA_GCMD_TE)
 		iommu_disable_translation(iommu);
+}
 
-	kfree(iommu->domains);
-	kfree(iommu->domain_ids);
-	iommu->domains = NULL;
-	iommu->domain_ids = NULL;
+static void free_dmar_iommu(struct intel_iommu *iommu)
+{
+	if ((iommu->domains) && (iommu->domain_ids)) {
+		kfree(iommu->domains);
+		kfree(iommu->domain_ids);
+		iommu->domains = NULL;
+		iommu->domain_ids = NULL;
+	}
 
 	g_iommus[iommu->seq_id] = NULL;
 
@@ -2708,6 +2711,41 @@ static int __init iommu_prepare_static_identity_mapping(int hw)
 	return 0;
 }
 
+static void intel_iommu_init_qi(struct intel_iommu *iommu)
+{
+	/*
+	 * Start from the sane iommu hardware state.
+	 * If the queued invalidation is already initialized by us
+	 * (for example, while enabling interrupt-remapping) then
+	 * we got the things already rolling from a sane state.
+	 */
+	if (!iommu->qi) {
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(-1, iommu);
+		/*
+		 * Disable queued invalidation if supported and already enabled
+		 * before OS handover.
+		 */
+		dmar_disable_qi(iommu);
+	}
+
+	if (dmar_enable_qi(iommu)) {
+		/*
+		 * Queued Invalidate not enabled, use Register Based Invalidate
+		 */
+		iommu->flush.flush_context = __iommu_flush_context;
+		iommu->flush.flush_iotlb = __iommu_flush_iotlb;
+		pr_info("IOMMU: %s using Register based invalidation\n",
+			iommu->name);
+	} else {
+		iommu->flush.flush_context = qi_flush_context;
+		iommu->flush.flush_iotlb = qi_flush_iotlb;
+		pr_info("IOMMU: %s using Queued invalidation\n", iommu->name);
+	}
+}
+
 static int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2728,14 +2766,18 @@ static int __init init_dmars(void)
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
-		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED) {
+		if (g_num_of_iommus < DMAR_UNITS_SUPPORTED) {
 			g_num_of_iommus++;
 			continue;
 		}
 		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
-			  IOMMU_UNITS_SUPPORTED);
+			  DMAR_UNITS_SUPPORTED);
 	}
 
+	/* Preallocate enough resources for IOMMU hot-addition */
+	if (g_num_of_iommus < DMAR_UNITS_SUPPORTED)
+		g_num_of_iommus = DMAR_UNITS_SUPPORTED;
+
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
 			GFP_KERNEL);
 	if (!g_iommus) {
@@ -2764,58 +2806,14 @@ static int __init init_dmars(void)
 		 * among all IOMMU's. Need to Split it later.
 		 */
 		ret = iommu_alloc_root_entry(iommu);
-		if (ret) {
-			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+		if (ret)
 			goto free_iommu;
-		}
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
 
-	/*
-	 * Start from the sane iommu hardware state.
-	 */
-	for_each_active_iommu(iommu, drhd) {
-		/*
-		 * If the queued invalidation is already initialized by us
-		 * (for example, while enabling interrupt-remapping) then
-		 * we got the things already rolling from a sane state.
-		 */
-		if (iommu->qi)
-			continue;
-
-		/*
-		 * Clear any previous faults.
-		 */
-		dmar_fault(-1, iommu);
-		/*
-		 * Disable queued invalidation if supported and already enabled
-		 * before OS handover.
-		 */
-		dmar_disable_qi(iommu);
-	}
-
-	for_each_active_iommu(iommu, drhd) {
-		if (dmar_enable_qi(iommu)) {
-			/*
-			 * Queued Invalidate not enabled, use Register Based
-			 * Invalidate
-			 */
-			iommu->flush.flush_context = __iommu_flush_context;
-			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
-			printk(KERN_INFO "IOMMU %d 0x%Lx: using Register based "
-			       "invalidation\n",
-				iommu->seq_id,
-			       (unsigned long long)drhd->reg_base_addr);
-		} else {
-			iommu->flush.flush_context = qi_flush_context;
-			iommu->flush.flush_iotlb = qi_flush_iotlb;
-			printk(KERN_INFO "IOMMU %d 0x%Lx: using Queued "
-			       "invalidation\n",
-				iommu->seq_id,
-			       (unsigned long long)drhd->reg_base_addr);
-		}
-	}
+	for_each_active_iommu(iommu, drhd)
+		intel_iommu_init_qi(iommu);
 
 	if (iommu_pass_through)
 		iommu_identity_mapping |= IDENTMAP_ALL;
@@ -2901,8 +2899,10 @@ static int __init init_dmars(void)
 	return 0;
 
 free_iommu:
-	for_each_active_iommu(iommu, drhd)
+	for_each_active_iommu(iommu, drhd) {
+		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
+	}
 	kfree(deferred_flush);
 free_g_iommus:
 	kfree(g_iommus);
@@ -3682,7 +3682,7 @@ static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
 
-int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
 {
 	struct acpi_dmar_reserved_memory *rmrr;
 	struct dmar_rmrr_unit *rmrru;
@@ -3708,17 +3708,48 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 	return 0;
 }
 
-int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
+static struct dmar_atsr_unit *dmar_find_atsr(struct acpi_dmar_atsr *atsr)
+{
+	struct dmar_atsr_unit *atsru;
+	struct acpi_dmar_atsr *tmp;
+
+	list_for_each_entry_rcu(atsru, &dmar_atsr_units, list) {
+		tmp = (struct acpi_dmar_atsr *)atsru->hdr;
+		if (atsr->segment != tmp->segment)
+			continue;
+		if (atsr->header.length != tmp->header.length)
+			continue;
+		if (memcmp(atsr, tmp, atsr->header.length) == 0)
+			return atsru;
+	}
+
+	return NULL;
+}
+
+int dmar_parse_one_atsr(struct acpi_dmar_header *hdr, void *arg)
 {
 	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
 
+	if (system_state != SYSTEM_BOOTING && !intel_iommu_enabled)
+		return 0;
+
 	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
-	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
+	atsru = dmar_find_atsr(atsr);
+	if (atsru)
+		return 0;
+
+	atsru = kzalloc(sizeof(*atsru) + hdr->length, GFP_KERNEL);
 	if (!atsru)
 		return -ENOMEM;
 
-	atsru->hdr = hdr;
+	/*
+	 * If memory is allocated from slab by ACPI _DSM method, we need to
+	 * copy the memory content because the memory buffer will be freed
+	 * on return.
+	 */
+	atsru->hdr = (void *)(atsru + 1);
+	memcpy(atsru->hdr, hdr, hdr->length);
 	atsru->include_all = atsr->flags & 0x1;
 	if (!atsru->include_all) {
 		atsru->devices = dmar_alloc_dev_scope((void *)(atsr + 1),
@@ -3741,6 +3772,138 @@ static void intel_iommu_free_atsr(struct dmar_atsr_unit *atsru)
 	kfree(atsru);
 }
 
+int dmar_release_one_atsr(struct acpi_dmar_header *hdr, void *arg)
+{
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
+	atsru = dmar_find_atsr(atsr);
+	if (atsru) {
+		list_del_rcu(&atsru->list);
+		synchronize_rcu();
+		intel_iommu_free_atsr(atsru);
+	}
+
+	return 0;
+}
+
+int dmar_check_one_atsr(struct acpi_dmar_header *hdr, void *arg)
+{
+	int i;
+	struct device *dev;
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
+	atsru = dmar_find_atsr(atsr);
+	if (!atsru)
+		return 0;
+
+	if (!atsru->include_all && atsru->devices && atsru->devices_cnt)
+		for_each_active_dev_scope(atsru->devices, atsru->devices_cnt,
+					  i, dev)
+			return -EBUSY;
+
+	return 0;
+}
+
+static int intel_iommu_add(struct dmar_drhd_unit *dmaru)
+{
+	int sp, ret = 0;
+	struct intel_iommu *iommu = dmaru->iommu;
+
+	if (g_iommus[iommu->seq_id])
+		return 0;
+
+	if (hw_pass_through && !ecap_pass_through(iommu->ecap)) {
+		pr_warn("IOMMU: %s doesn't support hardware pass through.\n",
+			iommu->name);
+		return -ENXIO;
+	}
+	if (!ecap_sc_support(iommu->ecap) &&
+	    domain_update_iommu_snooping(iommu)) {
+		pr_warn("IOMMU: %s doesn't support snooping.\n",
+			iommu->name);
+		return -ENXIO;
+	}
+	sp = domain_update_iommu_superpage(iommu) - 1;
+	if (sp >= 0 && !(cap_super_page_val(iommu->cap) & (1 << sp))) {
+		pr_warn("IOMMU: %s doesn't support large page.\n",
+			iommu->name);
+		return -ENXIO;
+	}
+
+	/*
+	 * Disable translation if already enabled prior to OS handover.
+	 */
+	if (iommu->gcmd & DMA_GCMD_TE)
+		iommu_disable_translation(iommu);
+
+	g_iommus[iommu->seq_id] = iommu;
+	ret = iommu_init_domains(iommu);
+	if (ret == 0)
+		ret = iommu_alloc_root_entry(iommu);
+	if (ret)
+		goto out;
+
+	if (dmaru->ignored) {
+		/*
+		 * we always have to disable PMRs or DMA may fail on this device
+		 */
+		if (force_on)
+			iommu_disable_protect_mem_regions(iommu);
+		return 0;
+	}
+
+	intel_iommu_init_qi(iommu);
+	iommu_flush_write_buffer(iommu);
+	ret = dmar_set_interrupt(iommu);
+	if (ret)
+		goto disable_iommu;
+
+	iommu_set_root_entry(iommu);
+	iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
+	iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
+	iommu_enable_translation(iommu);
+
+	if (si_domain) {
+		ret = iommu_attach_domain(si_domain, iommu);
+		if (ret < 0 || si_domain->id != ret)
+			goto disable_iommu;
+		domain_attach_iommu(si_domain, iommu);
+	}
+
+	iommu_disable_protect_mem_regions(iommu);
+	return 0;
+
+disable_iommu:
+	disable_dmar_iommu(iommu);
+out:
+	free_dmar_iommu(iommu);
+	return ret;
+}
+
+int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
+{
+	int ret = 0;
+	struct intel_iommu *iommu = dmaru->iommu;
+
+	if (!intel_iommu_enabled)
+		return 0;
+	if (iommu == NULL)
+		return -EINVAL;
+
+	if (insert) {
+		ret = intel_iommu_add(dmaru);
+	} else {
+		disable_dmar_iommu(iommu);
+		free_dmar_iommu(iommu);
+	}
+
+	return ret;
+}
+
 static void intel_iommu_free_dmars(void)
 {
 	struct dmar_rmrr_unit *rmrru, *rmrr_n;
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 7c80661b35c1..a55b207b9425 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -36,7 +36,6 @@ struct hpet_scope {
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
-static int ir_ioapic_num, ir_hpet_num;
 
 /*
  * Lock ordering:
@@ -55,7 +54,7 @@ static int __init parse_ioapics_under_ir(void);
 
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	return cfg ? &cfg->irq_2_iommu : NULL;
 }
 
@@ -86,7 +85,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
 	int index;
@@ -154,7 +153,7 @@ static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	if (!irq_iommu)
@@ -206,7 +205,7 @@ static struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
 	int i;
 
 	for (i = 0; i < MAX_HPET_TBS; i++)
-		if (ir_hpet[i].id == hpet_id)
+		if (ir_hpet[i].id == hpet_id && ir_hpet[i].iommu)
 			return ir_hpet[i].iommu;
 	return NULL;
 }
@@ -216,7 +215,7 @@ static struct intel_iommu *map_ioapic_to_ir(int apic)
 	int i;
 
 	for (i = 0; i < MAX_IO_APICS; i++)
-		if (ir_ioapic[i].id == apic)
+		if (ir_ioapic[i].id == apic && ir_ioapic[i].iommu)
 			return ir_ioapic[i].iommu;
 	return NULL;
 }
@@ -325,7 +324,7 @@ static int set_ioapic_sid(struct irte *irte, int apic)
 
 	down_read(&dmar_global_lock);
 	for (i = 0; i < MAX_IO_APICS; i++) {
-		if (ir_ioapic[i].id == apic) {
+		if (ir_ioapic[i].iommu && ir_ioapic[i].id == apic) {
 			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
 			break;
 		}
@@ -352,7 +351,7 @@ static int set_hpet_sid(struct irte *irte, u8 id)
 
 	down_read(&dmar_global_lock);
 	for (i = 0; i < MAX_HPET_TBS; i++) {
-		if (ir_hpet[i].id == id) {
+		if (ir_hpet[i].iommu && ir_hpet[i].id == id) {
 			sid = (ir_hpet[i].bus << 8) | ir_hpet[i].devfn;
 			break;
 		}
@@ -473,17 +472,17 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
-
-static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
+static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 {
 	struct ir_table *ir_table;
 	struct page *pages;
 	unsigned long *bitmap;
 
-	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
-					     GFP_ATOMIC);
+	if (iommu->ir_table)
+		return 0;
 
-	if (!iommu->ir_table)
+	ir_table = kzalloc(sizeof(struct ir_table), GFP_ATOMIC);
+	if (!ir_table)
 		return -ENOMEM;
 
 	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
@@ -492,24 +491,37 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 	if (!pages) {
 		pr_err("IR%d: failed to allocate pages of order %d\n",
 		       iommu->seq_id, INTR_REMAP_PAGE_ORDER);
-		kfree(iommu->ir_table);
-		return -ENOMEM;
+		goto out_free_table;
 	}
 
 	bitmap = kcalloc(BITS_TO_LONGS(INTR_REMAP_TABLE_ENTRIES),
 			 sizeof(long), GFP_ATOMIC);
 	if (bitmap == NULL) {
 		pr_err("IR%d: failed to allocate bitmap\n", iommu->seq_id);
-		__free_pages(pages, INTR_REMAP_PAGE_ORDER);
-		kfree(ir_table);
-		return -ENOMEM;
+		goto out_free_pages;
 	}
 
 	ir_table->base = page_address(pages);
 	ir_table->bitmap = bitmap;
-
-	iommu_set_irq_remapping(iommu, mode);
+	iommu->ir_table = ir_table;
 	return 0;
+
+out_free_pages:
+	__free_pages(pages, INTR_REMAP_PAGE_ORDER);
+out_free_table:
+	kfree(ir_table);
+	return -ENOMEM;
+}
+
+static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
+{
+	if (iommu && iommu->ir_table) {
+		free_pages((unsigned long)iommu->ir_table->base,
+			   INTR_REMAP_PAGE_ORDER);
+		kfree(iommu->ir_table->bitmap);
+		kfree(iommu->ir_table);
+		iommu->ir_table = NULL;
+	}
 }
 
 /*
@@ -666,9 +678,10 @@ static int __init intel_enable_irq_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		if (intel_setup_irq_remapping(iommu, eim))
+		if (intel_setup_irq_remapping(iommu))
 			goto error;
 
+		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
 
@@ -689,9 +702,11 @@ static int __init intel_enable_irq_remapping(void)
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
 
 error:
-	/*
-	 * handle error condition gracefully here!
-	 */
+	for_each_iommu(iommu, drhd)
+		if (ecap_ir_support(iommu->ecap)) {
+			iommu_disable_irq_remapping(iommu);
+			intel_teardown_irq_remapping(iommu);
+		}
 
 	if (x2apic_present)
 		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
@@ -699,12 +714,13 @@ error:
 	return -1;
 }
 
-static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
-				      struct intel_iommu *iommu)
+static int ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
+				   struct intel_iommu *iommu,
+				   struct acpi_dmar_hardware_unit *drhd)
 {
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
-	int count;
+	int count, free = -1;
 
 	bus = scope->bus;
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
@@ -720,19 +736,36 @@ static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
 					   PCI_SECONDARY_BUS);
 		path++;
 	}
-	ir_hpet[ir_hpet_num].bus   = bus;
-	ir_hpet[ir_hpet_num].devfn = PCI_DEVFN(path->device, path->function);
-	ir_hpet[ir_hpet_num].iommu = iommu;
-	ir_hpet[ir_hpet_num].id    = scope->enumeration_id;
-	ir_hpet_num++;
+
+	for (count = 0; count < MAX_HPET_TBS; count++) {
+		if (ir_hpet[count].iommu == iommu &&
+		    ir_hpet[count].id == scope->enumeration_id)
+			return 0;
+		else if (ir_hpet[count].iommu == NULL && free == -1)
+			free = count;
+	}
+	if (free == -1) {
+		pr_warn("Exceeded Max HPET blocks\n");
+		return -ENOSPC;
+	}
+
+	ir_hpet[free].iommu = iommu;
+	ir_hpet[free].id    = scope->enumeration_id;
+	ir_hpet[free].bus   = bus;
+	ir_hpet[free].devfn = PCI_DEVFN(path->device, path->function);
+	pr_info("HPET id %d under DRHD base 0x%Lx\n",
+		scope->enumeration_id, drhd->address);
+
+	return 0;
 }
 
-static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
-				      struct intel_iommu *iommu)
+static int ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
+				     struct intel_iommu *iommu,
+				     struct acpi_dmar_hardware_unit *drhd)
 {
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
-	int count;
+	int count, free = -1;
 
 	bus = scope->bus;
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
@@ -749,54 +782,63 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 		path++;
 	}
 
-	ir_ioapic[ir_ioapic_num].bus   = bus;
-	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->device, path->function);
-	ir_ioapic[ir_ioapic_num].iommu = iommu;
-	ir_ioapic[ir_ioapic_num].id    = scope->enumeration_id;
-	ir_ioapic_num++;
+	for (count = 0; count < MAX_IO_APICS; count++) {
+		if (ir_ioapic[count].iommu == iommu &&
+		    ir_ioapic[count].id == scope->enumeration_id)
+			return 0;
+		else if (ir_ioapic[count].iommu == NULL && free == -1)
+			free = count;
+	}
+	if (free == -1) {
+		pr_warn("Exceeded Max IO APICS\n");
+		return -ENOSPC;
+	}
+
+	ir_ioapic[free].bus   = bus;
+	ir_ioapic[free].devfn = PCI_DEVFN(path->device, path->function);
+	ir_ioapic[free].iommu = iommu;
+	ir_ioapic[free].id    = scope->enumeration_id;
+	pr_info("IOAPIC id %d under DRHD base  0x%Lx IOMMU %d\n",
+		scope->enumeration_id, drhd->address, iommu->seq_id);
+
+	return 0;
 }
 
 static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
 				      struct intel_iommu *iommu)
 {
+	int ret = 0;
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_device_scope *scope;
 	void *start, *end;
 
 	drhd = (struct acpi_dmar_hardware_unit *)header;
-
 	start = (void *)(drhd + 1);
 	end = ((void *)drhd) + header->length;
 
-	while (start < end) {
+	while (start < end && ret == 0) {
 		scope = start;
-		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
-			if (ir_ioapic_num == MAX_IO_APICS) {
-				printk(KERN_WARNING "Exceeded Max IO APICS\n");
-				return -1;
-			}
-
-			printk(KERN_INFO "IOAPIC id %d under DRHD base "
-			       " 0x%Lx IOMMU %d\n", scope->enumeration_id,
-			       drhd->address, iommu->seq_id);
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC)
+			ret = ir_parse_one_ioapic_scope(scope, iommu, drhd);
+		else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET)
+			ret = ir_parse_one_hpet_scope(scope, iommu, drhd);
+		start += scope->length;
+	}
 
-			ir_parse_one_ioapic_scope(scope, iommu);
-		} else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET) {
-			if (ir_hpet_num == MAX_HPET_TBS) {
-				printk(KERN_WARNING "Exceeded Max HPET blocks\n");
-				return -1;
-			}
+	return ret;
+}
 
-			printk(KERN_INFO "HPET id %d under DRHD base"
-			       " 0x%Lx\n", scope->enumeration_id,
-			       drhd->address);
+static void ir_remove_ioapic_hpet_scope(struct intel_iommu *iommu)
+{
+	int i;
 
-			ir_parse_one_hpet_scope(scope, iommu);
-		}
-		start += scope->length;
-	}
+	for (i = 0; i < MAX_HPET_TBS; i++)
+		if (ir_hpet[i].iommu == iommu)
+			ir_hpet[i].iommu = NULL;
 
-	return 0;
+	for (i = 0; i < MAX_IO_APICS; i++)
+		if (ir_ioapic[i].iommu == iommu)
+			ir_ioapic[i].iommu = NULL;
 }
 
 /*
@@ -1008,7 +1050,7 @@ static int
 intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			  bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
 	int err;
@@ -1063,7 +1105,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 	u16 sub_handle = 0;
 	int ir_index;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 
 	ir_index = map_irq_to_irte_handle(irq, &sub_handle);
 	BUG_ON(ir_index == -1);
@@ -1171,3 +1213,86 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.msi_setup_irq		= intel_msi_setup_irq,
 	.alloc_hpet_msi		= intel_alloc_hpet_msi,
 };
+
+/*
+ * Support of Interrupt Remapping Unit Hotplug
+ */
+static int dmar_ir_add(struct dmar_drhd_unit *dmaru, struct intel_iommu *iommu)
+{
+	int ret;
+	int eim = x2apic_enabled();
+
+	if (eim && !ecap_eim_support(iommu->ecap)) {
+		pr_info("DRHD %Lx: EIM not supported by DRHD, ecap %Lx\n",
+			iommu->reg_phys, iommu->ecap);
+		return -ENODEV;
+	}
+
+	if (ir_parse_ioapic_hpet_scope(dmaru->hdr, iommu)) {
+		pr_warn("DRHD %Lx: failed to parse managed IOAPIC/HPET\n",
+			iommu->reg_phys);
+		return -ENODEV;
+	}
+
+	/* TODO: check all IOAPICs are covered by IOMMU */
+
+	/* Setup Interrupt-remapping now. */
+	ret = intel_setup_irq_remapping(iommu);
+	if (ret) {
+		pr_err("DRHD %Lx: failed to allocate resource\n",
+		       iommu->reg_phys);
+		ir_remove_ioapic_hpet_scope(iommu);
+		return ret;
+	}
+
+	if (!iommu->qi) {
+		/* Clear previous faults. */
+		dmar_fault(-1, iommu);
+		iommu_disable_irq_remapping(iommu);
+		dmar_disable_qi(iommu);
+	}
+
+	/* Enable queued invalidation */
+	ret = dmar_enable_qi(iommu);
+	if (!ret) {
+		iommu_set_irq_remapping(iommu, eim);
+	} else {
+		pr_err("DRHD %Lx: failed to enable queued invalidation, ecap %Lx, ret %d\n",
+		       iommu->reg_phys, iommu->ecap, ret);
+		intel_teardown_irq_remapping(iommu);
+		ir_remove_ioapic_hpet_scope(iommu);
+	}
+
+	return ret;
+}
+
+int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
+{
+	int ret = 0;
+	struct intel_iommu *iommu = dmaru->iommu;
+
+	if (!irq_remapping_enabled)
+		return 0;
+	if (iommu == NULL)
+		return -EINVAL;
+	if (!ecap_ir_support(iommu->ecap))
+		return 0;
+
+	if (insert) {
+		if (!iommu->ir_table)
+			ret = dmar_ir_add(dmaru, iommu);
+	} else {
+		if (iommu->ir_table) {
+			if (!bitmap_empty(iommu->ir_table->bitmap,
+					  INTR_REMAP_TABLE_ENTRIES)) {
+				ret = -EBUSY;
+			} else {
+				iommu_disable_irq_remapping(iommu);
+				intel_teardown_irq_remapping(iommu);
+				ir_remove_ioapic_hpet_scope(iommu);
+			}
+		}
+	}
+
+	return ret;
+}
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 2c3f5ad01098..89c4846683be 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -298,7 +298,7 @@ static int set_remapped_irq_affinity(struct irq_data *data,
 
 void free_remapped_irq(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
@@ -311,7 +311,7 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
 			      unsigned int irq, unsigned int dest,
 			      struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!irq_remapped(cfg))
 		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
@@ -364,7 +364,7 @@ static void ir_ack_apic_edge(struct irq_data *data)
 static void ir_ack_apic_level(struct irq_data *data)
 {
 	ack_APIC_irq();
-	eoi_ioapic_irq(data->irq, data->chip_data);
+	eoi_ioapic_irq(data->irq, irqd_cfg(data));
 }
 
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index cced84233ac0..7a8f1c5e65af 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -67,7 +67,7 @@ config XEN_PCIDEV_FRONTEND
 config HT_IRQ
 	bool "Interrupts on hypertransport devices"
 	default y
-	depends on PCI && X86_LOCAL_APIC && X86_IO_APIC
+	depends on PCI && X86_LOCAL_APIC
 	help
 	   This allows native hypertransport devices to use interrupts.
 
@@ -110,13 +110,6 @@ config PCI_PASID
 
 	  If unsure, say N.
 
-config PCI_IOAPIC
-	bool "PCI IO-APIC hotplug support" if X86
-	depends on PCI
-	depends on ACPI
-	depends on X86_IO_APIC
-	default !X86
-
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e04fe2d9df3b..73e4af400a5a 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -13,8 +13,6 @@ obj-$(CONFIG_PCI_QUIRKS) += quirks.o
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
 
-obj-$(CONFIG_PCI_IOAPIC) += ioapic.o
-
 # Build the PCI Hotplug drivers if we were asked to
 obj-$(CONFIG_HOTPLUG_PCI) += hotplug/
 ifdef CONFIG_HOTPLUG_PCI
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 3efaf4c38528..96c5c729cdbc 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -36,6 +36,7 @@
 #include <linux/wait.h>
 #include "../pci.h"
 #include <asm/pci_x86.h>		/* for struct irq_routing_table */
+#include <asm/io_apic.h>
 #include "ibmphp.h"
 
 #define attn_on(sl)  ibmphp_hpc_writeslot (sl, HPC_SLOT_ATTNON)
@@ -155,13 +156,10 @@ int ibmphp_init_devno(struct slot **cur_slot)
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot &&
 		    (*cur_slot)->bus == rtable->slots[loop].bus) {
-			struct io_apic_irq_attr irq_attr;
-
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i,
-						&irq_attr);
+						(int) (*cur_slot)->device, i);
 
 			debug("(*cur_slot)->irq[0] = %x\n",
 					(*cur_slot)->irq[0]);
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
deleted file mode 100644
index f6219d36227f..000000000000
--- a/drivers/pci/ioapic.c
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * IOAPIC/IOxAPIC/IOSAPIC driver
- *
- * Copyright (C) 2009 Fujitsu Limited.
- * (c) Copyright 2009 Hewlett-Packard Development Company, L.P.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/*
- * This driver manages PCI I/O APICs added by hotplug after boot.  We try to
- * claim all I/O APIC PCI devices, but those present at boot were registered
- * when we parsed the ACPI MADT, so we'll fail when we try to re-register
- * them.
- */
-
-#include <linux/pci.h>
-#include <linux/module.h>
-#include <linux/acpi.h>
-#include <linux/slab.h>
-
-struct ioapic {
-	acpi_handle	handle;
-	u32		gsi_base;
-};
-
-static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
-{
-	acpi_handle handle;
-	acpi_status status;
-	unsigned long long gsb;
-	struct ioapic *ioapic;
-	int ret;
-	char *type;
-	struct resource *res;
-
-	handle = ACPI_HANDLE(&dev->dev);
-	if (!handle)
-		return -EINVAL;
-
-	status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
-	if (ACPI_FAILURE(status))
-		return -EINVAL;
-
-	/*
-	 * The previous code in acpiphp evaluated _MAT if _GSB failed, but
-	 * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O APICs.
-	 */
-
-	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
-	if (!ioapic)
-		return -ENOMEM;
-
-	ioapic->handle = handle;
-	ioapic->gsi_base = (u32) gsb;
-
-	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
-		type = "IOAPIC";
-	else
-		type = "IOxAPIC";
-
-	ret = pci_enable_device(dev);
-	if (ret < 0)
-		goto exit_free;
-
-	pci_set_master(dev);
-
-	if (pci_request_region(dev, 0, type))
-		goto exit_disable;
-
-	res = &dev->resource[0];
-	if (acpi_register_ioapic(ioapic->handle, res->start, ioapic->gsi_base))
-		goto exit_release;
-
-	pci_set_drvdata(dev, ioapic);
-	dev_info(&dev->dev, "%s at %pR, GSI %u\n", type, res, ioapic->gsi_base);
-	return 0;
-
-exit_release:
-	pci_release_region(dev, 0);
-exit_disable:
-	pci_disable_device(dev);
-exit_free:
-	kfree(ioapic);
-	return -ENODEV;
-}
-
-static void ioapic_remove(struct pci_dev *dev)
-{
-	struct ioapic *ioapic = pci_get_drvdata(dev);
-
-	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
-	pci_release_region(dev, 0);
-	pci_disable_device(dev);
-	kfree(ioapic);
-}
-
-
-static const struct pci_device_id ioapic_devices[] = {
-	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
-	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, ioapic_devices);
-
-static struct pci_driver ioapic_driver = {
-	.name		= "ioapic",
-	.id_table	= ioapic_devices,
-	.probe		= ioapic_probe,
-	.remove		= ioapic_remove,
-};
-
-static int __init ioapic_init(void)
-{
-	return pci_register_driver(&ioapic_driver);
-}
-module_init(ioapic_init);
-
-MODULE_LICENSE("GPL");
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 407a12f663eb..a81dd437a53c 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -148,6 +148,7 @@ int acpi_unmap_lsapic(int cpu);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base);
 void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 extern u32 acpi_irq_not_handled;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 593fff99e6bf..30624954dec5 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -30,6 +30,12 @@
 
 struct acpi_dmar_header;
 
+#ifdef	CONFIG_X86
+# define	DMAR_UNITS_SUPPORTED	MAX_IO_APICS
+#else
+# define	DMAR_UNITS_SUPPORTED	64
+#endif
+
 /* DMAR Flags */
 #define DMAR_INTR_REMAP		0x1
 #define DMAR_X2APIC_OPT_OUT	0x2
@@ -120,28 +126,60 @@ extern int dmar_remove_dev_scope(struct dmar_pci_notify_info *info,
 /* Intel IOMMU detection */
 extern int detect_intel_iommu(void);
 extern int enable_drhd_fault_handling(void);
+extern int dmar_device_add(acpi_handle handle);
+extern int dmar_device_remove(acpi_handle handle);
+
+static inline int dmar_res_noop(struct acpi_dmar_header *hdr, void *arg)
+{
+	return 0;
+}
 
 #ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
 extern int intel_iommu_init(void);
-extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
-extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
+extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg);
+extern int dmar_parse_one_atsr(struct acpi_dmar_header *header, void *arg);
+extern int dmar_check_one_atsr(struct acpi_dmar_header *hdr, void *arg);
+extern int dmar_release_one_atsr(struct acpi_dmar_header *hdr, void *arg);
+extern int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert);
 extern int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info);
 #else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
-static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+
+#define	dmar_parse_one_rmrr		dmar_res_noop
+#define	dmar_parse_one_atsr		dmar_res_noop
+#define	dmar_check_one_atsr		dmar_res_noop
+#define	dmar_release_one_atsr		dmar_res_noop
+
+static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
 {
 	return 0;
 }
-static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
+
+static inline int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
 {
 	return 0;
 }
-static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
+#endif /* CONFIG_INTEL_IOMMU */
+
+#ifdef CONFIG_IRQ_REMAP
+extern int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert);
+#else  /* CONFIG_IRQ_REMAP */
+static inline int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
+{ return 0; }
+#endif /* CONFIG_IRQ_REMAP */
+
+#else /* CONFIG_DMAR_TABLE */
+
+static inline int dmar_device_add(void *handle)
+{
+	return 0;
+}
+
+static inline int dmar_device_remove(void *handle)
 {
 	return 0;
 }
-#endif /* CONFIG_INTEL_IOMMU */
 
 #endif /* CONFIG_DMAR_TABLE */
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a523cee3abb5..c888c5e4e225 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -349,6 +349,7 @@ struct pci_dev {
 	unsigned int	__aer_firmware_first:1;
 	unsigned int	broken_intx_masking:1;
 	unsigned int	io_window_1k:1;	/* Intel P2P bridge 1K I/O windows */
+	unsigned int	irq_managed:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
