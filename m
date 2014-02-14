Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBNWxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:53:16 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40602 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaBNWxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:53:03 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH v9] PM / Hibernate: use name_to_dev_t to parse resume
Date: Fri, 14 Feb 2014 14:52:56 -0800
Message-Id: <1392418376-30060-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392418376-30060-1-git-send-email-sebastian.capella@linaro.org>
References: <1392418376-30060-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the name_to_dev_t call to parse the device name echo'd to
to /sys/power/resume.  This imitates the method used in hibernate.c
in software_resume, and allows the resume partition to be specified
using other equivalent device formats as well.  By allowing
/sys/debug/resume to accept the same syntax as the resume=device
parameter, we can parse the resume=device in the init script and
use the resume device directly from the kernel command line.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
---
 kernel/power/hibernate.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 0121dab..a5f702a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -972,16 +972,20 @@ static ssize_t resume_show(struct kobject *kobj, struct kobj_attribute *attr,
 static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
 			    const char *buf, size_t n)
 {
-	unsigned int maj, min;
 	dev_t res;
-	int ret = -EINVAL;
+	int len = n;
+	char *name;
 
-	if (sscanf(buf, "%u:%u", &maj, &min) != 2)
-		goto out;
+	if (len && buf[len-1] == '\n')
+		len--;
+	name = kstrndup(buf, len, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
 
-	res = MKDEV(maj,min);
-	if (maj != MAJOR(res) || min != MINOR(res))
-		goto out;
+	res = name_to_dev_t(name);
+	kfree(name);
+	if (!res)
+		return -EINVAL;
 
 	lock_system_sleep();
 	swsusp_resume_device = res;
@@ -989,9 +993,7 @@ static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
 	printk(KERN_INFO "PM: Starting manual resume from disk\n");
 	noresume = 0;
 	software_resume();
-	ret = n;
- out:
-	return ret;
+	return n;
 }
 
 power_attr(resume);
-- 
1.7.9.5

