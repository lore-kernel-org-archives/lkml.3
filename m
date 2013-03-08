Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab3CHXhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:37:51 -0500
Received: from [140.211.169.12] ([140.211.169.12]:51404 "EHLO
	mail.linuxfoundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933764Ab3CHXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:37:50 -0500
Date: Fri, 8 Mar 2013 15:37:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
Message-Id: <20130308153748.6ca8ed67384a328875e27bac@linux-foundation.org>
In-Reply-To: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Mar 2013 22:56:57 +0900 Namjae Jeon <linkinjeon@gmail.com> wrote:

> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Implement preallocation via the fallocate syscall on VFAT partitions.
> 
> Change Log:
> v3: Release preallocated blocks at file release.
> 
> With FALLOC_FL_KEEP_SIZE, there is no way to distinguish if the mismatch
> between i_size and no. of clusters allocated is a consequence of
> fallocate or just plain corruption. When a non fallocate aware (old)
> linux fat driver tries to write to such a file, it throws an error.
> Also, fsck detects this as inconsistency and truncates the prealloc'd blocks.
> 
> To avoid this, as suggested by OGAWA, remove changes that make fallocate
> persistent across mounts and restrict lifetime of blocks from
> fallocate(2) to file release.
> 
> v2: On an area preallocated with FALLOC_FL_KEEP_SIZE, when a seek was
> done to an offset beyond i_size, the old (garbage) data was exposed as
> we did not zero out the area at allocation time. Added
> fat_zero_falloc_area() to fix this.
> 
> v1: Reworked an earlier patch of the same name
> (https://lkml.org/lkml/2007/12/22/130) to fix some bugs:
> i)Preallocated space was not persistent and was lost on remount. Fixed
> it.
> ii)Did not zero out allocated clusters when FALLOC_FL_KEEP_SIZE was set,
> thereby speeding up preallocation time.
> 
> ...
>
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -17,8 +17,11 @@
>  #include <linux/blkdev.h>
>  #include <linux/fsnotify.h>
>  #include <linux/security.h>
> +#include <linux/falloc.h>
>  #include "fat.h"
>  
> +static long fat_fallocate(struct file *file, int mode,
> +				loff_t offset, loff_t len);
>  static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
>  {
>  	u32 attr;
> @@ -140,6 +143,12 @@ static long fat_generic_compat_ioctl(struct file *filp, unsigned int cmd,
>  
>  static int fat_file_release(struct inode *inode, struct file *filp)
>  {
> +	struct super_block *sb = inode->i_sb;
> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
> +				    ~(sb->s_blocksize-1);

Stylistically, it looks better to do

	loff_t mmu_private_ideal;

	mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
				    ~(sb->s_blocksize-1);

Note the blank line between end-of-definitions and start-of-code.  The
patch fails to do this in numerous places.

Also, I think and hope we can use round_up() here.

And we're not using i_size_read().  Probably that's OK if it is
guaranteed that fat_file_release() is always called under i_mutex, but
I might have forgotten the rules there.


> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
> +	    filp->f_dentry->d_count == 1)
> +		fat_truncate_blocks(inode, inode->i_size);

I suggest that a comment be added here.  It is unobvious why this code
is here, and what role d_count plays.

>  	if ((filp->f_mode & FMODE_WRITE) &&
>  	     MSDOS_SB(inode->i_sb)->options.flush) {
>  		fat_flush_inodes(inode->i_sb, inode, NULL);
> @@ -174,6 +183,7 @@ const struct file_operations fat_file_operations = {
>  #endif
>  	.fsync		= fat_file_fsync,
>  	.splice_read	= generic_file_splice_read,
> +	.fallocate      = fat_fallocate,
>  };
>  
>  static int fat_cont_expand(struct inode *inode, loff_t size)
> @@ -211,7 +221,78 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
>  out:
>  	return err;
>  }
> +/*
> + * preallocate space for a file. This implements fat's fallocate file
> + * operation, which gets called from sys_fallocate system call. User
> + * space requests len bytes at offset.If FALLOC_FL_KEEP_SIZE is set
> + * we just allocate clusters without zeroing them out.Otherwise we
> + * allocate and zero out clusters via an expanding truncate.

This comment is a bit lazy :( Capital letters at the start of
sentences, a space after a full stop etc, please.

> + */
> +static long fat_fallocate(struct file *file, int mode,
> +				loff_t offset, loff_t len)
> +{
> +	int err = 0;
> +	struct inode *inode = file->f_mapping->host;
> +	int cluster, nr_cluster, fclus, dclus, free_bytes, nr_bytes;

I'm rather allergic to multiple-definitions-on-one-line like this. 
They make the code harder to read and they result in messy patch resolution
efforts.  Most significantly, one-definition-per-line leaves a little
room on the right for a brief comment explaining the variable's role. 
Such comments appear to be needed in this function!

Are you sure that `int' is the best type for all these?  Do they need
to be signed?  For example nr_bytes and free_bytes are derived from
loff_t's and it is unobvious that there is no risk of overflowing.


> +	struct super_block *sb = inode->i_sb;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +
> +	/* No support for hole punch or other fallocate flags. */
> +	if (mode & ~FALLOC_FL_KEEP_SIZE)
> +		return -EOPNOTSUPP;
> +
> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
> +		fat_msg(sb, KERN_ERR,
> +			"fat_fallocate():Blocks already allocated");

Place a space after the colon.

> +		return -EINVAL;
> +	}
>  
> +	if ((mode & FALLOC_FL_KEEP_SIZE)) {

Unneeded parentheses.

> +		/* First compute the number of clusters to be allocated */
> +		if (inode->i_size > 0) {

i_size_read()?

> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
> +					      &fclus, &dclus);
> +			if (err < 0) {
> +				fat_msg(sb, KERN_ERR,
> +					"fat_fallocate():fat_get_cluster() error");

space after colon

> +				return err;
> +			}
> +			free_bytes = ((fclus+1) << sbi->cluster_bits)-

Place spaces around + and -

> +				     (inode->i_size);

More overparenthesization.

> +			nr_bytes = (offset + len - inode->i_size) - free_bytes;
> +		} else
> +			nr_bytes = (offset + len - inode->i_size);

Overparenthesization.

> +		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
> +			     sbi->cluster_bits;
> +		mutex_lock(&inode->i_mutex);

whoa, darn.  We weren't holding i_mutex?  Then yes, i_size_read() is
needed.

And this code reads i_size multiple times, while not holding any lock
which will prevent i_size from changing between those two reads.  It
seems racy.


> +		/* Start the allocation.We are not zeroing out the clusters */
> +		while (nr_cluster-- > 0) {
> +			err = fat_alloc_clusters(inode, &cluster, 1);
> +			if (err) {
> +				fat_msg(sb, KERN_ERR,
> +					"fat_fallocate():fat_alloc_clusters() error");

space after colon

> +				goto error;
> +			}
> +			err = fat_chain_add(inode, cluster, 1);
> +			if (err) {
> +				fat_free_clusters(inode, cluster);
> +				goto error;
> +			}
> +			MSDOS_I(inode)->mmu_private += sbi->cluster_size;
> +		}
> +	} else {
> +		mutex_lock(&inode->i_mutex);
> +		/* This is just an expanding truncate */
> +		err = fat_cont_expand(inode, (offset + len));

Overparenthesization.

> +		if (err) {
> +			fat_msg(sb, KERN_ERR,
> +				"fat_fallocate():fat_cont_expand() error");

space

> +		}
> +	}
> +error:
> +	mutex_unlock(&inode->i_mutex);
> +	return err;
> +}
>  /* Free all clusters after the skip'th cluster. */
>  static int fat_free(struct inode *inode, int skip)
>  {
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index dfce656..ddf2969 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -152,11 +152,58 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
>  	}
>  }
>  
> +static int fat_zero_falloc_area(struct file *file,
> +				struct address_space *mapping, loff_t pos)
> +{
> +	struct page *page;
> +	struct inode *inode = mapping->host;
> +	loff_t curpos = inode->i_size;
> +	size_t count = pos-curpos;

spaces around -

> +	int err;

Newline after end-of-locals.

> +	do {
> +		unsigned offset, bytes;
> +		void *fsdata;
> +
> +		offset = (curpos & (PAGE_CACHE_SIZE - 1));
> +		bytes = PAGE_CACHE_SIZE - offset;

OK, so use of 32-bit scalars are safe here.  They are "offset within a
page", yes?  That's unobvious from the chosen names...

> +		if (bytes > count)
> +			bytes = count;

Use min()?

> +		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
> +					AOP_FLAG_UNINTERRUPTIBLE,
> +					&page, &fsdata);
> +		if (err)
> +			break;

hm, so if we were only able to fallocate 1MB from a requested 2MB, we
don't tell userspace about this?  As far as userspace is concerned, the
whole thing failed?  Seems so...  Is there no requirement to clean up
the partial allocation on failure?

> +		zero_user(page, offset, bytes);
> +
> +		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
> +					page, fsdata);
> +		WARN_ON(err <= 0);

Why?  That could make the kernel extremely noisy if something goes
wrong.

> +		curpos += bytes;
> +		count -= bytes;
> +		err = 0;
> +	} while (count);
> +
> +	return -err;

What?  So if pagecache_write_begin() returned -ENOMEM,
fat_zero_falloc_area() will return --ENOMEM - that's +12.

> +}
> +
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

See earlier comments.

> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > inode->i_size)) {

Overparenthesization.

> +		err = fat_zero_falloc_area(file, mapping, pos);
> +		if (err)
> +			fat_msg(sb, KERN_ERR, "error zeroing fallocated area");

a) the errno should be displayed

b) why is it OK to just ignore the error and proceed?

> +	}
>  
>  	*pagep = NULL;
>  	err = cont_write_begin(file, mapping, pos, len, flags,

