Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaCKMu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:50:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:59375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaCKMuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:50:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="497652308"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: report consistently copy_from/to_user failures
Date: Tue, 11 Mar 2014 14:49:25 +0200
Message-Id: <1394542165-19362-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
References: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Consistently display error on possible copy_from/to_user failures
and replace dev_dbg with dev_err

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 4 +++-
 drivers/misc/mei/main.c   | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index b75a7da..2e7d914 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -244,8 +244,10 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	 * the buf_idx may point beyond */
 	length = min_t(size_t, length, (cb->buf_idx - *offset));
 
-	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length))
+	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
+		dev_err(&dev->pdev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
+	}
 	else {
 		rets = length;
 		if ((*offset + length) < cb->buf_idx) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 4e069b8..819aa8b 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -280,6 +280,7 @@ copy_buffer:
 	length = min_t(size_t, length, cb->buf_idx - *offset);
 
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
+		dev_err(&dev->pdev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
 		goto free;
 	}
@@ -579,7 +580,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	dev_dbg(&dev->pdev->dev, "copy connect data to user\n");
 	if (copy_to_user((char __user *)data, connect_data,
 				sizeof(struct mei_connect_client_data))) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
+		dev_err(&dev->pdev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
 		goto out;
 	}
-- 
1.8.5.3

