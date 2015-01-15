Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbbAOLGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:06:16 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34589 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbbAOLGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:06:14 -0500
Date: Thu, 15 Jan 2015 12:06:15 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, kim.phillips@freescale.com, paulus@samba.org,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com,
        b.reynal@virtualopensystems.com
Subject: Re: [PATCH v6 3/4] KVM: arm/arm64: implement
 kvm_arch_intc_initialized and use it in irqfd
Message-ID: <20150115110615.GQ26222@cbox>
References: <1421170420-30617-1-git-send-email-eric.auger@linaro.org>
 <1421170420-30617-4-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421170420-30617-4-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 06:33:39PM +0100, Eric Auger wrote:
> On arm/arm64 the VGIC is dynamically instantiated and it is useful
> to expose its state, especially for irqfd setup.
> 
> This patch defines __KVM_HAVE_ARCH_INTC_INITIALIZED and
> implements kvm_arch_intc_initialized.
> 
> The new function can now be used by irqfd to check whether the
> virtual interrupt controller is ready on KVM_IRQFD request. If not,
> KVM_IRQFD returns -EAGAIN
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v5 -> v6:
> - remove kvm_arch_intc_initialized declaration from
>   architecture specific kvm_host.h since it is now in
>   generic kvm_host.h
> - squash v5 patch files 3 & 4
> ---
>  arch/arm/include/asm/kvm_host.h   | 2 ++
>  arch/arm/kvm/arm.c                | 5 +++++
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  virt/kvm/eventfd.c                | 3 +++
>  4 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 254e065..8f87259 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -27,6 +27,8 @@
>  #include <asm/fpstate.h>
>  #include <kvm/arm_arch_timer.h>
>  
> +#define __KVM_HAVE_ARCH_INTC_INITIALIZED
> +
>  #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
>  #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>  #else
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 2d6d910..9c905b4 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -454,6 +454,11 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +bool kvm_arch_intc_initialized(struct kvm *kvm)
> +{
> +	return vgic_initialized(kvm);
> +}
> +
>  static void vcpu_pause(struct kvm_vcpu *vcpu)
>  {
>  	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0b7dfdb..dfb6135 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -28,6 +28,8 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmio.h>
>  
> +#define __KVM_HAVE_ARCH_INTC_INITIALIZED
> +
>  #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
>  #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>  #else
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 148b239..fc5f43e 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -311,6 +311,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	unsigned int events;
>  	int idx;
>  
> +	if (!kvm_arch_intc_initialized(kvm))
> +		return -EAGAIN;
> +

I think this hunk should go in patch 2 instead, split up the generic and
arch-specific parts.

>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
>  	if (!irqfd)
>  		return -ENOMEM;
> -- 
> 1.9.1
> 
Assuming you fix that:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
