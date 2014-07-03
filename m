Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaGCDBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 23:01:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59391 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754027AbaGCDA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 23:00:57 -0400
Message-Id: <20140703030055.201144423@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 02 Jul 2014 23:00:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RT 1/2] Fix latency histogram after "hrtimer: Set expiry time before
 switch_hrtimer_base()"
References: <20140703030043.202302661@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-Fix-latency-histogram-after-hrtimer-Set-expiry-time-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rt88-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

In an rt-kernel with CONFIG_MISSED_TIMER_OFFSETS_HIST enabled,
__hrtimer_start_range_ns() now crashes, as new_base is not assigned
before it is used.

Tested-by: Carsten Emde <C.Emde@osadl.org>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/hrtimer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f54379023e16..2bd88f06a6d0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1033,6 +1033,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 #endif
 	}
 
+	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
+
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 	{
 		ktime_t now = new_base->get_time();
@@ -1044,11 +1049,6 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 #endif
 
-	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
-
-	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
-
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
-- 
2.0.0


