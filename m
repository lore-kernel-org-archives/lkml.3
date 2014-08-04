Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaHDRRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:17:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56451 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sven Wegener" <sven.wegener@stealer.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.570732387@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 93/94] x86_32, entry: Store badsys error code in %eax
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Wegener <sven.wegener@stealer.net>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/entry_32.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -429,8 +429,8 @@ sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
 	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
-	movl %eax,PT_EAX(%esp)
 sysenter_after_call:
+	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
@@ -512,6 +512,7 @@ ENTRY(system_call)
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
+syscall_after_call:
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
 	LOCKDEP_SYS_EXIT
@@ -676,12 +677,12 @@ syscall_fault:
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

