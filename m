Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3FYUbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:31:32 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46035 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3FYUb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:31:29 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to prevent CPU
 offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 01:57:55 +0530
Message-ID: <20130625202755.16593.67819.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com>
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062520-1396-0000-0000-0000032B5CF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

In RCU code, rcu_implicit_dynticks_qs() checks if a CPU is offline,
while being protected by a spinlock. Use the get/put_online_cpus_atomic()
APIs to prevent CPUs from going offline, while invoking from atomic context.

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/rcutree.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cf3adc6..caeed1a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2107,6 +2107,8 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
 			continue;
 		}
+
+		get_online_cpus_atomic();
 		cpu = rnp->grplo;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
@@ -2114,6 +2116,8 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 			    f(per_cpu_ptr(rsp->rda, cpu)))
 				mask |= bit;
 		}
+		put_online_cpus_atomic();
+
 		if (mask != 0) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */

