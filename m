Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaHUMKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:10:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16729 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaHUMKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:10:09 -0400
X-AuditID: cbfee61a-f79e46d00000134f-c4-53f5e19f41ac
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v5 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Thu, 21 Aug 2014 14:09:18 +0200
Message-id: <1408622959-4096-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com>
References: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd35D78GG3zaxG0x62U7i8XB+/UW
	zYvXs1ncnjiNzeLyrjlsFouWtTJbrD1yl91iwfEWVosHh3eyO3B67J+7ht1j3Z9XTB59W1Yx
	ehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6MyZ9/Mxe08VX8Oj6dqYFxA3cXIyeHhICJxIEf
	d5khbDGJC/fWs3UxcnEICSxilOjb8JcZwmlnkji3YhUjSBWbgI7Elu8TwGwRAQGJ9S8usYMU
	MQs8YJRov3UZqJ2DQ1jAR+LS0miQGhYBVYmVX+6ygIR5BVwkTm02gVgmJ3Hy2GRWEJtTwFWi
	sfMzG4gtBFTy5OsUpgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBIfZM6kdjCsb
	LA4xCnAwKvHwNiz4EizEmlhWXJl7iFGCg1lJhPfM6a/BQrwpiZVVqUX58UWlOanFhxilOViU
	xHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhi9/z/QbNM+12+We2xHVurEar0DXtUn3j4UsTlS
	LxUaeefmjcJwWXWJ6S5qH9zKhJ1Wu4vMj25+eFA7/J5atpyh+BGzBsXGLz16X20axLXWrJip
	IzNl89aorMf+2jM8crnZV/wXDOG8rf808ln24jJHtZ3trv3tHTM/3OZ9FjXvaPdqjounPiux
	FGckGmoxFxUnAgAYnhMHLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
returns endpoint descriptor to userspace. It works only if function
is active.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/function/f_fs.c  | 21 +++++++++++++++++++++
 include/uapi/linux/usb/functionfs.h |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 8096f22..ac7b16d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1032,6 +1032,27 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
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
+			ret = copy_to_user((void *)value, desc, sizeof(*desc));
+			if (ret)
+				ret = -EFAULT;
+			break;
+		}
 		default:
 			ret = -ENOTTY;
 		}
diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 0154b28..7677108 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -265,6 +265,12 @@ struct usb_functionfs_event {
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

