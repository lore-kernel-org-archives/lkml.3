Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaLDXBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:01:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65261 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbaLDXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:01:13 -0500
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tom Van Braeckel <tomvanbraeckel@gmail.com>
Subject: Re: [PATCH] Misc: pass miscdevice through file's private_data
Date: Fri,  5 Dec 2014 00:01:03 +0100
Message-Id: <1417734063-28489-1-git-send-email-tomvanbraeckel@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141204211342.GA22293@kroah.com>
References: <20141204211342.GA22293@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > +	/*
> > +	 * Place the miscdevice in the file's
> > +	 * private_data so it can be used by the
> > +	 * file operations, including f_op->open below
> > +	 */
> > +	file->private_data = c;
> > +
> >  	err = 0;
> >  	replace_fops(file, new_fops);
> >  	if (file->f_op->open) {
> > -		file->private_data = c;
> >  		err = file->f_op->open(inode,file);
> >  	}
>
> These braces aren't needed anymore, right?
>
> Also, what is this now going to break?  :)
> 
> thanks,
> 
> greg k-h

Thanks for the fast feedback!

Good point, so I made a list of all drivers that use private_data (find drivers/ -iname "*.c" -exec grep -l private_data {} \;  | sort -u) and manually verified that all of them either register an open() operation, do not use the misc subsystem, or matched because of vm_private_data.

>From this investigation, I conclude that it does not break anything.

I also removed the unnecessary curly braces. Please find the new patch below.


misc: pass miscdevice through file's private_data

Place the miscdevice in the file's private_data to be used by the file operations.

Previously, this was done only when an open() operation had been registered.
But it is also useful in the other file operations, so we pass it on unconditionally.

All drivers that use private_data and misc_register() were checked to ensure they register an open() operation,
in order to verify that this improvement does not break any existing driver that uses the misc subsystem.

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

