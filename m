Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaKZOjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaKZOjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:39:53 -0500
Date: Wed, 26 Nov 2014 15:38:56 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Gleb Natapov <gleb@kernel.org>,
        jan.kiszka@siemens.com,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com,
        r65777@freescale.com, pbonzini@redhat.com, bp@suse.de
Subject: Re: [PATCH 3/7] KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG
 ioctl
Message-ID: <20141126143855.GC3245@hawk.usersys.redhat.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-4-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416931805-23223-4-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 04:10:01PM +0000, Alex Bennée wrote:
> This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
> ioctl. Currently any operation flag will return EINVAL. Actual
> functionality will be added with further patches.

Technically the stub is already there, and you're extending it to
start looking at control flags, but still not doing anything yet.

> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>.
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 7610eaa..2c6386e 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2570,7 +2570,7 @@ handled.
>  4.87 KVM_SET_GUEST_DEBUG
>  
>  Capability: KVM_CAP_SET_GUEST_DEBUG
> -Architectures: x86, s390, ppc
> +Architectures: x86, s390, ppc, arm64
>  Type: vcpu ioctl
>  Parameters: struct kvm_guest_debug (in)
>  Returns: 0 on success; -1 on error
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9e193c8..a0ff410 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -180,6 +180,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PSCI:
>  	case KVM_CAP_ARM_PSCI_0_2:
>  	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_SET_GUEST_DEBUG:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -302,7 +303,34 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> -	return -EINVAL;
> +	/* If it's not enabled clear all flags */
> +	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
> +		vcpu->guest_debug = 0;
> +		return 0;
> +	}
> +
> +	vcpu->guest_debug = dbg->control;
> +	kvm_info("%s: guest_debug is 0x%lx\n", __func__, vcpu->guest_debug);
> +
> +	/* Single Step */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +		kvm_info("SS requested, not yet implemented\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Software Break Points */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
> +		kvm_info("SW BP support requested, not yet implemented\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Hardware assisted Break and Watch points */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +		kvm_info("HW BP support requested, not yet implemented\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
>  }

I guess all the kvm_info's were useful for developing this patch series,
but do we still need them?

>  
>  
> -- 
> 2.1.3
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
