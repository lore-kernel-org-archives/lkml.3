Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3EIKDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:03:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3EIKDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:03:18 -0400
Date: Thu, 9 May 2013 13:03:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, j-nomura@ce.jp.nec.com,
        stable@vger.kernel.org.#.3.9
Subject: Re: [PATCH v2 2/3] KVM: emulator: emulate XLAT
Message-ID: <20130509100314.GD32023@redhat.com>
References: <1368091971-5071-1-git-send-email-pbonzini@redhat.com>
 <1368091971-5071-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368091971-5071-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:32:50AM +0200, Paolo Bonzini wrote:
> This is used by SGABIOS, KVM breaks with emulate_invalid_guest_state=1.
> It is just a MOV in disguise, with a funny source address.
> 
> Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: stable@vger.kernel.org # 3.9
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 709ba03..210bb4e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -60,6 +60,7 @@
>  #define OpGS              25ull  /* GS */
>  #define OpMem8            26ull  /* 8-bit zero extended memory operand */
>  #define OpImm64           27ull  /* Sign extended 16/32/64-bit immediate */
> +#define OpXLat            28ull  /* memory at BX/EBX/RBX + zero-extended AL */
>  
>  #define OpBits             5  /* Width of operand field */
>  #define OpMask             ((1ull << OpBits) - 1)
> @@ -99,6 +100,7 @@
>  #define SrcImmUByte (OpImmUByte << SrcShift)
>  #define SrcImmU     (OpImmU << SrcShift)
>  #define SrcSI       (OpSI << SrcShift)
> +#define SrcXLat     (OpXLat << SrcShift)
>  #define SrcImmFAddr (OpImmFAddr << SrcShift)
>  #define SrcMemFAddr (OpMemFAddr << SrcShift)
>  #define SrcAcc      (OpAcc << SrcShift)
> @@ -3949,7 +3951,8 @@ static const struct opcode opcode_table[256] = {
>  	G(Src2One | ByteOp, group2), G(Src2One, group2),
>  	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
>  	I(DstAcc | SrcImmUByte | No64, em_aam),
> -	I(DstAcc | SrcImmUByte | No64, em_aad), N, N,
> +	I(DstAcc | SrcImmUByte | No64, em_aad), N,
> +	I(DstAcc | SrcXLat | ByteOp, em_mov),
>  	/* 0xD8 - 0xDF */
>  	N, E(0, &escape_d9), N, E(0, &escape_db), N, E(0, &escape_dd), N, N,
>  	/* 0xE0 - 0xE7 */
> @@ -4207,6 +4210,17 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
>  		op->val = 0;
>  		op->count = 1;
>  		break;
> +	case OpXLat:
Sigh, obviously this is not reusable by any other instruction. So many
waisted transistor :(

> +		op->type = OP_MEM;
> +		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
> +		op->addr.mem.ea =
> +			register_address(ctxt,
> +				reg_read(ctxt, VCPU_REGS_RBX) +
> +				(reg_read(ctxt, VCPU_REGS_RAX) & 0xff));
> +		op->addr.mem.seg = seg_override(ctxt);
> +		op->val = 0;
> +		op->count = 1;
The count is set only for decoding that is used by string instructions.
I can drop it while applying.

> +		break;
>  	case OpImmFAddr:
>  		op->type = OP_IMM;
>  		op->addr.mem.ea = ctxt->_eip;
> -- 
> 1.8.1.4
> 

--
			Gleb.
