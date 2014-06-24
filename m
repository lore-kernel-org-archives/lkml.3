Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaF0OXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:23:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36057 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaF0OXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:23:32 -0400
Date: Tue, 24 Jun 2014 09:27:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 2 RAS fixes for 3.17, refreshed
Message-ID: <20140624132701.GB28885@laptop.dumpdata.com>
References: <20140622164603.GA3385@pd.tnic>
 <20140624132439.GH4439@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624132439.GH4439@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 03:24:39PM +0200, Borislav Petkov wrote:
> On Sun, Jun 22, 2014 at 06:46:03PM +0200, Borislav Petkov wrote:
> > Hi guys,
> > 
> > please queue this for 3.17. We had it ready earlier but decided to delay
> > it for an extra testing period.
> 
> Actually, ignore that one. Here's a new pull request adding a fix for an
> issue BorisO reported. All non-critical stuff for 3.17.

Isn't that one a regression that was introduced in 3.16?
Shouldn't it be going against 3.16 then?

Thanks.

> 
> Please pull,
> thanks.
> 
> ---
> The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:
> 
>   Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_3.17
> 
> for you to fetch changes up to 27c934158c5be0bebfb2970da521b9d9efc0058b:
> 
>   x86, MCE: Robustify mcheck_init_device (2014-06-24 15:17:01 +0200)
> 
> ----------------------------------------------------------------
> CPU_POST_DEAD is one of thorns in the path to getting CPU hotplug
> seriously cleaned up. Kill its incarnation here in the MCE code.
> 
> Also, robustify mcheck_init_device() wrt CPU hotplug.
> 
> ----------------------------------------------------------------
> Borislav Petkov (2):
>       x86, MCE: Kill CPU_POST_DEAD
>       x86, MCE: Robustify mcheck_init_device
> 
>  arch/x86/kernel/cpu/mcheck/mce.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index bb92f38153b2..4fc57975acc1 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2385,6 +2385,10 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  			threshold_cpu_callback(action, cpu);
>  		mce_device_remove(cpu);
>  		mce_intel_hcpu_update(cpu);
> +
> +		/* intentionally ignoring frozen here */
> +		if (!(action & CPU_TASKS_FROZEN))
> +			cmci_rediscover();
>  		break;
>  	case CPU_DOWN_PREPARE:
>  		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
> @@ -2396,11 +2400,6 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  	}
>  
> -	if (action == CPU_POST_DEAD) {
> -		/* intentionally ignoring frozen here */
> -		cmci_rediscover();
> -	}
> -
>  	return NOTIFY_OK;
>  }
>  
> @@ -2451,6 +2450,12 @@ static __init int mcheck_init_device(void)
>  	for_each_online_cpu(i) {
>  		err = mce_device_create(i);
>  		if (err) {
> +			/*
> +			 * Register notifier anyway (and do not unreg it) so
> +			 * that we don't leave undeleted timers, see notifier
> +			 * callback above.
> +			 */
> +			__register_hotcpu_notifier(&mce_cpu_notifier);
>  			cpu_notifier_register_done();
>  			goto err_device_create;
>  		}
> @@ -2471,10 +2476,6 @@ static __init int mcheck_init_device(void)
>  err_register:
>  	unregister_syscore_ops(&mce_syscore_ops);
>  
> -	cpu_notifier_register_begin();
> -	__unregister_hotcpu_notifier(&mce_cpu_notifier);
> -	cpu_notifier_register_done();
> -
>  err_device_create:
>  	/*
>  	 * We didn't keep track of which devices were created above, but
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
