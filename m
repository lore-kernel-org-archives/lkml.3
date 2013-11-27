Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3K0ONr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:13:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3K0OJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:09:02 -0500
Date: Wed, 27 Nov 2013 06:08:28 -0800
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-8dce7a9a6f4ca7163161a80a4603b66c88c5de8e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
References: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Be nice about building from userspace
Git-Commit-ID: 8dce7a9a6f4ca7163161a80a4603b66c88c5de8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:08:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dce7a9a6f4ca7163161a80a4603b66c88c5de8e
Gitweb:     http://git.kernel.org/tip/8dce7a9a6f4ca7163161a80a4603b66c88c5de8e
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 13 Jun 2013 18:41:16 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:55:20 +0100

lockdep: Be nice about building from userspace

Lockdep is an awesome piece of code which detects locking issues
which are relevant both to userspace and kernelspace. We can
easily make lockdep work in userspace since there is really no
kernel spacific magic going on in the code.

All we need is to wrap two functions which are used by lockdep
and are very kernel specific.

Doing that will allow tools located in tools/ to easily utilize
lockdep's code for their own use.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: penberg@kernel.org
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/1352753446-24109-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/lockdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 576ba75..eb8a547 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -590,6 +590,7 @@ static int very_verbose(struct lock_class *class)
 /*
  * Is this the address of a static object:
  */
+#ifdef __KERNEL__
 static int static_obj(void *obj)
 {
 	unsigned long start = (unsigned long) &_stext,
@@ -616,6 +617,7 @@ static int static_obj(void *obj)
 	 */
 	return is_module_address(addr) || is_module_percpu_address(addr);
 }
+#endif
 
 /*
  * To make lock name printouts unique, we calculate a unique
@@ -4115,6 +4117,7 @@ void debug_check_no_locks_held(void)
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
+#ifdef __KERNEL__
 void debug_show_all_locks(void)
 {
 	struct task_struct *g, *p;
@@ -4172,6 +4175,7 @@ retry:
 		read_unlock(&tasklist_lock);
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
+#endif
 
 /*
  * Careful: only use this function if you are sure that
