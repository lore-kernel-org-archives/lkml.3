Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaIPFRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:17:35 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47056 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaIPFRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140915192644.639672453@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
	<20140915192644.639672453@linuxfoundation.org>
Date: Tue, 16 Sep 2014 09:17:33 +0400
X-Google-Sender-Auth: vlPo0ruV-BQw3joIkQM0ndB_CMI
Message-ID: <CAKywueRDo_LSsnKvJVCEVngDQgnZcvLNRpT1ZPgpF=16g4QB1g@mail.gmail.com>
Subject: Re: [PATCH 3.14 103/114] CIFS: Fix directory rename error
From: Pavel Shilovsky <pshilovsky@samba.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-15 23:26 GMT+04:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Pavel Shilovsky <pshilovsky@samba.org>
>
> commit a07d322059db66b84c9eb4f98959df468e88b34b upstream.
>
> CIFS servers process nlink counts differently for files and directories.
> In cifs_rename() if we the request fails on the existing target, we
> try to remove it through cifs_unlink() but this is not what we want
> to do for directories. As the result the following sequence of commands
>
> mkdir {1,2}; mv -T 1 2; rmdir {1,2}; mkdir {1,2}; echo foo > 2/bar
>
> and XFS test generic/023 fail with -ENOENT error. That's why the second
> mkdir reuses the existing inode (target inode of the mv -T command) with
> S_DEAD flag.
>
> Fix this by checking whether the target is directory or not and
> calling cifs_rmdir() rather than cifs_unlink() for directories.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
> Signed-off-by: Steve French <smfrench@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  fs/cifs/inode.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1706,7 +1706,10 @@ cifs_rename(struct inode *source_dir, st
>  unlink_target:
>         /* Try unlinking the target dentry if it's not negative */
>         if (target_dentry->d_inode && (rc == -EACCES || rc == -EEXIST)) {
> -               tmprc = cifs_unlink(target_dir, target_dentry);
> +               if (d_is_dir(target_dentry))
> +                       tmprc = cifs_rmdir(target_dir, target_dentry);
> +               else
> +                       tmprc = cifs_unlink(target_dir, target_dentry);
>                 if (tmprc)
>                         goto cifs_rename_exit;
>                 rc = cifs_do_rename(xid, source_dentry, from_name,
>
>

Does the next stable-3.14.y have d_is_dir()? v3.14.18 doesn't compile this one.

-- 
Best regards,
Pavel Shilovsky.
