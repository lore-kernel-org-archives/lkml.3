Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbbANHlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:41:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbbANHlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:41:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.18 115/150] sched: Add missing rcu protection to wake_up_all_idle_cpus
Date: Tue, 13 Jan 2015 23:23:06 -0800
Message-Id: <20150114072101.068284286@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit fd7de1e8d5b2b2b35e71332fafb899f584597150 upstream.

Locklessly doing is_idle_task(rq->curr) is only okay because of
RCU protection.  The older variant of the broken code checked
rq->curr == rq->idle instead and therefore didn't need RCU.

Fixes: f6be8af1c95d ("sched: Add new API wake_up_if_idle() to wake up the idle cpu")
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1623,8 +1623,10 @@ void wake_up_if_idle(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!is_idle_task(rq->curr))
-		return;
+	rcu_read_lock();
+
+	if (!is_idle_task(rcu_dereference(rq->curr)))
+		goto out;
 
 	if (set_nr_if_polling(rq->idle)) {
 		trace_sched_wake_idle_without_ipi(cpu);
@@ -1635,6 +1637,9 @@ void wake_up_if_idle(int cpu)
 		/* Else cpu is not in idle, do nothing here */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)


