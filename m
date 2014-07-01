Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbaGAKwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:52:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33547 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbaGAKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:52:29 -0400
Date: Tue, 1 Jul 2014 12:52:50 +0200
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, security@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@al>
Subject: Re: [PATCH] x86_32,entry: Do syscall exit work on badsys
 (CVE-2014-4508)
Message-ID: <20140701105250.GI5192@chrystal.home>
References: <CA+5PVA70nFS8JZkL0-Q-1HjFHT5NA04275_M4WstjQMrpT+hrQ@mail.gmail.com>
 <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:22:15PM -0700, Andy Lutomirski wrote:
> The bad syscall nr paths are their own incomprehensible route
> through the entry control flow.  Rearrange them to work just like
> syscalls that return -ENOSYS.
> 
> This fixes an OOPS in the audit code when fast-path auditing is
> enabled and sysenter gets a bad syscall nr (CVE-2014-4508).
> 
> This has probably been broken since Linux 2.6.27:
> af0575bba0 i386 syscall audit fast-path
> 
> Cc: stable@vger.kernel.org
> Cc: Roland McGrath <roland@redhat.com>
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> I realize that the syscall audit fast path and badsys code, on 32-bit
> x86 no less, is possibly one of the least fun things in the kernel to
> review, but this is still a real security bug and should get fixed :(
> 
> So I'm cc-ing a bunch of people and maybe someone will review it.
> 
>  arch/x86/kernel/entry_32.S | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index a2a4f46..f4258a5 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -431,9 +431,10 @@ sysenter_past_esp:
>  	jnz sysenter_audit
>  sysenter_do_call:
>  	cmpl $(NR_syscalls), %eax
> -	jae syscall_badsys
> +	jae sysenter_badsys
>  	call *sys_call_table(,%eax,4)
>  	movl %eax,PT_EAX(%esp)
> +sysenter_after_call:
>  	LOCKDEP_SYS_EXIT
>  	DISABLE_INTERRUPTS(CLBR_ANY)
>  	TRACE_IRQS_OFF
> @@ -688,7 +689,12 @@ END(syscall_fault)
>  
>  syscall_badsys:
>  	movl $-ENOSYS,PT_EAX(%esp)
> -	jmp resume_userspace
> +	jmp syscall_exit

We're workig on preparing Ksplice updates for the last Fedora20 released
kernel and stumbled on this patch.

Apologies in advance if this is obvious, but would you mind explaining why
the above change in 'syscall_badsys' is required? We're just concerned
about doing the absolute minimum changes here if we can.

> +END(syscall_badsys)
> +
> +sysenter_badsys:
> +	movl $-ENOSYS,PT_EAX(%esp)
> +	jmp sysenter_after_call
>  END(syscall_badsys)

Although it probably doesn't hurt, you may want to change the above
'END(syscall_badsys)' to 'END(sysenter_badsys)'.

Thanks,
Quentin
