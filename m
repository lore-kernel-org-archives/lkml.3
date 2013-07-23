Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab3GWVOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:14:04 -0400
Received: from dupo.coraid.com ([208.71.232.133]:57424 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751386Ab3GWVOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:14:03 -0400
Message-Id: <7dfdc10b3114b276d621bda96ff21534142e63e1.1374610591.git.ecashin@coraid.com>
In-Reply-To: <cover.1374610591.git.ecashin@coraid.com>
References: <cover.1374610591.git.ecashin@coraid.com>
Subject: [PATCH 3/6] aoe: provide file operations for debugfs files
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 23 Jul 2013 17:13:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The place holder in the file contents is filled out in the
following patch.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index d76c5cb..0511d38 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -110,6 +110,24 @@ static ssize_t aoedisk_show_payload(struct device *dev,
 	return snprintf(page, PAGE_SIZE, "%lu\n", d->maxbcnt);
 }
 
+static int aoedisk_debugfs_show(struct seq_file *s, void *ignored)
+{
+	struct aoedev *d;
+	unsigned long flags;
+
+	d = s->private;
+	spin_lock_irqsave(&d->lock, flags);
+	seq_printf(s, "%s\n", d->gd->disk_name); /* place holder */
+	spin_unlock_irqrestore(&d->lock, flags);
+
+	return 0;
+}
+
+static int aoe_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, aoedisk_debugfs_show, inode->i_private);
+}
+
 static DEVICE_ATTR(state, S_IRUGO, aoedisk_show_state, NULL);
 static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
 static DEVICE_ATTR(netif, S_IRUGO, aoedisk_show_netif, NULL);
@@ -132,7 +150,12 @@ static const struct attribute_group attr_group = {
 	.attrs = aoe_attrs,
 };
 
-static const struct file_operations aoe_debugfs_fops;
+static const struct file_operations aoe_debugfs_fops = {
+	.open = aoe_debugfs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
 
 static void
 aoedisk_add_debugfs(struct aoedev *d)
-- 
1.7.1

