Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaJJLc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:32:56 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34500 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaJJLcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:32:53 -0400
From: Arun Chandran <achandran@mvista.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Arun Chandran <achandran@mvista.com>
Subject: [PATCH v2] Arm64: ASLR: Don't randomise text when randomise_va_space == 0
Date: Fri, 10 Oct 2014 17:01:24 +0530
Message-Id: <1412940684-12758-1-git-send-email-achandran@mvista.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141009144441.GA18384@leverpostej>
References: <20141009144441.GA18384@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When user asks to turn off ASLR by writing "0" to
/proc/sys/kernel/randomize_va_space there should not be
any randomization to mmap base, stack, VDSO, libs, text and heap

Currently arm64 violates this behavior by randomising text.
Fix this.

Signed-off-by: Arun Chandran <achandran@mvista.com>
---
Changes since v1:
	removed randomize_et_dyn()
---

This can be tested using the code below

#include <stdio.h>

int main(int argc, char *argv)
{
    printf("main = %p\n", main);
    return 0;
}

* compile it possition independently 
  aarch64-linux-gnu-gcc -fPIE -pie aslr.c -o aslr

* run it on the target

* Behavior before the patch

	# for i in 1 2 3 4 5 ; do ./aslr ; done
	main = 0x557020a950
	main = 0x5561e55950
	main = 0x5563e3a950
	main = 0x555af30950
	main = 0x5592859950
	# 
	# echo 0 > /proc/sys/kernel/randomize_va_space 
	# for i in 1 2 3 4 5 ; do ./aslr ; done
	main = 0x555927f950
	main = 0x556829b950
	main = 0x5566625950
	main = 0x556b533950
	main = 0x555c84d950

* Behavior after the patch

	# for i in 1 2 3 4 5 ; do ./aslr ; done
	main = 0x7f91988950
	main = 0x7fb17b6950
	main = 0x7f7805a950
	main = 0x7fa372e950
	main = 0x7f9cc1e950
	# 
	# echo 0 > /proc/sys/kernel/randomize_va_space 
	# for i in 1 2 3 4 5 ; do ./aslr ; done
	main = 0x5555555950
	main = 0x5555555950
	main = 0x5555555950
	main = 0x5555555950
	main = 0x5555555950
---
 arch/arm64/Kconfig           |    1 +
 arch/arm64/include/asm/elf.h |    4 ++--
 arch/arm64/kernel/process.c  |    5 -----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..a2eefc9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,5 +1,6 @@
 config ARM64
 	def_bool y
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 01d3aab..1f65be3 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -126,7 +126,7 @@ typedef struct user_fpsimd_state elf_fpregset_t;
  * that it will "exec", and that there is sufficient room for the brk.
  */
 extern unsigned long randomize_et_dyn(unsigned long base);
-#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))
+#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
 
 /*
  * When the program starts, a1 contains a pointer to a function to be
@@ -169,7 +169,7 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define COMPAT_ELF_PLATFORM		("v8l")
 #endif
 
-#define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))
+#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
 
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 29d4869..d2edb12 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -403,8 +403,3 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	return randomize_base(mm->brk);
 }
-
-unsigned long randomize_et_dyn(unsigned long base)
-{
-	return randomize_base(base);
-}
-- 
1.7.9.5

