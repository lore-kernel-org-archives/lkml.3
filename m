Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaJHIuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:50:07 -0400
Received: from mx02.posteo.de ([89.146.194.165]:53596 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbaJHIuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:50:01 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] misc: always assign miscdevice to file->private_data in open()
Date: Wed,  8 Oct 2014 10:47:54 +0200
Message-Id: <1412758074-7882-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
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

This change provides consistent behaviour for miscdevice developers by
always providing the pointer in private_data. A driver's open() fop would,
of course, just overwrite it, when using private_data itself.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
This is really only a question: Do I understand this correctly, and,
could this change then hurt any existing driver?
As a driver developer it took me a while to figure out what happens here,
and in my situation it would have been nice to just have this feature as
part of the miscdevice API. Possibly documented somewhere?

misc_open() is called in any case, on open(). As long as miscdevice drivers
don't explicitly rely on private_data being NULL exactly IF they don't
implement an open() fop (which I wouldn't imagine), this would make things
even more convenient.

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

