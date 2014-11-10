Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaKJWAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaKJWAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:39 -0500
Date: Mon, 10 Nov 2014 23:00:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] sched_show_task: fix unsafe usage of ->real_parent
Message-ID: <20141110220026.GA31224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110215959.GA31106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_lock() can not protect p->real_parent if release_task(p) was
already called, change sched_show_task() to check pis_alive() like
other users do.

Note: we need some helpers to cleanup the code like this. And it seems
that that the usage of cpu_curr(cpu) in dump_cpu_task() is not safe too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..1ec75c9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4572,8 +4572,10 @@ void sched_show_task(struct task_struct *p)
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
+	ppid = 0;
 	rcu_read_lock();
-	ppid = task_pid_nr(rcu_dereference(p->real_parent));
+	if (pid_alive(p))
+		ppid = task_pid_nr(rcu_dereference(p->real_parent));
 	rcu_read_unlock();
 	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
 		task_pid_nr(p), ppid,
-- 
1.5.5.1

