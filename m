Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3F0Qhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:37:48 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:59217 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3F0Qhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:37:46 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <1372350404-10359-4-git-send-email-apw@canonical.com>
References: <1372350404-10359-1-git-send-email-apw@canonical.com>
	<1372350404-10359-4-git-send-email-apw@canonical.com>
Date: Thu, 27 Jun 2013 18:37:45 +0200
Message-ID: <CAJfpegsYPDi2oxt0WKHFrwYBjrk6-SNj_owghtOGxqyVVG45uQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlayfs -- follow change to do_splice_direct interface
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patches, Andy.  I already pushed a similar set of fixes
to overlayfs.current (.v18) and to .v17 for the dentry_open() refcount
fix.

On Thu, Jun 27, 2013 at 6:26 PM, Andy Whitcroft <apw@canonical.com> wrote:
> The commit below changed the interface to do_splice_direct, follow that
> change in copy_up:
>
>   commit 7995bd287134f6c8f80d94bebe7396f05a9bc42b
>   Author: Al Viro <viro@zeniv.linux.org.uk>
>   Date:   Thu Jun 20 18:58:36 2013 +0400
>
>     splice: don't pass the address of ->f_pos to methods
>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  fs/overlayfs/copy_up.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index eef85e0..8e1b09f 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -90,9 +90,10 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>
>         /* FIXME: copy up sparse files efficiently */
>         while (len) {
> -               loff_t offset = new_file->f_pos;
>                 size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
>                 long bytes;
> +               loff_t pos = old_file->f_pos;
> +               loff_t out_pos = new_file->f_pos;
>
>                 if (len < this_len)
>                         this_len = len;
> @@ -102,7 +103,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>                         break;
>                 }
>
> -               bytes = do_splice_direct(old_file, &offset, new_file, this_len,
> +               bytes = do_splice_direct(old_file, &pos, new_file, &out_pos, this_len,


It is interesting how many people end up fixing this the wrong way ;)

Hint: how will the file offsets advance?

Thanks,
Miklos
