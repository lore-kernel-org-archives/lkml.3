Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaJ2TZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:25:13 -0400
Received: from mx02.posteo.de ([89.146.194.165]:51619 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbaJ2TZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:25:08 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 1/3] misc: always assign miscdevice to file->private_data in open()
Date: Wed, 29 Oct 2014 20:22:56 +0100
Message-Id: <1414610578-22779-2-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414610578-22779-1-git-send-email-martink@posteo.de>
References: <1414610578-22779-1-git-send-email-martink@posteo.de>
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

