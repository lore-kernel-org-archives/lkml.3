Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3CKJnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:43:21 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63357 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3CKJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130308153748.6ca8ed67384a328875e27bac@linux-foundation.org>
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
	<20130308153748.6ca8ed67384a328875e27bac@linux-foundation.org>
Date: Mon, 11 Mar 2013 18:43:18 +0900
Message-ID: <CAKYAXd_mpZo9F8xX0FAm7qKqmVj3U+CsVO_tzDLWispkEuLgFg@mail.gmail.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hirofumi@mail.parknet.co.jp, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Andrew.
>>
>>  static int fat_file_release(struct inode *inode, struct file *filp)
>>  {
>> +	struct super_block *sb = inode->i_sb;
>> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
>> +				    ~(sb->s_blocksize-1);
>
> Stylistically, it looks better to do
>
> 	loff_t mmu_private_ideal;
>
> 	mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
> 				    ~(sb->s_blocksize-1);
Agreed. I will fix this.
>
> Note the blank line between end-of-definitions and start-of-code.  The
> patch fails to do this in numerous places.
Okay. I will.

>
> Also, I think and hope we can use round_up() here.
Okay, I will.
>
> And we're not using i_size_read().  Probably that's OK if it is
> guaranteed that fat_file_release() is always called under i_mutex, but
> I might have forgotten the rules there.
Okay, I will fix it.

>
>
>> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
>> +	    filp->f_dentry->d_count == 1)
>> +		fat_truncate_blocks(inode, inode->i_size);
>
> I suggest that a comment be added here.  It is unobvious why this code
> is here, and what role d_count plays.
Ok. This is the code which releases prealloced (and not yet written
to) area when file is released.
The d_count check ensures release happens only when the last file
descriptor for that file is closed.
I will add a comment on next version patch.
>
>>  	if ((filp->f_mode & FMODE_WRITE) &&
>>  	     MSDOS_SB(inode->i_sb)->options.flush) {
>>  		fat_flush_inodes(inode->i_sb, inode, NULL);
>> @@ -174,6 +183,7 @@ const struct file_operations fat_file_operations = {
>>  #endif
>>  	.fsync		= fat_file_fsync,
>>  	.splice_read	= generic_file_splice_read,
>> +	.fallocate      = fat_fallocate,
>>  };
>>
>>  static int fat_cont_expand(struct inode *inode, loff_t size)
>> @@ -211,7 +221,78 @@ static int fat_cont_expand(struct inode *inode,
>> loff_t size)
>>  out:
>>  	return err;
>>  }
>> +/*
>> + * preallocate space for a file. This implements fat's fallocate file
>> + * operation, which gets called from sys_fallocate system call. User
>> + * space requests len bytes at offset.If FALLOC_FL_KEEP_SIZE is set
>> + * we just allocate clusters without zeroing them out.Otherwise we
>> + * allocate and zero out clusters via an expanding truncate.
>
> This comment is a bit lazy :( Capital letters at the start of
> sentences, a space after a full stop etc, please.
Okay!

>
>> + */
>> +static long fat_fallocate(struct file *file, int mode,
>> +				loff_t offset, loff_t len)
>> +{
>> +	int err = 0;
>> +	struct inode *inode = file->f_mapping->host;
>> +	int cluster, nr_cluster, fclus, dclus, free_bytes, nr_bytes;
>
> I'm rather allergic to multiple-definitions-on-one-line like this.
> They make the code harder to read and they result in messy patch resolution
> efforts.  Most significantly, one-definition-per-line leaves a little
> room on the right for a brief comment explaining the variable's role.
> Such comments appear to be needed in this function!
Okay, I will add detailed comments.

>
> Are you sure that `int' is the best type for all these?  Do they need
> to be signed?  For example nr_bytes and free_bytes are derived from
> loff_t's and it is unobvious that there is no risk of overflowing.
Yes, right. I will change free_bytes and nr_bytes to loff_t.

>
>
>> +	struct super_block *sb = inode->i_sb;
>> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> +
>> +	/* No support for hole punch or other fallocate flags. */
>> +	if (mode & ~FALLOC_FL_KEEP_SIZE)
>> +		return -EOPNOTSUPP;
>> +
>> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
>> +		fat_msg(sb, KERN_ERR,
>> +			"fat_fallocate():Blocks already allocated");
>
> Place a space after the colon.
Okay, Thanks.

>
>> +		return -EINVAL;
>> +	}
>>
>> +	if ((mode & FALLOC_FL_KEEP_SIZE)) {
>
> Unneeded parentheses.
Okay.

>
>> +		/* First compute the number of clusters to be allocated */
>> +		if (inode->i_size > 0) {
>
> i_size_read()?
Okay, I will change it.

>
>> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
>> +					      &fclus, &dclus);
>> +			if (err < 0) {
>> +				fat_msg(sb, KERN_ERR,
>> +					"fat_fallocate():fat_get_cluster() error");
>
> space after colon
Okay. I will add a space after colon.

>
>> +				return err;
>> +			}
>> +			free_bytes = ((fclus+1) << sbi->cluster_bits)-
>
> Place spaces around + and -
Okay, I will fix it.

>
>> +				     (inode->i_size);
>
> More overparenthesization.
Okay, I will.

>
>> +			nr_bytes = (offset + len - inode->i_size) - free_bytes;
>> +		} else
>> +			nr_bytes = (offset + len - inode->i_size);
>
> Overparenthesization.
Okay.

>
>> +		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
>> +			     sbi->cluster_bits;
>> +		mutex_lock(&inode->i_mutex);
>
> whoa, darn.  We weren't holding i_mutex?  Then yes, i_size_read() is
> needed.
Yes, right. I will fix it.

>
> And this code reads i_size multiple times, while not holding any lock
> which will prevent i_size from changing between those two reads.  It
> seems racy.
Right,  I will fix it.

>
>
>> +		/* Start the allocation.We are not zeroing out the clusters */
>> +		while (nr_cluster-- > 0) {
>> +			err = fat_alloc_clusters(inode, &cluster, 1);
>> +			if (err) {
>> +				fat_msg(sb, KERN_ERR,
>> +					"fat_fallocate():fat_alloc_clusters() error");
>
> space after colon
Okay!

>
>> +				goto error;
>> +			}
>> +			err = fat_chain_add(inode, cluster, 1);
>> +			if (err) {
>> +				fat_free_clusters(inode, cluster);
>> +				goto error;
>> +			}
>> +			MSDOS_I(inode)->mmu_private += sbi->cluster_size;
>> +		}
>> +	} else {
>> +		mutex_lock(&inode->i_mutex);
>> +		/* This is just an expanding truncate */
>> +		err = fat_cont_expand(inode, (offset + len));
>
> Overparenthesization.
Okay!

>
>> +		if (err) {
>> +			fat_msg(sb, KERN_ERR,
>> +				"fat_fallocate():fat_cont_expand() error");
>
> space
Okay!

>
>> +		}
>> +	}
>> +error:
>> +	mutex_unlock(&inode->i_mutex);
>> +	return err;
>> +}
>>  /* Free all clusters after the skip'th cluster. */
>>  static int fat_free(struct inode *inode, int skip)
>>  {
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index dfce656..ddf2969 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -152,11 +152,58 @@ static void fat_write_failed(struct address_space
>> *mapping, loff_t to)
>>  	}
>>  }
>>
>> +static int fat_zero_falloc_area(struct file *file,
>> +				struct address_space *mapping, loff_t pos)
>> +{
>> +	struct page *page;
>> +	struct inode *inode = mapping->host;
>> +	loff_t curpos = inode->i_size;
>> +	size_t count = pos-curpos;
>
> spaces around -
Okay, I will add it.

>
>> +	int err;
>
> Newline after end-of-locals.
Okay.

>
>> +	do {
>> +		unsigned offset, bytes;
>> +		void *fsdata;
>> +
>> +		offset = (curpos & (PAGE_CACHE_SIZE - 1));
>> +		bytes = PAGE_CACHE_SIZE - offset;
>
> OK, so use of 32-bit scalars are safe here.  They are "offset within a
> page", yes?  That's unobvious from the chosen names...
Yes, I will fix it.

>
>> +		if (bytes > count)
>> +			bytes = count;
>
> Use min()?
Okay. I will use it.

>
>> +		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
>> +					AOP_FLAG_UNINTERRUPTIBLE,
>> +					&page, &fsdata);
>> +		if (err)
>> +			break;
>
> hm, so if we were only able to fallocate 1MB from a requested 2MB, we
> don't tell userspace about this?  As far as userspace is concerned, the
> whole thing failed?  Seems so...  Is there no requirement to clean up
> the partial allocation on failure?
Other filesystem like EXT4 do not release partial allocation. we
verified this by fallocating 300MB on a 256MB EXT4 partition.
So I followed the same.
>
>> +		zero_user(page, offset, bytes);
>> +
>> +		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
>> +					page, fsdata);
>> +		WARN_ON(err <= 0);
>
> Why?  That could make the kernel extremely noisy if something goes
> wrong.
Yes, There was a mistake. I will fix it.

>
>> +		curpos += bytes;
>> +		count -= bytes;
>> +		err = 0;
>> +	} while (count);
>> +
>> +	return -err;
>
> What?  So if pagecache_write_begin() returned -ENOMEM,
> fat_zero_falloc_area() will return --ENOMEM - that's +12.
I had literally used the xfs_iozero() function which does these same
things and will fix it.

>
>> +}
>> +
>>  static int fat_write_begin(struct file *file, struct address_space
>> *mapping,
>>  			loff_t pos, unsigned len, unsigned flags,
>>  			struct page **pagep, void **fsdata)
>>  {
>>  	int err;
>> +	struct inode *inode = mapping->host;
>> +	struct super_block *sb = inode->i_sb;
>> +	loff_t mmu_private_actual = MSDOS_I(inode)->mmu_private;
>> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
>> +					 ~(sb->s_blocksize-1);
>
> See earlier comments.
Okay.

>
>> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > inode->i_size))
>> {
>
> Overparenthesization.
Okay.

>
>> +		err = fat_zero_falloc_area(file, mapping, pos);
>> +		if (err)
>> +			fat_msg(sb, KERN_ERR, "error zeroing fallocated area");
>
> a) the errno should be displayed
Yes, I will add it.
>
> b) why is it OK to just ignore the error and proceed?
Right, we should not proceed and return the error values.

I will post the next v2 patch after fixing totally.
Thanks for your review!
>
>> +	}
>>
>>  	*pagep = NULL;
>>  	err = cont_write_begin(file, mapping, pos, len, flags,
>
>
