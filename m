Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbbAGR1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:27:53 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:38342 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751929AbbAGR1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:27:51 -0500
Message-ID: <20150107182636.11006j44smrclg0c@webmail.upv.es>
Date: Wed, 07 Jan 2015 18:26:36 +0100
From: Hector Marco Gisbert <hecmargi@upv.es>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Arun Chandran <achandran@mvista.com>,
        Hanno =?iso-8859-1?b?QvZjaw==?= <hanno@hboeck.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib
 attack
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net>
In-Reply-To: <20141211221158.GS18807@outflux.net>
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


[PATH] Fix offset2lib issue for x86*, ARM*, PowerPC and MIPS.

Hi,

Following your suggestions here is the patch that fixes the offset2lib issue.

Only s390 architecture is not affected by the offset2lib, the solution for
all the architectures is based on this one, and so the
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE option is not longer needed (removed).


Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Ismael Ripoll <iripoll@upv.es>


diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97d07ed..ee7ea7e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1,7 +1,6 @@
  config ARM
  	bool
  	default y
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
  	select ARCH_HAVE_CUSTOM_GPIO_H
diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index afb9caf..6755cd8 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -115,7 +115,8 @@ int dump_task_regs(struct task_struct *t,  
elf_gregset_t *elfregs);
     the loader.  We need to make sure that it is out of the way of the program
     that it will "exec", and that there is sufficient room for the brk.  */

-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE / 3)
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE / 3))

  /* When the program starts, a1 contains a pointer to a function to be
     registered with atexit, as per the SVR4 ABI.  A value of 0 means we
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 5e85ed3..75ba490 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -30,6 +30,17 @@ static int mmap_is_legacy(void)
  	return sysctl_legacy_va_layout;
  }

+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd = 0;
+
+	/* 8 bits of randomness in 20 address space bits */
+	if (current->flags & PF_RANDOMIZE)
+		rnd = (long)get_random_int() % (1 << 8);
+
+	return rnd << PAGE_SHIFT;
+}
+
  static unsigned long mmap_base(unsigned long rnd)
  {
  	unsigned long gap = rlimit(RLIMIT_STACK);
@@ -230,3 +241,12 @@ int devmem_is_allowed(unsigned long pfn)
  }

  #endif
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) || !(current->flags &  
PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1f9a20..5580d90 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,6 +1,5 @@
  config ARM64
  	def_bool y
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
  	select ARCH_HAS_GCOV_PROFILE_ALL
  	select ARCH_HAS_SG_CHAIN
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 1f65be3..01d3aab 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -126,7 +126,7 @@ typedef struct user_fpsimd_state elf_fpregset_t;
   * that it will "exec", and that there is sufficient room for the brk.
   */
  extern unsigned long randomize_et_dyn(unsigned long base);
-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))

  /*
   * When the program starts, a1 contains a pointer to a function to be
@@ -169,7 +169,7 @@ extern unsigned long arch_randomize_brk(struct  
mm_struct *mm);
  #define COMPAT_ELF_PLATFORM		("v8l")
  #endif

-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
+#define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))

  /* AArch32 registers. */
  #define COMPAT_ELF_NGREG		18
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 54922d1..c444dcc 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -89,6 +89,15 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  }
  EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);

+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) || !(current->flags &  
PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
+

  /*
   * You really shouldn't be using read() or write() on /dev/mem.   
This might go
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3289969..31cc248 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -23,7 +23,6 @@ config MIPS
  	select HAVE_KRETPROBES
  	select HAVE_DEBUG_KMEMLEAK
  	select HAVE_SYSCALL_TRACEPOINTS
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES && 64BIT
  	select RTC_LIB if !MACH_LOONGSON
  	select GENERIC_ATOMIC64 if !64BIT
diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index eb4d95d..fcac4c99 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -402,7 +402,8 @@ extern const char *__elf_platform;
     that it will "exec", and that there is sufficient room for the brk.	*/

  #ifndef ELF_ET_DYN_BASE
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE		(randomize_et_dyn(TASK_SIZE / 3 * 2))
  #endif

  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
index f1baadd..d0c4a2d 100644
--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -196,3 +196,12 @@ int __virt_addr_valid(const volatile void *kaddr)
  	return pfn_valid(PFN_DOWN(virt_to_phys(kaddr)));
  }
  EXPORT_SYMBOL_GPL(__virt_addr_valid);
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) || !(current->flags &  
PF_RANDOMIZE))
+		return base;
+	ret = base + brk_rnd();
+	return (ret > base) ? ret : base;
+}
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a2a168e..fa4c877 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -88,7 +88,6 @@ config PPC
  	select ARCH_MIGHT_HAVE_PC_PARPORT
  	select ARCH_MIGHT_HAVE_PC_SERIO
  	select BINFMT_ELF
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
  	select OF
  	select OF_EARLY_FLATTREE
  	select OF_RESERVED_MEM
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 57d289a..4080425 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -28,7 +28,8 @@
     the loader.  We need to make sure that it is out of the way of the program
     that it will "exec", and that there is sufficient room for the brk.  */

-#define ELF_ET_DYN_BASE	0x20000000
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(0x20000000))

  #define ELF_CORE_EFLAGS (is_elf2_task() ? 2 : 0)

diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
index cb8bdbe..800f0a6 100644
--- a/arch/powerpc/mm/mmap.c
+++ b/arch/powerpc/mm/mmap.c
@@ -97,3 +97,12 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
  	}
  }
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) || !(current->flags &  
PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bd..dcfe16c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -85,7 +85,6 @@ config X86
  	select HAVE_CMPXCHG_DOUBLE
  	select HAVE_ARCH_KMEMCHECK
  	select HAVE_USER_RETURN_NOTIFIER
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
  	select HAVE_ARCH_JUMP_LABEL
  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
  	select SPARSE_IRQ
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index ca3347a..92c6ac4 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -249,7 +249,8 @@ extern int force_personality32;
     the loader.  We need to make sure that it is out of the way of the program
     that it will "exec", and that there is sufficient room for the brk.  */

-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE		(randomize_et_dyn(TASK_SIZE / 3 * 2))

  /* This yields a mask that user programs can use to figure out what
     instruction set this CPU supports.  This could be done in user space,
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 919b912..8f7b3bd 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -122,3 +122,11 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
  	}
  }
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) || !(current->flags &  
PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index c055d56..1186190 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -27,8 +27,6 @@ config COMPAT_BINFMT_ELF
  	bool
  	depends on COMPAT && BINFMT_ELF

-config ARCH_BINFMT_ELF_RANDOMIZE_PIE
-	bool

  config ARCH_BINFMT_ELF_STATE
  	bool
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 02b1691..72f7ff5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -908,21 +908,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
  			 * default mmap base, as well as whatever program they
  			 * might try to exec.  This is because the brk will
  			 * follow the loader, and is not movable.  */
-#ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
-			/* Memory randomization might have been switched off
-			 * in runtime via sysctl or explicit setting of
-			 * personality flags.
-			 * If that is the case, retain the original non-zero
-			 * load_bias value in order to establish proper
-			 * non-randomized mappings.
-			 */
-			if (current->flags & PF_RANDOMIZE)
-				load_bias = 0;
-			else
-				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#else
  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#endif
  		}

  		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,



> Hi,
>
> On Thu, Dec 11, 2014 at 09:12:29PM +0100, Hector Marco wrote:
>>
>> Hello,
>>
>> The following is an ASLR PIE implementation summary in order to help to
>> decide whether it is better to fix x86*, arm*, and MIPS without adding
>> randomize_va_space = 3 or move the PowerPC and the s390 to
>> randomize_va_space = 3.
>
> If we can fix x86, arm, and MIPS without introducing randomize_va_space=3,
> I would prefer it.
>
>> Before any randomization, commit: f057eac (April 2005) the code in
>> fs/binfmt_elf.c was:
>>
>>  } else if (loc->elf_ex.e_type == ET_DYN) {
>>          /* Try and get dynamic programs out of the way of the
>>           * default mmap base, as well as whatever program they
>>           * might try to exec.  This is because the brk will
>>           * follow the loader, and is not movable.  */
>>          load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
>>  }
>>
>> It seems that they tried to get out dynamic programs of the way
>> of the default mmap base. I am not sure why.
>>
>> The first architecture to implement PIE support was x86. To achieve
>> this, the code introduced by the commit 60bfba7 (Jul 2007) was:
>>
>>   } else if (loc->elf_ex.e_type == ET_DYN) {
>>           /* Try and get dynamic programs out of the way of the
>>            * default mmap base, as well as whatever program they
>>            * might try to exec.  This is because the brk will
>>            * follow the loader, and is not movable.  */
>> +#ifdef CONFIG_X86
>> +           load_bias = 0;
>> +#else
>>            load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
>> +#endif
>>             }
>>
>> After that, he code was removed (4 days later commit: d4e3cc3) and
>> reintroduced (commit: cc503c1) Jan 2008. From this commit, the x86*
>> are vulnerable to offset2lib attack.
>>
>> Note that they (x86*) used "load_bias = 0;" which cause that PIE
>> executable be loaded at mmap base.
>>
>> Around one year later, in Feb 2009, PowerPC provided support for PIE
>> executables but not following the X86* approach. PowerPC redefined
>> the ELF_ET_DYN_BASE. The change was:
>>
>> -#define ELF_ET_DYN_BASE (0x20000000)
>> +#define ELF_ET_DYN_BASE (randomize_et_dyn(0x20000000))
>>
>> The function "randomize_et_dyn" add a random value to the 0x20000000
>> which is not vulnerable to the offset2lib weakness. Note that in this
>> point two different ways of PIE implementation are coexisting.
>>
>>
>> Later, in Aug 2008, ARM started to support PIE (commit: e4eab08):
>>
>> -#if defined(CONFIG_X86)
>> +#if defined(CONFIG_X86) || defined(CONFIG_ARM)
>>            load_bias = 0;
>> #else
>>            load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
>> #endif
>>  }
>>
>>
>> They only add "|| defined(CONFIG_ARM)". They followed the x86* PIE
>> support approach which consist on load the PIE executables
>> in the mmap base area.
>>
>>
>> After that, in Jan 2011, s390 started to support PIE (commit: d2c9dfc).
>> They decided to follow the "PowerPC PIE support approach" by redefining:
>>
>> -#define ELF_ET_DYN_BASE         (STACK_TOP / 3 * 2)
>> +#define ELF_ET_DYN_BASE         (randomize_et_dyn(STACK_TOP / 3 * 2))
>>
>>
>> Later, in Nov 2012, the commit e39f560 changed:
>>
>> -#if defined(CONFIG_X86) || defined(CONFIG_ARM)
>> +#ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
>>
>> I think that this was made to avoid a long defined because they must
>> have thought that more architectures will be added in the future.
>> Join this change the x86*, ARM and MIPS architectures set to "y" this
>> value in their respective Kconfig files.
>>
>> The same day of the previous commit, MIPS started to support PIE
>> executables by setting "y" to the ARCH_BINFMT_ELF_RANDOMIZE_PIE in their
>> Kconfig. The commit is e26d196. Again MIPS followed the x86* and ARM
>> approaches.
>>
>>
>> Finally, in Nov 2014, following this approach ARM64 moved from "PowerPC"
>> approach to x86 one. The commit is 9298040.
>>
>> -#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))
>> +#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
>>
>> And set to "y" the "ARCH_BINFMT_ELF_RANDOMIZE_PIE" which cause to load
>> the PIE application in the mmap base area.
>>
>>
>> I don't know if exists any reason to put the PIE executable in the mmap
>> base address or not, but this was the first and most adopted approach.
>>
>> Now, by knowing the presence of the offset2lib weakness obviously is
>> better to use a different memory area.
>>
>> >From my point of view, to use a "define name" which is a random value
>> depending on the architecture does not help much to read the code. I
>> think is better to implement the PIE support by adding a new value to
>> the mm_struct which is filled very early in the function
>> "arch_pick_mmap_layout" which sets up the VM layout. This file is
>> architecture dependent and the function says:
>>
>> /*
>>  * This function, called very early during the creation of a new
>>  * process VM image, sets up which VM layout function to use:
>>  */
>> void arch_pick_mmap_layout(struct mm_struct *mm)
>>
>>
>> In this point the GAP stack is reserved and the mmap_base value is
>> calculated. I think this is the correct place to calculate where the PIE
>> executable will be loaded rather than rely on a "define" which obscure
>> the actual behavior (at first glance does not seem a random value).
>> Maybe this was the reason why most architectures followed the x86*
>> approach to support PIE. But now, with the offset2lib weakness this
>> approach need to be changed. From my point of view, moving to "PowerPC"
>> approach is not the best solution. I've taken a look to PaX code and
>> they implement a similar solution that I have been proposed.
>>
>> Anyway, if you are still thinking that the best approach is the
>> "PowerPC" one, then I could change the patch to fix the x86*, ARM* and
>> MIPS following this approach.
>
> Yeah, I think we should get rid of ARCH_BINFMT_ELF_RANDOMIZE_PIE and just
> fix this to do independent executable base randomization.
>
> While we're at it, can we fix VDSO randomization as well? :)
>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security
>



