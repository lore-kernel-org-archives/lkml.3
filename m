Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaLPPz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:55:58 -0500
Received: from lekensteyn.nl ([178.21.112.251]:57013 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaLPPzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:55:40 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] HID: logitech-dj: check report length
Date: Tue, 16 Dec 2014 16:55:21 +0100
Message-Id: <1418745323-17133-1-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <CAN+gG=EL0kYim=_uaS4yj7c_XC8rKa1eELxpVXaOuvnWgT_eQw@mail.gmail.com>
References: <CAN+gG=EL0kYim=_uaS4yj7c_XC8rKa1eELxpVXaOuvnWgT_eQw@mail.gmail.com>
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malicious USB devices can send bogus reports smaller than the expected
buffer size. Ensure that the length is valid to avoid reading out of
bounds.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 v1: patch 2/3 HID: logitech-{dj,hidpp}: check report length
 v2: splitted original report length check patch
---
 drivers/hid/hid-logitech-dj.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index c917ab6..5bc6d80 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -962,10 +962,24 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 
 	switch (data[0]) {
 	case REPORT_ID_DJ_SHORT:
+		if (size != DJREPORT_SHORT_LENGTH) {
+			dev_err(&hdev->dev, "DJ report of bad size (%d)", size);
+			return false;
+		}
 		return logi_dj_dj_event(hdev, report, data, size);
 	case REPORT_ID_HIDPP_SHORT:
-		/* intentional fallthrough */
+		if (size != HIDPP_REPORT_SHORT_LENGTH) {
+			dev_err(&hdev->dev,
+				"Short HID++ report of bad size (%d)", size);
+			return false;
+		}
+		return logi_dj_hidpp_event(hdev, report, data, size);
 	case REPORT_ID_HIDPP_LONG:
+		if (size != HIDPP_REPORT_LONG_LENGTH) {
+			dev_err(&hdev->dev,
+				"Long HID++ report of bad size (%d)", size);
+			return false;
+		}
 		return logi_dj_hidpp_event(hdev, report, data, size);
 	}
 
-- 
2.1.3

