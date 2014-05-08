Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaEHKpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:45:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaEHKp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:45:29 -0400
Date: Thu, 8 May 2014 03:44:45 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-r32tt8yldvic3jlcghd3g35u@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Ensure consistent inherit state in groups
Git-Commit-ID: 1f4ee5038f0c1ef95f8e6d47ad6623e006b5bce1
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

Commit-ID:  1f4ee5038f0c1ef95f8e6d47ad6623e006b5bce1
Gitweb:     http://git.kernel.org/tip/1f4ee5038f0c1ef95f8e6d47ad6623e006b5bce1
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 6 May 2014 09:59:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:44:17 +0200

perf: Ensure consistent inherit state in groups

Make sure all events in a group have the same inherit state. It was
possible for group leaders to have inherit set while sibling events
would not have inherit set.

In this case we'd still inherit the siblings, leading to some
non-fatal weirdness.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-r32tt8yldvic3jlcghd3g35u@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 09866a3..1de0d70 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7081,20 +7081,26 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	if (task && group_leader &&
+	    group_leader->attr.inherit != attr.inherit) {
+		err = -EINVAL;
+		goto err_task;
+	}
+
 	get_online_cpus();
 
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
-		goto err_task;
+		goto err_cpus;
 	}
 
 	if (flags & PERF_FLAG_PID_CGROUP) {
 		err = perf_cgroup_connect(pid, event, &attr, group_leader);
 		if (err) {
 			__free_event(event);
-			goto err_task;
+			goto err_cpus;
 		}
 	}
 
@@ -7256,8 +7262,9 @@ err_context:
 	put_ctx(ctx);
 err_alloc:
 	free_event(event);
-err_task:
+err_cpus:
 	put_online_cpus();
+err_task:
 	if (task)
 		put_task_struct(task);
 err_group_fd:
