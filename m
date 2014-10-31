Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbaJaLVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:21:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:32812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaJaLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:38 -0400
Message-Id: <20141031111549.727005513@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/7] rfcomm: Fix broken wait construct
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-fix-rfcomm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfcomm_run() is a tad broken in that is has a nested wait loop. One
cannot rely on p->state for the outer wait because the inner wait will
overwrite it.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 net/bluetooth/rfcomm/core.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -101,11 +101,11 @@ static struct rfcomm_session *rfcomm_ses
 #define __get_rpn_stop_bits(line) (((line) >> 2) & 0x1)
 #define __get_rpn_parity(line)    (((line) >> 3) & 0x7)
 
+static DECLARE_WAIT_QUEUE_HEAD(rfcomm_wq);
+
 static void rfcomm_schedule(void)
 {
-	if (!rfcomm_thread)
-		return;
-	wake_up_process(rfcomm_thread);
+	wake_up_all(&rfcomm_wq);
 }
 
 /* ---- RFCOMM FCS computation ---- */
@@ -2086,24 +2086,22 @@ static void rfcomm_kill_listener(void)
 
 static int rfcomm_run(void *unused)
 {
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	BT_DBG("");
 
 	set_user_nice(current, -10);
 
 	rfcomm_add_listener(BDADDR_ANY);
 
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		if (kthread_should_stop())
-			break;
+	add_wait_queue(&rfcomm_wq, &wait);
+	while (!kthread_should_stop()) {
 
 		/* Process stuff */
 		rfcomm_process_sessions();
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&rfcomm_wq, &wait);
 
 	rfcomm_kill_listener();
 


