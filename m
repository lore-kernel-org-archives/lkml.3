Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3DXElE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 00:41:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47094 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3DXElC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 00:41:02 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: johannes@sipsolutions.net
Cc: martin.pitt@ubuntu.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mac80211_hwsim: correctly register the platform driver
Date: Wed, 24 Apr 2013 00:40:05 -0400
Message-Id: <1366778405-7584-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not registering a platform_driver would make us access garbage
when the platform callbacks under driver_register() kicks in.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b878a32..cb34c78 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1723,11 +1723,11 @@ static void mac80211_hwsim_free(void)
 	class_destroy(hwsim_class);
 }
 
-
-static struct device_driver mac80211_hwsim_driver = {
-	.name = "mac80211_hwsim",
-	.bus = &platform_bus_type,
-	.owner = THIS_MODULE,
+static struct platform_driver mac80211_hwsim_driver = {
+	.driver = {
+		.name = "mac80211_hwsim",
+		.owner = THIS_MODULE,
+	},
 };
 
 static const struct net_device_ops hwsim_netdev_ops = {
@@ -2219,7 +2219,7 @@ static int __init init_mac80211_hwsim(void)
 	spin_lock_init(&hwsim_radio_lock);
 	INIT_LIST_HEAD(&hwsim_radios);
 
-	err = driver_register(&mac80211_hwsim_driver);
+	err = platform_driver_register(&mac80211_hwsim_driver);
 	if (err)
 		return err;
 
@@ -2254,7 +2254,7 @@ static int __init init_mac80211_hwsim(void)
 			err = -ENOMEM;
 			goto failed_drvdata;
 		}
-		data->dev->driver = &mac80211_hwsim_driver;
+		data->dev->driver = &mac80211_hwsim_driver.driver;
 		err = device_bind_driver(data->dev);
 		if (err != 0) {
 			printk(KERN_DEBUG
@@ -2564,7 +2564,7 @@ failed_drvdata:
 failed:
 	mac80211_hwsim_free();
 failed_unregister_driver:
-	driver_unregister(&mac80211_hwsim_driver);
+	platform_driver_unregister(&mac80211_hwsim_driver);
 	return err;
 }
 module_init(init_mac80211_hwsim);
@@ -2577,6 +2577,6 @@ static void __exit exit_mac80211_hwsim(void)
 
 	mac80211_hwsim_free();
 	unregister_netdev(hwsim_mon);
-	driver_unregister(&mac80211_hwsim_driver);
+	platform_driver_unregister(&mac80211_hwsim_driver);
 }
 module_exit(exit_mac80211_hwsim);
-- 
1.8.2.1

