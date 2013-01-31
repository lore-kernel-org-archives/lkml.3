Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3AaSmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:42:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38873 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab3AaSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672831"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/13] workqueue: enhance locking and record global worker id for work data
Date: Fri, 1 Feb 2013 02:41:23 +0800
Message-Id: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:41,
	Serialize complete at 2013/02/01 02:40:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better Locking:
---------

We have a much complex way to find out on which pool a given work is queued on,
mainly based on *mb() which is the most dangerous code and bad for readability.
This series change the usage of CWQ bit and makes these code simpler.
	--PATCH 3,4,5

We have get_work_pool(), but it requires the caller do the later check and locking,
we replace it which 3 better internal locking API. 1) More proper API and
2) merge the duplicated code and 3) simplify the caller.
	--PATCH 8,9,10

get_work_pool()/get_work_pool_id() are called everywhere, something they are
overkill(called idr_find() unneeded) and indirectly(caller knows it is onq or not),
we replace them with get_work_cwq()/offq_work_pool_id()/locking APIs.
	--PATCH 3,4,5,6,8,9,10


Safely/one-step searching and worker id:
----------------------------------------

We are planing to add non-std worker_pool, but old get_work_pool() or new
lock_pool_executing_work() was not prepared for this plan, idr_find(pool_id)
is unsafe when we introduce free-able non-std worker_pool. Although we can
fix it by adding rcu to worker_pool. but "recording global worker id for
work data and adding rcu to worker" is another way and more straight forward.
We implement the later one,  Now, lock_pool_executing_work() is ready for this plan.
	--PATCH 12,13

When every time we need to find out the running worker from a work,
we need two searches: search work_pool from work's data, and search worker
from hash. We record global worker id for work data and we only need one search.
	--PATCH 13

cleanup
	--PATCH 1,2,7,11

On top of tj/for-3.9 706026c2141113886f61e1ad2738c9a7723ec69c

Lai Jiangshan (13):
  workqueue: remove WORK_CPU_NONE
  workqueue: fix work_busy()
  workqueue: don't set work cwq until we queued it on pool
  workqueue: clear cwq when cancel the work
  workqueue: change queued detection and remove *mb()s
  workqueue: get pool id from work->data directly if it is offq
  workqueue: get pool from wq/cwq
  workqueue: add lock_pool_executing_work()
  workqueue: add lock_pool_queued_work()
  workqueue: add lock_pool_own_work() and remove get_work_pool()
  workqueue: allow more work_pool id space
  workqueue: add worker's global worker ID
  workqueue: record global worker ID instead of pool ID in work->data
    when off-queue

 include/linux/workqueue.h   |   24 ++--
 kernel/workqueue.c          |  428 +++++++++++++++++++++++--------------------
 kernel/workqueue_internal.h |    1 +
 3 files changed, 242 insertions(+), 211 deletions(-)

-- 
1.7.7.6

