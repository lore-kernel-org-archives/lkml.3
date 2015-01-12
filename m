Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbbALTBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:01:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbALS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gwendal Grignou <gwendal@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 130/216] HID: i2c-hid: prevent buffer overflow in early IRQ
Date: Mon, 12 Jan 2015 18:28:28 +0000
Message-Id: <1421087394-2712-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 523ebb74097d..9bce5bf4182d 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -370,7 +370,7 @@ static int i2c_hid_hwreset(struct i2c_client *client)
 static void i2c_hid_get_input(struct i2c_hid *ihid)
 {
 	int ret, ret_size;
-	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
+	int size = ihid->bufsize;
 
 	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
 	if (ret != size) {
-- 
2.1.4

