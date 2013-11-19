Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3KSPCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3KSPCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:02:48 -0500
Message-ID: <528B7D79.6030208@redhat.com>
Date: Tue, 19 Nov 2013 16:02:17 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Dan Aloni <alonid@stratoscale.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org, gleb@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Muli Ben-Yehuda <muli@stratoscale.com>
Subject: Re: [PATCH linux-next 2/2] kvm-x86: emulator: disable kgdb-x86 on
 fastop and fpe flush
References: <1384872810-29492-1-git-send-email-alonid@stratoscale.com> <1384872810-29492-3-git-send-email-alonid@stratoscale.com>
In-Reply-To: <1384872810-29492-3-git-send-email-alonid@stratoscale.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/11/2013 15:53, Dan Aloni ha scritto:
> We have seen that when kvm-unit-tests runs with kgdb enabled, the
> kernel halts on the debugger during the KVM x86 instruction emulation
> that performs a test of a division by zero, and also during fwait.
> 
> This patch adds calls that temporarily disable the debugger trap.
> 
> Signed-off-by: Dan Aloni <alonid@stratoscale.com>
> Signed-off-by: Muli Ben-Yehuda <muli@stratoscale.com>
> ---
>  arch/x86/kvm/emulate.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 07ffca0..05e8509 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -24,6 +24,7 @@
>  #include "kvm_cache_regs.h"
>  #include <linux/module.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kgdb.h>
>  #include <linux/stringify.h>
>  
>  #include "x86.h"
> @@ -4438,6 +4439,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
>  {
>  	bool fault = false;
>  
> +	kgdb_ll_local_disable();
>  	ctxt->ops->get_fpu(ctxt);
>  	asm volatile("1: fwait \n\t"
>  		     "2: \n\t"
> @@ -4449,6 +4451,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
>  		     _ASM_EXTABLE(1b, 3b)
>  		     : [fault]"+qm"(fault));
>  	ctxt->ops->put_fpu(ctxt);
> +	kgdb_ll_local_enable();
>  
>  	if (unlikely(fault))
>  		return emulate_exception(ctxt, MF_VECTOR, 0, false);
> @@ -4468,10 +4471,14 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
>  	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
>  	if (!(ctxt->d & ByteOp))
>  		fop += __ffs(ctxt->dst.bytes) * FASTOP_SIZE;
> +
> +	kgdb_ll_local_disable();
>  	asm("push %[flags]; popf; call *%[fastop]; pushf; pop %[flags]\n"
>  	    : "+a"(ctxt->dst.val), "+d"(ctxt->src.val), [flags]"+D"(flags),
>  	      [fastop]"+S"(fop)
>  	    : "c"(ctxt->src2.val));
> +	kgdb_ll_local_enable();
> +
>  	ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
>  	if (!fop) /* exception is returned in fop variable */
>  		return emulate_de(ctxt);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
