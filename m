Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaJSAc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 20:32:58 -0400
Received: from mx02b.posteo.de ([89.146.230.120]:57988 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbaJSAcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 20:32:55 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 1/3] misc: always assign miscdevice to file->private_data in open()
Date: Sun, 19 Oct 2014 02:30:58 +0200
Message-Id: <1413678660-29669-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5442F3D0.3070203@posteo.de>
References: <5442F3D0.3070203@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now, a miscdevice driver has to provide an implementation of
the open() file operation if it wants to have misc_open() assign a
pointer to struct miscdevice to file->private_data for other file
operations to use (given the user calls open()).

This leads to situations where a miscdevice driver that doesn't need
internal operations during open() has to implement open() that only
returns immediately, in order to use the data in private_data in other
fops.

This provides consistent behaviour for miscdevice developers and will
always provide the pointer in private_data. A driver's open() fop would,
of course, just overwrite it, when using private_data itself.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---

The mentioned warning is appearently unrelated here, and happens on mainline
v3.17 awell -.- sorry for the confusion.

This applies to 3.17 and is a call for review and opinions. Especially on
the followup patches.


 drivers/char/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d2..205ad4c 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -142,8 +142,8 @@ static int misc_open(struct inode * inode, struct file * file)
 
 	err = 0;
 	replace_fops(file, new_fops);
+	file->private_data = c;
 	if (file->f_op->open) {
-		file->private_data = c;
 		err = file->f_op->open(inode,file);
 	}
 fail:
-- 
1.7.10.4

