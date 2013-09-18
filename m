Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3IRJHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:07:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:65024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab3IRJHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,929,1371106800"; 
   d="scan'208";a="296306896"
Message-ID: <52396EB5.6050104@intel.com>
Date: Wed, 18 Sep 2013 12:13:25 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vince Weaver <vince@deater.net>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct perf_event_mmap_page'
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org> <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
In-Reply-To: <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/13 23:23, Vince Weaver wrote:
> 
> This patch somehow breaks the perf-ABI.
> 
> If I take a program that reads "mmap->cap_usr_rdpmc" and compile it
> against the new header with this change (say from 3.12-rc1)
> and then run it on an old kernel (say 3.11) then I get "0" for
> cap_usr_rdpmc.
> 
> If I take the same program and recompile against the old (without this 
> patch) header and run it on 3.11, I get the expected "1" value.
> 
> So something about this changed the bit pattern in an incompatible 
> fashion.


cap_usr_time and cap_usr_rdpmc were occupying the same bit position i.e. bit 0

That means that cap_usr_time and cap_usr_rdpmc were both unreliable.

If you look at the logic:

void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
{
    userpg->cap_usr_time = 0;
    userpg->cap_usr_time_zero = 0;
    userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
    userpg->pmc_width = x86_pmu.cntval_bits;

    if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
        return;

    if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
        return;

    userpg->cap_usr_time = 1;
    userpg->time_mult = this_cpu_read(cyc2ns);
    userpg->time_shift = CYC2NS_SCALE_FACTOR;
    userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;

    if (sched_clock_stable && !check_tsc_disabled()) {
        userpg->cap_usr_time_zero = 1;
        userpg->time_zero = this_cpu_read(cyc2ns_offset);
    }
}

The incorrect union caused 2 bugs:

1. On hardware with constant, non-stop TSC cap_usr_rdpmc was always 1.

2. On hardware without constant, non-stop TSC cap_usr_time was still 1 if
rdpmc was allowed in userspace.


Possible improvements are one or both of:
1. Add cap_usr_fixed to identify kernels that have the capabilities bits fixed
2. Swap the positions of cap_usr_time and cap_usr_rdpmc so that
cap_usr_rdpmc remains in bit 0






> 
> Vince
> 
> 
> 
> 
> On Tue, 23 Jul 2013, tip-bot for Adrian Hunter wrote:
> 
>> Commit-ID:  860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
>> Gitweb:     http://git.kernel.org/tip/860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
>> Author:     Adrian Hunter <adrian.hunter@intel.com>
>> AuthorDate: Fri, 28 Jun 2013 16:22:17 +0300
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Tue, 23 Jul 2013 12:17:10 +0200
>>
>> perf: Fix broken union in 'struct perf_event_mmap_page'
>>
>> The capabilities bits must not be "union'ed" together.
>> Put them in a separate struct.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Link: http://lkml.kernel.org/r/1372425741-1676-2-git-send-email-adrian.hunter@intel.com
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> ---
>>  include/uapi/linux/perf_event.h | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index 00d8274..0041aed 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -375,9 +375,11 @@ struct perf_event_mmap_page {
>>  	__u64	time_running;		/* time event on cpu */
>>  	union {
>>  		__u64	capabilities;
>> -		__u64	cap_usr_time  : 1,
>> -			cap_usr_rdpmc : 1,
>> -			cap_____res   : 62;
>> +		struct {
>> +			__u64	cap_usr_time		: 1,
>> +				cap_usr_rdpmc		: 1,
>> +				cap_____res		: 62;
>> +		};
>>  	};
>>  
>>  	/*
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> k
> 
> 

