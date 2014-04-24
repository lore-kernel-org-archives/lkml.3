Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaDXW05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:26:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbaDXW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:26:48 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: rmi: do not fetch more than 16 bytes in a query
Date: Thu, 24 Apr 2014 18:26:38 -0400
Message-Id: <1398378398-24825-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A firmware bug is present on the XPS Haswell edition which silently
split the request in two responses when the caller ask for a read of
more than 16 bytes.
The FW sends the first 16 then the 4 next, but it says that it answered
the 20 bytes in the first report.

This occurs only on the retrieving of the min/max of X and Y of the F11
function.
We only use the first 10 bytes of the Ctrl register, so we can get only
those 10 bytes to prevent the bug from happening.

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=1090161

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-rmi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 7da9509..cee89c9 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -613,10 +613,15 @@ static int rmi_populate_f11(struct hid_device *hdev)
 		}
 	}
 
-	/* retrieve the ctrl registers */
-	ret = rmi_read_block(hdev, data->f11.control_base_addr, buf, 20);
+	/*
+	 * retrieve the ctrl registers
+	 * the ctrl register has a size of 20 but a fw bug split it into 16 + 4,
+	 * and there is no way to know if the first 20 bytes are here or not.
+	 * We use only the first 10 bytes, so get only them.
+	 */
+	ret = rmi_read_block(hdev, data->f11.control_base_addr, buf, 10);
 	if (ret) {
-		hid_err(hdev, "can not read ctrl block of size 20: %d.\n", ret);
+		hid_err(hdev, "can not read ctrl block of size 10: %d.\n", ret);
 		return ret;
 	}
 
-- 
1.9.0

