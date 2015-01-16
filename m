Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbbAPJfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:35:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59990 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbbAPJfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:35:41 -0500
Message-ID: <54B8DB6B.1030805@arm.com>
Date: Fri, 16 Jan 2015 09:35:39 +0000
From: =?windows-1252?Q?Andr=E9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        christoffer.dall@linaro.org, marc.zyngier@arm.com,
        andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, gleb@kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, cornelia.huck@de.ibm.com
CC: will.deacon@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v7 2/4] KVM: introduce kvm_arch_intc_initialized and use
 it in irqfd
References: <1421333267-15287-1-git-send-email-eric.auger@linaro.org> <1421333267-15287-3-git-send-email-eric.auger@linaro.org>
In-Reply-To: <1421333267-15287-3-git-send-email-eric.auger@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 01/15/2015 02:47 PM, Eric Auger wrote:
> Introduce __KVM_HAVE_ARCH_INTC_INITIALIZED define and
> associated kvm_arch_intc_initialized function. This latter
> allows to test whether the virtual interrupt controller is initialized
> and ready to accept virtual IRQ injection. On some architectures,
> the virtual interrupt controller is dynamically instantiated, justifying
> that kind of check.
> 
> The new function can now be used by irqfd to check whether the
> virtual interrupt controller is ready on KVM_IRQFD request. If not,
> KVM_IRQFD returns -EAGAIN.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> ---
> v6 -> v7:
> - From now on, kvm_irqfd_assign calls kvm_arch_intc_initialized
>   (previously introduced in subsequent patch file).
> - add Christoffer's ack
> 
> v5 -> v6:
> - rename function name and macro
> - add kvm_arch_intc_initialized declaration in case the archi defines
>   the macro
> ---
>  include/linux/kvm_host.h | 14 ++++++++++++++
>  virt/kvm/eventfd.c       |  3 +++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 26f1060..702036a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -706,6 +706,20 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
>  #endif
>  }
>  
> +#ifdef __KVM_HAVE_ARCH_INTC_INITIALIZED
> +/*
> + * returns trues if the virtual interrupt controller is initialized and

Nit:          true

Other than that:
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.


> + * ready to accept virtual IRQ. On some architectures the virtual interrupt
> + * controller is dynamically instantiated and this is not always true.
> + */
> +bool kvm_arch_intc_initialized(struct kvm *kvm);
> +#else
> +static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
> +{
> +	return true;
> +}
> +#endif
> +
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
>  void kvm_arch_destroy_vm(struct kvm *kvm);
>  void kvm_arch_sync_events(struct kvm *kvm);
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
>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
>  	if (!irqfd)
>  		return -ENOMEM;
> 

