Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3H2NlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:41:12 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:39773 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3H2NlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:41:11 -0400
Date: Thu, 29 Aug 2013 09:41:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jamie Liu <jamieliu@google.com>
Subject: [GIT PULL] workqueue fixes for v3.11-rc7
Message-ID: <20130829134107.GA3985@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains one fix which could lead to system-wide
lockup on !PREEMPT kernels.  It's very late in the cycle but this
definitely is a -stable material.

The problem is that workqueue worker tasks may process unlimited
number of work items back-to-back without every yielding inbetween.
This usually isn't noticeable but a work item which re-queues itself
waiting for someone else to do something can deadlock with
stop_machine.  stop_machine will ensure nothing else happens on all
other cpus and the requeueing work item will reqeueue itself
indefinitely without ever yielding and thus preventing the CPU from
entering stop_machine.

Kudos to Jamie Liu for spotting and diagnosing the problem.  This can
be trivially fixed by adding cond_resched() after processing each work
item.

Thanks.

The following changes since commit c95389b4cd6a4b52af78bea706a274453e886251:

  Merge branch 'akpm' (patches from Andrew Morton) (2013-08-28 19:31:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.11-fixes

for you to fetch changes up to b22ce2785d97423846206cceec4efee0c4afd980:

  workqueue: cond_resched() after processing each work item (2013-08-29 09:19:28 -0400)

----------------------------------------------------------------
Tejun Heo (1):
      workqueue: cond_resched() after processing each work item

 kernel/workqueue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..e93f7b9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2201,6 +2201,15 @@ __acquires(&pool->lock)
 		dump_stack();
 	}
 
+	/*
+	 * The following prevents a kworker from hogging CPU on !PREEMPT
+	 * kernels, where a requeueing work item waiting for something to
+	 * happen could deadlock with stop_machine as such work item could
+	 * indefinitely requeue itself while all other CPUs are trapped in
+	 * stop_machine.
+	 */
+	cond_resched();
+
 	spin_lock_irq(&pool->lock);
 
 	/* clear cpu intensive status */
