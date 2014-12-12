Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaLLKQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:16:14 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:55205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965640AbaLLKQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:07 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44952080"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/5] workqueue: fix bug when numa mapping is changed
Date: Fri, 12 Dec 2014 18:19:50 +0800
Message-ID: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue code has an assumption that the numa mapping is stable
after system booted.  It is incorrectly currently.

Yasuaki Ishimatsu hit a allocation failure bug when the numa mapping
between CPU and node is changed. This was the last scene:
 SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
  cache: kmalloc-192, object size: 192, buffer size: 192, default order: 1, min order: 0
  node 0: slabs: 6172, objs: 259224, free: 245741
  node 1: slabs: 3261, objs: 136962, free: 127656

Yasuaki Ishimatsu investigated that it happened in the following situation:

1) System Node/CPU before offline/online:
	       | CPU
	------------------------
	node 0 |  0-14, 60-74
	node 1 | 15-29, 75-89
	node 2 | 30-44, 90-104
	node 3 | 45-59, 105-119

2) A system-board (contains node2 and node3) is offline:
	       | CPU
	------------------------
	node 0 |  0-14, 60-74
	node 1 | 15-29, 75-89

3) A new system-board is online, two new node IDs are allocated
   for the two node of the SB, but the old CPU IDs are allocated for
   the SB, here the NUMA mapping between node and CPU is changed.
   (the node of CPU#30 is changed from node#2 to node#4, for example)
	       | CPU
	------------------------
	node 0 |  0-14, 60-74
	node 1 | 15-29, 75-89
	node 4 | 30-59
	node 5 | 90-119

4) now, the NUMA mapping is changed, but wq_numa_possible_cpumask
   which is the convenient NUMA mapping cache in workqueue.c is still outdated.
   thus pool->node calculated by get_unbound_pool() is incorrect.

5) when the create_worker() is called with the incorrect offlined
    pool->node, it is failed and the pool can't make any progress.

To fix this bug, we need to fixup the wq_numa_possible_cpumask and the
pool->node, it is done in patch2 and patch3.

patch1 fixes memory leak related wq_numa_possible_cpumask.
patch4 kill another assumption about how the numa mapping changed.
patch5 reduces the allocation fails when the node is offline or the node
is lack of memory.

The patchset is untested. It is sent for earlier review.

Thanks,
Lai.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Lai Jiangshan (5):
  workqueue: fix memory leak in wq_numa_init()
  workqueue: update wq_numa_possible_cpumask
  workqueue: fixup existing pool->node
  workqueue: update NUMA affinity for the node lost CPU
  workqueue: retry on NUMA_NO_NODE when create_worker() fails

 kernel/workqueue.c |  129 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 109 insertions(+), 20 deletions(-)

-- 
1.7.4.4

