Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKPWA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:00:58 -0500
Received: from 1wt.eu ([62.212.114.60]:47934 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaKPWA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:56 -0500
Message-Id: <20141116215330.610444402@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:15 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>
Subject: [ 47/48] futex: Unlock hb->lock in futex_wait_requeue_pi()
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 error path

From: Thomas Gleixner <tglx@linutronix.de>

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
(cherry picked from commit 13c42c2f43b19aab3195f2d357db00d1e885eaa8)
[wt: 2.6.32 needs &q as first argument of queue_unlock()]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 55dd3d2..1e092d3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2414,6 +2414,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(&q, hb);
 		ret = -EINVAL;
 		goto out_put_keys;
 	}
-- 
1.7.12.2.21.g234cd45.dirty



