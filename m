Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaAPEeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:34:04 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45802 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaAPEeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:34:00 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 13/15] w1: use family_data instead of rom in w1_slave
Date: Wed, 15 Jan 2014 22:29:24 -0600
Message-Id: <1389846566-28862-14-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:33:54 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first line printed from w1_slave gives the context of the w1
device.  So does the second line, but if the CRC check failed, the
second line contains the last successful result.  It is confusing when
it prints the temperature next to the line that might be a previous
conversion and has nothing to do with that printed temperature value.
Modify the code to store the last good conversion in family_data,
which is designed for custom data structures.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/slaves/w1_therm.c |   21 +++++++++++++++++++--
 drivers/w1/w1.h              |    1 -
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 8b5ff33..1f11a20 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 
 #include "../w1.h"
@@ -58,6 +59,19 @@ MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS28EA00));
 static int w1_strong_pullup = 1;
 module_param_named(strong_pullup, w1_strong_pullup, int, 0);
 
+static int w1_therm_add_slave(struct w1_slave *sl)
+{
+	sl->family_data = kzalloc(9, GFP_KERNEL);
+	if (!sl->family_data)
+		return -ENOMEM;
+	return 0;
+}
+
+static void w1_therm_remove_slave(struct w1_slave *sl)
+{
+	kfree(sl->family_data);
+	sl->family_data = NULL;
+}
 
 static ssize_t w1_slave_show(struct device *device,
 	struct device_attribute *attr, char *buf);
@@ -71,6 +85,8 @@ static struct attribute *w1_therm_attrs[] = {
 ATTRIBUTE_GROUPS(w1_therm);
 
 static struct w1_family_ops w1_therm_fops = {
+	.add_slave	= w1_therm_add_slave,
+	.remove_slave	= w1_therm_remove_slave,
 	.groups		= w1_therm_groups,
 };
 
@@ -253,12 +269,13 @@ static ssize_t w1_slave_show(struct device *device,
 	c -= snprintf(buf + PAGE_SIZE - c, c, ": crc=%02x %s\n",
 			   crc, (verdict) ? "YES" : "NO");
 	if (verdict)
-		memcpy(sl->rom, rom, sizeof(sl->rom));
+		memcpy(sl->family_data, rom, sizeof(rom));
 	else
 		dev_warn(device, "Read failed CRC check\n");
 
 	for (i = 0; i < 9; ++i)
-		c -= snprintf(buf + PAGE_SIZE - c, c, "%02x ", sl->rom[i]);
+		c -= snprintf(buf + PAGE_SIZE - c, c, "%02x ",
+			      ((u8 *)sl->family_data)[i]);
 
 	c -= snprintf(buf + PAGE_SIZE - c, c, "t=%d\n",
 		w1_convert_temp(rom, sl->family->fid));
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 390a730..0eb5050 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -67,7 +67,6 @@ struct w1_slave
 	struct list_head	w1_slave_entry;
 	struct w1_reg_num	reg_num;
 	atomic_t		refcnt;
-	u8			rom[9];
 	int			ttl;
 	unsigned long		flags;
 
-- 
1.7.10.4

