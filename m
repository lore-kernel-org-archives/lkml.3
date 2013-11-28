Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab3K1TdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:33:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300Ab3K1Tc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:32:58 -0500
Date: Thu, 28 Nov 2013 20:33:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/1] usermodehelper: kill
	____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131128193349.GB24767@redhat.com>
References: <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128142359.GA6420@redhat.com> <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128193330.GA24767@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

____call_usermodehelper() does set_cpus_allowed_ptr(cpu_all_mask),
this (and the comment) is misleading. We no longer have keventd_wq,
and kmod.c switched to khelper_wq a long ago.

And more importantly, "unlike our parent" is no longer true too,
this thread was created by WQ_UNBOUND worker thread which has the
full ->cpus_allowed mask, so this set_cpus_allowed_ptr() is simply
unnecessary.

Perhaps we will change this later, so that userspace can control
the affinity of the usermode helper tasks, but this is yet another
reason to remove this set_cpus_allowed_ptr().

To some degree this also applies to set_user_nice(), but this
patch only updates the comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index b086006..2fe4544 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -208,13 +208,9 @@ static int ____call_usermodehelper(void *data)
 	spin_lock_irq(&current->sighand->siglock);
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
-
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
-
 	/*
-	 * Our parent is keventd, which runs with elevated scheduling priority.
-	 * Avoid propagating that into the userspace child.
+	 * Our parent is a workqueue thread, which can run with elevated
+	 * scheduling priority. Avoid propagating that into the userspace.
 	 */
 	set_user_nice(current, 0);
 
-- 
1.5.5.1


