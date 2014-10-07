Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaJGMlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:41:15 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60844 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaJGMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:41:14 -0400
From: Arun Chandran <achandran@mvista.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        Arun Chandran <achandran@mvista.com>
Subject: [PATCH v1] Arm64: ASLR: fix text randomization
Date: Tue,  7 Oct 2014 18:10:28 +0530
Message-Id: <1412685628-27178-1-git-send-email-achandran@mvista.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is due to incorrect definition of ELF_ET_DYN_BASE. It
introduces randomization for text even if user does a "echo 0 >
/proc/sys/kernel/randomize_va_space"

Signed-off-by: Arun Chandran <achandran@mvista.com>
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

	# ./aslr
	main = 0x7f87138950
	# ./aslr
	main = 0x7f94a10950
	# ./aslr
	main = 0x7f94fee950
	# ./aslr text
	main = 0x7f8cb72950

	# echo 0 > /proc/sys/kernel/randomize_va_space 
	# ./aslr text
	main = 0x5555555950
	# ./aslr 
	main = 0x5555555950
	# ./aslr 
	main = 0x5555555950
	# ./aslr 
	main = 0x5555555950
---
 arch/arm64/Kconfig           |    1 +
 arch/arm64/include/asm/elf.h |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

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
-- 
1.7.9.5

