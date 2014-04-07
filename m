Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaDGGpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 02:45:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33738 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDGGpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 02:45:05 -0400
Message-ID: <53424946.4000504@linux.vnet.ibm.com>
Date: Mon, 07 Apr 2014 12:14:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH] arm, kvm: fix double lock on cpu_add_remove_lock
References: <1396805768-18669-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1396805768-18669-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040706-5564-0000-0000-00000CEEB181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 11:06 PM, Ming Lei wrote:
> The patch of "arm, kvm: Fix CPU hotplug callback registration"
> in -next tree holds the lock before calling the two functions:
> 
> 	kvm_vgic_hyp_init()
> 	kvm_timer_hyp_init()
> 
> and both the two functions are calling register_cpu_notifier()
> to register cpu notifier, so cause double lock on cpu_add_remove_lock.
> 
> Considered that both two functions are only called inside
> kvm_arch_init() with holding cpu_add_remove_lock, so simply use
> __register_cpu_notifier() to fix the problem.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Sorry for missing that, and thank you for the fix!

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  virt/kvm/arm/arch_timer.c |    2 +-
>  virt/kvm/arm/vgic.c       |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 5081e80..22fa819 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -277,7 +277,7 @@ int kvm_timer_hyp_init(void)
> 
>  	host_vtimer_irq = ppi;
> 
> -	err = register_cpu_notifier(&kvm_timer_cpu_nb);
> +	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
>  	if (err) {
>  		kvm_err("Cannot register timer CPU notifier\n");
>  		goto out_free;
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 8ca405c..47b2983 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1496,7 +1496,7 @@ int kvm_vgic_hyp_init(void)
>  		goto out;
>  	}
> 
> -	ret = register_cpu_notifier(&vgic_cpu_nb);
> +	ret = __register_cpu_notifier(&vgic_cpu_nb);
>  	if (ret) {
>  		kvm_err("Cannot register vgic CPU notifier\n");
>  		goto out_free_irq;
> 

