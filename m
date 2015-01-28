Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867AbbA2Cff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:35:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbbA2Cfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 052/139] HID: i2c-hid: fix race condition reading reports
Date: Wed, 28 Jan 2015 14:19:55 -0800
Message-Id: <1422483682-15393-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 5f7e55f..bd13205 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -136,6 +136,7 @@ struct i2c_hid {
 						   * descriptor. */
 	unsigned int		bufsize;	/* i2c buffer size */
 	char			*inbuf;		/* Input buffer */
+	char			*rawbuf;	/* Raw Input buffer */
 	char			*cmdbuf;	/* Command buffer */
 	char			*argsbuf;	/* Command arguments buffer */
 
@@ -482,9 +483,11 @@ static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
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
@@ -500,10 +503,11 @@ static int i2c_hid_alloc_buffers(struct i2c_hid *ihid, size_t report_size)
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
@@ -530,12 +534,12 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 
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
@@ -544,7 +548,7 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 
 	/* The query buffer contains the size, dropping it in the reply */
 	count = min(count, ret_count - 2);
-	memcpy(buf, ihid->inbuf + 2, count);
+	memcpy(buf, ihid->rawbuf + 2, count);
 
 	return count;
 }
-- 
1.9.1

