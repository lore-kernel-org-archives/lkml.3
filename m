Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaLXFdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:33:00 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18635 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLXFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:32:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Dec 2014 21:27:42 -0800
From: Rohith Seelaboyina <rseelaboyina@nvidia.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <mina86@mina86.com>,
        <r.baldyga@samsung.com>, <andrzej.p@samsung.com>,
        <david.a.cohen@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rohith Seelaboyina <rseelaboyina@nvidia.com>
Subject: [PATCH] usb: gadget: ffs: Fix sparse error
Date: Wed, 24 Dec 2014 10:59:48 +0530
Message-ID: <1419398988-14576-1-git-send-email-rseelaboyina@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sparse error in functionfs
driver.

drivers/usb/gadget/function/f_fs.c:400:44: error: bad
constant experssion.

Dynamic memory allocation through kmalloc is more safer
than declaring variable array size, Fix this error by
using kmalloc for memory allocation, Check if memory
allocation is successful and return -ENOMEM on failure.

Signed-off-by: Rohith Seelaboyina <rseelaboyina@nvidia.com>
---
 drivers/usb/gadget/function/f_fs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 63314ede7ba6..6ac50891b697 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -397,10 +397,15 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
 	 * to release them.
 	 */
-	struct usb_functionfs_event events[n];
 	unsigned i = 0;
+	int ret;
+	struct usb_functionfs_event *events = kmalloc(n *
+			sizeof(struct usb_functionfs_event), GFP_KERNEL);
+
+	if (unlikely(!events))
+		return -ENOMEM;
 
-	memset(events, 0, sizeof events);
+	memset(events, 0, n * sizeof(*events));
 
 	do {
 		events[i].type = ffs->ev.types[i];
@@ -421,8 +426,10 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 	spin_unlock_irq(&ffs->ev.waitq.lock);
 	mutex_unlock(&ffs->mutex);
 
-	return unlikely(__copy_to_user(buf, events, sizeof events))
-		? -EFAULT : sizeof events;
+	ret = unlikely(__copy_to_user(buf, events, n * sizeof(*events)))
+		? -EFAULT : n * sizeof(*events);
+	kfree(events);
+	return ret;
 }
 
 static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
-- 
1.9.1

