Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3CDDnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32926 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab3CDDnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:50 -0500
Message-Id: <20130304033716.283848524@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 088/153] posix-timer: Dont call idr_find() with out-of-range ID
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/posix-timers.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -639,6 +639,13 @@ static struct k_itimer *__lock_timer(tim
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


