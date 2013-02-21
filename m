Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3BUQjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:39:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3BUQjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:39:43 -0500
Date: Thu, 21 Feb 2013 08:38:25 -0800
From: tip-bot for Tejun Heo <tipbot@zytor.com>
Message-ID: <tip-e182bb38d7db7494fa5dcd82da17fe0dedf60ecf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20130220232412.GL3570@htj.dyndns.org>
References: <20130220232412.GL3570@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] posix-timer: Don't call idr_find()
  with out-of-range ID
Git-Commit-ID: e182bb38d7db7494fa5dcd82da17fe0dedf60ecf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Feb 2013 08:38:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e182bb38d7db7494fa5dcd82da17fe0dedf60ecf
Gitweb:     http://git.kernel.org/tip/e182bb38d7db7494fa5dcd82da17fe0dedf60ecf
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 20 Feb 2013 15:24:12 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 21 Feb 2013 17:28:29 +0100

posix-timer: Don't call idr_find() with out-of-range ID

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20130220232412.GL3570@htj.dyndns.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/posix-timers.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 10349d5..7edfe4b 100644
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
