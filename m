Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3J3R4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab3J3R4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:56:35 -0400
Message-ID: <5271483A.10805@redhat.com>
Date: Wed, 30 Oct 2013 18:56:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5 -v3.1] kvm: Emulate MOVBE
References: <1379861095-628-1-git-send-email-bp@alien8.de> <20131029095300.GW15657@redhat.com> <20131029103003.GA10977@pd.tnic> <20131029103524.GZ15657@redhat.com> <20131029112824.GD10972@pd.tnic> <20131029113603.GC15657@redhat.com> <20131029115303.GE10972@pd.tnic> <20131029115456.GG10972@pd.tnic>
In-Reply-To: <20131029115456.GG10972@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/10/2013 12:54, Borislav Petkov ha scritto:
> From: Borislav Petkov <bp@suse.de>
> 
> This basically came from the need to be able to boot 32-bit Atom SMP
> guests on an AMD host, i.e. a host which doesn't support MOVBE. As a
> matter of fact, qemu has since recently received MOVBE support but we
> cannot share that with kvm emulation and thus we have to do this in the
> host. We're waay faster in kvm anyway. :-)
> 
> So, we piggyback on the #UD path and emulate the MOVBE functionality.
> With it, an 8-core SMP guest boots in under 6 seconds.
> 
> Also, requesting MOVBE emulation needs to happen explicitly to work,
> i.e. qemu -cpu n270,+movbe...
> 
> Just FYI, a fairly straight-forward boot of a MOVBE-enabled 3.9-rc6+
> kernel in kvm executes MOVBE ~60K times.
> 
> Signed-off-by: Andre Przywara <andre@andrep.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kvm/cpuid.c   | 18 ++++++++++++++++-
>  arch/x86/kvm/emulate.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 66 insertions(+), 5 deletions(-)

Thanks, I've applied these patches to kvm/queue.

Paolo

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 78a4439bfdc5..86d5756dda07 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -222,6 +222,22 @@ static bool supported_xcr0_bit(unsigned bit)
>  static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
>  				   u32 func, u32 index, int *nent, int maxnent)
>  {
> +	switch (func) {
> +	case 0:
> +		entry->eax = 1;		/* only one leaf currently */
> +		++*nent;
> +		break;
> +	case 1:
> +		entry->ecx = F(MOVBE);
> +		++*nent;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	entry->function = func;
> +	entry->index = index;
> +
>  	return 0;
>  }
>  
> @@ -593,7 +609,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  		return -EINVAL;
>  
>  	r = -ENOMEM;
> -	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
> +	cpuid_entries = vzalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
>  	if (!cpuid_entries)
>  		goto out;
>  
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 6c5cfe962b28..8e2a07bd8eac 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2961,6 +2961,46 @@ static int em_mov(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>  
> +#define FFL(x) bit(X86_FEATURE_##x)
> +
> +static int em_movbe(struct x86_emulate_ctxt *ctxt)
> +{
> +	u32 ebx, ecx, edx, eax = 1;
> +	u16 tmp;
> +
> +	/*
> +	 * Check MOVBE is set in the guest-visible CPUID leaf.
> +	 */
> +	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx);
> +	if (!(ecx & FFL(MOVBE)))
> +		return emulate_ud(ctxt);
> +
> +	switch (ctxt->op_bytes) {
> +	case 2:
> +		/*
> +		 * From MOVBE definition: "...When the operand size is 16 bits,
> +		 * the upper word of the destination register remains unchanged
> +		 * ..."
> +		 *
> +		 * Both casting ->valptr and ->val to u16 breaks strict aliasing
> +		 * rules so we have to do the operation almost per hand.
> +		 */
> +		tmp = (u16)ctxt->src.val;
> +		ctxt->dst.val &= ~0xffffUL;
> +		ctxt->dst.val |= (unsigned long)swab16(tmp);
> +		break;
> +	case 4:
> +		ctxt->dst.val = swab32((u32)ctxt->src.val);
> +		break;
> +	case 8:
> +		ctxt->dst.val = swab64(ctxt->src.val);
> +		break;
> +	default:
> +		return X86EMUL_PROPAGATE_FAULT;
> +	}
> +	return X86EMUL_CONTINUE;
> +}
> +
>  static int em_cr_write(struct x86_emulate_ctxt *ctxt)
>  {
>  	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
> @@ -3893,11 +3933,11 @@ static const struct opcode twobyte_table[256] = {
>  };
>  
>  static const struct gprefix three_byte_0f_38_f0 = {
> -	N, N, N, N
> +	I(DstReg | SrcMem | Mov, em_movbe), N, N, N
>  };
>  
>  static const struct gprefix three_byte_0f_38_f1 = {
> -	N, N, N, N
> +	I(DstMem | SrcReg | Mov, em_movbe), N, N, N
>  };
>  
>  /*
> @@ -3907,8 +3947,13 @@ static const struct gprefix three_byte_0f_38_f1 = {
>  static const struct opcode opcode_map_0f_38[256] = {
>  	/* 0x00 - 0x7f */
>  	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> -	/* 0x80 - 0xff */
> -	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N)
> +	/* 0x80 - 0xef */
> +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> +	/* 0xf0 - 0xf1 */
> +	GP(EmulateOnUD | ModRM | Prefix, &three_byte_0f_38_f0),
> +	GP(EmulateOnUD | ModRM | Prefix, &three_byte_0f_38_f1),
> +	/* 0xf2 - 0xff */
> +	N, N, X4(N), X8(N)
>  };
>  
>  #undef D
> 

