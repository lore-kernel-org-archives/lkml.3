Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab3JJPvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:51:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab3JJPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 040/104] HID: lenovo-tpkbd: validate output report details
Date: Thu, 10 Oct 2013 08:41:28 -0700
Message-Id: <1381419752-29733-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-lenovo-tpkbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index cea016e..189a3fb 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -341,7 +341,15 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
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
-- 
1.8.1.2

