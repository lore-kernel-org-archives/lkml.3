Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaJTHp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:45:27 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:40001 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaJTHpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:45:24 -0400
Date: Mon, 20 Oct 2014 09:45:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.18-rc2
Message-ID: <20141020094518.409b6d54@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102007-0041-0000-0000-000001BA67BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
One patch to enable the BPF system call and three more bug fixes.

Dominik Dingel (1):
      s390/mm: fixing calls of pte_unmap_unlock

Heiko Carstens (1):
      s390: wire up bpf syscall

Jan Willeke (1):
      s390/uprobes: fix kprobes dependency

Josh Boyer (1):
      s390/hmcdrv: Restrict s390 HMC driver to S390 arch

 arch/s390/include/uapi/asm/unistd.h | 3 ++-
 arch/s390/kernel/compat_wrapper.c   | 1 +
 arch/s390/kernel/syscalls.S         | 1 +
 arch/s390/kernel/uprobes.c          | 2 +-
 arch/s390/lib/probes.c              | 2 +-
 arch/s390/mm/pgtable.c              | 6 +++---
 drivers/s390/char/Kconfig           | 2 +-
 7 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 940ac49..4197c89 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -286,7 +286,8 @@
 #define __NR_seccomp		348
 #define __NR_getrandom		349
 #define __NR_memfd_create	350
-#define NR_syscalls 351
+#define __NR_bpf		351
+#define NR_syscalls 352
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.c b/arch/s390/kernel/compat_wrapper.c
index faf6caa..c4f7a3d 100644
--- a/arch/s390/kernel/compat_wrapper.c
+++ b/arch/s390/kernel/compat_wrapper.c
@@ -217,3 +217,4 @@ COMPAT_SYSCALL_WRAP5(renameat2, int, olddfd, const char __user *, oldname, int,
 COMPAT_SYSCALL_WRAP3(seccomp, unsigned int, op, unsigned int, flags, const char __user *, uargs)
 COMPAT_SYSCALL_WRAP3(getrandom, char __user *, buf, size_t, count, unsigned int, flags)
 COMPAT_SYSCALL_WRAP2(memfd_create, const char __user *, uname, unsigned int, flags)
+COMPAT_SYSCALL_WRAP3(bpf, int, cmd, union bpf_attr *, attr, unsigned int, size);
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 6fe886a..9f7087f 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -359,3 +359,4 @@ SYSCALL(sys_renameat2,sys_renameat2,compat_sys_renameat2)
 SYSCALL(sys_seccomp,sys_seccomp,compat_sys_seccomp)
 SYSCALL(sys_getrandom,sys_getrandom,compat_sys_getrandom)
 SYSCALL(sys_memfd_create,sys_memfd_create,compat_sys_memfd_create) /* 350 */
+SYSCALL(sys_bpf,sys_bpf,compat_sys_bpf)
diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index 956f4f7..f6b3cd0 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -5,13 +5,13 @@
  *    Author(s): Jan Willeke,
  */
 
-#include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/uprobes.h>
 #include <linux/compat.h>
 #include <linux/kdebug.h>
 #include <asm/switch_to.h>
 #include <asm/facility.h>
+#include <asm/kprobes.h>
 #include <asm/dis.h>
 #include "entry.h"
 
diff --git a/arch/s390/lib/probes.c b/arch/s390/lib/probes.c
index c5d64a0..ae90e1a 100644
--- a/arch/s390/lib/probes.c
+++ b/arch/s390/lib/probes.c
@@ -4,7 +4,7 @@
  *    Copyright IBM Corp. 2014
  */
 
-#include <linux/kprobes.h>
+#include <asm/kprobes.h>
 #include <asm/dis.h>
 
 int probe_is_prohibited_opcode(u16 *insn)
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 296b61a..1b79ca6 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -656,7 +656,7 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 	}
 	pgste_set_unlock(ptep, pgste);
 out_pte:
-	pte_unmap_unlock(*ptep, ptl);
+	pte_unmap_unlock(ptep, ptl);
 }
 EXPORT_SYMBOL_GPL(__gmap_zap);
 
@@ -943,7 +943,7 @@ retry:
 	}
 	if (!(pte_val(*ptep) & _PAGE_INVALID) &&
 	     (pte_val(*ptep) & _PAGE_PROTECT)) {
-		pte_unmap_unlock(*ptep, ptl);
+		pte_unmap_unlock(ptep, ptl);
 		if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE)) {
 			up_read(&mm->mmap_sem);
 			return -EFAULT;
@@ -974,7 +974,7 @@ retry:
 		pgste_val(new) |= PGSTE_UC_BIT;
 
 	pgste_set_unlock(ptep, new);
-	pte_unmap_unlock(*ptep, ptl);
+	pte_unmap_unlock(ptep, ptl);
 	up_read(&mm->mmap_sem);
 	return 0;
 }
diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
index dc24ecf..db2cb1f 100644
--- a/drivers/s390/char/Kconfig
+++ b/drivers/s390/char/Kconfig
@@ -105,7 +105,7 @@ config SCLP_ASYNC
 config HMC_DRV
 	def_tristate m
 	prompt "Support for file transfers from HMC drive CD/DVD-ROM"
-	depends on 64BIT
+	depends on S390 && 64BIT
 	select CRC16
 	help
 	  This option enables support for file transfers from a Hardware

