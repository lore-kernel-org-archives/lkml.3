Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142AbaGCKMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:12:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298AbaGCJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/198] [media] media: stk1160: Avoid stack-allocated buffer for control URBs
Date: Thu,  3 Jul 2014 10:18:05 +0100
Message-Id: <1404379241-8590-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

