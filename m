Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3EFHvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:51:40 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:37734 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3EFHvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:51:38 -0400
Date: Mon, 6 May 2013 09:51:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.10 merge window #2
Message-ID: <20130506095131.49db0c8b@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050607-5024-0000-0000-000005F71B53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
This is the second batch of s390 patches for the 3.10 merge window.
Heiko improved the memory detection, this fixes kdump for large memory
sizes. Some kvm related memory management work, new ipldev/condev
keywords in cio and bug fixes.

Heiko Carstens (11):
      s390/uaccess: add "fallthrough" comments
      s390/mem_detect: move memory detection code to mm folder
      s390/mem_detect: fix lockdep irq tracing
      s390/mem_detect: add DAT sanity check
      s390/zcore: calculate real memory size using own get_mem_size function
      s390: get rid of odd global real_memory_size
      s390/kdump,bootmem: fix bootmem allocator bitmap size
      s390/mem_detect: limit memory detection loop to "mem=" parameter
      s390/memory hotplug: provide memory_block_size_bytes() function
      s390/memory hotplug,sclp: get rid of per memory increment usecount
      s390/mem_detect: remove artificial kdump memory types

Ingo Tuchscherer (1):
      s390/zcrypt: ap bus rescan problem when toggle crypto adapters on/off

Martin Schwidefsky (1):
      s390/mm: add pte invalidation notifier for kvm

Nick Wang (1):
      s390/kvm: Change the virtual memory mapping location for Virtio devices

Sebastian Ott (3):
      s390/cio: add ipldev keyword to cio_ignore
      s390/cio: add condev keyword to cio_ignore
      s390/zfcpdump: exploit new cio_ignore keywords

 Documentation/s390/CommonIO     |   12 ++--
 arch/s390/include/asm/pgtable.h |   66 +++++++++++++++---
 arch/s390/include/asm/setup.h   |    9 +--
 arch/s390/kernel/Makefile       |    2 +-
 arch/s390/kernel/crash_dump.c   |    6 +-
 arch/s390/kernel/early.c        |    1 -
 arch/s390/kernel/mem_detect.c   |  145 ---------------------------------------
 arch/s390/kernel/setup.c        |   65 +++++++-----------
 arch/s390/lib/uaccess_pt.c      |    3 +
 arch/s390/mm/Makefile           |    2 +-
 arch/s390/mm/init.c             |   11 +++
 arch/s390/mm/mem_detect.c       |  134 ++++++++++++++++++++++++++++++++++++
 arch/s390/mm/pgtable.c          |  121 ++++++++++++++++++++++++++++++--
 arch/s390/mm/vmem.c             |    8 +--
 drivers/s390/char/sclp_cmd.c    |   20 +-----
 drivers/s390/char/zcore.c       |   34 ++++-----
 drivers/s390/cio/blacklist.c    |   28 +++++++-
 drivers/s390/crypto/ap_bus.c    |   17 ++---
 drivers/s390/kvm/kvm_virtio.c   |   11 +--
 19 files changed, 421 insertions(+), 274 deletions(-)
 delete mode 100644 arch/s390/kernel/mem_detect.c
 create mode 100644 arch/s390/mm/mem_detect.c

diff --git a/Documentation/s390/CommonIO b/Documentation/s390/CommonIO
index d378cba..6e0f63f3 100644
--- a/Documentation/s390/CommonIO
+++ b/Documentation/s390/CommonIO
@@ -8,9 +8,9 @@ Command line parameters
 
   Enable logging of debug information in case of ccw device timeouts.
 
-* cio_ignore = {all} |
-	       {<device> | <range of devices>} |
-	       {!<device> | !<range of devices>}
+* cio_ignore = device[,device[,..]]
+
+	device := {all | [!]ipldev | [!]condev | [!]<devno> | [!]<devno>-<devno>}
 
   The given devices will be ignored by the common I/O-layer; no detection
   and device sensing will be done on any of those devices. The subchannel to 
@@ -24,8 +24,10 @@ Command line parameters
   device numbers (0xabcd or abcd, for 2.4 backward compatibility). If you
   give a device number 0xabcd, it will be interpreted as 0.0.abcd.
 
-  You can use the 'all' keyword to ignore all devices.
-  The '!' operator will cause the I/O-layer to _not_ ignore a device.
+  You can use the 'all' keyword to ignore all devices. The 'ipldev' and 'condev'
+  keywords can be used to refer to the CCW based boot device and CCW console
+  device respectively (these are probably useful only when combined with the '!'
+  operator). The '!' operator will cause the I/O-layer to _not_ ignore a device.
   The command line is parsed from left to right.
 
   For example, 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b462291..4105b82 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -306,6 +306,7 @@ extern unsigned long MODULES_END;
 #define RCP_HC_BIT	0x00200000UL
 #define RCP_GR_BIT	0x00040000UL
 #define RCP_GC_BIT	0x00020000UL
+#define RCP_IN_BIT	0x00008000UL	/* IPTE notify bit */
 
 /* User dirty / referenced bit for KVM's migration feature */
 #define KVM_UR_BIT	0x00008000UL
@@ -373,6 +374,7 @@ extern unsigned long MODULES_END;
 #define RCP_HC_BIT	0x0020000000000000UL
 #define RCP_GR_BIT	0x0004000000000000UL
 #define RCP_GC_BIT	0x0002000000000000UL
+#define RCP_IN_BIT	0x0000800000000000UL	/* IPTE notify bit */
 
 /* User dirty / referenced bit for KVM's migration feature */
 #define KVM_UR_BIT	0x0000800000000000UL
@@ -746,30 +748,42 @@ struct gmap {
 
 /**
  * struct gmap_rmap - reverse mapping for segment table entries
- * @next: pointer to the next gmap_rmap structure in the list
+ * @gmap: pointer to the gmap_struct
  * @entry: pointer to a segment table entry
+ * @vmaddr: virtual address in the guest address space
  */
 struct gmap_rmap {
 	struct list_head list;
+	struct gmap *gmap;
 	unsigned long *entry;
+	unsigned long vmaddr;
 };
 
 /**
  * struct gmap_pgtable - gmap information attached to a page table
  * @vmaddr: address of the 1MB segment in the process virtual memory
- * @mapper: list of segment table entries maping a page table
+ * @mapper: list of segment table entries mapping a page table
  */
 struct gmap_pgtable {
 	unsigned long vmaddr;
 	struct list_head mapper;
 };
 
+/**
+ * struct gmap_notifier - notify function block for page invalidation
+ * @notifier_call: address of callback function
+ */
+struct gmap_notifier {
+	struct list_head list;
+	void (*notifier_call)(struct gmap *gmap, unsigned long address);
+};
+
 struct gmap *gmap_alloc(struct mm_struct *mm);
 void gmap_free(struct gmap *gmap);
 void gmap_enable(struct gmap *gmap);
 void gmap_disable(struct gmap *gmap);
 int gmap_map_segment(struct gmap *gmap, unsigned long from,
-		     unsigned long to, unsigned long length);
+		     unsigned long to, unsigned long len);
 int gmap_unmap_segment(struct gmap *gmap, unsigned long to, unsigned long len);
 unsigned long __gmap_translate(unsigned long address, struct gmap *);
 unsigned long gmap_translate(unsigned long address, struct gmap *);
@@ -777,6 +791,24 @@ unsigned long __gmap_fault(unsigned long address, struct gmap *);
 unsigned long gmap_fault(unsigned long address, struct gmap *);
 void gmap_discard(unsigned long from, unsigned long to, struct gmap *);
 
+void gmap_register_ipte_notifier(struct gmap_notifier *);
+void gmap_unregister_ipte_notifier(struct gmap_notifier *);
+int gmap_ipte_notify(struct gmap *, unsigned long start, unsigned long len);
+void gmap_do_ipte_notify(struct mm_struct *, unsigned long addr, pte_t *);
+
+static inline pgste_t pgste_ipte_notify(struct mm_struct *mm,
+					unsigned long addr,
+					pte_t *ptep, pgste_t pgste)
+{
+#ifdef CONFIG_PGSTE
+	if (pgste_val(pgste) & RCP_IN_BIT) {
+		pgste_val(pgste) &= ~RCP_IN_BIT;
+		gmap_do_ipte_notify(mm, addr, ptep);
+	}
+#endif
+	return pgste;
+}
+
 /*
  * Certain architectures need to do special things when PTEs
  * within a page table are directly modified.  Thus, the following
@@ -1032,8 +1064,10 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	pte_t pte;
 
 	mm->context.flush_mm = 1;
-	if (mm_has_pgste(mm))
+	if (mm_has_pgste(mm)) {
 		pgste = pgste_get_lock(ptep);
+		pgste = pgste_ipte_notify(mm, address, ptep, pgste);
+	}
 
 	pte = *ptep;
 	if (!mm_exclusive(mm))
@@ -1052,11 +1086,14 @@ static inline pte_t ptep_modify_prot_start(struct mm_struct *mm,
 					   unsigned long address,
 					   pte_t *ptep)
 {
+	pgste_t pgste;
 	pte_t pte;
 
 	mm->context.flush_mm = 1;
-	if (mm_has_pgste(mm))
-		pgste_get_lock(ptep);
+	if (mm_has_pgste(mm)) {
+		pgste = pgste_get_lock(ptep);
+		pgste_ipte_notify(mm, address, ptep, pgste);
+	}
 
 	pte = *ptep;
 	if (!mm_exclusive(mm))
@@ -1082,8 +1119,10 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	pgste_t pgste;
 	pte_t pte;
 
-	if (mm_has_pgste(vma->vm_mm))
+	if (mm_has_pgste(vma->vm_mm)) {
 		pgste = pgste_get_lock(ptep);
+		pgste = pgste_ipte_notify(vma->vm_mm, address, ptep, pgste);
+	}
 
 	pte = *ptep;
 	__ptep_ipte(address, ptep);
@@ -1111,8 +1150,11 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	pgste_t pgste;
 	pte_t pte;
 
-	if (mm_has_pgste(mm))
+	if (mm_has_pgste(mm)) {
 		pgste = pgste_get_lock(ptep);
+		if (!full)
+			pgste = pgste_ipte_notify(mm, address, ptep, pgste);
+	}
 
 	pte = *ptep;
 	if (!full)
@@ -1135,8 +1177,10 @@ static inline pte_t ptep_set_wrprotect(struct mm_struct *mm,
 
 	if (pte_write(pte)) {
 		mm->context.flush_mm = 1;
-		if (mm_has_pgste(mm))
+		if (mm_has_pgste(mm)) {
 			pgste = pgste_get_lock(ptep);
+			pgste = pgste_ipte_notify(mm, address, ptep, pgste);
+		}
 
 		if (!mm_exclusive(mm))
 			__ptep_ipte(address, ptep);
@@ -1160,8 +1204,10 @@ static inline int ptep_set_access_flags(struct vm_area_struct *vma,
 
 	if (pte_same(*ptep, entry))
 		return 0;
-	if (mm_has_pgste(vma->vm_mm))
+	if (mm_has_pgste(vma->vm_mm)) {
 		pgste = pgste_get_lock(ptep);
+		pgste = pgste_ipte_notify(vma->vm_mm, address, ptep, pgste);
+	}
 
 	__ptep_ipte(address, ptep);
 
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index ff67d73..59880dba 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -33,8 +33,6 @@
 
 #define CHUNK_READ_WRITE 0
 #define CHUNK_READ_ONLY  1
-#define CHUNK_OLDMEM	 4
-#define CHUNK_CRASHK	 5
 
 struct mem_chunk {
 	unsigned long addr;
@@ -43,13 +41,12 @@ struct mem_chunk {
 };
 
 extern struct mem_chunk memory_chunk[];
-extern unsigned long real_memory_size;
 extern int memory_end_set;
 extern unsigned long memory_end;
 
-void detect_memory_layout(struct mem_chunk chunk[]);
-void create_mem_hole(struct mem_chunk memory_chunk[], unsigned long addr,
-		     unsigned long size, int type);
+void detect_memory_layout(struct mem_chunk chunk[], unsigned long maxsize);
+void create_mem_hole(struct mem_chunk mem_chunk[], unsigned long addr,
+		     unsigned long size);
 
 #define PRIMARY_SPACE_MODE	0
 #define ACCESS_REGISTER_MODE	1
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 1386fca..4bb2a46 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -30,7 +30,7 @@ CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
 
 obj-y	:= bitmap.o traps.o time.o process.o base.o early.o setup.o vtime.o
 obj-y	+= processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o nmi.o
-obj-y	+= debug.o irq.o ipl.o dis.o diag.o mem_detect.o sclp.o vdso.o
+obj-y	+= debug.o irq.o ipl.o dis.o diag.o sclp.o vdso.o
 obj-y	+= sysinfo.o jump_label.o lgr.o os_info.o machine_kexec.o pgm_check.o
 obj-y	+= dumpstack.o
 
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index fb8d878..f703d91 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -88,8 +88,8 @@ static struct mem_chunk *get_memory_layout(void)
 	struct mem_chunk *chunk_array;
 
 	chunk_array = kzalloc_panic(MEMORY_CHUNKS * sizeof(struct mem_chunk));
-	detect_memory_layout(chunk_array);
-	create_mem_hole(chunk_array, OLDMEM_BASE, OLDMEM_SIZE, CHUNK_CRASHK);
+	detect_memory_layout(chunk_array, 0);
+	create_mem_hole(chunk_array, OLDMEM_BASE, OLDMEM_SIZE);
 	return chunk_array;
 }
 
@@ -344,7 +344,7 @@ static int loads_init(Elf64_Phdr *phdr, u64 loads_offset)
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		mem_chunk = &chunk_array[i];
 		if (mem_chunk->size == 0)
-			break;
+			continue;
 		if (chunk_array[i].type != CHUNK_READ_WRITE &&
 		    chunk_array[i].type != CHUNK_READ_ONLY)
 			continue;
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index bda011e..dc8770d 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -482,7 +482,6 @@ void __init startup_init(void)
 	detect_machine_facilities();
 	setup_topology();
 	sclp_facilities_detect();
-	detect_memory_layout(memory_chunk);
 #ifdef CONFIG_DYNAMIC_FTRACE
 	S390_lowcore.ftrace_func = (unsigned long)ftrace_caller;
 #endif
diff --git a/arch/s390/kernel/mem_detect.c b/arch/s390/kernel/mem_detect.c
deleted file mode 100644
index 22d502e..0000000
--- a/arch/s390/kernel/mem_detect.c
+++ /dev/null
@@ -1,145 +0,0 @@
-/*
- * Copyright IBM Corp. 2008, 2009
- *
- * Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <asm/ipl.h>
-#include <asm/sclp.h>
-#include <asm/setup.h>
-
-#define ADDR2G (1ULL << 31)
-
-static void find_memory_chunks(struct mem_chunk chunk[])
-{
-	unsigned long long memsize, rnmax, rzm;
-	unsigned long addr = 0, size;
-	int i = 0, type;
-
-	rzm = sclp_get_rzm();
-	rnmax = sclp_get_rnmax();
-	memsize = rzm * rnmax;
-	if (!rzm)
-		rzm = 1ULL << 17;
-	if (sizeof(long) == 4) {
-		rzm = min(ADDR2G, rzm);
-		memsize = memsize ? min(ADDR2G, memsize) : ADDR2G;
-	}
-	do {
-		size = 0;
-		type = tprot(addr);
-		do {
-			size += rzm;
-			if (memsize && addr + size >= memsize)
-				break;
-		} while (type == tprot(addr + size));
-		if (type == CHUNK_READ_WRITE || type == CHUNK_READ_ONLY) {
-			chunk[i].addr = addr;
-			chunk[i].size = size;
-			chunk[i].type = type;
-			i++;
-		}
-		addr += size;
-	} while (addr < memsize && i < MEMORY_CHUNKS);
-}
-
-void detect_memory_layout(struct mem_chunk chunk[])
-{
-	unsigned long flags, cr0;
-
-	memset(chunk, 0, MEMORY_CHUNKS * sizeof(struct mem_chunk));
-	/* Disable IRQs, DAT and low address protection so tprot does the
-	 * right thing and we don't get scheduled away with low address
-	 * protection disabled.
-	 */
-	flags = __arch_local_irq_stnsm(0xf8);
-	__ctl_store(cr0, 0, 0);
-	__ctl_clear_bit(0, 28);
-	find_memory_chunks(chunk);
-	__ctl_load(cr0, 0, 0);
-	arch_local_irq_restore(flags);
-}
-EXPORT_SYMBOL(detect_memory_layout);
-
-/*
- * Move memory chunks array from index "from" to index "to"
- */
-static void mem_chunk_move(struct mem_chunk chunk[], int to, int from)
-{
-	int cnt = MEMORY_CHUNKS - to;
-
-	memmove(&chunk[to], &chunk[from], cnt * sizeof(struct mem_chunk));
-}
-
-/*
- * Initialize memory chunk
- */
-static void mem_chunk_init(struct mem_chunk *chunk, unsigned long addr,
-			   unsigned long size, int type)
-{
-	chunk->type = type;
-	chunk->addr = addr;
-	chunk->size = size;
-}
-
-/*
- * Create memory hole with given address, size, and type
- */
-void create_mem_hole(struct mem_chunk chunk[], unsigned long addr,
-		     unsigned long size, int type)
-{
-	unsigned long lh_start, lh_end, lh_size, ch_start, ch_end, ch_size;
-	int i, ch_type;
-
-	for (i = 0; i < MEMORY_CHUNKS; i++) {
-		if (chunk[i].size == 0)
-			continue;
-
-		/* Define chunk properties */
-		ch_start = chunk[i].addr;
-		ch_size = chunk[i].size;
-		ch_end = ch_start + ch_size - 1;
-		ch_type = chunk[i].type;
-
-		/* Is memory chunk hit by memory hole? */
-		if (addr + size <= ch_start)
-			continue; /* No: memory hole in front of chunk */
-		if (addr > ch_end)
-			continue; /* No: memory hole after chunk */
-
-		/* Yes: Define local hole properties */
-		lh_start = max(addr, chunk[i].addr);
-		lh_end = min(addr + size - 1, ch_end);
-		lh_size = lh_end - lh_start + 1;
-
-		if (lh_start == ch_start && lh_end == ch_end) {
-			/* Hole covers complete memory chunk */
-			mem_chunk_init(&chunk[i], lh_start, lh_size, type);
-		} else if (lh_end == ch_end) {
-			/* Hole starts in memory chunk and convers chunk end */
-			mem_chunk_move(chunk, i + 1, i);
-			mem_chunk_init(&chunk[i], ch_start, ch_size - lh_size,
-				       ch_type);
-			mem_chunk_init(&chunk[i + 1], lh_start, lh_size, type);
-			i += 1;
-		} else if (lh_start == ch_start) {
-			/* Hole ends in memory chunk */
-			mem_chunk_move(chunk, i + 1, i);
-			mem_chunk_init(&chunk[i], lh_start, lh_size, type);
-			mem_chunk_init(&chunk[i + 1], lh_end + 1,
-				       ch_size - lh_size, ch_type);
-			break;
-		} else {
-			/* Hole splits memory chunk */
-			mem_chunk_move(chunk, i + 2, i);
-			mem_chunk_init(&chunk[i], ch_start,
-				       lh_start - ch_start, ch_type);
-			mem_chunk_init(&chunk[i + 1], lh_start, lh_size, type);
-			mem_chunk_init(&chunk[i + 2], lh_end + 1,
-				       ch_end - lh_end, ch_type);
-			break;
-		}
-	}
-}
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 0f419c5..0a49095 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -226,25 +226,17 @@ static void __init conmode_default(void)
 }
 
 #ifdef CONFIG_ZFCPDUMP
-static void __init setup_zfcpdump(unsigned int console_devno)
+static void __init setup_zfcpdump(void)
 {
-	static char str[41];
-
 	if (ipl_info.type != IPL_TYPE_FCP_DUMP)
 		return;
 	if (OLDMEM_BASE)
 		return;
-	if (console_devno != -1)
-		sprintf(str, " cio_ignore=all,!0.0.%04x,!0.0.%04x",
-			ipl_info.data.fcp.dev_id.devno, console_devno);
-	else
-		sprintf(str, " cio_ignore=all,!0.0.%04x",
-			ipl_info.data.fcp.dev_id.devno);
-	strcat(boot_command_line, str);
+	strcat(boot_command_line, " cio_ignore=all,!ipldev,!condev");
 	console_loglevel = 2;
 }
 #else
-static inline void setup_zfcpdump(unsigned int console_devno) {}
+static inline void setup_zfcpdump(void) {}
 #endif /* CONFIG_ZFCPDUMP */
 
  /*
@@ -471,14 +463,10 @@ static void __init setup_resources(void)
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		if (!memory_chunk[i].size)
 			continue;
-		if (memory_chunk[i].type == CHUNK_OLDMEM ||
-		    memory_chunk[i].type == CHUNK_CRASHK)
-			continue;
 		res = alloc_bootmem_low(sizeof(*res));
 		res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
 		switch (memory_chunk[i].type) {
 		case CHUNK_READ_WRITE:
-		case CHUNK_CRASHK:
 			res->name = "System RAM";
 			break;
 		case CHUNK_READ_ONLY:
@@ -510,12 +498,10 @@ static void __init setup_resources(void)
 	}
 }
 
-unsigned long real_memory_size;
-EXPORT_SYMBOL_GPL(real_memory_size);
-
 static void __init setup_memory_end(void)
 {
 	unsigned long vmax, vmalloc_size, tmp;
+	unsigned long real_memory_size = 0;
 	int i;
 
 
@@ -525,7 +511,6 @@ static void __init setup_memory_end(void)
 		memory_end_set = 1;
 	}
 #endif
-	real_memory_size = 0;
 	memory_end &= PAGE_MASK;
 
 	/*
@@ -538,6 +523,8 @@ static void __init setup_memory_end(void)
 		unsigned long align;
 
 		chunk = &memory_chunk[i];
+		if (!chunk->size)
+			continue;
 		align = 1UL << (MAX_ORDER + PAGE_SHIFT - 1);
 		start = (chunk->addr + align - 1) & ~(align - 1);
 		end = (chunk->addr + chunk->size) & ~(align - 1);
@@ -588,6 +575,8 @@ static void __init setup_memory_end(void)
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		struct mem_chunk *chunk = &memory_chunk[i];
 
+		if (!chunk->size)
+			continue;
 		if (chunk->addr >= memory_end) {
 			memset(chunk, 0, sizeof(*chunk));
 			continue;
@@ -688,15 +677,6 @@ static int __init verify_crash_base(unsigned long crash_base,
 }
 
 /*
- * Reserve kdump memory by creating a memory hole in the mem_chunk array
- */
-static void __init reserve_kdump_bootmem(unsigned long addr, unsigned long size,
-					 int type)
-{
-	create_mem_hole(memory_chunk, addr, size, type);
-}
-
-/*
  * When kdump is enabled, we have to ensure that no memory from
  * the area [0 - crashkernel memory size] and
  * [crashk_res.start - crashk_res.end] is set offline.
@@ -727,16 +707,22 @@ static struct notifier_block kdump_mem_nb = {
 static void reserve_oldmem(void)
 {
 #ifdef CONFIG_CRASH_DUMP
+	unsigned long real_size = 0;
+	int i;
+
 	if (!OLDMEM_BASE)
 		return;
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		struct mem_chunk *chunk = &memory_chunk[i];
 
-	reserve_kdump_bootmem(OLDMEM_BASE, OLDMEM_SIZE, CHUNK_OLDMEM);
-	reserve_kdump_bootmem(OLDMEM_SIZE, memory_end - OLDMEM_SIZE,
-			      CHUNK_OLDMEM);
-	if (OLDMEM_BASE + OLDMEM_SIZE == real_memory_size)
+		real_size = max(real_size, chunk->addr + chunk->size);
+	}
+	create_mem_hole(memory_chunk, OLDMEM_BASE, OLDMEM_SIZE);
+	create_mem_hole(memory_chunk, OLDMEM_SIZE, real_size - OLDMEM_SIZE);
+	if (OLDMEM_BASE + OLDMEM_SIZE == real_size)
 		saved_max_pfn = PFN_DOWN(OLDMEM_BASE) - 1;
 	else
-		saved_max_pfn = PFN_DOWN(real_memory_size) - 1;
+		saved_max_pfn = PFN_DOWN(real_size) - 1;
 #endif
 }
 
@@ -775,7 +761,7 @@ static void __init reserve_crashkernel(void)
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 	insert_resource(&iomem_resource, &crashk_res);
-	reserve_kdump_bootmem(crash_base, crash_size, CHUNK_CRASHK);
+	create_mem_hole(memory_chunk, crash_base, crash_size);
 	pr_info("Reserving %lluMB of memory at %lluMB "
 		"for crashkernel (System RAM: %luMB)\n",
 		crash_size >> 20, crash_base >> 20, memory_end >> 20);
@@ -847,11 +833,10 @@ static void __init setup_memory(void)
 	 * Register RAM areas with the bootmem allocator.
 	 */
 
-	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++) {
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		unsigned long start_chunk, end_chunk, pfn;
 
-		if (memory_chunk[i].type != CHUNK_READ_WRITE &&
-		    memory_chunk[i].type != CHUNK_CRASHK)
+		if (!memory_chunk[i].size)
 			continue;
 		start_chunk = PFN_DOWN(memory_chunk[i].addr);
 		end_chunk = start_chunk + PFN_DOWN(memory_chunk[i].size);
@@ -1067,12 +1052,12 @@ void __init setup_arch(char **cmdline_p)
 		memcpy(&uaccess, &uaccess_std, sizeof(uaccess));
 
 	parse_early_param();
-
+	detect_memory_layout(memory_chunk, memory_end);
 	os_info_init();
 	setup_ipl();
+	reserve_oldmem();
 	setup_memory_end();
 	setup_addressing_mode();
-	reserve_oldmem();
 	reserve_crashkernel();
 	setup_memory();
 	setup_resources();
@@ -1097,5 +1082,5 @@ void __init setup_arch(char **cmdline_p)
 	set_preferred_console();
 
 	/* Setup zfcpdump support */
-	setup_zfcpdump(console_devno);
+	setup_zfcpdump();
 }
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 466fb33..50ea137 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -89,16 +89,19 @@ static unsigned long follow_table(struct mm_struct *mm,
 		if (unlikely(*table & _REGION_ENTRY_INV))
 			return -0x39UL;
 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		/* fallthrough */
 	case _ASCE_TYPE_REGION2:
 		table = table + ((address >> 42) & 0x7ff);
 		if (unlikely(*table & _REGION_ENTRY_INV))
 			return -0x3aUL;
 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		/* fallthrough */
 	case _ASCE_TYPE_REGION3:
 		table = table + ((address >> 31) & 0x7ff);
 		if (unlikely(*table & _REGION_ENTRY_INV))
 			return -0x3bUL;
 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
+		/* fallthrough */
 	case _ASCE_TYPE_SEGMENT:
 		table = table + ((address >> 20) & 0x7ff);
 		if (unlikely(*table & _SEGMENT_ENTRY_INV))
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index 640bea1..839592c 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y		:= init.o fault.o extmem.o mmap.o vmem.o pgtable.o maccess.o
-obj-y		+= page-states.o gup.o extable.o pageattr.o
+obj-y		+= page-states.o gup.o extable.o pageattr.o mem_detect.o
 
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 0b09b23..89ebae4 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/bootmem.h>
+#include <linux/memory.h>
 #include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/initrd.h>
@@ -36,6 +37,7 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/ctl_reg.h>
+#include <asm/sclp.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 
@@ -214,6 +216,15 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	return rc;
 }
 
+unsigned long memory_block_size_bytes(void)
+{
+	/*
+	 * Make sure the memory block size is always greater
+	 * or equal than the memory increment size.
+	 */
+	return max_t(unsigned long, MIN_MEMORY_BLOCK_SIZE, sclp_get_rzm());
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 int arch_remove_memory(u64 start, u64 size)
 {
diff --git a/arch/s390/mm/mem_detect.c b/arch/s390/mm/mem_detect.c
new file mode 100644
index 0000000..3cbd3b8
--- /dev/null
+++ b/arch/s390/mm/mem_detect.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright IBM Corp. 2008, 2009
+ *
+ * Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/ipl.h>
+#include <asm/sclp.h>
+#include <asm/setup.h>
+
+#define ADDR2G (1ULL << 31)
+
+static void find_memory_chunks(struct mem_chunk chunk[], unsigned long maxsize)
+{
+	unsigned long long memsize, rnmax, rzm;
+	unsigned long addr = 0, size;
+	int i = 0, type;
+
+	rzm = sclp_get_rzm();
+	rnmax = sclp_get_rnmax();
+	memsize = rzm * rnmax;
+	if (!rzm)
+		rzm = 1ULL << 17;
+	if (sizeof(long) == 4) {
+		rzm = min(ADDR2G, rzm);
+		memsize = memsize ? min(ADDR2G, memsize) : ADDR2G;
+	}
+	if (maxsize)
+		memsize = memsize ? min((unsigned long)memsize, maxsize) : maxsize;
+	do {
+		size = 0;
+		type = tprot(addr);
+		do {
+			size += rzm;
+			if (memsize && addr + size >= memsize)
+				break;
+		} while (type == tprot(addr + size));
+		if (type == CHUNK_READ_WRITE || type == CHUNK_READ_ONLY) {
+			if (memsize && (addr + size > memsize))
+				size = memsize - addr;
+			chunk[i].addr = addr;
+			chunk[i].size = size;
+			chunk[i].type = type;
+			i++;
+		}
+		addr += size;
+	} while (addr < memsize && i < MEMORY_CHUNKS);
+}
+
+/**
+ * detect_memory_layout - fill mem_chunk array with memory layout data
+ * @chunk: mem_chunk array to be filled
+ * @maxsize: maximum address where memory detection should stop
+ *
+ * Fills the passed in memory chunk array with the memory layout of the
+ * machine. The array must have a size of at least MEMORY_CHUNKS and will
+ * be fully initialized afterwards.
+ * If the maxsize paramater has a value > 0 memory detection will stop at
+ * that address. It is guaranteed that all chunks have an ending address
+ * that is smaller than maxsize.
+ * If maxsize is 0 all memory will be detected.
+ */
+void detect_memory_layout(struct mem_chunk chunk[], unsigned long maxsize)
+{
+	unsigned long flags, flags_dat, cr0;
+
+	memset(chunk, 0, MEMORY_CHUNKS * sizeof(struct mem_chunk));
+	/*
+	 * Disable IRQs, DAT and low address protection so tprot does the
+	 * right thing and we don't get scheduled away with low address
+	 * protection disabled.
+	 */
+	local_irq_save(flags);
+	flags_dat = __arch_local_irq_stnsm(0xfb);
+	/*
+	 * In case DAT was enabled, make sure chunk doesn't reside in vmalloc
+	 * space. We have disabled DAT and any access to vmalloc area will
+	 * cause an exception.
+	 * If DAT was disabled we are called from early ipl code.
+	 */
+	if (test_bit(5, &flags_dat)) {
+		if (WARN_ON_ONCE(is_vmalloc_or_module_addr(chunk)))
+			goto out;
+	}
+	__ctl_store(cr0, 0, 0);
+	__ctl_clear_bit(0, 28);
+	find_memory_chunks(chunk, maxsize);
+	__ctl_load(cr0, 0, 0);
+out:
+	__arch_local_irq_ssm(flags_dat);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(detect_memory_layout);
+
+/*
+ * Create memory hole with given address and size.
+ */
+void create_mem_hole(struct mem_chunk mem_chunk[], unsigned long addr,
+		     unsigned long size)
+{
+	int i;
+
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		struct mem_chunk *chunk = &mem_chunk[i];
+
+		if (chunk->size == 0)
+			continue;
+		if (addr > chunk->addr + chunk->size)
+			continue;
+		if (addr + size <= chunk->addr)
+			continue;
+		/* Split */
+		if ((addr > chunk->addr) &&
+		    (addr + size < chunk->addr + chunk->size)) {
+			struct mem_chunk *new = chunk + 1;
+
+			memmove(new, chunk, (MEMORY_CHUNKS-i-1) * sizeof(*new));
+			new->addr = addr + size;
+			new->size = chunk->addr + chunk->size - new->addr;
+			chunk->size = addr - chunk->addr;
+			continue;
+		} else if ((addr <= chunk->addr) &&
+			   (addr + size >= chunk->addr + chunk->size)) {
+			memset(chunk, 0 , sizeof(*chunk));
+		} else if (addr + size < chunk->addr + chunk->size) {
+			chunk->size =  chunk->addr + chunk->size - addr - size;
+			chunk->addr = addr + size;
+		} else if (addr > chunk->addr) {
+			chunk->size = addr - chunk->addr;
+		}
+	}
+}
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index bd954e9..7805ddc 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -454,9 +454,8 @@ unsigned long gmap_translate(unsigned long address, struct gmap *gmap)
 }
 EXPORT_SYMBOL_GPL(gmap_translate);
 
-static int gmap_connect_pgtable(unsigned long segment,
-				unsigned long *segment_ptr,
-				struct gmap *gmap)
+static int gmap_connect_pgtable(unsigned long address, unsigned long segment,
+				unsigned long *segment_ptr, struct gmap *gmap)
 {
 	unsigned long vmaddr;
 	struct vm_area_struct *vma;
@@ -491,7 +490,9 @@ static int gmap_connect_pgtable(unsigned long segment,
 	/* Link gmap segment table entry location to page table. */
 	page = pmd_page(*pmd);
 	mp = (struct gmap_pgtable *) page->index;
+	rmap->gmap = gmap;
 	rmap->entry = segment_ptr;
+	rmap->vmaddr = address;
 	spin_lock(&mm->page_table_lock);
 	if (*segment_ptr == segment) {
 		list_add(&rmap->list, &mp->mapper);
@@ -553,7 +554,7 @@ unsigned long __gmap_fault(unsigned long address, struct gmap *gmap)
 		if (!(segment & _SEGMENT_ENTRY_RO))
 			/* Nothing mapped in the gmap address space. */
 			break;
-		rc = gmap_connect_pgtable(segment, segment_ptr, gmap);
+		rc = gmap_connect_pgtable(address, segment, segment_ptr, gmap);
 		if (rc)
 			return rc;
 	}
@@ -619,6 +620,118 @@ void gmap_discard(unsigned long from, unsigned long to, struct gmap *gmap)
 }
 EXPORT_SYMBOL_GPL(gmap_discard);
 
+static LIST_HEAD(gmap_notifier_list);
+static DEFINE_SPINLOCK(gmap_notifier_lock);
+
+/**
+ * gmap_register_ipte_notifier - register a pte invalidation callback
+ * @nb: pointer to the gmap notifier block
+ */
+void gmap_register_ipte_notifier(struct gmap_notifier *nb)
+{
+	spin_lock(&gmap_notifier_lock);
+	list_add(&nb->list, &gmap_notifier_list);
+	spin_unlock(&gmap_notifier_lock);
+}
+EXPORT_SYMBOL_GPL(gmap_register_ipte_notifier);
+
+/**
+ * gmap_unregister_ipte_notifier - remove a pte invalidation callback
+ * @nb: pointer to the gmap notifier block
+ */
+void gmap_unregister_ipte_notifier(struct gmap_notifier *nb)
+{
+	spin_lock(&gmap_notifier_lock);
+	list_del_init(&nb->list);
+	spin_unlock(&gmap_notifier_lock);
+}
+EXPORT_SYMBOL_GPL(gmap_unregister_ipte_notifier);
+
+/**
+ * gmap_ipte_notify - mark a range of ptes for invalidation notification
+ * @gmap: pointer to guest mapping meta data structure
+ * @address: virtual address in the guest address space
+ * @len: size of area
+ *
+ * Returns 0 if for each page in the given range a gmap mapping exists and
+ * the invalidation notification could be set. If the gmap mapping is missing
+ * for one or more pages -EFAULT is returned. If no memory could be allocated
+ * -ENOMEM is returned. This function establishes missing page table entries.
+ */
+int gmap_ipte_notify(struct gmap *gmap, unsigned long start, unsigned long len)
+{
+	unsigned long addr;
+	spinlock_t *ptl;
+	pte_t *ptep, entry;
+	pgste_t pgste;
+	int rc = 0;
+
+	if ((start & ~PAGE_MASK) || (len & ~PAGE_MASK))
+		return -EINVAL;
+	down_read(&gmap->mm->mmap_sem);
+	while (len) {
+		/* Convert gmap address and connect the page tables */
+		addr = __gmap_fault(start, gmap);
+		if (IS_ERR_VALUE(addr)) {
+			rc = addr;
+			break;
+		}
+		/* Get the page mapped */
+		if (get_user_pages(current, gmap->mm, addr, 1, 1, 0,
+				   NULL, NULL) != 1) {
+			rc = -EFAULT;
+			break;
+		}
+		/* Walk the process page table, lock and get pte pointer */
+		ptep = get_locked_pte(gmap->mm, addr, &ptl);
+		if (unlikely(!ptep))
+			continue;
+		/* Set notification bit in the pgste of the pte */
+		entry = *ptep;
+		if ((pte_val(entry) & (_PAGE_INVALID | _PAGE_RO)) == 0) {
+			pgste = pgste_get_lock(ptep);
+			pgste_val(pgste) |= RCP_IN_BIT;
+			pgste_set_unlock(ptep, pgste);
+			start += PAGE_SIZE;
+			len -= PAGE_SIZE;
+		}
+		spin_unlock(ptl);
+	}
+	up_read(&gmap->mm->mmap_sem);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(gmap_ipte_notify);
+
+/**
+ * gmap_do_ipte_notify - call all invalidation callbacks for a specific pte.
+ * @mm: pointer to the process mm_struct
+ * @addr: virtual address in the process address space
+ * @pte: pointer to the page table entry
+ *
+ * This function is assumed to be called with the page table lock held
+ * for the pte to notify.
+ */
+void gmap_do_ipte_notify(struct mm_struct *mm, unsigned long addr, pte_t *pte)
+{
+	unsigned long segment_offset;
+	struct gmap_notifier *nb;
+	struct gmap_pgtable *mp;
+	struct gmap_rmap *rmap;
+	struct page *page;
+
+	segment_offset = ((unsigned long) pte) & (255 * sizeof(pte_t));
+	segment_offset = segment_offset * (4096 / sizeof(pte_t));
+	page = pfn_to_page(__pa(pte) >> PAGE_SHIFT);
+	mp = (struct gmap_pgtable *) page->index;
+	spin_lock(&gmap_notifier_lock);
+	list_for_each_entry(rmap, &mp->mapper, list) {
+		list_for_each_entry(nb, &gmap_notifier_list, list)
+			nb->notifier_call(rmap->gmap,
+					  rmap->vmaddr + segment_offset);
+	}
+	spin_unlock(&gmap_notifier_lock);
+}
+
 static inline unsigned long *page_table_alloc_pgste(struct mm_struct *mm,
 						    unsigned long vmaddr)
 {
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 3583705..8b268fc 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -375,9 +375,8 @@ void __init vmem_map_init(void)
 
 	ro_start = PFN_ALIGN((unsigned long)&_stext);
 	ro_end = (unsigned long)&_eshared & PAGE_MASK;
-	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++) {
-		if (memory_chunk[i].type == CHUNK_CRASHK ||
-		    memory_chunk[i].type == CHUNK_OLDMEM)
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		if (!memory_chunk[i].size)
 			continue;
 		start = memory_chunk[i].addr;
 		end = memory_chunk[i].addr + memory_chunk[i].size;
@@ -412,9 +411,6 @@ static int __init vmem_convert_memory_chunk(void)
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		if (!memory_chunk[i].size)
 			continue;
-		if (memory_chunk[i].type == CHUNK_CRASHK ||
-		    memory_chunk[i].type == CHUNK_OLDMEM)
-			continue;
 		seg = kzalloc(sizeof(*seg), GFP_KERNEL);
 		if (!seg)
 			panic("Out of memory...\n");
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 178836e..bf07c3a 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -345,7 +345,6 @@ struct memory_increment {
 	struct list_head list;
 	u16 rn;
 	int standby;
-	int usecount;
 };
 
 struct assign_storage_sccb {
@@ -463,21 +462,10 @@ static int sclp_mem_change_state(unsigned long start, unsigned long size,
 			break;
 		if (start > istart + rzm - 1)
 			continue;
-		if (online) {
-			if (incr->usecount++)
-				continue;
-			/*
-			 * Don't break the loop if one assign fails. Loop may
-			 * be walked again on CANCEL and we can't save
-			 * information if state changed before or not.
-			 * So continue and increase usecount for all increments.
-			 */
+		if (online)
 			rc |= sclp_assign_storage(incr->rn);
-		} else {
-			if (--incr->usecount)
-				continue;
+		else
 			sclp_unassign_storage(incr->rn);
-		}
 	}
 	return rc ? -EIO : 0;
 }
@@ -561,8 +549,6 @@ static void __init sclp_add_standby_memory(void)
 	add_memory_merged(0);
 }
 
-#define MEM_SCT_SIZE (1UL << SECTION_SIZE_BITS)
-
 static void __init insert_increment(u16 rn, int standby, int assigned)
 {
 	struct memory_increment *incr, *new_incr;
@@ -574,8 +560,6 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 		return;
 	new_incr->rn = rn;
 	new_incr->standby = standby;
-	if (!standby)
-		new_incr->usecount = rzm > MEM_SCT_SIZE ? rzm/MEM_SCT_SIZE : 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 2282061..9e5e146 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -426,7 +426,7 @@ static int zcore_memmap_open(struct inode *inode, struct file *filp)
 			      GFP_KERNEL);
 	if (!chunk_array)
 		return -ENOMEM;
-	detect_memory_layout(chunk_array);
+	detect_memory_layout(chunk_array, 0);
 	buf = kzalloc(MEMORY_CHUNKS * CHUNK_INFO_SIZE, GFP_KERNEL);
 	if (!buf) {
 		kfree(chunk_array);
@@ -557,7 +557,7 @@ static void __init set_lc_mask(struct save_area *map)
 /*
  * Initialize dump globals for a given architecture
  */
-static int __init sys_info_init(enum arch_id arch)
+static int __init sys_info_init(enum arch_id arch, unsigned long mem_end)
 {
 	int rc;
 
@@ -579,7 +579,7 @@ static int __init sys_info_init(enum arch_id arch)
 	rc = init_cpu_info(arch);
 	if (rc)
 		return rc;
-	sys_info.mem_size = real_memory_size;
+	sys_info.mem_size = mem_end;
 
 	return 0;
 }
@@ -601,7 +601,7 @@ static int __init check_sdias(void)
 	return 0;
 }
 
-static int __init get_mem_size(unsigned long *mem)
+static int __init get_mem_info(unsigned long *mem, unsigned long *end)
 {
 	int i;
 	struct mem_chunk *chunk_array;
@@ -610,33 +610,31 @@ static int __init get_mem_size(unsigned long *mem)
 			      GFP_KERNEL);
 	if (!chunk_array)
 		return -ENOMEM;
-	detect_memory_layout(chunk_array);
+	detect_memory_layout(chunk_array, 0);
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		if (chunk_array[i].size == 0)
 			break;
 		*mem += chunk_array[i].size;
+		*end = max(*end, chunk_array[i].addr + chunk_array[i].size);
 	}
 	kfree(chunk_array);
 	return 0;
 }
 
-static int __init zcore_header_init(int arch, struct zcore_header *hdr)
+static void __init zcore_header_init(int arch, struct zcore_header *hdr,
+				     unsigned long mem_size)
 {
-	int rc, i;
-	unsigned long memory = 0;
 	u32 prefix;
+	int i;
 
 	if (arch == ARCH_S390X)
 		hdr->arch_id = DUMP_ARCH_S390X;
 	else
 		hdr->arch_id = DUMP_ARCH_S390;
-	rc = get_mem_size(&memory);
-	if (rc)
-		return rc;
-	hdr->mem_size = memory;
-	hdr->rmem_size = memory;
+	hdr->mem_size = mem_size;
+	hdr->rmem_size = mem_size;
 	hdr->mem_end = sys_info.mem_size;
-	hdr->num_pages = memory / PAGE_SIZE;
+	hdr->num_pages = mem_size / PAGE_SIZE;
 	hdr->tod = get_tod_clock();
 	get_cpu_id(&hdr->cpu_id);
 	for (i = 0; zfcpdump_save_areas[i]; i++) {
@@ -647,7 +645,6 @@ static int __init zcore_header_init(int arch, struct zcore_header *hdr)
 		hdr->lc_vec[hdr->cpu_cnt] = prefix;
 		hdr->cpu_cnt++;
 	}
-	return 0;
 }
 
 /*
@@ -682,9 +679,11 @@ static int __init zcore_reipl_init(void)
 
 static int __init zcore_init(void)
 {
+	unsigned long mem_size, mem_end;
 	unsigned char arch;
 	int rc;
 
+	mem_size = mem_end = 0;
 	if (ipl_info.type != IPL_TYPE_FCP_DUMP)
 		return -ENODATA;
 	if (OLDMEM_BASE)
@@ -727,13 +726,14 @@ static int __init zcore_init(void)
 	}
 #endif /* CONFIG_64BIT */
 
-	rc = sys_info_init(arch);
+	rc = get_mem_info(&mem_size, &mem_end);
 	if (rc)
 		goto fail;
 
-	rc = zcore_header_init(arch, &zcore_header);
+	rc = sys_info_init(arch, mem_end);
 	if (rc)
 		goto fail;
+	zcore_header_init(arch, &zcore_header, mem_size);
 
 	rc = zcore_reipl_init();
 	if (rc)
diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 2d2a966..a9fe3de 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -1,7 +1,7 @@
 /*
  *   S/390 common I/O routines -- blacklisting of specific devices
  *
- *    Copyright IBM Corp. 1999, 2002
+ *    Copyright IBM Corp. 1999, 2013
  *    Author(s): Ingo Adlung (adlung@de.ibm.com)
  *		 Cornelia Huck (cornelia.huck@de.ibm.com)
  *		 Arnd Bergmann (arndb@de.ibm.com)
@@ -17,8 +17,9 @@
 #include <linux/ctype.h>
 #include <linux/device.h>
 
-#include <asm/cio.h>
 #include <asm/uaccess.h>
+#include <asm/cio.h>
+#include <asm/ipl.h>
 
 #include "blacklist.h"
 #include "cio.h"
@@ -172,6 +173,29 @@ static int blacklist_parse_parameters(char *str, range_action action,
 			to_cssid = __MAX_CSSID;
 			to_ssid = __MAX_SSID;
 			to = __MAX_SUBCHANNEL;
+		} else if (strcmp(parm, "ipldev") == 0) {
+			if (ipl_info.type == IPL_TYPE_CCW) {
+				from_cssid = 0;
+				from_ssid = ipl_info.data.ccw.dev_id.ssid;
+				from = ipl_info.data.ccw.dev_id.devno;
+			} else if (ipl_info.type == IPL_TYPE_FCP ||
+				   ipl_info.type == IPL_TYPE_FCP_DUMP) {
+				from_cssid = 0;
+				from_ssid = ipl_info.data.fcp.dev_id.ssid;
+				from = ipl_info.data.fcp.dev_id.devno;
+			} else {
+				continue;
+			}
+			to_cssid = from_cssid;
+			to_ssid = from_ssid;
+			to = from;
+		} else if (strcmp(parm, "condev") == 0) {
+			if (console_devno == -1)
+				continue;
+
+			from_cssid = to_cssid = 0;
+			from_ssid = to_ssid = 0;
+			from = to = console_devno;
 		} else {
 			rc = parse_busid(strsep(&parm, "-"), &from_cssid,
 					 &from_ssid, &from, msgtrigger);
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index b8b340a..9de41aa 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -954,15 +954,11 @@ EXPORT_SYMBOL(ap_driver_unregister);
 
 void ap_bus_force_rescan(void)
 {
-	/* Delete the AP bus rescan timer. */
-	del_timer(&ap_config_timer);
-
-	/* processing a synchonuous bus rescan */
-	ap_scan_bus(NULL);
-
-	/* Setup the AP bus rescan timer again. */
-	ap_config_timer.expires = jiffies + ap_config_time * HZ;
-	add_timer(&ap_config_timer);
+	/* reconfigure the AP bus rescan timer. */
+	mod_timer(&ap_config_timer, jiffies + ap_config_time * HZ);
+	/* processing a asynchronous bus rescan */
+	queue_work(ap_work_queue, &ap_config_work);
+	flush_work(&ap_config_work);
 }
 EXPORT_SYMBOL(ap_bus_force_rescan);
 
@@ -1305,8 +1301,9 @@ static void ap_scan_bus(struct work_struct *unused)
 	int rc, i;
 
 	ap_query_configuration();
-	if (ap_select_domain() != 0)
+	if (ap_select_domain() != 0) {
 		return;
+	}
 	for (i = 0; i < AP_DEVICES; i++) {
 		qid = AP_MKQID(i, ap_domain_index);
 		dev = bus_find_device(&ap_bus_type, NULL,
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 6711e65..2ea6165 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -443,29 +443,30 @@ static int __init test_devices_support(unsigned long addr)
 }
 /*
  * Init function for virtio
- * devices are in a single page above top of "normal" mem
+ * devices are in a single page above top of "normal" + standby mem
  */
 static int __init kvm_devices_init(void)
 {
 	int rc;
+	unsigned long total_memory_size = sclp_get_rzm() * sclp_get_rnmax();
 
 	if (!MACHINE_IS_KVM)
 		return -ENODEV;
 
-	if (test_devices_support(real_memory_size) < 0)
+	if (test_devices_support(total_memory_size) < 0)
 		return -ENODEV;
 
-	rc = vmem_add_mapping(real_memory_size, PAGE_SIZE);
+	rc = vmem_add_mapping(total_memory_size, PAGE_SIZE);
 	if (rc)
 		return rc;
 
-	kvm_devices = (void *) real_memory_size;
+	kvm_devices = (void *) total_memory_size;
 
 	kvm_root = root_device_register("kvm_s390");
 	if (IS_ERR(kvm_root)) {
 		rc = PTR_ERR(kvm_root);
 		printk(KERN_ERR "Could not register kvm_s390 root device");
-		vmem_remove_mapping(real_memory_size, PAGE_SIZE);
+		vmem_remove_mapping(total_memory_size, PAGE_SIZE);
 		return rc;
 	}
 

