Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3DUWBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:01:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39730 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3DUWBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:01:02 -0400
Date: Sun, 21 Apr 2013 15:00:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421220015.GF3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
 <20130421203447.GE3509@linux.vnet.ibm.com>
 <20130421205139.GC5807@pd.tnic>
 <20130421214241.GA4593@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421214241.GA4593@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042122-7282-0000-0000-00001666500B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 11:42:41PM +0200, Borislav Petkov wrote:
> On Sun, Apr 21, 2013 at 10:51:39PM +0200, Borislav Petkov wrote:
> > A similar oneliner at the end of the resume path.
> >
> > Maybe have rcu suspend/resume callbacks where you can do this stuff
> > and maybe more in the future.
> 
> Ok, here's one - it is pretty straight-forward using that notifier
> abomination :-). It is only in rcutree.c, it could probably be shared
> with rcutiny.c. And it has a section mismatch but I'll fix that too.
> 
> It works though - two suspend/resume cycles looked ok.

Cool!!!  Note that there is no need for expediting TINY_RCU because
its grace periods are already maximally expedited.  There is only one
CPU, so if you are following the rules, when you call synchronize_rcu(),
by definition there is a zero-length grace period.  ;-)

So all you need is rcutree.c.

Looking forward to the section-mismatch-free version!

							Thanx, Paul

> --
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 986d1d3a34f5..cb1f61ede2f9 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -53,6 +53,7 @@
>  #include <linux/delay.h>
>  #include <linux/stop_machine.h>
>  #include <linux/random.h>
> +#include <linux/suspend.h>
> 
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
> @@ -3097,6 +3098,22 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
>  	return NOTIFY_OK;
>  }
> 
> +static int __cpuinit rcu_pm_notify(struct notifier_block *self,
> +				   unsigned long action, void *hcpu)
> +{
> +	switch (action) {
> +	case PM_HIBERNATION_PREPARE:
> +		rcu_expedited = 1;
> +		break;
> +	case PM_POST_RESTORE:
> +		rcu_expedited = 0;
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
>  /*
>   * Spawn the kthread that handles this RCU flavor's grace periods.
>   */
> @@ -3323,6 +3340,7 @@ void __init rcu_init(void)
>  	 * or the scheduler are operational.
>  	 */
>  	cpu_notifier(rcu_cpu_notify, 0);
> +	pm_notifier(rcu_pm_notify, 0);
>  	for_each_online_cpu(cpu)
>  		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
>  }
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

