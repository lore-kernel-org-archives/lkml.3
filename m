Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3EIEUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:20:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3EIEUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:20:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, penberg@kernel.org
Subject: [PATCH v2 1/9] lockdep: Be nice about building from userspace
Date: Thu,  9 May 2013 00:19:08 -0400
Message-Id: <1368073156-27567-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368073156-27567-1-git-send-email-sasha.levin@oracle.com>
References: <1368073156-27567-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep is an awesome piece of code which detects locking issues
which are relevant both to userspace and kernelspace. We can
easily make lockdep work in userspace since there is really no
kernel spacific magic going on in the code.

All we need is to wrap two functions which are used by lockdep
and are very kernel specific.

Doing that will allow tools located in tools/ to easily utilize
lockdep's code for their own use.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1352753446-24109-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8a0efac..1966746 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -584,6 +584,7 @@ static int very_verbose(struct lock_class *class)
 /*
  * Is this the address of a static object:
  */
+#ifdef __KERNEL__
 static int static_obj(void *obj)
 {
 	unsigned long start = (unsigned long) &_stext,
@@ -610,6 +611,7 @@ static int static_obj(void *obj)
 	 */
 	return is_module_address(addr) || is_module_percpu_address(addr);
 }
+#endif
 
 /*
  * To make lock name printouts unique, we calculate a unique
@@ -4114,6 +4116,7 @@ void debug_check_no_locks_held(struct task_struct *task)
 		print_held_locks_bug(task);
 }
 
+#ifdef __KERNEL__
 void debug_show_all_locks(void)
 {
 	struct task_struct *g, *p;
@@ -4171,6 +4174,7 @@ retry:
 		read_unlock(&tasklist_lock);
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
+#endif
 
 /*
  * Careful: only use this function if you are sure that
-- 
1.8.2.1

