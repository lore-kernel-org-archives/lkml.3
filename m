Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3AXUn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:43:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3AXUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:43:51 -0500
Date: Thu, 24 Jan 2013 12:43:37 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-47dd80e801c32c114bcc6767ad190361c8b70172@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
References: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Be nice about building from userspace
Git-Commit-ID: 47dd80e801c32c114bcc6767ad190361c8b70172
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:43:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47dd80e801c32c114bcc6767ad190361c8b70172
Gitweb:     http://git.kernel.org/tip/47dd80e801c32c114bcc6767ad190361c8b70172
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Mon, 12 Nov 2012 15:50:46 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 17:54:50 +0100

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
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1352753446-24109-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5cf12e7..c783e80 100644
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
@@ -4109,6 +4111,7 @@ void debug_check_no_locks_held(struct task_struct *task)
 		print_held_locks_bug(task);
 }
 
+#ifdef __KERNEL__
 void debug_show_all_locks(void)
 {
 	struct task_struct *g, *p;
@@ -4166,6 +4169,7 @@ retry:
 		read_unlock(&tasklist_lock);
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
+#endif
 
 /*
  * Careful: only use this function if you are sure that
