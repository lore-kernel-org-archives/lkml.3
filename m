Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaLEAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:25:27 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:56997 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932489AbaLEAZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:25:26 -0500
X-Greylist: delayed 1007 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2014 19:25:25 EST
Message-ID: <5480F756.90106@upv.es>
Date: Fri, 05 Dec 2014 01:07:50 +0100
From: Hector Marco <hecmargi@upv.es>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        will.deacon@arm.com, oleg@redhat.com, luto@amacapital.net,
        keescook@chromium.org
Subject: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack

  The issue appears on PIE linked executables when all memory areas of
  a process are randomized (randomize_va_space=2). In this case, the
  attack "offset2lib" de-randomizes all library areas on 64 bit Linux
  systems in less than one second.

  Further details of the PoC attack at:
  http://cybersecurity.upv.es/attacks/offset2lib/offset2lib.html

  PIE linked applications are loaded side by side with the dynamic
  libraries, which is exploited by the offset2lib attack. Moving away
  the executable from the mmap_base area (libraries area) prevents the
  attack.

  This patch loads the PIE linked executable in a different area than
  the libraries when randomize_va_space=3.

  Patch implementation details:

   - The ELF_ET_DYN_BASE address is used as the base to load randomly
     the PIE executable.

   - The executable image has the same entropy than
     randomize_va_space=2.


  If the randomize_va_space is set to 2 then this patch does not change
  any behavior when loading new processes.

  The patch has been tested on x86_64/32 and ARM/ARM64.


diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 5e85ed3..6602f5e 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -10,6 +10,7 @@
 #include <linux/personality.h>
 #include <linux/random.h>
 #include <asm/cachetype.h>
+#include <asm/elf.h>

 #define COLOUR_ALIGN(addr,pgoff)		\
 	((((addr)+SHMLBA-1)&~(SHMLBA-1)) +	\
@@ -19,6 +20,14 @@
 #define MIN_GAP (128*1024*1024UL)
 #define MAX_GAP ((TASK_SIZE)/6*5)

+#if ELF_EXEC_PAGESIZE > PAGE_SIZE
+#define ELF_MIN_ALIGN   ELF_EXEC_PAGESIZE
+#else
+#define ELF_MIN_ALIGN   PAGE_SIZE
+#endif
+
+#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))
+
 static int mmap_is_legacy(void)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
@@ -184,6 +193,9 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	} else {
 		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (randomize_va_space > 2)
+			mm->exec_base = ELF_PAGESTART(ELF_ET_DYN_BASE -
+				((get_random_int() % (1 << 8)) << PAGE_SHIFT));
 	}
 }

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 1d73662..32be3fd 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -28,6 +28,16 @@
 #include <linux/random.h>

 #include <asm/cputype.h>
+#include <asm/elf.h>
+
+
+#if ELF_EXEC_PAGESIZE > PAGE_SIZE
+#define ELF_MIN_ALIGN   ELF_EXEC_PAGESIZE
+#else
+#define ELF_MIN_ALIGN   PAGE_SIZE
+#endif
+
+#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))

 /*
  * Leave enough space between the mmap area and the stack to honour
ulimit in
@@ -93,6 +103,8 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (randomize_va_space > 2)
+			mm->exec_base = ELF_PAGESTART(ELF_ET_DYN_BASE - mmap_rnd());
 	}
 }
 EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 919b912..8cb9855 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -31,6 +31,14 @@
 #include <linux/sched.h>
 #include <asm/elf.h>

+#if ELF_EXEC_PAGESIZE > PAGE_SIZE
+#define ELF_MIN_ALIGN   ELF_EXEC_PAGESIZE
+#else
+#define ELF_MIN_ALIGN   PAGE_SIZE
+#endif
+
+#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))
+
 struct va_alignment __read_mostly va_align = {
 	.flags = -1,
 };
@@ -120,5 +128,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (randomize_va_space > 2)
+			mm->exec_base = ELF_PAGESTART(ELF_ET_DYN_BASE - mmap_rnd());
 	}
 }
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d8fc060..6f319c1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -804,8 +804,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * load_bias value in order to establish proper
 			 * non-randomized mappings.
 			 */
-			if (current->flags & PF_RANDOMIZE)
+			if (current->flags & PF_RANDOMIZE) {
 				load_bias = 0;
+				if (randomize_va_space > 2)
+					load_bias = current->mm->exec_base;
+			}
 			else
 				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #else
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6e0b286..dd052ec 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -353,6 +353,7 @@ struct mm_struct {
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
 	unsigned long mmap_legacy_base;         /* base of mmap area in
bottom-up allocations */
+	unsigned long exec_base;		/* base of exec area */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long highest_vm_end;		/* highest vma end address */
 	pgd_t * pgd;
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746..1fd4553 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -551,6 +551,7 @@ static void mm_init_owner(struct mm_struct *mm,
struct task_struct *p)
 static struct mm_struct *mm_init(struct mm_struct *mm, struct
task_struct *p)
 {
 	mm->mmap = NULL;
+	mm->exec_base = 0;
 	mm->mm_rb = RB_ROOT;
 	mm->vmacache_seqnum = 0;
 	atomic_set(&mm->mm_users, 1);


  Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
  Signed-off-by: Ismael Ripoll <iripoll@upv.es>
