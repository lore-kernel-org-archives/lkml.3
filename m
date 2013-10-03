Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3JCKHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:07:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:55004 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JCKG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:06:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1025,1371106800"; 
   d="scan'208";a="410878423"
Message-ID: <524D4359.2060801@intel.com>
Date: Thu, 03 Oct 2013 13:13:45 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
References: <20131002132308.GB20396@krava.brq.redhat.com> <524C23D3.6020300@intel.com> <20131003081737.GB993@krava.brq.redhat.com> <524D2E06.5020801@intel.com> <20131003085625.GA3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131003085625.GA3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/13 11:56, Peter Zijlstra wrote:
> On Thu, Oct 03, 2013 at 11:42:46AM +0300, Adrian Hunter wrote:
>> On 03/10/13 11:17, Jiri Olsa wrote:
>>> On Wed, Oct 02, 2013 at 04:46:59PM +0300, Adrian Hunter wrote:
>>>> On 02/10/13 16:23, Jiri Olsa wrote:
>>>>> hi,
>>>>> got a segfault in the tsc test on latest acme's tree.
>>>>>
>>>>> I'm dealing with some other issues right now, so just reporting ;-)
>>>>
>>>> The capability bits have changed positions.  You need to have:
>>>>
>>>> commit fa7315871046b9a4c48627905691dbde57e51033
>>>> Author: Peter Zijlstra <peterz@infradead.org>
>>>> Date:   Thu Sep 19 10:16:42 2013 +0200
>>>>
>>>>     perf: Fix capabilities bitfield compatibility in 'struct
>>>> perf_event_mmap_page'
>>>
>>> ok, I'll try that.. but anyway, the test should
>>> not crash in account of missing kernel change 
>>
>> No the ABI is broken in that case - better to crash.
> 
> No; neither case should crash.
> 
> Anyway; looking at this, why does time_zero have these different checks
> from the other time bits?
> 
> @@ -1897,6 +1898,11 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>         userpg->time_mult = this_cpu_read(cyc2ns);
>         userpg->time_shift = CYC2NS_SCALE_FACTOR;
>         userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
> +
> +       if (sched_clock_stable && !check_tsc_disabled()) {
> +               userpg->cap_usr_time_zero = 1;
> +               userpg->time_zero = this_cpu_read(cyc2ns_offset);
> +       }
>  }
> 
> That doesn't make any kind of sense.. why is cyc2ns_offset differently
> tested from cyc2ns itself?

I am afraid I don't understand the scaling calculations
so I don't know if they make any sense.

cap_usr_time_zero (now cap_user_time_zero) means you can convert
perf time to / from TSC.  That only works if TSC is not disabled
and sched_clock is stable (and you have constant, non-stop TSC)

As far as I can tell, assuming the hardware is not broken,
sched_clock will be stable unless something (BIOS) or someone
(meddling user) has changed TSC manually.

