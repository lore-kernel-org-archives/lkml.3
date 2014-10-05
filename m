Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaJERZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:25:05 -0400
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:59407 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaJERY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:24:58 -0400
X-MXL-Hash: 54317eea712b876b-8561958efd463f8cbb1c3b2ce325aefc2a40dc55
X-MXL-Hash: 54317edc014b0f92-e1651be775daa4a5125b7e28c0f2cc2c992114a3
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: <tj@kernel.org>, <paulmck@linux.vnet.ibm.com>, <jiri@resnulli.us>,
        Joe Lawrence <joe.lawrence@stratus.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] workqueue: add quiescent state between work items
Date: Sun, 5 Oct 2014 13:24:21 -0400
Message-ID: <1412529862-17954-2-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=U/yGDIbu c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=_KQqW7t0BisA:10 a=Cdz]
X-AnalysisOut: [KgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuKpAAAA:8 a=YlVTAMxI]
X-AnalysisOut: [AAAA:8 a=VwQbUJbxAAAA:8 a=55vktE7HwCub9vLaWSAA:9 a=kSViFEB]
X-AnalysisOut: [My1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014100508); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the stop_machine deadlock scenario on !PREEMPT kernels
addressed in b22ce2785d97 "workqueue: cond_resched() after processing
each work item", kworker threads requeueing back-to-back with zero jiffy
delay can stall RCU. The cond_resched call introduced in that fix will
yield only iff there are other higher priority tasks to run, so force a
quiescent RCU state between work items.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Link: https://lkml.kernel.org/r/20140926105227.01325697@jlaw-desktop.mno.stratus.com
Link: https://lkml.kernel.org/r/20140929115445.40221d8e@jlaw-desktop.mno.stratus.com
Fixes: b22ce2785d97 ("workqueue: cond_resched() after processing each work item")
Cc: <stable@vger.kernel.org>
---
 kernel/workqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5dbe22a..345bec9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2043,8 +2043,10 @@ __acquires(&pool->lock)
 	 * kernels, where a requeueing work item waiting for something to
 	 * happen could deadlock with stop_machine as such work item could
 	 * indefinitely requeue itself while all other CPUs are trapped in
-	 * stop_machine.
+	 * stop_machine. At the same time, report a quiescent RCU state so
+	 * the same condition doesn't freeze RCU.
 	 */
+	rcu_note_voluntary_context_switch(current);
 	cond_resched();
 
 	spin_lock_irq(&pool->lock);
-- 
1.7.10.4

