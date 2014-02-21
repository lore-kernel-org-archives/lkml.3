Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaBUVug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:50:36 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39791 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaBUVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:50:34 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH] [RFC] time: Improve negative offset handling in timekeeping_inject_offset
Date: Fri, 21 Feb 2014 13:50:30 -0800
Message-Id: <1393019430-13200-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The adjtimex() ADJ_SETOFFSET feature allows a offset in timespec
format to be added to the current time. This value can be positive
or negative. However, representing a negative value in a timespec
can be confusing, as there may be numerous ways to represent the
same amount of time.

Positive values are most obviously represented:
1)	{ 0,  500000000}
2)	{ 3,  0}
3)	{ 3,  500000000}

While negative values are more complex and confusing:
4)	{-5,  0}
5)	{ 0, -500000000}
6)	{-5, -500000000}
7)	{-6,  500000000}

Note that the last two values (#6 and #7) actually represent the
same amount of time.

In timekeeping_inject_offset, a likely naieve validation check
(implemented by me) on the timespec value resulted in -EINVAL
being returned if the nsec portion of the timespec was negative.

This resulted in the ADJ_SETOFFSET interface to consider examples
representations of {sec - 1, NSEC_PER_SEC + nsec} for negative
values (like example #7 above).

Initially I suspected the extra logic for underflow handling
was the reason this was done, but in looking at it,
set_normalized_timespec() handles both overflows and underflows
properly.

Thus this patch would allows for all of the representations
above to be considered valid.

There is of course, one missing example from the list above:
8)	{ 4, -500000000}

One could reasonably argue that examples #8 and #7 are simply
invalid timespecs, and we should have a rule:
* If tv_sec is nonzero, then the signs must agree.

I fully agree with this, but since the existing interface
only accepts #7 style negative timespecs, we have to continue
to support that style for this interface.

Another possible view is that the rule that the tv_nsec
value always be [0,1e9). And that while maybe non-intuitive,
the #7 style representations are valid and the existing
interface is correct, thus no further change is needed.

Thoughts? Comments?

I still need to do some further validation on this patch to
make sure it doesn't have any corner cases that breaks normal
time handling. But I wanted to get it out for wider discussion.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Reported-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..0b5ef8c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -539,7 +539,11 @@ int timekeeping_inject_offset(struct timespec *ts)
 	struct timespec tmp;
 	int ret = 0;
 
-	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+	/* Disallow any {1,-500} style timespecs */
+	if ((ts->tv_sec > 0) && ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC))
+		return -EINVAL;
+	/* While interval may be negative, should still be sane */
+	if (abs(ts->tv_nsec) >= NSEC_PER_SEC)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-- 
1.8.3.2

