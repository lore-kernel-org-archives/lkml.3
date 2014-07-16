Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaGPT2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:28:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965777AbaGPTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:23:02 -0400
Date: Wed, 16 Jul 2014 12:22:10 -0700
From: tip-bot for Mateusz Guzik <tipbot@zytor.com>
Message-ID: <tip-b0ab99e7736af88b8ac1b7ae50ea287fffa2badc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mguzik@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, mguzik@redhat.com
In-Reply-To: <1402750809-31991-1-git-send-email-mguzik@redhat.com>
References: <1402750809-31991-1-git-send-email-mguzik@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix possible divide by zero in avg_atom
 () calculation
Git-Commit-ID: b0ab99e7736af88b8ac1b7ae50ea287fffa2badc
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

Commit-ID:  b0ab99e7736af88b8ac1b7ae50ea287fffa2badc
Gitweb:     http://git.kernel.org/tip/b0ab99e7736af88b8ac1b7ae50ea287fffa2badc
Author:     Mateusz Guzik <mguzik@redhat.com>
AuthorDate: Sat, 14 Jun 2014 15:00:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:36:07 +0200

sched: Fix possible divide by zero in avg_atom() calculation

proc_sched_show_task() does:

  if (nr_switches)
	do_div(avg_atom, nr_switches);

nr_switches is unsigned long and do_div truncates it to 32 bits, which
means it can test non-zero on e.g. x86-64 and be truncated to zero for
division.

Fix the problem by using div64_ul() instead.

As a side effect calculations of avg_atom for big nr_switches are now correct.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1402750809-31991-1-git-send-email-mguzik@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 695f977..627b3c3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -608,7 +608,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 		avg_atom = p->se.sum_exec_runtime;
 		if (nr_switches)
-			do_div(avg_atom, nr_switches);
+			avg_atom = div64_ul(avg_atom, nr_switches);
 		else
 			avg_atom = -1LL;
 
