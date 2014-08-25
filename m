Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbaHYVye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:54:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:11405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607AbaHYVyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299616"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/10] mei: debugfs: adjust print buffer
Date: Tue, 26 Aug 2014 00:53:22 +0300
Message-Id: <1409003608-30274-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

In case of many me clients (15 and more) 1K buffer
is not enough for full information print.
Calculate buffer size according to real clients number.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/debugfs.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index 2399b31..ca2a12d 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -29,20 +29,28 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 {
 	struct mei_device *dev = fp->private_data;
 	struct mei_me_client *me_cl;
-	const size_t bufsz = 1024;
-	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	size_t bufsz = 1;
+	char *buf;
 	int i = 0;
 	int pos = 0;
 	int ret;
 
-	if  (!buf)
-		return -ENOMEM;
-
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"  |id|addr|         UUID                       |con|msg len|\n");
+#define HDR "  |id|addr|         UUID                       |con|msg len|\n"
 
 	mutex_lock(&dev->device_lock);
 
+	list_for_each_entry(me_cl, &dev->me_clients, list)
+		bufsz++;
+
+	bufsz *= sizeof(HDR) + 1;
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		mutex_unlock(&dev->device_lock);
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, HDR);
+
 	/*  if the driver is not enabled the list won't be consistent */
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		goto out;
-- 
1.9.3

