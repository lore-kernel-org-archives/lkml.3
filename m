Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3LSHyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:54:52 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59192 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3LSHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:54:49 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [RFC PATCH 10/14] rtc: improve and move week day computing function to rtc header
Date: Thu, 19 Dec 2013 15:51:51 +0800
Message-Id: <1387439515-8926-11-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to rtc-acpid and efi time used the same logic for computing
week day, so this patch moves code to rtc.h header file.

Additionally using a leap year algorithm to replace the for-loop
block in compute_wday for improve the performance. The first
version of algorithm is from Oliver Neukum.
---
 drivers/rtc/rtc-acpitad.c |   13 +------------
 include/linux/efi.h       |   13 +------------
 include/linux/rtc.h       |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/rtc/rtc-acpitad.c b/drivers/rtc/rtc-acpitad.c
index 065a033..bdf7ae1 100644
--- a/drivers/rtc/rtc-acpitad.c
+++ b/drivers/rtc/rtc-acpitad.c
@@ -32,23 +32,12 @@ compute_yday(struct acpi_time *acpit)
 static int
 compute_wday(struct acpi_time *acpit)
 {
-	int y;
-	int ndays = 0;
-
 	if (acpit->year < 1900) {
 		pr_err("ACPI year < 1900, invalid date\n");
 		return -1;
 	}
 
-	for (y = 1900; y < acpit->year; y++)
-		ndays += 365 + (is_leap_year(y) ? 1 : 0);
-
-	ndays += compute_yday(acpit);
-
-	/*
-	 * 1=1/1/1900 was a Monday
-	 */
-	return (ndays + 1) % 7;
+	return rtc_wday(acpit->day, acpit->month - 1, acpit->year);
 }
 
 static void
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3859f3e..1c78ae7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -177,23 +177,12 @@ compute_yday(efi_time_t *eft)
 static inline int
 compute_wday(efi_time_t *eft)
 {
-	int y;
-	int ndays = 0;
-
 	if (eft->year < 1998) {
 		pr_err("EFI year < 1998, invalid date\n");
 		return -1;
 	}
 
-	for (y = EFI_RTC_EPOCH; y < eft->year; y++)
-		ndays += 365 + (is_leap_year(y) ? 1 : 0);
-
-	ndays += compute_yday(eft);
-
-	/*
-	 * 4=1/1/1998 was a Thursday
-	 */
-	return (ndays + 4) % 7;
+	return rtc_wday(eft->day, eft->month - 1, eft->year);
 }
 
 static inline void
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index e6380ec..511884f 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -196,6 +196,44 @@ static inline bool is_leap_year(unsigned int year)
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
 
+#define SINCE1900 25    /* valid from 2000 */
+
+static inline int rtc_wday(unsigned int day, unsigned int month, unsigned int year)
+{
+	int ndays, correction;
+	int base;
+
+	if (year < 1900) {
+		pr_err("rtc: year < 1900, invalid date\n");
+		return -1;
+	}
+
+	if (year >= 2000)
+		base = year - 2000;
+	else
+		base = year - 1900;
+
+	correction = 0;
+	if (base >= 0) {
+		correction += base / 4;
+		correction -= base / 100;
+		correction += base / 400;
+		if (year >= 2000)
+			correction += SINCE1900;
+
+		/* later rtc_year_days will add the leap day of current year */
+		correction -= ((is_leap_year(year)) ? 1 : 0);
+	}
+
+	ndays = (year - 1900) * 365 + correction;
+	ndays += rtc_year_days(day, month, year);
+
+	/*
+	 * 1=1/1/1900 was a Monday
+	 */
+	return (ndays + 1) % 7;
+}
+
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 extern int rtc_hctosys_ret;
 #else
-- 
1.6.4.2

