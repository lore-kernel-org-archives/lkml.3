Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbbA2Cxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:53:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965501AbbA2CiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:18 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gwendal Grignou <gwendal@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 114/139] HID: i2c-hid: prevent buffer overflow in early IRQ
Date: Wed, 28 Jan 2015 14:20:57 -0800
Message-Id: <1422483682-15393-115-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gwendal Grignou <gwendal@chromium.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index bd13205..05c2134 100644
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
1.9.1

