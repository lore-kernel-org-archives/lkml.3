Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaCPPNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 11:13:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53923 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaCPPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 11:13:42 -0400
X-Nat-Received: from [202.181.97.72]:58555 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1394982821.27850
To: oleg@redhat.com, rientjes@google.com, akpm@linux-foundation.org
Cc: joseph.salisbury@canonical.com, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create() killable
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <53236AA2.7030105@canonical.com>
	<201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp>
In-Reply-To: <201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp>
Message-Id: <201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 17 Mar 2014 00:13:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16032014 #7529779, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Although the process who is sending SIGKILL to systemd-udevd is not
identified yet, adding wait_for_completion_timeout() can solve this
regression. Therefore, I'd like to propose this patch for 3.14-final
and 3.13-stable.

Regards.
----------
>From c6562e5d774dd1f36724197dbcb8976cccfaab53 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 16 Mar 2014 22:44:23 +0900
Subject: [PATCH] kthread: Do not leave kthread_create() immediately upon SIGKILL.

Commit 786235ee "kthread: make kthread_create() killable" changed to
leave kthread_create() as soon as receiving SIGKILL. But this change
caused boot failures if systemd-udevd received SIGKILL (probably due
to timeout) while loading SCSI controller drivers using
finit_module() [1].

Therefore, this patch changes kthread_create() to wait for 10 more
seconds after receiving SIGKILL, unless chosen by the OOM killer,
in order to give the kthreadd a chance to complete the request.

  [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@vger.kernel.org> [3.13+]
---
 kernel/kthread.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b5ae3ee..52ae7dc 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -292,6 +292,17 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 	 * new kernel thread.
 	 */
 	if (unlikely(wait_for_completion_killable(&done))) {
+		int i = 0;
+
+		/*
+		 * I got SIGKILL, but wait for 10 more seconds for completion
+		 * unless chosen by the OOM killer. This delay is there as a
+		 * workaround for boot failure caused by SIGKILL upon device
+		 * driver initialization timeout.
+		 */
+		while (i++ < 10 && !test_tsk_thread_flag(current, TIF_MEMDIE))
+			if (wait_for_completion_timeout(&done, HZ))
+				goto ready;
 		/*
 		 * If I was SIGKILLed before kthreadd (or new kernel thread)
 		 * calls complete(), leave the cleanup of this structure to
@@ -305,6 +316,7 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 		 */
 		wait_for_completion(&done);
 	}
+ready:
 	task = create->result;
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
-- 
1.7.1
