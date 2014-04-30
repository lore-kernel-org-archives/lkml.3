Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbaD3Vsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbaD3Vsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:48:45 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthias Bayer <thematthiasbayer@gmail.com>
Subject: [PATCH] HID: core: fix computation of the report size
Date: Wed, 30 Apr 2014 17:48:40 -0400
Message-Id: <1398894520-30407-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extra seven bits are only required when allocating the report buffer.
We can not use those extra bytes for the length of the report in the
generic implementation of .request because the device might (will) refuse
the set_report command.
This has been verified on the Atmel touchpad found on the Samsung Ativ 9
plus, which uses hid-multitouch and HID over I2C. Without this fix, the
device refuses to switch to the multitouch mode, and it becomes unresponsive
from the user point of view.

Actually, this has been discussed during the initial submission of the
commit 4fa5a7f76cc7b6ac87f57741edd2b124851d119f, see
https://patchwork.kernel.org/patch/3621751/

Unfortunately, I completely forgot about it later.

Reported-by: Matthias Bayer <thematthiasbayer@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

can you schedule this fix for 3.15?

Fortunately, the device required some ACPI changes, so it was not seen at all
in 3.13 and before. I am not sure of the status of 3.14, but it is definitively
not working in 3.15.

Cheers,
Benjamin

 drivers/hid/hid-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 963a8da..e0f6753 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1253,7 +1253,8 @@ EXPORT_SYMBOL_GPL(hid_output_report);
 
 static int hid_report_len(struct hid_report *report)
 {
-	return ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
+	/* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
+	return ((report->size - 1) >> 3) + 1 + (report->id > 0);
 }
 
 /*
@@ -1266,7 +1267,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 	 * of implement() working on 8 byte chunks
 	 */
 
-	int len = hid_report_len(report);
+	int len = hid_report_len(report) + 7;
 
 	return kmalloc(len, flags);
 }
-- 
1.9.0

