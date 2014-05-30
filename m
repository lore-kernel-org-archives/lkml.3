Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbaE3Tii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:38:38 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46765 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaE3Tih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:38:37 -0400
Message-ID: <5388DE3A.7060406@gmail.com>
Date: Fri, 30 May 2014 12:38:34 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: dirk.brandewie@gmail.com, Dave Jones <davej@redhat.com>,
        George Spelvin <linux@horizon.com>, herbert@gondor.apana.org.au,
        james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, Jacob jun Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
References: <20140529235432.19207.qmail@ns.horizon.com>	 <1401412036.2970.459.camel@schen9-DESK> <20140530011636.GA31694@redhat.com>	 <1401472592.2970.483.camel@schen9-DESK> <5388D1BF.6090503@gmail.com> <1401478326.2970.504.camel@schen9-DESK>
In-Reply-To: <1401478326.2970.504.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 12:32 PM, Tim Chen wrote:
> On Fri, 2014-05-30 at 11:45 -0700, Dirk Brandewie wrote:
>
>>
>> With turbostat from rc7.
>> [root@echolake turbostat]# ./turbostat
>>      Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt
>>         -       -       1    0.08    1178    3492       0    0.12    0.08    0.01   99.71      29      29   99.23    0.00    0.00    0.00    2.18    0.00    0.00
>>         0       0       2    0.19    1189    3492       0    0.22    0.30    0.00   99.29      29      29   99.24    0.00    0.00    0.00    2.18    0.00    0.00
>>         0       4       1    0.12    1253    3492       0    0.29
>>         1       1       0    0.03    1065    3492       0    0.03    0.00    0.00   99.93      23
>>         1       5       0    0.01    1104    3492       0    0.05
>>         2       2       0    0.02    1275    3492       0    0.22    0.00    0.03   99.73      24
>>         2       6       2    0.18    1220    3492       0    0.06
>>         3       3       0    0.01     992    3492       0    0.07    0.00    0.01   99.90      23
>>         3       7       0    0.05     915    3492       0    0.04
>>      Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt
>>         -       -       1    0.06    1034    3492       0    0.09    5.15    0.00   94.70      28      28   99.49    0.00    0.00    0.00    2.48    0.01    0.00
>>         0       0       1    0.09    1066    3492       0    0.17    0.01    0.00   99.73      28      28   99.49    0.00    0.00    0.00    2.48    0.01    0.00
>>         0       4       1    0.12    1036    3492       0    0.14
>>         1       1       0    0.04    1009    3492       0    0.05   20.59    0.00   79.32      24
>>         1       5       0    0.02     922    3492       0    0.07
>>         2       2       0    0.03     924    3492       0    0.15    0.00    0.00   99.82      25
>>         2       6       1    0.12    1117    3492       0    0.06
>>         3       3       0    0.01     911    3492       0    0.04    0.01    0.00   99.94      22
>>         3       7       0    0.03     856    3492       0    0.02
>>      Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt
>>         -       -       1    0.08     889    3492       0    0.12    0.03    0.06   99.71      29      29   99.32    0.00    0.00    0.00    2.21    0.00    0.00
>>         0       0       1    0.11     867    3492       0    0.20    0.02    0.22   99.44      29      29   99.32    0.00    0.00    0.00    2.21    0.00    0.00
>>         0       4       1    0.14     907    3492       0    0.17
>>         1       1       1    0.12     809    3492       0    0.04    0.11    0.01   99.73      24
>>         1       5       0    0.01     798    3492       0    0.14
>>         2       2       0    0.03     863    3492       0    0.18    0.00    0.01   99.78      24
>>         2       6       1    0.14    1013    3492       0    0.07
>>         3       3       0    0.02     853    3492       0    0.09    0.00    0.00   99.89      23
>>         3       7       1    0.06     815    3492       0    0.05
>> ^C
>> [root@echolake turbostat]# echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
>> [root@echolake turbostat]# ./turbostat
>>      Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt
>>         -       -       1    0.03    3489    3492       0    2.43    0.01    0.00   97.53      30      30   90.20    0.00    0.00    0.00    2.85    0.06    0.00
>>         0       0       1    0.04    3470    3492       0    0.09    0.00    0.00   99.88      30      30   90.20    0.00    0.00    0.00    2.85    0.06    0.00
>>         0       4       2    0.06    3492    3492       0    0.07
>>         1       1       1    0.02    3495    3492       0    0.05    0.03    0.00   99.90      25
>>         1       5       0    0.00    3494    3492       0    0.07
>>         2       2       0    0.01    3492    3492       0    9.53    0.00    0.01   90.45      25
>>         2       6       1    0.04    3492    3492       0    9.50
>>         3       3       1    0.03    3492    3492       0    0.05    0.01    0.00   99.91      23
>>         3       7       1    0.02    3493    3492       0    0.06
>>      Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt
>>         -       -       1    0.02    3492    3492       0    4.93    0.00    0.00   95.04      30      30   80.19    0.00    0.00    0.00    3.54    0.10    0.00
>>         0       0       1    0.02    3491    3492       0    0.08    0.01    0.00   99.89      30      30   80.19    0.00    0.00    0.00    3.54    0.10    0.00
>>         0       4       2    0.05    3492    3492       0    0.05
>>         1       1       0    0.01    3492    3492       0    0.02    0.00    0.00   99.97      24
>>         1       5       0    0.01    3493    3492       0    0.02
>>         2       2       0    0.01    3493    3492       0   19.65    0.01    0.00   80.34      24
>>         2       6       2    0.05    3493    3492       0   19.61
>>         3       3       1    0.01    3492    3492       0    0.02    0.00    0.00   99.97      23
>>         3       7       0    0.01    3494    3492       0    0.02
>>      Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt CorWatt GFXWatt
>>         -       -       2    0.05    3493    3492       0    1.64    0.01    0.00   98.29      30      30   93.25    0.00    0.00    0.00    2.64    0.04    0.00
>>         0       0       4    0.12    3492    3492       0    0.13    0.01    0.00   99.74      30      30   93.25    0.00    0.00    0.00    2.64    0.04    0.00
>>         0       4       2    0.06    3493    3492       0    0.19
>>         1       1       1    0.02    3492    3492       0    0.03    0.04    0.00   99.91      23
>>         1       5       0    0.01    3494    3492       0    0.04
>>         2       2       0    0.01    3492    3492       0    6.42    0.00    0.00   93.57      25
>>         2       6       6    0.16    3492    3492       0    6.27
>>         3       3       0    0.01    3501    3492       0    0.05    0.01    0.00   99.93      22
>>         3       7       1    0.03    3492    3492       0    0.03
>> [root@echolake turbostat]# grep MH /proc/cpuinfo
>> cpu MHz		: 997.089
>> cpu MHz		: 797.480
>> cpu MHz		: 998.320
>> cpu MHz		: 800.078
>> cpu MHz		: 845.878
>> cpu MHz		: 801.445
>> cpu MHz		: 800.078
>> cpu MHz		: 800.351
>> [root@echolake turbostat]# echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
>> [root@echolake turbostat]# grep MH /proc/cpuinfo
>> cpu MHz		: 3497.128
>> cpu MHz		: 3506.699
>> cpu MHz		: 3500.273
>> cpu MHz		: 3500.273
>> cpu MHz		: 3500.000
>> cpu MHz		: 3500.000
>> cpu MHz		: 3500.000
>> cpu MHz		: 3495.898
>>
>
> Dirk,
>
> Thanks for checking things out.
>
> I tested on a Haswell system, and I see that the frequency
> can dip below the max even when I set the min_perf_pct to 100.
> Let me know if you want to log on to my system and check if
> there's something I missed. It is odd that the package 1's
> cores are at a much higher frequency and close to
> max than package 0, once min_perf_pct is set to 100.
>

Can you run turbostat for a few samples it reports an average over the sample
time.

> Tim
>
> [root@otc-grantly-02 ~]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> 3600000
> [root@otc-grantly-02 ~]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
> 1200000
> [root@otc-grantly-02 ~]# echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
> [root@otc-grantly-02 ~]# cat /sys/devices/system/cpu/intel_pstate/min_perf_pct
> 100
> [root@otc-grantly-02 ~]# uname -a
> Linux otc-grantly-02 3.15.0-rc7+ #3 SMP Thu May 29 11:34:39 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux
> [root@otc-grantly-02 ~]# cpupower -c 0-1 frequency-info
> analyzing CPU 0:
>    driver: intel_pstate
>    CPUs which run at the same hardware frequency: 0
>    CPUs which need to have their frequency coordinated by software: 0
>    maximum transition latency: 0.97 ms.
>    hardware limits: 1.20 GHz - 3.60 GHz
>    available cpufreq governors: performance, powersave
>    current policy: frequency should be within 1.20 GHz and 3.60 GHz.
>                    The governor "powersave" may decide which speed to use
>                    within this range.
>    current CPU frequency is 1.20 GHz (asserted by call to hardware).
>    boost state support:
>      Supported: yes
>      Active: yes
> analyzing CPU 1:
>    driver: intel_pstate
>    CPUs which run at the same hardware frequency: 1
>    CPUs which need to have their frequency coordinated by software: 1
>    maximum transition latency: 0.97 ms.
>    hardware limits: 1.20 GHz - 3.60 GHz
>    available cpufreq governors: performance, powersave
>    current policy: frequency should be within 1.20 GHz and 3.60 GHz.
>                    The governor "powersave" may decide which speed to use
>                    within this range.
>    current CPU frequency is 2.02 GHz (asserted by call to hardware).
>    boost state support:
>      Supported: yes
>      Active: yes
> [root@otc-grantly-02 ~]# turbostat
> Package     Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7 PkgWatt RAMWatt   PKG_%   RAM_%
>         -       -       -       0    0.02    1964    2594       0    0.13    0.00   99.85    0.00      33      41    4.92    0.00   93.99    0.00   23.04    3.60    0.18    0.00
>         0       0       0       1    0.07    2154    2594       0    0.21    0.00   99.72    0.00      32      41    4.42    0.00   94.00    0.00   17.16    1.73    0.10    0.00
>         0       0      28       0    0.01    1465    2594       0    0.26
>         0       1       1       1    0.04    1941    2594       0    0.18    0.00   99.78    0.00      33
>         0       1      29       0    0.02    1587    2594       0    0.20
>         0       2       2       1    0.04    1586    2594       0    0.15    0.00   99.81    0.00      28
>         0       2      30       0    0.01    1539    2594       0    0.17
>         0       3       3       1    0.04    1656    2594       0    0.17    0.00   99.79    0.00      31
>         0       3      31       0    0.01    1723    2594       0    0.19
>         0       4       4       1    0.06    1800    2594       0    0.21    0.00   99.74    0.00      33
>         0       4      32       0    0.02    1725    2594       0    0.24
>         0       5       5       1    0.04    1917    2594       0    0.15    0.00   99.81    0.00      29
>         0       5      33       0    0.02    1707    2594       0    0.17
>         0       6       6       1    0.04    1820    2594       0    0.17    0.00   99.79    0.00      33
>         0       6      34       0    0.01    1564    2594       0    0.20
>         0       8       7       0    0.02    1655    2594       0    0.11    0.00   99.86    0.00      29
>         0       8      35       0    0.01    1687    2594       0    0.12
>         0       9       8       0    0.03    1748    2594       0    0.15    0.00   99.83    0.00      32
>         0       9      36       0    0.02    2001    2594       0    0.15
>         0      10       9       1    0.06    1604    2594       0    0.20    0.00   99.74    0.00      32
>         0      10      37       0    0.02    1679    2594       0    0.24
>         0      11      10       1    0.04    1644    2594       0    0.12    0.00   99.84    0.00      30
>         0      11      38       0    0.01    1509    2594       0    0.14
>         0      12      11       1    0.04    1773    2594       0    0.13    0.00   99.83    0.00      30
>         0      12      39       0    0.01    1529    2594       0    0.16
>         0      13      12       0    0.02    1907    2594       0    0.11    0.00   99.87    0.00      30
>         0      13      40       0    0.01    1574    2594       0    0.12
>         0      14      13       1    0.04    1831    2594       0    0.19    0.00   99.77    0.00      31
>         0      14      41       0    0.01    1735    2594       0    0.22
>         1       0      14       1    0.04    1831    2594       0    0.11    0.00   99.85    0.00      28      37    5.43    0.00   93.98    0.00    5.88    1.87    0.08    0.00
>         1       0      42       0    0.01    2238    2594       0    0.14
>         1       1      15       1    0.04    1869    2594       0    0.15    0.00   99.81    0.00      31
>         1       1      43       0    0.01    2407    2594       0    0.18
>         1       2      16       0    0.02    2164    2594       0    0.10    0.00   99.88    0.00      28
>         1       2      44       0    0.01    2326    2594       0    0.11
>         1       3      17       1    0.04    2101    2594       0    0.10    0.00   99.86    0.00      30
>         1       3      45       0    0.01    2355    2594       0    0.13
>         1       4      18       0    0.01    2429    2594       0    0.08    0.00   99.90    0.00      29
>         1       4      46       0    0.01    2545    2594       0    0.08
>         1       5      19       0    0.01    2412    2594       0    0.08    0.00   99.91    0.00      29
>         1       5      47       0    0.01    2392    2594       0    0.08
>         1       6      20       0    0.01    2448    2594       0    0.08    0.00   99.90    0.00      29
>         1       6      48       0    0.01    2430    2594       0    0.08
>         1       8      21       0    0.01    2574    2594       0    0.08    0.00   99.90    0.00      29
>         1       8      49       0    0.01    2450    2594       0    0.09
>         1       9      22       0    0.02    2470    2594       0    0.08    0.00   99.90    0.00      31
>         1       9      50       0    0.01    2555    2594       0    0.08
>         1      10      23       0    0.01    2540    2594       0    0.07    0.00   99.92    0.00      26
>         1      10      51       0    0.01    2672    2594       0    0.07
>         1      11      24       0    0.01    2472    2594       0    0.08    0.00   99.91    0.00      28
>         1      11      52       0    0.01    2461    2594       0    0.08
>         1      12      25       0    0.01    2438    2594       0    0.07    0.00   99.92    0.00      29
>         1      12      53       0    0.01    2316    2594       0    0.07
>         1      13      26       0    0.01    2363    2594       0    0.08    0.00   99.90    0.00      28
>         1      13      54       0    0.01    2586    2594       0    0.09
>         1      14      27       0    0.01    2459    2594       0    0.09    0.00   99.90    0.00      27
>         1      14      55       1    0.02    2939    2594       0    0.08
>
> Tim
>

