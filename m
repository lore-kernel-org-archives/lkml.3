Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab3IBAMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:12:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:29144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab3IBAMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="395354883"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/5] mei: revamp read and write length checks
Date: Mon,  2 Sep 2013 03:11:04 +0300
Message-Id: <1378080664-7274-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
References: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Return zero on zero length read and writes
2. For a too large write return -EFBIG as defined in man write(2)
EFBIG  An attempt was made to write a file that
        exceeds the implementation-defined maximum
        file size or the process's file size limit,
        or to  write  at  a  position  past  the  maximum
        allowed offset.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 5ff810b..7404584 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -203,12 +203,18 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 
 	dev = cl->dev;
 
+
 	mutex_lock(&dev->device_lock);
 	if (dev->dev_state != MEI_DEV_ENABLED) {
 		rets = -ENODEV;
 		goto out;
 	}
 
+	if (length == 0) {
+		rets = 0;
+		goto out;
+	}
+
 	if (cl == &dev->iamthif_cl) {
 		rets = mei_amthif_read(dev, file, ubuf, length, offset);
 		goto out;
@@ -350,8 +356,14 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		rets = -ENODEV;
 		goto out;
 	}
-	if (length > dev->me_clients[id].props.max_msg_length || length <= 0) {
-		rets = -EMSGSIZE;
+
+	if (length == 0) {
+		rets = 0;
+		goto out;
+	}
+
+	if (length > dev->me_clients[id].props.max_msg_length) {
+		rets = -EFBIG;
 		goto out;
 	}
 
-- 
1.8.3.1

