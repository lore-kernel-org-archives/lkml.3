Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3GLJIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab3GLJIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:08:35 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: do not init reports for multitouch devices
Date: Fri, 12 Jul 2013 11:08:21 +0200
Message-Id: <1373620101-16113-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some multitouch screens do not like to be polled for input reports.
However, the Win8 spec says that all touches should be sent during
each report, making the initialization of reports unnecessary.
The Win7 spec is less precise, but we can safely assume that when
the module is loaded (at boot), no one is touching the screen.

Add the quirk HID_QUIRK_NO_INIT_REPORTS so that we do not have to
introduce a quirk for each problematic device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d99b959..197c2e6 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -957,6 +957,15 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
 
 	/*
+	 * Some multitouch screens do not like to be polled for input reports.
+	 * However, the Win8 spec says that all touches should be sent during
+	 * each report, making the initialization of reports unnecessary.
+	 * The Win7 spec is less precise, but we can safely assume that when
+	 * the module is loaded (at boot), no one is touching the screen.
+	 */
+	hdev->quirks |= HID_QUIRK_NO_INIT_REPORTS;
+
+	/*
 	 * This allows the driver to handle different input sensors
 	 * that emits events through different reports on the same HID
 	 * device.
-- 
1.8.3.1

