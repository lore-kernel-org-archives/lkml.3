Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3FLOCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:02:54 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58922 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab3FLOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:02:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Date: Wed, 12 Jun 2013 16:02:36 +0200
Message-Id: <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the watchdog runs, it prevents the full dynticks
CPUs from stopping their tick because the hard lockup
detector uses perf events internally, which in turn
rely on the periodic tick.

Since this is a rather confusing behaviour that is not
easy to track down and identify for those who want to
test CONFIG_NO_HZ_FULL, let's default disable the
watchdog on boot time when full dynticks is enabled.

The user can still enable it later on runtime using
proc or sysctl.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Anish Singh <anish198519851985@gmail.com>
---
 kernel/watchdog.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 52c9a9b..277d713 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -553,6 +553,14 @@ void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
+#ifdef CONFIG_NO_HZ_FULL
+	if (watchdog_enabled) {
+		watchdog_enabled = 0;
+		pr_warning("Disabled lockup detectors by default for full dynticks\n");
+		pr_warning("You can reactivate it with 'sysctl -w kernel.watchdog=1'\n");
+	}
+#endif
+
 	if (watchdog_enabled)
 		watchdog_enable_all_cpus();
 }
-- 
1.7.5.4

