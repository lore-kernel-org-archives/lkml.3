Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaBJQPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:15:36 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:48794
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbaBJQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:15:32 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        shuahkhan@gmail.com
Subject: [RFT][PATCH 11/12] drivers/pcmcia: change ds driver power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:15:21 -0700
Message-Id: <4159bb4e4aa13212b1eac2be7e911ed18451ec9c.1392040068.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ds driver to register pm ops using dev_pm_ops instead of legacy
pm_ops. .pm hooks call existing legacy suspend and resume interfaces
by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/pcmcia/ds.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 757119b..2979323 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -962,7 +962,10 @@ static int pcmcia_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 /************************ runtime PM support ***************************/
 
-static int pcmcia_dev_suspend(struct device *dev, pm_message_t state);
+static int __pcmcia_dev_suspend(struct device *dev, pm_message_t state);
+static int pcmcia_dev_suspend(struct device *dev);
+static int pcmcia_dev_poweroff(struct device *dev);
+static int pcmcia_dev_freeze(struct device *dev);
 static int pcmcia_dev_resume(struct device *dev);
 
 static int runtime_suspend(struct device *dev)
@@ -970,7 +973,7 @@ static int runtime_suspend(struct device *dev)
 	int rc;
 
 	device_lock(dev);
-	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
+	rc = __pcmcia_dev_suspend(dev, PMSG_SUSPEND);
 	device_unlock(dev);
 	return rc;
 }
@@ -1120,7 +1123,22 @@ ATTRIBUTE_GROUPS(pcmcia_dev);
 
 /* PM support, also needed for reset */
 
-static int pcmcia_dev_suspend(struct device *dev, pm_message_t state)
+static int pcmcia_dev_suspend(struct device *dev)
+{
+	return __pcmcia_dev_suspend(dev, PMSG_SUSPEND);
+}
+
+static int pcmcia_dev_poweroff(struct device *dev)
+{
+	return __pcmcia_dev_suspend(dev, PMSG_HIBERNATE);
+}
+
+static int pcmcia_dev_freeze(struct device *dev)
+{
+	return __pcmcia_dev_suspend(dev, PMSG_FREEZE);
+}
+
+static int __pcmcia_dev_suspend(struct device *dev, pm_message_t state)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 	struct pcmcia_driver *p_drv = NULL;
@@ -1397,6 +1415,15 @@ static struct class_interface pcmcia_bus_interface __refdata = {
 	.remove_dev = &pcmcia_bus_remove_socket,
 };
 
+static const struct dev_pm_ops pcmcia_bus_dev_pm_ops = {
+	.suspend = pcmcia_dev_suspend,
+	.resume = pcmcia_dev_resume,
+	/* Hibernate callbacks */
+	.freeze = pcmcia_dev_freeze,
+	.thaw = pcmcia_dev_resume,
+	.poweroff = pcmcia_dev_poweroff,
+	.restore = pcmcia_dev_resume,
+};
 
 struct bus_type pcmcia_bus_type = {
 	.name = "pcmcia",
@@ -1405,8 +1432,7 @@ struct bus_type pcmcia_bus_type = {
 	.dev_groups = pcmcia_dev_groups,
 	.probe = pcmcia_device_probe,
 	.remove = pcmcia_device_remove,
-	.suspend = pcmcia_dev_suspend,
-	.resume = pcmcia_dev_resume,
+	.pm = &pcmcia_bus_dev_pm_ops,
 };
 
 
-- 
1.7.10.4

