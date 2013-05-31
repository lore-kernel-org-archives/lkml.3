Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3EaRJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:09:20 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:38655 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab3EaRJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:09:12 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: a.zummo@towertech.it, rafael.j.wysocki@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH v2] drivers/rtc/class: Convert from Legacy pm ops to dev_pm_ops
Date: Fri, 31 May 2013 11:08:42 -0600
Message-Id: <1370020122-29869-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/rtc/class to use dev_pm_ops for power management and
remove Legacy PM ops hooks. With this change, rtc class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume. When __device_suspend() runs call-backs, it will
find class->pm ops for the rtc class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com> 
---
 drivers/rtc/class.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 6638540..f379bff 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -47,7 +47,7 @@ int rtc_hctosys_ret = -ENODEV;
 static struct timespec old_rtc, old_system, old_delta;
 
 
-static int rtc_suspend(struct device *dev, pm_message_t mesg)
+static int rtc_suspend(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
@@ -135,9 +135,9 @@ static int rtc_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
 #else
-#define rtc_suspend	NULL
-#define rtc_resume	NULL
+#define rtc_class_dev_pm_ops	NULL
 #endif
 
 
@@ -336,8 +336,7 @@ static int __init rtc_init(void)
 		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
-	rtc_class->suspend = rtc_suspend;
-	rtc_class->resume = rtc_resume;
+	rtc_class->pm = &rtc_class_dev_pm_ops;
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
 	return 0;
-- 
1.7.10.4

