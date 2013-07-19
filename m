Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722Ab3GSOVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:21:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:50341 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760736Ab3GSOUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:20:24 -0400
Date: Fri, 19 Jul 2013 16:20:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.11-rc2
Message-ID: <20130719162017.35a151eb@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071914-8372-0000-0000-000006A00FAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

not enough please pull requests? Well, here is what I have pending, won't
do much for you commit counter though..

Please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
An update for the BFP jit to the latest and greatest, two patches to get
kdump working again, the random-abort ptrace extention for transactional
execution, the z90crypt module alias for ap and a tiny cleanup.

Heiko Carstens (4):
      s390/bpf,jit: call module_free() from any context
      s390/bpf,jit: use generic jit dumper
      s390/bpf,jit: address randomize and write protect jit code
      s390/bpf,jit: add pkt_type support

Ingo Tuchscherer (1):
      s390/zcrypt: Alias for new zcrypt device driver base module

Michael Holzheu (2):
      s390/kdump: Disable mmap for s390
      s390/kdump: Allow copy_oldmem_page() copy to virtual memory

Michael Mueller (1):
      s390/ptrace: PTRACE_TE_ABORT_RAND

Sebastian Ott (1):
      s390/qdio: remove unused variable

 arch/s390/include/asm/processor.h   |   10 +++-
 arch/s390/include/asm/switch_to.h   |    4 +-
 arch/s390/include/uapi/asm/ptrace.h |    1 +
 arch/s390/kernel/crash_dump.c       |   51 ++++++++++++++--
 arch/s390/kernel/ptrace.c           |   50 ++++++++++++----
 arch/s390/net/bpf_jit_comp.c        |  113 +++++++++++++++++++++++++++--------
 drivers/s390/cio/qdio_main.c        |    4 +-
 drivers/s390/crypto/ap_bus.c        |    1 +
 fs/proc/vmcore.c                    |    2 +-
 9 files changed, 190 insertions(+), 46 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 6b49987..b0e6435 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -91,7 +91,15 @@ struct thread_struct {
 #endif
 };
 
-#define PER_FLAG_NO_TE		1UL	/* Flag to disable transactions. */
+/* Flag to disable transactions. */
+#define PER_FLAG_NO_TE			1UL
+/* Flag to enable random transaction aborts. */
+#define PER_FLAG_TE_ABORT_RAND		2UL
+/* Flag to specify random transaction abort mode:
+ * - abort each transaction at a random instruction before TEND if set.
+ * - abort random transactions at a random instruction if cleared.
+ */
+#define PER_FLAG_TE_ABORT_RAND_TEND	4UL
 
 typedef struct thread_struct thread_struct;
 
diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
index f3a9e0f..80b6f11 100644
--- a/arch/s390/include/asm/switch_to.h
+++ b/arch/s390/include/asm/switch_to.h
@@ -10,7 +10,7 @@
 #include <linux/thread_info.h>
 
 extern struct task_struct *__switch_to(void *, void *);
-extern void update_per_regs(struct task_struct *task);
+extern void update_cr_regs(struct task_struct *task);
 
 static inline void save_fp_regs(s390_fp_regs *fpregs)
 {
@@ -86,7 +86,7 @@ static inline void restore_access_regs(unsigned int *acrs)
 		restore_fp_regs(&next->thread.fp_regs);			\
 		restore_access_regs(&next->thread.acrs[0]);		\
 		restore_ri_cb(next->thread.ri_cb, prev->thread.ri_cb);	\
-		update_per_regs(next);					\
+		update_cr_regs(next);					\
 	}								\
 	prev = __switch_to(prev,next);					\
 } while (0)
diff --git a/arch/s390/include/uapi/asm/ptrace.h b/arch/s390/include/uapi/asm/ptrace.h
index 3aa9f1e..7a84619 100644
--- a/arch/s390/include/uapi/asm/ptrace.h
+++ b/arch/s390/include/uapi/asm/ptrace.h
@@ -400,6 +400,7 @@ typedef struct
 #define PTRACE_POKE_SYSTEM_CALL	      0x5008
 #define PTRACE_ENABLE_TE	      0x5009
 #define PTRACE_DISABLE_TE	      0x5010
+#define PTRACE_TE_ABORT_RAND	      0x5011
 
 /*
  * PT_PROT definition is loosely based on hppa bsd definition in
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index f703d91..d8f3556 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -21,6 +21,48 @@
 #define PTR_SUB(x, y) (((char *) (x)) - ((unsigned long) (y)))
 #define PTR_DIFF(x, y) ((unsigned long)(((char *) (x)) - ((unsigned long) (y))))
 
+
+/*
+ * Return physical address for virtual address
+ */
+static inline void *load_real_addr(void *addr)
+{
+	unsigned long real_addr;
+
+	asm volatile(
+		   "	lra     %0,0(%1)\n"
+		   "	jz	0f\n"
+		   "	la	%0,0\n"
+		   "0:"
+		   : "=a" (real_addr) : "a" (addr) : "cc");
+	return (void *)real_addr;
+}
+
+/*
+ * Copy up to one page to vmalloc or real memory
+ */
+static ssize_t copy_page_real(void *buf, void *src, size_t csize)
+{
+	size_t size;
+
+	if (is_vmalloc_addr(buf)) {
+		BUG_ON(csize >= PAGE_SIZE);
+		/* If buf is not page aligned, copy first part */
+		size = min(roundup(__pa(buf), PAGE_SIZE) - __pa(buf), csize);
+		if (size) {
+			if (memcpy_real(load_real_addr(buf), src, size))
+				return -EFAULT;
+			buf += size;
+			src += size;
+		}
+		/* Copy second part */
+		size = csize - size;
+		return (size) ? memcpy_real(load_real_addr(buf), src, size) : 0;
+	} else {
+		return memcpy_real(buf, src, csize);
+	}
+}
+
 /*
  * Copy one page from "oldmem"
  *
@@ -32,6 +74,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 			 size_t csize, unsigned long offset, int userbuf)
 {
 	unsigned long src;
+	int rc;
 
 	if (!csize)
 		return 0;
@@ -43,11 +86,11 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 		 src < OLDMEM_BASE + OLDMEM_SIZE)
 		src -= OLDMEM_BASE;
 	if (userbuf)
-		copy_to_user_real((void __force __user *) buf, (void *) src,
-				  csize);
+		rc = copy_to_user_real((void __force __user *) buf,
+				       (void *) src, csize);
 	else
-		memcpy_real(buf, (void *) src, csize);
-	return csize;
+		rc = copy_page_real(buf, (void *) src, csize);
+	return (rc == 0) ? csize : rc;
 }
 
 /*
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index a314c57..e9fadb0 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -47,7 +47,7 @@ enum s390_regset {
 	REGSET_GENERAL_EXTENDED,
 };
 
-void update_per_regs(struct task_struct *task)
+void update_cr_regs(struct task_struct *task)
 {
 	struct pt_regs *regs = task_pt_regs(task);
 	struct thread_struct *thread = &task->thread;
@@ -56,17 +56,25 @@ void update_per_regs(struct task_struct *task)
 #ifdef CONFIG_64BIT
 	/* Take care of the enable/disable of transactional execution. */
 	if (MACHINE_HAS_TE) {
-		unsigned long cr0, cr0_new;
+		unsigned long cr[3], cr_new[3];
 
-		__ctl_store(cr0, 0, 0);
-		/* set or clear transaction execution bits 8 and 9. */
+		__ctl_store(cr, 0, 2);
+		cr_new[1] = cr[1];
+		/* Set or clear transaction execution TXC/PIFO bits 8 and 9. */
 		if (task->thread.per_flags & PER_FLAG_NO_TE)
-			cr0_new = cr0 & ~(3UL << 54);
+			cr_new[0] = cr[0] & ~(3UL << 54);
 		else
-			cr0_new = cr0 | (3UL << 54);
-		/* Only load control register 0 if necessary. */
-		if (cr0 != cr0_new)
-			__ctl_load(cr0_new, 0, 0);
+			cr_new[0] = cr[0] | (3UL << 54);
+		/* Set or clear transaction execution TDC bits 62 and 63. */
+		cr_new[2] = cr[2] & ~3UL;
+		if (task->thread.per_flags & PER_FLAG_TE_ABORT_RAND) {
+			if (task->thread.per_flags & PER_FLAG_TE_ABORT_RAND_TEND)
+				cr_new[2] |= 1UL;
+			else
+				cr_new[2] |= 2UL;
+		}
+		if (memcmp(&cr_new, &cr, sizeof(cr)))
+			__ctl_load(cr_new, 0, 2);
 	}
 #endif
 	/* Copy user specified PER registers */
@@ -100,14 +108,14 @@ void user_enable_single_step(struct task_struct *task)
 {
 	set_tsk_thread_flag(task, TIF_SINGLE_STEP);
 	if (task == current)
-		update_per_regs(task);
+		update_cr_regs(task);
 }
 
 void user_disable_single_step(struct task_struct *task)
 {
 	clear_tsk_thread_flag(task, TIF_SINGLE_STEP);
 	if (task == current)
-		update_per_regs(task);
+		update_cr_regs(task);
 }
 
 /*
@@ -447,6 +455,26 @@ long arch_ptrace(struct task_struct *child, long request,
 		if (!MACHINE_HAS_TE)
 			return -EIO;
 		child->thread.per_flags |= PER_FLAG_NO_TE;
+		child->thread.per_flags &= ~PER_FLAG_TE_ABORT_RAND;
+		return 0;
+	case PTRACE_TE_ABORT_RAND:
+		if (!MACHINE_HAS_TE || (child->thread.per_flags & PER_FLAG_NO_TE))
+			return -EIO;
+		switch (data) {
+		case 0UL:
+			child->thread.per_flags &= ~PER_FLAG_TE_ABORT_RAND;
+			break;
+		case 1UL:
+			child->thread.per_flags |= PER_FLAG_TE_ABORT_RAND;
+			child->thread.per_flags |= PER_FLAG_TE_ABORT_RAND_TEND;
+			break;
+		case 2UL:
+			child->thread.per_flags |= PER_FLAG_TE_ABORT_RAND;
+			child->thread.per_flags &= ~PER_FLAG_TE_ABORT_RAND_TEND;
+			break;
+		default:
+			return -EINVAL;
+		}
 		return 0;
 	default:
 		/* Removing high order bit from addr (only for 31 bit). */
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 82f165f..d5f10a4 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -9,6 +9,8 @@
 #include <linux/netdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/filter.h>
+#include <linux/random.h>
+#include <linux/init.h>
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
 #include <asm/facility.h>
@@ -221,6 +223,37 @@ static void bpf_jit_epilogue(struct bpf_jit *jit)
 	EMIT2(0x07fe);
 }
 
+/* Helper to find the offset of pkt_type in sk_buff
+ * Make sure its still a 3bit field starting at the MSBs within a byte.
+ */
+#define PKT_TYPE_MAX 0xe0
+static int pkt_type_offset;
+
+static int __init bpf_pkt_type_offset_init(void)
+{
+	struct sk_buff skb_probe = {
+		.pkt_type = ~0,
+	};
+	char *ct = (char *)&skb_probe;
+	int off;
+
+	pkt_type_offset = -1;
+	for (off = 0; off < sizeof(struct sk_buff); off++) {
+		if (!ct[off])
+			continue;
+		if (ct[off] == PKT_TYPE_MAX)
+			pkt_type_offset = off;
+		else {
+			/* Found non matching bit pattern, fix needed. */
+			WARN_ON_ONCE(1);
+			pkt_type_offset = -1;
+			return -1;
+		}
+	}
+	return 0;
+}
+device_initcall(bpf_pkt_type_offset_init);
+
 /*
  * make sure we dont leak kernel information to user
  */
@@ -720,6 +753,16 @@ call_fn:	/* lg %r1,<d(function)>(%r13) */
 			EMIT4_DISP(0x88500000, 12);
 		}
 		break;
+	case BPF_S_ANC_PKTTYPE:
+		if (pkt_type_offset < 0)
+			goto out;
+		/* lhi %r5,0 */
+		EMIT4(0xa7580000);
+		/* ic %r5,<d(pkt_type_offset)>(%r2) */
+		EMIT4_DISP(0x43502000, pkt_type_offset);
+		/* srl %r5,5 */
+		EMIT4_DISP(0x88500000, 5);
+		break;
 	case BPF_S_ANC_CPU: /* A = smp_processor_id() */
 #ifdef CONFIG_SMP
 		/* l %r5,<d(cpu_nr)> */
@@ -738,8 +781,41 @@ out:
 	return -1;
 }
 
+/*
+ * Note: for security reasons, bpf code will follow a randomly
+ *	 sized amount of illegal instructions.
+ */
+struct bpf_binary_header {
+	unsigned int pages;
+	u8 image[];
+};
+
+static struct bpf_binary_header *bpf_alloc_binary(unsigned int bpfsize,
+						  u8 **image_ptr)
+{
+	struct bpf_binary_header *header;
+	unsigned int sz, hole;
+
+	/* Most BPF filters are really small, but if some of them fill a page,
+	 * allow at least 128 extra bytes for illegal instructions.
+	 */
+	sz = round_up(bpfsize + sizeof(*header) + 128, PAGE_SIZE);
+	header = module_alloc(sz);
+	if (!header)
+		return NULL;
+	memset(header, 0, sz);
+	header->pages = sz / PAGE_SIZE;
+	hole = sz - bpfsize + sizeof(*header);
+	/* Insert random number of illegal instructions before BPF code
+	 * and make sure the first instruction starts at an even address.
+	 */
+	*image_ptr = &header->image[(prandom_u32() % hole) & -2];
+	return header;
+}
+
 void bpf_jit_compile(struct sk_filter *fp)
 {
+	struct bpf_binary_header *header = NULL;
 	unsigned long size, prg_len, lit_len;
 	struct bpf_jit jit, cjit;
 	unsigned int *addrs;
@@ -772,12 +848,11 @@ void bpf_jit_compile(struct sk_filter *fp)
 		} else if (jit.prg == cjit.prg && jit.lit == cjit.lit) {
 			prg_len = jit.prg - jit.start;
 			lit_len = jit.lit - jit.mid;
-			size = max_t(unsigned long, prg_len + lit_len,
-				     sizeof(struct work_struct));
+			size = prg_len + lit_len;
 			if (size >= BPF_SIZE_MAX)
 				goto out;
-			jit.start = module_alloc(size);
-			if (!jit.start)
+			header = bpf_alloc_binary(size, &jit.start);
+			if (!header)
 				goto out;
 			jit.prg = jit.mid = jit.start + prg_len;
 			jit.lit = jit.end = jit.start + prg_len + lit_len;
@@ -788,37 +863,25 @@ void bpf_jit_compile(struct sk_filter *fp)
 		cjit = jit;
 	}
 	if (bpf_jit_enable > 1) {
-		pr_err("flen=%d proglen=%lu pass=%d image=%p\n",
-		       fp->len, jit.end - jit.start, pass, jit.start);
-		if (jit.start) {
-			printk(KERN_ERR "JIT code:\n");
+		bpf_jit_dump(fp->len, jit.end - jit.start, pass, jit.start);
+		if (jit.start)
 			print_fn_code(jit.start, jit.mid - jit.start);
-			print_hex_dump(KERN_ERR, "JIT literals:\n",
-				       DUMP_PREFIX_ADDRESS, 16, 1,
-				       jit.mid, jit.end - jit.mid, false);
-		}
 	}
-	if (jit.start)
+	if (jit.start) {
+		set_memory_ro((unsigned long)header, header->pages);
 		fp->bpf_func = (void *) jit.start;
+	}
 out:
 	kfree(addrs);
 }
 
-static void jit_free_defer(struct work_struct *arg)
-{
-	module_free(NULL, arg);
-}
-
-/* run from softirq, we must use a work_struct to call
- * module_free() from process context
- */
 void bpf_jit_free(struct sk_filter *fp)
 {
-	struct work_struct *work;
+	unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
+	struct bpf_binary_header *header = (void *)addr;
 
 	if (fp->bpf_func == sk_run_filter)
 		return;
-	work = (struct work_struct *)fp->bpf_func;
-	INIT_WORK(work, jit_free_defer);
-	schedule_work(work);
+	set_memory_rw(addr, header->pages);
+	module_free(NULL, header);
 }
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index fb1c1e0..8ed52aa 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1497,7 +1497,7 @@ static inline int buf_in_between(int bufnr, int start, int count)
 static int handle_inbound(struct qdio_q *q, unsigned int callflags,
 			  int bufnr, int count)
 {
-	int used, diff;
+	int diff;
 
 	qperf_inc(q, inbound_call);
 
@@ -1530,7 +1530,7 @@ static int handle_inbound(struct qdio_q *q, unsigned int callflags,
 
 set:
 	count = set_buf_states(q, bufnr, SLSB_CU_INPUT_EMPTY, count);
-	used = atomic_add_return(count, &q->nr_buf_used) - count;
+	atomic_add(count, &q->nr_buf_used);
 
 	if (need_siga_in(q))
 		return qdio_siga_input(q);
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index f446a77..d4174b8 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -71,6 +71,7 @@ MODULE_AUTHOR("IBM Corporation");
 MODULE_DESCRIPTION("Adjunct Processor Bus driver, " \
 		   "Copyright IBM Corp. 2006, 2012");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("z90crypt");
 
 /*
  * Module parameter
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 2850317..a1a16eb 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -223,7 +223,7 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
  * regions in the 1st kernel pointed to by PT_LOAD entries) into
  * virtually contiguous user-space in ELF layout.
  */
-#ifdef CONFIG_MMU
+#if defined(CONFIG_MMU) && !defined(CONFIG_S390)
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;

