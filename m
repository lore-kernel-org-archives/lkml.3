Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaK0JIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:08:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:41736 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbaK0Irf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 36/91] futex: Unlock hb->lock in futex_wait_requeue_pi() error path
Date: Thu, 27 Nov 2014 16:42:19 +0800
Message-Id: <1417077794-9299-36-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 13c42c2f43b19aab3195f2d357db00d1e885eaa8 upstream.

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
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1409112318500.4178@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[lizf: Backported to 3.4: queue_unlock() takes two parameters]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 9396b7b..41dfb18 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2460,6 +2460,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(&q, hb);
 		ret = -EINVAL;
 		goto out_put_keys;
 	}
-- 
1.9.1

