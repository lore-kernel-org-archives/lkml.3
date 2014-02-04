Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaBDUoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:44:09 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35162 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586AbaBDUoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:44:04 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH v7 3/3] PM / Hibernate: use name_to_dev_t to parse resume
Date: Tue,  4 Feb 2014 12:43:51 -0800
Message-Id: <1391546631-7715-4-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org>
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
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
---
 kernel/power/hibernate.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index cd1e30c..3abd192 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -970,26 +970,27 @@ static ssize_t resume_show(struct kobject *kobj, struct kobj_attribute *attr,
 static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
 			    const char *buf, size_t n)
 {
-	unsigned int maj, min;
 	dev_t res;
-	int ret = -EINVAL;
+	char *name = kstrdup_trimnl(buf, GFP_KERNEL);
 
-	if (sscanf(buf, "%u:%u", &maj, &min) != 2)
-		goto out;
+	if (name == NULL)
+		return -ENOMEM;
 
-	res = MKDEV(maj,min);
-	if (maj != MAJOR(res) || min != MINOR(res))
-		goto out;
+	res = name_to_dev_t(name);
 
-	lock_system_sleep();
-	swsusp_resume_device = res;
-	unlock_system_sleep();
-	pr_info("PM: Starting manual resume from disk\n");
-	noresume = 0;
-	software_resume();
-	ret = n;
- out:
-	return ret;
+	if (res != 0) {
+		lock_system_sleep();
+		swsusp_resume_device = res;
+		unlock_system_sleep();
+		pr_info("PM: Starting manual resume from disk\n");
+		noresume = 0;
+		software_resume();
+	} else {
+		n = -EINVAL;
+	}
+
+	kfree(name);
+	return n;
 }
 
 power_attr(resume);
-- 
1.7.9.5

