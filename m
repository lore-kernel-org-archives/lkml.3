Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaGTWJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 18:09:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35187 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaGTWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 18:09:04 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net>
References: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86_32, entry: store badsys error code in %eax
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 20 Jul 2014 15:07:53 -0700
To: Sven Wegener <sven.wegener@stealer.net>
CC: Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        stable@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>
Message-ID: <90404aa5-cab6-44aa-9eab-4106cb16e7ab@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a subtle regression at all.  It is in fact a very very serious one.

On July 20, 2014 2:33:50 PM PDT, Sven Wegener <sven.wegener@stealer.net> wrote:
>Commit 554086d ("x86_32, entry: Do syscall exit work on badsys
>(CVE-2014-4508)") introduced a subtle regression in the x86_32 syscall
>entry code, resulting in syscall() not returning proper errors for
>non-existing syscalls on CPUs not supporting the sysenter feature.
>
>The following code:
>
>> int result = syscall(666);
>> printf("result=%d errno=%d error=%s\n", result, errno,
>strerror(errno));
>
>results in:
>
>> result=666 errno=0 error=Success
>
>Obviously, the syscall return value is the called syscall number, but
>it
>should have been an ENOSYS error. When run under ptrace it behaves
>correctly, which makes it hard to debug in the wild:
>
>> result=-1 errno=38 error=Function not implemented
>
>The %eax register is the return value register. For debugging via
>ptrace
>the syscall entry code stores the complete register context on the
>stack. The badsys handlers only store the ENOSYS error code in the
>ptrace register set and do not set %eax like a regular syscall handler
>would. The old resume_userspace call chain contains code that clobbers
>%eax and it restores %eax from the ptrace registers afterwards. The
>same
>goes for the ptrace-enabled call chain. When ptrace is not used, the
>syscall return value is the passed-in syscall number from the
>%eax register.
>
>Use %eax as the return value register in syscall_badsys and
>sysenter_badsys, like a real syscall handler does, and have the caller
>push the value onto the stack for ptrace access.
>
>Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
>---
> arch/x86/kernel/entry_32.S | 9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
>index dbaa23e..0d0c9d4 100644
>--- a/arch/x86/kernel/entry_32.S
>+++ b/arch/x86/kernel/entry_32.S
>@@ -425,8 +425,8 @@ sysenter_do_call:
> 	cmpl $(NR_syscalls), %eax
> 	jae sysenter_badsys
> 	call *sys_call_table(,%eax,4)
>-	movl %eax,PT_EAX(%esp)
> sysenter_after_call:
>+	movl %eax,PT_EAX(%esp)
> 	LOCKDEP_SYS_EXIT
> 	DISABLE_INTERRUPTS(CLBR_ANY)
> 	TRACE_IRQS_OFF
>@@ -502,6 +502,7 @@ ENTRY(system_call)
> 	jae syscall_badsys
> syscall_call:
> 	call *sys_call_table(,%eax,4)
>+syscall_after_call:
> 	movl %eax,PT_EAX(%esp)		# store the return value
> syscall_exit:
> 	LOCKDEP_SYS_EXIT
>@@ -675,12 +676,12 @@ syscall_fault:
> END(syscall_fault)
> 
> syscall_badsys:
>-	movl $-ENOSYS,PT_EAX(%esp)
>-	jmp syscall_exit
>+	movl $-ENOSYS,%eax
>+	jmp syscall_after_call
> END(syscall_badsys)
> 
> sysenter_badsys:
>-	movl $-ENOSYS,PT_EAX(%esp)
>+	movl $-ENOSYS,%eax
> 	jmp sysenter_after_call
> END(syscall_badsys)
> 	CFI_ENDPROC

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
