Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaDRNWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:22:33 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11381 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755003AbaDRNWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:22:23 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29446816"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2 V4] workqueue: fix possible race condition when rescuer VS  pwq-release
Date: Fri, 18 Apr 2014 21:25:55 +0800
Message-ID: <1397827555-19641-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140417162720.GQ15326@htj.dyndns.org>
 <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between rescuer_thread() and
pwq_unbound_release_workfn().

The works of the @pwq may be processed by some other workers,
and @pwq is scheduled to release(due to its wq's attr is changed)
before the rescuer starts to process. In this case
pwq_unbound_release_workfn() will corrupt wq->maydays list,
and rescuer_thead() will access to corrupted data.

Using get_pwq() pin it until rescuer is done with it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7539244..8c0830c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1916,6 +1916,16 @@ static void send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	if (list_empty(&pwq->mayday_node)) {
+		/*
+		 * pwqs might go away at any time, pin it until the
+		 * rescuer is done with it.
+		 *
+		 * Especially a pwq of an unbound wq may be released
+		 * before wq's destruction when the wq's attr is changed.
+		 * In this case, pwq_unbound_release_workfn() may execute
+		 * earlier before rescuer_thread() and corrupt wq->maydays.
+		 */
+		get_pwq(pwq);
 		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
 	}
@@ -2447,6 +2457,9 @@ repeat:
 
 		process_scheduled_works(rescuer);
 
+		/* put the reference grabbed by send_mayday(). */
+		put_pwq(pwq);
+
 		/*
 		 * Leave this pool.  If keep_working() is %true, notify a
 		 * regular worker; otherwise, we end up with 0 concurrency
-- 
1.7.4.4

