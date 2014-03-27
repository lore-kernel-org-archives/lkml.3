Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbaC0Qch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:32:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42014 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbaC0Qcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:32:35 -0400
X-IronPort-AV: E=Sophos;i="4.97,743,1389715200"; 
   d="scan'208";a="9779053"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: fix possible race condition when rescuer VS pwq-release
Date: Fri, 28 Mar 2014 00:20:12 +0800
Message-Id: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/28 00:17:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/28 00:17:25,
	Serialize complete at 2014/03/28 00:17:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between rescuer_thread() and
pwq_unbound_release_workfn().

The works of the @pwq may be processed by some other worker,
and @pwq is scheduled to release before the rescuer starts
to process. In this case pwq_unbound_release_workfn() will
corrupt wq->maydays, and rescuer_thead will access to corrupted
data.

Using get_pwq() when send_mayday() will keep @pwq's lifetime
and avoid the race condition.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..7066519 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1902,6 +1902,12 @@ static void send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	if (list_empty(&pwq->mayday_node)) {
+		/*
+		 * Keep the pwq and avoid the pwq to be scheduled to release
+		 * when someone else processes all the works before the rescuer
+		 * starts to process.
+		 */
+		get_pwq(pwq);
 		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
 	}
@@ -2418,6 +2424,7 @@ repeat:
 		/* migrate to the target cpu if possible */
 		worker_maybe_bind_and_lock(pool);
 		rescuer->pool = pool;
+		put_pwq(pwq);
 
 		/*
 		 * Slurp in all works issued via this workqueue and
-- 
1.7.7.6

