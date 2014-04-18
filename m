Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaDRQfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:35:20 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:51507 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaDRQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:35:11 -0400
Date: Fri, 18 Apr 2014 12:35:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] workqueue: fix a possible race condition between rescuer
 and pwq-release
Message-ID: <20140418163508.GD12515@htj.dyndns.org>
References: <20140417162720.GQ15326@htj.dyndns.org>
 <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
 <1397827555-19641-2-git-send-email-laijs@cn.fujitsu.com>
 <20140418150653.GB12515@htj.dyndns.org>
 <CACvQF51a-babdUSBiREEsSv=1keiQCTJh-sZFrtFXn9iUHegOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF51a-babdUSBiREEsSv=1keiQCTJh-sZFrtFXn9iUHegOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, you're right.  Fixed.

Thanks.
------ 8< ------
>From 77668c8b559e4fe2acf2a0749c7c83cde49a5025 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Apr 2014 11:04:16 -0400

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
Cc: stable@vger.kernel.org # v3.10+
---
 kernel/workqueue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6ba0c60..8edc871 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1916,6 +1916,12 @@ static void send_mayday(struct work_struct *work)
 
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
@@ -2450,6 +2456,12 @@ repeat:
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
1.9.0

