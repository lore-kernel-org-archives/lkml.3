Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3JZUkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:40:46 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:62880 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3JZUkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:40:41 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, pali.rohar@gmail.com
Subject: [PATCH 16/16] wl1251: Add sysfs file address for setting permanent mac address
Date: Sat, 26 Oct 2013 22:34:15 +0200
Message-Id: <1382819655-30430-17-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver wl1251 generating mac address randomly at startup and there is no way to
set permanent mac address via SET_IEEE80211_PERM_ADDR. This patch export sysfs
file which can set permanent mac address by userspace helper program. Patch is
needed for devices which do not store mac address in internal wl1251 eeprom.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   52 +++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 29625c2..91a009c 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1375,6 +1375,46 @@ static const struct ieee80211_ops wl1251_ops = {
 	.get_survey = wl1251_op_get_survey,
 };
 
+static ssize_t wl1251_sysfs_show_address(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct wl1251 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	/* FIXME: what's the maximum length of buf? page size?*/
+	len = 500;
+
+	len = snprintf(buf, len, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
+		       wl->mac_addr[0], wl->mac_addr[1], wl->mac_addr[2],
+		       wl->mac_addr[3], wl->mac_addr[4], wl->mac_addr[5]);
+
+	return len;
+}
+
+static ssize_t wl1251_sysfs_store_address(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct wl1251 *wl = dev_get_drvdata(dev);
+	unsigned int addr[6];
+	int ret, i;
+
+	ret = sscanf(buf, "%2x:%2x:%2x:%2x:%2x:%2x\n",
+			&addr[0], &addr[1], &addr[2],
+			&addr[3], &addr[4], &addr[5]);
+
+	if (ret != 6)
+		return -EINVAL;
+
+	for (i = 0; i < 6; i++)
+		wl->mac_addr[i] = addr[i] & 0xff;
+
+	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+
+	return count;
+}
+
 static ssize_t wl1251_sysfs_show_tx_mgmt_frm_rate(struct device *dev,
 						  struct device_attribute *attr,
 						  char *buf)
@@ -1584,6 +1624,10 @@ out:
 	return count;
 }
 
+static DEVICE_ATTR(address, S_IRUGO | S_IWUSR,
+		   wl1251_sysfs_show_address,
+		   wl1251_sysfs_store_address);
+
 static DEVICE_ATTR(tx_mgmt_frm_rate, S_IRUGO | S_IWUSR,
 		   wl1251_sysfs_show_tx_mgmt_frm_rate,
 		   wl1251_sysfs_store_tx_mgmt_frm_rate);
@@ -1728,6 +1772,14 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	}
 	dev_set_drvdata(&wl1251_device.dev, wl);
 
+	/* Create sysfs file address */
+	ret = device_create_file(&wl1251_device.dev,
+				 &dev_attr_address);
+	if (ret < 0) {
+		wl1251_error("failed to create sysfs file address");
+		goto out;
+	}
+
 	/* Create sysfs file tx_mgmt_frm_rate */
 	ret = device_create_file(&wl1251_device.dev,
 				 &dev_attr_tx_mgmt_frm_rate);
-- 
1.7.10.4

