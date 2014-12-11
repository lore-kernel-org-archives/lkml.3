Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbaLKUMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:12:48 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:40782 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758330AbaLKUMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:12:46 -0500
Message-ID: <5489FAAD.7000606@upv.es>
Date: Thu, 11 Dec 2014 21:12:29 +0100
From: Hector Marco <hecmargi@upv.es>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
References: <5489E6D2.2060200@upv.es>
In-Reply-To: <5489E6D2.2060200@upv.es>
X-Enigmail-Version: 1.5.2
X-Forwarded-Message-Id: <5489E6D2.2060200@upv.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

The following is an ASLR PIE implementation summary in order to help to
decide whether it is better to fix x86*, arm*, and MIPS without adding
randomize_va_space = 3 or move the PowerPC and the s390 to
randomize_va_space = 3.


Before any randomization, commit: f057eac (April 2005) the code in
fs/binfmt_elf.c was:

 } else if (loc->elf_ex.e_type == ET_DYN) {
         /* Try and get dynamic programs out of the way of the
          * default mmap base, as well as whatever program they
          * might try to exec.  This is because the brk will
          * follow the loader, and is not movable.  */
         load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 }

It seems that they tried to get out dynamic programs of the way
of the default mmap base. I am not sure why.

The first architecture to implement PIE support was x86. To achieve
this, the code introduced by the commit 60bfba7 (Jul 2007) was:

  } else if (loc->elf_ex.e_type == ET_DYN) {
          /* Try and get dynamic programs out of the way of the
           * default mmap base, as well as whatever program they
           * might try to exec.  This is because the brk will
           * follow the loader, and is not movable.  */
+#ifdef CONFIG_X86
+           load_bias = 0;
+#else
           load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
+#endif
            }

After that, he code was removed (4 days later commit: d4e3cc3) and
reintroduced (commit: cc503c1) Jan 2008. From this commit, the x86*
are vulnerable to offset2lib attack.

Note that they (x86*) used "load_bias = 0;" which cause that PIE
executable be loaded at mmap base.

Around one year later, in Feb 2009, PowerPC provided support for PIE
executables but not following the X86* approach. PowerPC redefined
the ELF_ET_DYN_BASE. The change was:

-#define ELF_ET_DYN_BASE (0x20000000)
+#define ELF_ET_DYN_BASE (randomize_et_dyn(0x20000000))

The function "randomize_et_dyn" add a random value to the 0x20000000
which is not vulnerable to the offset2lib weakness. Note that in this
point two different ways of PIE implementation are coexisting.


Later, in Aug 2008, ARM started to support PIE (commit: e4eab08):

-#if defined(CONFIG_X86)
+#if defined(CONFIG_X86) || defined(CONFIG_ARM)
           load_bias = 0;
#else
           load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
#endif
 }


They only add "|| defined(CONFIG_ARM)". They followed the x86* PIE
support approach which consist on load the PIE executables
in the mmap base area.


After that, in Jan 2011, s390 started to support PIE (commit: d2c9dfc).
They decided to follow the "PowerPC PIE support approach" by redefining:

-#define ELF_ET_DYN_BASE         (STACK_TOP / 3 * 2)
+#define ELF_ET_DYN_BASE         (randomize_et_dyn(STACK_TOP / 3 * 2))


Later, in Nov 2012, the commit e39f560 changed:

-#if defined(CONFIG_X86) || defined(CONFIG_ARM)
+#ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE

I think that this was made to avoid a long defined because they must
have thought that more architectures will be added in the future.
Join this change the x86*, ARM and MIPS architectures set to "y" this
value in their respective Kconfig files.

The same day of the previous commit, MIPS started to support PIE
executables by setting "y" to the ARCH_BINFMT_ELF_RANDOMIZE_PIE in their
Kconfig. The commit is e26d196. Again MIPS followed the x86* and ARM
approaches.


Finally, in Nov 2014, following this approach ARM64 moved from "PowerPC"
approach to x86 one. The commit is 9298040.

-#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))
+#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)

And set to "y" the "ARCH_BINFMT_ELF_RANDOMIZE_PIE" which cause to load
the PIE application in the mmap base area.


I don't know if exists any reason to put the PIE executable in the mmap
base address or not, but this was the first and most adopted approach.

Now, by knowing the presence of the offset2lib weakness obviously is
better to use a different memory area.

>From my point of view, to use a "define name" which is a random value
depending on the architecture does not help much to read the code. I
think is better to implement the PIE support by adding a new value to
the mm_struct which is filled very early in the function
"arch_pick_mmap_layout" which sets up the VM layout. This file is
architecture dependent and the function says:

/*
 * This function, called very early during the creation of a new
 * process VM image, sets up which VM layout function to use:
 */
void arch_pick_mmap_layout(struct mm_struct *mm)


In this point the GAP stack is reserved and the mmap_base value is
calculated. I think this is the correct place to calculate where the PIE
executable will be loaded rather than rely on a "define" which obscure
the actual behavior (at first glance does not seem a random value).
Maybe this was the reason why most architectures followed the x86*
approach to support PIE. But now, with the offset2lib weakness this
approach need to be changed. From my point of view, moving to "PowerPC"
approach is not the best solution. I've taken a look to PaX code and
they implement a similar solution that I have been proposed.

Anyway, if you are still thinking that the best approach is the
"PowerPC" one, then I could change the patch to fix the x86*, ARM* and
MIPS following this approach.


Best regards,
Hector Marco.
http://hmarco.org


