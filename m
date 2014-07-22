Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaGVRCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:02:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaGVRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:02:17 -0400
Date: Tue, 22 Jul 2014 10:01:23 -0700
From: tip-bot for Sven Wegener <tipbot@zytor.com>
Message-ID: <tip-8142b215501f8b291a108a202b3a053a265b03dd@git.kernel.org>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sven.wegener@stealer.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, sven.wegener@stealer.net, tglx@linutronix.de
In-Reply-To: <alpine.LNX.2.11.1407221022380.31021@titan.int.lan.stealer.net>
References: <alpine.LNX.2.11.1407221022380.31021@titan.int.lan.stealer.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86_32, entry: Store badsys error code in %eax
Git-Commit-ID: 8142b215501f8b291a108a202b3a053a265b03dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8142b215501f8b291a108a202b3a053a265b03dd
Gitweb:     http://git.kernel.org/tip/8142b215501f8b291a108a202b3a053a265b03dd
Author:     Sven Wegener <sven.wegener@stealer.net>
AuthorDate: Tue, 22 Jul 2014 10:26:06 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 22 Jul 2014 02:34:05 -0700

x86_32, entry: Store badsys error code in %eax

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
Cc: <stable@vger.kernel.org> # If 554086d is backported
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_32.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dbaa23e..0d0c9d4 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -425,8 +425,8 @@ sysenter_do_call:
 	cmpl $(NR_syscalls), %eax
 	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
-	movl %eax,PT_EAX(%esp)
 sysenter_after_call:
+	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
@@ -502,6 +502,7 @@ ENTRY(system_call)
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
+syscall_after_call:
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
 	LOCKDEP_SYS_EXIT
@@ -675,12 +676,12 @@ syscall_fault:
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
