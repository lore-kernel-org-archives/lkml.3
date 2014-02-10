Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaBJUl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:41:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35694 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaBJUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:27 -0500
Message-Id: <20140210203659.734441092@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 6/8] mutex: Extra reschedule point
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=peterz-mutex-need_resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in an extra reschedule in an attempt to avoid getting reschedule
the moment we've acquired the lock.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/locking/mutex.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -468,6 +468,13 @@ __mutex_lock_common(struct mutex *lock,
 	}
 	osq_unlock(&lock->osq);
 slowpath:
+	/*
+	 * If we fell out of the spin path because of need_resched(),
+	 * reschedule now, before we try-lock the mutex. This avoids getting
+	 * scheduled out right after we obtained the mutex.
+	 */
+	if (unlikely(need_resched()))
+		schedule_preempt_disabled();
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 


