Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3GUBko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 21:40:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49626 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3GUBkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 21:40:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Stephen Warren <swarren@nvidia.com>,
        kexec@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        linux-arm-kernel@lists.infradead.org
References: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
Date: Sat, 20 Jul 2013 18:40:14 -0700
In-Reply-To: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
	(Stephen Warren's message of "Thu, 11 Jul 2013 16:48:51 -0600")
Message-ID: <87ehas7ksh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19xKRsWu4+9zXbHxLZubIZxMF6l6JkRfmg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Warren <swarren@wwwdotorg.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] ARM: kexec: validate CPU hotplug support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> writes:

> From: Stephen Warren <swarren@nvidia.com>
>
> Architectures should fully validate whether kexec is possible as part of
> machine_kexec_prepare(), so that user-space's kexec_load() operation can
> report any problems. Performing validation in machine_kexec() itself is
> too late, since it is not allowed to return.
>
> Prior to this patch, ARM's machine_kexec() was testing after-the-fact
> whether machine_kexec_prepare() was able to disable all but one CPU.
> Instead, modify machine_kexec_prepare() to validate all conditions
> necessary for machine_kexec_prepare()'s to succeed. BUG if the validation
> succeeded, yet disabling the CPUs didn't actually work.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

At a quick skim this looks good to me.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
> Russell, does it make sense for this to be cc: stable as a follow-up to
> 19ab428 "ARM: 7759/1: decouple CPU offlining from reboot/shutdown"?
>
>  arch/arm/include/asm/smp_plat.h |  3 +++
>  arch/arm/kernel/machine_kexec.c | 20 ++++++++++++++++----
>  arch/arm/kernel/smp.c           |  8 ++++++++
>  3 files changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/include/asm/smp_plat.h b/arch/arm/include/asm/smp_plat.h
> index 6462a72..a252c0b 100644
> --- a/arch/arm/include/asm/smp_plat.h
> +++ b/arch/arm/include/asm/smp_plat.h
> @@ -88,4 +88,7 @@ static inline u32 mpidr_hash_size(void)
>  {
>  	return 1 << mpidr_hash.bits;
>  }
> +
> +extern int platform_can_cpu_hotplug(void);
> +
>  #endif
> diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
> index 4fb074c..d7c82df 100644
> --- a/arch/arm/kernel/machine_kexec.c
> +++ b/arch/arm/kernel/machine_kexec.c
> @@ -15,6 +15,7 @@
>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
>  #include <asm/mach-types.h>
> +#include <asm/smp_plat.h>
>  #include <asm/system_misc.h>
>  
>  extern const unsigned char relocate_new_kernel[];
> @@ -39,6 +40,14 @@ int machine_kexec_prepare(struct kimage *image)
>  	int i, err;
>  
>  	/*
> +	 * Validate that if the current HW supports SMP, then the SW supports
> +	 * and implements CPU hotplug for the current HW. If not, we won't be
> +	 * able to kexec reliably, so fail the prepare operation.
> +	 */
> +	if (num_possible_cpus() > 1 && !platform_can_cpu_hotplug())
> +		return -EINVAL;
> +
> +	/*
>  	 * No segment at default ATAGs address. try to locate
>  	 * a dtb using magic.
>  	 */
> @@ -134,10 +143,13 @@ void machine_kexec(struct kimage *image)
>  	unsigned long reboot_code_buffer_phys;
>  	void *reboot_code_buffer;
>  
> -	if (num_online_cpus() > 1) {
> -		pr_err("kexec: error: multiple CPUs still online\n");
> -		return;
> -	}
> +	/*
> +	 * This can only happen if machine_shutdown() failed to disable some
> +	 * CPU, and that can only happen if the checks in
> +	 * machine_kexec_prepare() were not correct. If this fails, we can't
> +	 * reliably kexec anyway, so BUG_ON is appropriate.
> +	 */
> +	BUG_ON(num_online_cpus() > 1);
>  
>  	page_list = image->head & PAGE_MASK;
>  
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index c2b4f8f..5b9e501 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -145,6 +145,14 @@ int boot_secondary(unsigned int cpu, struct task_struct *idle)
>  	return -ENOSYS;
>  }
>  
> +int platform_can_cpu_hotplug(void)
> +{
> +	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU) || !smp_ops.cpu_kill)
> +		return 0;
> +
> +	return 1;
> +}
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  static void percpu_timer_stop(void);
