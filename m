Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbbANH2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbbANH2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.18 055/150] HID: i2c-hid: prevent buffer overflow in early IRQ
Date: Tue, 13 Jan 2015 23:22:06 -0800
Message-Id: <20150114072058.365798430@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -370,7 +370,7 @@ static int i2c_hid_hwreset(struct i2c_cl
 static void i2c_hid_get_input(struct i2c_hid *ihid)
 {
 	int ret, ret_size;
-	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
+	int size = ihid->bufsize;
 
 	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
 	if (ret != size) {


