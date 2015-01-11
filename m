Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbbAKOd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:33:28 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51579 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbAKOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:33:09 -0500
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Pen <r.peniaev@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sekhar Nori <nsekhar@ti.com>, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: entry-common,ptrace: do not pass scno to syscall_trace_enter
Date: Sun, 11 Jan 2015 23:32:31 +0900
Message-Id: <1420986751-30364-3-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
References: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In previous patch current_thread_info()->syscall is set with
corresponding syscall number prior to further calls, thus there
is no any need to pass 'scno'.

Also, add explicit comment why do we have to reread 'scno' local
variable.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/kernel/entry-common.S | 1 -
 arch/arm/kernel/ptrace.c       | 6 ++++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 89452ff..3d12eb5 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -228,7 +228,6 @@ ENDPROC(vector_swi)
 	 * context switches, and waiting for our parent to respond.
 	 */
 __sys_trace:
-	mov	r1, scno
 	add	r0, sp, #S_OFF
 	bl	syscall_trace_enter
 
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index ef9119f..1238787 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -928,9 +928,9 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	regs->ARM_ip = ip;
 }
 
-asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
+asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
-	current_thread_info()->syscall = scno;
+	int scno = current_thread_info()->syscall;
 
 	/* Do the secure computing check first; failures should be fast. */
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
@@ -944,6 +944,8 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
+	/* Syscall can be aborted (-1 can be set) or even changed
+	 * by the tracer and subsequent PTRACE_SET_SYSCALL request */
 	scno = current_thread_info()->syscall;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-- 
2.1.3

