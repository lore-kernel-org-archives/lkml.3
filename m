Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3CST2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:28:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36232 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932810Ab3CST2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:44 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904499"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/21] workqueue: swap the two branches in pwq_adjust_max_active() to get better readability
Date: Wed, 20 Mar 2013 03:28:04 +0800
Message-Id: <1363721306-2030-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:18,
	Serialize complete at 2013/03/20 03:27:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"if (!freezable || !(pwq->pool->flags & POOL_FREEZING))" is hard to read.

Swap the two branches. it becomes
"if (freezable && (pwq->pool->flags & POOL_FREEZING))", it is better.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e1b31fc..8c882ae 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3592,14 +3592,14 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	if (freezable && (pwq->pool->flags & POOL_FREEZING)) {
+		pwq->max_active = 0;
+	} else {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
 		       pwq->nr_active < pwq->max_active)
 			pwq_activate_first_delayed(pwq);
-	} else {
-		pwq->max_active = 0;
 	}
 
 	spin_unlock(&pwq->pool->lock);
-- 
1.7.7.6

