Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3GXQZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:25:49 -0400
Received: from mail-gh0-f169.google.com ([209.85.160.169]:59107 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3GXQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:25:47 -0400
Date: Wed, 24 Jul 2013 12:25:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH] workqueue: allow work_on_cpu() to be called recursively
Message-ID: <20130724162542.GE20377@mtj.dyndns.org>
References: <51E55B7D.2040209@linux.vnet.ibm.com>
 <51E66CCC.9010600@cn.fujitsu.com>
 <51E84EDC.5090502@linux.vnet.ibm.com>
 <51E89ABB.20808@cn.fujitsu.com>
 <51E8FF76.5030706@linux.vnet.ibm.com>
 <51ED1D02.80205@cn.fujitsu.com>
 <20130722213231.GC16776@mtj.dyndns.org>
 <51EDDB02.20502@cn.fujitsu.com>
 <20130723143841.GA18458@mtj.dyndns.org>
 <51EFAD0E.20303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFAD0E.20303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to wq/for-3.11-fixes with comment and subject tweaks.

Thanks!

---------- 8< ------------

>From c2fda509667b0fda4372a237f5a59ea4570b1627 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 18:31:42 +0800

If the @fn call work_on_cpu() again, the lockdep will complain:

> [ INFO: possible recursive locking detected ]
> 3.11.0-rc1-lockdep-fix-a #6 Not tainted
> ---------------------------------------------
> kworker/0:1/142 is trying to acquire lock:
>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81077100>] flush_work+0x0/0xb0
>
> but task is already holding lock:
>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock((&wfc.work));
>   lock((&wfc.work));
>
>  *** DEADLOCK ***

It is false-positive lockdep report. In this sutiation,
the two "wfc"s of the two work_on_cpu() are different,
they are both on stack. flush_work() can't be deadlock.

To fix this, we need to avoid the lockdep checking in this case,
thus we instroduce a internal __flush_work() which skip the lockdep.

tj: Minor comment adjustment.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reported-by: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Reported-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..55f5f0a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2817,6 +2817,19 @@ already_gone:
 	return false;
 }
 
+static bool __flush_work(struct work_struct *work)
+{
+	struct wq_barrier barr;
+
+	if (start_flush_work(work, &barr)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else {
+		return false;
+	}
+}
+
 /**
  * flush_work - wait for a work to finish executing the last queueing instance
  * @work: the work to flush
@@ -2830,18 +2843,10 @@ already_gone:
  */
 bool flush_work(struct work_struct *work)
 {
-	struct wq_barrier barr;
-
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
-	if (start_flush_work(work, &barr)) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
-		return true;
-	} else {
-		return false;
-	}
+	return __flush_work(work);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -4756,7 +4761,14 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
 	schedule_work_on(cpu, &wfc.work);
-	flush_work(&wfc.work);
+
+	/*
+	 * The work item is on-stack and can't lead to deadlock through
+	 * flushing.  Use __flush_work() to avoid spurious lockdep warnings
+	 * when work_on_cpu()s are nested.
+	 */
+	__flush_work(&wfc.work);
+
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
-- 
1.8.3.1

