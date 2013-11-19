Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3KSTQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:16:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3KSTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:16:16 -0500
Date: Tue, 19 Nov 2013 11:15:33 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-42eb088ed246a5a817bb45a8b32fe234cf1c0f8b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, preeti@linux.vnet.ibm.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131118113701.GF3866@twins.programming.kicks-ass.net>
References: <20131118113701.GF3866@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Avoid NULL dereference on sd_busy
Git-Commit-ID: 42eb088ed246a5a817bb45a8b32fe234cf1c0f8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:15:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42eb088ed246a5a817bb45a8b32fe234cf1c0f8b
Gitweb:     http://git.kernel.org/tip/42eb088ed246a5a817bb45a8b32fe234cf1c0f8b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 19 Nov 2013 16:41:49 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 17:01:16 +0100

sched: Avoid NULL dereference on sd_busy

Commit 37dc6b50cee9 ("sched: Remove unnecessary iteration over sched
domains to update nr_busy_cpus") forgot to clear 'sd_busy' under some
conditions leading to a possible NULL deref in set_cpu_sd_state_idle().

Reported-by: Anton Blanchard <anton@samba.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131118113701.GF3866@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..a1591ca 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4910,8 +4910,9 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
-		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
+		sd = sd->parent; /* sd_busy */
 	}
+	rcu_assign_pointer(per_cpu(sd_busy, cpu), sd);
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_size, cpu) = size;
