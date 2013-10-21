Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3JUIvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39562 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687Ab3JUIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Benjamin Tissoires" <benjamin.tissoires@gmail.com>,
        "Kees Cook" <keescook@chromium.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.588526770@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 072/149] HID: logitech-dj: validate output report details
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 297502abb32e225fb23801fcdb0e4f6f8e17099a upstream.

A HID device could send a malicious output report that would cause the
logitech-dj HID driver to leak kernel memory contents to the device, or
trigger a NULL dereference during initialization:

[  304.424553] usb 1-1: New USB device found, idVendor=046d, idProduct=c52b
...
[  304.780467] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  304.781409] IP: [<ffffffff815d50aa>] logi_dj_recv_send_report.isra.11+0x1a/0x90

CVE-2013-2895

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: drop inapplicable changes to
 logi_dj_recv_send_report()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-logitech-dj.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -791,6 +791,12 @@ static int logi_dj_probe(struct hid_devi
 		goto hid_parse_fail;
 	}
 
+	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, REPORT_ID_DJ_SHORT,
+				 0, DJREPORT_SHORT_LENGTH - 1)) {
+		retval = -ENODEV;
+		goto hid_parse_fail;
+	}
+
 	/* Starts the usb device and connects to upper interfaces hiddev and
 	 * hidraw */
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);

