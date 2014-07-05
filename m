Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbaGEKrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:47:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaGEKrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:47:12 -0400
Date: Sat, 5 Jul 2014 03:46:12 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-99b625670f1447ecf0739161efbe7f2f43c0e0b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, ktkhai@parallels.com,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, pjt@google.com, umgwanakikbuti@gmail.com,
        khorenko@parallels.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        bsegall@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, peterz@infradead.org,
        khorenko@parallels.com, umgwanakikbuti@gmail.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <1403684388.3462.43.camel@tkhai>
References: <1403684388.3462.43.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Enqueue just unthrottled rt_rq back on the stack in __disable_runtime()
Git-Commit-ID: 99b625670f1447ecf0739161efbe7f2f43c0e0b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99b625670f1447ecf0739161efbe7f2f43c0e0b6
Gitweb:     http://git.kernel.org/tip/99b625670f1447ecf0739161efbe7f2f43c0e0b6
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 25 Jun 2014 12:19:48 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:44 +0200

sched/rt: Enqueue just unthrottled rt_rq back on the stack in __disable_runtime()

Make rt_rq available for pick_next_task(). Otherwise, their tasks
stay prisoned long time till dead cpu becomes alive again.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Konstantin Khorenko <khorenko@parallels.com>
CC: Ben Segall <bsegall@google.com>
CC: Paul Turner <pjt@google.com>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403684388.3462.43.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a490831..671a8b5 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -740,6 +740,9 @@ balanced:
 		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
+
+		/* Make rt_rq available for pick_next_task() */
+		sched_rt_rq_enqueue(rt_rq);
 	}
 }
 
