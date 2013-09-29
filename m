Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3I2T5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:57:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab3I2T15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 16/49] HID: lenovo-tpkbd: validate output report details
Date: Sun, 29 Sep 2013 12:26:50 -0700
Message-Id: <20130929191604.110165924@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 0a9cd0a80ac559357c6a90d26c55270ed752aa26 upstream.

A HID device could send a malicious output report that would cause the
lenovo-tpkbd HID driver to write just beyond the output report allocation
during initialization, causing a heap overflow:

[   76.109807] usb 1-1: New USB device found, idVendor=17ef, idProduct=6009
...
[   80.462540] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

CVE-2013-2894

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lenovo-tpkbd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -339,7 +339,15 @@ static int tpkbd_probe_tp(struct hid_dev
 	struct tpkbd_data_pointer *data_pointer;
 	size_t name_sz = strlen(dev_name(dev)) + 16;
 	char *name_mute, *name_micmute;
-	int ret;
+	int i, ret;
+
+	/* Validate required reports. */
+	for (i = 0; i < 4; i++) {
+		if (!hid_validate_values(hdev, HID_FEATURE_REPORT, 4, i, 1))
+			return -ENODEV;
+	}
+	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 3, 0, 2))
+		return -ENODEV;
 
 	if (sysfs_create_group(&hdev->dev.kobj,
 				&tpkbd_attr_group_pointer)) {


