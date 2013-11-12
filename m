Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3KLVBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:01:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:10535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab3KLVA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:00:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407682059"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 4/5] check quirk to pad epout buf size when not aligned to maxpacketsize
Date: Tue, 12 Nov 2013 13:04:45 -0800
Message-Id: <1384290286-21432-5-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index efa1152a4c15..688cfa005b4d 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -755,6 +755,7 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
 	char *data = NULL;
 	ssize_t ret;
@@ -790,7 +791,14 @@ static ssize_t ffs_epfile_io(struct file *file,
 
 	/* Allocate & copy */
 	if (!halt) {
-		data = kmalloc(len, GFP_KERNEL);
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		size_t data_len = read && gadget->quirk_ep_out_aligned_size ?
+			usb_ep_align_maxpacketsize(ep->ep, len) : len;
+
+		data = kmalloc(data_len, GFP_KERNEL);
 		if (unlikely(!data))
 			return -ENOMEM;
 
-- 
1.8.4.2

