Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaLINo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:44:27 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48878 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaLINoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:44:25 -0500
Date: Tue, 9 Dec 2014 14:44:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/ras tree changes for v3.19
Message-ID: <20141209134420.GA32354@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   # HEAD: c7c9b3929b6a57ad47ab4021c77e46f7ff21c007 x86/mce: Spell "panicked" correctly

The biggest change in this cycle is better support for UCNA 
(UnCorrected No Action) events:

    "Handle all uncorrected error reports in the same way (soft 
     offline the page). We used to only do that for SRAO 
     (software recoverable action optional) machine checks, but 
     it makes sense to also do it for UCNA (UnCorrected No 
     Action) logs found by CMCI or polling."

plus various x86 MCE handling updates and fixes.

  out-of-topic modifications in x86-ras-for-linus:
  --------------------------------------------------
  drivers/acpi/apei/ghes.c           # 8f7c31f6cd49: GHES: Make ghes_estatus_cach
                                   # 8d21d4c91efa: APEI, GHES: Cleanup unnecess
  drivers/edac/mce_amd.h             # e3480271f592: x86, mce, severity: Extend t
  mm/memory-failure.c                # 6dc52cbe0b18: RAS, HWPOISON: Fix wrong err

 Thanks,

	Ingo

------------------>
Borislav Petkov (3):
      GHES: Make ghes_estatus_caches static
      x86, MCE, AMD: Drop software-defined bank in error thresholding
      x86/mce: Spell "panicked" correctly

Chen Yucong (6):
      x86, MCE, AMD: Use macros to compute bank MSRs
      x86, MCE, AMD: Correct thresholding error logging
      x86, MCE, AMD: Move invariant code out from loop body
      x86, MCE, AMD: Assign interrupt handler only when bank supports it
      x86, mce, severity: Extend the the mce_severity mechanism to handle UCNA/DEFERRED error
      x86, mce: Support memory error recovery for both UCNA and Deferred error in machine_check_poll

Chen, Gong (2):
      APEI, GHES: Cleanup unnecessary function for lockless list
      RAS, HWPOISON: Fix wrong error recovery status


 arch/x86/include/asm/mce.h                |  5 ++-
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  4 +-
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 23 +++++++---
 arch/x86/kernel/cpu/mcheck/mce.c          | 72 +++++++++++++++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce_amd.c      | 54 ++++++++++++-----------
 drivers/acpi/apei/ghes.c                  | 20 ++-------
 drivers/edac/mce_amd.h                    |  3 --
 mm/memory-failure.c                       |  2 +-
 8 files changed, 116 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 958b90f761e5..51b26e895933 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -34,6 +34,10 @@
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
 
+/* AMD-specific bits */
+#define MCI_STATUS_DEFERRED	(1ULL<<44)  /* declare an uncorrected error */
+#define MCI_STATUS_POISON	(1ULL<<43)  /* access poisonous data */
+
 /*
  * Note that the full MCACOD field of IA32_MCi_STATUS MSR is
  * bits 15:0.  But bit 12 is the 'F' bit, defined for corrected
@@ -78,7 +82,6 @@
 /* Software defined banks */
 #define MCE_EXTENDED_BANK	128
 #define MCE_THERMAL_BANK	(MCE_EXTENDED_BANK + 0)
-#define K8_MCE_THRESHOLD_BASE   (MCE_EXTENDED_BANK + 1)
 
 #define MCE_LOG_LEN 32
 #define MCE_LOG_SIGNATURE	"MACHINECHECK"
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 09edd0b65fef..10b46906767f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -3,6 +3,8 @@
 
 enum severity_level {
 	MCE_NO_SEVERITY,
+	MCE_DEFERRED_SEVERITY,
+	MCE_UCNA_SEVERITY = MCE_DEFERRED_SEVERITY,
 	MCE_KEEP_SEVERITY,
 	MCE_SOME_SEVERITY,
 	MCE_AO_SEVERITY,
@@ -21,7 +23,7 @@ struct mce_bank {
 	char			attrname[ATTR_LEN];	/* attribute name */
 };
 
-int mce_severity(struct mce *a, int tolerant, char **msg);
+int mce_severity(struct mce *a, int tolerant, char **msg, bool is_excp);
 struct dentry *mce_get_debugfs_dir(void);
 
 extern struct mce_bank *mce_banks;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index c370e1c4468b..8bb433043a7f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -31,6 +31,7 @@
 
 enum context { IN_KERNEL = 1, IN_USER = 2 };
 enum ser { SER_REQUIRED = 1, NO_SER = 2 };
+enum exception { EXCP_CONTEXT = 1, NO_EXCP = 2 };
 
 static struct severity {
 	u64 mask;
@@ -40,6 +41,7 @@ static struct severity {
 	unsigned char mcgres;
 	unsigned char ser;
 	unsigned char context;
+	unsigned char excp;
 	unsigned char covered;
 	char *msg;
 } severities[] = {
@@ -48,6 +50,8 @@ static struct severity {
 #define  USER		.context = IN_USER
 #define  SER		.ser = SER_REQUIRED
 #define  NOSER		.ser = NO_SER
+#define  EXCP		.excp = EXCP_CONTEXT
+#define  NOEXCP		.excp = NO_EXCP
 #define  BITCLR(x)	.mask = x, .result = 0
 #define  BITSET(x)	.mask = x, .result = x
 #define  MCGMASK(x, y)	.mcgmask = x, .mcgres = y
@@ -62,7 +66,7 @@ static struct severity {
 		),
 	MCESEV(
 		NO, "Not enabled",
-		BITCLR(MCI_STATUS_EN)
+		EXCP, BITCLR(MCI_STATUS_EN)
 		),
 	MCESEV(
 		PANIC, "Processor context corrupt",
@@ -71,16 +75,20 @@ static struct severity {
 	/* When MCIP is not set something is very confused */
 	MCESEV(
 		PANIC, "MCIP not set in MCA handler",
-		MCGMASK(MCG_STATUS_MCIP, 0)
+		EXCP, MCGMASK(MCG_STATUS_MCIP, 0)
 		),
 	/* Neither return not error IP -- no chance to recover -> PANIC */
 	MCESEV(
 		PANIC, "Neither restart nor error IP",
-		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
+		EXCP, MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
 		),
 	MCESEV(
 		PANIC, "In kernel and no restart IP",
-		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
+		EXCP, KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
+		),
+	MCESEV(
+		DEFERRED, "Deferred error",
+		NOSER, MASK(MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON, MCI_STATUS_DEFERRED)
 		),
 	MCESEV(
 		KEEP, "Corrected error",
@@ -89,7 +97,7 @@ static struct severity {
 
 	/* ignore OVER for UCNA */
 	MCESEV(
-		KEEP, "Uncorrected no action required",
+		UCNA, "Uncorrected no action required",
 		SER, MASK(MCI_UC_SAR, MCI_STATUS_UC)
 		),
 	MCESEV(
@@ -178,8 +186,9 @@ static int error_context(struct mce *m)
 	return ((m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
 }
 
-int mce_severity(struct mce *m, int tolerant, char **msg)
+int mce_severity(struct mce *m, int tolerant, char **msg, bool is_excp)
 {
+	enum exception excp = (is_excp ? EXCP_CONTEXT : NO_EXCP);
 	enum context ctx = error_context(m);
 	struct severity *s;
 
@@ -194,6 +203,8 @@ int mce_severity(struct mce *m, int tolerant, char **msg)
 			continue;
 		if (s->context && ctx != s->context)
 			continue;
+		if (s->excp && excp != s->excp)
+			continue;
 		if (msg)
 			*msg = s->msg;
 		s->covered = 1;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668cebfd..d2c611699cd9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -292,10 +292,10 @@ static void print_mce(struct mce *m)
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
-static atomic_t mce_paniced;
+static atomic_t mce_panicked;
 
 static int fake_panic;
-static atomic_t mce_fake_paniced;
+static atomic_t mce_fake_panicked;
 
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
@@ -319,7 +319,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		/*
 		 * Make sure only one CPU runs in machine check panic
 		 */
-		if (atomic_inc_return(&mce_paniced) > 1)
+		if (atomic_inc_return(&mce_panicked) > 1)
 			wait_for_panic();
 		barrier();
 
@@ -327,7 +327,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		console_verbose();
 	} else {
 		/* Don't log too much for fake panic */
-		if (atomic_inc_return(&mce_fake_paniced) > 1)
+		if (atomic_inc_return(&mce_fake_panicked) > 1)
 			return;
 	}
 	/* First print corrected ones that are still unlogged */
@@ -575,6 +575,37 @@ static void mce_read_aux(struct mce *m, int i)
 	}
 }
 
+static bool memory_error(struct mce *m)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		/*
+		 * coming soon
+		 */
+		return false;
+	} else if (c->x86_vendor == X86_VENDOR_INTEL) {
+		/*
+		 * Intel SDM Volume 3B - 15.9.2 Compound Error Codes
+		 *
+		 * Bit 7 of the MCACOD field of IA32_MCi_STATUS is used for
+		 * indicating a memory error. Bit 8 is used for indicating a
+		 * cache hierarchy error. The combination of bit 2 and bit 3
+		 * is used for indicating a `generic' cache hierarchy error
+		 * But we can't just blindly check the above bits, because if
+		 * bit 11 is set, then it is a bus/interconnect error - and
+		 * either way the above bits just gives more detail on what
+		 * bus/interconnect error happened. Note that bit 12 can be
+		 * ignored, as it's the "filter" bit.
+		 */
+		return (m->status & 0xef80) == BIT(7) ||
+		       (m->status & 0xef00) == BIT(8) ||
+		       (m->status & 0xeffc) == 0xc;
+	}
+
+	return false;
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -595,6 +626,7 @@ DEFINE_PER_CPU(unsigned, mce_poll_count);
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
+	int severity;
 	int i;
 
 	this_cpu_inc(mce_poll_count);
@@ -630,6 +662,20 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
+
+		severity = mce_severity(&m, mca_cfg.tolerant, NULL, false);
+
+		/*
+		 * In the cases where we don't have a valid address after all,
+		 * do not add it into the ring buffer.
+		 */
+		if (severity == MCE_DEFERRED_SEVERITY && memory_error(&m)) {
+			if (m.status & MCI_STATUS_ADDRV) {
+				mce_ring_add(m.addr >> PAGE_SHIFT);
+				mce_schedule_work();
+			}
+		}
+
 		/*
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
@@ -668,7 +714,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 			if (quirk_no_way_out)
 				quirk_no_way_out(i, m, regs);
 		}
-		if (mce_severity(m, mca_cfg.tolerant, msg) >= MCE_PANIC_SEVERITY)
+		if (mce_severity(m, mca_cfg.tolerant, msg, true) >=
+		    MCE_PANIC_SEVERITY)
 			ret = 1;
 	}
 	return ret;
@@ -697,7 +744,7 @@ static int mce_timed_out(u64 *t)
 	 * might have been modified by someone else.
 	 */
 	rmb();
-	if (atomic_read(&mce_paniced))
+	if (atomic_read(&mce_panicked))
 		wait_for_panic();
 	if (!mca_cfg.monarch_timeout)
 		goto out;
@@ -754,7 +801,7 @@ static void mce_reign(void)
 	for_each_possible_cpu(cpu) {
 		int severity = mce_severity(&per_cpu(mces_seen, cpu),
 					    mca_cfg.tolerant,
-					    &nmsg);
+					    &nmsg, true);
 		if (severity > global_worst) {
 			msg = nmsg;
 			global_worst = severity;
@@ -1095,13 +1142,14 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
 
-		severity = mce_severity(&m, cfg->tolerant, NULL);
+		severity = mce_severity(&m, cfg->tolerant, NULL, true);
 
 		/*
-		 * When machine check was for corrected handler don't touch,
-		 * unless we're panicing.
+		 * When machine check was for corrected/deferred handler don't
+		 * touch, unless we're panicing.
 		 */
-		if (severity == MCE_KEEP_SEVERITY && !no_way_out)
+		if ((severity == MCE_KEEP_SEVERITY ||
+		     severity == MCE_UCNA_SEVERITY) && !no_way_out)
 			continue;
 		__set_bit(i, toclear);
 		if (severity == MCE_NO_SEVERITY) {
@@ -2520,7 +2568,7 @@ struct dentry *mce_get_debugfs_dir(void)
 static void mce_reset(void)
 {
 	cpu_missing = 0;
-	atomic_set(&mce_fake_paniced, 0);
+	atomic_set(&mce_fake_panicked, 0);
 	atomic_set(&mce_executing, 0);
 	atomic_set(&mce_callin, 0);
 	atomic_set(&global_nwo, 0);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5d4999f95aec..f1c3769bbd64 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -212,12 +212,12 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int cpu = smp_processor_id();
 	u32 low = 0, high = 0, address = 0;
 	unsigned int bank, block;
-	int offset = -1;
+	int offset = -1, new;
 
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
-				address = MSR_IA32_MC0_MISC + bank * 4;
+				address = MSR_IA32_MCx_MISC(bank);
 			else if (block == 1) {
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
@@ -247,13 +247,18 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			b.address		= address;
 			b.interrupt_capable	= lvt_interrupt_supported(bank, high);
 
-			if (b.interrupt_capable) {
-				int new = (high & MASK_LVTOFF_HI) >> 20;
-				offset  = setup_APIC_mce(offset, new);
-			}
+			if (!b.interrupt_capable)
+				goto init;
+
+			new	= (high & MASK_LVTOFF_HI) >> 20;
+			offset  = setup_APIC_mce(offset, new);
+
+			if ((offset == new) &&
+			    (mce_threshold_vector != amd_threshold_interrupt))
+				mce_threshold_vector = amd_threshold_interrupt;
 
+init:
 			mce_threshold_block_init(&b, offset);
-			mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
 }
@@ -270,18 +275,17 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 static void amd_threshold_interrupt(void)
 {
 	u32 low = 0, high = 0, address = 0;
+	int cpu = smp_processor_id();
 	unsigned int bank, block;
 	struct mce m;
 
-	mce_setup(&m);
-
 	/* assume first bank caused it */
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
-		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
+		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0) {
-				address = MSR_IA32_MC0_MISC + bank * 4;
+				address = MSR_IA32_MCx_MISC(bank);
 			} else if (block == 1) {
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
@@ -309,21 +313,20 @@ static void amd_threshold_interrupt(void)
 			 * Log the machine check that caused the threshold
 			 * event.
 			 */
-			machine_check_poll(MCP_TIMESTAMP,
-					this_cpu_ptr(&mce_poll_banks));
-
-			if (high & MASK_OVERFLOW_HI) {
-				rdmsrl(address, m.misc);
-				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
-				       m.status);
-				m.bank = K8_MCE_THRESHOLD_BASE
-				       + bank * NR_BLOCKS
-				       + block;
-				mce_log(&m);
-				return;
-			}
+			if (high & MASK_OVERFLOW_HI)
+				goto log;
 		}
 	}
+	return;
+
+log:
+	mce_setup(&m);
+	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
+	m.misc = ((u64)high << 32) | low;
+	m.bank = bank;
+	mce_log(&m);
+
+	wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
 }
 
 /*
@@ -617,8 +620,7 @@ static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		}
 	}
 
-	err = allocate_threshold_blocks(cpu, bank, 0,
-					MSR_IA32_MC0_MISC + bank * 4);
+	err = allocate_threshold_blocks(cpu, bank, 0, MSR_IA32_MCx_MISC(bank));
 	if (!err)
 		goto out;
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fc5f780bb61d..1b6aa514848f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -128,7 +128,7 @@ static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
 static struct gen_pool *ghes_estatus_pool;
 static unsigned long ghes_estatus_pool_size_request;
 
-struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
+static struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
 
 static int ghes_ioremap_init(void)
@@ -738,20 +738,6 @@ static LIST_HEAD(ghes_nmi);
 
 static int ghes_panic_timeout	__read_mostly = 30;
 
-static struct llist_node *llist_nodes_reverse(struct llist_node *llnode)
-{
-	struct llist_node *next, *tail = NULL;
-
-	while (llnode) {
-		next = llnode->next;
-		llnode->next = tail;
-		tail = llnode;
-		llnode = next;
-	}
-
-	return tail;
-}
-
 static void ghes_proc_in_irq(struct irq_work *irq_work)
 {
 	struct llist_node *llnode, *next;
@@ -765,7 +751,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 	 * Because the time order of estatus in list is reversed,
 	 * revert it back to proper order.
 	 */
-	llnode = llist_nodes_reverse(llnode);
+	llnode = llist_reverse_order(llnode);
 	while (llnode) {
 		next = llnode->next;
 		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
@@ -798,7 +784,7 @@ static void ghes_print_queued_estatus(void)
 	 * Because the time order of estatus in list is reversed,
 	 * revert it back to proper order.
 	 */
-	llnode = llist_nodes_reverse(llnode);
+	llnode = llist_reverse_order(llnode);
 	while (llnode) {
 		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
 					   llnode);
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 51b7e3a36e37..c2359a1ea6b3 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -32,9 +32,6 @@
 #define R4(x)				(((x) >> 4) & 0xf)
 #define R4_MSG(x)			((R4(x) < 9) ?  rrrr_msgs[R4(x)] : "Wrong R4!")
 
-#define MCI_STATUS_DEFERRED		BIT_64(44)
-#define MCI_STATUS_POISON		BIT_64(43)
-
 extern const char * const pp_msgs[];
 
 enum tt_ids {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8639f6b28746..b852b10ec76d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -860,7 +860,6 @@ static int page_action(struct page_state *ps, struct page *p,
 	int count;
 
 	result = ps->action(p, pfn);
-	action_result(pfn, ps->msg, result);
 
 	count = page_count(p) - 1;
 	if (ps->action == me_swapcache_dirty && result == DELAYED)
@@ -871,6 +870,7 @@ static int page_action(struct page_state *ps, struct page *p,
 		       pfn, ps->msg, count);
 		result = FAILED;
 	}
+	action_result(pfn, ps->msg, result);
 
 	/* Could do more checks here if page looks ok */
 	/*
