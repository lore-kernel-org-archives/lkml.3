Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaFISk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaFISkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:40:24 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org
Subject: Re: [PATCH 12/25] KVM: emulate: extend memory access optimization to stores
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
	<1402318753-23362-13-git-send-email-pbonzini@redhat.com>
Date: Mon, 09 Jun 2014 14:40:19 -0400
In-Reply-To: <1402318753-23362-13-git-send-email-pbonzini@redhat.com> (Paolo
	Bonzini's message of "Mon, 9 Jun 2014 14:59:00 +0200")
Message-ID: <jpg61kaexkc.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Even on a store the optimization saves about 50 clock cycles,
> mostly because the jump in write_memory_operand becomes much more
> predictable.
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Isn't the reviewed-by automatically implied ? :)

> ---
>  arch/x86/kvm/emulate.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 594cb560947c..eaf0853ffaf9 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1589,7 +1589,7 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>  
>  static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
>  				  struct operand *op,
> -				  bool write)
> +				  bool read, bool write)
>  {
>  	int rc;
>  	unsigned long gva;
> @@ -1605,6 +1605,10 @@ static int prepare_memory_operand(struct x86_emulate_ctxt *ctxt,
>  	if (rc != X86EMUL_CONTINUE)
>  		return rc;
>  
> +	/* optimisation - avoid slow emulated read if Mov */
> +	if (!read)
> +		return X86EMUL_CONTINUE;
> +
>  	if (likely(!kvm_is_error_hva(op->hva))) {
>  		rc = read_from_user(ctxt, op->hva, &op->val, size);
>  		if (!write)
> @@ -4699,14 +4703,14 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  	}
>  
>  	if ((ctxt->src.type == OP_MEM) && !(ctxt->d & NoAccess)) {
> -		rc = prepare_memory_operand(ctxt, &ctxt->src, false);
> +		rc = prepare_memory_operand(ctxt, &ctxt->src, true, false);
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
>  		ctxt->src.orig_val64 = ctxt->src.val64;
>  	}
>  
>  	if (ctxt->src2.type == OP_MEM) {
> -		rc = prepare_memory_operand(ctxt, &ctxt->src2, false);
> +		rc = prepare_memory_operand(ctxt, &ctxt->src2, true, false);
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
>  	}
> @@ -4715,9 +4719,9 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  		goto special_insn;
>  
>  
> -	if ((ctxt->dst.type == OP_MEM) && !(ctxt->d & Mov)) {
> -		/* optimisation - avoid slow emulated read if Mov */
> +	if (ctxt->dst.type == OP_MEM) {
>  		rc = prepare_memory_operand(ctxt, &ctxt->dst,
> +					    !(ctxt->d & Mov),
>  					    !(ctxt->d & NoWrite));
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
