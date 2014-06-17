Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966085AbaFQVsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965454AbaFQVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 110/212] hwmon: (emc1403) Fix resource leak on module unload
Date: Tue, 17 Jun 2014 14:43:24 -0700
Message-Id: <1403041506-13646-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/emc1403.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 61d89d6..42a3cfc 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -355,9 +355,9 @@ static int emc1403_probe(struct i2c_client *client,
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
 
-- 
1.9.1

