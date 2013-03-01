Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3CAVj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:39:58 -0500
Received: from mail.ispras.ru ([83.149.199.45]:60609 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3CAVj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:39:57 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] drbd: add module_put() on error path in drbd_proc_open()
Date: Sat,  2 Mar 2013 01:39:42 +0400
Message-Id: <1362173982-26454-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If single_open() fails in drbd_proc_open(), module refcount is left incremented.
The patch adds module_put() on the error path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/block/drbd/drbd_proc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 56672a6..30fe0a5 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -313,8 +313,14 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 
 static int drbd_proc_open(struct inode *inode, struct file *file)
 {
-	if (try_module_get(THIS_MODULE))
-		return single_open(file, drbd_seq_show, PDE(inode)->data);
+	int err;
+
+	if (try_module_get(THIS_MODULE)) {
+		err = single_open(file, drbd_seq_show, PDE(inode)->data);
+		if (err)
+			module_put(THIS_MODULE);
+		return err;
+	}
 	return -ENODEV;
 }
 
-- 
1.7.9.5

