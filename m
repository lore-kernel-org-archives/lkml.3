Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935443AbaKNXgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:36:51 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35831 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935404AbaKNXgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:36:45 -0500
From: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Alekseev <igor.alekseev@itep.ru>,
        Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
Subject: [PATCH 1/3] staging: vme: use image mutex for ioctl()
Date: Sat, 15 Nov 2014 02:36:16 +0300
Message-Id: <1416008178-9393-2-git-send-email-dmitry.kalinkin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
References: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements more granular locking in vme_user_ioctl() by using separate
locks for each devfs device.

This also provides a synchronization between vme_user_read(), vme_user_write()
and vme_user_ioctl().

Signed-off-by: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
Cc: Igor Alekseev <igor.alekseev@itep.ru>
---
 drivers/staging/vme/devices/vme_user.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 8b1f533..8731838 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -41,7 +41,6 @@
 
 #include "vme_user.h"
 
-static DEFINE_MUTEX(vme_user_mutex);
 static const char driver_name[] = "vme_user";
 
 static int bus[VME_USER_BUS_MAX];
@@ -555,10 +554,12 @@ static long
 vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
+	struct inode *inode = file_inode(file);
+	unsigned int minor = MINOR(inode->i_rdev);
 
-	mutex_lock(&vme_user_mutex);
-	ret = vme_user_ioctl(file_inode(file), file, cmd, arg);
-	mutex_unlock(&vme_user_mutex);
+	mutex_lock(&image[minor].mutex);
+	ret = vme_user_ioctl(inode, file, cmd, arg);
+	mutex_unlock(&image[minor].mutex);
 
 	return ret;
 }
-- 
1.9.1

