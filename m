Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaILUKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:10:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaILUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:10:41 -0400
Date: Fri, 12 Sep 2014 13:10:16 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-13c42c2f43b19aab3195f2d357db00d1e885eaa8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, dvhart@linux.intel.com, davej@redhat.com,
        dave@stgolabs.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, a.p.zijlstra@chello.nl, davej@redhat.com,
        dave@stgolabs.net, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1409112318500.4178@nanos>
References: <alpine.DEB.2.10.1409112318500.4178@nanos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] futex: Unlock hb->
 lock in futex_wait_requeue_pi() error path
Git-Commit-ID: 13c42c2f43b19aab3195f2d357db00d1e885eaa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13c42c2f43b19aab3195f2d357db00d1e885eaa8
Gitweb:     http://git.kernel.org/tip/13c42c2f43b19aab3195f2d357db00d1e885eaa8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 11 Sep 2014 23:44:35 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 12 Sep 2014 22:04:36 +0200

futex: Unlock hb->lock in futex_wait_requeue_pi() error path

futex_wait_requeue_pi() calls futex_wait_setup(). If
futex_wait_setup() succeeds it returns with hb->lock held and
preemption disabled. Now the sanity check after this does:

        if (match_futex(&q.key, &key2)) {
	   	ret = -EINVAL;
		goto out_put_keys;
	}

which releases the keys but does not release hb->lock.

So we happily return to user space with hb->lock held and therefor
preemption disabled.

Unlock hb->lock before taking the exit route.

Reported-by: Dave "Trinity" Jones <davej@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1409112318500.4178@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index d3a9d94..815d7af 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2592,6 +2592,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(hb);
 		ret = -EINVAL;
 		goto out_put_keys;
 	}
