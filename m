Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab3ETQD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:03:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45469 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab3ETQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:15 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 6/8] kthread: Enable parking requests from setup() and unpark() callbacks
Date: Mon, 20 May 2013 18:01:54 +0200
Message-Id: <1369065716-22801-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the watchdog code is boot-disabled by the user, for example
through the 'nmi_watchdog=0' boot option, the setup() callback of
the watchdog kthread requests to park the task, and that until the
user later re-enables the watchdog through sysctl or procfs.

However the parking request is not well handled when done from
the setup() callback. After ->setup() is called, the generic smpboot
kthread loop directly tries to call the thread function or wait
for some event if ->thread_should_run() is false.

In the case of the watchdog kthread, ->thread_should_run() returns
false and the kthread goes to sleep and wait for the watchdog timer
to wake it up. But the timer is not enabled since the user requested
to disable the watchdog. We want the kthread to park instead of waiting
for events that can't happen.

As a result, later unpark requests after sysctl write through
'sysctl -w kernel.watchdog=1' won't wake up/unpark the task as
expected, since it's not parked anyway, leaving the value modified
without triggering any action.

We could workaround some solution in the watchdog code like forcing
one pass to the thread function and immediately return to park.

But supporting parking requests from ->setup() or ->unpark()
callbacks look like proper way to implement cancellation in
general. So let's fix it that way.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Don Zickus <dzickus@redhat.com>
---
 kernel/smpboot.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 02fc5c9..3394ed0 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -151,6 +151,12 @@ static int smpboot_thread_fn(void *data)
 			break;
 		}
 
+		/* Check if setup or unpark actually want us to park */
+		if (kthread_should_stop() || kthread_should_park()) {
+			preempt_enable();
+			continue;
+		}
+
 		if (!ht->thread_should_run(td->cpu)) {
 			preempt_enable();
 			schedule();
-- 
1.7.5.4

