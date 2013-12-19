Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3LSLdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:33:04 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:53082 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3LSLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:33:03 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] HID: hyperv: make sure input buffer is big enough
Date: Thu, 19 Dec 2013 12:32:24 +0100
Message-Id: <1387452744-8860-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need at least HID_MAX_BUFFER_SIZE (4096) bytes as input buffer. HID
core depends on this as it requires every input report to be at least as
big as advertised.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
Hi

Same as for the HIDP patch, if there's a way to avoid the extra copy, please
provide a better patch.

Thanks
David

 drivers/hid/hid-hyperv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 8fae6d1..c24908f 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -157,6 +157,7 @@ struct mousevsc_dev {
 	u32			report_desc_size;
 	struct hv_input_dev_info hid_dev_info;
 	struct hid_device       *hid_device;
+	u8			input_buf[HID_MAX_BUFFER_SIZE];
 };
 
 
@@ -256,6 +257,7 @@ static void mousevsc_on_receive(struct hv_device *device,
 	struct synthhid_msg *hid_msg;
 	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
 	struct synthhid_input_report *input_report;
+	size_t len;
 
 	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
 						(packet->offset8 << 3));
@@ -300,9 +302,12 @@ static void mousevsc_on_receive(struct hv_device *device,
 			(struct synthhid_input_report *)pipe_msg->data;
 		if (!input_dev->init_complete)
 			break;
-		hid_input_report(input_dev->hid_device,
-				HID_INPUT_REPORT, input_report->buffer,
-				input_report->header.size, 1);
+
+		len = min(input_report->header.size,
+			  (u32)sizeof(input_dev->input_buf));
+		memcpy(input_dev->input_buf, input_report->buffer, len);
+		hid_input_report(input_dev->hid_device, HID_INPUT_REPORT,
+				 input_dev->input_buf, len, 1);
 		break;
 	default:
 		pr_err("unsupported hid msg type - type %d len %d",
-- 
1.8.5.1

