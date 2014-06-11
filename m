Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaFKD2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:28:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48418 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbaFKD0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:26:10 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        John Johansen <john.johansen@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v6 9/9] MIPS: add seccomp syscall
Date: Tue, 10 Jun 2014 20:25:21 -0700
Message-Id: <1402457121-8410-10-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402457121-8410-1-git-send-email-keescook@chromium.org>
References: <1402457121-8410-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wires up the new seccomp syscall.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/include/uapi/asm/unistd.h |   15 +++++++++------
 arch/mips/kernel/scall32-o32.S      |    1 +
 arch/mips/kernel/scall64-64.S       |    1 +
 arch/mips/kernel/scall64-n32.S      |    1 +
 arch/mips/kernel/scall64-o32.S      |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/uapi/asm/unistd.h b/arch/mips/include/uapi/asm/unistd.h
index 5805414777e0..9bc13eaf9d67 100644
--- a/arch/mips/include/uapi/asm/unistd.h
+++ b/arch/mips/include/uapi/asm/unistd.h
@@ -372,16 +372,17 @@
 #define __NR_sched_setattr		(__NR_Linux + 349)
 #define __NR_sched_getattr		(__NR_Linux + 350)
 #define __NR_renameat2			(__NR_Linux + 351)
+#define __NR_seccomp			(__NR_Linux + 352)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		351
+#define __NR_Linux_syscalls		352
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		351
+#define __NR_O32_Linux_syscalls		352
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -701,16 +702,17 @@
 #define __NR_sched_setattr		(__NR_Linux + 309)
 #define __NR_sched_getattr		(__NR_Linux + 310)
 #define __NR_renameat2			(__NR_Linux + 311)
+#define __NR_seccomp			(__NR_Linux + 312)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		311
+#define __NR_Linux_syscalls		312
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		311
+#define __NR_64_Linux_syscalls		312
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1034,15 +1036,16 @@
 #define __NR_sched_setattr		(__NR_Linux + 313)
 #define __NR_sched_getattr		(__NR_Linux + 314)
 #define __NR_renameat2			(__NR_Linux + 315)
+#define __NR_seccomp			(__NR_Linux + 316)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		315
+#define __NR_Linux_syscalls		316
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		315
+#define __NR_N32_Linux_syscalls		316
 
 #endif /* _UAPI_ASM_UNISTD_H */
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 3245474f19d5..ab02d14f1b5c 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -578,3 +578,4 @@ EXPORT(sys_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr		/* 4350 */
 	PTR	sys_renameat2
+	PTR	sys_seccomp
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index be2fedd4ae33..010dccf128ec 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -431,4 +431,5 @@ EXPORT(sys_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr		/* 5310 */
 	PTR	sys_renameat2
+	PTR	sys_seccomp
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index c1dbcda4b816..c3b3b6525df5 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -424,4 +424,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr
 	PTR	sys_renameat2			/* 6315 */
+	PTR	sys_seccomp
 	.size	sysn32_call_table,.-sysn32_call_table
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index f1343ccd7ed7..bb1550b1f501 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -557,4 +557,5 @@ EXPORT(sys32_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr		/* 4350 */
 	PTR	sys_renameat2
+	PTR	sys_seccomp
 	.size	sys32_call_table,.-sys32_call_table
-- 
1.7.9.5

