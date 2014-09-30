Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaI3RXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaI3RSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 02/13] HID: core: do not scan reports if the group is already set
Date: Tue, 30 Sep 2014 13:18:24 -0400
Message-Id: <1412097515-17241-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the transport layer (I have in mind hid-logitech-dj and uhid)
to set the group before it is added to the hid bus. This way, it can
bypass the hid_scan_report() call, and choose in advance which driver
will handle the newly created hid device.

Signed-off-by: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 6cfecb8..f4323d2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2532,7 +2532,8 @@ int hid_add_device(struct hid_device *hdev)
 	 * Scan generic devices for group information
 	 */
 	if (hid_ignore_special_drivers ||
-	    !hid_match_id(hdev, hid_have_special_driver)) {
+	    (!hdev->group &&
+	     !hid_match_id(hdev, hid_have_special_driver))) {
 		ret = hid_scan_report(hdev);
 		if (ret)
 			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
-- 
2.1.0

