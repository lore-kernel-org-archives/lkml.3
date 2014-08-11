Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaHKSEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:04:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50086 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaHKSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:04:33 -0400
Message-ID: <1407780269.28221.63.camel@chimera>
Subject: [PATCH] allow setting wiphy.perm_addr after driver probe
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Aug 2014 11:04:29 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On embedded devices, often the BSSID of an access point must be set from
userspace during the boot process. This provides a relatively clean way
of doing that without major side effects.

Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
--- 
--- a/net/wireless/sysfs.c	2014-04-19 08:36:52.048511623 -0700
+++ b/net/wireless/sysfs.c	2014-04-19 08:38:09.196894176 -0700
@@ -24,18 +24,30 @@
 	return container_of(dev, struct cfg80211_registered_device, wiphy.dev);
 }
 
-#define SHOW_FMT(name, fmt, member)					\
+#define SHOW_FMT(name, fmt, member, perm)				\
 static ssize_t name ## _show(struct device *dev,			\
 			      struct device_attribute *attr,		\
 			      char *buf)				\
 {									\
 	return sprintf(buf, fmt "\n", dev_to_rdev(dev)->member);	\
 }									\
-static DEVICE_ATTR_RO(name)
+static DEVICE_ATTR_ ## perm(name)
 
-SHOW_FMT(index, "%d", wiphy_idx);
-SHOW_FMT(macaddress, "%pM", wiphy.perm_addr);
-SHOW_FMT(address_mask, "%pM", wiphy.addr_mask);
+static ssize_t macaddress_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	u8 temp[ETH_ALEN];
+
+	if (sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", temp, temp + 1,
+			temp + 2, temp + 3, temp + 4, temp + 5) == ETH_ALEN)
+		memcpy(dev_to_rdev(dev)->wiphy.perm_addr, temp, ETH_ALEN);
+	return count;
+}
+
+SHOW_FMT(index, "%d", wiphy_idx, RO);
+SHOW_FMT(macaddress, "%pM", wiphy.perm_addr, RW);
+SHOW_FMT(address_mask, "%pM", wiphy.addr_mask, RO);
 
 static ssize_t name_show(struct device *dev,
 			 struct device_attribute *attr,


