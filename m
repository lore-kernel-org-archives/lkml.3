Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3J3REA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:04:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:49116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab3J3RCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401080727"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, Paul.Zimmerman@synopsys.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v3 2/3] usb: ffs: check quirk to pad epout buf size when not aligned to maxpacketsize
Date: Wed, 30 Oct 2013 10:06:17 -0700
Message-Id: <1383152778-30739-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint. ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 75e4b78..b49dd55 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -755,10 +755,12 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
 	char *data = NULL;
 	ssize_t ret;
 	int halt;
+	size_t orig_len = len;
 
 	goto first_try;
 	do {
@@ -794,6 +796,21 @@ first_try:
 			goto error;
 		}
 
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		if (gadget->quirk_ep_out_aligned_size && read &&
+		    !IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize)) {
+			size_t old_len = len;
+			len = roundup(orig_len,
+				      (size_t)ep->ep->desc->wMaxPacketSize);
+			if (unlikely(data) && len > old_len) {
+				kfree(data);
+				data = NULL;
+			}
+		}
+
 		/* Allocate & copy */
 		if (!halt && !data) {
 			data = kzalloc(len, GFP_KERNEL);
-- 
1.8.4.rc3

