Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaI2NjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:39:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:2354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaI2Ncs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029936"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 02/18] mei: debugfs: adjust print buffer
Date: Mon, 29 Sep 2014 16:31:34 +0300
Message-Id: <1411997510-29094-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
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

