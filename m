Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaFCH11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:27:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:9469 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbaFCH10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:27:26 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368473"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: use "pool->cpu < 0" to stand for an unbound pool
Date: Tue, 3 Jun 2014 15:31:45 +0800
Message-ID: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a piece of sanity checks code in the put_unbound_pool().
The meaning of this code is "if it is not an unbound pool, it will complain
and return" IIUC. But the code uses "pool->flags & POOL_DISASSOCIATED"
imprecisely due to a non-unbound pool may also have this flags.

We should use "pool->cpu < 0" to stand for an unbound pool, so we covert the
code to it.

There is no strictly wrong if we still keep "pool->flags & POOL_DISASSOCIATED"
here, but it is just a noise if we keep it:
  1) we focus on "unbound" here, not "[dis]association".
  2) "pool->cpu < 0" already implies "pool->flags & POOL_DISASSOCIATED".

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90a0fa5..724ae35 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3457,7 +3457,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 		return;
 
 	/* sanity checks */
-	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
+	if (WARN_ON(!(pool->cpu < 0)) ||
 	    WARN_ON(!list_empty(&pool->worklist)))
 		return;
 
-- 
1.7.4.4

