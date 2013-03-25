Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3CYUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:09:22 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:56251 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267Ab3CYUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:32 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 5/8] timekeeping: Move ADJ_SETOFFSET to top level do_adjtimex()
Date: Mon, 25 Mar 2013 13:08:15 -0700
Message-Id: <1364242098-5977-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ADJ_SETOFFSET adjusts the timekeeping state, process
it as part of the top level do_adjtimex() function in
timekeeping.c.

This avoids deadlocks that could occur once we change the
ntp locking rules.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c         |   11 -----------
 kernel/time/timekeeping.c |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d17e13c..a331ebc 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -666,17 +666,6 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 {
 	int result;
 
-	if (txc->modes & ADJ_SETOFFSET) {
-		struct timespec delta;
-		delta.tv_sec  = txc->time.tv_sec;
-		delta.tv_nsec = txc->time.tv_usec;
-		if (!(txc->modes & ADJ_NANO))
-			delta.tv_nsec *= 1000;
-		result = timekeeping_inject_offset(&delta);
-		if (result)
-			return result;
-	}
-
 	raw_spin_lock_irq(&ntp_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5f7a233..e44915c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1627,6 +1627,17 @@ int do_adjtimex(struct timex *txc)
 	if (ret)
 		return ret;
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		ret = timekeeping_inject_offset(&delta);
+		if (ret)
+			return ret;
+	}
+
 	getnstimeofday(&ts);
 	orig_tai = tai = timekeeping_get_tai_offset();
 
-- 
1.7.10.4

