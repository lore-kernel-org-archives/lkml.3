Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaHFVFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:05:21 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36274 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHFVFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:05:17 -0400
From: Goffredo Baroncelli <kreijack@gmail.com>
X-Google-Original-From: Goffredo Baroncelli <kreijack@inwind.it>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/5] Return the fan speed via sysfs
Date: Wed,  6 Aug 2014 21:05:02 +0000
Message-Id: <1407359103-6012-5-git-send-email-kreijack@inwind.it>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the fan speed via sysfs:
/sys/devices/temperature/fan_level

This patch is copied from the Bryan Christianson's patch (see
debian bug #741663)

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 7c512db..b6cba98 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -109,9 +109,15 @@ show_case_temperature( struct device *dev, struct device_attribute *attr, char *
 	return sprintf(buf, "%d.%d\n", x.casetemp>>8, (x.casetemp & 255)*10/256 );
 }
 
+static ssize_t
+show_fan_level(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", 11 - x.fan_level);
+}
+
 static DEVICE_ATTR(cpu_temperature, S_IRUGO, show_cpu_temperature, NULL );
 static DEVICE_ATTR(case_temperature, S_IRUGO, show_case_temperature, NULL );
-
+static DEVICE_ATTR(fan_level, S_IRUGO, show_fan_level, NULL);
 
 
 /************************************************************************/
@@ -265,6 +271,7 @@ setup_hardware( void )
 
 	err = device_create_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
 	err |= device_create_file( &x.of_dev->dev, &dev_attr_case_temperature );
+	err |= device_create_file(&x.of_dev->dev, &dev_attr_fan_level);
 	if (err)
 		printk(KERN_WARNING
 			"Failed to create temperature attribute file(s).\n");
@@ -275,6 +282,7 @@ restore_regs( void )
 {
 	device_remove_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
 	device_remove_file( &x.of_dev->dev, &dev_attr_case_temperature );
+	device_remove_file(&x.of_dev->dev, &dev_attr_fan_level);
 
 	write_reg( x.fan, 0x01, x.r1, 1 );
 	write_reg( x.fan, 0x20, x.r20, 1 );
-- 
2.0.1

