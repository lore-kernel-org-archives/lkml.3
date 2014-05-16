Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaEPEOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaEPEOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:14:36 -0400
Date: Fri, 16 May 2014 00:13:32 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chegu_vinod@hp.com, mingo@kernel.org,
        umgwanakikbuti@gmail.com
Subject: [PATCH RFC] sched,numa: decay wakee_flips instead of zeroing
Message-ID: <20140516001332.67f91af2@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Affine wakeups have the potential to interfere with NUMA placement.
If a task wakes up too many other tasks, affine wakeups will get
disabled.

However, regardless of how many other tasks it wakes up, it gets
re-enabled once a second, potentially interfering with NUMA
placement of other tasks.

By decaying wakee_wakes in half instead of zeroing it, we can avoid
that problem for some workloads.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f01e2f1..0381b11 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4009,7 +4009,7 @@ static void record_wakee(struct task_struct *p)
 	 * about the loss.
 	 */
 	if (jiffies > current->wakee_flip_decay_ts + HZ) {
-		current->wakee_flips = 0;
+		current->wakee_flips >>= 1;
 		current->wakee_flip_decay_ts = jiffies;
 	}
 
