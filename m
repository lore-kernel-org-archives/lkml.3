Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966871Ab3DQWGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:06:54 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:36765 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965558Ab3DQWGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:06:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Paul Stewart <pstew@chromium.org>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] net-sysfs: Add entry for nl80211 interface type
Date: Wed, 17 Apr 2013 15:06:09 -0700
Message-ID: <1366236369-543-1-git-send-email-bzhao@marvell.com>
X-Mailer: git-send-email 1.7.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "wireless/nl80211_iftype" entry in the net device sysfs
file structure to indicate the mode of the wireless device so
it can be discovered easily from userspace.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 net/core/net-sysfs.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 7427ab5..454bd7f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -17,6 +17,7 @@
 #include <linux/nsproxy.h>
 #include <net/sock.h>
 #include <net/net_namespace.h>
+#include <net/cfg80211.h>
 #include <linux/rtnetlink.h>
 #include <linux/vmalloc.h>
 #include <linux/export.h>
@@ -448,7 +449,24 @@ static struct attribute_group netstat_group = {
 };
 
 #if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
+static ssize_t show_nl80211_iftype(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	const struct net_device *netdev = to_net_dev(dev);
+	ssize_t ret = 0;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+	if (netdev->ieee80211_ptr)
+		ret = sprintf(buf, "%d\n", netdev->ieee80211_ptr->iftype);
+	rtnl_unlock();
+
+	return ret;
+}
+static DEVICE_ATTR(nl80211_iftype, S_IRUGO, show_nl80211_iftype, NULL);
+
 static struct attribute *wireless_attrs[] = {
+	&dev_attr_nl80211_iftype.attr,
 	NULL
 };
 
-- 
1.7.0.2

