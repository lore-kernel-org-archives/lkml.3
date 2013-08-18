Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3HRCZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:25:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41492 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3HRCZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:25:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/5] rcu: Make rcutorture emit online failures if verbose
Date: Sat, 17 Aug 2013 19:25:17 -0700
Message-Id: <1376792717-3755-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081802-2398-0000-0000-0000019923FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although rcutorture counts CPU-hotplug online failures, it does
not explicitly record which CPUs were having trouble coming online.
This commit therefore emits a console message when online failure occurs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 7d42d13..15bec39 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1437,7 +1437,13 @@ rcu_torture_onoff(void *arg)
 					 torture_type, cpu);
 			starttime = jiffies;
 			n_online_attempts++;
-			if (cpu_up(cpu) == 0) {
+			ret = cpu_up(cpu);
+			if (ret != 0) {
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

