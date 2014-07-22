Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaGVI0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:26:24 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:42967 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaGVI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:26:21 -0400
Date: Tue, 22 Jul 2014 10:26:06 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        stable <stable@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH] x86_32, entry: store badsys error code in %eax
Message-ID: <alpine.LNX.2.11.1407221022380.31021@titan.int.lan.stealer.net>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.3.2 2011-06-06 on smtp1.stealer.net at Tue, 22 Jul 2014 08:26:12 +0000
 Bayes: 0.0000 Tokens: new, 319; hammy, 10; neutral, 6; spammy, 0.
 AutoLearn: no
 *  1.0 URIBL_RHSMAILPOLICE Contains a URL listed in the
 *      block.rhs.mailpolice.com blocklist
 *      [URIs: stealer.net]
 * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
X-Spam-Signature: 2d57a8d0c0f2450893b303d1f35d36285dc5cffb
X-DomainKey-Status: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Reviewed-and-tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: stable@vger.kernel.org
---

I've updated the commit message and added the Reviewed-and-tested-by and 
Cc.

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
