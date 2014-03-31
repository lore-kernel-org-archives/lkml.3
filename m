Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaCaNXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:23:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaCaNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        Xiaoming Wang <xiaoming.wang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 07/71] genirq: Remove racy waitqueue_active check
Date: Mon, 31 Mar 2014 14:22:13 +0100
Message-Id: <1396272197-13394-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
index a561ed3..91baa12 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -785,8 +785,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 
 static void wake_threads_waitq(struct irq_desc *desc)
 {
-	if (atomic_dec_and_test(&desc->threads_active) &&
-	    waitqueue_active(&desc->wait_for_threads))
+	if (atomic_dec_and_test(&desc->threads_active))
 		wake_up(&desc->wait_for_threads);
 }
 
-- 
1.9.1

