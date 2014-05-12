Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbaELNfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:35:51 -0400
Received: from ns.horizon.com ([71.41.210.147]:36125 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756023AbaELNfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:35:50 -0400
Date: 12 May 2014 09:35:48 -0400
Message-ID: <20140512133548.31421.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org
Subject: [PATCH] ntp: make is_error_status() use its argument
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's an inline function always called with the global time_status as an
argument, so there's zero functional difference, but the non-CONFIG_SMP
version uses the passed-in argument, while the CONFIG_SMP one ignores
its argument and uses the global.
    
Make it use the argument always; shorter variable names are good.

Signed-off-by: George Spelvin <linux@horizon.com>
---
While poking about in the code, I came across this rather odd bit.
It looked worth fixing, on general principles.

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 419a52cecd..1a2aad3fff 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -165,21 +165,21 @@ static inline void pps_set_freq(s64 freq)
 
 static inline int is_error_status(int status)
 {
-	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
+	return (status & (STA_UNSYNC|STA_CLOCKERR))
 		/* PPS signal lost when either PPS time or
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
-			&& !(time_status & STA_PPSSIGNAL))
+		|| ((status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(status & STA_PPSSIGNAL))
 		/* PPS jitter exceeded when
 		 * PPS time synchronization requested */
-		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
+		|| ((status & (STA_PPSTIME|STA_PPSJITTER))
 			== (STA_PPSTIME|STA_PPSJITTER))
 		/* PPS wander exceeded or calibration error when
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & STA_PPSFREQ)
-			&& (time_status & (STA_PPSWANDER|STA_PPSERROR)));
+		|| ((status & STA_PPSFREQ)
+			&& (status & (STA_PPSWANDER|STA_PPSERROR)));
 }
 
 static inline void pps_fill_timex(struct timex *txc)
