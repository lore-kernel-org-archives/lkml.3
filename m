Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaJIV0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:26:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaJIVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 061/163] futex: Unlock hb->lock in futex_wait_requeue_pi() error path
Date: Thu,  9 Oct 2014 14:01:26 -0700
Message-Id: <1412888588-26755-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

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
[ kamal: backport to 3.13-stable: queue_unlock() args ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index c265aac..4741b1f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2465,6 +2465,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(&q, hb);
 		ret = -EINVAL;
 		goto out_put_keys;
 	}
-- 
1.9.1

