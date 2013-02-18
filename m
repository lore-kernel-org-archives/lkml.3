Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3BRQOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59377 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3BRQOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:15 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724949"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 10/15] workqueue: avoid unneeded calls to get_work_cwq()
Date: Tue, 19 Feb 2013 00:12:11 +0800
Message-Id: <1361203940-6300-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:37,
	Serialize complete at 2013/02/19 00:13:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use already-known "cwq" instead of get_work_cwq(work) in try_to_grab_pending()
and cwq_activate_first_delayed().

It avoid unneeded calls to get_work_cwq() which becomes not so light-way
in later patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e14a03e..7ac6824 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1012,10 +1012,9 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
-static void cwq_activate_delayed_work(struct work_struct *work)
+static void cwq_activate_delayed_work(struct work_struct *work,
+				      struct cpu_workqueue_struct *cwq)
 {
-	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
-
 	trace_workqueue_activate_work(work);
 	move_linked_works(work, &cwq->pool->worklist, NULL);
 	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
@@ -1027,7 +1026,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
 
-	cwq_activate_delayed_work(work);
+	cwq_activate_delayed_work(work, cwq);
 }
 
 /**
@@ -1147,10 +1146,10 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		 * item is activated before grabbing.
 		 */
 		if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
-			cwq_activate_delayed_work(work);
+			cwq_activate_delayed_work(work, cwq);
 
 		list_del_init(&work->entry);
-		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
+		cwq_dec_nr_in_flight(cwq, get_work_color(work));
 
 		/* work is dequeued, work->data points to pool iff running */
 		if (worker)
-- 
1.7.7.6

