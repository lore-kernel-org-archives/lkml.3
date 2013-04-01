Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3DAFFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:05:18 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57352 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3DAFFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:05:16 -0400
Message-ID: <5159157F.7060605@linux.vnet.ibm.com>
Date: Mon, 01 Apr 2013 13:05:03 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v6 0/21] sched: power aware scheduling
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040105-9574-0000-0000-00000746D4E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 10:34 PM, Alex Shi wrote:
[snip]
> 
> Some performance testing results:
> ---------------------------------
> 
> Tested benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
> hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
> loopback netperf. on my core2, nhm, wsm, snb, platforms.

Hi, Alex

I've tested the patch on my 12 cpu X86 box with 3.9.0-rc2, here is the
results of pgbench (a rough test with little float):

		    base	performance	powersaving
| db_size | clients |  tps  |   |  tps  |	|  tps  |
+---------+---------+-------+   +-------+	+-------+
| 22 MB   |       1 | 10662 |   | 10497 |	| 10124 |
| 22 MB   |       2 | 21483 |   | 21398 |	| 17400 |
| 22 MB   |       4 | 42046 |   | 41974 |	| 33473 |
| 22 MB   |       8 | 55807 |   | 53504 |	| 45320 |
| 22 MB   |      12 | 50768 |   | 49657 |	| 47469 |
| 22 MB   |      16 | 49880 |   | 49189 |	| 48328 |
| 22 MB   |      24 | 45904 |   | 45870 |	| 44756 |
| 22 MB   |      32 | 43420 |   | 44183 |	| 43552 |
| 7484 MB |       1 |  7965 |   |  9045 |	|  8221 |
| 7484 MB |       2 | 19354 |   | 19593 |	| 14525 |
| 7484 MB |       4 | 37552 |   | 37459 |	| 28348 |
| 7484 MB |       8 | 48655 |   | 46974 |	| 42360 |
| 7484 MB |      12 | 45778 |   | 45410 |	| 43800 |
| 7484 MB |      16 | 45659 |   | 44303 |	| 42265 |
| 7484 MB |      24 | 42192 |   | 40571 |	| 39197 |
| 7484 MB |      32 | 36385 |   | 36535 |	| 36066 |
| 15 GB   |       1 |  7677 |   |  7362 |	|  8075 |
| 15 GB   |       2 | 19227 |   | 19033 |	| 14796 |
| 15 GB   |       4 | 37335 |   | 37186 |	| 28923 |
| 15 GB   |       8 | 48130 |   | 50232 |	| 42281 |
| 15 GB   |      12 | 45393 |   | 44266 |	| 42763 |
| 15 GB   |      16 | 45110 |   | 43973 |	| 42647 |
| 15 GB   |      24 | 41415 |   | 39389 |	| 38844 |
| 15 GB   |      32 | 35988 |   | 36175 |	| 35247 |

For the performance one, a bit win here and a bit lost there, well,
since little float is there, I think at least, no regression.

But the powersaving one suffered some regression in low-end, is that the
sacrifice we supposed to do for power saving?

Regards,
Michael Wang

> 
> results:
> A, no clear performance change found on 'performance' policy.
> B, specjbb2005 drop 5~7% on both of policy whenever with openjdk or
>    jrockit on powersaving polocy
> C, hackbench drops 40% with powersaving policy on snb 4 sockets platforms.
> Others has no clear change.
> 
> ===
> Changelog:
> V6 change:
> a, remove 'balance' policy.
> b, consider RT task effect in balancing
> c, use avg_idle as burst wakeup indicator
> d, balance on task utilization in fork/exec/wakeup.
> e, no power balancing on SMT domain.
> 
> V5 change:
> a, change sched_policy to sched_balance_policy
> b, split fork/exec/wake power balancing into 3 patches and refresh
> commit logs
> c, others minors clean up
> 
> V4 change:
> a, fix few bugs and clean up code according to Morten Rasmussen, Mike
> Galbraith and Namhyung Kim. Thanks!
> b, take Morten Rasmussen's suggestion to use different criteria for
> different policy in transitory task packing.
> c, shorter latency in power aware scheduling.
> 
> V3 change:
> a, engaged nr_running and utilisation in periodic power balancing.
> b, try packing small exec/wake tasks on running cpu not idle cpu.
> 
> V2 change:
> a, add lazy power scheduling to deal with kbuild like benchmark.
> 
> 
> -- Thanks Alex
> [patch v6 01/21] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v6 02/21] sched: set initial value of runnable avg for new
> [patch v6 03/21] sched: only count runnable avg on cfs_rq's
> [patch v6 04/21] sched: add sched balance policies in kernel
> [patch v6 05/21] sched: add sysfs interface for sched_balance_policy
> [patch v6 06/21] sched: log the cpu utilization at rq
> [patch v6 07/21] sched: add new sg/sd_lb_stats fields for incoming
> [patch v6 08/21] sched: move sg/sd_lb_stats struct ahead
> [patch v6 09/21] sched: scale_rt_power rename and meaning change
> [patch v6 10/21] sched: get rq potential maximum utilization
> [patch v6 11/21] sched: detect wakeup burst with rq->avg_idle
> [patch v6 12/21] sched: add power aware scheduling in fork/exec/wake
> [patch v6 13/21] sched: using avg_idle to detect bursty wakeup
> [patch v6 14/21] sched: packing transitory tasks in wakeup power
> [patch v6 15/21] sched: add power/performance balance allow flag
> [patch v6 16/21] sched: pull all tasks from source group
> [patch v6 17/21] sched: no balance for prefer_sibling in power
> [patch v6 18/21] sched: add new members of sd_lb_stats
> [patch v6 19/21] sched: power aware load balance
> [patch v6 20/21] sched: lazy power balance
> [patch v6 21/21] sched: don't do power balance on share cpu power
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

