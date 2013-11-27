Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929Ab3K0CHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:07:30 -0500
Received: from mx5.zte.com.cn ([63.217.80.70]:60490 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759891Ab3K0CHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:07:24 -0500
In-Reply-To: <20131126180420.GA18172@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn> <20131114052326.GA29031@mtj.dyndns.org> <20131114114039.GA29277@redhat.com> <20131114115551.GA30824@redhat.com> <20131114115618.GB30824@redhat.com> <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com> <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn> <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn> <20131126180420.GA18172@redhat.com>
Subject: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into userspace child
X-KeepSent: 99742718:77495161-48257C30:000A8334;
 type=4; name=$KeepSent
To: Oleg Nesterov <oleg@redhat.com>
Cc: htejun@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tejun Heo <tj@kernel.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Wed, 27 Nov 2013 10:07:03 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-11-27 10:07:10
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse01.zte.com.cn rAR277bS037424
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace process doesn't want the PF_NO_SETAFFINITY, but its parent may be
a kernel worker thread which has PF_NO_SETAFFINITY set, and this worker thread
can do kernel_thread() to create the child.
Clearing this flag in usersapce child to enable its migrating capability.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>

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


