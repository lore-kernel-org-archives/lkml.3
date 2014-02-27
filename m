Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaB0G71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:59:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:10047 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaB0G70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:59:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,552,1389772800"; 
   d="scan'208";a="482716448"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, mina86@mina86.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@intel.com, jin.can.zhuang@intel.com, yu.y.wang@intel.com,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
Date: Thu, 27 Feb 2014 14:49:31 +0800
Message-Id: <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
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

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/usb/gadget/f_fs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 2b43343..31ee7af 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -687,10 +687,12 @@ static ssize_t ffs_epfile_io(struct file *file,
 			 * space for.
 			 */
 			ret = ep->status;
-			if (read && ret > 0 &&
-			    unlikely(copy_to_user(buf, data,
-						  min_t(size_t, ret, len))))
-				ret = -EFAULT;
+			if (read && ret > 0) {
+				ret = min_t(size_t, ret, len);
+
+				if (unlikely(copy_to_user(buf, data, ret)))
+					ret = -EFAULT;
+			}
 		}
 	}
 
-- 
1.9.rc0

