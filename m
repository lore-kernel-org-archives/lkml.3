Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEZUBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:01:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36132 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbaEZUBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:01:33 -0400
Date: Mon, 26 May 2014 22:01:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] x86, MCE: Kill CPU_POST_DEAD
Message-ID: <20140526200122.GC26531@pd.tnic>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com>
 <20140522100820.GE4383@pd.tnic>
 <537DE579.6000505@linux.vnet.ibm.com>
 <20140522123251.GU30445@twins.programming.kicks-ass.net>
 <20140522153006.GK4383@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F328133C0@ORSMSX114.amr.corp.intel.com>
 <20140522195538.GM4383@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140522195538.GM4383@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:55:38PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> Date: Thu, 22 May 2014 16:40:54 +0200
> Subject: [PATCH] x86, MCE: Kill CPU_POST_DEAD
> 
> In conjunction with cleaning up CPU hotplug, we want to get rid of
> CPU_POST_DEAD. Kill this instance here and rediscover CMCI banks at the
> end of CPU_DEAD.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 68317c80de7f..bfde4871848f 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2391,6 +2391,10 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
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
> @@ -2402,11 +2406,6 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
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

Ok, so I did a little hammering on this one by running a hotplug toggler
script, reading out files under /sys/devices/system/machinecheck... and
suspending to disk and resuming, all at the same time. 'Round 10ish
cycles I did and the box was chugging away happily without any issues.

So, I'm going to queue this one for 3.17, along with the
panic-on-timeout for the default tolerance level one:

http://lkml.kernel.org/r/20140523091041.GA21332@pd.tnic

if you don't have any objections. I'm saying 3.17 because both are
not really critical stuff and could use a full cycle of simmering in
linux-next just fine.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
