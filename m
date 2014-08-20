Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHTFr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:47:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62042 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaHTFrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:47:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-ac-53f4366b86ce
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Wed, 20 Aug 2014 07:46:24 +0200
Message-id: <1408513585-28261-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
References: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd1ssy/BBj1zFCxmvWxnsTh4v96i
	efF6NovbE6exWVzeNYfNYtGyVmaLtUfuslssON7CavHg8E52B06P/XPXsHus+/OKyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJVxZO8ipoI2vorXZ/YwNjBu4O5i5OSQEDCR+Lj7
	OiOELSZx4d56ti5GLg4hgUWMEjcurWCGcNqZJO693sIGUsUmoCOx5fsEsA4RAQGJ9S8usYMU
	MQs8YJRov3UZrEhYwEfiaydEA4uAqsSTD5vAGngFXCWunrrJBLFOTuLkscmsIDangJvEz+79
	zCC2EFBN27HXjBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA61Z9I7GFc1WBxi
	FOBgVOLhdWj/HCzEmlhWXJl7iFGCg1lJhJdN40uwEG9KYmVValF+fFFpTmrxIUZpDhYlcd6D
	rdaBQgLpiSWp2ampBalFMFkmDk6pBsaFatl/Hl5pDo8TOPdA+f1X7ZOVBV4H7p7hmLPrvqSq
	l97GVV8mypaJbrjVuUiAnXVakpaR9ZasO5ujaw986O6b2mSWZ515/xTnG+5DWiEXV+VF/QoV
	XPNp2cE+RjXJlM2T7AU6vU/+bKp5krLu/I//2Xv+6livFV4r1nR7jqF7rV6CwcusS9FKLMUZ
	iYZazEXFiQCJsEKQMQIAAA==
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
index 0154b28..900896e 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -265,6 +265,12 @@ struct usb_functionfs_event {
  */
 #define	FUNCTIONFS_ENDPOINT_REVMAP	_IO('g', 129)
 
+/*
+ * Returns endpoint descriptor. In funciton is not active returns -ENODEV.
+ */
+#define	FUNCTIONFS_ENDPOINT_DESC	_IOR('g', 130, \
+					     struct usb_endpoint_descriptor)
+
 
 
 #endif /* _UAPI__LINUX_FUNCTIONFS_H__ */
-- 
1.9.1

