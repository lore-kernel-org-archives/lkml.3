Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKKNZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:25:34 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48942 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaKKNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:25:32 -0500
Message-ID: <54620E5F.5090802@gmail.com>
Date: Tue, 11 Nov 2014 14:25:51 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RESEND][PATCH 4/5] Return the fan speed via sysfs
References: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the fan speed via sysfs:
/sys/devices/temperature/fan_level

This patch is extracted from a Bryan Christianson's bigger one (see
debian bug #741663)

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 68f1067..30a6588 100644
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
@@ -264,6 +270,7 @@ setup_hardware( void )
 
 	err = device_create_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
 	err |= device_create_file( &x.of_dev->dev, &dev_attr_case_temperature );
+	err |= device_create_file(&x.of_dev->dev, &dev_attr_fan_level);
 	if (err)
 		printk(KERN_WARNING
 			"Failed to create temperature attribute file(s).\n");
@@ -274,6 +281,7 @@ restore_regs( void )
 {
 	device_remove_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
 	device_remove_file( &x.of_dev->dev, &dev_attr_case_temperature );
+	device_remove_file(&x.of_dev->dev, &dev_attr_fan_level);
 
 	write_reg( x.fan, 0x01, x.r1, 1 );
 	write_reg( x.fan, 0x20, x.r20, 1 );
-- 
2.1.0.rc1


