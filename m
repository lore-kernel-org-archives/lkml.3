Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbaJCXPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:15:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbaJCWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "=?UTF-8?q?Dave=20 \"Trinity\" =20Jones?=" <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3.14 157/238] futex: Unlock hb->lock in futex_wait_requeue_pi() error path
Date: Fri,  3 Oct 2014 14:31:12 -0700
Message-Id: <20141003212918.699312857@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2614,6 +2614,7 @@ static int futex_wait_requeue_pi(u32 __u
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(hb);
 		ret = -EINVAL;
 		goto out_put_keys;
 	}


