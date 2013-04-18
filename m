Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967232Ab3DRQz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:55:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3DRQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:55:55 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: core: dump events in hidraw even if raw_event() returns > 0
Date: Thu, 18 Apr 2013 18:55:06 +0200
Message-Id: <1366304106-32243-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If raw_events() returns a value not equal to 0, the processing stops.
However, I think we should still forward the events to the hidraw node,
unless there is an error in raw_event() marked by a negative value.

For instance, hid-magicmouse stops the processing because the device
use a hidden collection (not declared in hid reports descriptor), making
hid-core lost when dealing with it. However, forwarding it to the
user-space through hidraw is harmless and can help debugging the driver.

Of course, hid debugfs can be used, but there is currently a problem with
the output beeing too small for some devices and it adds processing in the
kernel because debugfs returns human readable strings outputs.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, this is the patch I mentioned earlier.
I don't think it will break anything, but I don't know how many applications
use hidraw and will be hurt by receiving more events. I did a quick review
of all hid drivers, and some of them are returning 1 in their raw_event().
The only problematic one is hid-primax, which manually calls
hid_report_raw_event() before returning 1... which is... weird.

Anyway, I would like your advice on this, if you think it's valuable or if
we should drop it and continue with the current implementation.

Cheers,
Benjamin

 drivers/hid/hid-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1129f49..e0b8175 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1315,6 +1315,8 @@ nomem:
 	if (hdrv && hdrv->raw_event && hid_match_report(hid, report)) {
 		ret = hdrv->raw_event(hid, report, data, size);
 		if (ret != 0) {
+			if (ret > 0 && (hid->claimed & HID_CLAIMED_HIDRAW))
+				ret = hidraw_report_event(hid, data, size);
 			ret = ret < 0 ? ret : 0;
 			goto unlock;
 		}
-- 
1.8.1.4

