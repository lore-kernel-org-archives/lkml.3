Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaKKJqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:46:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:56128 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaKKJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:46:33 -0500
Message-ID: <1415699189.15631.6.camel@tkhai>
Subject: [PATCH] sched/numa: Init numa balancing fields of init_task
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Tue, 11 Nov 2014 12:46:29 +0300
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 include/linux/init_task.h |   10 ++++++++++
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
 




