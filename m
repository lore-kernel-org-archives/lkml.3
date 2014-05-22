Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaEVMaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:30:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbaEVMaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:30:15 -0400
Date: Thu, 22 May 2014 05:29:23 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-096aa33863a5e48de52d2ff30e0801b7487944f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140516001332.67f91af2@annuminas.surriel.com>
References: <20140516001332.67f91af2@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Decay ->
 wakee_flips instead of zeroing
Git-Commit-ID: 096aa33863a5e48de52d2ff30e0801b7487944f4
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

Commit-ID:  096aa33863a5e48de52d2ff30e0801b7487944f4
Gitweb:     http://git.kernel.org/tip/096aa33863a5e48de52d2ff30e0801b7487944f4
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 16 May 2014 00:13:32 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:41 +0200

sched/numa: Decay ->wakee_flips instead of zeroing

Affine wakeups have the potential to interfere with NUMA placement.
If a task wakes up too many other tasks, affine wakeups will get
disabled.

However, regardless of how many other tasks it wakes up, it gets
re-enabled once a second, potentially interfering with NUMA
placement of other tasks.

By decaying wakee_wakes in half instead of zeroing it, we can avoid
that problem for some workloads.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: chegu_vinod@hp.com
Cc: umgwanakikbuti@gmail.com
Link: http://lkml.kernel.org/r/20140516001332.67f91af2@annuminas.surriel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 503f750..c9617b7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4065,7 +4065,7 @@ static void record_wakee(struct task_struct *p)
 	 * about the loss.
 	 */
 	if (jiffies > current->wakee_flip_decay_ts + HZ) {
-		current->wakee_flips = 0;
+		current->wakee_flips >>= 1;
 		current->wakee_flip_decay_ts = jiffies;
 	}
 
