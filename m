Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaETJml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:42:41 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23330 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751461AbaETJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:42:39 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762551"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V3 00/10] workqueue: async worker destruction and worker attaching/detaching
Date: Tue, 20 May 2014 17:46:26 +0800
Message-ID: <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
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

 kernel/workqueue.c          |  394 ++++++++++++++-----------------------------
 kernel/workqueue_internal.h |    2 +
 2 files changed, 133 insertions(+), 263 deletions(-)

-- 
1.7.4.4

