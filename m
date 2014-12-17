Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaLQRnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:43:06 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61058 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaLQRnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:43:04 -0500
Message-ID: <5491C0A2.7040503@redhat.com>
Date: Wed, 17 Dec 2014 18:42:58 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-26-git-send-email-feng.wu@intel.com>
In-Reply-To: <1418397300-10870-26-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 16:14, Feng Wu wrote:
> Currently, we don't support urgent interrupt, all interrupts
> are recognized as non-urgent interrupt, so we cannot send
> posted-interrupt when 'SN' is set.

Can this happen?  If the vcpu is in guest mode, it cannot have been
scheduled out, and that's the only case when SN is set.

Paolo

> Signed-off-by: Feng Wu <feng.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/kvm/vmx.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index a1c83a2..0aee151 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4401,15 +4401,22 @@ static int vmx_vm_has_apicv(struct kvm *kvm)
>  static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	int r;
> +	int r, sn;
>  
>  	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
>  		return;
>  
> +	/*
> +	 * Currently, we don't support urgent interrupt, all interrupts
> +	 * are recognized as non-urgent interrupt, so we cannot send
> +	 * posted-interrupt when 'SN' is set.
> +	 */
> +	sn = pi_test_sn(&vmx->pi_desc);
> +
>  	r = pi_test_and_set_on(&vmx->pi_desc);
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  #ifdef CONFIG_SMP
> -	if (!r && (vcpu->mode == IN_GUEST_MODE))
> +	if (!r && !sn && (vcpu->mode == IN_GUEST_MODE))
>  		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
>  				POSTED_INTR_VECTOR);
>  	else
> -- 
