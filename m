Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaBBEX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:23:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaBBEXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:23:15 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: fix buffer allocations
Date: Sat,  1 Feb 2014 23:23:10 -0500
Message-Id: <1391314990-29046-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using hid_output_report(), the buffer should be allocated by hid_alloc_report_buf(),
not a custom malloc.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-input.c       | 2 +-
 drivers/hid/i2c-hid/i2c-hid.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d50e731..a713e62 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1178,7 +1178,7 @@ static void hidinput_led_worker(struct work_struct *work)
 
 	/* fall back to generic raw-output-report */
 	len = ((report->size - 1) >> 3) + 1 + (report->id > 0);
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = hid_alloc_report_buf(report, GFP_KERNEL);
 	if (!buf)
 		return;
 
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index e914f27..ce68a12 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -582,7 +582,7 @@ static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
 	int ret;
 	int len = i2c_hid_get_report_length(rep) - 2;
 
-	buf = kzalloc(len, GFP_KERNEL);
+	buf = hid_alloc_report_buf(rep, GFP_KERNEL);
 	if (!buf)
 		return;
 
-- 
1.8.3.1

