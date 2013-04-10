Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022Ab3DJJMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:12:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3DJJMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:12:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130406165600.GA29660@kroah.com>
References: <20130406165600.GA29660@kroah.com>
Date: Wed, 10 Apr 2013 17:12:17 +0800
Message-ID: <CACVXFVNctGZ5hs-sBuA8MxO8NJtGkQREURiVJbFRVSO9WLO-JA@mail.gmail.com>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
From: Ming Lei <ming.lei@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 12:56 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> @@ -201,14 +206,14 @@ static int handle_create(const char *nod
>         if (IS_ERR(dentry))
>                 return PTR_ERR(dentry);
>
> -       err = vfs_mknod(path.dentry->d_inode,
> -                       dentry, mode, dev->devt);
> +       err = vfs_mknod(path.dentry->d_inode, dentry, mode, dev->devt);
>         if (!err) {
>                 struct iattr newattrs;
>
> -               /* fixup possibly umasked mode */
>                 newattrs.ia_mode = mode;
> -               newattrs.ia_valid = ATTR_MODE;
> +               newattrs.ia_uid = uid;
> +               newattrs.ia_gid = gid;

drivers/base/devtmpfs.c: In function 'handle_create':
drivers/base/devtmpfs.c:214:19: error: incompatible types when
assigning to type 'kuid_t' from type 'uid_t'
drivers/base/devtmpfs.c:215:19: error: incompatible types when
assigning to type 'kgid_t' from type 'gid_t'
make[2]: *** [drivers/base/devtmpfs.o] Error 1

Looks the below patch may fix it.
--
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index fda5256..e268fc5 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -211,8 +211,8 @@ static int handle_create(const char *nodename,
umode_t mode, uid_t uid,
 		struct iattr newattrs;

 		newattrs.ia_mode = mode;
-		newattrs.ia_uid = uid;
-		newattrs.ia_gid = gid;
+		newattrs.ia_uid = KUIDT_INIT(uid);
+		newattrs.ia_gid = KGIDT_INIT(gid);
 		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		mutex_lock(&dentry->d_inode->i_mutex);
 		notify_change(dentry, &newattrs);


Thanks,
--
Ming Lei
