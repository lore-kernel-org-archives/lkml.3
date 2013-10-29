Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3J2JvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3J2JvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:51:17 -0400
Date: Tue, 29 Oct 2013 11:50:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/6] kvm, emulator: Add initial three-byte insns support
Message-ID: <20131029095043.GV15657@redhat.com>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-5-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379861095-628-5-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 04:44:53PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Add initial support for handling three-byte instructions in the
> emulator.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kvm/emulate.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 67277bcb377a..72093d76c769 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3880,6 +3880,25 @@ static const struct opcode twobyte_table[256] = {
>  	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
>  };
>  
> +static const struct gprefix third_opcode_byte_0xf0 = {
> +	N, N, N, N
> +};
> +
> +static const struct gprefix third_opcode_byte_0xf1 = {
> +	N, N, N, N
> +};
There are two three opcode tables, so third_opcode_byte is ambiguous.
What about pfx_0f_38_f0 and pfx_0f_38_f1?
 
> +
> +/*
> + * Insns below are selected by the prefix which indexed by the third opcode
> + * byte.
> + */
> +static const struct opcode opcode_map_0f_38[256] = {
> +	/* 0x00 - 0x7f */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> +	/* 0x80 - 0xff */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N)
> +};
> +
>  #undef D
>  #undef N
>  #undef G
> @@ -4200,6 +4219,13 @@ done_prefixes:
>  		ctxt->opcode_len = 2;
>  		ctxt->b = insn_fetch(u8, ctxt);
>  		opcode = twobyte_table[ctxt->b];
> +
> +		/* 0F_38 opcode map */
> +		if (ctxt->b == 0x38) {
> +			ctxt->opcode_len = 3;
> +			ctxt->b = insn_fetch(u8, ctxt);
> +			opcode = opcode_map_0f_38[ctxt->b];
> +		}
>  	}
>  	ctxt->d = opcode.flags;
>  
> @@ -4531,6 +4557,8 @@ special_insn:
>  
>  	if (ctxt->opcode_len == 2)
>  		goto twobyte_insn;
> +	else if (ctxt->opcode_len == 3)
> +		goto threebyte_insn;
>  
>  	switch (ctxt->b) {
>  	case 0x63:		/* movsxd */
> @@ -4715,6 +4743,8 @@ twobyte_insn:
>  		goto cannot_emulate;
>  	}
>  
> +threebyte_insn:
> +
>  	if (rc != X86EMUL_CONTINUE)
>  		goto done;
>  
> -- 
> 1.8.4

--
			Gleb.
