Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaK0V06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:26:58 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:58194 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK0V04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:26:56 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Felipe Balbi <balbi@ti.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: Fix a few off-by-one lengths
Date: Thu, 27 Nov 2014 22:25:45 +0100
Message-Id: <1417123546-2011-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

!strncmp(buf, "force host", 9) is true if and only if buf starts with
"force hos". This was obviously not what was intended. The same error
exists for "force full-speed", "force high-speed" and "test
packet". Using strstarts avoids the error-prone hardcoding of the
prefix length.

For consistency, also change the other occurences of the !strncmp
idiom.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
Strictly speaking this is a user-visible change since buf came from
userspace. I can't believe anybody cares, though.

 drivers/usb/musb/musb_cppi41.c  |  4 ++--
 drivers/usb/musb/musb_debugfs.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index 5a9b977..560d54f 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -620,9 +620,9 @@ static int cppi41_dma_controller_start(struct cppi41_dma_controller *controller)
 		ret = of_property_read_string_index(np, "dma-names", i, &str);
 		if (ret)
 			goto err;
-		if (!strncmp(str, "tx", 2))
+		if (strstarts(str, "tx"))
 			is_tx = 1;
-		else if (!strncmp(str, "rx", 2))
+		else if (strstarts(str, "rx"))
 			is_tx = 0;
 		else {
 			dev_err(dev, "Wrong dmatype %s\n", str);
diff --git a/drivers/usb/musb/musb_debugfs.c b/drivers/usb/musb/musb_debugfs.c
index 4c21679..05d1b20 100644
--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -194,30 +194,30 @@ static ssize_t musb_test_mode_write(struct file *file,
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	if (!strncmp(buf, "force host", 9))
+	if (strstarts(buf, "force host"))
 		test = MUSB_TEST_FORCE_HOST;
 
-	if (!strncmp(buf, "fifo access", 11))
+	if (strstarts(buf, "fifo access"))
 		test = MUSB_TEST_FIFO_ACCESS;
 
-	if (!strncmp(buf, "force full-speed", 15))
+	if (strstarts(buf, "force full-speed"))
 		test = MUSB_TEST_FORCE_FS;
 
-	if (!strncmp(buf, "force high-speed", 15))
+	if (strstarts(buf, "force high-speed"))
 		test = MUSB_TEST_FORCE_HS;
 
-	if (!strncmp(buf, "test packet", 10)) {
+	if (strstarts(buf, "test packet")) {
 		test = MUSB_TEST_PACKET;
 		musb_load_testpacket(musb);
 	}
 
-	if (!strncmp(buf, "test K", 6))
+	if (strstarts(buf, "test K"))
 		test = MUSB_TEST_K;
 
-	if (!strncmp(buf, "test J", 6))
+	if (strstarts(buf, "test J"))
 		test = MUSB_TEST_J;
 
-	if (!strncmp(buf, "test SE0 NAK", 12))
+	if (strstarts(buf, "test SE0 NAK"))
 		test = MUSB_TEST_SE0_NAK;
 
 	musb_writeb(musb->mregs, MUSB_TESTMODE, test);
-- 
2.0.4

