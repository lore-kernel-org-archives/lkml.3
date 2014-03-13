Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaCMF6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 01:58:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44885 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaCMF6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 01:58:47 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: [ PATCH 0/8] sched: remove cpu_load array
Date: Thu, 13 Mar 2014 13:57:21 +0800
Message-Id: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the cpu_load decay usage, we mixed the long term, short term load with
balance bias, randomly pick a big/small value from them according to balance 
destination or source. This mix is wrong, the balance bias should be based
on task moving cost between cpu groups, not on random history or instant load.
History load maybe diverage a lot from real load, that lead to incorrect bias.

In fact, the cpu_load decays can be replaced by the sched_avg decay, that 
also decays load on time. The balance bias part can fullly use fixed bias --
imbalance_pct, which is already used in newly idle, wake, forkexec balancing
and numa balancing scenarios.

Currently the only working idx is busy_idx and idle_idx.
As to busy_idx:
We mix history load decay and bias together. The ridiculous thing is, when 
all cpu load are continuous stable, long/short term load is same. then we 
lose the bias meaning, so any minimum imbalance may cause unnecessary task
moving. To prevent this funny thing happen, we have to reuse the 
imbalance_pct again in find_busiest_group().  But that clearly causes over
bias in normal time. If there are some burst load in system, it is more worse.

As to idle_idx:
Though I have some cencern of usage corretion, 
https://lkml.org/lkml/2014/3/12/247, but since we are working on cpu
idle migration into scheduler. The problem will be reconsidered. We don't
need to care it now.

This patch removed the cpu_load idx decay, since it can be replaced by
sched_avg feature. and left the imbalance_pct bias untouched, since only 
idle_idx missed it, but it is fine. and will be reconsidered soon.


V5,
1, remove unify bias patch and biased_load function. Thanks for PeterZ's 
comments!
2, remove get_sd_load_idx() in the 1st patch as SrikarD's suggestion.
3, remove LB_BIAS feature, it is not needed now.

V4,
1, rebase on latest tip/master
2, replace target_load by biased_load as Morten's suggestion

V3,
1, correct the wake_affine bias. Thanks for Morten's reminder!
2, replace source_load by weighted_cpuload for better function name meaning.

V2,
1, This version do some tuning on load bias of target load.
2, Got further to remove the cpu_load in rq.
3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs

Any testing/comments are appreciated.

This patch rebase on latest tip/master.
The git tree for this patchset at:
 git@github.com:alexshi/power-scheduling.git noload

Thanks
    Alex

 [PATCH 1/8] sched: shortcut to remove load_idx
 [PATCH 2/8] sched: remove rq->cpu_load[load_idx] array
 [PATCH 3/8] sched: remove source_load and target_load
 [PATCH 4/8] sched: remove LB_BIAS
 [PATCH 5/8] sched: clean up cpu_load update
 [PATCH 6/8] sched: rewrite update_cpu_load_nohz
 [PATCH 7/8] sched: remove rq->cpu_load and rq->nr_load_updates
 [PATCH 8/8] sched: rename update_*_cpu_load
