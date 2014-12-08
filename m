Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaLHWPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:15:53 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:57029 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbaLHWPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:15:51 -0500
Message-ID: <20141208231509.557032xsqu9sfgtp@webmail.upv.es>
Date: Mon, 08 Dec 2014 23:15:09 +0100
From: Hector Marco Gisbert <hecmargi@upv.es>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib
 attack
References: <5480F756.90106@upv.es>
 <CAGXu5jJkLZLg6c6kOBwXbS5WFFiniJv_ap9uNsQDQYRokLj3jw@mail.gmail.com>
In-Reply-To: <CAGXu5jJkLZLg6c6kOBwXbS5WFFiniJv_ap9uNsQDQYRokLj3jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
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
   the libraries when randomize_va_space=3. By default randomize_va_space
   is set to 3 because this shouldn't break any existing userspace
   configuration.

   Patch implementation details:

    - The ELF_ET_DYN_BASE address is used as the base to load randomly
      the PIE executable.

    - The executable image has the same entropy than
      randomize_va_space=2.


   If the randomize_va_space is set to 2 then this patch does not change
   any behavior when loading new processes.

   The patch has been tested on x86_64/32 and ARM/ARM64.


   Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
   Signed-off-by: Ismael Ripoll <iripoll@upv.es>


diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 57baff5..1068492 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -690,6 +690,19 @@ that support this feature.
      with CONFIG_COMPAT_BRK enabled, which excludes the heap from process
      address space randomization.

+3 - It is an extension of the previous option, which only affects
+    PIE-linked binaries. If enabled, the application executable is
+    located to a random area on its own. Note that with options 1
+    and 2, the executable is placed side by side with the rest of the
+    mmaped objects (libraries, maped files, etc.).
+
+    An address leak from an area does not compromise the others. So,
+    this option removes the offset2lib weakness.
+
+    As far as we know it shall not break backward compatibility and
+    does not introduce overhead on the execution. Therefore, it is
+    advisable to enable it.
+
  ==============================================================

  reboot-cmd: (Sparc only)
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 5e85ed3..0b1e18c 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -9,6 +9,7 @@
  #include <linux/io.h>
  #include <linux/personality.h>
  #include <linux/random.h>
+#include <linux/elf.h>
  #include <asm/cachetype.h>

  #define COLOUR_ALIGN(addr,pgoff)		\
@@ -19,6 +20,17 @@
  #define MIN_GAP (128*1024*1024UL)
  #define MAX_GAP ((TASK_SIZE)/6*5)

+/* 8 bits of randomness in 20 address space bits */
+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd = 0;
+	if ((current->flags & PF_RANDOMIZE) &&
+		!(current->personality & ADDR_NO_RANDOMIZE))
+		rnd = (get_random_int() % (1 << 8)) << PAGE_SHIFT;
+
+	return rnd;
+}
+
  static int mmap_is_legacy(void)
  {
  	if (current->personality & ADDR_COMPAT_LAYOUT)
@@ -30,7 +42,7 @@ static int mmap_is_legacy(void)
  	return sysctl_legacy_va_layout;
  }

-static unsigned long mmap_base(unsigned long rnd)
+static unsigned long mmap_base(void)
  {
  	unsigned long gap = rlimit(RLIMIT_STACK);

@@ -39,7 +51,7 @@ static unsigned long mmap_base(unsigned long rnd)
  	else if (gap > MAX_GAP)
  		gap = MAX_GAP;

-	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
+	return PAGE_ALIGN(TASK_SIZE - gap - mmap_rnd());
  }

  /*
@@ -171,19 +183,14 @@ arch_get_unmapped_area_topdown(struct file  
*filp, const unsigned long addr0,

  void arch_pick_mmap_layout(struct mm_struct *mm)
  {
-	unsigned long random_factor = 0UL;
-
-	/* 8 bits of randomness in 20 address space bits */
-	if ((current->flags & PF_RANDOMIZE) &&
-	    !(current->personality & ADDR_NO_RANDOMIZE))
-		random_factor = (get_random_int() % (1 << 8)) << PAGE_SHIFT;
-
  	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
+		mm->mmap_base = TASK_UNMAPPED_BASE + mmap_rnd();
  		mm->get_unmapped_area = arch_get_unmapped_area;
  	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base();
  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (randomize_va_space > 2)
+			mm->exec_base = ELF_PAGESTART(ELF_ET_DYN_BASE - mmap_rnd());
  	}
  }

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 1d73662..793d4b6 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -93,6 +93,8 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  	} else {
  		mm->mmap_base = mmap_base();
  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (randomize_va_space > 2)
+			mm->exec_base = ELF_PAGESTART(ELF_ET_DYN_BASE - mmap_rnd());
  	}
  }
  EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 919b912..06202d3 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -29,6 +29,7 @@
  #include <linux/random.h>
  #include <linux/limits.h>
  #include <linux/sched.h>
+#include <linux/elf.h>
  #include <asm/elf.h>

  struct va_alignment __read_mostly va_align = {
@@ -120,5 +121,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  		mm->get_unmapped_area = arch_get_unmapped_area;
  	} else {
  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (randomize_va_space > 2)
+			mm->exec_base = ELF_PAGESTART(ELF_ET_DYN_BASE - mmap_rnd());
  	}
  }
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d8fc060..8a89afe 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -65,17 +65,11 @@ static int elf_core_dump(struct coredump_params *cprm);
  #define elf_core_dump	NULL
  #endif

-#if ELF_EXEC_PAGESIZE > PAGE_SIZE
-#define ELF_MIN_ALIGN	ELF_EXEC_PAGESIZE
-#else
-#define ELF_MIN_ALIGN	PAGE_SIZE
-#endif

  #ifndef ELF_CORE_EFLAGS
  #define ELF_CORE_EFLAGS	0
  #endif

-#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))
  #define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN-1))
  #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))

@@ -805,7 +799,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
  			 * non-randomized mappings.
  			 */
  			if (current->flags & PF_RANDOMIZE)
-				load_bias = 0;
+				load_bias = current->mm->exec_base;
  			else
  				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
  #else
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 67a5fa7..46fb890 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -3,6 +3,7 @@

  #include <asm/elf.h>
  #include <uapi/linux/elf.h>
+#include <asm/page.h>

  #ifndef elf_read_implies_exec
    /* Executables for which elf_read_implies_exec() returns TRUE will
@@ -48,4 +49,13 @@ static inline int  
elf_coredump_extra_notes_write(struct coredump_params *cprm) {
  extern int elf_coredump_extra_notes_size(void);
  extern int elf_coredump_extra_notes_write(struct coredump_params *cprm);
  #endif
+
+#if ELF_EXEC_PAGESIZE > PAGE_SIZE
+#define ELF_MIN_ALIGN   ELF_EXEC_PAGESIZE
+#else
+#define ELF_MIN_ALIGN   PAGE_SIZE
+#endif
+
+#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN-1))
+
  #endif /* _LINUX_ELF_H */
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
  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
  {
  	mm->mmap = NULL;
+	mm->exec_base = 0;
  	mm->mm_rb = RB_ROOT;
  	mm->vmacache_seqnum = 0;
  	atomic_set(&mm->mm_users, 1);
diff --git a/mm/memory.c b/mm/memory.c
index d5f2ae9..47a185f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -100,12 +100,17 @@ EXPORT_SYMBOL(high_memory);
   *
   * ( When CONFIG_COMPAT_BRK=y we exclude brk from randomization,
   *   as ancient (libc5 based) binaries can segfault. )
+ *
+ *  The default when is not COMPAT is moved from 2 to 3 to
+ *  improve PIE-linked binaries randomization.
+ *  (This prevent the offset2lib attack)
+ *
   */
  int randomize_va_space __read_mostly =
  #ifdef CONFIG_COMPAT_BRK
  					1;
  #else
-					2;
+					3;
  #endif

  static int __init disable_randmaps(char *s)

