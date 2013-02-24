Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3BXSi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 13:38:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3BXSi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 13:38:27 -0500
Date: Sun, 24 Feb 2013 19:36:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] freezer: do not send a fake signal to a PF_DUMPCORE
	thread
Message-ID: <20130224183656.GA8903@redhat.com>
References: <20130224173144.GA32179@redhat.com> <20130224173206.GA32206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130224173206.GA32206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A coredumping thread can't be frozen anyway but the fake signal sent
by freeze_task() can confuse dump_write/wait_for_dump_helpers/etc
and interrupt the coredump.

We are going to make the do_coredump() paths freezable but the fake
TIF_SIGPENDING doesn't help, it only makes sense when we assume that
the target can return to user-mode and call get_signal_to_deliver().

Change freeze_task() to check PF_DUMPCORE along with PF_KTHREAD. We
need to recheck PF_DUMPCORE under ->siglock to avoid the race with
zap_threads() which can set this flag right before we take the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/freezer.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index c38893b..595afab 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -85,14 +85,21 @@ bool __refrigerator(bool check_kthr_stop)
 }
 EXPORT_SYMBOL(__refrigerator);
 
-static void fake_signal_wake_up(struct task_struct *p)
+static bool fake_signal_wake_up(struct task_struct *p)
 {
 	unsigned long flags;
+	bool ret = false;
+
+	if (p->flags & (PF_KTHREAD | PF_DUMPCORE))
+		return ret;
 
 	if (lock_task_sighand(p, &flags)) {
-		signal_wake_up(p, 0);
+		ret = !(p->flags & PF_DUMPCORE);
+		if (ret)
+			signal_wake_up(p, 0);
 		unlock_task_sighand(p, &flags);
 	}
+	return ret;
 }
 
 /**
@@ -100,8 +107,8 @@ static void fake_signal_wake_up(struct task_struct *p)
  * @p: task to send the request to
  *
  * If @p is freezing, the freeze request is sent either by sending a fake
- * signal (if it's not a kernel thread) or waking it up (if it's a kernel
- * thread).
+ * signal (if it's not a kernel thread or a coredumping thread) or waking
+ * it up otherwise.
  *
  * RETURNS:
  * %false, if @p is not freezing or already frozen; %true, otherwise
@@ -116,9 +123,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & PF_KTHREAD))
-		fake_signal_wake_up(p);
-	else
+	if (!fake_signal_wake_up(p))
 		wake_up_state(p, TASK_INTERRUPTIBLE);
 
 	spin_unlock_irqrestore(&freezer_lock, flags);
-- 
1.5.5.1


