Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaJSAc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 20:32:57 -0400
Received: from mx02b.posteo.de ([89.146.230.120]:57990 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751592AbaJSAcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 20:32:55 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 3/3] lguest: force file->private_data to be NULL on open()
Date: Sun, 19 Oct 2014 02:31:00 +0200
Message-Id: <1413678660-29669-3-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1413678660-29669-1-git-send-email-martink@posteo.de>
References: <5442F3D0.3070203@posteo.de>
 <1413678660-29669-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if we depend on private_data being NULL in write() before initialize()
make sure it is NULL after open().

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---

I'm not completely sure if this patch is needed and am still investigating.
What do you think? open() could be called by the user I guess. Does
lguest_user.c depend on private_data being NULL on a first write()?


 drivers/lguest/lguest_user.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 4263f4c..30251b7 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -497,6 +497,12 @@ static int close(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int open(struct inode *inode, struct file *file)
+{
+	/* the miscdevice core sets private_data on open() */
+	file->private_data = NULL;
+}
+
 /*L:000
  * Welcome to our journey through the Launcher!
  *
@@ -514,6 +520,7 @@ static int close(struct inode *inode, struct file *file)
  */
 static const struct file_operations lguest_fops = {
 	.owner	 = THIS_MODULE,
+	.open	 = open,
 	.release = close,
 	.write	 = write,
 	.read	 = read,
-- 
1.7.10.4

