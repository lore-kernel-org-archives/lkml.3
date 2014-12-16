Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaLPWZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:25:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaLPWZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:25:54 -0500
Message-ID: <5490B158.4060005@redhat.com>
Date: Tue, 16 Dec 2014 16:25:28 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] check for stack overflow in ___might_sleep
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes a "BUG: sleeping function called from invalid context"
message is not indicative of locking problems, but is the result
of a stack overflow corrupting the thread info.

Witness http://oss.sgi.com/archives/xfs/2014-02/msg00325.html
for example, which took a few go-rounds to sort out.

If we're printing the warning, things are wonky already, and
it'd be informative to check for the stack end corruption at this
point, too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b7..4ef726c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7328,6 +7328,9 @@ void ___might_sleep(const char *file, int line, int preempt_offset)
 			in_atomic(), irqs_disabled(),
 			current->pid, current->comm);
 
+	if (task_stack_end_corrupted(current))
+		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
+
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);

