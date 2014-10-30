Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaJaHb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:31:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:52623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaJaHb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:31:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408960465"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com, dietmar.eggemann@arm.com,
        umgwanakikbuti@gmail.com, Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 0/3 v6] sched: Rewrite per entity runnable load average tracking
Date: Fri, 31 Oct 2014 07:32:25 +0800
Message-Id: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks to PeterZ for his review, to Dietmar, and to Fengguang for 0Day and LKP.

v6 changes:

Based on v3.18-rc2.

- Unify decay_load 32 and 64 bits by mul_u64_u32_shr
- Add force option in update_tg_load_avg
- Read real-time cfs's load_avg for calc_tg_weight
- Have tg_load_avg_contrib ifdef CONFIG_FAIR_GROUP_SCHED
- Bug fix

v5 changes:

Thank Peter intensively for reviewing this patchset in detail and all his comments.
And Mike for general and cgroup pipe-test. Morten, Ben, and Vincent in the discussion.

- Remove dead task and task group load_avg
- Do not update trivial delta to task_group load_avg (threshold 1/64 old_contrib)
- mul_u64_u32_shr() is used in decay_load, so on 64bit, load_sum can afford
  about 4353082796 (=2^64/47742/88761) entities with the highest weight (=88761)
  always runnable, greater than previous theoretical maximum 132845
- Various code efficiency and style changes

We carried out some performance tests (thanks to Fengguang and his LKP). The results
are shown as follows. The patchset (including threepatches) is on top of mainline
v3.16-rc5. We may report more perf numbers later.

Overall, this rewrite has better performance, and reduced net overhead in load
average tracking, flat efficiency in multi-layer cgroup pipe-test.

v4 changes:

Thanks to Morten, Ben, and Fengguang for v4 revision.

- Insert memory barrier before writing cfs_rq->load_last_update_copy.
- Fix typos.

v3 changes:

Many thanks to Ben for v3 revision.

Regarding the overflow issue, we now have for both entity and cfs_rq:

struct sched_avg {
    .....
    u64 load_sum;
    unsigned long load_avg;
    .....
};

Given the weight for both entity and cfs_rq is:

struct load_weight {
    unsigned long weight;
    .....
};

So, load_sum's max is 47742 * load.weight (which is unsigned long), then on 32bit,
it is absolutly safe. On 64bit, with unsigned long being 64bit, but we can afford
about 4353082796 (=2^64/47742/88761) entities with the highest weight (=88761)
always runnable, even considering we may multiply 1<<15 in decay_load64, we can
still support 132845 (=4353082796/2^15) always runnable, which should be acceptible.

load_avg = load_sum / 47742 = load.weight (which is unsigned long), so it should be
perfectly safe for both entity (even with arbitrary user group share) and cfs_rq on
both 32bit and 64bit. Originally, we saved this division, but have to get it back
because of the overflow issue on 32bit (actually load average itself is safe from
overflow, but the rest of the code referencing it always uses long, such as cpu_load,
etc., which prevents it from saving).

- Fix overflow issue both for entity and cfs_rq on both 32bit and 64bit.
- Track all entities (both task and group entity) due to group entity's clock issue.
  This actually improves code simplicity.
- Make a copy of cfs_rq sched_avg's last_update_time, to read an intact 64bit
  variable on 32bit machine when in data race (hope I did it right).
- Minor fixes and code improvement.

v2 changes:

Thanks to PeterZ and Ben for their help in fixing the issues and improving
the quality, and Fengguang and his 0Day in finding compile errors in different
configurations for version 2.

- Batch update the tg->load_avg, making sure it is up-to-date before update_cfs_shares
- Remove migrating task from the old CPU/cfs_rq, and do so with atomic operations

Yuyang Du (3):
  sched: Remove update_rq_runnable_avg
  sched: Rewrite per entity runnable load average tracking
  sched: Remove task and group entity load_avg when they are dead

 include/linux/sched.h |   21 +-
 kernel/sched/debug.c  |   29 +--
 kernel/sched/fair.c   |  584 ++++++++++++++++---------------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   24 +-
 5 files changed, 215 insertions(+), 445 deletions(-)

-- 
1.7.9.5

