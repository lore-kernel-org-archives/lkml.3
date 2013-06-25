Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3FYRvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:51:55 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41297 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab3FYRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:51:54 -0400
From: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
To: linux-kernel@vger.kernel.org
Cc: rydberg@euromail.se, srinivas.pandruvada@intel.com,
        erazor_de@users.sourceforge.net, benjamin.tissoires@redhat.com,
        jkosina@suse.cz, lorenz@badgers.com,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
Subject: [PATCH] Added a check for NULL pointer in hid_add_device
Date: Tue, 25 Jun 2013 19:51:41 +0200
Message-Id: <1372182701-12256-1-git-send-email-michael.banken@mathe.stud.uni-erlangen.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check greatly simplifies creating a dummy hid device.
With this check in place a hid dummy can be created simply by allocating and adding the device.
This used to be possible in earlier Kernel versions.

Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
---
 drivers/hid/hid-core.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0951a9a..88c573e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2289,24 +2289,27 @@ int hid_add_device(struct hid_device *hdev)
 	if (hid_ignore(hdev))
 		return -ENODEV;
 
-	/*
-	 * Read the device report descriptor once and use as template
-	 * for the driver-specific modifications.
-	 */
-	ret = hdev->ll_driver->parse(hdev);
-	if (ret)
-		return ret;
-	if (!hdev->dev_rdesc)
-		return -ENODEV;
-
-	/*
-	 * Scan generic devices for group information
-	 */
-	if (hid_ignore_special_drivers ||
-	    !hid_match_id(hdev, hid_have_special_driver)) {
-		ret = hid_scan_report(hdev);
+	if (hdev->ll_driver != NULL) {
+		/*
+		 * Read the device report descriptor once and use as template
+			 * for the driver-specific modifications.
+		 */
+		ret = hdev->ll_driver->parse(hdev);
 		if (ret)
-			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
+			return ret;
+		if (!hdev->dev_rdesc)
+			return -ENODEV;
+
+		/*
+		 * Scan generic devices for group information
+		 */
+		if (hid_ignore_special_drivers ||
+		    !hid_match_id(hdev, hid_have_special_driver)) {
+			ret = hid_scan_report(hdev);
+			if (ret)
+				hid_warn(hdev,
+					"bad device descriptor (%d)\n", ret);
+		}
 	}
 
 	/* XXX hack, any other cleaner solution after the driver core
-- 
1.7.10.4

