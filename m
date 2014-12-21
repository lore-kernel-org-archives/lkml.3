Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaLUN7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 08:59:13 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35234 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLUN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 08:59:11 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Fabian Frederick <fabf@skynet.be>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] powerpc: Wire up sys_execveat() syscall
Date: Sun, 21 Dec 2014 08:59:32 -0500
Message-Id: <1419170375-27759-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up sys_execveat(). This passes the selftests for the system call.

Check success of execveat(3, '../execveat', 0)... [OK]
Check success of execveat(5, 'execveat', 0)... [OK]
Check success of execveat(6, 'execveat', 0)... [OK]
Check success of execveat(-100, '/home/pranith/linux/...ftests/exec/execveat', 0)... [OK]
Check success of execveat(99, '/home/pranith/linux/...ftests/exec/execveat', 0)... [OK]
Check success of execveat(8, '', 4096)... [OK]
Check success of execveat(17, '', 4096)... [OK]
Check success of execveat(9, '', 4096)... [OK]
Check success of execveat(14, '', 4096)... [OK]
Check success of execveat(14, '', 4096)... [OK]
Check success of execveat(15, '', 4096)... [OK]
Check failure of execveat(8, '', 0) with ENOENT... [OK]
Check failure of execveat(8, '(null)', 4096) with EFAULT... [OK]
Check success of execveat(5, 'execveat.symlink', 0)... [OK]
Check success of execveat(6, 'execveat.symlink', 0)... [OK]
Check success of execveat(-100, '/home/pranith/linux/...xec/execveat.symlink', 0)... [OK]
Check success of execveat(10, '', 4096)... [OK]
Check success of execveat(10, '', 4352)... [OK]
Check failure of execveat(5, 'execveat.symlink', 256) with ELOOP... [OK]
Check failure of execveat(6, 'execveat.symlink', 256) with ELOOP... [OK]
Check failure of execveat(-100, '/home/pranith/linux/tools/testing/selftests/exec/execveat.symlink', 256) with ELOOP... [OK]
Check success of execveat(3, '../script', 0)... [OK]
Check success of execveat(5, 'script', 0)... [OK]
Check success of execveat(6, 'script', 0)... [OK]
Check success of execveat(-100, '/home/pranith/linux/...elftests/exec/script', 0)... [OK]
Check success of execveat(13, '', 4096)... [OK]
Check success of execveat(13, '', 4352)... [OK]
Check failure of execveat(18, '', 4096) with ENOENT... [OK]
Check failure of execveat(7, 'script', 0) with ENOENT... [OK]
Check success of execveat(16, '', 4096)... [OK]
Check success of execveat(16, '', 4096)... [OK]
Check success of execveat(4, '../script', 0)... [OK]
Check success of execveat(4, 'script', 0)... [OK]
Check success of execveat(4, '../script', 0)... [OK]
Check failure of execveat(4, 'script', 0) with ENOENT... [OK]
Check failure of execveat(5, 'execveat', 65535) with EINVAL... [OK]
Check failure of execveat(5, 'no-such-file', 0) with ENOENT... [OK]
Check failure of execveat(6, 'no-such-file', 0) with ENOENT... [OK]
Check failure of execveat(-100, 'no-such-file', 0) with ENOENT... [OK]
Check failure of execveat(5, '', 4096) with EACCES... [OK]
Check failure of execveat(5, 'Makefile', 0) with EACCES... [OK]
Check failure of execveat(11, '', 4096) with EACCES... [OK]
Check failure of execveat(12, '', 4096) with EACCES... [OK]
Check failure of execveat(99, '', 4096) with EBADF... [OK]
Check failure of execveat(99, 'execveat', 0) with EBADF... [OK]
Check failure of execveat(8, 'execveat', 0) with ENOTDIR... [OK]
Invoke copy of 'execveat' via filename of length 4093:
Check success of execveat(19, '', 4096)... [OK]
Check success of execveat(5, 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [OK]
Invoke copy of 'script' via filename of length 4093:
Check success of execveat(20, '', 4096)... [OK]
/bin/sh: 0: Can't open /dev/fd/5/xxxxxxx(... a long line of x's and y's, 0)... [OK]
Check success of execveat(5, 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [OK]

Tested on a 32-bit powerpc system.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/include/asm/systbl.h      | 1 +
 arch/powerpc/include/asm/unistd.h      | 2 +-
 arch/powerpc/include/uapi/asm/unistd.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index ce9577d..91062ee 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -366,3 +366,4 @@ SYSCALL_SPU(seccomp)
 SYSCALL_SPU(getrandom)
 SYSCALL_SPU(memfd_create)
 SYSCALL_SPU(bpf)
+COMPAT_SYS(execveat)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index e0da021..36b79c3 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define __NR_syscalls		362
+#define __NR_syscalls		363
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
index f55351f..ef5b5b1 100644
--- a/arch/powerpc/include/uapi/asm/unistd.h
+++ b/arch/powerpc/include/uapi/asm/unistd.h
@@ -384,5 +384,6 @@
 #define __NR_getrandom		359
 #define __NR_memfd_create	360
 #define __NR_bpf		361
+#define __NR_execveat		362
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
-- 
1.9.1

