Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaD2A0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:26:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52010 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbaD2AZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 22/45] torture: Increase stutter-end intensity
Date: Mon, 28 Apr 2014 17:25:10 -0700
Message-Id: <1398731133-18925-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-8236-0000-0000-000001E64A76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, all stuttered kthreads block a jiffy at a time, which can
result in them starting at different times.  (Note: This is not an
energy-efficiency problem unless you run torture tests in production,
in which case you have other problems!)  This commit increases the
intensity of the restart event by causing kthreads to spin through the
last jiffy, restarting when they see the variable change.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index f329848c3eee..bd768effba9a 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -533,7 +533,11 @@ void stutter_wait(const char *title)
 	while (ACCESS_ONCE(stutter_pause_test) ||
 	       (torture_runnable && !ACCESS_ONCE(*torture_runnable))) {
 		if (stutter_pause_test)
-			schedule_timeout_interruptible(1);
+			if (ACCESS_ONCE(stutter_pause_test) == 1)
+				schedule_timeout_interruptible(1);
+			else
+				while (ACCESS_ONCE(stutter_pause_test))
+					cond_resched();
 		else
 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
 		torture_shutdown_absorb(title);
@@ -550,7 +554,11 @@ static int torture_stutter(void *arg)
 	VERBOSE_TOROUT_STRING("torture_stutter task started");
 	do {
 		if (!torture_must_stop()) {
-			schedule_timeout_interruptible(stutter);
+			if (stutter > 1) {
+				schedule_timeout_interruptible(stutter - 1);
+				ACCESS_ONCE(stutter_pause_test) = 2;
+			}
+			schedule_timeout_interruptible(1);
 			ACCESS_ONCE(stutter_pause_test) = 1;
 		}
 		if (!torture_must_stop())
-- 
1.8.1.5

