Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIHH5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:57:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45688 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaIHH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:57:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0e-540d615f3dc5
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v7 1/2] usb: gadget: f_fs: add ioctl returning ep
 descriptor
Date: Mon, 08 Sep 2014 09:56:59 +0200
Message-id: <1410163020-13910-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410163020-13910-1-git-send-email-r.baldyga@samsung.com>
References: <1410163020-13910-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xoG58Im+IwaHZNhYH79dbNC9ez2Zx
	edccNotFy1qZLR4c3snuwOqxf+4ado++LasYPY7f2M7k8XmTXABLFJdNSmpOZllqkb5dAlfG
	nMP32Qve81UsfOLYwNjD08XIySEhYCLx6+hbZghbTOLCvfVsXYxcHEIC0xkldn5fzgrhtDNJ
	3D/2gA2kik1AR2LL9wmMILaIgIDE+heX2EGKmAUaGSV+/J7BCpIQFgiV6N/Wxw5iswioSqzd
	vAyomYODV8BVYvKxfIhtchInj00GK+cUcJPY3H2QCcQWAiqZc3gT0wRG3gWMDKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgoPmmdQOxpUNFocYBTgYlXh4OS7zhAixJpYVV+YeYpTgYFYS
	4WUI4w0R4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLjx
	V43J+rVqcn9k8x/UmGS7BC/kPniPdY48d5FskFvRgSbbdx2bK2a6L63m8Dq+g+W77a35cZee
	/Lv4+f4lp9A9EfqvPp31X9PxtDpn2opmW5s7d6u6521Q+rf5scSzo5M36GVWN5tv3XTmjt/s
	98FPPfZXMEYIPLvy8fv5+VfKD7UY7okwiWZRYinOSDTUYi4qTgQAlFgixxYCAAA=
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
index dc30adf..6405e0f 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1026,6 +1026,29 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
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

