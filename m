Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaCKMSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:18:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60052 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaCKMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:18:20 -0400
X-Nat-Received: from [202.181.97.72]:54230 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1394540207.18162
To: jmorris@namei.org
Cc: rgb@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        laijs@cn.fujitsu.com, akpm@linux-foundation.org, joe@perches.com,
        keescook@chromium.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
        tglx@linutronix.de, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
	<20140307155415.GB16640@madcap2.tricolour.ca>
	<201403082143.BIH86903.QtVMHJFFOOSFOL@I-love.SAKURA.ne.jp>
	<20140310202155.GR16640@madcap2.tricolour.ca>
	<201403112102.HCC48418.LSOQFJOFOtFVHM@I-love.SAKURA.ne.jp>
In-Reply-To: <201403112102.HCC48418.LSOQFJOFOtFVHM@I-love.SAKURA.ne.jp>
Message-Id: <201403112116.HIJ21362.OFVQJFtHOSOFLM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Mar 2014 21:16:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11032014 #7489815, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the same phrase goes to James Morris...

If you are sure that it is safe to use get_task_comm() from
dump_common_audit_data() and you prefer locked version, please pick up below
patch via your git tree.

If you are unsure or prefer lockless version, I'll make a lockless version
using do_get_task_comm() proposed in this thread.

----------
>From 1fe3dcd8792bc1296e337daba661200a8feaf706 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 11 Mar 2014 21:09:48 +0900
Subject: [PATCH] LSM: Pass comm name via get_task_comm()

When we pass task->comm to audit_log_untrustedstring(), we need to pass
a snapshot of it using get_task_comm(). Otherwise, we will lose fields
after comm= if we raced with updating task->comm.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/lsm_audit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 9a62045..6291c67 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -212,6 +212,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 				   struct common_audit_data *a)
 {
 	struct task_struct *tsk = current;
+	char name[TASK_COMM_LEN];
 
 	/*
 	 * To keep stack sizes in check force programers to notice if they
@@ -221,7 +222,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
 
 	audit_log_format(ab, " pid=%d comm=", tsk->pid);
-	audit_log_untrustedstring(ab, tsk->comm);
+	audit_log_untrustedstring(ab, get_task_comm(name, tsk));
 
 	switch (a->type) {
 	case LSM_AUDIT_DATA_NONE:
@@ -280,7 +281,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 		tsk = a->u.tsk;
 		if (tsk && tsk->pid) {
 			audit_log_format(ab, " pid=%d comm=", tsk->pid);
-			audit_log_untrustedstring(ab, tsk->comm);
+			audit_log_untrustedstring(ab, get_task_comm(name, tsk));
 		}
 		break;
 	case LSM_AUDIT_DATA_NET:
-- 
1.7.9.5
