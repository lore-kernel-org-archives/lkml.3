Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3LSMiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:38:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3LSL5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 097/208] ntp: Make periodic RTC update more reliable
Date: Thu, 19 Dec 2013 11:53:15 +0000
Message-Id: <1387454106-19326-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miroslav Lichvar <mlichvar@redhat.com>

commit a97ad0c4b447a132a322cedc3a5f7fa4cab4b304 upstream.

The current code requires that the scheduled update of the RTC happens
in the closest tick to the half of the second. This seems to be
difficult to achieve reliably. The scheduled work may be missing the
target time by a tick or two and be constantly rescheduled every second.

Relax the limit to 10 ticks. As a typical RTC drifts in the 11-minute
update interval by several milliseconds, this shouldn't affect the
overall accuracy of the RTC much.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/ntp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index bb22151..af8d1d4 100644
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
1.8.3.2

