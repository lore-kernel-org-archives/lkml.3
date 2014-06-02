Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbaFBOJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:09:21 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:58289 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaFBOJT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 2 Jun 2014 10:09:19 -0400
Message-Id: <538CA1AC0200007800016DE9@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 02 Jun 2014 15:09:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.zummo@towertech.it>
Cc: <rtc-linux@googlegroups.com>, "Raymund Will" <rw@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc-efi: check for invalid data coming back from UEFI
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In particular seeing zero in eft->month is problematic, as it results
in -1 (converted to unsigned int, i.e. yielding 0xffffffff) getting
passed to rtc_year_days(), where the value gets used as an array index
(normally resulting in a crash). This was observed with the driver
enabled on x86 on some Fujitsu system (with possibly not up to date
firmware, but anyway).

Perhaps efi_read_alarm() should not fail if neither enabled nor pending
are set, but the returned time is invalid?

Reported-by: Raymund Will <rw@suse.de>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/rtc/rtc-efi.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- 3.15-rc8/drivers/rtc/rtc-efi.c
+++ 3.15-rc8-EFI-RTC-check-time/drivers/rtc/rtc-efi.c
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
 
@@ -78,19 +79,36 @@ convert_to_efi_time(struct rtc_time *wti
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
@@ -106,6 +124,8 @@ convert_from_efi_time(efi_time_t *eft, s
 	default:
 		wtime->tm_isdst = -1;
 	}
+
+	return true;
 }
 
 static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
@@ -122,7 +142,8 @@ static int efi_read_alarm(struct device
 	if (status != EFI_SUCCESS)
 		return -EINVAL;
 
-	convert_from_efi_time(&eft, &wkalrm->time);
+	if (!convert_from_efi_time(&eft, &wkalrm->time))
+		return -EIO;
 
 	return rtc_valid_tm(&wkalrm->time);
 }
@@ -163,7 +184,8 @@ static int efi_read_time(struct device *
 		return -EINVAL;
 	}
 
-	convert_from_efi_time(&eft, tm);
+	if (!convert_from_efi_time(&eft, tm))
+		return -EIO;
 
 	return rtc_valid_tm(tm);
 }



