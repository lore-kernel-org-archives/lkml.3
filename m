Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbaGYNgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:36:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57795 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760365AbaGYNgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:36:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-2c-53d25d537494
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Fri, 25 Jul 2014 15:36:02 +0200
Message-id: <1406295363-26998-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd3g2EvBBpdbhSxmvWxnsTh4v96i
	efF6NovLu+awWSxa1spssfbIXXaLBcdbWC0eHN7J7sDhsX/uGnaPdX9eMXn0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgylt3/z1JwlrfiyNe/rA2MjdxdjJwcEgImEvvX7WeBsMUk
	Ltxbz9bFyMUhJDCdUWLes6nsEE47k8SLha1gVWwCOhJbvk9gBLFFBAQk1r+4BFbELHCcUWLm
	py9MXYwcHMICPhJTGsVAalgEVCVWrvrNCmLzCrhKTFs+jRFim5zEyWOTweKcAm4SDet2g7UK
	AdV0nbabwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwcD2T2sG4ssHiEKMAB6MS
	D29H/cVgIdbEsuLK3EOMEhzMSiK8tVGXgoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQS
	SE8sSc1OTS1ILYLJMnFwSjUwzpTvOONb/Gi+t81drucmKs51rpeS47XdNDZ/9JmfzaC419He
	Z0q51IuiqhXlBZ/eZe/4xp3/PuZj5KQFHO9fca9eEcYR8Z6jc7FbUcOd5J4VfGs+flJhzLFI
	/xl08UjpvK3OD63NT59Z0i+lomz5e9anmonMGnvzWQys6rd6Lrdmj+vIVfBUYinOSDTUYi4q
	TgQA9AQMQCoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
returns endpoint descriptor to userspace. It works only if function
is active.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/f_fs.c           | 17 +++++++++++++++++
 include/uapi/linux/usb/functionfs.h |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 490b30f..a2e18cc 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1031,6 +1031,23 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 		case FUNCTIONFS_ENDPOINT_REVMAP:
 			ret = epfile->ep->num;
 			break;
+		case FUNCTIONFS_ENDPOINT_DESC:
+		{
+			int desc_idx;
+			struct usb_endpoint_descriptor *desc;
+
+			if (epfile->ffs->gadget->speed == USB_SPEED_SUPER)
+				desc_idx = 2;
+			else if (epfile->ffs->gadget->speed == USB_SPEED_HIGH)
+				desc_idx = 1;
+			else
+				desc_idx = 0;
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
index 1dc473a..1ab6f06 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -197,6 +197,12 @@ struct usb_functionfs_event {
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

