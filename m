Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaCLLUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:20:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:11139 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbaCLLUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:20:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,637,1389772800"; 
   d="scan'208";a="496884003"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3 V2] mei: report consistently copy_from/to_user failures
Date: Wed, 12 Mar 2014 13:19:13 +0200
Message-Id: <1394623153-27046-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Consistently display error on possible copy_from/to_user failures
use dev_dbg  so it cannot be abused to flood the kernel log

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-on: https://git-isdc.jer.intel.com/gerrit/1158
---
V2: use dev_dbg instead of dev_err

 drivers/misc/mei/amthif.c | 4 +++-
 drivers/misc/mei/main.c   | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index b75a7da..2052609 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -244,8 +244,10 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	 * the buf_idx may point beyond */
 	length = min_t(size_t, length, (cb->buf_idx - *offset));
 
-	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length))
+	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
+		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
+	}
 	else {
 		rets = length;
 		if ((*offset + length) < cb->buf_idx) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 4e069b8..bc1c39e 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -280,6 +280,7 @@ copy_buffer:
 	length = min_t(size_t, length, cb->buf_idx - *offset);
 
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
+		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
 		goto free;
 	}
@@ -400,7 +401,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
 	if (rets) {
-		dev_err(&dev->pdev->dev, "failed to copy data from userland\n");
+		dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
 		rets = -EFAULT;
 		goto out;
 	}
@@ -565,7 +566,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	dev_dbg(&dev->pdev->dev, "copy connect data from user\n");
 	if (copy_from_user(connect_data, (char __user *)data,
 				sizeof(struct mei_connect_client_data))) {
-		dev_err(&dev->pdev->dev, "failed to copy data from userland\n");
+		dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
 		rets = -EFAULT;
 		goto out;
 	}
-- 
1.8.5.3

