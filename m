Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaCAAUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:20:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaCAAUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:20:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] HID: cp2112: remove various hid_out_raw_report calls
Date: Fri, 28 Feb 2014 19:20:34 -0500
Message-Id: <1393633237-26496-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_out_raw_report is going to be obsoleted as it is not part of the
unified HID low level transport documentation
(Documentation/hid/hid-transport.txt)

  hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
is strictly equivalent to:
  hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
		HID_FEATURE_REPORT, HID_REQ_SET_REPORT);

So use the new api.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-cp2112.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 1025982..860db694 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -185,8 +185,8 @@ static int cp2112_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	buf[1] &= ~(1 << offset);
 	buf[2] = gpio_push_pull;
 
-	ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
-					  HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	if (ret < 0) {
 		hid_err(hdev, "error setting GPIO config: %d\n", ret);
 		return ret;
@@ -207,8 +207,8 @@ static void cp2112_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	buf[1] = value ? 0xff : 0;
 	buf[2] = 1 << offset;
 
-	ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
-					  HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	if (ret < 0)
 		hid_err(hdev, "error setting GPIO values: %d\n", ret);
 }
@@ -253,8 +253,8 @@ static int cp2112_gpio_direction_output(struct gpio_chip *chip,
 	buf[1] |= 1 << offset;
 	buf[2] = gpio_push_pull;
 
-	ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf),
-					  HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	if (ret < 0) {
 		hid_err(hdev, "error setting GPIO config: %d\n", ret);
 		return ret;
-- 
1.8.5.3

