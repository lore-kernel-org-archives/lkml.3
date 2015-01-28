Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbbA2KnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:43:00 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754799AbbA2JAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:01 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 174/176] usb: musb: Fix a few off-by-one lengths
Date: Wed, 28 Jan 2015 15:30:04 +0100
Message-Id: <205de7838a458df3ae58f534d9b9422e074e158c.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e87c3f80ad0490d26ffe04754b7d094463b40f30 upstream.

!strncmp(buf, "force host", 9) is true if and only if buf starts with
"force hos". This was obviously not what was intended. The same error
exists for "force full-speed", "force high-speed" and "test
packet". Using strstarts avoids the error-prone hardcoding of the
prefix length.

For consistency, also change the other occurences of the !strncmp
idiom.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/musb/musb_cppi41.c  |  4 ++--
 drivers/usb/musb/musb_debugfs.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index 5c91ff379345..77b475a43dad 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -586,9 +586,9 @@ static int cppi41_dma_controller_start(struct cppi41_dma_controller *controller)
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
index 4c216790e86b..05d1b203f0d0 100644
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
2.2.2

