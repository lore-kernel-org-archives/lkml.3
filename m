Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbbANJDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:03:31 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:50728 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbbANJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:03:27 -0500
Date: Wed, 14 Jan 2015 10:03:19 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.19-rc5
Message-ID: <20150114100319.06b850d7@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011409-0029-0000-0000-000002CAFB67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Two small performance tweaks, the plumbing for the execveat system call
and a couple of bug fixes.

Chen Gang (1):
      s390/timex: fix get_tod_clock_ext() inline assembly

Christian Borntraeger (2):
      s390/vtime: Get rid of redundant WARN_ON
      s390/kernel: use stnsm 255 instead of stosm 0

Harald Freudenberger (1):
      s390/zcrypt: kernel oops at insmod of the z90crypt device driver

Heiko Carstens (1):
      s390: wire up execveat syscall

Jan Willeke (1):
      s390/uprobes: fix user space PER events

Martin Schwidefsky (1):
      s390/mm: avoid using pmd_to_page for !USE_SPLIT_PMD_PTLOCKS

Michael Holzheu (2):
      s390/bpf: Fix ALU_NEG (A = -A)
      s390/bpf: Fix JMP_JGE_X (A > X) and JMP_JGT_X (A >= X)

 arch/s390/hypfs/hypfs_vm.c          |  2 +-
 arch/s390/include/asm/irqflags.h    |  2 +-
 arch/s390/include/asm/timex.h       | 10 +++---
 arch/s390/include/uapi/asm/unistd.h |  3 +-
 arch/s390/kernel/syscalls.S         |  1 +
 arch/s390/kernel/uprobes.c          | 69 ++++++++++++++++++++++++++++++++-----
 arch/s390/kernel/vtime.c            |  2 --
 arch/s390/mm/pgtable.c              |  5 +--
 arch/s390/net/bpf_jit_comp.c        |  8 ++---
 drivers/s390/crypto/ap_bus.c        | 10 ++++--
 10 files changed, 85 insertions(+), 27 deletions(-)

diff --git a/arch/s390/hypfs/hypfs_vm.c b/arch/s390/hypfs/hypfs_vm.c
index 32040ac..afbe079 100644
--- a/arch/s390/hypfs/hypfs_vm.c
+++ b/arch/s390/hypfs/hypfs_vm.c
@@ -231,7 +231,7 @@ failed:
 struct dbfs_d2fc_hdr {
 	u64	len;		/* Length of d2fc buffer without header */
 	u16	version;	/* Version of header */
-	char	tod_ext[16];	/* TOD clock for d2fc */
+	char	tod_ext[STORE_CLOCK_EXT_SIZE]; /* TOD clock for d2fc */
 	u64	count;		/* Number of VM guests in d2fc buffer */
 	char	reserved[30];
 } __attribute__ ((packed));
diff --git a/arch/s390/include/asm/irqflags.h b/arch/s390/include/asm/irqflags.h
index 37b9091..16aa0c7 100644
--- a/arch/s390/include/asm/irqflags.h
+++ b/arch/s390/include/asm/irqflags.h
@@ -36,7 +36,7 @@ static inline notrace void __arch_local_irq_ssm(unsigned long flags)
 
 static inline notrace unsigned long arch_local_save_flags(void)
 {
-	return __arch_local_irq_stosm(0x00);
+	return __arch_local_irq_stnsm(0xff);
 }
 
 static inline notrace unsigned long arch_local_irq_save(void)
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 8beee1c..98eb2a5 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -67,20 +67,22 @@ static inline void local_tick_enable(unsigned long long comp)
 	set_clock_comparator(S390_lowcore.clock_comparator);
 }
 
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
+#define STORE_CLOCK_EXT_SIZE	16	/* stcke writes 16 bytes */
 
 typedef unsigned long long cycles_t;
 
-static inline void get_tod_clock_ext(char clk[16])
+static inline void get_tod_clock_ext(char *clk)
 {
-	typedef struct { char _[sizeof(clk)]; } addrtype;
+	typedef struct { char _[STORE_CLOCK_EXT_SIZE]; } addrtype;
 
 	asm volatile("stcke %0" : "=Q" (*(addrtype *) clk) : : "cc");
 }
 
 static inline unsigned long long get_tod_clock(void)
 {
-	unsigned char clk[16];
+	unsigned char clk[STORE_CLOCK_EXT_SIZE];
+
 	get_tod_clock_ext(clk);
 	return *((unsigned long long *)&clk[1]);
 }
diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 2b446cf..67878af 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -289,7 +289,8 @@
 #define __NR_bpf		351
 #define __NR_s390_pci_mmio_write	352
 #define __NR_s390_pci_mmio_read		353
-#define NR_syscalls 354
+#define __NR_execveat		354
+#define NR_syscalls 355
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index a298724..939ec47 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -362,3 +362,4 @@ SYSCALL(sys_memfd_create,sys_memfd_create,compat_sys_memfd_create) /* 350 */
 SYSCALL(sys_bpf,sys_bpf,compat_sys_bpf)
 SYSCALL(sys_ni_syscall,sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
 SYSCALL(sys_ni_syscall,sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
+SYSCALL(sys_execveat,sys_execveat,compat_sys_execveat)
diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index f6b3cd0..cc73280 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -48,6 +48,30 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *tsk)
 	return false;
 }
 
+static int check_per_event(unsigned short cause, unsigned long control,
+			   struct pt_regs *regs)
+{
+	if (!(regs->psw.mask & PSW_MASK_PER))
+		return 0;
+	/* user space single step */
+	if (control == 0)
+		return 1;
+	/* over indication for storage alteration */
+	if ((control & 0x20200000) && (cause & 0x2000))
+		return 1;
+	if (cause & 0x8000) {
+		/* all branches */
+		if ((control & 0x80800000) == 0x80000000)
+			return 1;
+		/* branch into selected range */
+		if (((control & 0x80800000) == 0x80800000) &&
+		    regs->psw.addr >= current->thread.per_user.start &&
+		    regs->psw.addr <= current->thread.per_user.end)
+			return 1;
+	}
+	return 0;
+}
+
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	int fixup = probe_get_fixup_type(auprobe->insn);
@@ -71,9 +95,13 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		if (regs->psw.addr - utask->xol_vaddr == ilen)
 			regs->psw.addr = utask->vaddr + ilen;
 	}
-	/* If per tracing was active generate trap */
-	if (regs->psw.mask & PSW_MASK_PER)
-		do_per_trap(regs);
+	if (check_per_event(current->thread.per_event.cause,
+			    current->thread.per_user.control, regs)) {
+		/* fix per address */
+		current->thread.per_event.address = utask->vaddr;
+		/* trigger per event */
+		set_pt_regs_flag(regs, PIF_PER_TRAP);
+	}
 	return 0;
 }
 
@@ -106,6 +134,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	clear_thread_flag(TIF_UPROBE_SINGLESTEP);
 	regs->int_code = auprobe->saved_int_code;
 	regs->psw.addr = current->utask->vaddr;
+	current->thread.per_event.address = current->utask->vaddr;
 }
 
 unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline,
@@ -146,17 +175,20 @@ static void adjust_psw_addr(psw_t *psw, unsigned long len)
 	__rc;						\
 })
 
-#define emu_store_ril(ptr, input)			\
+#define emu_store_ril(regs, ptr, input)			\
 ({							\
 	unsigned int mask = sizeof(*(ptr)) - 1;		\
+	__typeof__(ptr) __ptr = (ptr);			\
 	int __rc = 0;					\
 							\
 	if (!test_facility(34))				\
 		__rc = EMU_ILLEGAL_OP;			\
-	else if ((u64 __force)ptr & mask)		\
+	else if ((u64 __force)__ptr & mask)		\
 		__rc = EMU_SPECIFICATION;		\
-	else if (put_user(*(input), ptr))		\
+	else if (put_user(*(input), __ptr))		\
 		__rc = EMU_ADDRESSING;			\
+	if (__rc == 0)					\
+		sim_stor_event(regs, __ptr, mask + 1);	\
 	__rc;						\
 })
 
@@ -198,6 +230,25 @@ union split_register {
 };
 
 /*
+ * If user per registers are setup to trace storage alterations and an
+ * emulated store took place on a fitting address a user trap is generated.
+ */
+static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
+{
+	if (!(regs->psw.mask & PSW_MASK_PER))
+		return;
+	if (!(current->thread.per_user.control & PER_EVENT_STORE))
+		return;
+	if ((void *)current->thread.per_user.start > (addr + len))
+		return;
+	if ((void *)current->thread.per_user.end < addr)
+		return;
+	current->thread.per_event.address = regs->psw.addr;
+	current->thread.per_event.cause = PER_EVENT_STORE >> 16;
+	set_pt_regs_flag(regs, PIF_PER_TRAP);
+}
+
+/*
  * pc relative instructions are emulated, since parameters may not be
  * accessible from the xol area due to range limitations.
  */
@@ -249,13 +300,13 @@ static void handle_insn_ril(struct arch_uprobe *auprobe, struct pt_regs *regs)
 			rc = emu_load_ril((u32 __user *)uptr, &rx->u64);
 			break;
 		case 0x07: /* sthrl */
-			rc = emu_store_ril((u16 __user *)uptr, &rx->u16[3]);
+			rc = emu_store_ril(regs, (u16 __user *)uptr, &rx->u16[3]);
 			break;
 		case 0x0b: /* stgrl */
-			rc = emu_store_ril((u64 __user *)uptr, &rx->u64);
+			rc = emu_store_ril(regs, (u64 __user *)uptr, &rx->u64);
 			break;
 		case 0x0f: /* strl */
-			rc = emu_store_ril((u32 __user *)uptr, &rx->u32[1]);
+			rc = emu_store_ril(regs, (u32 __user *)uptr, &rx->u32[1]);
 			break;
 		}
 		break;
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 7f0089d..e34122e5 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -128,8 +128,6 @@ void vtime_account_irq_enter(struct task_struct *tsk)
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
 
-	WARN_ON_ONCE(!irqs_disabled());
-
 	timer = S390_lowcore.last_update_timer;
 	S390_lowcore.last_update_timer = get_vtimer();
 	S390_lowcore.system_timer += timer - S390_lowcore.last_update_timer;
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 71c7eff..601deb8 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -322,11 +322,12 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 static unsigned long __gmap_segment_gaddr(unsigned long *entry)
 {
 	struct page *page;
-	unsigned long offset;
+	unsigned long offset, mask;
 
 	offset = (unsigned long) entry / sizeof(unsigned long);
 	offset = (offset & (PTRS_PER_PMD - 1)) * PMD_SIZE;
-	page = pmd_to_page((pmd_t *) entry);
+	mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
+	page = virt_to_page((void *)((unsigned long) entry & mask));
 	return page->index + offset;
 }
 
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index c52ac77..524496d 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -431,8 +431,8 @@ static int bpf_jit_insn(struct bpf_jit *jit, struct sock_filter *filter,
 		EMIT4_DISP(0x88500000, K);
 		break;
 	case BPF_ALU | BPF_NEG: /* A = -A */
-		/* lnr %r5,%r5 */
-		EMIT2(0x1155);
+		/* lcr %r5,%r5 */
+		EMIT2(0x1355);
 		break;
 	case BPF_JMP | BPF_JA: /* ip += K */
 		offset = addrs[i + K] + jit->start - jit->prg;
@@ -502,8 +502,8 @@ branch:		if (filter->jt == filter->jf) {
 xbranch:	/* Emit compare if the branch targets are different */
 		if (filter->jt != filter->jf) {
 			jit->seen |= SEEN_XREG;
-			/* cr %r5,%r12 */
-			EMIT2(0x195c);
+			/* clr %r5,%r12 */
+			EMIT2(0x155c);
 		}
 		goto branch;
 	case BPF_JMP | BPF_JSET | BPF_X: /* ip += (A & X) ? jt : jf */
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 91e97ec..4d41bf7 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1163,9 +1163,13 @@ static inline int ap_test_config_card_id(unsigned int id)
  */
 static inline int ap_test_config_domain(unsigned int domain)
 {
-	if (!ap_configuration)
-		return 1;
-	return ap_test_config(ap_configuration->aqm, domain);
+	if (!ap_configuration)	  /* QCI not supported */
+		if (domain < 16)
+			return 1; /* then domains 0...15 are configured */
+		else
+			return 0;
+	else
+		return ap_test_config(ap_configuration->aqm, domain);
 }
 
 /**

