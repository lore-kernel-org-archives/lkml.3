Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3HTCv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:51:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35749 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3HTCvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:51:24 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/5] rcu: Make rcutorture emit online failures if verbose
Date: Mon, 19 Aug 2013 19:51:14 -0700
Message-Id: <1376967074-32530-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A4784C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although rcutorture counts CPU-hotplug online failures, it does
not explicitly record which CPUs were having trouble coming online.
This commit therefore emits a console message when online failure occurs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutorture.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 869dac2..a4a73d4 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1434,7 +1434,13 @@ rcu_torture_onoff(void *arg)
 					 torture_type, cpu);
 			starttime = jiffies;
 			n_online_attempts++;
-			if (cpu_up(cpu) == 0) {
+			ret = cpu_up(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: online %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
 				if (verbose)
 					pr_alert("%s" TORTURE_FLAG
 						 "rcu_torture_onoff task: onlined %d\n",
-- 
1.8.1.5

