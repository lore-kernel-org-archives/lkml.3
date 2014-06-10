Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaFJLwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:52:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37016 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaFJLwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:52:04 -0400
Message-ID: <5396F166.1030401@arm.com>
Date: Tue, 10 Jun 2014 12:52:06 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yuyang Du <yuyang.du@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 07/16 v3] Init Workload Consolidation flags in sched_domain
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com> <1401431772-14320-8-git-send-email-yuyang.du@intel.com> <20140603121416.GH30445@twins.programming.kicks-ass.net> <5395F541.60604@arm.com> <20140609211820.GA5361@intel.com>
In-Reply-To: <20140609211820.GA5361@intel.com>
X-OriginalArrivalTime: 10 Jun 2014 11:51:56.0548 (UTC) FILETIME=[6116B440:01CF84A2]
X-MC-Unique: 114061012520102901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 22:18, Yuyang Du wrote:
> On Mon, Jun 09, 2014 at 06:56:17PM +0100, Dietmar Eggemann wrote:
> 
> Thanks, Dietmar.
> 
>> I'm running these patches on my ARM TC2 on top of
>> kernel/git/torvalds/linux.git (v3.15-rc7-79-gfe45736f4134). There're
>> considerable changes in the area of sched domain setup since Vincent's
>> patchset 'rework sched_domain topology description' (destined for v3.16)
>> which you can find on kernel/git/tip/tip.git .
>>
> 
> Yeah, PeterZ pointed it out. It was on top of mainline not tip.
> 
>> Why did you make SD_WORKLOAD_CONSOLIDATION controllable via sysctl? All
>> the other SD flags are set during setup.
>>
> 
> I don't understand. Any flag or parameter in sched_domain can be modified
> on-the-fly after booting via sysctl. The SD_XXX_INIT is a template to make
> the sched_domain initialization easier, IIUC.

Technically true but since the sysctrl stuff is per-cpu and you want to
change per-domain data, you have to be extremely careful that each cpu
still sees the same data.

Another counter example, if I delete the SD_SHARE_PKG_RESOURCES flag on
my ARM TC2 system for all CPU's on domain0 (MC level) via sysctl, the
scheduler still has sd_llc assigned to the struct sched_domain for the
MC level of the CPU.

> 
> Yes, I should not unconditionally enable SD_WORKLOAD_CONSOLIDATION in MC
> and CPU domain (pointed out by PeterZ), but I did so for the purpose of
> testing this patchset at this moment. Eventually, this flag should not be
> turned on for any domain by default for many reasons, not to mention CPU
> topology is getting more diverse/complex.

But isn't this the point to show how and under which conditions you
would set this flag in the existing code? Since I guess it's a scheduler
behavioural (not a topology related one) flag, it has to be integrated
nicely into sd_init() etc.

> 
> I just checked Vincent's "rework sched_domain topology description". The
> general picture for init sched_domain does not change. If you work on top
> of tip tree, you can simply skip this patch (0007), and after booting
> enable SD_WORKLOAD_CONSOLIDATION by:
> 
> sysctl -w kernel.sched_domain.cpuX.domainY.flags += 0x8000
> sysctl -w kernel.sched_domain.cpu0.domain1.consolidating_coeff=180
> sysctl -w kernel.sched_cc_wakeup_threshold=80
> 
>> Your top_flag_domain() function
>> takes care of figuring out what is the highest sd level this is set on
>> during load-balance but I can't find any good reason to do it this way
>> other then for testing purposes?
> 
> Any flag is used for testing whether it is set on or not when encountering
> it, including the flags in sched_domain for load balancing, this is why flag
> is called flag. My flag is any excpetion?

Not in this sense but there is no functionality in the scheduler right
now to check constantly if an sd flag has been set/unset via sysctl.
IMHO, there's only sd_init and (highest/lowest)_flag_domain to cache
pointers to special sd's and both are called during start-up or cpu
hotplug
((init/partition_sched_domains()->build_sched_domains()->{build_sched_domain()->sd_init(),
cpu_attach_domain()-> update_top_cache_domain())}

-- Dietmar

> 
> Thanks,
> Yuyang
> 


