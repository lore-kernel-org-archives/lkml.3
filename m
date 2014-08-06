Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaHFUpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:45:52 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:2095 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866AbaHFUpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:45:50 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 06 Aug 2014 13:56:27 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: print an error if F11 is not found instead of stopping the device
Date: Wed, 6 Aug 2014 13:37:40 -0700
Message-ID: <1407357460-9569-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently rmi_probe will return -EIO if the device doesn't report that it has F11.
This would indicate that something happened and the device is in the bootloader.
We can recover the device using a userspace firmware update tool, but it needs
access to the device through the hidraw device file. If the probe returns -EIO
the hidraw device won't be created. So instead of failing the probe, just print
an error message, but leave the device accessible from userspace.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 0dc2514..8389e81 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -909,10 +909,15 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return ret;
 	}
 
-	if (!test_bit(RMI_STARTED, &data->flags)) {
-		hid_hw_stop(hdev);
-		return -EIO;
-	}
+	if (!test_bit(RMI_STARTED, &data->flags))
+		/*
+		 * The device maybe in the bootloader if rmi_input_configured
+		 * failed to find F11 in the PDT. Print an error, but don't
+		 * return an error from rmi_probe so that hidraw will be
+		 * accessible from userspace. That way a userspace tool
+		 * can be used to reload working firmware on the touchpad.
+		 */
+		hid_err(hdev, "Device failed to be properly configured\n");
 
 	return 0;
 }
-- 
1.9.1

