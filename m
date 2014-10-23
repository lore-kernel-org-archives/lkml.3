Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaJWEJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:09:53 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49474 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaJWEDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:03:51 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 06/14] net: dsa: Add support for hardware monitoring
Date: Wed, 22 Oct 2014 21:03:14 -0700
Message-Id: <1414037002-25528-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54487E27.0055,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 48
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Marvell switches provide chip temperature data.
Add support for reporting it to the dsa infrastructure.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/net/dsa.h |   6 +++
 net/dsa/dsa.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b765592..d8b3057 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -242,6 +242,12 @@ struct dsa_switch_driver {
 			   struct ethtool_eee *e);
 	int	(*get_eee)(struct dsa_switch *ds, int port,
 			   struct ethtool_eee *e);
+
+	/* Hardware monitoring */
+	int	(*get_temp)(struct dsa_switch *ds, int *temp);
+	int	(*get_temp_limit)(struct dsa_switch *ds, int *temp);
+	int	(*set_temp_limit)(struct dsa_switch *ds, int temp);
+	int	(*get_temp_alarm)(struct dsa_switch *ds, bool *alarm);
 };
 
 void register_switch_driver(struct dsa_switch_driver *type);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 22f34cf..6567c8e 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -9,6 +9,8 @@
  * (at your option) any later version.
  */
 
+#include <linux/device.h>
+#include <linux/hwmon.h>
 #include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -17,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
+#include <linux/sysfs.h>
 #include "dsa_priv.h"
 
 char dsa_driver_version[] = "0.1";
@@ -71,6 +74,104 @@ dsa_switch_probe(struct device *host_dev, int sw_addr, char **_name)
 	return ret;
 }
 
+/* hwmon support ************************************************************/
+
+#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
+
+static ssize_t temp1_input_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct dsa_switch *ds = dev_get_drvdata(dev);
+	int temp, ret;
+
+	ret = ds->drv->get_temp(ds, &temp);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", temp * 1000);
+}
+static DEVICE_ATTR_RO(temp1_input);
+
+static ssize_t temp1_max_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct dsa_switch *ds = dev_get_drvdata(dev);
+	int temp, ret;
+
+	ret = ds->drv->get_temp_limit(ds, &temp);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", temp * 1000);
+}
+
+static ssize_t temp1_max_store(struct device *dev,
+			       struct device_attribute *attr, const char *buf,
+			       size_t count)
+{
+	struct dsa_switch *ds = dev_get_drvdata(dev);
+	int temp, ret;
+
+	ret = kstrtoint(buf, 0, &temp);
+	if (ret < 0)
+		return ret;
+
+	ret = ds->drv->set_temp_limit(ds, DIV_ROUND_CLOSEST(temp, 1000));
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR(temp1_max, S_IRUGO, temp1_max_show, temp1_max_store);
+
+static ssize_t temp1_max_alarm_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct dsa_switch *ds = dev_get_drvdata(dev);
+	bool alarm;
+	int ret;
+
+	ret = ds->drv->get_temp_alarm(ds, &alarm);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", alarm);
+}
+static DEVICE_ATTR_RO(temp1_max_alarm);
+
+static struct attribute *dsa_hwmon_attrs[] = {
+	&dev_attr_temp1_input.attr,	/* 0 */
+	&dev_attr_temp1_max.attr,	/* 1 */
+	&dev_attr_temp1_max_alarm.attr,	/* 2 */
+	NULL
+};
+
+static umode_t dsa_hwmon_attrs_visible(struct kobject *kobj,
+				       struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct dsa_switch *ds = dev_get_drvdata(dev);
+	struct dsa_switch_driver *drv = ds->drv;
+	umode_t mode = attr->mode;
+
+	if (index == 1) {
+		if (!drv->get_temp_limit)
+			mode = 0;
+		else if (drv->set_temp_limit)
+			mode |= S_IWUSR;
+	} else if (index == 2 && !drv->get_temp_alarm) {
+		mode = 0;
+	}
+	return mode;
+}
+
+static const struct attribute_group dsa_hwmon_group = {
+	.attrs = dsa_hwmon_attrs,
+	.is_visible = dsa_hwmon_attrs_visible,
+};
+__ATTRIBUTE_GROUPS(dsa_hwmon);
+
+#endif /* CONFIG_HWMON */
 
 /* basic switch operations **************************************************/
 static struct dsa_switch *
@@ -225,6 +326,16 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int index,
 		ds->ports[i] = slave_dev;
 	}
 
+#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
+	/* If the switch provides a temperature sensor,
+	 * register with hardware monitoring subsystem.
+	 * Treat registration error as non-fatal and ignore it.
+	 */
+	if (drv->get_temp)
+		devm_hwmon_device_register_with_groups(parent, "dsa", ds,
+						       dsa_hwmon_groups);
+#endif
+
 	return ds;
 
 out_free:
-- 
1.9.1

