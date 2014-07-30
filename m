Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaG3MSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:18:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36820 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbaG3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Wegener <sven.wegener@stealer.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 91/94] x86_32, entry: Store badsys error code in %eax
Date: Wed, 30 Jul 2014 14:15:20 +0200
Message-Id: <f4714f6dfeb7d9636cca7127a18609cc1e4860d9.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Wegener <sven.wegener@stealer.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8142b215501f8b291a108a202b3a053a265b03dd upstream.

Commit 554086d ("x86_32, entry: Do syscall exit work on badsys
(CVE-2014-4508)") introduced a regression in the x86_32 syscall entry
code, resulting in syscall() not returning proper errors for undefined
syscalls on CPUs supporting the sysenter feature.

The following code:

> int result = syscall(666);
> printf("result=%d errno=%d error=%s\n", result, errno, strerror(errno));

results in:

> result=666 errno=0 error=Success

Obviously, the syscall return value is the called syscall number, but it
should have been an ENOSYS error. When run under ptrace it behaves
correctly, which makes it hard to debug in the wild:

> result=-1 errno=38 error=Function not implemented

The %eax register is the return value register. For debugging via ptrace
the syscall entry code stores the complete register context on the
stack. The badsys handlers only store the ENOSYS error code in the
ptrace register set and do not set %eax like a regular syscall handler
would. The old resume_userspace call chain contains code that clobbers
%eax and it restores %eax from the ptrace registers afterwards. The same
goes for the ptrace-enabled call chain. When ptrace is not used, the
syscall return value is the passed-in syscall number from the untouched
%eax register.

Use %eax as the return value register in syscall_badsys and
sysenter_badsys, like a real syscall handler does, and have the caller
push the value onto the stack for ptrace access.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Link: http://lkml.kernel.org/r/alpine.LNX.2.11.1407221022380.31021@titan.int.lan.stealer.net
Reviewed-and-tested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/entry_32.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 3308125c90aa..1fc2a347c47c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -436,8 +436,8 @@ sysenter_do_call:
 	cmpl $(NR_syscalls), %eax
 	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
-	movl %eax,PT_EAX(%esp)
 sysenter_after_call:
+	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
@@ -517,6 +517,7 @@ ENTRY(system_call)
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
+syscall_after_call:
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
 	LOCKDEP_SYS_EXIT
@@ -686,12 +687,12 @@ syscall_fault:
 END(syscall_fault)
 
 syscall_badsys:
-	movl $-ENOSYS,PT_EAX(%esp)
-	jmp syscall_exit
+	movl $-ENOSYS,%eax
+	jmp syscall_after_call
 END(syscall_badsys)
 
 sysenter_badsys:
-	movl $-ENOSYS,PT_EAX(%esp)
+	movl $-ENOSYS,%eax
 	jmp sysenter_after_call
 END(syscall_badsys)
 	CFI_ENDPROC
-- 
2.0.1

