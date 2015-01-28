Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbbA2JDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:03:48 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44801 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759167AbbA2JDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:42 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/176] HID: i2c-hid: prevent buffer overflow in early IRQ
Date: Wed, 28 Jan 2015 15:27:31 +0100
Message-Id: <f0a431e778fffb7eae3350a85b0998bf17e726a6.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d1c7e29e8d276c669e8790bb8be9f505ddc48888 upstream.

Before ->start() is called, bufsize size is set to HID_MIN_BUFFER_SIZE,
64 bytes. While processing the IRQ, we were asking to receive up to
wMaxInputLength bytes, which can be bigger than 64 bytes.

Later, when ->start is run, a proper bufsize will be calculated.

Given wMaxInputLength is said to be unreliable in other part of the
code, set to receive only what we can even if it results in truncated
reports.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/i2c-hid/i2c-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index ffa9c9e13741..e29d8a0feb5f 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -356,7 +356,7 @@ static int i2c_hid_hwreset(struct i2c_client *client)
 static void i2c_hid_get_input(struct i2c_hid *ihid)
 {
 	int ret, ret_size;
-	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
+	int size = ihid->bufsize;
 
 	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
 	if (ret != size) {
-- 
2.2.2

