Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaAWOoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:44:09 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54674 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaAWOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:44:06 -0500
Message-ID: <52E12AAD.9070200@linaro.org>
Date: Thu, 23 Jan 2014 22:43:57 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Mike Galbraith <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org> <1390282399-17091-2-git-send-email-alex.shi@linaro.org> <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com> <52DF802D.4030608@linaro.org> <20140122160901.GW13532@twins.programming.kicks-ass.net> <1390414208.2866.11.camel@j-VirtualBox> <52E0BB75.2080102@linaro.org> <20140123095443.GQ30183@twins.programming.kicks-ass.net> <52E0F3BF.5020904@linaro.org> <20140123123252.GC19029@e103034-lin>
In-Reply-To: <20140123123252.GC19029@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 08:32 PM, Morten Rasmussen wrote:
> On Thu, Jan 23, 2014 at 10:49:35AM +0000, Alex Shi wrote:
>> On 01/23/2014 05:54 PM, Peter Zijlstra wrote:
>>> On Thu, Jan 23, 2014 at 02:49:25PM +0800, Alex Shi wrote:
>>>> On 01/23/2014 02:10 AM, Jason Low wrote:
>>>>>>>>>  	P64(avg_idle);
>>>>>>>>> +	P64(max_idle_balance_cost);
>>>>>>>>>  #endif
>>>>>>>>>   	P(ttwu_count);
>>>>>>>
>>>>>>> Not also the per-sd value in sd_alloc_ctl_domain_table() ?
>>>>> Yeah, tracking the sd->max_newidle_lb_cost can also be useful.
>>>>>
>>>>>
>>>>
>>>> Thanks for suggestion!
>>>>
>>>> I thought the sd->max_newidle_lb_cost keep changing. But yes, it's
>>>> still meaningful. 
>>>> BTW, in the pandaboard ES, sd balance cost is about 1~2ms.
>>>
>>> That's an insane amount of time for only 2 cpus.
>>
>> maybe, :(
>>
>> but it is the data.
>> $ cat /proc/sys/kernel/sched_domain/cpu0/domain0/max_newidle_lb_cost
>> 1873393
> 
> What sort of workload are you running? It seems rather extreme.
> 
> I did a quick test on TC2 and got max_newidle_lb_cost in the range
> ~7000-80000 when having a constantly running task on each cpu for a few
> seconds.

Thanks for trying.

I am using the ubuntu server system on the panda ES.
memory has more than half free.
kernel is tip/master with some debug enabled, like debug_kernel, debug locks
etc.
Looks nothing abnormal.

the vmstat data:
alexs@alex-panda:~$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 628420  48776 245088    0    0    11     4   39   26  0  0 99  0
 0  0      0 628396  48776 245088    0    0     0     0   79   44  0  0 100  0
 1  0      0 628396  48776 245088    0    0     0     0   64   39  0  0 100  0
 0  0      0 628420  48776 245112    0    0     0     0   47   27  0  1 99  0
 0  0      0 628420  48776 245112    0    0     0     0   53   31  0  0 100  0
 0  0      0 628420  48776 245112    0    0     0     0   47   30  0  0 100  0
 0  0      0 628420  48776 245112    0    0     0     0   44   31  0  0 100  0
 0  0      0 628420  48776 245112    0    0     0     0   58   39  0  0 100  0
 0  0      0 628420  48776 245112    0    0     0     0   46   23  0  0 100  0

=====
@alex-panda:~$ cat /proc/sched_debug 
Sched Debug Version: v0.11, 3.13.0-02178-gaac64da-dirty #94
ktime                                   : 14299180.219725
sched_clk                               : 14299181.549072
cpu_clk                                 : 14299181.549072
jiffies                                 : 1399918

sysctl_sched
  .sysctl_sched_latency                    : 12.000000
  .sysctl_sched_min_granularity            : 1.500000
  .sysctl_sched_wakeup_granularity         : 2.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 11899
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 287105
  .nr_load_updates               : 103294
  .nr_uninterruptible            : -10
  .next_balance                  : 1.399919
  .curr->pid                     : 0
  .clock                         : 14299181.488037
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 2
  .sched_count                   : 287650
  .sched_goidle                  : 106271
  .avg_idle                      : 7203403
  .max_idle_balance_cost         : 3704243
  .ttwu_count                    : 183044
  .ttwu_local                    : 161092

cfs_rq[0]:
  .exec_clock                    : 200707.458407
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 668837.562013
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 63
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 97

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     ksoftirqd/0     3    668828.662844     12744   120    668828.662844      1148.742697  14295248.412972
    kworker/0:0H     5      1780.632452         5   100      1780.632452         0.915527      2428.527832
          rcu_bh     8        12.628673         2   120        12.628673         0.030517         0.030518
     migration/0     9         0.000000       399     0         0.000000       187.866211         0.030517
    kworker/u4:1    16      3362.363077       201   120      3362.363077        72.906491      7433.654788
     kworker/0:1    52    668831.623049      7206   120    668831.623049      1035.125800  14296468.780426
       writeback   275       238.256812         2   100       238.256812         0.061035         0.030518
          bioset   277       244.287678         2   100       244.287678         0.061034         0.030518
         kblockd   279       250.318545         2   100       250.318545         0.061036         0.030517
         kswapd0   552       533.946299         3   120       533.946299         0.152588       103.240967
          nfsiod   554       473.305109         2   100       473.305109         0.061036         0.030517
          crypto   555       479.396659         2   100       479.396659         0.091553         0.030517
      OMAP UART0   575       527.793717         2   100       527.793717         0.061035         0.061035
      OMAP UART1   577       533.854750         2   100       533.854750         0.061036         0.030517
      OMAP UART2   579       539.915782         2   100       539.915782         0.061035         0.030518
      OMAP UART3   581       552.098882         2   100       552.098882         0.000000         0.061035
            spi1   649       968.857220         3   120       968.857220         0.152588         0.152588
            spi2   651       981.070836         2   120       981.070836         0.061034         0.030518
            spi3   653       993.192900         2   120       993.192900         0.000000         0.061035
            spi4   655      1005.375999         2   120      1005.375999         0.030517         0.030518
       kpsmoused   694      1238.045075         2   100      1238.045075         0.061036         0.030517
  irq/158-talert   706         0.000000         2    49         0.000000         0.366211         0.000000
         deferwq   730      1384.852623         2   100      1384.852623         0.091553         0.030517
 irq/39-TWL6030-   742         0.000000         2    49         0.000000         1.068115         0.000000
 irq/151-twl6040   776         5.999997         2    49         5.999997         0.793457         0.000000
 irq/89-48072000   779         0.000000         2    49         0.000000         0.061036         0.000000
 irq/93-48060000   782         0.000000         2    49         0.000000         0.122070         0.000000
 irq/94-48350000   788         0.000000         2    49         0.000000         0.122070         0.000000
    kworker/0:1H   809    380628.904053      3018   100    380628.904053       505.493149  14107134.002707
 upstart-udev-br   884     14849.067714      1123   120     14849.067714       498.809820     38619.323719
           udevd   896      4948.481614       668   120      4948.481614       368.133548      5490.539550
           udevd  1140      2599.121477         4   120      2599.121477         3.997803         0.000000
     kworker/0:2  1615      3411.081929         3   120      3411.081929         0.640868        19.897461
     dbus-daemon  1629     58044.480491       304   120     58044.480491       150.939951   3185970.214828
        rsyslogd  1679    668566.974627      1084   120    668566.974627     11260.040283  14269129.852303
   rs:main Q:Reg  1683    381884.264680       146   120    381884.264680       552.001943  14231655.883798
 upstart-socket-  1743     14848.579433       221   120     14848.579433        52.886965     34331.695554
            nmbd  1834    668796.790535      1455   120    668796.790535      2483.093268  14283383.087151
           getty  1873      4977.536546        10   120      4977.536546        13.061522         0.000000
           getty  1881      5006.922279         7   120      5006.922279        13.824462         2.929688
           getty  1898     13273.101971        20   120     13273.101971        31.250000     12775.329589
      irqbalance  1918    668722.339617      1641   120    668722.339617      5594.879138  14275445.953377
            cron  1955    668328.823268       255   120    668328.823268       335.906977  14246798.889165
             atd  1956    360099.936165         6   120    360099.936165         3.021240  10800118.621826
          mysqld  2007      5674.303582         1   120      5674.303582         0.152588         0.000000
          mysqld  2009      5675.561879         1   120      5675.561879         0.152587         0.000000
          mysqld  2011      5675.053433         1   120      5675.053433         0.000000         0.000000
          mysqld  2013      5674.775504         1   120      5674.775504         0.000000         0.000000
          mysqld  2015      5675.008589         1   120      5675.008589         0.152588         0.000000
          mysqld  2024    668831.696048     14074   120    668831.696048     12500.183090  14259236.908010
          mysqld  2026    668796.698982      2846   120    668796.698982      1983.551015  14281165.191669
          mysqld  2027      6691.770100         3   120      6691.770100         0.732421      1000.976563
          mysqld  2052      6691.546710         1   120      6691.546710         0.793457         0.000000
        libvirtd  1981      5444.877738         1   120      5444.877738         0.000000         0.000000
        libvirtd  1983      5444.968627         1   120      5444.968627         0.152588         0.000000
        libvirtd  1985      5445.243285         1   120      5445.243285         0.000000         0.000000
        libvirtd  1991      5445.548948         1   120      5445.548948         0.000000         0.000000
        postgres  2218    668834.796877     64567   120    668834.796877     70552.520660  14157241.424533
        postgres  2220    668796.668465      8332   120    668796.668465     10573.760938  14259290.405313
         apache2  2897    309936.461891         1   120    309936.461891         3.479004         0.000000
         apache2  2900    309942.976298         1   120    309942.976298         3.570557         0.000000
         apache2  2901    309944.990458         1   120    309944.990458         3.509521         0.000000
            bash  3371    668837.562013       225   120    668837.562013      2406.188964     48741.851807

cpu#1
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 269118
  .nr_load_updates               : 130029
  .nr_uninterruptible            : 10
  .next_balance                  : 1.399934
  .curr->pid                     : 3416
  .clock                         : 14299182.861328
  .cpu_load[0]                   : 998
  .cpu_load[1]                   : 499
  .cpu_load[2]                   : 250
  .cpu_load[3]                   : 131
  .cpu_load[4]                   : 82
  .yld_count                     : 2
  .sched_count                   : 269213
  .sched_goidle                  : 108355
  .avg_idle                      : 5111702
  .max_idle_balance_cost         : 3708756
  .ttwu_count                    : 141417
  .ttwu_local                    : 130286

cfs_rq[1]:
  .exec_clock                    : 175200.378299
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 376330.465410
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -292507.096603
  .nr_spread_over                : 130
  .nr_running                    : 1
  .load                          : 1024
  .runnable_load_avg             : 998
  .blocked_load_avg              : 413

rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            init     1    313310.289516      3299   120    313310.289516      2455.017054   6104221.954363
        kthreadd     2      6577.160196        58   120      6577.160196         5.462646      8008.483888
    kworker/u4:0     6    376132.673205      2930   120    376132.673205       493.042018  14291930.480919
       rcu_sched     7    376323.397295     14084   120    376323.397295       723.998898  14297275.360261
     migration/1    10         0.000000       401     0         0.000000       850.799562         0.030517
     ksoftirqd/1    11    376284.212726      7272   120    376284.212726       634.094247  14296060.028045
     kworker/1:0    12       232.154164         6   120       232.154164         0.488281       232.757568
    kworker/1:0H    13      3954.602298         6   100      3954.602298         0.457762      2448.822022
         khelper    14         5.074196         2   100         5.074196         0.152589         0.030517
       kdevtmpfs    15      6350.821406       145   120      6350.821406        34.027099      6938.079836
     kworker/1:1    55    376324.556962     14214   120    376324.556962      1210.388161  14295621.337855
           khubd   431      3992.571696       146   120      3992.571696        73.120116      2298.736572
          rpciod   533      3186.886003         2   100      3186.886003         0.061036         0.030517
   fsnotify_mark   553      6698.542889         5   120      6698.542889         0.610351      7465.240479
 irq/88-48070000   733         0.000000       175    49         0.000000        37.597654         0.000000
         mmcqd/0   798    376284.578939     31081   120    376284.578939      7339.965810  14286424.774125
    kworker/1:1H   811    376284.153804      2016   100    376284.153804       467.559836  14295915.771461
 jbd2/mmcblk0p2-   812    376284.853597       909   120    376284.853597       187.957750  14296129.089368
 ext4-rsv-conver   813      3960.631760         2   100      3960.631760         0.091552         0.030518
           udevd  1139      5073.299325         3   120      5073.299325         3.326416         0.000000
        rsyslogd  1685    367855.641776        89   120    367855.641776        66.558837  14232167.999268
        rsyslogd  1686     18583.825784         5   120     18583.825784         8.148193     35041.595459
            smbd  1735    373866.679904       381   120    373866.679904       713.073724  14233558.624261
            smbd  1750      7436.795409         1   120      7436.795409         3.997803         0.000000
            sshd  1791    367855.611257        41   120    367855.611257        56.549075  14230944.915772
           getty  1888      8379.423084         9   120      8379.423084        17.639160         0.000000
           getty  1890      8397.461169         9   120      8397.461169        17.425537         0.000000
           getty  1895      8438.145491         9   120      8438.145491        17.730713         0.000000
           acpid  1914      8598.322557         4   120      8598.322557         9.460450         0.000000
          mysqld  1967     10371.880479       128   120     10371.880479       366.973878      1735.992431
          mysqld  2008      9233.960583         7   120      9233.960583         2.258300       475.158691
          mysqld  2010      8867.063605         1   120      8867.063605         0.152588         0.000000
          mysqld  2012      8866.341534         1   120      8866.341534         0.000000         0.000000
          mysqld  2014      8867.467414         1   120      8867.467414         1.159668         0.000000
          mysqld  2016      8866.296690         1   120      8866.296690         0.000000         0.000000
          mysqld  2025    376285.463948     14148   120    376285.463948     19846.252467  14255057.739241
        whoopsie  1972    319956.300764        20   120    319956.300764        45.135497   7200619.628905
           gdbus  1998      8723.098042         8   120      8723.098042         4.394532         0.457763
        libvirtd  1977     46500.443638        27   120     46500.443638        46.112063   3182319.610594
        libvirtd  1980      8682.048136         1   120      8682.048136         0.000000         0.000000
        libvirtd  1982      8681.762422         1   120      8681.762422         0.000000         0.000000
        libvirtd  1984      8681.548135         1   120      8681.548135         0.000000         0.000000
        libvirtd  1986      8681.548136         1   120      8681.548136         0.000000         0.000000
        libvirtd  1989      8681.822793         2   120      8681.822793         0.274658         0.000000
        libvirtd  1990      8681.578652         1   120      8681.578652         0.030517         0.000000
        postgres  2022    376137.781608      1385   120    376137.781608      8902.221690  14270901.306141
        postgres  2217    376284.365315     64617   120    376284.365315     68520.446801  14163715.789733
        postgres  2219    376284.273762     15293   120    376284.273762      8413.848882  14260271.423355
         apache2  2315    376284.151692     14024   120    376284.151692      8033.294679  14257380.950902
           getty  2353     17387.058964        12   120     17387.058964        12.756348         2.380371
         apache2  2896    293802.653959         8   120    293802.653959         2.899168         0.000000
         apache2  2898    293807.600003         1   120    293807.600003         0.946045         0.000000
            sshd  3243    374087.137122        31   120    374087.137122       168.395993      6727.355959
            sshd  3370    376324.679034       263   120    376324.679034       360.321040     50774.353030
R            cat  3416    376330.465410         4   120    376330.465410         9.033203         0.518799


> 
> I also traced curr_cost just to get an idea of the cost of idle_balance.
> I get an average cost across all five cpus of around 7000.
> 
> Morten
> 


-- 
Thanks
    Alex
