Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906Ab3FUNBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:01:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54895 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422719Ab3FUNBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:01:18 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>,
        michael.opdenacker@free-electrons.com,
        gregory.clement@free-electrons.com, maxime.ripard@free-electrons.com,
        alexandre.belloni@free-electrons.com
Subject: [PATCH] char: misc: assign file->private_data in all cases
Date: Fri, 21 Jun 2013 15:01:05 +0200
Message-Id: <1371819665-3882-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fa1f68db6ca ("drivers: misc: pass miscdevice pointer via file
private data"), the misc driver infrastructure was changed to assigned
file->private_data as a pointer to the 'struct miscdevice' that
corresponds to the device being opened.

However, this assignment was only done when the misc driver was
declaring a driver-specific ->open() operation in its
file_operations. This doesn't make sense, as the driver may not
necessarily have a custom ->open() operation, and might still be
interested in having file->private_data properly set for use in its
->read() and write() operations.

Therefore, we move the assignment of file->private_data outside of the
condition that tests whether a driver-specific ->open() operation was
defined.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/char/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 190d442..fd504d3 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -143,8 +143,8 @@ static int misc_open(struct inode * inode, struct file * file)
 	err = 0;
 	old_fops = file->f_op;
 	file->f_op = new_fops;
+	file->private_data = c;
 	if (file->f_op->open) {
-		file->private_data = c;
 		err=file->f_op->open(inode,file);
 		if (err) {
 			fops_put(file->f_op);
-- 
1.8.1.2

