Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3JCLme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:42:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:11791 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3JCLmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:42:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1025,1371106800"; 
   d="scan'208";a="404737160"
Message-ID: <524D59B5.4040004@intel.com>
Date: Thu, 03 Oct 2013 14:49:09 +0300
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
References: <20131002132308.GB20396@krava.brq.redhat.com> <524C23D3.6020300@intel.com> <20131003081737.GB993@krava.brq.redhat.com> <524D2E06.5020801@intel.com> <20131003085625.GA3081@twins.programming.kicks-ass.net> <524D4359.2060801@intel.com> <20131003110224.GD3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131003110224.GD3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/13 14:02, Peter Zijlstra wrote:
> On Thu, Oct 03, 2013 at 01:13:45PM +0300, Adrian Hunter wrote:
>>> Anyway; looking at this, why does time_zero have these different checks
>>> from the other time bits?
>>>
>>> @@ -1897,6 +1898,11 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>>>         userpg->time_mult = this_cpu_read(cyc2ns);
>>>         userpg->time_shift = CYC2NS_SCALE_FACTOR;
>>>         userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
>>> +
>>> +       if (sched_clock_stable && !check_tsc_disabled()) {
>>> +               userpg->cap_usr_time_zero = 1;
>>> +               userpg->time_zero = this_cpu_read(cyc2ns_offset);
>>> +       }
>>>  }
>>>
>>> That doesn't make any kind of sense.. why is cyc2ns_offset differently
>>> tested from cyc2ns itself?
>>
>> I am afraid I don't understand the scaling calculations
>> so I don't know if they make any sense.
>>
>> cap_usr_time_zero (now cap_user_time_zero) means you can convert
>> perf time to / from TSC.  That only works if TSC is not disabled
>> and sched_clock is stable (and you have constant, non-stop TSC)
>>
>> As far as I can tell, assuming the hardware is not broken,
>> sched_clock will be stable unless something (BIOS) or someone
>> (meddling user) has changed TSC manually.
> 
> Well all the scaling mess only applies to TSC.. furthermore note how
> time_offset even uses cyc2ns_offset.
> 
> So I don't see any point in cap_user_time and cap_user_time_zero having
> different conditions.
> 
> Also, I don't think that a cpu without cap_tsc will ever run perf code
> so I don't see the point of testing tsc_disabled; if someone is mad
> enough to boot with that he can bloody well keep the pieces.

You can boot with notsc and perf still seems to work
e.g.

$ dmesg | grep -i tsc
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0+ root=UUID=f1b4c71a-15aa-41a6-8898-cdde49966bce ro ignore_loglevel earlyprintk=ttyS0 console=ttyS0,115200n8 no_console_suspend notsc=1
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0+ root=UUID=f1b4c71a-15aa-41a6-8898-cdde49966bce ro ignore_loglevel earlyprintk=ttyS0 console=ttyS0,115200n8 no_console_suspend notsc=1
[    0.000000] tsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2593.932 MHz processor
[    0.224000] TSC deadline timer enabled


$ tools/perf/perf record -e instructions:u uname
Linux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.032 MB perf.data (~1414 samples) ]

$ tools/perf/perf script
# ========
# captured on: Thu Oct  3 17:31:38 2013
# hostname : ivb01
# os release : 3.11.0+
# perf version : 3.11.rc4.gde8db8
# arch : x86_64
# nrcpus online : 8
# nrcpus avail : 8
# cpudesc : Intel(R) Core(TM) i7-3720QM CPU @ 2.60GHz
# cpuid : GenuineIntel,6,58,9
# total memory : 8074624 kB
# cmdline : /home/ahunter/git/linux-perf/tools/perf/perf record -e instructions:u uname 
# event : name = instructions:u, type = 0, config = 0x1, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 1, excl_host = 0, e
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_cbox_0 = 6, uncore_cbox_1 = 7, uncore_cbox_2 = 8, uncore_cbox_3 = 9, b
# ========
#
           uname  3914   451.484000: instructions:u:      7fe3f3315af3 [unknown] (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:  ffffffff813a1ad0 page_fault ([kernel.kallsyms])
           uname  3914   451.484000: instructions:u:      7fe3f3316136 _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:  ffffffff813a1ad0 page_fault ([kernel.kallsyms])
           uname  3914   451.484000: instructions:u:  ffffffff813a1ad0 page_fault ([kernel.kallsyms])
           uname  3914   451.484000: instructions:u:  ffffffff813a1ad0 page_fault ([kernel.kallsyms])
           uname  3914   451.484000: instructions:u:      7fe3f33161b4 _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f33161af _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f33161af _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f33161af _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f33161bd _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f3316388 _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f3316590 _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)
           uname  3914   451.484000: instructions:u:      7fe3f33165a0 _dl_start (/lib/x86_64-linux-gnu/ld-2.13.so)



> 
> Arguably the CONSTANT && NONSTOP test was to test the same thing as
> sched_clock_stable, but I suppose we can use that.
> 
> Which reminds me; I should go and fix the transition for
> sched_clock_stable: 1->0.
> 
> ---
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 897783b3302a..9db2b361a63d 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1888,21 +1888,16 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
>  	userpg->pmc_width = x86_pmu.cntval_bits;
>  
> -	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> -		return;
> -
> -	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
> -		return;
> +	if (!sched_clock_stable)
> +		return
>  
>  	userpg->cap_user_time = 1;
>  	userpg->time_mult = this_cpu_read(cyc2ns);
>  	userpg->time_shift = CYC2NS_SCALE_FACTOR;
>  	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
>  
> -	if (sched_clock_stable && !check_tsc_disabled()) {
> -		userpg->cap_user_time_zero = 1;
> -		userpg->time_zero = this_cpu_read(cyc2ns_offset);
> -	}
> +	userpg->cap_user_time_zero = 1;
> +	userpg->time_zero = this_cpu_read(cyc2ns_offset);
>  }
>  
>  /*
> 
> 

