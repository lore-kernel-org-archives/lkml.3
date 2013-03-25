Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab3CYUI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:08:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35817 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CYUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:26 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 1/8] ntp: Split out timex validation from do_adjtimex
Date: Mon, 25 Mar 2013 13:08:11 -0700
Message-Id: <1364242098-5977-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the timex validation done in do_adjtimex into a separate
function. This will help simplify logic in following patches.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 59e2749..457d2ba 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -622,17 +622,13 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		ntp_update_frequency();
 }
 
-/*
- * adjtimex mainly allows reading (and writing, if superuser) of
- * kernel time-keeping variables. used by xntpd.
+
+
+/**
+ * ntp_validate_timex - Ensures the timex is ok for use in do_adjtimex
  */
-int do_adjtimex(struct timex *txc)
+int ntp_validate_timex(struct timex *txc)
 {
-	struct timespec ts;
-	u32 time_tai, orig_tai;
-	int result;
-
-	/* Validate the data before disabling interrupts */
 	if (txc->modes & ADJ_ADJTIME) {
 		/* singleshot must not be used with any other mode bits */
 		if (!(txc->modes & ADJ_OFFSET_SINGLESHOT))
@@ -644,7 +640,6 @@ int do_adjtimex(struct timex *txc)
 		/* In order to modify anything, you gotta be super-user! */
 		 if (txc->modes && !capable(CAP_SYS_TIME))
 			return -EPERM;
-
 		/*
 		 * if the quartz is off by more than 10% then
 		 * something is VERY wrong!
@@ -655,12 +650,32 @@ int do_adjtimex(struct timex *txc)
 			return -EINVAL;
 	}
 
+	if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
+		return -EPERM;
+
+	return 0;
+}
+
+
+/*
+ * adjtimex mainly allows reading (and writing, if superuser) of
+ * kernel time-keeping variables. used by xntpd.
+ */
+int do_adjtimex(struct timex *txc)
+{
+	struct timespec ts;
+	u32 time_tai, orig_tai;
+	int result;
+
+	/* Validate the data before disabling interrupts */
+	result = ntp_validate_timex(txc);
+	if (result)
+		return result;
+
 	if (txc->modes & ADJ_SETOFFSET) {
 		struct timespec delta;
 		delta.tv_sec  = txc->time.tv_sec;
 		delta.tv_nsec = txc->time.tv_usec;
-		if (!capable(CAP_SYS_TIME))
-			return -EPERM;
 		if (!(txc->modes & ADJ_NANO))
 			delta.tv_nsec *= 1000;
 		result = timekeeping_inject_offset(&delta);
-- 
1.7.10.4

