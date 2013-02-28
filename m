Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840Ab3B1O6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:58:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891Ab3B1Oud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 113/139] posix-timer: Don't call idr_find() with out-of-range ID
Date: Thu, 28 Feb 2013 14:44:23 +0000
Message-Id: <1362062689-2567-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e182bb38d7db7494fa5dcd82da17fe0dedf60ecf upstream.

When idr_find() was fed a negative ID, it used to look up the ID
ignoring the sign bit before recent ("idr: remove MAX_IDR_MASK and
move left MAX_IDR_* into idr.c") patch. Now a negative ID triggers
a WARN_ON_ONCE().

__lock_timer() feeds timer_id from userland directly to idr_find()
without sanitizing it which can trigger the above malfunctions.  Add a
range check on @timer_id before invoking idr_find() in __lock_timer().

While timer_t is defined as int by all archs at the moment, Andrew
worries that it may be defined as a larger type later on.  Make the
test cover larger integers too so that it at least is guaranteed to
not return the wrong timer.

Note that WARN_ON_ONCE() in idr_find() on id < 0 is transitional
precaution while moving away from ignoring MSB.  Once it's gone we can
remove the guard as long as timer_t isn't larger than int.

Signed-off-by: Tejun Heo <tj@kernel.org>nnn
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130220232412.GL3570@htj.dyndns.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/posix-timers.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..e885be1 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -639,6 +639,13 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 
+	/*
+	 * timer_t could be any type >= int and we want to make sure any
+	 * @timer_id outside positive int range fails lookup.
+	 */
+	if ((unsigned long long)timer_id > INT_MAX)
+		return NULL;
+
 	rcu_read_lock();
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
-- 
1.8.1.2

