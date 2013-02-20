Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3BTWka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:40:30 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55886 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3BTWk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:40:27 -0500
Date: Wed, 20 Feb 2013 14:40:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] posix-timer: don't call idr_find() w/ out-of-range ID
Message-ID: <20130220224019.GI3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
 <20130220210116.GD3570@htj.dyndns.org>
 <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org>
 <20130220140551.8017e795.akpm@linux-foundation.org>
 <20130220220823.GH3570@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220220823.GH3570@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When idr_find() is fed a negative ID, it used to look up the ID
ignoring the sign bit before recent ("idr: remove MAX_IDR_MASK and
move left MAX_IDR_* into idr.c") patch, and triggers WARN_ON_ONCE()
after it.

__lock_timer() feeds timer_id from userland directly to idr_find()
without sanitizing it which can trigger the above malfunctions.  Add a
range check on @timer_id before invoking idr_find() in __lock_timer().

While timer_t is defined as int by all archs at the moment, Andrew
worries that it may be defined as a larger type later on.  Make the
test cover larger integers too so that it at least is guaranteed to
not return the wrong timer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
---
 kernel/posix-timers.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index b51bb08..6edbb2c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -637,6 +637,13 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
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
