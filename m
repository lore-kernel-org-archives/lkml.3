Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbaIDGct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:32:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14766 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbaIDGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:32:47 -0400
X-AuditID: cbfee61a-f79e46d00000134f-9f-5408078e5fc8
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v7 1/2] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Thu, 04 Sep 2014 08:32:17 +0200
Message-id: <1409812338-16012-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409812338-16012-1-git-send-email-r.baldyga@samsung.com>
References: <1409812338-16012-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd0+do4Qg7PLVCxmvWxnsTh4v96i
	efF6NovbE6exWVzeNYfNYtGyVmaLtUfuslssON7CavHg8E52B06P/XPXsHus+/OKyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJVxcuN+poIPfBUTDl5ibmDs5eli5OSQEDCRmLSx
	kw3CFpO4cG89kM3FISQwnVFiw67rjBBOO5PE3aXzGUGq2AR0JLZ8nwBmiwgISKx/cYkdpIhZ
	4AGjRPuty2CjhAV8JJ6tuAhmswioShyb38UMYvMKuEo0H1vKDrFOTuLkscmsXYwcHJwCbhIX
	97iDhIWASqbMecQ8gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgQHsmtYNxZYPF
	IUYBDkYlHt6CF+whQqyJZcWVuYcYJTiYlUR4Z58FCvGmJFZWpRblxxeV5qQWH2KU5mBREuc9
	0GodKCSQnliSmp2aWpBaBJNl4uCUamDUcOr4YWi68BLTKx8z0Q0u34py5huue7AicpPseV/7
	2aX7SjN1N85dq2y3gPFj9myP3d98X+3faK+guXlN3K3f7kGJco8irKy5Wk5keh9KS9l4SvL1
	3yk/l53ICKv8VhWi+/X8wZYS76muDPePHimZYcC2NTO1K4ZPf26SnA+D0Em+O/L3GL2UWIoz
	Eg21mIuKEwGOupjoMAIAAA==
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

