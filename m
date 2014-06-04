Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaFEAow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:44:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaFDXVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.14 047/228] hwmon: (emc1403) Fix resource leak on module unload
Date: Wed,  4 Jun 2014 16:21:16 -0700
Message-Id: <20140604232349.594673060@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit 8759f9046550f463098148bf577ccd32cdb895e3 upstream.

Commit 454aee17f claims to convert driver emc1403 to use
devm_hwmon_device_register_with_groups, however the patch itself makes
use of hwmon_device_register_with_groups instead. As the driver remove
function was still dropped, the hwmon device is no longer unregistered
on driver removal, leading to a resource leak.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 454aee17f hwmon: (emc1403) Convert to use devm_hwmon_device_register_with_groups
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/emc1403.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -355,9 +355,9 @@ static int emc1403_probe(struct i2c_clie
 	if (id->driver_data)
 		data->groups[1] = &emc1404_group;
 
-	hwmon_dev = hwmon_device_register_with_groups(&client->dev,
-						      client->name, data,
-						      data->groups);
+	hwmon_dev = devm_hwmon_device_register_with_groups(&client->dev,
+							   client->name, data,
+							   data->groups);
 	if (IS_ERR(hwmon_dev))
 		return PTR_ERR(hwmon_dev);
 


