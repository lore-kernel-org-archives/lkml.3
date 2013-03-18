Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3CRVRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:17:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36906 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3CRVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:17:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/7] rcu: Avoid invoking RCU core on offline CPUs
Date: Mon, 18 Mar 2013 14:16:51 -0700
Message-Id: <1363641416-18642-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318211615.GA15814@linux.vnet.ibm.com>
 <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-2876-0000-0000-00000674262D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Offline CPUs transition through the scheduler to the idle loop one
last time before being shut down.  This can result in RCU raising
softirq on this CPU, which is at best useless given that the CPU's
callbacks will be offloaded at CPU_DEAD time.  This commit therefore
avoids raising softirq on offline CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 157539a..b2fc234 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2169,7 +2169,8 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 
 static void invoke_rcu_core(void)
 {
-	raise_softirq(RCU_SOFTIRQ);
+	if (cpu_online(smp_processor_id()))
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 /*
-- 
1.8.1.5

