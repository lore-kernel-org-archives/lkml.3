Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaD0EFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:05:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44510 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474AbaD0EF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778301"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/10] workqueue: async worker destruction and pool-binding synchronization
Date: Sun, 27 Apr 2014 12:08:55 +0800
Message-ID: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1-4: async worker destruction

The old version(https://lkml.org/lkml/2014/2/17/418) code of async worker
destruction has to dance with pool->lock and worker_idr, it is complicated.

But worker_idr in the new version dosn't requies pool->lock, and the code in
put_unbound_pool() which waits workers exit is changed to wait on a
wait_queue_head_t. These two changes make the new async worker destruction
much simpler.

Patch2 reduces the review burden. It will be easier to review the whole
patchset if we know destroy_worker() is forced to destroy idle workers only.

==========
Patch5-10: pool-binding synchronization and simplify the workers management

The code which binds a worker to the pool and unbind a worker from the pool
is unfolded in create_worker()/destroy_worker().
The patchset moves this pool-binding code out and wraps them.

patch3-4 moves the pool-unbinding code out from destroy_worker(), and make
manger_mutex only protects the pool-unbinding code only rather than
protects the whole worker-destruction path.

patch5-7 makes manger_mutex only protects the pool-binding code rather than the
whole worker-creation path.

patch8: rename manger_mutex to bind_mutex
patch9-10: moves the pool-binding code out from create_worker() and use it for
rescuer.

Lai Jiangshan (10):
  workqueue: use manager lock only to protect worker_idr
  workqueue: destroy_worker() should destroy idle workers only
  workqueue: async worker destruction
  workqueue: destroy worker directly in the idle timeout handler
  workqueue: separate iteration role from worker_idr
  workqueue: convert worker_idr to worker_ida
  workqueue: narrow the protection range of manager_mutex
  workqueue: rename manager_mutex to bind_mutex
  workqueue: separate pool-binding code out from create_worker()
  workqueue: use generic pool-bind/unbind routine for rescuers

 kernel/workqueue.c          |  396 +++++++++++++------------------------------
 kernel/workqueue_internal.h |    1 +
 2 files changed, 120 insertions(+), 277 deletions(-)

-- 
1.7.4.4

