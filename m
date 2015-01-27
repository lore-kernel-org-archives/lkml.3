Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbbA0MFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:05:39 -0500
Received: from a8-23.smtp-out.amazonses.com ([54.240.8.23]:37428 "EHLO
	a8-23.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbbA0MFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:05:35 -0500
X-Greylist: delayed 3287 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 07:05:35 EST
From: Jim Keir <jimkeir@oracledbadirect.com>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Cc: Jim Keir <jimkeir@oracledbadirect.com>
Subject: [PATCH 2/2] Fix force effect modifications for the Microsoft Sidewinder Force Feedback Pro 2 joystick
Date: Tue, 27 Jan 2015 10:59:27 +0000
Message-ID: <0000014b2b0bc77f-e684a707-986b-4473-b45f-fe668b06f2f3-000000@email.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2015.01.27-54.240.8.23
Feedback-ID: us-east-1.amlta2VpckBvcmFjbGVkYmFkaXJlY3QuY29t:AmazonSES
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
The FF2 driver (usbhid/hid-pidff.c) does not set the effect ID when
uploading an effect. The result is that the initial upload works but
subsequent uploads to modify effect parameters are all directed at the
last-created effect.

The targeted effect ID must be passed back to the device when effect
parameters are changed. This is done at the start of
"pidff_set_condition_report", "pidff_set_periodic_report" etc. based on
the value of "pidff->block_load[PID_EFFECT_
BLOCK_INDEX].value[0]".

This value is only ever set during pidff_request_effect_upload.
The result is stored in "pidff->pid_id[effect->id]" at the end of
pid_upload_effect, for later use. However, if an effect is modified and
re-sent then this identifier is not being copied back from
pidff->pid_id[effect->id] before sending the command to the device. The
fix is to do this at the start of pidff_upload_effect.

Signed-off-by: Jim Keir <jimkeir@oracledbadirect.com> 

 drivers/hid/usbhid/hid-pidff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 0b531c6..1b3fa70 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -568,6 +568,12 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 	int type_id;
 	int error;
 
+	pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
+	if (old && effect) {
+		pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] =
+			pidff->pid_id[effect->id];
+	}
+
 	switch (effect->type) {
 	case FF_CONSTANT:
 		if (!old) {
-- 
1.9.1

