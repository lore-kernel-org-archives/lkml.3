Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaEIO46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:56:58 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:58548 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbaEIO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:56:56 -0400
Message-ID: <536CECB4.1090109@semaphore.gr>
Date: Fri, 09 May 2014 17:56:52 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Smythies <dsmythies@telus.net>
Subject: Re: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of
 next pstate
References: <5368255D.3090207@semaphore.gr> <536BEE89.3040602@gmail.com>
In-Reply-To: <536BEE89.3040602@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

On 08/05/2014 11:52 μμ, Dirk Brandewie wrote:
> On 05/05/2014 04:57 PM, Stratos Karafotis wrote:
>> Currently the driver calculates the next pstate proportional to
>> core_busy factor, scaled by the ratio max_pstate / current_pstate.
>>
>> Using the scaled load (core_busy) to calculate the next pstate
>> is not always correct, because there are cases that the load is
>> independent from current pstate. For example, a tight 'for' loop
>> through many sampling intervals will cause a load of 100% in
>> every pstate.
>>
>> So, change the above method and calculate the next pstate with
>> the assumption that the next pstate should not depend on the
>> current pstate. The next pstate should only be proportional
>> to measured load. Use the linear function to calculate the load:
>>
>> Next P-state = A + B * load
>>
>> where A = min_state and B = (max_pstate - min_pstate) / 100
>> If turbo is enabled the B = (turbo_pstate - min_pstate) / 100
>> The load is calculated using the kernel time functions.
>>

Thank you very much for your comments and for your time to test my patch!


> 
> This will hurt your power numbers under "normal" conditions where you
> are not running a performance workload. Consider the following:
> 
>    1. The system is idle, all core at min P state and utilization is low say < 10%
>    2. You run something that drives the load as seen by the kernel to 100%
>       which scaled by the current P state.
> 
> This would cause the P state to go from min -> max in one step.  Which is
> what you want if you are only looking at a single core.  But this will also
> drag every core in the package to the max P state as well.  This would be fine

I think, this will also happen using the original driver (before your
new patch 4/5), after some sampling intervals.


> if the power vs frequency cure was linear all the cores would finish
> their work faster and go idle sooner (race to halt) and maybe spend
> more time in a deeper C state which dwarfs the amount of power we can
> save by controlling P states. Unfortunately this is *not* the case, 
> power vs frequency curve is non-linear and get very steep in the turbo
> range.  If it were linear there would be no reason to have P state
> control you could select the highest P state and walk away.
> 
> Being conservative on the way up and aggressive on way down give you
> the best power efficiency on non-benchmark loads.  Most benchmarks
> are pretty useless for measuring power efficiency (unless they were
> designed for it) since they are measuring how fast something can be
> done which is measuring the efficiency at max performance.
> 
> The performance issues you pointed out were caused by commit 
> fcb6a15c intel_pstate: Take core C0 time into account for core busy calculation
> and the ensuing problem is caused. These have been fixed in the patch set
> 
>    https://lkml.org/lkml/2014/5/8/574
> 
> The performance comparison between before/after this patch set, your patch
> and ondemand/acpi_cpufreq is available at:
>     http://openbenchmarking.org/result/1405085-PL-C0200965993
> ffmpeg was added to the set of benchmarks because there was a regression
> reported against this benchmark as well.
>     https://bugzilla.kernel.org/show_bug.cgi?id=75121

Of course, I agree generally with your comments above. But I believe that
the we should scale the core as soon as we measure high load. 

I tested your new patches and I confirm your benchmarks. But I think
they are against the above theory (at least on low loads).
With the new patches I get increased frequencies even on an idle system.
Please compare the results below.

With your latest patches during a mp3 decoding (a non-benchmark load)
the energy consumption increased to 5187.52 J from 5036.57 J (almost 3%).


Thanks again,
Stratos



With my patch
-------------
[root@albert ~]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat -i 60
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.06    1645    3392       0    0.26    0.00   99.67    0.00      32      32    0.00    0.00    0.00    0.00   20.18    2.00    0.02
       0       0       2    0.10    1623    3392       0    0.63    0.01   99.26    0.00      32      32    0.00    0.00    0.00    0.00   20.18    2.00    0.02
       0       4       0    0.01    1618    3392       0    0.72
       1       1       1    0.03    1618    3392       0    0.03    0.00   99.94    0.00      27
       1       5       0    0.01    1606    3392       0    0.05
       2       2       0    0.02    1635    3392       0    0.28    0.00   99.70    0.00      22
       2       6       3    0.17    1668    3392       0    0.13
       3       3       2    0.12    1647    3392       0    0.08    0.00   99.80    0.00      30
       3       7       0    0.02    1623    3392       0    0.18


With your latest patch
----------------------
[root@albert ~]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat -i 60
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.05    2035    3392       0    0.28    0.01   99.66    0.00      34      34    0.00    0.00    0.00    0.00   20.20    2.01    0.02
       0       0       1    0.04    1831    3392       0    0.06    0.00   99.90    0.00      34      34    0.00    0.00    0.00    0.00   20.20    2.01    0.02
       0       4       0    0.01    2136    3392       0    0.09
       1       1       1    0.06    1931    3392       0    0.70    0.00   99.24    0.00      31
       1       5       0    0.01    2024    3392       0    0.75
       2       2       1    0.03    2231    3392       0    0.21    0.03   99.73    0.00      26
       2       6       2    0.09    1967    3392       0    0.15
       3       3       3    0.15    2115    3392       0    0.06    0.00   99.78    0.00      34
       3       7       0    0.02    2073    3392       0    0.19



With my patch:
--------------
[root@albert ~]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat mpg321 /home/stratosk/One\ Direction\ -\ Story\ of\ My\ Life.mp3
[4:05] Decoding of One Direction - Story of My Life.mp3 finished.
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       7    0.45    1613    3392       0   14.55    0.02   84.97    0.00      35      35    0.00    0.00    0.00    0.00   20.51    2.33    0.01
       0       0      16    1.01    1623    3392       0    1.06    0.04   97.89    0.00      35      35    0.00    0.00    0.00    0.00   20.51    2.33    0.01
       0       4       0    0.02    1616    3392       0    2.05
       1       1       3    0.16    1609    3392       0    1.61    0.00   98.22    0.00      30
       1       5      13    0.80    1606    3392       0    0.97
       2       2       8    0.52    1606    3392       0   38.97    0.03   60.48    0.00      26
       2       6      10    0.65    1613    3392       0   38.84
       3       3       7    0.42    1613    3392       0   16.28    0.01   83.29    0.00      33
       3       7       1    0.05    1624    3392       0   16.65
245.566284 sec


With your patch:
----------------
[root@albert ~]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat mpg321 /home/stratosk/One\ Direction\ -\ Story\ of\ My\ Life.mp3
[4:05] Decoding of One Direction - Story of My Life.mp3 finished.
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       7    0.27    2773    3392       0   40.05    0.01   59.67    0.00      35      35    0.00    0.00    0.00    0.00   21.11    2.93    0.01
       0       0       9    0.31    2773    3392       0   82.55    0.01   17.12    0.00      35      35    0.00    0.00    0.00    0.00   21.11    2.93    0.01
       0       4       5    0.15    3290    3392       0   82.71
       1       1       8    0.31    2541    3392       0   26.87    0.00   72.82    0.00      30
       1       5      19    0.79    2400    3392       0   26.38
       2       2       8    0.23    3490    3392       0   15.43    0.00   84.34    0.00      27
       2       6       1    0.04    2086    3392       0   15.62
       3       3       4    0.13    2978    3392       0   35.44    0.00   64.42    0.00      31
       3       7       6    0.16    3553    3392       0   35.42
245.642873 sec


With original code
-----------------
[root@albert ~]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat mpg321 /home/stratosk/One\ Direction\ -\ Story\ of\ My\ Life.mp3
[4:05] Decoding of One Direction - Story of My Life.mp3 finished.
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       5    0.32    1608    3392       0   20.43    0.01   79.24    0.00      35      35    0.00    0.00    0.00    0.00   20.59    2.41    0.01
       0       0       2    0.11    1621    3392       0   20.90    0.01   78.98    0.00      35      35    0.00    0.00    0.00    0.00   20.59    2.41    0.01
       0       4       6    0.38    1600    3392       0   20.63
       1       1       8    0.50    1603    3392       0   24.10    0.00   75.40    0.00      29
       1       5       0    0.02    1611    3392       0   24.58
       2       2      13    0.81    1598    3392       0    0.45    0.02   98.73    0.00      29
       2       6       1    0.04    1675    3392       0    1.21
       3       3       9    0.59    1603    3392       0   35.54    0.01   63.86    0.00      33
       3       7       1    0.08    1749    3392       0   36.05
245.641863 sec
