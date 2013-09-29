Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab3I2TpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:45:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3I2T2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 17/71] HID: steelseries: validate output report details
Date: Sun, 29 Sep 2013 12:27:29 -0700
Message-Id: <20130929192644.707216936@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 41df7f6d43723deb7364340b44bc5d94bf717456 upstream.

A HID device could send a malicious output report that would cause the
steelseries HID driver to write beyond the output report allocation
during initialization, causing a heap overflow:

[  167.981534] usb 1-1: New USB device found, idVendor=1038, idProduct=1410
...
[  182.050547] BUG kmalloc-256 (Tainted: G        W   ): Redzone overwritten

CVE-2013-2891

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-steelseries.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/hid-steelseries.c
+++ b/drivers/hid/hid-steelseries.c
@@ -249,6 +249,11 @@ static int steelseries_srws1_probe(struc
 		goto err_free;
 	}
 
+	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 0, 0, 16)) {
+		ret = -ENODEV;
+		goto err_free;
+	}
+
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");


