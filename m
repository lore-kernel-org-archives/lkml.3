Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3C0NKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:10:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44313 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3C0NJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:24 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 14/17] drbd: add module_put() on error path in drbd_proc_open()
Date: Wed, 27 Mar 2013 14:08:46 +0100
Message-Id: <1364389729-17559-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

If single_open() fails in drbd_proc_open(), module refcount is left incremented.
The patch adds module_put() on the error path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
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

