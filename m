Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3DBJNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:13:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761097Ab3DBJMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:12:48 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH v3.7+] HID: magicmouse: fix race between input_register() and probe()
Date: Tue,  2 Apr 2013 11:11:52 +0200
Message-Id: <1364893912-29578-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kernel 3.7, it appears that the input registration occured before
the end of magicmouse_setup_input(). This is shown by receiving a lot of
"EV_SYN SYN_REPORT 1" instead of normal "EV_SYN SYN_REPORT 0".
This value means that the output buffer is full, and the user space
is loosing events.

Using .input_configured guarantees that the race is not occuring, and that
the call of "input_set_events_per_packet(input, 60)" is taken into account
by input_register().

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=908604

Reported-and-Tested-By: Clarke Wixon <cwixon@usa.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

this one can goes to stable (so 3.8) as well.

Cheers,
Benjamin

 drivers/hid/hid-magicmouse.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index ef89573..5bc3734 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -461,6 +461,21 @@ static int magicmouse_input_mapping(struct hid_device *hdev,
 	return 0;
 }
 
+static void magicmouse_input_configured(struct hid_device *hdev,
+		struct hid_input *hi)
+
+{
+	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
+
+	int ret = magicmouse_setup_input(msc->input, hdev);
+	if (ret) {
+		hid_err(hdev, "magicmouse setup input failed (%d)\n", ret);
+		/* clean msc->input to notify probe() of the failure */
+		msc->input = NULL;
+	}
+}
+
+
 static int magicmouse_probe(struct hid_device *hdev,
 	const struct hid_device_id *id)
 {
@@ -492,15 +507,10 @@ static int magicmouse_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
-	/* We do this after hid-input is done parsing reports so that
-	 * hid-input uses the most natural button and axis IDs.
-	 */
-	if (msc->input) {
-		ret = magicmouse_setup_input(msc->input, hdev);
-		if (ret) {
-			hid_err(hdev, "magicmouse setup input failed (%d)\n", ret);
-			goto err_stop_hw;
-		}
+	if (!msc->input) {
+		hid_err(hdev, "magicmouse input not registered\n");
+		ret = -ENOMEM;
+		goto err_stop_hw;
 	}
 
 	if (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
@@ -567,6 +577,7 @@ static struct hid_driver magicmouse_driver = {
 	.remove = magicmouse_remove,
 	.raw_event = magicmouse_raw_event,
 	.input_mapping = magicmouse_input_mapping,
+	.input_configured = magicmouse_input_configured,
 };
 module_hid_driver(magicmouse_driver);
 
-- 
1.8.1.4

