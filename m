Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaITQve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:34 -0400
Received: from forward9l.mail.yandex.net ([84.201.143.142]:35978 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaITQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:32 -0400
X-Yandex-Uniq: d4afbbcb-d861-40fb-8452-2983c1de25c1
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 3/7] sched: Use dl_bw_of() under RCU read lock
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:28 +0400
Message-ID: <20140920165128.16299.20888.stgit@localhost>
In-Reply-To: <20140920165116.16299.1381.stgit@localhost>
References: <20140920165116.16299.1381.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

dl_bw_of() dereferences rq->rd which has to have RCU read lock held.
Probability of use-after-free and memory corruption aren't zero here.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: <stable@vger.kernel.org> # v3.14+
---
 kernel/sched/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c8d754f..00a024c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7619,6 +7619,8 @@ static int sched_dl_global_constraints(void)
 	int cpu, ret = 0;
 	unsigned long flags;
 
+	rcu_read_lock();
+
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -7640,6 +7642,8 @@ static int sched_dl_global_constraints(void)
 			break;
 	}
 
+	rcu_read_unlock();
+
 	return ret;
 }
 
@@ -7655,6 +7659,7 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
@@ -7665,6 +7670,7 @@ static void sched_dl_do_global(void)
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
+	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)

