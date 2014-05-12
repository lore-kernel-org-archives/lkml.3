Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaELGw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:52:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2376 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbaELGw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:52:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,1033,1389715200"; 
   d="scan'208";a="30389387"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/10 V2] workqueue: async worker destruction and worker attaching/detaching
Date: Mon, 12 May 2014 14:56:12 +0800
Message-ID: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140505150514.GI11231@htj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1-4: async worker destruction

Patch2 reduces the review burden. It will be easier to review the whole
patchset if we know destroy_worker() is forced to destroy idle workers only.

Patch5-10: worker attaching/detaching and simplify the workers management

The code which attaches a worker to the pool and detaches a worker from the pool
is unfolded in create_worker()/destroy_worker().
The patchset moves this attaching/detaching code out and wraps them.

patch3-4 moves the detaching code out from destroy_worker(), and make
manger_mutex only protects the detaching code only rather than
protects the whole worker-destruction path.

patch5-7 makes manger_mutex only protects the attaching code rather than the
whole worker-creation path.

patch8: rename manger_mutex to attach_mutex
patch9-10: moves the attaching code out from create_worker() and use it for
rescuer.


Lai Jiangshan (10):
  workqueue: use manager lock only to protect worker_idr
  workqueue: destroy_worker() should destroy idle workers only
  workqueue: async worker destruction
  workqueue: destroy worker directly in the idle timeout handler
  workqueue: separate iteration role from worker_idr
  workqueue: convert worker_idr to worker_ida
  workqueue: narrow the protection range of manager_mutex
  workqueue: rename manager_mutex to attach_mutex
  workqueue: separate pool-attaching code out from create_worker()
  workqueue: use generic attach/detach routine for rescuers

 kernel/workqueue.c          |  401 ++++++++++++++-----------------------------
 kernel/workqueue_internal.h |    1 +
 2 files changed, 126 insertions(+), 276 deletions(-)

-- 
1.7.4.4

