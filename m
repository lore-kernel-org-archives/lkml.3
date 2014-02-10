Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaBJQVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:21:49 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:59823 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbaBJQVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:21:47 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFT][PATCH 07/12] isa: change isa bus power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:30 -0700
Message-Id: <7ba97d2e7665008d0db89a7a36333394e5596a5e.1392040068.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change isa bus driver to register pm ops using dev_pm_ops instead of
legacy pm_ops. .pm hooks call existing legacy suspend and resume
interfaces by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/isa.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index 91dba65..15b8825 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -63,7 +63,7 @@ static void isa_bus_shutdown(struct device *dev)
 		isa_driver->shutdown(dev, to_isa_dev(dev)->id);
 }
 
-static int isa_bus_suspend(struct device *dev, pm_message_t state)
+static int __isa_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct isa_driver *isa_driver = dev->platform_data;
 
@@ -73,6 +73,21 @@ static int isa_bus_suspend(struct device *dev, pm_message_t state)
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
+static int isa_bus_poweroff(struct device *dev)
+{
+	return __isa_bus_suspend(dev, PMSG_HIBERNATE);
+}
+
 static int isa_bus_resume(struct device *dev)
 {
 	struct isa_driver *isa_driver = dev->platform_data;
@@ -83,14 +98,23 @@ static int isa_bus_resume(struct device *dev)
 	return 0;
 }
 
+static const struct dev_pm_ops isa_bus_dev_pm_ops = {
+	.suspend = isa_bus_suspend,
+	.resume = isa_bus_resume,
+	/* Hibernate callbacks */
+	.freeze = isa_bus_freeze,
+	.thaw = isa_bus_resume,
+	.poweroff = isa_bus_poweroff,
+	.restore = isa_bus_resume,
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

