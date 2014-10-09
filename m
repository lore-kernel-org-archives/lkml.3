Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaJIJrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:47:24 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56858 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJIJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:47:13 -0400
Message-ID: <5436599C.9000207@monom.org>
Date: Thu, 09 Oct 2014 11:47:08 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Do not try to replenish from a non deadline tasks
References: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de> <5433B5B9.70006@arm.com> <5433D654.2020108@monom.org> <5433D84F.3040003@monom.org> <5433E8B3.6040708@monom.org>
In-Reply-To: <5433E8B3.6040708@monom.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,

On 10/07/2014 03:20 PM, Daniel Wagner wrote:
> On 10/07/2014 02:10 PM, Daniel Wagner wrote:
>> [   36.689416] pthread_-1555    0d..5 18486408us : sched_stat_sleep: comm=pthread_test pid=1554 delay=143975 [ns]
>> [   36.689416] pthread_-1555    0d..5 18486408us : sched_wakeup: comm=pthread_test pid=1554 prio=120 success=1 target_cpu=000
>> [   36.689416] pthread_-1555    0d..4 18486420us : sched_pi_setprio: comm=pthread_test pid=1555 oldprio=-1 newprio=-1
>> [   36.689416] pthread_-1555    0d..4 18486421us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
>> [   36.689416] pthread_-1555    0d..4 18486421us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=8
>> [   36.689416] pthread_-1555    0d..4 18486421us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
>> [   36.689416] pthread_-1555    0d..4 18486422us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=0
>> [   36.689416] pthread_-1555    0d.H4 18486539us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=8
> 
> I noticed that the last two lines are different. Maybe that is yet
> another path into enqueue_task_dl().

So more testing revealed that the patch also starve both task
eventually. Both process make no progress at all.

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         systemd     1       170.771190      2147   120       170.771190       433.550134    359375.395748 /autogroup-1
        kthreadd     2     12481.085697        66   120     12481.085697         1.062411    848978.893057 /
     ksoftirqd/0     3     12486.586001     10125   120     12486.586001        48.522819    856220.673708 /
    kworker/0:0H     5      1218.349308         6   100      1218.349308         0.106697       835.585066 /
    kworker/u2:0     6     12483.710138      1947   120     12483.710138        45.712779    854218.654119 /
         khelper     7        13.326326         2   100        13.326326         0.000000         0.000000 /
       kdevtmpfs     8      2001.861157       139   120      2001.861157         1.787992     10775.571085 /
           netns     9        17.326324         2   100        17.326324         0.000000         0.000000 /
    kworker/u2:1    10      2001.760377       678   120      2001.760377         9.362114     10766.675796 /
       writeback    19        32.293597         2   100        32.293597         0.003126         0.002243 /
          crypto    21        33.494501         2   100        33.494501         0.002662         0.002051 /
          bioset    23        34.995536         2   100        34.995536         0.002601         0.002002 /
         kblockd    25        36.497285         2   100        36.497285         0.003835         0.002050 /
         ata_sff    61        78.865458         2   100        78.865458         0.004438         0.002205 /
           khubd    64        80.079505         2   120        80.079505         0.015444         0.003833 /
              md    66        81.268188         2   100        81.268188         0.003050         0.002173 /
     kworker/0:1    68     12484.564192       957   120     12484.564192        49.238817    855345.418329 /
        cfg80211    69        82.636198         2   100        82.636198         0.003627         0.002132 /
          rpciod   130       156.580245         2   100       156.580245         0.005374         0.004012 /
         kswapd0   138       928.454330         3   120       928.454330         0.048229        99.749401 /
   fsnotify_mark   143      1963.891522        14   120      1963.891522         0.065959      3496.886517 /
          nfsiod   146       171.432785         2   100       171.432785         0.004305         0.003535 /
        xfsalloc   149       174.366108         2   100       174.366108         0.002861         0.002284 /
   xfs_mru_cache   151       175.567171         2   100       175.567171         0.002752         0.002090 /
         xfslogd   153       177.068445         2   100       177.068445         0.003142         0.002171 /
 acpi_thermal_pm   177       192.956400         2   100       192.956400         0.003639         0.002317 /
       scsi_eh_0   203      1188.912866         8   120      1188.912866         2.029062       153.702869 /
      scsi_tmf_0   205       223.187411         2   100       223.187411         0.003086         0.002421 /
       scsi_eh_1   207      1531.958332        29   120      1531.958332         2.988008      1276.298054 /
      scsi_tmf_1   209       226.190410         2   100       226.190410         0.004007         0.002328 /
       kpsmoused   218       235.418718         2   100       235.418718         0.003621         0.002384 /
   ipv6_addrconf   227       244.650047         2   100       244.650047         0.004004         0.004044 /
         deferwq   232       247.754373         2   100       247.754373         0.003005         0.002112 /
    kworker/0:1H   882     12482.321178      1873   100     12482.321178        51.220049    850000.764070 /
   xfs-data/sda2   887      1230.066143         2   100      1230.066143         0.003715         0.002886 /
   xfs-conv/sda2   888      1231.567109         2   100      1231.567109         0.002769         0.002330 /
    xfs-cil/sda2   889      1233.568672         2   100      1233.568672         0.044412         0.002514 /
    xfsaild/sda2   890     12484.343046      4544   120     12484.343046        74.991234    847492.165181 /
 systemd-journal   902      1019.896708       410   120      1019.896708      1021.188821    848668.196674 /autogroup-5
         kauditd   905      7231.521873        59   120      7231.521873         0.606636    358980.677314 /
   systemd-udevd   971        60.572337       520   120        60.572337        53.544845     12283.357288 /autogroup-10
     jbd2/sda1-8  1422      1957.029513         2   120      1957.029513         0.062018         0.004464 /
 ext4-rsv-conver  1423      1959.032062         2   100      1959.032062         0.004310         0.002700 /
          auditd  1428         6.142863        98   116         6.142863        10.602551    845312.563408 /autogroup-21
          auditd  1436         5.502422        81   116         5.502422         2.335235    357502.433148 /autogroup-21
  NetworkManager  1445        82.669958       562   120        82.669958        64.904912    844091.171520 /autogroup-26
  NetworkManager  1467        20.709072         1   120        20.709072         0.014731         0.000000 /autogroup-26
           gmain  1470        66.064602         6   120        66.064602         0.366758      3699.249128 /autogroup-26
           gdbus  1474        79.637929       140   120        79.637929         4.511798    838151.788025 /autogroup-26
  systemd-logind  1446         8.311585       106   120         8.311585         9.677422    355305.433254 /autogroup-27
     dbus-daemon  1447        23.241715       345   120        23.241715        24.616880    844172.717523 /autogroup-28
           crond  1449         3.123550        18   120         3.123550         4.516948    841485.755390 /autogroup-29
          agetty  1455         2.936206         7   120         2.936206         7.052828      4305.395671 /autogroup-37
          agetty  1456        12.159459        11   120        12.159459        16.314073      3286.999222 /autogroup-36
         polkitd  1475        20.631235        93   120        20.631235        15.310572    349234.784825 /autogroup-32
           gmain  1478         8.881526         2   120         8.881526         0.065824         0.000000 /autogroup-32
           gdbus  1479        21.328501        38   120        21.328501         2.320225    349229.316491 /autogroup-32
    JS GC Helper  1480        14.370672         1   120        14.370672         0.031663         0.000000 /autogroup-32
 JS Sour~ Thread  1481        17.473336         7   120        17.473336         0.071963         3.840505 /autogroup-32
 runaway-killer-  1482        20.472425         5   120        20.472425         0.051006         0.250475 /autogroup-32
            sshd  1486        13.338015        67   120        13.338015        14.729391    349142.506840 /autogroup-35
        dhclient  1490        66.072235        65   120        66.072235        17.853255      1029.655591 /autogroup-26
            sshd  1505        27.497743       218   120        27.497743        25.950965    340666.314097 /autogroup-39
         systemd  1507         9.239660        26   120         9.239660        10.300048       729.175924 /autogroup-40
            bash  1508      4560.989053        99   120      4560.989053        14.807953    340582.911272 /autogroup-41
        (sd-pam)  1511         3.251482         1   120         3.251482         0.050250         0.000000 /autogroup-40
     kworker/0:0  1529     12482.288839       648   120     12482.288839        24.882158    535264.262021 /
    pthread_test  1536         0.000000   1510185    -1         0.000000      7142.137941     61496.639384 /autogroup-41
    pthread_test  1537         0.000000   1508994    -1         0.000000     19830.272655         0.000000 /autogroup-41
            sshd  1538        45.693223       859   120        45.693223        44.510292    497299.440632 /autogroup-42
            bash  1540       336.221438       292   120       336.221438        15.725550    496379.865890 /autogroup-43
     kworker/0:2  1561     12486.603821        72   120     12486.603821         1.009523      8366.740527 /
R            cat  1562       337.711978         0   120       337.711978         0.655400         0.000000 /autogroup-43


[  478.792528] pthread_test    R  running task    14232  1536   1508 0x10000080
[  478.793133]  ffff880078d1bf60 0000000000000046 ffff88007caee5e0 ffff880078d1bfd8
[  478.793774]  ffffffff81e1d4c0 00007fffa9c5e7b0 ffffffff8136187e 0000000000000000
[  478.794451]  00000000004009d0 00007fffa9c5e890 0000000000000000 0000000000000000
[  478.795118] Call Trace:
[  478.795326]  [<ffffffff8136187e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  478.795846]  [<ffffffff818b6d13>] schedule+0x23/0x60
[  478.796256]  [<ffffffff818bd20f>] retint_careful+0x12/0x2d
[  478.796695] pthread_test    S ffff88007caea8c0 14424  1537   1508 0x10000080
[  478.797287]  ffff880078e63bd8 0000000000000046 ffff88007caea8c0 ffff880078e63fd8
[  478.797909]  ffffffff81e1d4c0 ffff88007caea8c0 ffff880078e63be8 ffff880000158010
[  478.798542]  ffff880078e63c58 0000000000000001 0000000000000001 ffff88007caea8c0
[  478.799175] Call Trace:
[  478.799376]  [<ffffffff818b6d13>] schedule+0x23/0x60
[  478.799773]  [<ffffffff818ba2fb>] __rt_mutex_slowlock+0x5b/0xe0
[  478.800257]  [<ffffffff818ba4ce>] rt_mutex_slowlock+0xbe/0x1c0
[  478.800725]  [<ffffffff8107cbea>] rt_mutex_timed_futex_lock+0x3a/0x40
[  478.801252]  [<ffffffff810a6437>] futex_lock_pi.isra.20+0x257/0x370
[  478.801753]  [<ffffffff81068cd5>] ? sched_clock_local.constprop.6+0x15/0x80
[  478.802317]  [<ffffffff81068ec5>] ? sched_clock_cpu+0x55/0x80
[  478.802774]  [<ffffffff81068f45>] ? local_clock+0x15/0x30
[  478.803225]  [<ffffffff81068cd5>] ? sched_clock_local.constprop.6+0x15/0x80
[  478.803784]  [<ffffffff810a720c>] do_futex+0x2bc/0xa90
[  478.804209]  [<ffffffff81068cd5>] ? sched_clock_local.constprop.6+0x15/0x80
[  478.804766]  [<ffffffff81068ec5>] ? sched_clock_cpu+0x55/0x80
[  478.805236]  [<ffffffff81068f45>] ? local_clock+0x15/0x30
[  478.805669]  [<ffffffff8109a936>] ? current_kernel_time+0x56/0xb0
[  478.806165]  [<ffffffff8107648d>] ? trace_hardirqs_on+0xd/0x10
[  478.806629]  [<ffffffff810a7a4c>] SyS_futex+0x6c/0x150
[  478.807046]  [<ffffffff8100f60f>] ? syscall_trace_enter+0x21f/0x230
[  478.807549]  [<ffffffff818bc75f>] tracesys+0xdc/0xe1

(gdb) p $lx_task_by_pid(1536).dl
$1 = {
  rb_node = {
    __rb_parent_color = 18446612134406055880, 
    rb_right = 0x0, 
    rb_left = 0x0
  }, 
  dl_runtime = 0, 
  dl_deadline = 0, 
  dl_period = 0, 
  dl_bw = 0, 
  runtime = -283620, 
  deadline = 441965145261, 
  flags = 0, 
  dl_throttled = 0, 
  dl_new = 0, 
  dl_boosted = 1, 
  dl_yielded = 0, 
  dl_timer = {
    node = {
      node = {
        __rb_parent_color = 18446612134406055976, 
        rb_right = 0x0, 
        rb_left = 0x0
      }, 
      expires = {
        tv64 = 0
      }
    }, 
    _softexpires = {
      tv64 = 0
    }, 
    function = 0x0, 
    base = 0xffffffff82010d68 <hrtimer_bases+136>, 
    state = 0, 
    start_pid = -1, 
    start_site = 0x0, 
    start_comm = '\000' <repeats 15 times>
  }
}
                                                                                                                                            
(gdb) p $lx_task_by_pid(1537).dl
$2 = {
  rb_node = {
    __rb_parent_color = 18446612134406040232, 
    rb_right = 0x0, 
    rb_left = 0x0
  }, 
  dl_runtime = 100000, 
  dl_deadline = 200000, 
  dl_period = 200000, 
  dl_bw = 524288, 
  runtime = 70824, 
  deadline = 441965047345, 
  flags = 0, 
  dl_throttled = 0, 
  dl_new = 0, 
  dl_boosted = 0, 
  dl_yielded = 0, 
  dl_timer = {
    node = {
      node = {
        __rb_parent_color = 18446612134406040328, 
        rb_right = 0x0, 
        rb_left = 0x0
      }, 
      expires = {
        tv64 = 441824359503
      }
    }, 
    _softexpires = {
      tv64 = 441824359503
    }, 
    function = 0xffffffff8106ce50 <dl_task_timer>, 
    base = 0xffffffff82010d68 <hrtimer_bases+136>, 
    state = 0, 
    start_pid = 1537, 
    start_site = 0xffffffff8106d178 <update_curr_dl+552>, 
    start_comm = "pthread_test\000\000\000"
  }
}

cheers,
daniel
