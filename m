Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab3HNXKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:10:13 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:53572 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933229Ab3HNXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:10:12 -0400
From: Philippe De Swert <philippe.deswert@jollamobile.com>
To: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Cc: Philippe De Swert <philippe.deswert@jollamobile.com>
Subject: [PATCH] power:power_supply_syfs : Treat PROP_TYPE as a regular attribute first
Date: Thu, 15 Aug 2013 02:09:58 +0300
Message-Id: <1376521798-16985-1-git-send-email-philippe.deswert@jollamobile.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days we often have USB powered devices. This means that often the
type is variable. Common examples are smartphones which can be charged
through a normal USB port on a PC/laptop, a dedicated charger, etc...
Often those chips also have support for other charger types like a
mains/DC charger. This means that often there are several psy structures
in the driver and makes it impossible to stick to just one type.

Userspace sometimes needs to behave differently based on the type of charger
connected to such devices. This goes from loading gadget drivers to get
enumerated on a PC/laptop to draw more power, to enabling special charging
functions for a dedicated charger. Or to just enable userspace to discriminate
between the two for charging indications/USB cable detection.

Moreover TYPE seems to be the right attribute to use as it has definitions
already for all the different USB charger types.This patch allows for using the 
regular get_property function with the TYPE property without breaking current 
functionality/way of working.

Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
---
 drivers/power/power_supply_sysfs.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 29178f7..a839c91 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -73,19 +73,20 @@ static ssize_t power_supply_show_property(struct device *dev,
 	const ptrdiff_t off = attr - power_supply_attrs;
 	union power_supply_propval value;
 
-	if (off == POWER_SUPPLY_PROP_TYPE)
-		value.intval = psy->type;
-	else
-		ret = psy->get_property(psy, off, &value);
+	ret = psy->get_property(psy, off, &value);
 
 	if (ret < 0) {
-		if (ret == -ENODATA)
-			dev_dbg(dev, "driver has no data for `%s' property\n",
-				attr->attr.name);
-		else if (ret != -ENODEV)
-			dev_err(dev, "driver failed to report `%s' property: %zd\n",
-				attr->attr.name, ret);
-		return ret;
+		if (off == POWER_SUPPLY_PROP_TYPE)
+			value.intval = psy->type;
+		else {
+			if (ret == -ENODATA)
+				dev_dbg(dev, "driver has no data for `%s' property\n",
+					attr->attr.name);
+			else if (ret != -ENODEV)
+				dev_err(dev, "driver failed to report `%s' property: %zd\n",
+					attr->attr.name, ret);
+			return ret;
+		}
 	}
 
 	if (off == POWER_SUPPLY_PROP_STATUS)
-- 
1.8.1.2

