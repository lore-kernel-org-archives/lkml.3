Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaGKXl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:41:58 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:15096 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaGKXl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:41:57 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 11 Jul 2014 16:49:44 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>
Subject: [PATCH] HID: i2c-hid: call the hid driver's suspend and resume callbacks
Date: Fri, 11 Jul 2014 16:34:18 -0700
Message-ID: <1405121658-3853-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the i2c-hid driver does not call the suspend, resume, and
reset_resume callbacks in the hid_driver struct when those events occur.
This means that HID drivers for i2c-hid devices will not be able to execute
commands which may be needed during suspend or resume. One example is when a
touchpad using the hid-multitouch driver gets reset by i2c-hid coming out of
resume. Since the reset_resume callback never gets called the device is never
put back into the correct input mode. This patch calls the suspend and resume
callbacks and tries to duplicate the functionality of the usb-hid driver.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
Signed-off-by: Vincent Huang <vincent.huang@tw.synaptics.com>
---
Hi Benjamin,

This is the patch which Vincent and I came up with to fix the behavior which we were seeing with touchpads not being operational after resuming. We only use the reset_resume callback since i2c_hid_resume is always doing a hardware reset and it doesn't seem like there is a condition in which the standard resume callback would be appropriate. Also, is a full hardware reset always needed when resuming?

 drivers/hid/i2c-hid/i2c-hid.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 21aafc8..747d544 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -1054,21 +1054,29 @@ static int i2c_hid_remove(struct i2c_client *client)
 static int i2c_hid_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_hid *ihid = i2c_get_clientdata(client);
+	struct hid_device *hid = ihid->hid;
+	int ret = 0;
 
 	disable_irq(client->irq);
 	if (device_may_wakeup(&client->dev))
 		enable_irq_wake(client->irq);
 
+	if (hid->driver && hid->driver->suspend)
+		ret = hid->driver->suspend(hid, PMSG_SUSPEND);
+
 	/* Save some power */
 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
 
-	return 0;
+	return ret;
 }
 
 static int i2c_hid_resume(struct device *dev)
 {
 	int ret;
 	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_hid *ihid = i2c_get_clientdata(client);
+	struct hid_device *hid = ihid->hid;
 
 	enable_irq(client->irq);
 	ret = i2c_hid_hwreset(client);
@@ -1078,6 +1086,11 @@ static int i2c_hid_resume(struct device *dev)
 	if (device_may_wakeup(&client->dev))
 		disable_irq_wake(client->irq);
 
+	if (hid->driver && hid->driver->reset_resume) {
+		ret = hid->driver->reset_resume(hid);
+		return ret;
+	}
+
 	return 0;
 }
 #endif
-- 
1.9.1

