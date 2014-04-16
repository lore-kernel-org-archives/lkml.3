Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161477AbaDPXau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:30:50 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15625 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756908AbaDPXam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:30:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,875,1389715200"; 
   d="scan'208";a="29364838"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2] workqueue: fix possible race condition when rescuer VS  pwq-release
Date: Thu, 17 Apr 2014 07:34:09 +0800
Message-ID: <1397691258-11639-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140416165052.GK1257@htj.dyndns.org>
 <1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
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
index 832125f..77c29b7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1916,6 +1916,16 @@ static void send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	if (list_empty(&pwq->mayday_node)) {
+		/*
+		 * pwqs might go away at any time, pin it until
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
@@ -2438,6 +2448,9 @@ repeat:
 
 		process_scheduled_works(rescuer);
 
+		/* put the reference grabbed by send_mayday(). */
+		put_pwq(pwq);
+
 		/*
 		 * Leave this pool.  If keep_working() is %true, notify a
 		 * regular worker; otherwise, we end up with 0 concurrency
-- 
1.7.4.4

