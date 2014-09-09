Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaIIGYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:24:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32591 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaIIGXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:23:35 -0400
X-AuditID: cbfee61b-f79f86d00000144c-cf-540e9ce50f65
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v8 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Tue, 09 Sep 2014 08:23:16 +0200
Message-id: <1410243797-9719-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
References: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xgO7TOXwhBlveq1gcvF9v0bx4PZvF
	5V1z2CwWLWtltnhweCe7A6vH/rlr2D36tqxi9Dh+YzuTx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	+z/3shR84Ku43iHUwNjL08XIySEhYCIx8fJZJghbTOLCvfVsXYxcHEICixglvmxZywjhtDNJ
	PJ/QyAZSxSagI7Hl+wRGEFtEQEBi/YtL7CBFzAKNjBI/fs9g7WLk4BAW8JH4+1cfpIZFQFVi
	595mVhCbV8BF4tWjBSwQ2+QkTh6bDBbnFHCV+HZmA9h8IaCa5xumM09g5F3AyLCKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIzhonknvYFzVYHGIUYCDUYmHNyOYL0SINbGsuDL3EKMEB7OS
	CK/3DKAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGRr5w
	hXsz0m+yc++5JqYqJM3DpHhEc8rxn6pBe/v+PZrxu6rQ0TXw+Z4cHjer2+kV/zsTxJyzS+9d
	vnXjkNEvHfnA/Jb68tA5Lj8yFB/un72hPNj06a0509aKXFykwmVsaMNWlhy6+duPvHqTN5Mn
	u+/TsA9t5Ms0W74u2pRJWM31mInC9WBxJZbijERDLeai4kQAEHZnjBYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
returns endpoint descriptor to userspace. It works only if function
is active.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/function/f_fs.c  | 23 +++++++++++++++++++++++
 include/uapi/linux/usb/functionfs.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 0dc3552d..978a4c9 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1032,6 +1032,29 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 		case FUNCTIONFS_ENDPOINT_REVMAP:
 			ret = epfile->ep->num;
 			break;
+		case FUNCTIONFS_ENDPOINT_DESC:
+		{
+			int desc_idx;
+			struct usb_endpoint_descriptor *desc;
+
+			switch (epfile->ffs->gadget->speed) {
+			case USB_SPEED_SUPER:
+				desc_idx = 2;
+				break;
+			case USB_SPEED_HIGH:
+				desc_idx = 1;
+				break;
+			default:
+				desc_idx = 0;
+			}
+			desc = epfile->ep->descs[desc_idx];
+
+			spin_unlock_irq(&epfile->ffs->eps_lock);
+			ret = copy_to_user((void *)value, desc, sizeof(*desc));
+			if (ret)
+				ret = -EFAULT;
+			return ret;
+		}
 		default:
 			ret = -ENOTTY;
 		}
diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 6d2a16b..7c7a2fe 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -275,6 +275,12 @@ struct usb_functionfs_event {
  */
 #define	FUNCTIONFS_ENDPOINT_REVMAP	_IO('g', 129)
 
+/*
+ * Returns endpoint descriptor. If function is not active returns -ENODEV.
+ */
+#define	FUNCTIONFS_ENDPOINT_DESC	_IOR('g', 130, \
+					     struct usb_endpoint_descriptor)
+
 
 
 #endif /* _UAPI__LINUX_FUNCTIONFS_H__ */
-- 
1.9.1

