Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3AVHkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:40:31 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55157 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3AVHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:40:27 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 19/45] net: Use get/put_online_cpus_atomic() to prevent CPU
 offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2013 13:08:21 +0530
Message-ID: <20130122073817.13822.60227.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012207-3568-0000-0000-0000030FFE67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able to
depend on preempt_disable() or local_irq_disable() to prevent CPUs from
going offline from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
while invoking from atomic context.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 net/core/dev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f64e439..5421f96 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3089,7 +3089,7 @@ int netif_rx(struct sk_buff *skb)
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
-		preempt_disable();
+		get_online_cpus_atomic();
 		rcu_read_lock();
 
 		cpu = get_rps_cpu(skb->dev, skb, &rflow);
@@ -3099,7 +3099,7 @@ int netif_rx(struct sk_buff *skb)
 		ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
 
 		rcu_read_unlock();
-		preempt_enable();
+		put_online_cpus_atomic();
 	} else
 #endif
 	{
@@ -3498,6 +3498,7 @@ int netif_receive_skb(struct sk_buff *skb)
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu, ret;
 
+		get_online_cpus_atomic();
 		rcu_read_lock();
 
 		cpu = get_rps_cpu(skb->dev, skb, &rflow);
@@ -3505,9 +3506,11 @@ int netif_receive_skb(struct sk_buff *skb)
 		if (cpu >= 0) {
 			ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
 			rcu_read_unlock();
+			put_online_cpus_atomic();
 			return ret;
 		}
 		rcu_read_unlock();
+		put_online_cpus_atomic();
 	}
 #endif
 	return __netif_receive_skb(skb);
@@ -3887,6 +3890,7 @@ static void net_rps_action_and_irq_enable(struct softnet_data *sd)
 		local_irq_enable();
 
 		/* Send pending IPI's to kick RPS processing on remote cpus. */
+		get_online_cpus_atomic();
 		while (remsd) {
 			struct softnet_data *next = remsd->rps_ipi_next;
 
@@ -3895,6 +3899,7 @@ static void net_rps_action_and_irq_enable(struct softnet_data *sd)
 							   &remsd->csd, 0);
 			remsd = next;
 		}
+		put_online_cpus_atomic();
 	} else
 #endif
 		local_irq_enable();

