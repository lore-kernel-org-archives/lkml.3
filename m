Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbaCEV1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:27:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbaCEV1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:27:05 -0500
Date: Wed, 5 Mar 2014 16:25:26 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mateusz Guzik <mguzik@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: [RFC PATCH] hrtimer: remove deadlock due to waiting on IPI in
 softirq context
Message-ID: <20140305162526.7d2ef1ab@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to be a deadlock in the hrtimer code. Specifically,
clock_was_set() calls an IPI with wait=1, from softirq context.

Waiting for IPIs to complete in irq context can lead to a deadlock,
because the current code (that was interrupted) might be holding some
kind of lock, that another CPU is waiting for with spin_lock_irq or
similar.

In other words, the current CPU may need to release a resource, before
the IPI can be handled by one of the destination CPUs.

To my untrained eye, it does not look like this patch introduces a
new bug to the timer code, but that is hard to ascertain with the
timer code. so I am posting this as an RFC for the timer gods to hurt
their brains on :)

This bug was introduced by 54cdfdb4 in early 2007 (the original
hrtimer code patch).

Not-yet-signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Mateusz Guzik <mguzik@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Clark Williams <williams@redhat.com>
---
 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0909436..19145ec 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -771,7 +771,7 @@ void clock_was_set(void)
 {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Retrigger the CPU local events everywhere */
-	on_each_cpu(retrigger_next_event, NULL, 1);
+	on_each_cpu(retrigger_next_event, NULL, 0);
 #endif
 	timerfd_clock_was_set();
 }
