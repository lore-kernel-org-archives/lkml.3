Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaESNMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:12:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59518 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbaESNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:12:22 -0400
Date: Mon, 19 May 2014 06:11:21 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-5658b4f43e63f8c7b4a27995dcb2cf43a52ee398@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140516001332.67f91af2@annuminas.surriel.com>
References: <20140516001332.67f91af2@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched,numa: Decay wakee_flips instead of zeroing
Git-Commit-ID: 5658b4f43e63f8c7b4a27995dcb2cf43a52ee398
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

Commit-ID:  5658b4f43e63f8c7b4a27995dcb2cf43a52ee398
Gitweb:     http://git.kernel.org/tip/5658b4f43e63f8c7b4a27995dcb2cf43a52ee398
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 16 May 2014 00:13:32 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:43 +0900

sched,numa: Decay wakee_flips instead of zeroing

Affine wakeups have the potential to interfere with NUMA placement.
If a task wakes up too many other tasks, affine wakeups will get
disabled.

However, regardless of how many other tasks it wakes up, it gets
re-enabled once a second, potentially interfering with NUMA
placement of other tasks.

By decaying wakee_wakes in half instead of zeroing it, we can avoid
that problem for some workloads.

Cc: chegu_vinod@hp.com
Cc: mingo@kernel.org
Cc: umgwanakikbuti@gmail.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140516001332.67f91af2@annuminas.surriel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
