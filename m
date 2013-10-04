Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3JDSbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:31:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:54101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3JDSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1034,1371106800"; 
   d="scan'208";a="388012752"
Message-ID: <524F097A.9010506@intel.com>
Date: Fri, 04 Oct 2013 21:31:22 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
In-Reply-To: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2013 8:31 p.m., tip-bot for Peter Zijlstra wrote:
> Commit-ID:  d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
> Gitweb:     http://git.kernel.org/tip/d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Thu, 3 Oct 2013 16:00:14 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 4 Oct 2013 09:58:55 +0200
>
> perf/x86: Clean up cap_user_time* setting
>
> Currently the cap_user_time_zero capability has different tests than
> cap_user_time; even though they expose the exact same data.
>
> Switch from CONSTANT && NONSTOP to sched_clock_stable to also deal
> with multi cabinet machines and drop the tsc_disabled() check.. non of
> this will work sanely without tsc anyway.

Unfortunately in the case that TSC is disabled, sched_clock is still
reported as stable, which means removing the tsc_disabled() check breaks
the capability bit. e.g.

$ dmesg | grep -i TSC
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0+ root=UUID=f1b4c71a-15aa-41a6-8898-cdde49966bce ro ignore_loglevel earlyprintk=ttyS0 console=ttyS0,115200n8 no_console_suspend notsc=1 sched_debug=1
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0+ root=UUID=f1b4c71a-15aa-41a6-8898-cdde49966bce ro ignore_loglevel earlyprintk=ttyS0 console=ttyS0,115200n8 no_console_suspend notsc=1 sched_debug=1
[    0.000000] tsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2594.166 MHz processor
[    0.224000] TSC deadline timer enabled
$ cat /proc/sched_debug | grep sched_clock_stable
sched_clock_stable                      : 1

>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>   arch/x86/kernel/cpu/perf_event.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 897783b..9d84491 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1888,10 +1888,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>   	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
>   	userpg->pmc_width = x86_pmu.cntval_bits;
>
> -	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> -		return;
> -
> -	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
> +	if (!sched_clock_stable)
>   		return;
>
>   	userpg->cap_user_time = 1;
> @@ -1899,10 +1896,8 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>   	userpg->time_shift = CYC2NS_SCALE_FACTOR;
>   	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
>
> -	if (sched_clock_stable && !check_tsc_disabled()) {
> -		userpg->cap_user_time_zero = 1;
> -		userpg->time_zero = this_cpu_read(cyc2ns_offset);
> -	}
> +	userpg->cap_user_time_zero = 1;
> +	userpg->time_zero = this_cpu_read(cyc2ns_offset);
>   }
>
>   /*
>

