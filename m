Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab3BHDmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:42:45 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34640 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab3BHDmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:42:44 -0500
MIME-Version: 1.0
Date: Fri, 8 Feb 2013 11:42:43 +0800
Message-ID: <CAJd=RBBvE-5f1UyJGu32EHGVCXe6rVYY0010SKa56j7OvtPG7g@mail.gmail.com>
Subject: [PATCH 2/2] stop_machine: dequeue work before signal completion
From: Hillf Danton <dhillf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As checked with BUG_ON in the case of CPU_UP_PREPARE, we have to dequeue
work first for further actions, then stopper reaches sane and clear state.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/stop_machine.c	Fri Feb  8 11:22:44 2013
+++ b/kernel/stop_machine.c	Fri Feb  8 11:29:40 2013
@@ -342,8 +342,12 @@ static int __cpuinit cpu_stop_cpu_callba
 		kthread_stop(stopper->thread);
 		/* drain remaining works */
 		spin_lock_irq(&stopper->lock);
-		list_for_each_entry(work, &stopper->works, list)
+		while (!list_empty(&stopper->works)) {
+			work = list_first_entry(&stopper->works,
+					struct cpu_stop_work, list);
+			list_del_init(&work->list);
 			cpu_stop_signal_done(work->done, false);
+		}
 		stopper->enabled = false;
 		spin_unlock_irq(&stopper->lock);
 		/* release the stopper */
--
