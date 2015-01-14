Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbbANOCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:02:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbbANOC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:02:28 -0500
Date: Wed, 14 Jan 2015 06:01:50 -0800
From: tip-bot for Eric Sandeen <tipbot@zytor.com>
Message-ID: <tip-a8b686b3af4419f92e0ea5be1c76fb68363df8e6@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, peterz@infradead.org, hpa@zytor.com,
        sandeen@redhat.com
Reply-To: sandeen@redhat.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, peterz@infradead.org
In-Reply-To: <5490B158.4060005@redhat.com>
References: <5490B158.4060005@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug:
  Check for stack overflow in ___might_sleep()
Git-Commit-ID: a8b686b3af4419f92e0ea5be1c76fb68363df8e6
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

Commit-ID:  a8b686b3af4419f92e0ea5be1c76fb68363df8e6
Gitweb:     http://git.kernel.org/tip/a8b686b3af4419f92e0ea5be1c76fb68363df8e6
Author:     Eric Sandeen <sandeen@redhat.com>
AuthorDate: Tue, 16 Dec 2014 16:25:28 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:14 +0100

sched/debug: Check for stack overflow in ___might_sleep()

Sometimes a "BUG: sleeping function called from invalid context"
message is not indicative of locking problems, but is the result
of a stack overflow corrupting the thread info.

Witness http://oss.sgi.com/archives/xfs/2014-02/msg00325.html
for example, which took a few go-rounds to sort out.

If we're printing the warning, things are wonky already, and
it'd be informative to check for the stack end corruption at this
point, too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/5490B158.4060005@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0accc0..56c9b79 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7325,6 +7325,9 @@ void ___might_sleep(const char *file, int line, int preempt_offset)
 			in_atomic(), irqs_disabled(),
 			current->pid, current->comm);
 
+	if (task_stack_end_corrupted(current))
+		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
+
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);
