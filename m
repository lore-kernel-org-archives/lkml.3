Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3LSHyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:54:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53613 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3LSHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:54:40 -0500
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
Subject: [RFC PATCH 09/14] efi: move functions of access efi time to header file for sharing
Date: Thu, 19 Dec 2013 15:51:50 +0800
Message-Id: <1387439515-8926-10-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have some functions, e.g. compute_yday, compute_wday, convert efi
time... are duplicated in efirtc, rtc-efi and will also used in rtc.c.
So this patch moved those functions of access efi time to efi.h header
file for sharing.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/char/efirtc.c |   98 ------------------------------------
 drivers/rtc/rtc-efi.c |  133 ++----------------------------------------------
 include/linux/efi.h   |  134 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 225 deletions(-)

diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index e39e740..8a30a02 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -41,109 +41,11 @@
 
 #define EFI_RTC_VERSION		"0.4"
 
-#define EFI_ISDST (EFI_TIME_ADJUST_DAYLIGHT|EFI_TIME_IN_DAYLIGHT)
-/*
- * EFI Epoch is 1/1/1998
- */
-#define EFI_RTC_EPOCH		1998
-
 static DEFINE_SPINLOCK(efi_rtc_lock);
 
 static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg);
 
-#define is_leap(year) \
-          ((year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0))
-
-static const unsigned short int __mon_yday[2][13] =
-{
-	/* Normal years.  */
-	{ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
-	/* Leap years.  */  
-	{ 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
-};
-
-/*
- * returns day of the year [0-365]
- */
-static inline int
-compute_yday(efi_time_t *eft)
-{
-	/* efi_time_t.month is in the [1-12] so, we need -1 */
-	return  __mon_yday[is_leap(eft->year)][eft->month-1]+ eft->day -1;
-}
-/*
- * returns day of the week [0-6] 0=Sunday
- *
- * Don't try to provide a year that's before 1998, please !
- */
-static int
-compute_wday(efi_time_t *eft)
-{
-	int y;
-	int ndays = 0;
-
-	if ( eft->year < 1998 ) {
-		printk(KERN_ERR "efirtc: EFI year < 1998, invalid date\n");
-		return -1;
-	}
-
-	for(y=EFI_RTC_EPOCH; y < eft->year; y++ ) {
-		ndays += 365 + (is_leap(y) ? 1 : 0);
-	}
-	ndays += compute_yday(eft);
-
-	/*
-	 * 4=1/1/1998 was a Thursday
-	 */
-	return (ndays + 4) % 7;
-}
-
-static void
-convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
-{
-
-	eft->year	= wtime->tm_year + 1900;
-	eft->month	= wtime->tm_mon + 1; 
-	eft->day	= wtime->tm_mday;
-	eft->hour	= wtime->tm_hour;
-	eft->minute	= wtime->tm_min;
-	eft->second 	= wtime->tm_sec;
-	eft->nanosecond = 0; 
-	eft->daylight	= wtime->tm_isdst ? EFI_ISDST: 0;
-	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
-}
-
-static void
-convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
-{
-	memset(wtime, 0, sizeof(*wtime));
-	wtime->tm_sec  = eft->second;
-	wtime->tm_min  = eft->minute;
-	wtime->tm_hour = eft->hour;
-	wtime->tm_mday = eft->day;
-	wtime->tm_mon  = eft->month - 1;
-	wtime->tm_year = eft->year - 1900;
-
-	/* day of the week [0-6], Sunday=0 */
-	wtime->tm_wday = compute_wday(eft);
-
-	/* day in the year [1-365]*/
-	wtime->tm_yday = compute_yday(eft);
-
-
-	switch (eft->daylight & EFI_ISDST) {
-		case EFI_ISDST:
-			wtime->tm_isdst = 1;
-			break;
-		case EFI_TIME_ADJUST_DAYLIGHT:
-			wtime->tm_isdst = 0;
-			break;
-		default:
-			wtime->tm_isdst = -1;
-	}
-}
-
 static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 693ea47..4687022 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -22,95 +22,6 @@
 #include <linux/rtc.h>
 #include <linux/efi.h>
 
-#define EFI_ISDST (EFI_TIME_ADJUST_DAYLIGHT|EFI_TIME_IN_DAYLIGHT)
-/*
- * EFI Epoch is 1/1/1998
- */
-#define EFI_RTC_EPOCH		1998
-
-/*
- * returns day of the year [0-365]
- */
-static inline int
-compute_yday(efi_time_t *eft)
-{
-	/* efi_time_t.month is in the [1-12] so, we need -1 */
-	return rtc_year_days(eft->day, eft->month - 1, eft->year);
-}
-/*
- * returns day of the week [0-6] 0=Sunday
- *
- * Don't try to provide a year that's before 1998, please !
- */
-static int
-compute_wday(efi_time_t *eft)
-{
-	int y;
-	int ndays = 0;
-
-	if (eft->year < 1998) {
-		pr_err("EFI year < 1998, invalid date\n");
-		return -1;
-	}
-
-	for (y = EFI_RTC_EPOCH; y < eft->year; y++)
-		ndays += 365 + (is_leap_year(y) ? 1 : 0);
-
-	ndays += compute_yday(eft);
-
-	/*
-	 * 4=1/1/1998 was a Thursday
-	 */
-	return (ndays + 4) % 7;
-}
-
-static void
-convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
-{
-	eft->year	= wtime->tm_year + 1900;
-	eft->month	= wtime->tm_mon + 1;
-	eft->day	= wtime->tm_mday;
-	eft->hour	= wtime->tm_hour;
-	eft->minute	= wtime->tm_min;
-	eft->second	= wtime->tm_sec;
-	eft->nanosecond = 0;
-	eft->daylight	= wtime->tm_isdst ? EFI_ISDST : 0;
-#ifdef CONFIG_IA64
-	/* avoid overwrite timezone on non-IA64 platform. e.g. x86_64 */
-	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
-#endif
-}
-
-static void
-convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
-{
-	memset(wtime, 0, sizeof(*wtime));
-	wtime->tm_sec  = eft->second;
-	wtime->tm_min  = eft->minute;
-	wtime->tm_hour = eft->hour;
-	wtime->tm_mday = eft->day;
-	wtime->tm_mon  = eft->month - 1;
-	wtime->tm_year = eft->year - 1900;
-
-	/* day of the week [0-6], Sunday=0 */
-	wtime->tm_wday = compute_wday(eft);
-
-	/* day in the year [1-365]*/
-	wtime->tm_yday = compute_yday(eft);
-
-
-	switch (eft->daylight & EFI_ISDST) {
-	case EFI_ISDST:
-		wtime->tm_isdst = 1;
-		break;
-	case EFI_TIME_ADJUST_DAYLIGHT:
-		wtime->tm_isdst = 0;
-		break;
-	default:
-		wtime->tm_isdst = -1;
-	}
-}
-
 static int efi_read_gmtoff(struct device *dev, long int *arg)
 {
 	efi_status_t status;
@@ -230,54 +141,22 @@ static int efi_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	return status == EFI_SUCCESS ? 0 : -EINVAL;
 }
 
-static int efi_read_time(struct device *dev, struct rtc_time *tm)
+static int efi_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	efi_status_t status;
-	efi_time_t eft;
-	efi_time_cap_t cap;
-
-	status = efi.get_time(&eft, &cap);
-
-	if (status != EFI_SUCCESS) {
-		/* should never happen */
-		dev_err(dev, "can't read time\n");
-		return -EINVAL;
-	}
-
-	convert_from_efi_time(&eft, tm);
-
-	return rtc_valid_tm(tm);
+	return efi_read_time(tm);
 }
 
-static int efi_set_time(struct device *dev, struct rtc_time *tm)
+static int efi_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	efi_status_t status;
-	efi_time_t eft;
-#ifdef CONFIG_X86
-	efi_time_cap_t cap;
-
-	/* read time for grab timezone to avoid overwrite it */
-	status = efi.get_time(&eft, &cap);
-
-	if (status != EFI_SUCCESS) {
-		pr_err("efitime: can't read time\n");
-		return -EINVAL;
-	}
-#endif
-
-	convert_to_efi_time(tm, &eft);
-
-	status = efi.set_time(&eft);
-
-	return status == EFI_SUCCESS ? 0 : -EINVAL;
+	return efi_set_time(tm);
 }
 
 static const struct rtc_class_ops efi_rtc_ops = {
 #ifdef CONFIG_X86
 	.ioctl = efi_rtc_ioctl,
 #endif
-	.read_time = efi_read_time,
-	.set_time = efi_set_time,
+	.read_time = efi_rtc_read_time,
+	.set_time = efi_rtc_set_time,
 	.read_alarm = efi_read_alarm,
 	.set_alarm = efi_set_alarm,
 };
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fc8fa0e..3859f3e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -132,6 +132,12 @@ typedef int (*efi_freemem_callback_t) (u64 start, u64 end, void *arg);
 #define EFI_TIME_ADJUST_DAYLIGHT 0x1
 #define EFI_TIME_IN_DAYLIGHT     0x2
 #define EFI_UNSPECIFIED_TIMEZONE 0x07ff
+#define EFI_ISDST		 (EFI_TIME_ADJUST_DAYLIGHT|EFI_TIME_IN_DAYLIGHT)
+
+/*
+ * EFI Epoch is 1/1/1998
+ */
+#define EFI_RTC_EPOCH           1998
 
 typedef struct {
 	u16 year;
@@ -154,6 +160,90 @@ typedef struct {
 } efi_time_cap_t;
 
 /*
+ * returns day of the year [0-365]
+ */
+static inline int
+compute_yday(efi_time_t *eft)
+{
+	/* efi_time_t.month is in the [1-12] so, we need -1 */
+	return rtc_year_days(eft->day, eft->month - 1, eft->year);
+}
+
+/*
+ * returns day of the week [0-6] 0=Sunday
+ *
+ * Don't try to provide a year that's before 1998, please !
+ */
+static inline int
+compute_wday(efi_time_t *eft)
+{
+	int y;
+	int ndays = 0;
+
+	if (eft->year < 1998) {
+		pr_err("EFI year < 1998, invalid date\n");
+		return -1;
+	}
+
+	for (y = EFI_RTC_EPOCH; y < eft->year; y++)
+		ndays += 365 + (is_leap_year(y) ? 1 : 0);
+
+	ndays += compute_yday(eft);
+
+	/*
+	 * 4=1/1/1998 was a Thursday
+	 */
+	return (ndays + 4) % 7;
+}
+
+static inline void
+convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
+{
+	memset(wtime, 0, sizeof(*wtime));
+	wtime->tm_sec  = eft->second;
+	wtime->tm_min  = eft->minute;
+	wtime->tm_hour = eft->hour;
+	wtime->tm_mday = eft->day;
+	wtime->tm_mon  = eft->month - 1;
+	wtime->tm_year = eft->year - 1900;
+
+	/* day of the week [0-6], Sunday=0 */
+	wtime->tm_wday = compute_wday(eft);
+
+	/* day in the year [1-365]*/
+	wtime->tm_yday = compute_yday(eft);
+
+	switch (eft->daylight & EFI_ISDST) {
+	case EFI_ISDST:
+		wtime->tm_isdst = 1;
+		break;
+	case EFI_TIME_ADJUST_DAYLIGHT:
+		wtime->tm_isdst = 0;
+		break;
+	default:
+		wtime->tm_isdst = -1;
+	}
+}
+
+static inline void
+convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
+{
+	eft->year       = wtime->tm_year + 1900;
+	eft->month      = wtime->tm_mon + 1;
+	eft->day        = wtime->tm_mday;
+	eft->hour       = wtime->tm_hour;
+	eft->minute     = wtime->tm_min;
+	eft->second     = wtime->tm_sec;
+	eft->nanosecond = 0;
+	eft->daylight   = wtime->tm_isdst ? EFI_ISDST : 0;
+#ifdef CONFIG_IA64
+	/* avoid overwrite timezone on non-IA64 platform. e.g. x86_64 */
+	eft->timezone   = EFI_UNSPECIFIED_TIMEZONE;
+#endif
+}
+
+
+/*
  * EFI Boot Services table
  */
 typedef struct {
@@ -585,6 +675,50 @@ efi_guid_unparse(efi_guid_t *guid, char *out)
         return out;
 }
 
+static inline int
+efi_set_time(struct rtc_time *tm)
+{
+	efi_status_t status;
+	efi_time_t eft;
+#ifdef CONFIG_X86
+	efi_time_cap_t cap;
+
+	/* read time for grab timezone to avoid overwrite it */
+	status = efi.get_time(&eft, &cap);
+
+	if (status != EFI_SUCCESS) {
+		pr_err("efi: can't read time\n");
+		return -EINVAL;
+	}
+#endif
+
+	convert_to_efi_time(tm, &eft);
+
+	status = efi.set_time(&eft);
+
+	return status == EFI_SUCCESS ? 0 : -EINVAL;
+}
+
+static inline int
+efi_read_time(struct rtc_time *tm)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+
+	status = efi.get_time(&eft, &cap);
+
+	if (status != EFI_SUCCESS) {
+		/* should never happen */
+		pr_err("efi: can't read time\n");
+		return -EINVAL;
+	}
+
+	convert_from_efi_time(&eft, tm);
+
+	return rtc_valid_tm(tm);
+}
+
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
-- 
1.6.4.2

