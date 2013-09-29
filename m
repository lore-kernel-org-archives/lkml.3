Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3I2T6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:58:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3I2T1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 14/49] HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails
Date: Sun, 29 Sep 2013 12:26:48 -0700
Message-Id: <20130929191603.977889166@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 0ccdd9e7476680c16113131264ad6597bd10299d upstream.

If tpkbd_probe_tp() bails out, the probe() function return an error,
but hid_hw_stop() is never called.

fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=1003998

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lenovo-tpkbd.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -406,22 +406,27 @@ static int tpkbd_probe(struct hid_device
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
 


