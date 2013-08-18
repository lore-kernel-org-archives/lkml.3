Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3HRBib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 21:38:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43181 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3HRBiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 21:38:10 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/11] rcu: Expedite during suspend and resume only on smallish systems
Date: Sat, 17 Aug 2013 18:37:47 -0700
Message-Id: <1376789876-27594-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081801-7606-0000-0000-00000E6C105C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Expedited grace periods are of dubious benefit on very large systems,
so this commit restricts their automated use during suspend and resume
to systems of 256 or fewer CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 69e4792..6ec33dc 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -3038,7 +3038,8 @@ static int rcu_pm_notify(struct notifier_block *self,
 {
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
-		rcu_expedited = 1;
+		if (nr_cpu_ids <= 256) /* Expediting bad for large systems. */
+			rcu_expedited = 1;
 		break;
 	case PM_POST_RESTORE:
 		rcu_expedited = 0;
-- 
1.8.1.5

