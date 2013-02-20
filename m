Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab3BTVBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:01:24 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64754 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935392Ab3BTVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:01:21 -0500
Date: Wed, 20 Feb 2013 13:01:16 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] posix-timer: don't call idr_find() w/ negative ID
Message-ID: <20130220210116.GD3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512522CF.1020901@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent idr updates make idr_find() trigger WARN_ON_ONCE() before
returning NULL when a negative ID is specified.  Apparently,
posix-timer::__lock_timer() was depending on idr_find() returning NULL
on negative ID, thus triggering the new WARN_ON_ONCE().  Make
__lock_timer() first check whether @timer_id is negative and return
NULL without invoking idr_find() if so.

Note that the previous code was theoretically broken.  idr_find()
masked off the sign bit before performing lookup and if the matching
IDs were in use, it would have returned pointer for the incorrect
entry.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Sasha, can you please test whether this makes the warning go away?

Thanks.

 kernel/posix-timers.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index b51bb08..92465f9 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -637,6 +637,9 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 
+	if ((int)timer_id < 0)
+		return NULL;
+
 	rcu_read_lock();
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
