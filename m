Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937147Ab3DJWrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937029Ab3DJWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 07/64] HID: magicmouse: fix race between input_register() and probe()
Date: Wed, 10 Apr 2013 15:46:04 -0700
Message-Id: <20130410224334.839399776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit f1a9a149abc86903e81dd1b2e720f3f89874384b upstream.

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
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-magicmouse.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -462,6 +462,21 @@ static int magicmouse_input_mapping(stru
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
@@ -493,15 +508,10 @@ static int magicmouse_probe(struct hid_d
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
@@ -568,6 +578,7 @@ static struct hid_driver magicmouse_driv
 	.remove = magicmouse_remove,
 	.raw_event = magicmouse_raw_event,
 	.input_mapping = magicmouse_input_mapping,
+	.input_configured = magicmouse_input_configured,
 };
 
 static int __init magicmouse_init(void)


