Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab3CST3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:29:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933660Ab3CST3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:05 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904513"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 18/21] workqueue: read POOL_DISASSOCIATED bit under pool->lock
Date: Wed, 20 Mar 2013 03:28:18 +0800
Message-Id: <1363721306-2030-19-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:39,
	Serialize complete at 2013/03/20 03:27:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply move it to pool->lock C.S.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 21ef721..0c692d4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1611,11 +1611,10 @@ static struct worker *create_worker(struct worker_pool *pool)
 	 * remains stable across this function.  See the comments above the
 	 * flag definition for details.
 	 */
+	spin_lock_irq(&pool->lock);
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
-
 	/* successful, commit the pointer to idr */
-	spin_lock_irq(&pool->lock);
 	idr_replace(&pool->worker_idr, worker, worker->id);
 	spin_unlock_irq(&pool->lock);
 
-- 
1.7.7.6

