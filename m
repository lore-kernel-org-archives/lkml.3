Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab3CIOSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 09:18:12 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45298 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3CIOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 09:18:10 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 09 Mar 2013 23:18:05 +0900
In-Reply-To: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Thu, 7 Mar 2013 22:56:57 +0900")
Message-ID: <87sj44ac82.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>  static int fat_file_release(struct inode *inode, struct file *filp)
>  {
> +	struct super_block *sb = inode->i_sb;
> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
> +				    ~(sb->s_blocksize-1);
> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
> +	    filp->f_dentry->d_count == 1)
> +		fat_truncate_blocks(inode, inode->i_size);

Without locking, truncate is racy.

This choose ->release(). BTW, we would also be able to do this only
->evict_inode(), although I'm not thinking yet which one is better.

If you had conclusion, it would be nice to explain it.

> +static long fat_fallocate(struct file *file, int mode,
> +				loff_t offset, loff_t len)
> +{
>
> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
> +		fat_msg(sb, KERN_ERR,
> +			"fat_fallocate():Blocks already allocated");
> +		return -EINVAL;
> +	}

Also this looks like totally racy.

>  static int fat_write_begin(struct file *file, struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned flags,
>  			struct page **pagep, void **fsdata)
>  {
>  	int err;
> +	struct inode *inode = mapping->host;
> +	struct super_block *sb = inode->i_sb;
> +	loff_t mmu_private_actual = MSDOS_I(inode)->mmu_private;
> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
> +					 ~(sb->s_blocksize-1);
> +
> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > inode->i_size)) {
> +		err = fat_zero_falloc_area(file, mapping, pos);
> +		if (err)
> +			fat_msg(sb, KERN_ERR, "error zeroing fallocated area");
> +	}
>  
>  	*pagep = NULL;
>  	err = cont_write_begin(file, mapping, pos, len, flags,

Hm, only write_begin is enough to handle mmap, truncate, and etc.?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
