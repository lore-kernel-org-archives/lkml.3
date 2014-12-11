Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbaLKMw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:52:58 -0500
Received: from lekensteyn.nl ([178.21.112.251]:45678 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882AbaLKMve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:51:34 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] HID: logitech-hidpp: disable io in probe error path
Date: Thu, 11 Dec 2014 13:51:20 +0100
Message-Id: <1418302280-14794-5-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balance a hid_device_io_start() call with hid_device_io_stop() in the
error path. This avoids processing of HID reports when the probe fails
which possibly leads to invalid memory access in hid_device_probe() as
report_enum->report_id_hash might already be freed via
hid_close_report().

hid_set_drvdata() is called before wtp_allocate, be consistent and clear
drvdata too on the error path of wtp_allocate.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
Hi Andrew,

There are few users of hid_device_io_start/stop, this is the first one
to get start/stop out of sync. Should the comment of
hid_device_io_start() be updated to ensure that hid_device_io_stop()
gets called before probe() returns? Or should the hid-core be changed to
handle this out-of-sync issue:

		if (ret) {
			if (hdev->io_started))
				down(&hdev->driver_input_lock);
			hid_close_report(hdev);
			hdev->driver = NULL;
		}

Is my observation correct or not that HID reports can arrive during
hid_close_report() when io_started == true?

Kind regards,
Peter
---
 drivers/hid/hid-logitech-hidpp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 4292cc3..2f420c0 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -1121,7 +1121,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
 		ret = wtp_allocate(hdev, id);
 		if (ret)
-			return ret;
+			goto wtp_allocate_fail;
 	}
 
 	INIT_WORK(&hidpp->work, delayed_work_cb);
@@ -1141,6 +1141,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (id->group != HID_GROUP_LOGITECH_DJ_DEVICE) {
 		if (!connected) {
 			hid_err(hdev, "Device not connected");
+			hid_device_io_stop(hdev);
 			goto hid_parse_fail;
 		}
 
@@ -1186,6 +1187,7 @@ hid_hw_start_fail:
 hid_parse_fail:
 	cancel_work_sync(&hidpp->work);
 	mutex_destroy(&hidpp->send_mutex);
+wtp_allocate_fail:
 	hid_set_drvdata(hdev, NULL);
 	return ret;
 }
-- 
2.1.3

