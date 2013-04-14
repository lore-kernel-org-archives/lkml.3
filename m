Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3DNQoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:44:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3DNQoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:44:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051550"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/8] workqueue: move worker->flags up
Date: Mon, 15 Apr 2013 00:41:55 +0800
Message-Id: <1365957716-7631-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:46,
	Serialize complete at 2013/04/15 00:41:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker->flags is hot field(accessed when process each work item).
Move it up the the first 64 bytes(32 byte in 32bis) which are
hot fields.

And move colder field worker->task down to ensure worker->pool is
still in the first 64 bytes.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue_internal.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index e9fd05f..63cfac7 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -20,6 +20,7 @@ struct worker_pool;
  * Only to be used in workqueue and async.
  */
 struct worker {
+	unsigned int		flags;		/* LI: flags */
 	/* on idle list while idle, on busy hash table while busy */
 	union {
 		struct list_head	entry;	/* L: while idle */
@@ -30,12 +31,11 @@ struct worker {
 	work_func_t		current_func;	/* L: current_work's fn */
 	struct pool_workqueue	*current_pwq; /* L: current_work's pwq */
 	struct list_head	scheduled;	/* L: scheduled works */
-	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
+	struct task_struct	*task;		/* I: worker task */
 	unsigned long		last_active;	/* L: last active timestamp */
-	unsigned int		flags;		/* LI: flags */
 	int			id;		/* I: worker id */
 
 	/* used only by rescuers to point to the target workqueue */
-- 
1.7.7.6

