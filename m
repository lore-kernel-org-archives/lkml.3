Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbaLEEjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:39:39 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56295 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbaLEEjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:39:37 -0500
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, samu.p.onkalo@nokia.com,
        Tom Van Braeckel <tomvanbraeckel@gmail.com>
Subject: [PATCH] misc: pass miscdevice through file's private_data
Date: Fri,  5 Dec 2014 05:37:54 +0100
Message-Id: <1417754274-29769-1-git-send-email-tomvanbraeckel@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141204232951.GA13690@kroah.com>
References: <20141204232951.GA13690@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the miscdevice accessible through the file's private_data.

Previously, this was done only when an open() operation had been registered.
But it's also useful in other file operations so we pass it on unconditionally.

All drivers that use private_data and misc_register() were checked to ensure
they register an open() operation in order to verify that this improvement
does not break any existing driver that uses the misc subsystem.

Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
---
 drivers/char/misc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d2..d6445de 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -140,12 +140,17 @@ static int misc_open(struct inode * inode, struct file * file)
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
-	if (file->f_op->open) {
-		file->private_data = c;
+	if (file->f_op->open)
 		err = file->f_op->open(inode,file);
-	}
 fail:
 	mutex_unlock(&misc_mtx);
 	return err;
-- 
1.9.1

