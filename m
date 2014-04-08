Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaDHNLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:11:08 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55296 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaDHNLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:11:03 -0400
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Elias Vanderstuyft <elias.vds@gmail.com>,
        Edgar Simo-Serra <bobbens@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: lg2ff: add rumble magnitude clamping quirk
Date: Tue,  8 Apr 2014 15:06:07 +0200
Message-Id: <1396962367-6469-1-git-send-email-elias.vds@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a magnitude in the output report is lower than 2, i.e. 1 or 0,
the corresponding rumble motor shakes irregularly,
instead of being turned (almost) off like when magnitude 2 is used.
On the other hand, if a magnitude is higher than 0xfd, i.e 0xfe or 0xff,
the corresponding rumble motor shakes irregularly with a rotation speed
lower than when magnitude 0xfd is used.
>From 0x02 to 0xfd, the device behaves well:
a monotonic increase of rotation speed.
This applies to both weak and strong rumble motor types.

This patch fixes this issue by clamping magnitudes from 0x02 to 0xfd.

This behaviour is observed on the Formula Vibration wheel (ca04).
However it's not present on the Wingman Rumblepad (c20a) device,
yet the clamping has no effect on the haptic side,
so that special case handling is not needed.
Discussion on http://www.spinics.net/lists/linux-input/msg30711.html

Note: The same thing appears to happen in the Windows Logitech driver,
      except the max clamping bound is not 0xfd, but 0xfe.
      Experimentally, I proved this to be wrong.

Tested-by: Hendrik Iben <hendrik_iben@web.de>
Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>
Cc: Edgar Simo-Serra <bobbens@gmail.com>
Cc: Michal Malý <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/hid/hid-lg2ff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 0e3fb1a..e180e1e 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -38,12 +38,17 @@ static int play_effect(struct input_dev *dev, void *data,
 	struct lg2ff_device *lg2ff = data;
 	int weak, strong;
 
+#define CLAMP_QUIRK(x) do { if (x < 2) x = 2; else if (x > 0xfd) x = 0xfd; } \
+			while (0)
+
 	strong = effect->u.rumble.strong_magnitude;
 	weak = effect->u.rumble.weak_magnitude;
 
 	if (weak || strong) {
 		weak = weak * 0xff / 0xffff;
 		strong = strong * 0xff / 0xffff;
+		CLAMP_QUIRK(weak);
+		CLAMP_QUIRK(strong);
 
 		lg2ff->report->field[0]->value[0] = 0x51;
 		lg2ff->report->field[0]->value[2] = weak;
-- 
1.8.3.1

