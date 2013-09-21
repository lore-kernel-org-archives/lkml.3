Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3IUIO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 04:14:26 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:54651 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3IUIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 04:14:22 -0400
X-Greylist: delayed 1839 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Sep 2013 04:14:22 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6] fat: additions to support fat_fallocate
References: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 21 Sep 2013 16:43:32 +0900
In-Reply-To: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Tue, 10 Sep 2013 23:15:52 +0900")
Message-ID: <87a9j6y5zv.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

Entirely, we would have to consider in the case of write fail
(e.g. -ENOSPC). If write failed, it will call truncate(). Then, it can
be truncate the fallocate region too unexpectedly.

> +		if (!create) {
> +			/*
> + 			 * to map cluster in case of read request
> +			 * for a block in fallocated region
> + 			 */
> +  			if (MSDOS_I(inode)->mmu_private >
> +				round_up(i_size, sb->s_blocksize))
> +				goto out_map_cluster;

->mmu_private can't stable without i_mutex. I.e. racy.

> +/*
> + * Preallocate space for a file. This implements fat's fallocate file
> + * operation, which gets called from sys_fallocate system call. User
> + * space requests len bytes at offset. If FALLOC_FL_KEEP_SIZE is set
> + * we just allocate clusters without zeroing them out. Otherwise we
> + * allocate and zero out clusters via an expanding truncate.
> + */
> +static long fat_fallocate(struct file *file, int mode,
> +				loff_t offset, loff_t len)
> +{
> +	int cluster, fclus, dclus;
> +	int nr_cluster; /* Number of clusters to be allocated */
> +	loff_t nr_bytes; /* Number of bytes to be allocated*/
> +	loff_t free_bytes; /* Unused bytes in the last cluster of file*/
> +	struct inode *inode = file->f_mapping->host;
> +	struct super_block *sb = inode->i_sb;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +	int err = 0;
> +
> +	/* No support for hole punch or other fallocate flags. */
> +	if (mode & ~FALLOC_FL_KEEP_SIZE)
> +		return -EOPNOTSUPP;

Don't we need to check S_ISREG() here? If this inode is dir, fallocate()
will break dir.

> +	mutex_lock(&inode->i_mutex);

Don't we need to check inode_newsize_ok()? It seems nobody is checking
rlimit.

> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
> +		fat_msg(sb, KERN_ERR,
> +			"fat_fallocate(): Blocks already allocated");
> +		err = -EINVAL;
> +		goto error;
> +	}

This is user error, so we should not print from kernel. Otherwise,
attacker can make flood of kernel message.

Furthermore, is this right behavior? User should care about current
fallocated size? Other FSes return -EINVAL too?

> +	if (mode & FALLOC_FL_KEEP_SIZE) {
> +		/* First compute the number of clusters to be allocated */
> +		if (inode->i_size > 0) {
> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
> +					      &fclus, &dclus);
> +			if (err < 0) {
> +				fat_msg(sb, KERN_ERR,
> +					"fat_fallocate(): fat_get_cluster() error");
> +				goto error;
> +			}
> +			free_bytes = ((fclus + 1) << sbi->cluster_bits) -
> +				     inode->i_size;
> +			nr_bytes = offset + len - inode->i_size - free_bytes;
> +			MSDOS_I(inode)->mmu_private = (fclus + 1) <<
> +						      sbi->cluster_bits;
> +		} else
> +			nr_bytes = offset + len - inode->i_size;

Hm, why do we need to re-compute ->mmu_private here?

>  static int fat_write_begin(struct file *file, struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned flags,
>  			struct page **pagep, void **fsdata)
>  {
>  	int err;
> +	struct inode *inode = mapping->host;
> +	struct super_block *sb = inode->i_sb;
> +	loff_t i_size = i_size_read(inode);
> +
> +	if (MSDOS_I(inode)->mmu_private > round_up(i_size, sb->s_blocksize)
> +			&& pos > i_size) {
> +		err = fat_zero_falloc_area(file, mapping, pos);
> +		if (err) {
> +			fat_msg(sb, KERN_ERR,
> +				"Error (%d) zeroing fallocated area", err);
> +			return err;
> +		}
> +	}

Again, I'm not fan of this way.

Normally, get_block() returns with buffer_new(). Then, caller checks
blockdev buffer with

	unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);

then, zeroed buffer. Do we really don't need to check this race?

>  static void fat_evict_inode(struct inode *inode)
>  {
> +
> +	struct super_block *sb = inode->i_sb;
> +
> +	/*
> +	 * Release unwritten fallocated blocks on file release.
> +	 * Do this only when the inode evict and i_count becomes 0.
> +	 */
> +	mutex_lock(&inode->i_mutex);
> +	if (round_up(inode->i_size, sb->s_blocksize) <
> +	    MSDOS_I(inode)->mmu_private && atomic_read(&inode->i_count) == 0)
> +		fat_truncate_blocks(inode, inode->i_size);
> +	mutex_unlock(&inode->i_mutex);

This is strange.

- inode->i_count is always 0 here.
- nobody touch this inode anymore, so no need ->i_mutex.
- no need to truncate if ->i_nlink == 0. it should be done already.

>  	truncate_inode_pages(&inode->i_data, 0);
>  	if (!inode->i_nlink) {
>  		inode->i_size = 0;

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
