Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaB0J6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:58:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaB0J6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:58:44 -0500
Date: Thu, 27 Feb 2014 01:58:18 -0800
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-c685689fd24d310343ac33942e9a54a974ae9c43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, xiaoming.wang@intel.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, xiaoming.wang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        chuansheng.liu@intel.com
In-Reply-To: <1393212590-32543-1-git-send-email-chuansheng.liu@intel.com>
References: <1393212590-32543-1-git-send-email-chuansheng.liu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Remove racy waitqueue_active check
Git-Commit-ID: c685689fd24d310343ac33942e9a54a974ae9c43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c685689fd24d310343ac33942e9a54a974ae9c43
Gitweb:     http://git.kernel.org/tip/c685689fd24d310343ac33942e9a54a974ae9c43
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Mon, 24 Feb 2014 11:29:50 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Feb 2014 10:54:16 +0100

genirq: Remove racy waitqueue_active check

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
