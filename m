Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaKCUdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:33:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaKCUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:33:41 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: core: cleanup .claimed field on disconnect
Date: Mon,  3 Nov 2014 15:33:32 -0500
Message-Id: <1415046812-3263-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a subdriver is rmmod-ed then re-insmod-ed, the hid device is not
destroyed as it is owned by the transport layer.
So when we re-probed the device, the hid device is assumed to be already
claimed, and can lead to page faults if hid-core tries to forward the
emitted data to the to-be-created claimed node.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

[keeping the people involved in the logitech-hidpp driver in CC]

this one was particularly nasty. I had several page faults when just
rmmod && insmod the hid-logitech-hidpp driver. The page fault was occuring
in hidraw :/
I was not able to get a stacktrace which I could include here. The laptop was
completely unresponsive and I could take only a picture to debug it.

Cheers,
Benjamin

 drivers/hid/hid-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1e2d512..bbb138d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1656,6 +1656,7 @@ void hid_disconnect(struct hid_device *hdev)
 		hdev->hiddev_disconnect(hdev);
 	if (hdev->claimed & HID_CLAIMED_HIDRAW)
 		hidraw_disconnect(hdev);
+	hdev->claimed = 0;
 }
 EXPORT_SYMBOL_GPL(hid_disconnect);
 
-- 
2.1.0

