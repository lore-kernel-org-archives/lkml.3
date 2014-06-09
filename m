Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936486AbaFIJ2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:28:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933579AbaFIJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/146] workqueue: fix a possible race condition between rescuer and pwq-release
Date: Mon,  9 Jun 2014 10:50:38 +0200
Message-Id: <faad6139a324ab020b9b1c4c82358d4ce6948fe1.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 77668c8b559e4fe2acf2a0749c7c83cde49a5025 upstream.

There is a race condition between rescuer_thread() and
pwq_unbound_release_workfn().

Even after a pwq is scheduled for rescue, the associated work items
may be consumed by any worker.  If all of them are consumed before the
rescuer gets to them and the pwq's base ref was put due to attribute
change, the pwq may be released while still being linked on
@wq->maydays list making the rescuer dereference already freed pwq
later.

Make send_mayday() pin the target pwq until the rescuer is done with
it.

tj: Updated comment and patch description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/workqueue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9ae0693ca520..c0b6eb1e0b83 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1901,6 +1901,12 @@ static void send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	if (list_empty(&pwq->mayday_node)) {
+		/*
+		 * If @pwq is for an unbound wq, its base ref may be put at
+		 * any time due to an attribute change.  Pin @pwq until the
+		 * rescuer is done with it.
+		 */
+		get_pwq(pwq);
 		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
 	}
@@ -2430,6 +2436,12 @@ repeat:
 		process_scheduled_works(rescuer);
 
 		/*
+		 * Put the reference grabbed by send_mayday().  @pool won't
+		 * go away while we're holding its lock.
+		 */
+		put_pwq(pwq);
+
+		/*
 		 * Leave this pool.  If keep_working() is %true, notify a
 		 * regular worker; otherwise, we end up with 0 concurrency
 		 * and stalling the execution.
-- 
1.9.3

