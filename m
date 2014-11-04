Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaKDXoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:44:07 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61180 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKDXoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:44:05 -0500
MIME-Version: 1.0
In-Reply-To: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
References: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Nov 2014 15:43:43 -0800
Message-ID: <CALCETrVKW39sg8mYTTgzqkMpW3GeJM-SSNCK6rJWd5Y+_=6rfQ@mail.gmail.com>
Subject: Re: [PATCH] x86_64,entry: Fix RCX for traced syscalls
To: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:08 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> The int_ret_from_sys_call and syscall tracing code disagrees with
> the sysret path as to the value of RCX.
>
> The Intel SDM, the AMD APM, and my laptop all agree that sysret
> returns with RCX == RIP.  The syscall tracing code does not respect
> this property.
>
> For example, this program:
>
> int main()
> {
>         extern const char syscall_rip[];
>         unsigned long rcx = 1;
>         unsigned long orig_rcx = rcx;
>         asm ("mov $-1, %%eax\n\t"
>              "syscall\n\t"
>              "syscall_rip:"
>              : "+c" (rcx) : : "r11");
>         printf("syscall: RCX = %lX  RIP = %lX  orig RCX = %lx\n",
>                rcx, (unsigned long)syscall_rip, orig_rcx);
>         return 0;
> }
>
> prints:
> syscall: RCX = 400556  RIP = 400556  orig RCX = 1
>
> Running it under strace gives this instead:
> syscall: RCX = FFFFFFFFFFFFFFFF  RIP = 400556  orig RCX = 1
>
> This changes FIXUP_TOP_OF_STACK to match sysret, causing the test to
> show RCX == RIP even under strace.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/kernel/entry_64.S | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b25ca96..6624e18 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -143,7 +143,8 @@ ENDPROC(native_usergs_sysret64)
>         movq \tmp,RSP+\offset(%rsp)
>         movq $__USER_DS,SS+\offset(%rsp)
>         movq $__USER_CS,CS+\offset(%rsp)
> -       movq $-1,RCX+\offset(%rsp)
> +       movq RIP+\offset(%rsp),\tmp  /* get rip */
> +       movq \tmp,RCX+\offset(%rsp)  /* copy it to rcx as sysret would do */
>         movq R11+\offset(%rsp),\tmp  /* get eflags */
>         movq \tmp,EFLAGS+\offset(%rsp)
>         .endm
> --
> 1.9.3
>

Hi all-

I think this got lost.  No one acked it, but no one nacked it either.
Summary of arguments in favor of applying:

 - It's arguably a bugfix.

 - Processes shouldn't be able to detect that they're being traced.
There are probably any number of ways that tracing is visible, but
this fixes one of them.

 - The assembly code is complex enough anyway without requiring people
to wonder why setting the saved RCX to -1 is a reasonable thing to do.

 - The performance hit is probably negligible.  It's a single
instruction, it only happens during a slow path, and it's unlikely to
cause a cache miss.

Summary of arguments against:

 - It adds one instruction.

 - The bug it fixes isn't really entirely obviously a bug in the first place.

I'm still in favor.

--Andy
