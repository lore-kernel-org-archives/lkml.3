Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3HARbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:31:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3HARbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:31:39 -0400
From: Miroslav Lichvar <mlichvar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] ntp: Make periodic RTC update more reliable
Date: Thu,  1 Aug 2013 19:31:35 +0200
Message-Id: <1375378295-3858-1-git-send-email-mlichvar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code requires that the scheduled update of the RTC happens
in the closest tick to the half of the second. This seems to be
difficult to achieve reliably. The scheduled work may be missing the
target time by a tick or two and be constantly rescheduled every second.

Relax the limit to 10 ticks. As a typical RTC drifts in the 11-minute
update interval by several milliseconds, this shouldn't affect the
overall accuracy of the RTC much.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
---
 kernel/time/ntp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8f5b3b9..ab1fa7c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -475,6 +475,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	 * called as close as possible to 500 ms before the new second starts.
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
+	 * We want the clock to be within a couple of ticks from the target.
 	 */
 	if (!ntp_synced()) {
 		/*
@@ -485,7 +486,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
-- 
1.8.3.1

