Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaDDJrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaDDJrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:47:33 -0400
Message-ID: <533E7FB1.3070908@redhat.com>
Date: Fri, 04 Apr 2014 11:47:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] KVM: emulate: clean up initializations in init_decode_cache
References: <1396564070-5586-1-git-send-email-bsd@redhat.com> <1396564070-5586-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1396564070-5586-3-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bandan.

> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 8e2b866..eac488b 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1072,6 +1072,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  		ctxt->modrm_reg = (ctxt->rex_prefix & 4) << 1;	/* REX.R */
>  		index_reg = (ctxt->rex_prefix & 2) << 2; /* REX.X */
>  		ctxt->modrm_rm = base_reg = (ctxt->rex_prefix & 1) << 3; /* REG.B */
> +	} else {
> +		ctxt->modrm_reg = 0;
> +		ctxt->modrm_rm = 0;
>  	}

You can drop the if altogether here (and also the initialization
in "int index_reg = 0, base_reg = 0, scale;").

Also, getting down to micro-micro-optimization, the following will give
slightly better code:

 		ctxt->modrm_reg = (ctxt->rex_prefix << 1) & 8; /* REX.R */
 		index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
 		ctxt->modrm_rm = base_reg = (ctxt->rex_prefix << 3) & 8; /* REG.B */

because x86 can do a three-operand shift (using the LEA instruction), but
not three-operand AND.

>  	ctxt->modrm_mod |= (ctxt->modrm & 0xc0) >> 6;
> @@ -4357,6 +4360,8 @@ done_prefixes:
>  
>  	if (ctxt->d & ModRM)
>  		ctxt->modrm = insn_fetch(u8, ctxt);
> +	else
> +		ctxt->modrm = 0;

I think in the "else" case modrm won't be read at all, but it is indeed a bit
safer this way.  You can just leave it in the "zeroed" part of ctxt.  There is
padding in the struct, so you get the initialization for free.


>  	while (ctxt->d & GroupMask) {
>  		switch (ctxt->d & GroupMask) {
> @@ -4435,10 +4440,14 @@ done_prefixes:
>  			ctxt->op_bytes = 16;
>  		else if (ctxt->d & Mmx)
>  			ctxt->op_bytes = 8;
> +	} else {
> +		ctxt->intercept = 0;

You can add a preparatory patch that checks (ctxt->d & Intercept) in
x86_emulate_insn instead of ctxt->intercept and skip this initialization.

> +		ctxt->check_perm = NULL;

Similarly you can check (ctxt->d & CheckPerm) and skip this initialization.

>  	}

Same here: the common case will zero them, might as well leave it to the memset.

>  
>  	/* ModRM and SIB bytes. */
>  	if (ctxt->d & ModRM) {
> +		ctxt->modrm_mod = 0;

What about instead changing

        ctxt->modrm_mod |= (ctxt->modrm & 0xc0) >> 6;

from "|=" to "="?

>  		rc = decode_modrm(ctxt, &ctxt->memop);
>  		if (!ctxt->has_seg_override)
>  			set_seg_override(ctxt, ctxt->modrm_seg);
> @@ -4552,14 +4561,41 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
>  
>  void init_decode_cache(struct x86_emulate_ctxt *ctxt)
>  {
> -	memset(&ctxt->opcode_len, 0,
> -	       (void *)&ctxt->_regs - (void *)&ctxt->opcode_len);
>  
> -	ctxt->fetch.start = 0;
> -	ctxt->fetch.end = 0;
> +	/*
> +	 * Variables that don't require initializing to 0
> +	 * opcode_len - set in x86_decode_insn
> +	 * b - set in x86_decode_insn
> +	 * intercept - conditionally set in x86_decode_insn, added
> +	 *             else set to 0
> +	 * op_bytes - initialized in x86_decode_insn
> +	 * ad_bytes - initialized in x86_decode_insn
> +	 * rex_prefix - conditionally set in x86_decode_isn

I think rex_prefix must be in the zeroed area.  Again, with careful field
placement you get that for free.

> +	 * struct operands src,src2,dst - set by calling decode_operand
> +	 *                                in x86_decode_insn,
> +	 *                                default.type = OP_NONE
> +	 * (*execute) - set in x86_decode_insn
> +	 * (*check_perm) - conditionally set in x86_decode_insn, added
> +	 *                 else set to 0
> +	 * d - set in x86_decode_insn
> +	 * modrm - conditionally set in x86_decode_insn, added else set to 0
> +	 * modrm_mod - or'ed in decode_modrm which is conditionally called in
> +	 *             in x86_decode_insn, added initialization to 0 before call
> +	 * modrm_reg - set in decode_modrm or else decode_register_operand
> +	 * modrm_rm - set in decode_modrm, added else set to 0
> +	 * modrm_seg - set in decode_modrm
> +	 * _eip - set in x86_decode_insn
> +	 * memop - .type set to OP_NONE in x86_decode_insn
> +	 * ctxt->fetch.start - set in x86_decode_insn
> +	 * ctxt->fetch.end
> +	 * ctxt->mem_read.pos - set in x86_emulate_insn

Apart from the above suggestions, I agree with this patch.

Also, memopp is initialized to NULL and can be moved to the zeroed area.
But perhaps we can remove memopp, see below.

You now have:

+	u8 lock_prefix;
+	u8 rep_prefix;
 	bool has_seg_override;
 	u8 seg_override;
 	u64 d;
+	bool rip_relative;
+	/* bitmaps of registers in _regs[] that can be read */
+	u32 regs_valid;
+	/* bitmaps of registers in _regs[] that have been written */
+	u32 regs_dirty;

Even if we add back a couple of fields, that's pretty good!  It's 32
bytes (four stores).  rip_relative introduces a lot of padding; move
it together with other u8 and bool fields, and that makes 24.
And ctxt->d is in the zeroed area by mistake, which makes it 16.

There is a little more that you can do in this field.

seg_override can be moved out of the zeroed area, and the seg_override()
calls can be changed to direct accesses of the field.  Please double check
though. :)  Actually, if the above is true, has_seg_override can also be
eliminated and moved to x86_decode_insn as a local variable.

We could also get rid completely of rip_relative and move it to a local
variable in decode_modrm.  Currently it is in x86_decode_insn because
of this earlier check:

        if (ctxt->memop.type == OP_MEM && ctxt->ad_bytes != 8)
                ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;

	...

        if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
                ctxt->memopp->addr.mem.ea += ctxt->_eip;


but I think the earlier check can be moved to decode_modrm as well.
This is my reasoning:

- the first "if" can only trigger for modrm (decode_abs will not set
mem.ea to an out-of-range value if ctxt->ad_bytes != 8)

- ctxt->memopp != NULL means that *ctxt->memopp was copied from ctxt->memop
(so it must be either ModRM or MemAbs), but rip_relative is set to 1
only if the instruction is ModRM, never for MemAbs.

And once you do this, memopp is never read anymore and can be dropped.


This gives the following series:

- patch 1 from here

- replace ->intercept and ->check_perm checks with ctxt->d checks

- cleanups and code changes from this patch, except struct reorganization and
memset change

- struct reorganization and memset change; instead of the large comment in
init_decode_cache, please add comments in front of each field or group of
fields

- removing has_seg_override and moving seg_override out of the zeroed area

- removing memopp and rip_relative

(BTW, I found a bug in my second series while studying your patch.  It
ignores the mem_read cache in prepare_memory_operand, but it shouldn't).

Paolo
