Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaFPKR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:17:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbaFPKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:17:57 -0400
Message-ID: <539EC43F.607@redhat.com>
Date: Mon, 16 Jun 2014 12:17:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH 6/6] KVM: x86: check DR6/7 high-bits are clear only on
 long-mode
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il> <1402837982-24959-7-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1402837982-24959-7-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/06/2014 15:13, Nadav Amit ha scritto:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> When the guest sets DR6 and DR7, KVM asserts the high 32-bits are clear, and
> otherwise injects a #GP exception. This exception should only be injected only
> if running in long-mode.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/x86.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 57eac30..71fe841 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -756,6 +756,15 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
>  		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
>  }
>
> +static bool is_64_bit_mode(struct kvm_vcpu *vcpu)
> +{
> +	int cs_db, cs_l;
> +	if (!is_long_mode(vcpu))
> +		return false;
> +	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> +	return cs_l;
> +}
> +
>  static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  {
>  	switch (dr) {
> @@ -769,7 +778,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  			return 1; /* #UD */
>  		/* fall through */
>  	case 6:
> -		if (val & 0xffffffff00000000ULL)
> +		if ((val & 0xffffffff00000000ULL) && is_64_bit_mode(vcpu))
>  			return -1; /* #GP */
>  		vcpu->arch.dr6 = (val & DR6_VOLATILE) | DR6_FIXED_1;
>  		kvm_update_dr6(vcpu);
> @@ -779,7 +788,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  			return 1; /* #UD */
>  		/* fall through */
>  	default: /* 7 */
> -		if (val & 0xffffffff00000000ULL)
> +		if ((val & 0xffffffff00000000ULL) && is_64_bit_mode(vcpu))
>  			return -1; /* #GP */
>  		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
>  		kvm_update_dr7(vcpu);
>

Do you get this if the input register has bit 31 set?

Paolo
