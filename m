Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaDRTNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:13:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaDRTNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:13:18 -0400
Date: Fri, 18 Apr 2014 21:12:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
Cc: Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] memcg: kill start_kernel()->mm_init_owner(init_mm)
Message-ID: <20140418191259.GA7413@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com> <20140418172631.GA13323@redhat.com> <20140418182444.GB22235@dhcp22.suse.cz> <20140418184441.GA26046@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418184441.GA26046@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18, Oleg Nesterov wrote:
>
> OTOH, mm->owner is used by mm/memcontrol.c, so perhaps the prefix is fine?
>
> I do not even understand why do we have CONFIG_MM_OWNER, perhaps it should
> die?

Seriously what do you think about the patch below? Afaics CONFIG_MM_OWNER
is pointless.

And I just noticed start_kernel()->mm_init_owner(). It looks simply wrong
even if this is harmless, or I missed something?

Could you review 1/1 as well?

Oleg.
---

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8967e20..de16272 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -406,7 +406,7 @@ struct mm_struct {
 	spinlock_t			ioctx_lock;
 	struct kioctx_table __rcu	*ioctx_table;
 #endif
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 	/*
 	 * "owner" points to a task that is regarded as the canonical
 	 * user/owner of this mm. All of the following must be true in
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 82fe3da..570a325 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2947,7 +2947,7 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
 #else
@@ -2958,7 +2958,7 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
 static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 {
 }
-#endif /* CONFIG_MM_OWNER */
+#endif /* CONFIG_MEMCG */
 
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
 		unsigned int limit)
diff --git a/init/Kconfig b/init/Kconfig
index 765018c..143119e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -933,7 +933,6 @@ config RESOURCE_COUNTERS
 config MEMCG
 	bool "Memory Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS
-	select MM_OWNER
 	select EVENTFD
 	help
 	  Provides a memory resource controller that manages both anonymous
@@ -951,9 +950,6 @@ config MEMCG
 	  disable memory resource controller and you can avoid overheads.
 	  (and lose benefits of memory resource controller)
 
-	  This config option also selects MM_OWNER config option, which
-	  could in turn add some fork/exit overhead.
-
 config MEMCG_SWAP
 	bool "Memory Resource Controller Swap Extension"
 	depends on MEMCG && SWAP
@@ -1173,9 +1169,6 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
-config MM_OWNER
-	bool
-
 config SYSFS_DEPRECATED
 	bool "Enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
diff --git a/kernel/exit.c b/kernel/exit.c
index 429659c..e5c4668 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -313,7 +313,7 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
 	}
 }
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
  */
@@ -399,7 +399,7 @@ assign_new_owner:
 	task_unlock(c);
 	put_task_struct(c);
 }
-#endif /* CONFIG_MM_OWNER */
+#endif /* CONFIG_MEMCG */
 
 /*
  * Turn us into a lazy TLB process if we
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26..ed75cf5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1099,12 +1099,12 @@ static void rt_mutex_init_task(struct task_struct *p)
 #endif
 }
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 {
 	mm->owner = p;
 }
-#endif /* CONFIG_MM_OWNER */
+#endif /* CONFIG_MEMCG */
 
 /*
  * Initialize POSIX timer handling for a single task.

