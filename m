Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBXDjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:39:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:23279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaBXDjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:39:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,532,1389772800"; 
   d="scan'208";a="488459858"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        Xiaoming Wang <xiaoming.wang@intel.com>
Subject: [PATCH] genirq: Fix the possible synchronize_irq() wait-forever
Date: Mon, 24 Feb 2014 11:29:50 +0800
Message-Id: <1393212590-32543-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We hit one rare case below:
T1 calling disable_irq(), but hanging at synchronize_irq()
always;
The corresponding irq thread is in sleeping state;
And all CPUs are in idle state;

After analysis, we found there is one possible scenerio which
causes T1 is waiting there forever:
CPU0                                       CPU1
 synchronize_irq()
  wait_event()
    spin_lock()
                                           atomic_dec_and_test(&threads_active)
      insert the __wait into queue
    spin_unlock()
                                           if(waitqueue_active)
    atomic_read(&threads_active)
                                             wait_up()

Here after inserted the __wait into queue on CPU0, and before
test if queue is empty on CPU1, there is no barrier, it maybe
cause it is not visible for CPU1 immediately, although CPU0 has
updated the queue list.
It is similar for CPU0 atomic_read() threads_active also.

So we need one smp_mb() before waitqueue_active or something like
that.

Thomas shared one good option that removing waitqueue_active()
judgement directly, it will make things to be simple and clear.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiaoming Wang <xiaoming.wang@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 kernel/irq/manage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..d3bf660 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -802,8 +802,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 
 static void wake_threads_waitq(struct irq_desc *desc)
 {
-	if (atomic_dec_and_test(&desc->threads_active) &&
-	    waitqueue_active(&desc->wait_for_threads))
+	if (atomic_dec_and_test(&desc->threads_active))
 		wake_up(&desc->wait_for_threads);
 }
 
-- 
1.9.rc0

