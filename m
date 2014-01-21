Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaAUJbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:31:12 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43436 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaAUJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:31:08 -0500
Date: Tue, 21 Jan 2014 04:31:03 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for v3.14-rc1
Message-ID: <20140121093103.GA6928@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Just one patch to add destroy_work_on_stack() annotations to help
debugobj debugging.  The change is almost trivial but unfortunately
causes the following merge conflict.

  long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
  {
	  struct work_for_cpu wfc = { .fn = fn, .arg = arg };

	  INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
	  schedule_work_on(cpu, &wfc.work);
  <<<<<<< HEAD
	  flush_work(&wfc.work);
  =======

	  /*
	   * The work item is on-stack and can't lead to deadlock through
	   * flushing.  Use __flush_work() to avoid spurious lockdep warnings
	   * when work_on_cpu()s are nested.
	   */
	  __flush_work(&wfc.work);

	  destroy_work_on_stack(&wfc.work);
  >>>>>>> 440a11360326044a9addf1c652a0364aad0be90c
	  return wfc.ret;
  }

The conflict is between the following two commits.

* master	12997d1a999c ("Revert "workqueue: allow work_on_cpu() to be called recursively"")
* wq/for-3.14	440a11360326 ("workqueue: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()")

The former updated work_on_cpu() to drop __flush_work() change to
allow recursive work_on_cpu() usage which no longer was necessary
after PCI update.  The latter added destroy_work_on_stack() call to
the function thus causing context conflict.  It can be easily resolved
by adding destroy_work_on_stack() to the version in master.

  long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
  {
	  struct work_for_cpu wfc = { .fn = fn, .arg = arg };

	  INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
	  schedule_work_on(cpu, &wfc.work);
	  flush_work(&wfc.work);
	  destroy_work_on_stack(&wfc.work);
	  return wfc.ret;
  }

The merge is also available in the test-merge-3.14 branch of wq tree.

The changes are available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.14

for you to fetch changes up to 440a11360326044a9addf1c652a0364aad0be90c:

  workqueue: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK() (2014-01-11 22:26:33 -0500)

Thanks.
----------------------------------------------------------------
Chuansheng Liu (1):
      workqueue: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()

 kernel/workqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..00df112 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4776,6 +4776,7 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 
 		/* wait for per-cpu unbinding to finish */
 		flush_work(&unbind_work);
+		destroy_work_on_stack(&unbind_work);
 		break;
 	}
 	return NOTIFY_OK;
@@ -4822,6 +4823,7 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 	 */
 	__flush_work(&wfc.work);
 
+	destroy_work_on_stack(&wfc.work);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
