Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBJIXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:23:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:43078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaBJIXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:23:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="480776403"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        xiaoming wang <xiaoming.wang@intel.com>
Subject: [PATCH 1/2] genirq: Fix the possible synchronize_irq() wait-forever
Date: Mon, 10 Feb 2014 16:13:56 +0800
Message-Id: <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is below race between irq handler and irq thread:
irq handler                             irq thread

irq_wake_thread()                       irq_thread()
  set bit RUNTHREAD
  ...                                    clear bit RUNTHREAD
                                         thread_fn()
                                         [A]test_and_decrease
                                               thread_active
  [B]increase thread_active

If action A is before action B, after that the thread_active
will be always > 0, and for synchronize_irq() calling, which
will be waiting there forever.

Here put the increasing thread-active before setting bit
RUNTHREAD, which can resolve such race.

Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 kernel/irq/handle.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..5f9fbb7 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -65,7 +65,7 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * Wake up the handler thread for this action. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
 	/*
@@ -126,6 +126,25 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 */
 	atomic_inc(&desc->threads_active);
 
+	/*
+	 * set the RUNTHREAD bit after increasing the threads_active,
+	 * it can avoid the below race:
+	 * irq handler                  irq thread in case it is in
+	 *                                            running state
+	 *
+	 *  set RUNTHREAD bit
+	 *                              clear the RUNTHREAD bit
+	 *...                           thread_fn()
+	 *
+	 *                              due to threads_active==0,
+	 *                              no waking up wait_for_threads
+	 *
+	 * threads_active ++
+	 * After that, the threads_active will be always > 0, which
+	 * will block the synchronize_irq().
+	 */
+	set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+
 	wake_up_process(action->thread);
 }
 
-- 
1.9.rc0

