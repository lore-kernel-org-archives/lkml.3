Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaG3Jod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:44:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30996 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaG3JoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:44:04 -0400
X-AuditID: cbfee61a-f79e46d00000134f-92-53d8be617236
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Wed, 30 Jul 2014 11:43:42 +0200
Message-id: <1406713423-32472-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
References: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQd3EfTeCDa6/s7KY9bKdxeLg/XqL
	5sXr2SxuT5zGZnF51xw2i0XLWpkt1h65y26x4HgLq8WDwzvZHTg99s9dw+6x7s8rJo++LasY
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGn/89TAVneSsen/3A2sDYyN3FyMkhIWAi8fn5
	LxYIW0ziwr31bCC2kMB0RomzR0u7GLmA7HYmicfTfrGDJNgEdCS2fJ/ACGKLCAhIrH9xiR2k
	iFngAaNE+63LYN3CAj4SXx91gU1lEVCVWLRhJVgDr4CrxLy181khtslJnDw2GczmFHCTOLnp
	AVANB9A2V4nvT7wmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcZs+kdjCubLA4
	xCjAwajEwzvj//VgIdbEsuLK3EOMEhzMSiK8fWtvBAvxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgPPW42OVF/e8FwSmWXUU8q44vLz84m3MvW0B5Y3tr
	1ZE4fZs/c5PvzgxuD0j5kCf4ZYKlcsJq3uOXJmoUR2feEetbdcRpdo5n0YFo62PPZSob5Gx9
	jh27uKp6cULHH8nXCx7dLr0Xuuqicms+s/fdOxtmvTi21aYywM86MnJC/3pTn/sLtkkyK7EU
	ZyQaajEXFScCAF2gFEgvAgAA
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
index 6b806be..7f16c5a 100644
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

