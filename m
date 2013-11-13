Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab3KMLel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:34:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:45722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab3KMLei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:34:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434513437"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jerome Blin <jerome.blin@intel.com>
Subject: [PATCH] HID: i2c-hid: disable interrupt on suspend
Date: Wed, 13 Nov 2013 13:34:18 +0200
Message-Id: <1384342458-5551-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an I2C HID device is powered of during system sleep, as a result of
removing its power resources (by the ACPI core) the interrupt line might go
low as well. This results inadvertent interrupt and wakes the system from
sleep immediately.

To prevent this we disable the device interrupt in the drivers suspend
method and enable it on resume. The device can still wake the system up if
it is wake capable (this also means that not all of its power will be
removed to keep the interrupt line high).

Reported-by: Jerome Blin <jerome.blin@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index c1336193b04b..dc8b575477b4 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -1073,6 +1073,7 @@ static int i2c_hid_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 
+	disable_irq(client->irq);
 	if (device_may_wakeup(&client->dev))
 		enable_irq_wake(client->irq);
 
@@ -1087,6 +1088,7 @@ static int i2c_hid_resume(struct device *dev)
 	int ret;
 	struct i2c_client *client = to_i2c_client(dev);
 
+	enable_irq(client->irq);
 	ret = i2c_hid_hwreset(client);
 	if (ret)
 		return ret;
-- 
1.8.4.3

