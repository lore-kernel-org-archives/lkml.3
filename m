Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaJSAL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 20:11:59 -0400
Received: from mx02b.posteo.de ([89.146.230.120]:50729 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751544AbaJSAL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 20:11:58 -0400
Message-ID: <54430160.6020503@posteo.de>
Date: Sun, 19 Oct 2014 02:10:08 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: rusty@rustcorp.com.au
CC: lguest@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: lguest: lguest_user.c is open() called by the user?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi

Just a question for understanding: open() is not implemented in
lguest_user.c's miscdevice. The miscdevice core, in this case, does
_not_ set file->private_data on a user's open() call. Is open() called
by the user here? and do you here _depend_ on file->private_data being
NULL after open()? (could you even?)

Would the following force to NULL be necessary if the miscdevice core
_would_ set private_data?


diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 4263f4c..3d472ea 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -497,6 +497,12 @@ static int close(struct inode *inode, struct file
*file)
        return 0;
 }

+static int open(struct inode *inode, struct file *file)
+{
+       /* assuming the miscdevice core sets private_data on open() */
+       file->private_data = NULL;
+}
+
 /*L:000
  * Welcome to our journey through the Launcher!
  *
@@ -514,6 +520,7 @@ static int close(struct inode *inode, struct file *file)
  */
 static const struct file_operations lguest_fops = {
        .owner   = THIS_MODULE,
+       .open    = open,
        .release = close,
        .write   = write,
        .read    = read,
-- 

thanks
                               martin
