Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaGNHSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:18:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:45430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaGNHSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,656,1400050800"; 
   d="scan'208";a="569384953"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 0/2 v2] sched: Rewrite per entity runnable load average tracking 
Date: Mon, 14 Jul 2014 07:15:50 +0800
Message-Id: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is really imbalanced in size.

The 1/2 patch is not simply resending, but for two reasons: 1) this rewrite
does not include rq's runnable load_avg, and 2) more importantly, I want to
reduce the size of the 2/2 patch, this is the only way I know how.

The 2/2 patch is very big. Sorry for that, but as this patch is a rewrite, I can
only do it in an all-or-nothing manner. Splitting it will not make each small one
compile or correctly function.

I'd like to thank PeterZ and Ben for their help in fixing the issues and improving
the quality in this version. And Fengguang and his 0Day in finding compile errors
in different configurations.

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

 include/linux/sched.h |   13 +-
 kernel/sched/debug.c  |   32 +--
 kernel/sched/fair.c   |  644 ++++++++++++++++++++-----------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   34 +--
 5 files changed, 287 insertions(+), 438 deletions(-)

-- 
1.7.9.5

