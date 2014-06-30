Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaF3Mmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:42:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065AbaF3MbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 140/181] media: stk1160: Avoid stack-allocated buffer for control URBs
Date: Mon, 30 Jun 2014 13:52:41 +0200
Message-Id: <66d2fd610dac2c69c2128b2e10880652767c63bd.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 85ac1a1772bb41da895bad83a81f6a62c8f293f6 upstream.

Currently stk1160_read_reg() uses a stack-allocated char to get the
read control value. This is wrong because usb_control_msg() requires
a kmalloc-ed buffer.

This commit fixes such issue by kmalloc'ating a 1-byte buffer to receive
the read value.

While here, let's remove the urb_buf array which was meant for a similar
purpose, but never really used.

Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/stk1160/stk1160-core.c | 10 +++++++++-
 drivers/media/usb/stk1160/stk1160.h      |  1 -
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 34a26e0cfe77..03504dcf3c52 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -67,17 +67,25 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
 {
 	int ret;
 	int pipe = usb_rcvctrlpipe(dev->udev, 0);
+	u8 *buf;
 
 	*value = 0;
+
+	buf = kmalloc(sizeof(u8), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, value, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), HZ);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
+		kfree(buf);
 		return ret;
 	}
 
+	*value = *buf;
+	kfree(buf);
 	return 0;
 }
 
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 05b05b160e1e..abdea484c998 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -143,7 +143,6 @@ struct stk1160 {
 	int num_alt;
 
 	struct stk1160_isoc_ctl isoc_ctl;
-	char urb_buf[255];	 /* urb control msg buffer */
 
 	/* frame properties */
 	int width;		  /* current frame width */
-- 
2.0.0

