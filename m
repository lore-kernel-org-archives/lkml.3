Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161511Ab3LFWHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:07:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446Ab3LFVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.10 56/58] ntp: Make periodic RTC update more reliable
Date: Fri,  6 Dec 2013 13:52:27 -0800
Message-Id: <20131206214850.071902802@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/ntp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -475,6 +475,7 @@ static void sync_cmos_clock(struct work_
 	 * called as close as possible to 500 ms before the new second starts.
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
+	 * We want the clock to be within a couple of ticks from the target.
 	 */
 	if (!ntp_synced()) {
 		/*
@@ -485,7 +486,7 @@ static void sync_cmos_clock(struct work_
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;


