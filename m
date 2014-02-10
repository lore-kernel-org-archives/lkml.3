Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBJQPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:15:50 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:48794
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbaBJQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:15:46 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, ingo.tuchscherer@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFT][PATCH 12/12] drivers/s390/crypto: change ap_bus driver power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:15:43 -0700
Message-Id: <8c806d9343e9b28ee505908d6171e99032a5bf52.1392040068.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ap_bus driver to register pm ops using dev_pm_ops instead of legacy
pm_ops. .pm hooks call existing legacy suspend and resume interfaces by
passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/s390/crypto/ap_bus.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index ab3baa7..c39c917 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -799,7 +799,7 @@ static int ap_uevent (struct device *dev, struct kobj_uevent_env *env)
 	return retval;
 }
 
-static int ap_bus_suspend(struct device *dev, pm_message_t state)
+static int __ap_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
 	unsigned long flags;
@@ -833,6 +833,21 @@ static int ap_bus_suspend(struct device *dev, pm_message_t state)
 	return 0;
 }
 
+static int ap_bus_suspend(struct device *dev)
+{
+	return __ap_bus_suspend(dev, PMSG_SUSPEND);
+}
+
+static int ap_bus_freeze(struct device *dev)
+{
+	return __ap_bus_suspend(dev, PMSG_FREEZE);
+}
+
+static int ap_bus_poweroff(struct device *dev)
+{
+	return __ap_bus_suspend(dev, PMSG_HIBERNATE);
+}
+
 static int ap_bus_resume(struct device *dev)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
@@ -886,12 +901,21 @@ static int ap_bus_resume(struct device *dev)
 	return rc;
 }
 
+static const struct dev_pm_ops ap_bus_dev_pm_ops = {
+	.suspend = ap_bus_suspend,
+	.resume = ap_bus_resume,
+	/* Hibernate callbacks */
+	.freeze = ap_bus_freeze,
+	.thaw = ap_bus_resume,
+	.poweroff = ap_bus_poweroff,
+	.restore = ap_bus_resume,
+};
+
 static struct bus_type ap_bus_type = {
 	.name = "ap",
 	.match = &ap_bus_match,
 	.uevent = &ap_uevent,
-	.suspend = ap_bus_suspend,
-	.resume = ap_bus_resume
+	.pm = &ap_bus_dev_pm_ops,
 };
 
 static int ap_device_probe(struct device *dev)
-- 
1.7.10.4

