Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbaCEA3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:29:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:44416 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756941AbaCEA3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:29:47 -0500
Message-Id: <20140305002943.837880844@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Mar 2014 19:29:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>, Tiejun Chen <tiejun.chen@windriver.com>,
        Bin Jiang <bin.jiang@windriver.com>
Subject: [PATCH RT 1/6] rcutree/rcu_bh_qs: disable irq while calling rcu_preempt_qs()
References: <20140305002933.559081123@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-rcutree-rcu_bh_qs-disable-irq-while-calling-rcu_pree.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.82-rt101-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tiejun Chen <tiejun.chen@windriver.com>

Any callers to the function rcu_preempt_qs() must disable irqs in
order to protect the assignment to ->rcu_read_unlock_special. In
RT case, rcu_bh_qs() as the wrapper of rcu_preempt_qs() is called
in some scenarios where irq is enabled, like this path,

do_single_softirq()
    |
    + local_irq_enable();
    + handle_softirq()
    |    |
    |    + rcu_bh_qs()
    |        |
    |        + rcu_preempt_qs()
    |
    + local_irq_disable()

So here we'd better disable irq directly inside of rcu_bh_qs() to
fix this, otherwise the kernel may be freezable sometimes as
observed. And especially this way is also kind and safe for the
potential rcu_bh_qs() usage elsewhere in the future.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
Signed-off-by: Bin Jiang <bin.jiang@windriver.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 12ae410..055268b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -177,7 +177,12 @@ static void rcu_preempt_qs(int cpu);
 
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	/* Callers to this function, rcu_preempt_qs(), must disable irqs. */
+	local_irq_save(flags);
 	rcu_preempt_qs(cpu);
+	local_irq_restore(flags);
 }
 #else
 void rcu_bh_qs(int cpu)
-- 
1.8.5.3


