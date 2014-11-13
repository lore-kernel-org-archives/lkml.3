Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaKMPal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:30:41 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52813 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279AbaKMPak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:30:40 -0500
Message-ID: <5464CE9A.6050209@arm.com>
Date: Thu, 13 Nov 2014 15:30:34 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virt: kvm: arm: vgic: Process the failure case when kvm_register_device_ops()
 fails
References: <5464C865.90504@gmail.com>
In-Reply-To: <5464C865.90504@gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2014 15:30:35.0336 (UTC) FILETIME=[C4EFE480:01CFFF56]
X-MC-Unique: 114111315303702401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 15:04, Chen Gang wrote:
> When kvm_register_device_ops() fails, also need call free_percpu_irq()
> just like others have down within kvm_vgic_hyp_init().
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  virt/kvm/arm/vgic.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 3aaca49..b799f17 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2470,8 +2470,14 @@ int kvm_vgic_hyp_init(void)
>  
>  	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
>  
> -	return kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
> -				       KVM_DEV_TYPE_ARM_VGIC_V2);
> +	ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
> +				      KVM_DEV_TYPE_ARM_VGIC_V2);
> +	if (ret) {
> +		kvm_err("Cannot register device ops\n");
> +		goto out_free_irq;
> +	}
> +
> +	return 0;
>  
>  out_free_irq:
>  	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
> 

Awesome. You're now freeing a per-cpu interrupt after just after having
enabled it on all CPUs. What could possibly go wrong?

	M.
-- 
Jazz is not dead. It just smells funny...

