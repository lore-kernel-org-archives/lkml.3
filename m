Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaH0HM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:12:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaH0HM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:12:26 -0400
Date: Wed, 27 Aug 2014 09:12:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: linux-input@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: magicmouse: sanity check report size in raw_event()
 callback
Message-ID: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The report passed to us from transport driver could potentially be 
arbitrarily large, therefore we better sanity-check it so that 
magicmouse_emit_touch() gets only valid values of raw_id.

Cc: stable@vger.kernel.org
Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-magicmouse.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index ecc2cbf..29a74c1 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -290,6 +290,11 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		if (size < 4 || ((size - 4) % 9) != 0)
 			return 0;
 		npoints = (size - 4) / 9;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for TRACKPAD_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches = 0;
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
@@ -307,6 +312,11 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		if (size < 6 || ((size - 6) % 8) != 0)
 			return 0;
 		npoints = (size - 6) / 8;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for MOUSE_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches = 0;
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
-- 
1.9.2
