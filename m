Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3AWHKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:10:31 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60924 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3AWHKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:10:30 -0500
Message-ID: <50FF8CD8.4060105@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 15:10:16 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net> <50FF7086.4020509@linux.vnet.ibm.com> <1358922520.5752.91.camel@marge.simpson.net>
In-Reply-To: <1358922520.5752.91.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012307-2674-0000-0000-0000079296E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 02:28 PM, Mike Galbraith wrote:
> On Wed, 2013-01-23 at 13:09 +0800, Michael Wang wrote: 
>> On 01/23/2013 12:31 PM, Mike Galbraith wrote:
> 
>>> Another thing that wants fixing: root can set flags for _existing_
>>> domains any way he likes,
>>
>> Can he? on running time changing the domain flags? I do remember I used to
>> send out some patch to achieve that but was refused since it's dangerous...
> 
> Yes, flags can be set any way you like, which works just fine when flags
> are evaluated at runtime.
> 
> WRT dangerous: if root says "Let there be stupidity", stupidity should
> appear immediately :)
> 
>> but when he invokes godly powers to rebuild
>>> domains, he gets what's hard coded, which is neither clever (godly
>>> wrath;), nor wonderful for godly runtime path decisions.
>>
>> The purpose is to using a map to describe the sd topology of a cpu, it
>> should be rebuild correctly according to the new topology when attaching
>> new domain to a cpu.
> 
> Try turning FORK/EXEC/WAKE on/off.
> 
> echo [01] > [cpuset]/sched_load_balance will rebuild, but resulting
> domains won't reflect flag your change. 

Yeah, I've done some test on it previously, but I failed to enter the
rebuild procedure, need more research on it.

> 
>> For this case, it's really strange that level 2 was missed in topology,
>> I found that in build_sched_domains(), the level was added one by one,
>> and I don't know why it jumps here...sounds like some BUG to me.
>>
>> Whatever, the sbm should still work properly by designed, even in such
>> strange topology, if it's initialized correctly.
>>
>> And below patch will do help on it, just based on the original patch set.
>>
>> Could you please take a try on it, it's supposed to make the balance path
>> correctly, and please apply below DEBUG patch too, so we could know how it
>> changes, I think this time, we may be able to solve the issue by the right
>> way ;-)
> 
> Done, previous changes backed out, new change applied on top of v2 set.
> Full debug output attached.
> 
> Domain flags on this box (bogus CPU domain is still patched away).
> 
> monteverdi:/abuild/mike/aim7/:[127]# tune-sched-domains
> usage: tune-sched-domains <val>
> {cpu0/domain0:SIBLING} SD flag: 687
> +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
> +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
> +   4: SD_BALANCE_EXEC:          Balance on exec
> +   8: SD_BALANCE_FORK:          Balance on fork, clone
> -  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
> +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
> -  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
> + 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
> - 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
> + 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
> -1024: SD_SERIALIZE:             Only a single load balancing instance
> -2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
> -4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
> -8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice
> {cpu0/domain1:MC} SD flag: 559
> +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
> +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
> +   4: SD_BALANCE_EXEC:          Balance on exec
> +   8: SD_BALANCE_FORK:          Balance on fork, clone
> -  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
> +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
> -  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
> - 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
> - 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
> + 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
> -1024: SD_SERIALIZE:             Only a single load balancing instance
> -2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
> -4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
> -8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice
> {cpu0/domain2:NUMA} SD flag: 9263
> +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
> +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
> +   4: SD_BALANCE_EXEC:          Balance on exec
> +   8: SD_BALANCE_FORK:          Balance on fork, clone
> -  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
> +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
> -  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
> - 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
> - 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
> - 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
> +1024: SD_SERIALIZE:             Only a single load balancing instance
> -2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
> -4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
> +8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice

I will study this BUG candidate later.

> 
> Abbreviated test run:
> Tasks    jobs/min  jti  jobs/min/task      real       cpu
>   640   158044.01   81       246.9438     24.54    577.66   Wed Jan 23 07:14:33 2013
>  1280    50434.33   39        39.4018    153.80   5737.57   Wed Jan 23 07:17:07 2013
>  2560    47214.07   34        18.4430    328.58  12715.56   Wed Jan 23 07:22:36 2013

So still not works... and not going to balance path while waking up will
fix it, looks like that's the only choice if no error on balance path
could be found...benchmark wins again, I'm feeling bad...

I will conclude the info we collected and make a v3 later.

Regards,
Michael Wang

> 

