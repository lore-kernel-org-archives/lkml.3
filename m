Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaCKMFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:05:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58955 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaCKMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:05:17 -0400
X-Nat-Received: from [202.181.97.72]:62563 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1394539362.4128
To: rgb@redhat.com
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com,
        akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140225144643.GU9987@twins.programming.kicks-ass.net>
	<201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
	<20140307155415.GB16640@madcap2.tricolour.ca>
	<201403082143.BIH86903.QtVMHJFFOOSFOL@I-love.SAKURA.ne.jp>
	<20140310202155.GR16640@madcap2.tricolour.ca>
In-Reply-To: <20140310202155.GR16640@madcap2.tricolour.ca>
Message-Id: <201403112102.HCC48418.LSOQFJOFOtFVHM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Mar 2014 21:02:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11032014 #7489815, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs wrote:
> > Even if you don't trust the comm= field, it is annoying for me that fields
> > after comm= are missing in the audit log.
> 
> More than annoying, that isn't acceptable.
> 
OK. If you are sure that it is safe to use get_task_comm() from
audit_log_task() and you prefer locked version, please pick up below patch
via your git tree.

If you are unsure or prefer lockless version, I'll make a lockless version
using do_get_task_comm() proposed in this thread.

----------
>From 88c3ff13efa10df6f4d4d0f2c243124ce6a3eaeb Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 11 Mar 2014 20:47:29 +0900
Subject: [PATCH] Audit: Pass comm name via get_task_comm()

When we pass task->comm to audit_log_untrustedstring(), we need to pass
a snapshot of it using get_task_comm(). Otherwise, we will lose fields
after comm= if we raced with updating task->comm.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/auditsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7aef2f4..ba57993 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2357,6 +2357,7 @@ static void audit_log_task(struct audit_buffer *ab)
 	kgid_t gid;
 	unsigned int sessionid;
 	struct mm_struct *mm = current->mm;
+	char name[TASK_COMM_LEN];
 
 	auid = audit_get_loginuid(current);
 	sessionid = audit_get_sessionid(current);
@@ -2369,7 +2370,7 @@ static void audit_log_task(struct audit_buffer *ab)
 			 sessionid);
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
-	audit_log_untrustedstring(ab, current->comm);
+	audit_log_untrustedstring(ab, get_task_comm(name, current));
 	if (mm) {
 		down_read(&mm->mmap_sem);
 		if (mm->exe_file)
-- 
1.7.9.5
