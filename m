Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3IQH5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:57:19 -0400
Received: from goliath.siemens.de ([192.35.17.28]:26801 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3IQH5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:57:16 -0400
Message-ID: <52380B55.5010408@siemens.com>
Date: Tue, 17 Sep 2013 09:57:09 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH 1/3] KVM: cleanup (physical) CPU hotplug
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <1379340373-5135-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1379340373-5135-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-09-16 16:06, Paolo Bonzini wrote:
> Remove the useless argument, and do not do anything if there are no
> VMs running at the time of the hotplug.

kvm_cpu_hotplug already filters !kvm_usage_count. If we need the check
to be under kvm_lock, drop that line as well. If that is not required
(machine still halted?), drop the related changes here.

Jan

> 
> Cc: stable@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: gleb@redhat.com
> Cc: jan.kiszka@siemens.com
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 979bff4..75522b3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2681,10 +2681,11 @@ static void hardware_enable_nolock(void *junk)
>  	}
>  }
>  
> -static void hardware_enable(void *junk)
> +static void hardware_enable(void)
>  {
>  	raw_spin_lock(&kvm_lock);
> -	hardware_enable_nolock(junk);
> +	if (kvm_usage_count)
> +		hardware_enable_nolock(NULL);
>  	raw_spin_unlock(&kvm_lock);
>  }
>  
> @@ -2698,10 +2699,11 @@ static void hardware_disable_nolock(void *junk)
>  	kvm_arch_hardware_disable(NULL);
>  }
>  
> -static void hardware_disable(void *junk)
> +static void hardware_disable(void)
>  {
>  	raw_spin_lock(&kvm_lock);
> -	hardware_disable_nolock(junk);
> +	if (kvm_usage_count)
> +		hardware_disable_nolock(NULL);
>  	raw_spin_unlock(&kvm_lock);
>  }
>  
> @@ -2756,12 +2758,12 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
>  	case CPU_DYING:
>  		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
>  		       cpu);
> -		hardware_disable(NULL);
> +		hardware_disable();
>  		break;
>  	case CPU_STARTING:
>  		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
>  		       cpu);
> -		hardware_enable(NULL);
> +		hardware_enable();
>  		break;
>  	}
>  	return NOTIFY_OK;
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
