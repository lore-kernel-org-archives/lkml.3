Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3FBSM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 14:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3FBSMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 14:12:55 -0400
Date: Sun, 2 Jun 2013 21:12:53 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
Message-ID: <20130602181253.GP24773@redhat.com>
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 04:35:55PM +0200, Paolo Bonzini wrote:
> The x86-64 extended low-byte registers were fetched correctly from reg,
> but not from mod/rm.
> 
> This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
> not enough.
> 
Did I missed unit test patch? :)

> Cc: gnatapov@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 3.9
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index aa68106..028b34f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1239,9 +1239,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  	ctxt->modrm_seg = VCPU_SREG_DS;
>  
>  	if (ctxt->modrm_mod == 3) {
> +		int highbyte_regs = ctxt->rex_prefix == 0;
> +
>  		op->type = OP_REG;
>  		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
> -		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm, ctxt->d & ByteOp);
> +		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
> +					       highbyte_regs && (ctxt->d & ByteOp));
>  		if (ctxt->d & Sse) {
>  			op->type = OP_XMM;
>  			op->bytes = 16;
> -- 
> 1.8.1.4

--
			Gleb.
