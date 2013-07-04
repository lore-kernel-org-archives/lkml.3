Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab3GDJNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933532Ab3GDJNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:13:48 -0400
Date: Thu, 4 Jul 2013 12:13:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Avi Kivity <avi.kivity@gmail.com>
Subject: Re: [PATCH] x86/kvm/emulate.c: simplify NOP (opcode 0x90) check
Message-ID: <20130704091345.GB5113@redhat.com>
References: <1372928309-16488-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372928309-16488-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 10:58:29AM +0200, Denys Vlasenko wrote:
> The check sits in switch() statement which itself can check
> for opcode 0x90 far more efficiently.
> 
> On assembler level, this change simply eliminates the following
> bit of code:
> 
> 4c 8b a3 d8 00 00 00    mov    0xd8(%rbx),%r12
> 31 f6                   xor    %esi,%esi
> 48 89 df                mov    %rbx,%rdi
> e8 32 8c ff ff          callq  490 <reg_read>
> 48 8d 83 78 01 00 00    lea    0x178(%rbx),%rax
> 83 8b 70 01 00 00 01    orl    $0x1,0x170(%rbx)
> 83 8b 74 01 00 00 01    orl    $0x1,0x174(%rbx)
> 49 39 c4                cmp    %rax,%r12
> 0f 84 88 fa ff ff       je     7304 <x86_emulate_insn+0x204>
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Avi Kivity <avi.kivity@gmail.com>
> ---
>  arch/x86/kvm/emulate.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2bc1e81..7e6e74a 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4544,9 +4544,9 @@ special_insn:
>  	case 0x8d: /* lea r16/r32, m */
>  		ctxt->dst.val = ctxt->src.addr.mem.ea;
>  		break;
> -	case 0x90 ... 0x97: /* nop / xchg reg, rax */
> -		if (ctxt->dst.addr.reg == reg_rmw(ctxt, VCPU_REGS_RAX))
> -			break;
> +	case 0x90: /* nop */
> +		break;
This does not work on 64bit and REX prefix.

> +	case 0x91 ... 0x97: /* xchg reg, rax */
>  		rc = em_xchg(ctxt);
>  		break;
>  	case 0x98: /* cbw/cwde/cdqe */
> -- 
> 1.8.1.4

--
			Gleb.
