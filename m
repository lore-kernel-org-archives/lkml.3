Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaLDVIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:08:43 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59256 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaLDVIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:08:42 -0500
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Subject: [PATCH] Misc: pass miscdevice through file's private_data
Date: Thu,  4 Dec 2014 22:08:15 +0100
Message-Id: <1417727295-18989-1-git-send-email-tomvanbraeckel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place the miscdevice in the file's private_data to be used by the file operations.

Previously, this was done only when an open() operation had been registered.
But it is also useful in the other file operations, so we pass it on unconditionally.

Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
---
 drivers/char/misc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d2..c3681fb 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -140,10 +140,16 @@ static int misc_open(struct inode * inode, struct file * file)
 			goto fail;
 	}
 
+	/*
+	 * Place the miscdevice in the file's
+	 * private_data so it can be used by the
+	 * file operations, including f_op->open below
+	 */
+	file->private_data = c;
+
 	err = 0;
 	replace_fops(file, new_fops);
 	if (file->f_op->open) {
-		file->private_data = c;
 		err = file->f_op->open(inode,file);
 	}
 fail:
-- 
1.9.1

