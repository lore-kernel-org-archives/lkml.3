Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaEPUuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:50:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20444 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755891AbaEPUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:50:06 -0400
Date: Fri, 16 May 2014 16:49:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        tglx@linutronix.de, x86@kernel.org, peterz@infradead.org,
        gleb@redhat.com, hpa@zytor.com, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] x86: fix page fault tracing when KVM guest support
 enabled
Message-ID: <20140516164942.752a19db@gandalf.local.home>
In-Reply-To: <20140516194515.D859CC11@viggo.jf.intel.com>
References: <20140516194515.D859CC11@viggo.jf.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 12:45:15 -0700
Dave Hansen <dave@sr71.net> wrote:
> 
> Steven had an alternative to this which has zero overhead when
> tracing is off where this includes the standard noops even when
> tracing is disabled.  I'm unconvinced that the extra complexity
> of his apporach:
> 
> 	http://lkml.kernel.org/r/20140508194508.561ed220@gandalf.local.home
> 
> is worth it, expecially considering that the KVM code is already
> making page fault entry slower here.  This solution is
> dirt-simple.

I just threw it out there as a suggestion. I don't care either way.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

You probably need an acked-by from hpa or one of the other x86
maintainers as it touches the generic traps.h header.

-- Steve

> 
> Gleb, please apply.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
>  b/arch/x86/include/asm/traps.h |    5 +++++
>  b/arch/x86/kernel/kvm.c        |    2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff -puN arch/x86/include/asm/traps.h~muck-with-kvm-guest-code arch/x86/include/asm/traps.h
> --- a/arch/x86/include/asm/traps.h~muck-with-kvm-guest-code	2014-05-16 12:29:23.900429347 -0700
> +++ b/arch/x86/include/asm/traps.h	2014-05-16 12:29:23.905429570 -0700
> @@ -74,6 +74,11 @@ dotraplinkage void do_general_protection
>  dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
>  #ifdef CONFIG_TRACING
>  dotraplinkage void trace_do_page_fault(struct pt_regs *, unsigned long);
> +#else
> +static inline void trace_do_page_fault(struct pt_regs *regs, unsigned long error)
> +{
> +	do_page_fault(regs, error);
> +}
>  #endif
>  dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
>  dotraplinkage void do_coprocessor_error(struct pt_regs *, long);
> diff -puN arch/x86/kernel/kvm.c~muck-with-kvm-guest-code arch/x86/kernel/kvm.c
> --- a/arch/x86/kernel/kvm.c~muck-with-kvm-guest-code	2014-05-16 12:29:23.902429437 -0700
> +++ b/arch/x86/kernel/kvm.c	2014-05-16 12:29:23.906429615 -0700
> @@ -259,7 +259,7 @@ do_async_page_fault(struct pt_regs *regs
>  
>  	switch (kvm_read_and_reset_pf_reason()) {
>  	default:
> -		do_page_fault(regs, error_code);
> +		trace_do_page_fault(regs, error_code);
>  		break;
>  	case KVM_PV_REASON_PAGE_NOT_PRESENT:
>  		/* page is swapped out by the host. */
> _

