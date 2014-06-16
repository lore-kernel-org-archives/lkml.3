Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaFPRjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaFPRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:39:08 -0400
From: Bandan Das <bsd@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: pbonzini@redhat.com, gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: x86: Wrong emulation on 'xadd X, X'
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
	<1402837982-24959-3-git-send-email-namit@cs.technion.ac.il>
Date: Mon, 16 Jun 2014 13:38:51 -0400
In-Reply-To: <1402837982-24959-3-git-send-email-namit@cs.technion.ac.il>
	(Nadav Amit's message of "Sun, 15 Jun 2014 16:12:58 +0300")
Message-ID: <jpg7g4gzrdg.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadav Amit <namit@cs.technion.ac.il> writes:

> The emulator does not emulate the xadd instruction correctly if the two
> operands are the same.  In this (unlikely) situation the result should be the
> sum of X and X (2X) when it is currently X.  The solution is to first perform
> writeback to the source, before writing to the destination.  The only
> instruction which should be affected is xadd, as the other instructions that
> perform writeback to the source use the extended accumlator (e.g., RAX:RDX).
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f0b0a10..3c8d867 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4711,17 +4711,17 @@ special_insn:
>  		goto done;
>  
>  writeback:
> -	if (!(ctxt->d & NoWrite)) {
> -		rc = writeback(ctxt, &ctxt->dst);
> -		if (rc != X86EMUL_CONTINUE)
> -			goto done;
> -	}
>  	if (ctxt->d & SrcWrite) {
>  		BUG_ON(ctxt->src.type == OP_MEM || ctxt->src.type == OP_MEM_STR);
While we are here, I think we should replace this BUG_ON with a warning
and return X86EMUL_UNHANDLEABLE if the condition is true.

>  		rc = writeback(ctxt, &ctxt->src);
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
>  	}
> +	if (!(ctxt->d & NoWrite)) {
> +		rc = writeback(ctxt, &ctxt->dst);
> +		if (rc != X86EMUL_CONTINUE)
> +			goto done;
> +	}
>  
>  	/*
>  	 * restore dst type in case the decoding will be reused
