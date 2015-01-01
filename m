Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbbAASdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 13:33:35 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:34255 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbAASdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 13:33:33 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1420126692-9552-1-git-send-email-waydi1@gmail.com>
References: <1420126692-9552-1-git-send-email-waydi1@gmail.com>
Date: Thu, 1 Jan 2015 19:33:31 +0100
Message-ID: <CA+icZUWj+raXW8zBr7gmYe36EA9wuq4xN_3pC+mhhV+qiOJV7g@mail.gmail.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 4:38 PM, Seunghun Lee <waydi1@gmail.com> wrote:
> Overlayfs should be mounted read-only when upper fs is r/o or nonexistend.
> But now it can be remounted read-write and this can causes kernel panic.
> So we should prevent read-write remount when the above situation.
>

Cannot say much to the code, but you have some typos in your commit-message.
Here some corrections... wording, style etc.

...when upper-fs (with a dash) is read-only (if you write read-write
below) or nonexisten*t*...
...this can cause (without s at the end)...
...when the above situation *happens* (missing word)...

- Sedat -

> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  fs/overlayfs/super.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 84f3144..8944651 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -522,10 +522,21 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         return 0;
>  }
>
> +static int ovl_remount(struct super_block *sb, int *flags, char *data)
> +{
> +       struct ovl_fs *ufs = sb->s_fs_info;
> +
> +       if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
> +               *flags |= MS_RDONLY;
> +
> +       return 0;
> +}
> +
>  static const struct super_operations ovl_super_operations = {
>         .put_super      = ovl_put_super,
>         .statfs         = ovl_statfs,
>         .show_options   = ovl_show_options,
> +       .remount_fs     = ovl_remount,
>  };
>
>  enum {
> --
> 2.1.3
>
