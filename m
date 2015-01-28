Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbbA2JhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:37:19 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44856 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760041AbbA2JF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/176] HID: i2c-hid: fix race condition reading reports
Date: Wed, 28 Jan 2015 15:27:30 +0100
Message-Id: <5927cd034b1a289e1c73018fc908403c0ce15658.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6296f4a8eb86f9abcc370fb7a1a116b8441c17fd upstream.

Current driver uses a common buffer for reading reports either
synchronously in i2c_hid_get_raw_report() and asynchronously in
the interrupt handler.
There is race condition if an interrupt arrives immediately after
the report is received in i2c_hid_get_raw_report(); the common
buffer is modified by the interrupt handler with the new report
and then i2c_hid_get_raw_report() proceed using wrong data.

Fix it by using a separate buffers for synchronous reports.

Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
[Antonio Borneo: cleanup, rebase to v3.17, submit mainline]
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/i2c-hid/i2c-hid.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index c1336193b04b..ffa9c9e13741 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -136,6 +136,7 @@ struct i2c_hid {
 						   * descriptor. */
 	unsigned int		bufsize;	/* i2c buffer size */
 	char			*inbuf;		/* Input buffer */
+	char			*rawbuf;	/* Raw Input buffer */
 	char			*cmdbuf;	/* Command buffer */
 	char			*argsbuf;	/* Command arguments buffer */
 
@@ -486,9 +487,11 @@ static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
 static void i2c_hid_free_buffers(struct i2c_hid *ihid)
 {
 	kfree(ihid->inbuf);
+	kfree(ihid->rawbuf);
 	kfree(ihid->argsbuf);
 	kfree(ihid->cmdbuf);
 	ihid->inbuf = NULL;
+	ihid->rawbuf = NULL;
 	ihid->cmdbuf = NULL;
 	ihid->argsbuf = NULL;
 	ihid->bufsize = 0;
@@ -504,10 +507,11 @@ static int i2c_hid_alloc_buffers(struct i2c_hid *ihid, size_t report_size)
 		       report_size; /* report */
 
 	ihid->inbuf = kzalloc(report_size, GFP_KERNEL);
+	ihid->rawbuf = kzalloc(report_size, GFP_KERNEL);
 	ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
 	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
 
-	if (!ihid->inbuf || !ihid->argsbuf || !ihid->cmdbuf) {
+	if (!ihid->inbuf || !ihid->rawbuf || !ihid->argsbuf || !ihid->cmdbuf) {
 		i2c_hid_free_buffers(ihid);
 		return -ENOMEM;
 	}
@@ -534,12 +538,12 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 
 	ret = i2c_hid_get_report(client,
 			report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
-			report_number, ihid->inbuf, ask_count);
+			report_number, ihid->rawbuf, ask_count);
 
 	if (ret < 0)
 		return ret;
 
-	ret_count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
+	ret_count = ihid->rawbuf[0] | (ihid->rawbuf[1] << 8);
 
 	if (ret_count <= 2)
 		return 0;
@@ -548,7 +552,7 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 
 	/* The query buffer contains the size, dropping it in the reply */
 	count = min(count, ret_count - 2);
-	memcpy(buf, ihid->inbuf + 2, count);
+	memcpy(buf, ihid->rawbuf + 2, count);
 
 	return count;
 }
-- 
2.2.2

