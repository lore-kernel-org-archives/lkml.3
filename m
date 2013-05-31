Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3EaP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:58:34 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:45834
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843Ab3EaP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:58:28 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: a.zummo@towertech.it, rafael.j.wysocki@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] drivers/rtc/class: Convert from Legacy pm ops to dev_pm_ops
Date: Fri, 31 May 2013 09:57:52 -0600
Message-Id: <1370015872-3560-1-git-send-email-shuah.kh@samsung.com>
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
---
 drivers/rtc/class.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 6638540..21d83ec 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
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

