Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbaGPJxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:53:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:9133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551AbaGPJxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:53:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,671,1400050800"; 
   d="scan'208";a="562552297"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com, umgwanakikbuti@gmail.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 0/2 v3] sched: Rewrite per entity runnable load average tracking
Date: Wed, 16 Jul 2014 09:50:45 +0800
Message-Id: <1405475447-7783-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Many thanks to Ben for this revision.

v3 changes:

- Fix overflow issue both for entity and cfs_rq on both 32bit and 64bit.
- Track all entities (both task and group entity) due to group entity's clock issue.
  This actually improves code simplicity.
- Make a copy of cfs_rq sched_avg's last_update_time, to read an intact 64bit
  variable on 64bit machine when in data race (hope I did it right).
- Minor fixes and code improvement.

Thanks to PeterZ and Ben for their help in fixing the issues and improving
the quality, and Fengguang and his 0Day in finding compile errors in different
configurations for version 2.

v2 changes:

- Batch update the tg->load_avg, making sure it is up-to-date before update_cfs_shares
- Remove migrating task from the old CPU/cfs_rq, and do so with atomic operations
- Retrack lod_avg of group's entities (if any), since we need it in task_h_load calc,
  and do it along with its own cfs_rq's update
- Fix 32bit overflow issue of cfs_rq's load_avg, now it is 64bit, should be safe
- Change load.weight in effective_load which uses runnable load_avg consistently


Yuyang Du (2):
  sched: Remove update_rq_runnable_avg
  sched: Rewrite per entity runnable load average tracking

 include/linux/sched.h |   21 +-
 kernel/sched/debug.c  |   30 +--
 kernel/sched/fair.c   |  565 ++++++++++++++++---------------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   22 +-
 5 files changed, 206 insertions(+), 434 deletions(-)

-- 
1.7.9.5

