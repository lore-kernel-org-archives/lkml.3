Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaLBEfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:35:39 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59798 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaLBEfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:35:36 -0500
From: Alex Dubov <alex.dubov@gmail.com>
X-Google-Original-From: Alex Dubov <oakad@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: alex.dubov@gmail.com, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 2/2] fs: Wire up sendfd() syscall (all architectures)
Date: Tue,  2 Dec 2014 15:35:19 +1100
Message-Id: <1417494919-4577-3-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 arch/arm/include/uapi/asm/unistd.h        |  1 +
 arch/arm/kernel/calls.S                   |  1 +
 arch/arm64/include/asm/unistd32.h         |  2 ++
 arch/ia64/include/uapi/asm/unistd.h       |  1 +
 arch/ia64/kernel/entry.S                  |  1 +
 arch/m68k/include/uapi/asm/unistd.h       |  1 +
 arch/m68k/kernel/syscalltable.S           |  1 +
 arch/microblaze/include/uapi/asm/unistd.h |  1 +
 arch/microblaze/kernel/syscall_table.S    |  1 +
 arch/mips/include/uapi/asm/unistd.h       | 15 +++++++++------
 arch/mips/kernel/scall32-o32.S            |  1 +
 arch/mips/kernel/scall64-64.S             |  1 +
 arch/mips/kernel/scall64-n32.S            |  1 +
 arch/mips/kernel/scall64-o32.S            |  1 +
 arch/parisc/include/uapi/asm/unistd.h     |  3 ++-
 arch/powerpc/include/asm/systbl.h         |  1 +
 arch/powerpc/include/uapi/asm/unistd.h    |  1 +
 arch/s390/include/uapi/asm/unistd.h       |  3 ++-
 arch/s390/kernel/compat_wrapper.c         |  1 +
 arch/s390/kernel/syscalls.S               |  1 +
 arch/sparc/include/uapi/asm/unistd.h      |  3 ++-
 arch/sparc/kernel/systbls_32.S            |  2 +-
 arch/sparc/kernel/systbls_64.S            |  4 ++--
 arch/x86/syscalls/syscall_32.tbl          |  1 +
 arch/x86/syscalls/syscall_64.tbl          |  1 +
 arch/xtensa/include/uapi/asm/unistd.h     |  5 +++--
 include/linux/syscalls.h                  |  1 +
 include/uapi/asm-generic/unistd.h         |  4 +++-
 kernel/sys_ni.c                           |  3 +++
 29 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index 705bb76..6428823 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -413,6 +413,7 @@
 #define __NR_getrandom			(__NR_SYSCALL_BASE+384)
 #define __NR_memfd_create		(__NR_SYSCALL_BASE+385)
 #define __NR_bpf			(__NR_SYSCALL_BASE+386)
+#define __NR_sendfd			(__NR_SYSCALL_BASE+387)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index e51833f..30bdeb5 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -396,6 +396,7 @@
 		CALL(sys_getrandom)
 /* 385 */	CALL(sys_memfd_create)
 		CALL(sys_bpf)
+		CALL(sys_sendfd)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 9dfdac4..7f19595 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -794,3 +794,5 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
 __SYSCALL(__NR_memfd_create, sys_memfd_create)
 #define __NR_bpf 386
 __SYSCALL(__NR_bpf, sys_bpf)
+#define __NR_sendfd 387
+__SYSCALL(__NR_sendfd, sys_sendfd)
diff --git a/arch/ia64/include/uapi/asm/unistd.h b/arch/ia64/include/uapi/asm/unistd.h
index 4c2240c..55be68c 100644
--- a/arch/ia64/include/uapi/asm/unistd.h
+++ b/arch/ia64/include/uapi/asm/unistd.h
@@ -331,5 +331,6 @@
 #define __NR_getrandom			1339
 #define __NR_memfd_create		1340
 #define __NR_bpf			1341
+#define __NR_sendfd			1342
 
 #endif /* _UAPI_ASM_IA64_UNISTD_H */
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index f5e96df..97596a3 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1779,6 +1779,7 @@ sys_call_table:
 	data8 sys_getrandom
 	data8 sys_memfd_create			// 1340
 	data8 sys_bpf
+	data8 sys_sendfd
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
index 2c1bec9..77e7098 100644
--- a/arch/m68k/include/uapi/asm/unistd.h
+++ b/arch/m68k/include/uapi/asm/unistd.h
@@ -360,5 +360,6 @@
 #define __NR_getrandom		352
 #define __NR_memfd_create	353
 #define __NR_bpf		354
+#define __NR_sendfd		355
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 2ca219e..3ea20d4 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -375,4 +375,5 @@ ENTRY(sys_call_table)
 	.long sys_getrandom
 	.long sys_memfd_create
 	.long sys_bpf
+	.long sys_sendfd
 
diff --git a/arch/microblaze/include/uapi/asm/unistd.h b/arch/microblaze/include/uapi/asm/unistd.h
index c712677..f69e30a 100644
--- a/arch/microblaze/include/uapi/asm/unistd.h
+++ b/arch/microblaze/include/uapi/asm/unistd.h
@@ -403,5 +403,6 @@
 #define __NR_getrandom		385
 #define __NR_memfd_create	386
 #define __NR_bpf		387
+#define __NR_sendfd		388
 
 #endif /* _UAPI_ASM_MICROBLAZE_UNISTD_H */
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 0166e89..1550f45 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -388,3 +388,4 @@ ENTRY(sys_call_table)
 	.long sys_getrandom		/* 385 */
 	.long sys_memfd_create
 	.long sys_bpf
+	.long sys_sendfd
diff --git a/arch/mips/include/uapi/asm/unistd.h b/arch/mips/include/uapi/asm/unistd.h
index d001bb1..24109dc 100644
--- a/arch/mips/include/uapi/asm/unistd.h
+++ b/arch/mips/include/uapi/asm/unistd.h
@@ -376,16 +376,17 @@
 #define __NR_getrandom			(__NR_Linux + 353)
 #define __NR_memfd_create		(__NR_Linux + 354)
 #define __NR_bpf			(__NR_Linux + 355)
+#define __NR_sendfd			(__NR_Linux + 356)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		355
+#define __NR_Linux_syscalls		356
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		355
+#define __NR_O32_Linux_syscalls		356
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -709,16 +710,17 @@
 #define __NR_getrandom			(__NR_Linux + 313)
 #define __NR_memfd_create		(__NR_Linux + 314)
 #define __NR_bpf			(__NR_Linux + 315)
+#define __NR_sendfd			(__NR_Linux + 316)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		315
+#define __NR_Linux_syscalls		316
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		315
+#define __NR_64_Linux_syscalls		316
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1046,15 +1048,16 @@
 #define __NR_getrandom			(__NR_Linux + 317)
 #define __NR_memfd_create		(__NR_Linux + 318)
 #define __NR_bpf			(__NR_Linux + 319)
+#define __NR_sendfd			(__NR_Linux + 320)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		319
+#define __NR_Linux_syscalls		320
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		319
+#define __NR_N32_Linux_syscalls		320
 
 #endif /* _UAPI_ASM_UNISTD_H */
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 00cad10..94a7014 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -580,3 +580,4 @@ EXPORT(sys_call_table)
 	PTR	sys_getrandom
 	PTR	sys_memfd_create
 	PTR	sys_bpf				/* 4355 */
+	PTR	sys_sendfd
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index 5251565..cc2440d 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -435,4 +435,5 @@ EXPORT(sys_call_table)
 	PTR	sys_getrandom
 	PTR	sys_memfd_create
 	PTR	sys_bpf				/* 5315 */
+	PTR	sys_sendfd
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index 77e7439..ff1de3a 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -428,4 +428,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_getrandom
 	PTR	sys_memfd_create
 	PTR	sys_bpf
+	PTR	sys_sendfd
 	.size	sysn32_call_table,.-sysn32_call_table
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 6f8db9f..87d3a33 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -565,4 +565,5 @@ EXPORT(sys32_call_table)
 	PTR	sys_getrandom
 	PTR	sys_memfd_create
 	PTR	sys_bpf				/* 4355 */
+	PTR	sys_sendfd
 	.size	sys32_call_table,.-sys32_call_table
diff --git a/arch/parisc/include/uapi/asm/unistd.h b/arch/parisc/include/uapi/asm/unistd.h
index 5f5c037..f182787 100644
--- a/arch/parisc/include/uapi/asm/unistd.h
+++ b/arch/parisc/include/uapi/asm/unistd.h
@@ -834,8 +834,9 @@
 #define __NR_getrandom		(__NR_Linux + 339)
 #define __NR_memfd_create	(__NR_Linux + 340)
 #define __NR_bpf		(__NR_Linux + 341)
+#define __NR_sendfd		(__NR_Linux + 342)
 
-#define __NR_Linux_syscalls	(__NR_bpf + 1)
+#define __NR_Linux_syscalls	(__NR_sendfd + 1)
 
 
 #define __IGNORE_select		/* newselect */
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index ce9577d..4aa6c22 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -366,3 +366,4 @@ SYSCALL_SPU(seccomp)
 SYSCALL_SPU(getrandom)
 SYSCALL_SPU(memfd_create)
 SYSCALL_SPU(bpf)
+SYSCALL_SPU(sendfd)
diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
index f55351f..2d55338 100644
--- a/arch/powerpc/include/uapi/asm/unistd.h
+++ b/arch/powerpc/include/uapi/asm/unistd.h
@@ -384,5 +384,6 @@
 #define __NR_getrandom		359
 #define __NR_memfd_create	360
 #define __NR_bpf		361
+#define __NR_sendfd		362
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 4197c89..7248c4a 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -287,7 +287,8 @@
 #define __NR_getrandom		349
 #define __NR_memfd_create	350
 #define __NR_bpf		351
-#define NR_syscalls 352
+#define __NR_sendfd		352
+#define NR_syscalls 353
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.c b/arch/s390/kernel/compat_wrapper.c
index c4f7a3d..d931326 100644
--- a/arch/s390/kernel/compat_wrapper.c
+++ b/arch/s390/kernel/compat_wrapper.c
@@ -218,3 +218,4 @@ COMPAT_SYSCALL_WRAP3(seccomp, unsigned int, op, unsigned int, flags, const char
 COMPAT_SYSCALL_WRAP3(getrandom, char __user *, buf, size_t, count, unsigned int, flags)
 COMPAT_SYSCALL_WRAP2(memfd_create, const char __user *, uname, unsigned int, flags)
 COMPAT_SYSCALL_WRAP3(bpf, int, cmd, union bpf_attr *, attr, unsigned int, size);
+COMPAT_SYSCALL_WRAP3(sendfd, pid_t, pid, int, sig, int, fd);
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 9f7087f..b1beaf1 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -360,3 +360,4 @@ SYSCALL(sys_seccomp,sys_seccomp,compat_sys_seccomp)
 SYSCALL(sys_getrandom,sys_getrandom,compat_sys_getrandom)
 SYSCALL(sys_memfd_create,sys_memfd_create,compat_sys_memfd_create) /* 350 */
 SYSCALL(sys_bpf,sys_bpf,compat_sys_bpf)
+SYSCALL(sys_sendfd,sys_sendfd,compat_sys_sendfd)
diff --git a/arch/sparc/include/uapi/asm/unistd.h b/arch/sparc/include/uapi/asm/unistd.h
index 46d8384..a43637a 100644
--- a/arch/sparc/include/uapi/asm/unistd.h
+++ b/arch/sparc/include/uapi/asm/unistd.h
@@ -415,8 +415,9 @@
 #define __NR_getrandom		347
 #define __NR_memfd_create	348
 #define __NR_bpf		349
+#define __NR_sendfd		350
 
-#define NR_syscalls		350
+#define NR_syscalls		351
 
 /* Bitmask values returned from kern_features system call.  */
 #define KERN_FEATURE_MIXED_MODE_STACK	0x00000001
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index ad0cdf4..1b3ff92 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -86,4 +86,4 @@ sys_call_table:
 /*330*/	.long sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
 /*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
-/*345*/	.long sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*345*/	.long sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf, sys_sendfd
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 580cde9..ebbafb1 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -87,7 +87,7 @@ sys_call_table32:
 /*330*/	.word compat_sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, compat_sys_open_by_handle_at, compat_sys_clock_adjtime
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
-	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf, sys_sendfd
 
 #endif /* CONFIG_COMPAT */
 
@@ -166,4 +166,4 @@ sys_call_table:
 /*330*/	.word sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
-	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf, sys_sendfd
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 9fe1b5d..dfe91f7 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -364,3 +364,4 @@
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
+358	i386	sendfd			sys_sendfd
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 281150b..4d6b55d 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -328,6 +328,7 @@
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
+322	common	sendfd			sys_sendfd
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
index db5bb72..3705d28 100644
--- a/arch/xtensa/include/uapi/asm/unistd.h
+++ b/arch/xtensa/include/uapi/asm/unistd.h
@@ -749,8 +749,9 @@ __SYSCALL(337, sys_seccomp, 3)
 __SYSCALL(338, sys_getrandom, 3)
 #define __NR_memfd_create			339
 __SYSCALL(339, sys_memfd_create, 2)
-
-#define __NR_syscall_count			340
+#define __NR_sendfd				340
+__SYSCALL(340, sys_sendfd, 3)
+#define __NR_syscall_count			341
 
 /*
  * sysxtensa syscall handler
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index bda9b81..1871b72f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -877,4 +877,5 @@ asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_bpf(int cmd, union bpf_attr *attr, unsigned int size);
+asmlinkage long sys_sendfd(pid_t pid, int sig, int fd);
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 22749c1..270aa02 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -707,9 +707,11 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
 __SYSCALL(__NR_memfd_create, sys_memfd_create)
 #define __NR_bpf 280
 __SYSCALL(__NR_bpf, sys_bpf)
+#define __NR_sendfd 281
+__SYSCALL(__NR_sendfd, sys_sendfd)
 
 #undef __NR_syscalls
-#define __NR_syscalls 281
+#define __NR_syscalls 282
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 02aa418..353cddb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -224,3 +224,6 @@ cond_syscall(sys_seccomp);
 
 /* access BPF programs and maps */
 cond_syscall(sys_bpf);
+
+/* send file descriptor to another process */
+cond_syscall(sys_sendfd);
-- 
1.8.3.2

