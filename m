Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaCDHpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:45:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:1963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbaCDHpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:45:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,583,1389772800"; 
   d="scan'208";a="493633893"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        david.a.cohen@linux.intel.com,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH v2] usb: gadget: return the right length in ffs_epfile_io()
Date: Tue,  4 Mar 2014 15:34:57 +0800
Message-Id: <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the request length is aligned to maxpacketsize, sometimes
the return length ret > the user space requested len.

At that time, we will use min_t(size_t, ret, len) to limit the
size in case of user data buffer overflow.

But we need return the min_t(size_t, ret, len) to tell the user
space rightly also.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/usb/gadget/f_fs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 42f7a0e..780f877 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			 * we may end up with more data then user space has
 			 * space for.
 			 */
-			ret = ep->status;
-			if (io_data->read && ret > 0 &&
-			    unlikely(copy_to_user(io_data->buf, data,
-						  min_t(size_t, ret,
-						  io_data->len))))
-				ret = -EFAULT;
+				ret = ep->status;
+				if (io_data->read && ret > 0) {
+					ret = min_t(size_t, ret, io_data->len);
+
+					if (unlikely(copy_to_user(io_data->buf,
+						data, ret)))
+						ret = -EFAULT;
+				}
 			}
 			kfree(data);
 		}
-- 
1.9.rc0

