Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaHTMRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:17:01 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59575 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbaHTMQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:16:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/104] drivers/rtc/rtc-efi.c: check for invalid data coming back from UEFI
Date: Wed, 20 Aug 2014 13:44:06 +0200
Message-Id: <461e904ed60b18ef3e47ca2add4b73dba9b33ae0.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6e85bab6bc1019f9b87c53b32da3ad7791e7ddf9 upstream.

In particular seeing zero in eft->month is problematic, as it results in
-1 (converted to unsigned int, i.e.  yielding 0xffffffff) getting passed
to rtc_year_days(), where the value gets used as an array index
(normally resulting in a crash).  This was observed with the driver
enabled on x86 on some Fujitsu system (with possibly not up to date
firmware, but anyway).

Perhaps efi_read_alarm() should not fail if neither enabled nor pending
are set, but the returned time is invalid?

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reported-by: Raymund Will <rw@suse.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/rtc/rtc-efi.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index c4c38431012e..8225b89de810 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -17,6 +17,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/stringify.h>
 #include <linux/time.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
@@ -48,8 +49,8 @@ compute_wday(efi_time_t *eft)
 	int y;
 	int ndays = 0;
 
-	if (eft->year < 1998) {
-		pr_err("EFI year < 1998, invalid date\n");
+	if (eft->year < EFI_RTC_EPOCH) {
+		pr_err("EFI year < " __stringify(EFI_RTC_EPOCH) ", invalid date\n");
 		return -1;
 	}
 
@@ -78,19 +79,36 @@ convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
 	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
 }
 
-static void
+static bool
 convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 {
 	memset(wtime, 0, sizeof(*wtime));
+
+	if (eft->second >= 60)
+		return false;
 	wtime->tm_sec  = eft->second;
+
+	if (eft->minute >= 60)
+		return false;
 	wtime->tm_min  = eft->minute;
+
+	if (eft->hour >= 24)
+		return false;
 	wtime->tm_hour = eft->hour;
+
+	if (!eft->day || eft->day > 31)
+		return false;
 	wtime->tm_mday = eft->day;
+
+	if (!eft->month || eft->month > 12)
+		return false;
 	wtime->tm_mon  = eft->month - 1;
 	wtime->tm_year = eft->year - 1900;
 
 	/* day of the week [0-6], Sunday=0 */
 	wtime->tm_wday = compute_wday(eft);
+	if (wtime->tm_wday < 0)
+		return false;
 
 	/* day in the year [1-365]*/
 	wtime->tm_yday = compute_yday(eft);
@@ -106,6 +124,8 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	default:
 		wtime->tm_isdst = -1;
 	}
+
+	return true;
 }
 
 static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
@@ -122,7 +142,8 @@ static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	if (status != EFI_SUCCESS)
 		return -EINVAL;
 
-	convert_from_efi_time(&eft, &wkalrm->time);
+	if (!convert_from_efi_time(&eft, &wkalrm->time))
+		return -EIO;
 
 	return rtc_valid_tm(&wkalrm->time);
 }
@@ -163,7 +184,8 @@ static int efi_read_time(struct device *dev, struct rtc_time *tm)
 		return -EINVAL;
 	}
 
-	convert_from_efi_time(&eft, tm);
+	if (!convert_from_efi_time(&eft, tm))
+		return -EIO;
 
 	return rtc_valid_tm(tm);
 }
-- 
2.0.4

