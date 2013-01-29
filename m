Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3A2WTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:19:43 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:49066 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3A2WTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:19:41 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130125182242.10037.3237.stgit@maximpc.sw.ru>
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
	<20130125182242.10037.3237.stgit@maximpc.sw.ru>
Date: Tue, 29 Jan 2013 23:19:40 +0100
Message-ID: <CAJfpegtszx6cDJ9fUPTB_z-1vG7iM8J1jdKuEdqN+wPFkOf6NQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] fuse: Update i_mtime on buffered writes
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 7:24 PM, Maxim V. Patlasov
<MPatlasov@parallels.com> wrote:
> If writeback cache is on, buffered write doesn't result in immediate mtime
> update in userspace because the userspace will see modified data later, when
> writeback happens. Consequently, mtime provided by userspace may be older than
> actual time of buffered write.
>
> The problem can be solved by generating mtime locally (will come in next
> patches) and flushing it to userspace periodically. Here we introduce a flag to
> keep the state of fuse_inode: the flag is ON if and only if locally generated
> mtime (stored in inode->i_mtime) was not pushed to the userspace yet.
>
> The patch also implements all bits related to flushing and clearing the flag.
>
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> ---
>  fs/fuse/dir.c    |   42 +++++++++++++++++++++++++----
>  fs/fuse/file.c   |   31 ++++++++++++++++++---
>  fs/fuse/fuse_i.h |   13 ++++++++-
>  fs/fuse/inode.c  |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 154 insertions(+), 11 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index ff8b603..969c60d 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -177,6 +177,13 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
>                 if (flags & LOOKUP_RCU)
>                         return -ECHILD;
>
> +               if (test_bit(FUSE_I_MTIME_UPDATED,
> +                            &get_fuse_inode(inode)->state)) {
> +                       err = fuse_flush_mtime(inode, 0);

->d_revalidate may be called with or without i_mutex, there's
absolutely no way to know.  So this won't work.

I know it was me who suggested this approach, but I have second
thoughts...  I really don't like the way this mixes userspace and
kernel updates to mtime.  I think it should be either one or the
other.

I don't think you need to much changes to this patch.  Just clear
S_NOCMTIME, implement i_op->update_time(), which sets the
FUSE_I_MTIME_UPDATED flag and flush mtime just like you do now.
Except now it doesn't need to take i_mutex since all mtime updates are
now done by the kernel.

Does that make sense?

Thanks,
Miklos
