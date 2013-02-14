Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab3BNRDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068Ab3BNRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:03:45 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Thu, 14 Feb 2013 12:02:55 -0500
Message-Id: <1360861375-24131-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1360861375-24131-1-git-send-email-prarit@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
read-only access.  This patch introduces write functionality which will
set the rtc time.

Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
       echo HH:MM:SS > /sys/class/rtc/rtcX/time

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: x86@kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: linux-efi@vger.kernel.org
---
 drivers/rtc/rtc-sysfs.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index b70e2bb..87d63d7 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -48,6 +48,46 @@ rtc_sysfs_show_date(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+rtc_sysfs_store_date(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	ssize_t retval;
+	struct rtc_time tm;
+	char tmp[11] = "\0", *tmpptr = tmp;
+	char *cyear, *cmonth, *cday;
+	int year, month, day;
+
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	/* from rtc_sysfs_show_date(): date string format is YYYY-MM-DD */
+	if (strlen(buf) != 11)
+		return -EINVAL;
+
+	strncpy(tmp, buf, 11);
+	cyear = strsep(&tmpptr, "-");
+	sscanf(cyear, "%i", &year);
+	cmonth = strsep(&tmpptr, "-");
+	sscanf(cmonth, "%i", &month);
+	cday = strsep(&tmpptr, "-");
+	sscanf(cday, "%i", &day);
+
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return -ENODEV;
+
+	tm.tm_year = year - 1900;
+	tm.tm_mon = month - 1;
+	tm.tm_mday = day;
+
+	retval = rtc_set_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return retval;
+
+	return count;
+}
+
+static ssize_t
 rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -64,6 +104,46 @@ rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+rtc_sysfs_store_time(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	ssize_t retval;
+	struct rtc_time tm;
+	char tmp[9] = "\0", *tmpptr = tmp;
+	char *chour, *cmin, *csec;
+	int hour, min, sec;
+
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	/* from rtc_sysfs_show_time(): time string format is HH:MM:SS */
+	if (strlen(buf) != 9)
+		return -EINVAL;
+
+	strncpy(tmp, buf, 9);
+	chour = strsep(&tmpptr, ":");
+	sscanf(chour, "%i", &hour);
+	cmin = strsep(&tmpptr, ":");
+	sscanf(cmin, "%i", &min);
+	csec = strsep(&tmpptr, ":");
+	sscanf(csec, "%i", &sec);
+
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return -ENODEV;
+
+	tm.tm_hour = hour;
+	tm.tm_min = min;
+	tm.tm_sec = sec;
+
+	retval = rtc_set_time(to_rtc_device(dev), &tm);
+	if (retval)
+		return retval;
+
+	return count;
+}
+
+static ssize_t
 rtc_sysfs_show_since_epoch(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -124,8 +204,10 @@ rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
 
 static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
-	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
-	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
+	__ATTR(date, S_IRUGO | S_IWUGO, rtc_sysfs_show_date,
+	       rtc_sysfs_store_date),
+	__ATTR(time, S_IRUGO | S_IWUGO, rtc_sysfs_show_time,
+	       rtc_sysfs_store_time),
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
 	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
 			rtc_sysfs_set_max_user_freq),
-- 
1.8.1.2

