Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaF1TFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:05:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaF1Rsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 42/77] media: stk1160: Avoid stack-allocated buffer for control URBs
Date: Sat, 28 Jun 2014 10:46:35 -0700
Message-Id: <20140628174523.720727311@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/stk1160/stk1160-core.c |   10 +++++++++-
 drivers/media/usb/stk1160/stk1160.h      |    1 -
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -67,17 +67,25 @@ int stk1160_read_reg(struct stk1160 *dev
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
 
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -143,7 +143,6 @@ struct stk1160 {
 	int num_alt;
 
 	struct stk1160_isoc_ctl isoc_ctl;
-	char urb_buf[255];	 /* urb control msg buffer */
 
 	/* frame properties */
 	int width;		  /* current frame width */


