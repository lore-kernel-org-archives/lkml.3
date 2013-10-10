Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3JJQHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:07:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab3JJPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 044/104] HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails
Date: Thu, 10 Oct 2013 08:41:32 -0700
Message-Id: <1381419752-29733-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 0ccdd9e7476680c16113131264ad6597bd10299d upstream.

If tpkbd_probe_tp() bails out, the probe() function return an error,
but hid_hw_stop() is never called.

fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=1003998

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-lenovo-tpkbd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 189a3fb..2f357a3 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -416,22 +416,27 @@ static int tpkbd_probe(struct hid_device *hdev,
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "hid_parse failed\n");
-		goto err_free;
+		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "hid_hw_start failed\n");
-		goto err_free;
+		goto err;
 	}
 
 	uhdev = (struct usbhid_device *) hdev->driver_data;
 
-	if (uhdev->ifnum == 1)
-		return tpkbd_probe_tp(hdev);
+	if (uhdev->ifnum == 1) {
+		ret = tpkbd_probe_tp(hdev);
+		if (ret)
+			goto err_hid;
+	}
 
 	return 0;
-err_free:
+err_hid:
+	hid_hw_stop(hdev);
+err:
 	return ret;
 }
 
-- 
1.8.1.2

