Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbbAEIiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:38:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:16998 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbbAEIh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:37:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,698,1413270000"; 
   d="scan'208";a="664456559"
From: xiaomin1 <xiaoming.wang@intel.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Cc: xiaomin1 <xiaoming.wang@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>
Subject: [PATCH] move file->f_op->open out of mutex (misc_mtx) in misc_open
Date: Tue,  6 Jan 2015 08:34:07 +0800
Message-Id: <1420504447-9670-1-git-send-email-xiaoming.wang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

misc_mtx was used to mutex misc_list.
But file->f_op->open may be blocked by downloading
firmware in some devices' open.
So move file->f_op->open out of mutex (misc_mtx)
in misc_open to avoid this block.
It also make code more efficiency.

Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
---
 drivers/char/misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d2..289c59e 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -144,7 +144,8 @@ static int misc_open(struct inode * inode, struct file * file)
 	replace_fops(file, new_fops);
 	if (file->f_op->open) {
 		file->private_data = c;
-		err = file->f_op->open(inode,file);
+		mutex_unlock(&misc_mtx);
+		return file->f_op->open(inode,file);
 	}
 fail:
 	mutex_unlock(&misc_mtx);
-- 
1.7.9.5

