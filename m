Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaDPCoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:44:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52211 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDPCoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:07 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [RESEND PATCH V5 0/8] remove cpu_load idx
Date: Wed, 16 Apr 2014 10:43:21 +0800
Message-Id: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the cpu_load decay usage, we mixed the long term, short term load with
balance bias, randomly pick a big or small value according to balance 
destination or source. This mix is wrong, the balance bias should be based
on task moving cost between cpu groups, not on random history or instant load.
History load maybe diverage a lot from real load, that lead to incorrect bias.

like on busy_idx,
We mix history load decay and bias together. The ridiculous thing is, when 
all cpu load are continuous stable, long/short term load is same. then we 
lose the bias meaning, so any minimum imbalance may cause unnecessary task
moving. To prevent this funny thing happen, we have to reuse the 
imbalance_pct again in find_busiest_group().  But that clearly causes over
bias in normal time. If there are some burst load in system, it is more worse.

As to idle_idx:
Though I have some cencern of usage corretion, 
https://lkml.org/lkml/2014/3/12/247 but since we are working on cpu
idle migration into scheduler. The problem will be reconsidered. We don't
need to care it too much now.

In fact, the cpu_load decays can be replaced by the sched_avg decay, that 
also decays load on time. The balance bias part can fullly use fixed bias --
imbalance_pct, which is already used in newly idle, wake, forkexec balancing
and numa balancing scenarios.

This patch removed the cpu_load idx decay, since it can be replaced by
sched_avg feature. and left the imbalance_pct bias untouched.

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

[PATCH V5 1/8] sched: shortcut to remove load_idx
[PATCH V5 2/8] sched: remove rq->cpu_load[load_idx] array
[PATCH V5 3/8] sched: remove source_load and target_load
[PATCH V5 4/8] sched: remove LB_BIAS
[PATCH V5 5/8] sched: clean up cpu_load update
[PATCH V5 6/8] sched: rewrite update_cpu_load_nohz
[PATCH V5 7/8] sched: remove rq->cpu_load and rq->nr_load_updates
[PATCH V5 8/8] sched: rename update_*_cpu_load
