Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaE3SpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:45:23 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39171 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaE3SpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:45:22 -0400
Message-ID: <5388D1BF.6090503@gmail.com>
Date: Fri, 30 May 2014 11:45:19 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>, Dave Jones <davej@redhat.com>
CC: dirk.brandewie@gmail.com, George Spelvin <linux@horizon.com>,
        herbert@gondor.apana.org.au, james.guilford@intel.com,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
References: <20140529235432.19207.qmail@ns.horizon.com>	 <1401412036.2970.459.camel@schen9-DESK> <20140530011636.GA31694@redhat.com> <1401472592.2970.483.camel@schen9-DESK>
In-Reply-To: <1401472592.2970.483.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 10:56 AM, Tim Chen wrote:
> On Thu, 2014-05-29 at 21:16 -0400, Dave Jones wrote:
>> On Thu, May 29, 2014 at 06:07:16PM -0700, Tim Chen wrote:
>>   > On Thu, 2014-05-29 at 19:54 -0400, George Spelvin wrote:
>>   > > Sorry for the delay; my Ivy Bridge test machine isn't in my
>>   > > office and getting to the console to tweak the BIOS is a
>>   > > bit of a bother.
>>   > >
>>   > > Anyway, i7-4930K, turbo boost & hyperthreading disabled,
>>   > > $ cat /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor
>>   > > performance
>>   > > performance
>>   > > performance
>>   > > performance
>>   > > performance
>>   > > performance
>>   > >
>>   > > Oddly, though, CPU speed still seems to be fluctuating:
>>   > > $ grep MHz /proc/cpuinfo
>>   > > cpu MHz         : 1255.875
>>   > > cpu MHz         : 3168.375
>>   > > cpu MHz         : 3062.125
>>   > > cpu MHz         : 1468.375
>>   > > cpu MHz         : 1309.000
>>   > > cpu MHz         : 2212.125
>>   > > $ grep MHz /proc/cpuinfo
>>   > > cpu MHz         : 1255.875
>>   > > cpu MHz         : 2690.250
>>   > > cpu MHz         : 1255.875
>>   > > cpu MHz         : 2530.875
>>   > > cpu MHz         : 2212.125
>>   > > cpu MHz         : 1521.500
>>   >
>>   > This is odd.  On my Ivy Bridge system the CPU speed from /proc/cpuinfo
>>   > is at max freq once I set the performance governor.
>>   > The numbers above almost look like
>>   > the cpu frequency is fluctuating and an average is taken.
>>   > What version of the kernel are you running?  Is
>>   > CONFIG_CPU_FREQ_GOV_PERFORMANCE compiled in?
>>   >
>>   > Does /sys/devices/system/cpu/cpu?/cpufreq/scaling_cur_freq
>>   > also changes?
>>   >
>>   > Can you check what are the available governors in your system
>>   > and available frequencies?
>>   >
>>   > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
>>   > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
>>   >
>>   > If userspace governor is available, you can try set the governor
>>   > to userspace, then pin frequency to 3400 MHz (assuming that's your
>>   > max) with command like:
>>   
>> intel_pstate overrides any governor choice you make through sysfs.
>>
>> 	Dave
>>
> 
> Dirk,
> 
> Wonder if this the right behavior for intel_pstate that when I set the
> governor to performance, intel_pstate driver still adjusts
> the cpu frequencies around?

No, the value returned is a measured/delivered frequency instead of the P state
requested which is what the other governors return.

> 
> Turbotstat also confirms that the frequencies are not at max,
> even though the max_perf_pct and min_perf_pct are both set at 100.
> 

I calculate frequency the same way turbostat does but my samples are a *lot* 
shorter.
 

> I ran on my HSW system with 3.15-rc7 kernel and see similar
> issue that Geroge reported.
> 
> It is really a pain when we need to do performance benchmarking and
> need to have a constant cpu frequency.
> 

With turbostat from rc7.
[root@echolake turbostat]# ./turbostat 
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.08    1178    3492       0    0.12    0.08    0.01   99.71      29      29   99.23    0.00    0.00    0.00    2.18    0.00    0.00
       0       0       2    0.19    1189    3492       0    0.22    0.30    0.00   99.29      29      29   99.24    0.00    0.00    0.00    2.18    0.00    0.00
       0       4       1    0.12    1253    3492       0    0.29
       1       1       0    0.03    1065    3492       0    0.03    0.00    0.00   99.93      23
       1       5       0    0.01    1104    3492       0    0.05
       2       2       0    0.02    1275    3492       0    0.22    0.00    0.03   99.73      24
       2       6       2    0.18    1220    3492       0    0.06
       3       3       0    0.01     992    3492       0    0.07    0.00    0.01   99.90      23
       3       7       0    0.05     915    3492       0    0.04
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.06    1034    3492       0    0.09    5.15    0.00   94.70      28      28   99.49    0.00    0.00    0.00    2.48    0.01    0.00
       0       0       1    0.09    1066    3492       0    0.17    0.01    0.00   99.73      28      28   99.49    0.00    0.00    0.00    2.48    0.01    0.00
       0       4       1    0.12    1036    3492       0    0.14
       1       1       0    0.04    1009    3492       0    0.05   20.59    0.00   79.32      24
       1       5       0    0.02     922    3492       0    0.07
       2       2       0    0.03     924    3492       0    0.15    0.00    0.00   99.82      25
       2       6       1    0.12    1117    3492       0    0.06
       3       3       0    0.01     911    3492       0    0.04    0.01    0.00   99.94      22
       3       7       0    0.03     856    3492       0    0.02
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.08     889    3492       0    0.12    0.03    0.06   99.71      29      29   99.32    0.00    0.00    0.00    2.21    0.00    0.00
       0       0       1    0.11     867    3492       0    0.20    0.02    0.22   99.44      29      29   99.32    0.00    0.00    0.00    2.21    0.00    0.00
       0       4       1    0.14     907    3492       0    0.17
       1       1       1    0.12     809    3492       0    0.04    0.11    0.01   99.73      24
       1       5       0    0.01     798    3492       0    0.14
       2       2       0    0.03     863    3492       0    0.18    0.00    0.01   99.78      24
       2       6       1    0.14    1013    3492       0    0.07
       3       3       0    0.02     853    3492       0    0.09    0.00    0.00   99.89      23
       3       7       1    0.06     815    3492       0    0.05
^C
[root@echolake turbostat]# echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct 
[root@echolake turbostat]# ./turbostat 
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.03    3489    3492       0    2.43    0.01    0.00   97.53      30      30   90.20    0.00    0.00    0.00    2.85    0.06    0.00
       0       0       1    0.04    3470    3492       0    0.09    0.00    0.00   99.88      30      30   90.20    0.00    0.00    0.00    2.85    0.06    0.00
       0       4       2    0.06    3492    3492       0    0.07
       1       1       1    0.02    3495    3492       0    0.05    0.03    0.00   99.90      25
       1       5       0    0.00    3494    3492       0    0.07
       2       2       0    0.01    3492    3492       0    9.53    0.00    0.01   90.45      25
       2       6       1    0.04    3492    3492       0    9.50
       3       3       1    0.03    3492    3492       0    0.05    0.01    0.00   99.91      23
       3       7       1    0.02    3493    3492       0    0.06
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       1    0.02    3492    3492       0    4.93    0.00    0.00   95.04      30      30   80.19    0.00    0.00    0.00    3.54    0.10    0.00
       0       0       1    0.02    3491    3492       0    0.08    0.01    0.00   99.89      30      30   80.19    0.00    0.00    0.00    3.54    0.10    0.00
       0       4       2    0.05    3492    3492       0    0.05
       1       1       0    0.01    3492    3492       0    0.02    0.00    0.00   99.97      24
       1       5       0    0.01    3493    3492       0    0.02
       2       2       0    0.01    3493    3492       0   19.65    0.01    0.00   80.34      24
       2       6       2    0.05    3493    3492       0   19.61
       3       3       1    0.01    3492    3492       0    0.02    0.00    0.00   99.97      23
       3       7       0    0.01    3494    3492       0    0.02
    Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt 
       -       -       2    0.05    3493    3492       0    1.64    0.01    0.00   98.29      30      30   93.25    0.00    0.00    0.00    2.64    0.04    0.00
       0       0       4    0.12    3492    3492       0    0.13    0.01    0.00   99.74      30      30   93.25    0.00    0.00    0.00    2.64    0.04    0.00
       0       4       2    0.06    3493    3492       0    0.19
       1       1       1    0.02    3492    3492       0    0.03    0.04    0.00   99.91      23
       1       5       0    0.01    3494    3492       0    0.04
       2       2       0    0.01    3492    3492       0    6.42    0.00    0.00   93.57      25
       2       6       6    0.16    3492    3492       0    6.27
       3       3       0    0.01    3501    3492       0    0.05    0.01    0.00   99.93      22
       3       7       1    0.03    3492    3492       0    0.03
[root@echolake turbostat]# grep MH /proc/cpuinfo
cpu MHz		: 997.089
cpu MHz		: 797.480
cpu MHz		: 998.320
cpu MHz		: 800.078
cpu MHz		: 845.878
cpu MHz		: 801.445
cpu MHz		: 800.078
cpu MHz		: 800.351
[root@echolake turbostat]# echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct 
[root@echolake turbostat]# grep MH /proc/cpuinfo
cpu MHz		: 3497.128
cpu MHz		: 3506.699
cpu MHz		: 3500.273
cpu MHz		: 3500.273
cpu MHz		: 3500.000
cpu MHz		: 3500.000
cpu MHz		: 3500.000
cpu MHz		: 3495.898


> Thanks.
> 
> Tim
> 

