Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaFEAM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:12:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaFDXWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 154/228] workqueue: fix a possible race condition between rescuer and pwq-release
Date: Wed,  4 Jun 2014 16:23:03 -0700
Message-Id: <20140604232352.968416244@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1909,6 +1909,12 @@ static void send_mayday(struct work_stru
 
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
@@ -2438,6 +2444,12 @@ repeat:
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


