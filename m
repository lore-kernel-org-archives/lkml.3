Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3LSHy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:54:26 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50485 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3LSHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:54:21 -0500
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
Subject: [RFC PATCH 07/14] rtc-efi: add GMTOFF support to rtc_efi
Date: Thu, 19 Dec 2013 15:51:48 +0800
Message-Id: <1387439515-8926-8-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per UEFI 2.3.1 spec, we can use SetTime() to store the timezone value to
BIOS and get it back by GetTime(). It's good for installation system to
gain the default timezone setting from BIOS that was set by
manufacturer.

This patch adds 2 new iotrl: RTC_RD_GMTOFF and RTC_SET_GMTOFF to rtc_efi
support get/set gmt offset that mapping to the GUN's tm_gmtoff extension
(Seconds east of UTC).
Due the timezone definition of UEFI is "Localtime = UTC - TimeZone",
rtc_efi driver will transfer the format between GNU and EFI.

The logic of timezone only affect on x86 architecture and keep the
original EFI_UNSPECIFIED_TIMEZONE value on IA64.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/rtc/rtc-efi.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index c4c3843..e0e3c7e 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -75,7 +75,10 @@ convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
 	eft->second	= wtime->tm_sec;
 	eft->nanosecond = 0;
 	eft->daylight	= wtime->tm_isdst ? EFI_ISDST : 0;
+#ifdef CONFIG_IA64
+	/* avoid overwrite timezone on non-IA64 platform. e.g. x86_64 */
 	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
+#endif
 }
 
 static void
@@ -108,6 +111,84 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	}
 }
 
+static int efi_read_gmtoff(struct device *dev, long int *arg)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+	s16 timezone;
+
+	status = efi.get_time(&eft, &cap);
+
+	if (status != EFI_SUCCESS) {
+		/* should never happen */
+		pr_err("efitime: can't read time\n");
+		return -EINVAL;
+	}
+
+	timezone = (s16)le16_to_cpu(eft.timezone);
+	*arg = EFI_UNSPECIFIED_TIMEZONE * 60;
+	if (abs(timezone) != EFI_UNSPECIFIED_TIMEZONE &&
+	    abs(timezone) <= 1440)
+		*arg = timezone * 60 * -1;
+
+	return 0;
+}
+
+static int efi_set_gmtoff(struct device *dev, long int arg)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+	s16 timezone;
+
+	/* transfer seconds east of UTC to minutes for ACPI */
+	timezone = arg / 60 * -1;
+	if (abs(timezone) > 1440 &&
+	    abs(timezone) != EFI_UNSPECIFIED_TIMEZONE)
+		return -EINVAL;
+
+	/* can not use -2047 */
+	if (timezone == EFI_UNSPECIFIED_TIMEZONE * -1)
+		timezone = EFI_UNSPECIFIED_TIMEZONE;
+
+	status = efi.get_time(&eft, &cap);
+
+	if (status != EFI_SUCCESS) {
+		pr_err("efitime: can't read time\n");
+		return -EINVAL;
+	}
+
+	eft.timezone = (s16)cpu_to_le16(timezone);
+	status = efi.set_time(&eft);
+	if (status != EFI_SUCCESS) {
+		pr_err("efitime: can't set timezone\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int efi_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	long int gmtoff;
+	int err;
+
+	switch (cmd) {
+	case RTC_RD_GMTOFF:
+		err = efi_read_gmtoff(dev, &gmtoff);
+		if (err)
+			return err;
+		return put_user(gmtoff, (unsigned long __user *)arg);
+	case RTC_SET_GMTOFF:
+		return efi_set_gmtoff(dev, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
 static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 {
 	efi_time_t eft;
@@ -172,6 +253,17 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 {
 	efi_status_t status;
 	efi_time_t eft;
+#ifdef CONFIG_X86
+	efi_time_cap_t cap;
+
+	/* read time for grab timezone to avoid overwrite it */
+	status = efi.get_time(&eft, &cap);
+
+	if (status != EFI_SUCCESS) {
+		pr_err("efitime: can't read time\n");
+		return -EINVAL;
+	}
+#endif
 
 	convert_to_efi_time(tm, &eft);
 
@@ -181,13 +273,16 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 static const struct rtc_class_ops efi_rtc_ops = {
+#ifdef CONFIG_X86
+	.ioctl = efi_rtc_ioctl,
+#endif
 	.read_time = efi_read_time,
 	.set_time = efi_set_time,
 	.read_alarm = efi_read_alarm,
 	.set_alarm = efi_set_alarm,
 };
 
-static int __init efi_rtc_probe(struct platform_device *dev)
+static int efi_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
@@ -196,6 +291,8 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
+	rtc->caps = (RTC_TZ_CAP | RTC_DST_CAP);
+
 	platform_set_drvdata(dev, rtc);
 
 	return 0;
@@ -213,3 +310,4 @@ module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
 MODULE_AUTHOR("dann frazier <dannf@hp.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("EFI RTC driver");
+MODULE_ALIAS("platform:rtc-efi");
-- 
1.6.4.2

