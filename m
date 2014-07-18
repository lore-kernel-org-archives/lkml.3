Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbaGREUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:20:40 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39323 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbaGREUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:20:35 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 net-next 06/16] bpf: enable bpf syscall on x64
Date: Thu, 17 Jul 2014 21:19:56 -0700
Message-Id: <1405657206-12060-7-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

done as separate commit to ease conflict resolution

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 arch/x86/syscalls/syscall_64.tbl  |    1 +
 include/linux/syscalls.h          |    2 ++
 include/uapi/asm-generic/unistd.h |    4 +++-
 kernel/sys_ni.c                   |    3 +++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1646d2..edbb8460e1b5 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	bpf			sys_bpf
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0ed322..2b524aeba262 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -866,4 +866,6 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+asmlinkage long sys_bpf(int cmd, unsigned long arg2, unsigned long arg3,
+			unsigned long arg4, unsigned long arg5);
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 333640608087..41e20f8fb87e 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -699,9 +699,11 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
 __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
 #define __NR_renameat2 276
 __SYSCALL(__NR_renameat2, sys_renameat2)
+#define __NR_bpf 277
+__SYSCALL(__NR_bpf, sys_bpf)
 
 #undef __NR_syscalls
-#define __NR_syscalls 277
+#define __NR_syscalls 278
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 36441b51b5df..877c9aafbfb4 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -213,3 +213,6 @@ cond_syscall(compat_sys_open_by_handle_at);
 
 /* compare kernel pointers */
 cond_syscall(sys_kcmp);
+
+/* access BPF programs and maps */
+cond_syscall(sys_bpf);
-- 
1.7.9.5

