Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaANVXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:23:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:47908 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaANVXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:23:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="466673310"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: export active connections to debugfs
Date: Tue, 14 Jan 2014 23:21:41 +0200
Message-Id: <1389734501-28949-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export active connection state to debugfs
The information displayed is [me,host] id pair,
client connection state, and client's read and write states

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/debugfs.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index a3ae154..ced5b77 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -75,6 +75,54 @@ static const struct file_operations mei_dbgfs_fops_meclients = {
 	.llseek = generic_file_llseek,
 };
 
+static ssize_t mei_dbgfs_read_active(struct file *fp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	struct mei_device *dev = fp->private_data;
+	struct mei_cl *cl;
+	const size_t bufsz = 1024;
+	char *buf;
+	int i = 0;
+	int pos = 0;
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if  (!buf)
+		return -ENOMEM;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"  |me|host|state|rd|wr|\n");
+
+	mutex_lock(&dev->device_lock);
+
+	/*  if the driver is not enabled the list won't b consitent */
+	if (dev->dev_state != MEI_DEV_ENABLED)
+		goto out;
+
+	list_for_each_entry(cl, &dev->file_list, link) {
+
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"%2d|%2d|%4d|%5d|%2d|%2d|\n",
+			i, cl->me_client_id, cl->host_client_id, cl->state,
+			cl->reading_state, cl->writing_state);
+		i++;
+	}
+out:
+	mutex_unlock(&dev->device_lock);
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations mei_dbgfs_fops_active = {
+	.open = simple_open,
+	.read = mei_dbgfs_read_active,
+	.llseek = generic_file_llseek,
+};
+
 static ssize_t mei_dbgfs_read_devstate(struct file *fp, char __user *ubuf,
 					size_t cnt, loff_t *ppos)
 {
@@ -128,6 +176,12 @@ int mei_dbgfs_register(struct mei_device *dev, const char *name)
 		dev_err(&dev->pdev->dev, "meclients: registration failed\n");
 		goto err;
 	}
+	f = debugfs_create_file("active", S_IRUSR, dir,
+				dev, &mei_dbgfs_fops_active);
+	if (!f) {
+		dev_err(&dev->pdev->dev, "meclients: registration failed\n");
+		goto err;
+	}
 	f = debugfs_create_file("devstate", S_IRUSR, dir,
 				dev, &mei_dbgfs_fops_devstate);
 	if (!f) {
-- 
1.8.4.2

