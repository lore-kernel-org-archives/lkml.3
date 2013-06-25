Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3FYQCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:02:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:02:15 -0400
Message-ID: <1372176104.7497.86.camel@marge.simpson.net>
Subject: Re: Scheduler accounting inflated for io bound processes.
From: Mike Galbraith <bitbucket@online.de>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Jun 2013 18:01:44 +0200
In-Reply-To: <51C35C05.1070005@canonical.com>
References: <51C35C05.1070005@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:GNEwKGtu5eOUh8l7j04WCACyGUK8wtQ8AKbfzqitvyX
 ivCSUKNBkdGaR8E/i96UekCoxpN5+kK/u5wRinbG/hYOESV+Qj
 6zyejGXfGHBfp/l2DneUwMmxEx4RE22MVYKH0soj8hxIr1QA0j
 ajLUxJ5BXV2qWFXiPRn7ltsDTlTZeizzuWZCG16FWg1rFlbtoy
 SnMwd9aNn+buJrmDNKyjFC805SQxLR5/YOwISyAFixpfvKGOtL
 /YiilwF2bOiWkY3B0x5I6B5Jm1iYBLBXteELp/8aNZhWzGliUj
 THsW4Is4zhQQeGm3xoVnbqNIbXhEgutH3vmVPJJbP1RmCDaSz1
 xafprRVOCOclKD/JqQXWON4vDoZCISO7QVdotmVO0t+yAVxo2n
 VW7u15IKtklcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 14:46 -0500, Dave Chiluk wrote: 
> Running the below testcase shows each process consuming 41-43% of it's
> respective cpu while per core idle numbers show 63-65%, a disparity of
> roughly 4-8%.  Is this a bug, known behaviour, or consequence of the
> process being io bound?

All three I suppose.  Idle is indeed inflated when softirq load is
present.  Depends on ACCOUNTING config what exact numbers you see.

There are lies, there are damn lies.. and there are statistics.

> 1. run sudo taskset -c 0 netserver
> 2. run taskset -c 1 netperf -H localhost -l 3600 -t TCP_RR & (start
> netperf with priority on cpu1)
> 3. run top, press 1 for multiple CPUs to be separated

CONFIG_TICK_CPU_ACCOUNTING cpu[23] isolated

cgexec -g cpuset:rtcpus netperf.sh 999&sleep 300 && killall -9 top

%Cpu2  :  6.8 us, 42.0 sy,  0.0 ni, 42.0 id,  0.0 wa,  0.0 hi,  9.1 si,  0.0 st
%Cpu3  :  5.6 us, 43.3 sy,  0.0 ni, 40.0 id,  0.0 wa,  0.0 hi, 11.1 si,  0.0 st
                                    ^^^^
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM     TIME+ P COMMAND
 7226 root      20   0  8828  336  192 S 57.6  0.0   2:49.40 3 netserver   100*(2*60+49.4)/300 = 56.4
 7225 root      20   0  8824  648  504 R 55.6  0.0   2:46.55 2 netperf     100*(2*60+46.55)/300 = 55.5

Ok, accumulated time ~agrees with %CPU snapshots.

cgexec -g cpuset:rtcpus taskset -c 3 schedctl -I pert 5

(pert is self calibrating tsc tight loop perturbation measurement
proggy, enters kernel once per 5s period for write.  It doesn't care
about post period stats processing/output time, but it's running
SCHED_IDLE, gets VERY little CPU when competing, so runs more or less
only when netserver is idle.  Plenty good enough proxy for idle.) 
...
cgexec -g cpuset:rtcpus netperf.sh 9999
...
pert/s:    81249 >17.94us:       24 min:  0.08 max: 33.89 avg:  8.24 sum/s:669515us overhead:66.95%
pert/s:    81151 >18.43us:       25 min:  0.14 max: 37.53 avg:  8.25 sum/s:669505us overhead:66.95%
                                                                           ^^^^^^^^^^^^^^^^^^^^^^^
pert userspace tsc loop gets ~32% ~= idle upper bound, reported = ~40%,
disparity ~8%.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM     TIME+ P COMMAND
23067 root      20   0  8828  340  196 R 57.5  0.0   0:19.15 3 netserver
23040 root      20   0  8208  396  304 R 42.7  0.0   0:35.61 3 pert         
                                         ^^^^ ~10% disparity.

perf record -e irq:softirq* -a -C 3 -- sleep 00
perf report --sort=comm

    99.80%  netserver
     0.20%       pert

pert does ~zip softirq processing (timer+rcu) and ~zip squat kernel.

Repeat.

cgexec -g cpuset:rtcpus netperf.sh 3600
pert/s:    80860 >474.34us:        0 min:  0.06 max: 35.26 avg:  8.28 sum/s:669197us overhead:66.92%
pert/s:    80897 >429.20us:        0 min:  0.14 max: 37.61 avg:  8.27 sum/s:668673us overhead:66.87%
pert/s:    80800 >388.26us:        0 min:  0.14 max: 31.33 avg:  8.26 sum/s:667277us overhead:66.73%

%Cpu3  : 36.3 us, 51.5 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi, 12.1 si,  0.0 st
         ^^^^ ~agrees with pert
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM     TIME+ P COMMAND
23569 root      20   0  8828  340  196 R 57.2  0.0   0:21.97 3 netserver
23040 root      20   0  8208  396  304 R 42.9  0.0   6:46.20 3 pert
                                         ^^^^ pert is VERY nearly 100% userspace
                                              one of those numbers is a.. statistic
Kills pert...

%Cpu3  :  3.4 us, 42.5 sy,  0.0 ni, 41.4 id,  0.1 wa,  0.0 hi, 12.5 si,  0.0 st
          ^^^ ~agrees that pert's us claim did go away, but wth is up
              with sy, it dropped ~9% after killing ~100% us proggy.  nak
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM     TIME+ P COMMAND
23569 root      20   0  8828  340  196 R 56.6  0.0   2:50.80 3 netserver

Yup, adding softirq load turns utilization numbers into.. statistics.
Pure cpu load idle numbers look fine.

-Mike

