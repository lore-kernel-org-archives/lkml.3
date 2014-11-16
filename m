Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaKPMeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:34:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaKPMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:34:09 -0500
Date: Sun, 16 Nov 2014 04:33:35 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-d8b163c4c657478ef33c082cff78d03a4ca07bb2@git.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, eparis@redhat.com, oleg@redhat.com,
        hpa@zytor.com, ktkhai@parallels.com, dserrg@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Reply-To: paulmck@linux.vnet.ibm.com, oleg@redhat.com, eparis@redhat.com,
        hpa@zytor.com, dserrg@gmail.com, ktkhai@parallels.com,
        tglx@linutronix.de, peterz@infradead.org, mingo@kernel.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1415699189.15631.6.camel@tkhai>
References: <1415699189.15631.6.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Init numa balancing fields of init_task
Git-Commit-ID: d8b163c4c657478ef33c082cff78d03a4ca07bb2
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

Commit-ID:  d8b163c4c657478ef33c082cff78d03a4ca07bb2
Gitweb:     http://git.kernel.org/tip/d8b163c4c657478ef33c082cff78d03a4ca07bb2
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Tue, 11 Nov 2014 12:46:29 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:59:01 +0100

sched/numa: Init numa balancing fields of init_task

We do not initialize init_task.numa_preferred_nid,
but this value is inherited by userspace "init"
process:

rest_init()->kernel_thread(kernel_init)->do_fork(CLONE_VM);

__sched_fork()
{
	if (clone_flags & CLONE_VM)
		p->numa_preferred_nid = current->numa_preferred_nid;
	else
		p->numa_preferred_nid = -1;
}

kernel_init() becomes userspace "init" process.

So, we propagate garbage nid to userspace, and it may be used
during numa balancing.

Currently, we do not have reports about this brings a problem,
but it seem we should set it for sure.

Even if init_task.numa_preferred_nid is zero, we may meet a weird
configuration without nid#0. On sparc64, where processors are
numbered physically, I saw a machine without cpu#1, while cpu#2
existed. Possible, something similar may be with numa nodes.
So, let's initialize it and be sure we're safe.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Link: http://lkml.kernel.org/r/1415699189.15631.6.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/init_task.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 77fc43f..5f30ac8 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -166,6 +166,15 @@ extern struct task_group root_task_group;
 # define INIT_RT_MUTEXES(tsk)
 #endif
 
+#ifdef CONFIG_NUMA_BALANCING
+# define INIT_NUMA_BALANCING(tsk)					\
+	.numa_preferred_nid = -1,					\
+	.numa_group = NULL,						\
+	.numa_faults = NULL,
+#else
+# define INIT_NUMA_BALANCING(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -237,6 +246,7 @@ extern struct task_group root_task_group;
 	INIT_CPUSET_SEQ(tsk)						\
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
+	INIT_NUMA_BALANCING(tsk)					\
 }
 
 
