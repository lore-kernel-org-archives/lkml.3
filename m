Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaEVVOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:14:48 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59598 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaEVVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:14:47 -0400
Message-ID: <537E687B.9080300@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 02:43:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] x86, MCE: Kill CPU_POST_DEAD
References: <1400750624-19238-1-git-send-email-bp@alien8.de> <537DC6D2.8040305@linux.vnet.ibm.com> <20140522100820.GE4383@pd.tnic> <537DE579.6000505@linux.vnet.ibm.com> <20140522123251.GU30445@twins.programming.kicks-ass.net> <20140522153006.GK4383@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F328133C0@ORSMSX114.amr.corp.intel.com> <20140522195538.GM4383@pd.tnic>
In-Reply-To: <20140522195538.GM4383@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052221-1396-0000-0000-000004E56BA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 01:25 AM, Borislav Petkov wrote:
> On Thu, May 22, 2014 at 03:50:21PM +0000, Luck, Tony wrote:
>>>> So I think we can reduce it to just the one rwsem (with recursion) if we
>>>> shoot CPU_POST_DEAD in the head.
>>>
>>> Here's the first bullet. Stressing my box here with Steve's hotplug
>>> script seems to work fine.
>>>
>>> Tony, any objections?
>>
>> what was this comment referring to:
>>
>>     /* intentionally ignoring frozen here */
>>
>> After you move the cmci_rediscover() call, it is now in a place where we are
>> no longer ignoring frozen (i.e. the old placement did the rediscover even if the
>> CPU_TASKS_FROZEN bit was set - with the new placement we will skip rediscovery.
>>

That's not quite true. The existing code already ignores FROZEN for all the cases,
by ignoring it at the top of the switch-case itself:

        switch (action & ~CPU_TASKS_FROZEN) {
        case CPU_ONLINE:
		[...]
		break;
        case CPU_DEAD:
                if (threshold_cpu_callback)
                        threshold_cpu_callback(action, cpu);
                mce_device_remove(cpu);
                mce_intel_hcpu_update(cpu);
                break;

Then I started wondering what the comment really meant, and commit 1a65f970d1
made things clear: its actually the _other_ way around! That is, cmci_rediscover()
didn't have to be invoked* during suspend/resume, so it was kept separate from
the rest.

* or maybe it was not _supposed_ to be invoked; I don't know which is the case..
the original commit 88ccbedd9 didn't explain that.

Either way, cmci_rediscover() doesn't seem to have any reason why it should
be called specifically in the POST_DEAD stage only. So I'm sure we can get rid
of that one way or other easily.

Regards,
Srivatsa S. Bhat

>> So we were working around some interaction between cpu hotplug and frozen.
>> Do we no longer need to do that?
> 
> Hmm, that FROZEN thing is supposedly for hotplug operations while
> suspend is happening. I guess it makes a little sense to rediscover CMCI
> banks while suspend is in progress. Whatever.
> 
> Let's keep it before more crap ensues, that was a good catch, thanks.
> 
> So, I guess something like that instead.
> 
> Which means, I'd need to run a couple of suspend/resume rounds while
> hotplugging cores to see whether we're still kosher.
> 
> More fun tomorrow.
> 
> ---
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
> 

