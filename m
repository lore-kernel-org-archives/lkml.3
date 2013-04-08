Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877Ab3DHJNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:13:54 -0400
Received: from www.piware.de ([213.9.93.70]:37948 "EHLO www.piware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934527Ab3DHJNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:13:49 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 05:13:48 EDT
Date: Mon, 8 Apr 2013 11:06:33 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>
Subject: [PATCH] mac80211_hwsim: Register and bind to driver
Message-ID: <20130408090633.GB2818@piware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly register our mac80211_hwsim_driver, attach it to the platform bus.
Bind newly created hwsim devices to that driver, so that our wlan devices get
a proper "driver" sysfs attribute.

This makes mac80211_hwsim interfaces work with NetworkManager.

Signed-off-by: Martin Pitt <martin.pitt@ubuntu.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0064d38..50a8b52 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -25,6 +25,7 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
+#include <linux/platform_device.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
 #include <linux/ktime.h>
@@ -1675,6 +1676,7 @@ static void mac80211_hwsim_free(void)
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
+		device_release_driver(data->dev);
 		device_unregister(data->dev);
 		ieee80211_free_hw(data->hw);
 	}
@@ -1683,7 +1685,9 @@ static void mac80211_hwsim_free(void)
 
 
 static struct device_driver mac80211_hwsim_driver = {
-	.name = "mac80211_hwsim"
+	.name = "mac80211_hwsim",
+	.bus = &platform_bus_type,
+	.owner = THIS_MODULE,
 };
 
 static const struct net_device_ops hwsim_netdev_ops = {
@@ -2179,6 +2183,8 @@ static int __init init_mac80211_hwsim(void)
 	if (IS_ERR(hwsim_class))
 		return PTR_ERR(hwsim_class);
 
+	driver_register(&mac80211_hwsim_driver);
+
 	memset(addr, 0, ETH_ALEN);
 	addr[0] = 0x02;
 
@@ -2205,6 +2211,14 @@ static int __init init_mac80211_hwsim(void)
 			goto failed_drvdata;
 		}
 		data->dev->driver = &mac80211_hwsim_driver;
+		err = device_bind_driver(data->dev);
+		if (err != 0) {
+			printk(KERN_DEBUG
+			       "mac80211_hwsim: device_bind_driver "
+			       "failed (%d)\n", err);
+			goto failed_hw;
+		}
+
 		skb_queue_head_init(&data->pending);
 
 		SET_IEEE80211_DEV(hw, data->dev);
@@ -2518,5 +2532,6 @@ static void __exit exit_mac80211_hwsim(void)
 
 	mac80211_hwsim_free();
 	unregister_netdev(hwsim_mon);
+	driver_unregister(&mac80211_hwsim_driver);
 }
 module_exit(exit_mac80211_hwsim);
-- 
1.7.2.5

-- 
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
