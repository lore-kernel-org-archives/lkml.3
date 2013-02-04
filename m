Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3BDRYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:24:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25661 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3BDRYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:24:42 -0500
Message-ID: <510FEECA.6070106@oracle.com>
Date: Mon, 04 Feb 2013 11:24:26 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: add support for read_iter and write_iter
References: <alpine.LNX.2.00.1302032200400.7832@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302032200400.7832@eggly.anvils>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 12:15 AM, Hugh Dickins wrote:
> Convert tmpfs do_shmem_file_read() to shmem_file_read_iter().
> Make file_read_iter_actor() global so tmpfs can use it too: delete
> file_read_actor(), which was made global in 2.4.4 for use by tmpfs.
> Replace tmpfs generic_file_aio_write() by generic_file_write_iter().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> Please add this to the end of your loop O_DIRECT series.  I tested loop
> on tmpfs successfully with .direct_IO = shmem_direct_IO() { return 0; }
> but that's better left as a patch for separate discussion.

Thanks!

> Hmm, I don't see an equivalent of the old fault_in_pages_writeable():
> have I missed it, or is that a problem?

That's a good question. I think adding back fault_in_pages_writeable()
and the surrounding logic into ii_iovec_copy_to_user() would be worthwhile.

>  include/linux/fs.h |    5 ++-
>  mm/filemap.c       |   42 +----------------------------
>  mm/shmem.c         |   61 +++++++++++++------------------------------
>  3 files changed, 24 insertions(+), 84 deletions(-)
> 
> --- 3.8-dk/include/linux/fs.h	2013-01-29 14:40:40.272041622 -0800
> +++ linux/include/linux/fs.h	2013-02-02 20:40:07.316296654 -0800
> @@ -2458,8 +2458,9 @@ extern int sb_min_blocksize(struct super
>  extern int generic_file_mmap(struct file *, struct vm_area_struct *);
>  extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
>  extern int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
> -		unsigned long size, pgoff_t pgoff);
> -extern int file_read_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size);
> +				unsigned long size, pgoff_t pgoff);
> +extern int file_read_iter_actor(read_descriptor_t *desc, struct page *page,
> +				unsigned long offset, unsigned long size);
>  int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
>  extern ssize_t generic_file_aio_read(struct kiocb *, const struct iovec *, unsigned long, loff_t);
>  extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *,
> --- 3.8-dk/mm/filemap.c	2013-01-29 14:40:12.520040962 -0800
> +++ linux/mm/filemap.c	2013-02-02 20:40:17.728296902 -0800
> @@ -1295,44 +1295,6 @@ out:
>  	file_accessed(filp);
>  }
>  
> -int file_read_actor(read_descriptor_t *desc, struct page *page,
> -			unsigned long offset, unsigned long size)
> -{
> -	char *kaddr;
> -	unsigned long left, count = desc->count;
> -
> -	if (size > count)
> -		size = count;
> -
> -	/*
> -	 * Faults on the destination of a read are common, so do it before
> -	 * taking the kmap.
> -	 */
> -	if (!fault_in_pages_writeable(desc->arg.buf, size)) {
> -		kaddr = kmap_atomic(page);
> -		left = __copy_to_user_inatomic(desc->arg.buf,
> -						kaddr + offset, size);
> -		kunmap_atomic(kaddr);
> -		if (left == 0)
> -			goto success;
> -	}
> -
> -	/* Do it the slow way */
> -	kaddr = kmap(page);
> -	left = __copy_to_user(desc->arg.buf, kaddr + offset, size);
> -	kunmap(page);
> -
> -	if (left) {
> -		size -= left;
> -		desc->error = -EFAULT;
> -	}
> -success:
> -	desc->count = count - size;
> -	desc->written += size;
> -	desc->arg.buf += size;
> -	return size;
> -}
> -
>  /*
>   * Performs necessary checks before doing a write
>   * @iov:	io vector request
> @@ -1372,8 +1334,8 @@ int generic_segment_checks(const struct
>  }
>  EXPORT_SYMBOL(generic_segment_checks);
>  
> -static int file_read_iter_actor(read_descriptor_t *desc, struct page *page,
> -				unsigned long offset, unsigned long size)
> +int file_read_iter_actor(read_descriptor_t *desc, struct page *page,
> +			 unsigned long offset, unsigned long size)
>  {
>  	struct iov_iter *iter = desc->arg.data;
>  	unsigned long copied = 0;
> --- 3.8-dk/mm/shmem.c	2013-01-02 20:27:10.956550061 -0800
> +++ linux/mm/shmem.c	2013-02-03 21:21:17.332510148 -0800
> @@ -1463,14 +1463,23 @@ shmem_write_end(struct file *file, struc
>  	return copied;
>  }
>  
> -static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_t *desc, read_actor_t actor)
> +static ssize_t shmem_file_read_iter(struct kiocb *iocb,
> +				struct iov_iter *iter, loff_t pos)
>  {
> +	read_descriptor_t desc;
> +	loff_t *ppos = &iocb->ki_pos;
> +	struct file *filp = iocb->ki_filp;
>  	struct inode *inode = filp->f_path.dentry->d_inode;
>  	struct address_space *mapping = inode->i_mapping;
>  	pgoff_t index;
>  	unsigned long offset;
>  	enum sgp_type sgp = SGP_READ;
>  
> +	desc.written = 0;
> +	desc.count = iov_iter_count(iter);
> +	desc.arg.data = iter;
> +	desc.error = 0;
> +
>  	/*
>  	 * Might this read be for a stacking filesystem?  Then when reading
>  	 * holes of a sparse file, we actually need to allocate those pages,
> @@ -1497,10 +1506,10 @@ static void do_shmem_file_read(struct fi
>  				break;
>  		}
>  
> -		desc->error = shmem_getpage(inode, index, &page, sgp, NULL);
> -		if (desc->error) {
> -			if (desc->error == -EINVAL)
> -				desc->error = 0;
> +		desc.error = shmem_getpage(inode, index, &page, sgp, NULL);
> +		if (desc.error) {
> +			if (desc.error == -EINVAL)
> +				desc.error = 0;
>  			break;
>  		}
>  		if (page)
> @@ -1551,13 +1560,13 @@ static void do_shmem_file_read(struct fi
>  		 * "pos" here (the actor routine has to update the user buffer
>  		 * pointers and the remaining count).
>  		 */
> -		ret = actor(desc, page, offset, nr);
> +		ret = file_read_iter_actor(&desc, page, offset, nr);
>  		offset += ret;
>  		index += offset >> PAGE_CACHE_SHIFT;
>  		offset &= ~PAGE_CACHE_MASK;
>  
>  		page_cache_release(page);
> -		if (ret != nr || !desc->count)
> +		if (ret != nr || !desc.count)
>  			break;
>  
>  		cond_resched();
> @@ -1565,40 +1574,8 @@ static void do_shmem_file_read(struct fi
>  
>  	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
>  	file_accessed(filp);
> -}
>  
> -static ssize_t shmem_file_aio_read(struct kiocb *iocb,
> -		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
> -{
> -	struct file *filp = iocb->ki_filp;
> -	ssize_t retval;
> -	unsigned long seg;
> -	size_t count;
> -	loff_t *ppos = &iocb->ki_pos;
> -
> -	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
> -	if (retval)
> -		return retval;
> -
> -	for (seg = 0; seg < nr_segs; seg++) {
> -		read_descriptor_t desc;
> -
> -		desc.written = 0;
> -		desc.arg.buf = iov[seg].iov_base;
> -		desc.count = iov[seg].iov_len;
> -		if (desc.count == 0)
> -			continue;
> -		desc.error = 0;
> -		do_shmem_file_read(filp, ppos, &desc, file_read_actor);
> -		retval += desc.written;
> -		if (desc.error) {
> -			retval = retval ?: desc.error;
> -			break;
> -		}
> -		if (desc.count > 0)
> -			break;
> -	}
> -	return retval;
> +	return desc.written ? desc.written : desc.error;
>  }
>  
>  static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
> @@ -2679,8 +2656,8 @@ static const struct file_operations shme
>  	.llseek		= shmem_file_llseek,
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
> -	.aio_read	= shmem_file_aio_read,
> -	.aio_write	= generic_file_aio_write,
> +	.read_iter	= shmem_file_read_iter,
> +	.write_iter	= generic_file_write_iter,
>  	.fsync		= noop_fsync,
>  	.splice_read	= shmem_file_splice_read,
>  	.splice_write	= generic_file_splice_write,
> 
