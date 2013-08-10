Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399Ab3HJPWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:22:33 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:56847 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934234Ab3HJPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:31 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] isa: Change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:46 -0600
Message-Id: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change isa bus to register dev_pm_ops via bus_type.pm. Add freeze ops for
PM_EVENT_FREEZE handling.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/isa.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index 91dba65..0f5943f 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -63,7 +63,7 @@ static void isa_bus_shutdown(struct device *dev)
 		isa_driver->shutdown(dev, to_isa_dev(dev)->id);
 }
 
-static int isa_bus_suspend(struct device *dev, pm_message_t state)
+static int __isa_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct isa_driver *isa_driver = dev->platform_data;
 
@@ -73,6 +73,16 @@ static int isa_bus_suspend(struct device *dev, pm_message_t state)
 	return 0;
 }
 
+static int isa_bus_suspend(struct device *dev)
+{
+	return __isa_bus_suspend(dev, PMSG_SUSPEND);
+}
+
+static int isa_bus_freeze(struct device *dev)
+{
+	return __isa_bus_suspend(dev, PMSG_FREEZE);
+}
+
 static int isa_bus_resume(struct device *dev)
 {
 	struct isa_driver *isa_driver = dev->platform_data;
@@ -83,14 +93,19 @@ static int isa_bus_resume(struct device *dev)
 	return 0;
 }
 
+static const struct dev_pm_ops isa_bus_dev_pm_ops = {
+	.suspend = isa_bus_suspend,
+	.freeze = isa_bus_freeze,
+	.resume = isa_bus_resume,
+};
+
 static struct bus_type isa_bus_type = {
 	.name		= "isa",
 	.match		= isa_bus_match,
 	.probe		= isa_bus_probe,
 	.remove		= isa_bus_remove,
 	.shutdown	= isa_bus_shutdown,
-	.suspend	= isa_bus_suspend,
-	.resume		= isa_bus_resume
+	.pm		= &isa_bus_dev_pm_ops,
 };
 
 static void isa_dev_release(struct device *dev)
-- 
1.7.10.4

