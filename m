Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaCAAUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:20:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaCAAUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:20:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] HID: cp2112: remove the last hid_output_raw_report() call
Date: Fri, 28 Feb 2014 19:20:35 -0500
Message-Id: <1393633237-26496-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have access to the device, so I copied/pasted the code
from hidraw.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-cp2112.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 860db694..c4f87bd 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -290,7 +290,21 @@ static int cp2112_hid_output(struct hid_device *hdev, u8 *data, size_t count,
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hdev->hid_output_raw_report(hdev, buf, count, report_type);
+	/* Fixme: test which function is actually called for output reports */
+	if (report_type == HID_OUTPUT_REPORT) {
+		ret = hid_hw_output_report(hdev, buf, count);
+		/*
+		 * compatibility with old implementation of USB-HID:
+		 * if the device does not support receiving output reports,
+		 * on an interrupt endpoint, fallback to SET_REPORT HID command.
+		 */
+		if (ret != -ENOSYS)
+			goto out_free;
+	}
+
+	ret = hid_hw_raw_request(hdev, buf[0], buf, count, report_type,
+				HID_REQ_SET_REPORT);
+out_free:
 	kfree(buf);
 	return ret;
 }
-- 
1.8.5.3

