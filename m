Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbbAGUwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:52:10 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36840 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbbAGUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:52:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2][RFC] ipmi: Update timespec usage to timespec64
Date: Wed,  7 Jan 2015 12:51:50 -0800
Message-Id: <1420663910-6406-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420663910-6406-1-git-send-email-john.stultz@linaro.org>
References: <1420663910-6406-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the internal y2038 cleanup, this patch removes
timespec usage in the ipmi driver, replacing it timespec64

Cc: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/char/ipmi/ipmi_si_intf.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index cc3a07d..814ba98 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -324,10 +324,10 @@ static void cleanup_ipmi_si(void);
 #ifdef DEBUG_TIMING
 void debug_timestamp(char *msg)
 {
-	struct timeval t;
+	struct timespec64 t;
 
-	do_gettimeofday(&t);
-	pr_debug("**%s: %d.%9.9d\n", msg, t.tv_sec, t.tv_usec);
+	do_getnstimeofday64(&t);
+	pr_debug("**%s: %lld.%9.9d\n", msg, (long long) t.tv_sec, t.tv_usec);
 }
 #else
 #define debug_timestamp(x)
@@ -988,18 +988,18 @@ static void set_run_to_completion(void *send_info, bool i_run_to_completion)
  * we are spinning in kipmid looking for something and not delaying
  * between checks
  */
-static inline void ipmi_si_set_not_busy(struct timespec *ts)
+static inline void ipmi_si_set_not_busy(struct timespec64 *ts)
 {
 	ts->tv_nsec = -1;
 }
-static inline int ipmi_si_is_busy(struct timespec *ts)
+static inline int ipmi_si_is_busy(struct timespec64 *ts)
 {
 	return ts->tv_nsec != -1;
 }
 
 static inline int ipmi_thread_busy_wait(enum si_sm_result smi_result,
 					const struct smi_info *smi_info,
-					struct timespec *busy_until)
+					struct timespec64 *busy_until)
 {
 	unsigned int max_busy_us = 0;
 
@@ -1008,12 +1008,13 @@ static inline int ipmi_thread_busy_wait(enum si_sm_result smi_result,
 	if (max_busy_us == 0 || smi_result != SI_SM_CALL_WITH_DELAY)
 		ipmi_si_set_not_busy(busy_until);
 	else if (!ipmi_si_is_busy(busy_until)) {
-		getnstimeofday(busy_until);
-		timespec_add_ns(busy_until, max_busy_us*NSEC_PER_USEC);
+		getnstimeofday64(busy_until);
+		timespec64_add_ns(busy_until, max_busy_us*NSEC_PER_USEC);
 	} else {
-		struct timespec now;
-		getnstimeofday(&now);
-		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
+		struct timespec64 now;
+
+		getnstimeofday64(&now);
+		if (unlikely(timespec64_compare(&now, busy_until) > 0)) {
 			ipmi_si_set_not_busy(busy_until);
 			return 0;
 		}
@@ -1036,7 +1037,7 @@ static int ipmi_thread(void *data)
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
-	struct timespec busy_until;
+	struct timespec64 busy_until;
 
 	ipmi_si_set_not_busy(&busy_until);
 	set_user_nice(current, MAX_NICE);
-- 
1.9.1

