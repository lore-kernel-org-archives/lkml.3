Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3EOEEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:04:10 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34906 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3EOEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1368575992-7142-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
	<1368575992-7142-2-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 15 May 2013 13:04:08 +0900
Message-ID: <CAKYAXd__Vy0g-w1wu9csq4P_NEcDDL7+A56K=ZtYtv0oKs9_qw@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: fix the inconsistent state of data pages
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/15, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> In get_lock_data_page, if there is a data race between get_dnode_of_data
> for
> node and grab_cache_page for data, f2fs is able to face with the following
> BUG_ON(dn.data_blkaddr == NEW_ADDR).
>
> kernel BUG at /home/zeus/f2fs_test/src/fs/f2fs/data.c:251!
>  [<ffffffffa044966c>] get_lock_data_page+0x1ec/0x210 [f2fs]
> Call Trace:
>  [<ffffffffa043b089>] f2fs_readdir+0x89/0x210 [f2fs]
>  [<ffffffff811a0920>] ? fillonedir+0x100/0x100
>  [<ffffffff811a0920>] ? fillonedir+0x100/0x100
>  [<ffffffff811a07f8>] vfs_readdir+0xb8/0xe0
>  [<ffffffff811a0b4f>] sys_getdents+0x8f/0x110
>  [<ffffffff816d7999>] system_call_fastpath+0x16/0x1b
>
> This bug is able to be occurred when the block address of the data block is
> changed after f2fs_put_dnode().
> In order to avoid that, this patch fixes the lock order of node and data
> blocks in which the node block lock is covered by the data block lock.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/data.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 91ff93b..05fb5c6 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -233,18 +233,23 @@ struct page *get_lock_data_page(struct inode *inode,
> pgoff_t index)
>  	struct page *page;
>  	int err;
>
> +repeat:
> +	page = grab_cache_page(mapping, index);
> +	if (!page)
> +		return ERR_PTR(-ENOMEM);
> +
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
>  	err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
> -	if (err)
> +	if (err) {
> +		f2fs_put_page(page, 1);
>  		return ERR_PTR(err);
> +	}
>  	f2fs_put_dnode(&dn);
>
> -	if (dn.data_blkaddr == NULL_ADDR)
> +	if (dn.data_blkaddr == NULL_ADDR) {
> +		f2fs_put_page(page, 1);
>  		return ERR_PTR(-ENOENT);
> -repeat:
> -	page = grab_cache_page(mapping, index);
> -	if (!page)
> -		return ERR_PTR(-ENOMEM);
> +	}
>
>  	if (PageUptodate(page))
>  		return page;
Is there no need to move PageUptodate condition checking to
grab_cache_page next ?

Thanks.
> --
> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
