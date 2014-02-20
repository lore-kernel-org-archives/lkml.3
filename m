Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBTUoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:44:54 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:47529 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaBTUov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:51 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 9/9] workqueue: remove PREPARE_[DELAYED_]WORK()
Date: Thu, 20 Feb 2014 15:44:31 -0500
Message-Id: <1392929071-16555-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley noticed that since a2c1c57be8d9 ("workqueue: consider
work function when searching for busy work items"), a work item which
gets assigned a different work function would break out of the
non-reentrancy guarantee as workqueue would consider it a different
work item.

This is fragile and extremely subtle.  PREPARE_[DELAYED_]WORK() have
never been used widely and its semantics has always been somewhat
iffy.  If the work item is known not to be on queue when
PREPARE_WORK() is called, there's no difference from using
INIT_WORK().  If the work item may be queued at the time of
PREPARE_WORK(), we can't really tell whether the old or new function
will be executed the next time.

We really don't want this level of subtlety in workqueue interface for
such marginal use cases.  The previous patches converted all existing
users away from PREPARE_[DELAYED_]WORK().  Let's remove them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Link: http://lkml.kernel.org/g/1392493119-9277-1-git-send-email-peter@hurleysoftware.com
---
 include/linux/workqueue.h | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..d499066 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -177,17 +177,6 @@ struct execute_work {
 #define DECLARE_DEFERRABLE_WORK(n, f)					\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, TIMER_DEFERRABLE)
 
-/*
- * initialize a work item's function pointer
- */
-#define PREPARE_WORK(_work, _func)					\
-	do {								\
-		(_work)->func = (_func);				\
-	} while (0)
-
-#define PREPARE_DELAYED_WORK(_work, _func)				\
-	PREPARE_WORK(&(_work)->work, (_func))
-
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
@@ -217,7 +206,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0); \
 		INIT_LIST_HEAD(&(_work)->entry);			\
-		PREPARE_WORK((_work), (_func));				\
+		(_work)->func = (_func);				\
 	} while (0)
 #else
 #define __INIT_WORK(_work, _func, _onstack)				\
@@ -225,7 +214,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
-		PREPARE_WORK((_work), (_func));				\
+		(_work)->func = (_func);				\
 	} while (0)
 #endif
 
-- 
1.8.5.3

