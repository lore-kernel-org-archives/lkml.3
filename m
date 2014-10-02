Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaJBJrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:47:07 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57306 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:47:05 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v7 1/6] arm64: ptrace: add PTRACE_SET_SYSCALL
Date: Thu,  2 Oct 2014 18:46:11 +0900
Message-Id: <1412243176-16192-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow tracer to be able to change/skip a system call by re-writing
a syscall number, there are several approaches:

(1) modify x8 register with ptrace(PTRACE_SETREGSET), and handle this case
    later on in syscall_trace_enter(), or
(2) support ptrace(PTRACE_SET_SYSCALL) as on arm

Thinking of the fact that user_pt_regs doesn't expose 'syscallno' to
tracer as well as that secure_computing() expects a changed syscall number
to be visible, especially case of -1, before this function returns in
syscall_trace_enter(), we'd better take (2).

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/uapi/asm/ptrace.h |    1 +
 arch/arm64/kernel/ptrace.c           |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 6913643..49c6174 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -23,6 +23,7 @@
 
 #include <asm/hwcap.h>
 
+#define PTRACE_SET_SYSCALL	23
 
 /*
  * PSR bits
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index fe63ac5..2842f9f 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1082,7 +1082,19 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
-	return ptrace_request(child, request, addr, data);
+	int ret;
+
+	switch (request) {
+		case PTRACE_SET_SYSCALL:
+			task_pt_regs(child)->syscallno = data;
+			ret = 0;
+			break;
+		default:
+			ret = ptrace_request(child, request, addr, data);
+			break;
+	}
+
+	return ret;
 }
 
 enum ptrace_syscall_dir {
-- 
1.7.9.5

