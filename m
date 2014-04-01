Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaDAMTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:19:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaDALQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        Xiaoming Wang <xiaoming.wang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/144] genirq: Remove racy waitqueue_active check
Date: Tue,  1 Apr 2014 12:13:42 +0100
Message-Id: <1396350948-29910-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit c685689fd24d310343ac33942e9a54a974ae9c43 upstream.

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
                                             wake_up()

Here after inserted the __wait into queue on CPU0, and before
test if queue is empty on CPU1, there is no barrier, it maybe
cause it is not visible for CPU1 immediately, although CPU0 has
updated the queue list.
It is similar for CPU0 atomic_read() threads_active also.

So we'd need one smp_mb() before waitqueue_active.that, but removing
the waitqueue_active() check solves it as wel l and it makes
things simple and clear.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Xiaoming Wang <xiaoming.wang@intel.com>
Link: http://lkml.kernel.org/r/1393212590-32543-1-git-send-email-chuansheng.liu@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/irq/manage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3e59f95..4c84746 100644
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
1.9.1

