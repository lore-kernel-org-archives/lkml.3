Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3J0NuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:50:17 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35326 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3J0NuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:50:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 2/5] fat: add fat_fallocate operation
References: <1381329640-11871-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 27 Oct 2013 22:50:12 +0900
In-Reply-To: <1381329640-11871-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 9 Oct 2013 23:40:40 +0900")
Message-ID: <87hac2yga3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 578a5db..2211489 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -491,6 +491,13 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
>  
>  static void fat_evict_inode(struct inode *inode)
>  {
> +	struct super_block *sb = inode->i_sb;
> +
> +	/* Release unwritten fallocated blocks on file release. */
> +	if (round_up(inode->i_size, sb->s_blocksize) <
> +	    MSDOS_I(inode)->i_disksize && inode->i_nlink != 0)
> +		fat_truncate_blocks(inode, inode->i_size);
> +
>  	truncate_inode_pages(&inode->i_data, 0);
>  	if (!inode->i_nlink) {
>  		inode->i_size = 0;

This would be better to move after truncate_inode_pages(). And as part
of "else".

	if (!inode->i_nlink) {
        	...
        } else {
        	/* here */
        }

And inode->i_size should be ->mmu_private?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
