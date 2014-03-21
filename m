Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966715AbaCUAbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:31:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965944AbaCUAJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Xiaoming Wang <xiaoming.wang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.10 42/85] genirq: Remove racy waitqueue_active check
Date: Thu, 20 Mar 2014 17:09:45 -0700
Message-Id: <20140321000604.743453767@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/manage.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -802,8 +802,7 @@ static irqreturn_t irq_thread_fn(struct
 
 static void wake_threads_waitq(struct irq_desc *desc)
 {
-	if (atomic_dec_and_test(&desc->threads_active) &&
-	    waitqueue_active(&desc->wait_for_threads))
+	if (atomic_dec_and_test(&desc->threads_active))
 		wake_up(&desc->wait_for_threads);
 }
 


