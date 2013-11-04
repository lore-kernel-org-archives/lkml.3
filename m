Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3KDWIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:08:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:50701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3KDWId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:08:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="429741876"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when not aligned to maxpacketsize
Date: Mon,  4 Nov 2013 14:12:56 -0800
Message-Id: <1383603177-4624-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383603177-4624-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383603177-4624-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint. ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 75e4b7846a8d..e7c3c3119552 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -755,10 +755,13 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
 	char *data = NULL;
+	size_t data_len = 0;
 	ssize_t ret;
 	int halt;
+	size_t orig_len = len;
 
 	goto first_try;
 	do {
@@ -794,11 +797,30 @@ first_try:
 			goto error;
 		}
 
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		if (gadget->quirk_ep_out_aligned_size && read) {
+			/*
+			 * We pass 'orig_len' to usp_ep_align_maxpacketsize()
+			 * due to we're in a loop and 'len' may have been
+			 * changed.
+			 */
+			len = usb_ep_align_maxpacketsize(ep->ep, orig_len);
+			if (data && len > data_len) {
+				kfree(data);
+				data = NULL;
+				data_len = 0;
+			}
+		}
+
 		/* Allocate & copy */
 		if (!halt && !data) {
 			data = kzalloc(len, GFP_KERNEL);
 			if (unlikely(!data))
 				return -ENOMEM;
+			data_len = len;
 
 			if (!read &&
 			    unlikely(__copy_from_user(data, buf, len))) {
-- 
1.8.4.rc3

