Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaHYRHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaHYRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:07:19 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?=C3=89ric=20Brunet?= <Eric.Brunet@lps.ens.fr>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: input: force generic axis to be mapped to their user space axis
Date: Mon, 25 Aug 2014 13:07:10 -0400
Message-Id: <1408986430-24451-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel 840B digitizer presents a stylus interface which reports twice
the X coordinate and then twice the Y coordinate. In its current
implementation, hid-input assign the first X to X, then the second to Y,
then the first Y to Z, then the second one to RX.

This is wrong, and X should always be mapped to X, no matter what.
A solution consists in forcing X, Y, Z, RX, RY, RZ to be mapped to their
correct user space counter part.

Reported-by: Éric Brunet <Eric.Brunet@lps.ens.fr>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, this fix should have been in the Linux kernel for ages IMO. This would
have prevented the need of HID_QUIRK_MULTI_INPUT for the very first multitouch
panels. I can not see any reasons why we want to have the second X mapped to
Y, and in the device reported here, both X have the same value.

Note that I am still investigating the spurious jumps reported by Eric, but we
should be safe in taking this one to master.

Cheers,
Benjamin

 drivers/hid/hid-input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 2619f7f..2df7fdd 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -599,6 +599,12 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		/* These usage IDs map directly to the usage codes. */
 		case HID_GD_X: case HID_GD_Y: case HID_GD_Z:
 		case HID_GD_RX: case HID_GD_RY: case HID_GD_RZ:
+			if (field->flags & HID_MAIN_ITEM_RELATIVE)
+				map_rel(usage->hid & 0xf);
+			else
+				map_abs_clear(usage->hid & 0xf);
+			break;
+
 		case HID_GD_SLIDER: case HID_GD_DIAL: case HID_GD_WHEEL:
 			if (field->flags & HID_MAIN_ITEM_RELATIVE)
 				map_rel(usage->hid & 0xf);
-- 
2.1.0

