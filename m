Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaKMK4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:56:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbaKMK4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:56:34 -0500
Message-ID: <54648E53.9080309@redhat.com>
Date: Thu, 13 Nov 2014 11:56:19 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Chris J Arges <chris.j.arges@canonical.com>, kvm@vger.kernel.org
CC: Joerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: svm: move WARN_ON in svm_adjust_tsc_offset
References: <1415847657-22178-1-git-send-email-chris.j.arges@canonical.com>
In-Reply-To: <1415847657-22178-1-git-send-email-chris.j.arges@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/2014 04:00, Chris J Arges wrote:
> When running the tsc_adjust kvm-unit-test on an AMD processor with the
> IA32_TSC_ADJUST feature enabled, the WARN_ON in svm_adjust_tsc_offset can be
> triggered. This WARN_ON checks for a negative adjustment in case __scale_tsc
> is called; however it may trigger unnecessary warnings.
> 
> This patch moves the WARN_ON to trigger only if __scale_tsc will actually be
> called from svm_adjust_tsc_offset. In addition make adj in kvm_set_msr_common
> s64 since this can have signed values.
> 
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> ---
>  arch/x86/kvm/svm.c | 8 +++++---
>  arch/x86/kvm/x86.c | 2 +-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d4f3aaa..6b411ad 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1056,9 +1056,11 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool ho
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	WARN_ON(adjustment < 0);
> -	if (host)
> -		adjustment = svm_scale_tsc(vcpu, adjustment);
> +	if (host) {
> +		if (svm->tsc_ratio != TSC_RATIO_DEFAULT)
> +			WARN_ON(adjustment < 0);
> +		adjustment = svm_scale_tsc(vcpu, (u64)adjustment);
> +	}
>  
>  	svm->vmcb->control.tsc_offset += adjustment;
>  	if (is_guest_mode(vcpu))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f85da5c..1cd1376 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2141,7 +2141,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_TSC_ADJUST:
>  		if (guest_cpuid_has_tsc_adjust(vcpu)) {
>  			if (!msr_info->host_initiated) {
> -				u64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
> +				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
>  				kvm_x86_ops->adjust_tsc_offset(vcpu, adj, true);
>  			}
>  			vcpu->arch.ia32_tsc_adjust_msr = data;
> 

Applied, thanks!

Paolo
