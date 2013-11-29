Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3K2JUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:20:08 -0500
Received: from mx5.zte.com.cn ([63.217.80.70]:56049 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3K2JT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:19:59 -0500
Subject: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into userspace child
X-KeepSent: 0BCEFABA:AA93B98E-48257C32:0031CD54;
 type=4; name=$KeepSent
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        pang.xunlei@zte.com.cn
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF0BCEFABA.AA93B98E-ON48257C32.0031CD54-48257C32.00334133@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Fri, 29 Nov 2013 17:19:21 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-11-29 17:19:30
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse02.zte.com.cn rAT9JapN091749
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Khelper is a workqueue thread which has PF_NO_SETAFFINITY set.
When a usermode process is spawned by khelper through __call_usermodehelper()
which will invoke kernel_thread() (not kthread_create()) to fork the new
process, we will clearly see that it will inherit the PF_NO_SETAFFINITY flag.

Consequently, this usermod process will lose some capabilities like
sched_setaffinity(), moving between cgroups, etc.

Clearing this flag in flush_old_exec() to solve this problem.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Signed-off-by: Pang Xunlei <pang.xunlei@zte.com.cn>

--- linux-3.12.old/fs/exec.c	2013-11-26 08:53:12.175811856 +0000
+++ linux-3.12/fs/exec.c	2013-11-27 09:36:56.231972168 +0000
@@ -1090,8 +1090,8 @@ int flush_old_exec(struct linux_binprm *
 	bprm->mm = NULL;		/* We're using it now */

 	set_fs(USER_DS);
-	current->flags &=
-		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
+	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
+					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;


