Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaJJFpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:45:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33685 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaJJFpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:45:51 -0400
From: Vineeth Vijayan <vvijayan@mvista.com>
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, Vineeth Vijayan <vvijayan@mvista.com>
Subject: [PATCH] powerpc: Fix Text randomization
Date: Fri, 10 Oct 2014 11:15:26 +0530
Message-Id: <1412919926-13123-1-git-send-email-vvijayan@mvista.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now there is no way to disable TEXT randomization on a PPC32
machine. text randomization happens even in the case of "echo 0 >
/proc/sys/kernel/randomize_va_space"

This happens due to the incorrect definition of ELF_ET_DYN_BASE at
arch/powerpc/include/asm/elf.h

Signed-off-by: Vineeth Vijayan <vvijayan@mvista.com>
---
Test details:

#include <stdio.h>

int main(int argc,char *argv)
{
        printf("main = %p\n",main);
        return 0;
}

Compile the same as position-independent executable

Results without Patch:

p5040ds:~# gcc test.c -o test -fPIE -pie
p5040ds:~# echo 2 > /proc/sys/kernel/randomize_va_space 
p5040ds:~# ./test 
main = 0xb7e9681c
p5040ds:~# ./test 
main = 0xb7aba81c
p5040ds:~# ./test 
main = 0xb7fac81c
p5040ds:~# ./test 
main = 0xb7f4c81c
p5040ds:~# echo 0 > /proc/sys/kernel/randomize_va_space                                                                                                                                              
p5040ds:~# ./test 
main = 0x2010281c
p5040ds:~# ./test 
main = 0x2018d81c
p5040ds:~# ./test 
main = 0x206a981c
p5040ds:~# ./test 
main = 0x2036681c


Results with Patch:

p5040ds:~# gcc test.c -o test -fPIE -pie
p5040ds:~# 
p5040ds:~# echo 2 > /proc/sys/kernel/randomize_va_space 
p5040ds:~# 
p5040ds:~# ./test 
main = 0xb78a581c
p5040ds:~# ./test 
main = 0xb792c81c
p5040ds:~# ./test 
main = 0xb79de81c
p5040ds:~# ./test 
main = 0xb78ae81c
p5040ds:~# echo 0 > /proc/sys/kernel/randomize_va_space                                                                                                                                              
p5040ds:~# 
p5040ds:~# ./test 
main = 0x2000081c
p5040ds:~# ./test 
main = 0x2000081c
p5040ds:~# ./test 
main = 0x2000081c
p5040ds:~# ./test 
main = 0x2000081c


 arch/powerpc/Kconfig           |    1 +
 arch/powerpc/include/asm/elf.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4bc7b62..f99ddae 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -88,6 +88,7 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select OF
 	select OF_EARLY_FLATTREE
 	select OF_RESERVED_MEM
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 888d8f3..162813b 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -29,7 +29,7 @@
    that it will "exec", and that there is sufficient room for the brk.  */
 
 extern unsigned long randomize_et_dyn(unsigned long base);
-#define ELF_ET_DYN_BASE		(randomize_et_dyn(0x20000000))
+#define ELF_ET_DYN_BASE		(0x20000000)
 
 #define ELF_CORE_EFLAGS (is_elf2_task() ? 2 : 0)
 
-- 
1.7.9.5

