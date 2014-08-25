Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaHYJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:16:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12148 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaHYJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:16:57 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a2-53faff076d11
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v6 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
Date: Mon, 25 Aug 2014 11:16:28 +0200
Message-id: <1408958189-20611-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408958189-20611-1-git-send-email-r.baldyga@samsung.com>
References: <1408958189-20611-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQV32/7+CDc6t1reY9bKdxeLg/XqL
	5sXr2SxuT5zGZnF51xw2i0XLWpkt1h65y26x4HgLq8WDwzvZHTg99s9dw+6x7s8rJo++LasY
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfG6fOLmAre8FUcWPaQvYGxi6eLkZNDQsBE4vz6
	FSwQtpjEhXvr2boYuTiEBKYzSnw7d5sdwmlnkrgweS07SBWbgI7Elu8TGEFsEQEBifUvLoEV
	MQs8YJRov3WZDSQhLOAj8ebiU2YQm0VAVeLNlSamLkYODl4BV4mlR8IhtslJnDw2mRXE5hRw
	k5g8cwsTiC0EVNKxchrrBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCA+2Z9A7G
	VQ0WhxgFOBiVeHhXcv4KFmJNLCuuzD3EKMHBrCTCq/EHKMSbklhZlVqUH19UmpNafIhRmoNF
	SZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGxbUJNWpZ6s9uNhdnRf2vuqnyf3yPyf+rbBkXV
	xql6azyTtF6zHzkf7rbxbIHMnxuF5f+m13zoDk4tMKt/l6pyKubEdfbnlry8993KQtNCFdSu
	32IpbTuSJsG9K0xU/sYbdSed20VSjzka+NOmNvDfnN909sONNssHDvGWDk8PcfDbLlhdwaXE
	UpyRaKjFXFScCAADIlp6MAIAAA==
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
index 0dc3552d..6edf7e4 100644
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
+			return;
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

