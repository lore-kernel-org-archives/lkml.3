Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaGKVxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:53:25 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:64491 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaGKVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:53:18 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2014 17:53:16 EDT
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 11 Jul 2014 14:51:35 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?Benjamin=20Tissoires=20=C2=A0?= 
	<benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: change logging level of log messages related to unexpected reports
Date: Fri, 11 Jul 2014 14:35:51 -0700
Message-ID: <1405114551-24354-2-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405114551-24354-1-git-send-email-aduggan@synaptics.com>
References: <1405114551-24354-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace tools may use hidraw to perform operations on the device from userspace while
hid-rmi is bound to the device. This can cause hid-rmi to print error messages when its
->raw_event() callback gets called as the reports pass through the HID stack. In this case
receiving responses which were not initiated by hid-rmi is not actually an error so the resulting
error messages are incorrect and misleading. This patch changes the log messages to debug so
that the messages can be turned on in the event that there is a problem and there is not
a userspace tool running.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 578bbe6..25f571a 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -377,7 +377,7 @@ static int rmi_input_event(struct hid_device *hdev, u8 *data, int size)
 	irq_mask |= hdata->f30.irq_mask;
 
 	if (data[1] & ~irq_mask)
-		hid_warn(hdev, "unknown intr source:%02lx %s:%d\n",
+		hid_dbg(hdev, "unknown intr source:%02lx %s:%d\n",
 			data[1] & ~irq_mask, __FILE__, __LINE__);
 
 	if (hdata->f11.interrupt_base < hdata->f30.interrupt_base) {
@@ -400,7 +400,7 @@ static int rmi_read_data_event(struct hid_device *hdev, u8 *data, int size)
 	struct rmi_data *hdata = hid_get_drvdata(hdev);
 
 	if (!test_bit(RMI_READ_REQUEST_PENDING, &hdata->flags)) {
-		hid_err(hdev, "no read request pending\n");
+		hid_dbg(hdev, "no read request pending\n");
 		return 0;
 	}
 
-- 
1.9.1

