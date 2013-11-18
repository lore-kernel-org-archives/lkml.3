Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3KRTIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:08:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43271 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3KRTIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:08:13 -0500
Message-ID: <528A657E.6060304@oracle.com>
Date: Mon, 18 Nov 2013 13:07:42 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
References: <528A648F.1030007@oracle.com>
In-Reply-To: <528A648F.1030007@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Here is a merge patch for resolving the conflicts in my git tree.
Of course I could rebase, but I think you prefer I didn't do that.

Thanks,
Shaggy


    Conflicts:
    	drivers/mtd/nand/nandsim.c
    	fs/btrfs/inode.c
	fs/cifs/file.c
    	fs/nfs/direct.c
    	fs/nfs/file.c
    	fs/read_write.c
    	include/linux/blk_types.h
    	mm/filemap.c

diff --cc fs/btrfs/inode.c
index da8d2f6,6feae86..1b83942
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@@ -7234,10 -7233,8 +7247,10 @@@ static ssize_t btrfs_direct_IO(int rw, 
  	 * call btrfs_wait_ordered_range to make absolutely sure that any
  	 * outstanding dirty pages are on disk.
  	 */
- 	count = iov_length(iov, nr_segs);
+ 	count = iov_iter_count(iter);
 -	btrfs_wait_ordered_range(inode, offset, count);
 +	ret = btrfs_wait_ordered_range(inode, offset, count);
 +	if (ret)
 +		return ret;
  
  	if (rw & WRITE) {
  		/*
diff --cc fs/cifs/file.c
index 5a5a872,cf6aedc..931158b
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@@ -3663,27 -3663,6 +3663,26 @@@ void cifs_oplock_break(struct work_stru
  	}
  }
  
 +/*
 + * The presence of cifs_direct_io() in the address space ops vector
 + * allowes open() O_DIRECT flags which would have failed otherwise.
 + *
 + * In the non-cached mode (mount with cache=none), we shunt off direct read and write requests
 + * so this method should never be called.
 + *
 + * Direct IO is not yet supported in the cached mode. 
 + */
 +static ssize_t
- cifs_direct_io(int rw, struct kiocb *iocb, const struct iovec *iov,
-                loff_t pos, unsigned long nr_segs)
++cifs_direct_io(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 +{
 +        /*
 +         * FIXME
 +         * Eventually need to support direct IO for non forcedirectio mounts
 +         */
 +        return -EINVAL;
 +}
 +
 +
  const struct address_space_operations cifs_addr_ops = {
  	.readpage = cifs_readpage,
  	.readpages = cifs_readpages,
diff --cc fs/nfs/direct.c
index d71d66c,239c2fe..87a6475
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@@ -117,26 -118,18 +118,17 @@@ static inline int put_dreq(struct nfs_d
   * @nr_segs: size of iovec array
   *
   * The presence of this routine in the address space ops vector means
-  * the NFS client supports direct I/O. However, for most direct IO, we
-  * shunt off direct read and write requests before the VFS gets them,
-  * so this method is only ever called for swap.
+  * the NFS client supports direct I/O. However, we shunt off direct
+  * read and write requests before the VFS gets them, so this method
+  * should never be called.
   */
- ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
+ ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+ 		      loff_t pos)
  {
- #ifndef CONFIG_NFS_SWAP
 -	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
 -			iocb->ki_filp->f_path.dentry->d_name.name,
 -			(long long) pos, iter->nr_segs);
 +	dprintk("NFS: nfs_direct_IO (%pD) off/no(%Ld/%lu) EINVAL\n",
- 			iocb->ki_filp, (long long) pos, nr_segs);
++			iocb->ki_filp, (long long) pos, iter->nr_segs);
  
  	return -EINVAL;
- #else
- 	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
- 
- 	if (rw == READ || rw == KERNEL_READ)
- 		return nfs_file_direct_read(iocb, iov, nr_segs, pos,
- 				rw == READ ? true : false);
- 	return nfs_file_direct_write(iocb, iov, nr_segs, pos,
- 				rw == WRITE ? true : false);
- #endif /* CONFIG_NFS_SWAP */
  }
  
  static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
@@@ -905,11 -1010,13 +1009,11 @@@ ssize_t nfs_file_direct_read(struct kio
  	struct address_space *mapping = file->f_mapping;
  	size_t count;
  
- 	count = iov_length(iov, nr_segs);
+ 	count = iov_iter_count(iter);
  	nfs_add_stats(mapping->host, NFSIOS_DIRECTREADBYTES, count);
  
 -	dfprintk(FILE, "NFS: direct read(%s/%s, %zd@%Ld)\n",
 -		file->f_path.dentry->d_parent->d_name.name,
 -		file->f_path.dentry->d_name.name,
 -		count, (long long) pos);
 +	dfprintk(FILE, "NFS: direct read(%pD2, %zd@%Ld)\n",
 +		file, count, (long long) pos);
  
  	retval = 0;
  	if (!count)
@@@ -959,11 -1065,13 +1062,11 @@@ ssize_t nfs_file_direct_write(struct ki
  	struct address_space *mapping = file->f_mapping;
  	size_t count;
  
- 	count = iov_length(iov, nr_segs);
+ 	count = iov_iter_count(iter);
  	nfs_add_stats(mapping->host, NFSIOS_DIRECTWRITTENBYTES, count);
  
 -	dfprintk(FILE, "NFS: direct write(%s/%s, %zd@%Ld)\n",
 -		file->f_path.dentry->d_parent->d_name.name,
 -		file->f_path.dentry->d_name.name,
 -		count, (long long) pos);
 +	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
 +		file, count, (long long) pos);
  
  	retval = generic_write_checks(file, &pos, &count, 0);
  	if (retval)
diff --cc fs/nfs/file.c
index e2fcacf,19ac4fd..e022fe9
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@@ -165,18 -174,18 +165,17 @@@ nfs_file_flush(struct file *file, fl_ow
  EXPORT_SYMBOL_GPL(nfs_file_flush);
  
  ssize_t
- nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
- 		unsigned long nr_segs, loff_t pos)
+ nfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
  {
 -	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 -	struct inode * inode = dentry->d_inode;
 +	struct inode *inode = file_inode(iocb->ki_filp);
  	ssize_t result;
  
  	if (iocb->ki_filp->f_flags & O_DIRECT)
- 		return nfs_file_direct_read(iocb, iov, nr_segs, pos, true);
+ 		return nfs_file_direct_read(iocb, iter, pos);
  
- 	dprintk("NFS: read(%pD2, %lu@%lu)\n",
 -	dprintk("NFS: read_iter(%s/%s, %lu@%lu)\n",
 -		dentry->d_parent->d_name.name, dentry->d_name.name,
++	dprintk("NFS: read_iter(%pD2, %lu@%lu)\n",
 +		iocb->ki_filp,
- 		(unsigned long) iov_length(iov, nr_segs), (unsigned long) pos);
+ 		(unsigned long) iov_iter_count(iter), (unsigned long) pos);
  
  	result = nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping);
  	if (!result) {
@@@ -634,24 -655,25 +633,24 @@@ static int nfs_need_sync_write(struct f
  	return 0;
  }
  
- ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
- 		       unsigned long nr_segs, loff_t pos)
+ ssize_t nfs_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+ 			    loff_t pos)
  {
 -	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 -	struct inode * inode = dentry->d_inode;
 +	struct file *file = iocb->ki_filp;
 +	struct inode *inode = file_inode(file);
  	unsigned long written = 0;
  	ssize_t result;
- 	size_t count = iov_length(iov, nr_segs);
+ 	size_t count = iov_iter_count(iter);
  
 -	result = nfs_key_timeout_notify(iocb->ki_filp, inode);
 +	result = nfs_key_timeout_notify(file, inode);
  	if (result)
  		return result;
  
 -	if (iocb->ki_filp->f_flags & O_DIRECT)
 +	if (file->f_flags & O_DIRECT)
- 		return nfs_file_direct_write(iocb, iov, nr_segs, pos, true);
+ 		return nfs_file_direct_write(iocb, iter, pos);
  
- 	dprintk("NFS: write(%pD2, %lu@%Ld)\n",
 -	dprintk("NFS: write_iter(%s/%s, %lu@%lld)\n",
 -		dentry->d_parent->d_name.name, dentry->d_name.name,
 -		(unsigned long) count, (long long) pos);
++	dprintk("NFS: write_iter(%pD2, %lu@%Ld)\n",
 +		file, (unsigned long) count, (long long) pos);
  
  	result = -EBUSY;
  	if (IS_SWAPFILE(inode))
diff --cc include/linux/blk_types.h
index 238ef0e,1bea25f..2c1c8c9
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@@ -176,9 -176,7 +176,8 @@@ enum rq_flag_bits 
  	__REQ_FLUSH_SEQ,	/* request for flush sequence */
  	__REQ_IO_STAT,		/* account I/O stat */
  	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
- 	__REQ_KERNEL, 		/* direct IO to kernel pages */
  	__REQ_PM,		/* runtime pm request */
 +	__REQ_END,		/* last of chain of requests */
  	__REQ_NR_BITS,		/* stops here */
  };
  
@@@ -207,29 -205,27 +206,28 @@@
  #define REQ_NOMERGE_FLAGS \
  	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
  
 -#define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 -#define REQ_THROTTLED		(1 << __REQ_THROTTLED)
 -
 -#define REQ_SORTED		(1 << __REQ_SORTED)
 -#define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
 -#define REQ_FUA			(1 << __REQ_FUA)
 -#define REQ_NOMERGE		(1 << __REQ_NOMERGE)
 -#define REQ_STARTED		(1 << __REQ_STARTED)
 -#define REQ_DONTPREP		(1 << __REQ_DONTPREP)
 -#define REQ_QUEUED		(1 << __REQ_QUEUED)
 -#define REQ_ELVPRIV		(1 << __REQ_ELVPRIV)
 -#define REQ_FAILED		(1 << __REQ_FAILED)
 -#define REQ_QUIET		(1 << __REQ_QUIET)
 -#define REQ_PREEMPT		(1 << __REQ_PREEMPT)
 -#define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 -#define REQ_COPY_USER		(1 << __REQ_COPY_USER)
 -#define REQ_FLUSH		(1 << __REQ_FLUSH)
 -#define REQ_FLUSH_SEQ		(1 << __REQ_FLUSH_SEQ)
 -#define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 -#define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 -#define REQ_SECURE		(1 << __REQ_SECURE)
 -#define REQ_PM			(1 << __REQ_PM)
 +#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 +#define REQ_THROTTLED		(1ULL << __REQ_THROTTLED)
 +
 +#define REQ_SORTED		(1ULL << __REQ_SORTED)
 +#define REQ_SOFTBARRIER		(1ULL << __REQ_SOFTBARRIER)
 +#define REQ_FUA			(1ULL << __REQ_FUA)
 +#define REQ_NOMERGE		(1ULL << __REQ_NOMERGE)
 +#define REQ_STARTED		(1ULL << __REQ_STARTED)
 +#define REQ_DONTPREP		(1ULL << __REQ_DONTPREP)
 +#define REQ_QUEUED		(1ULL << __REQ_QUEUED)
 +#define REQ_ELVPRIV		(1ULL << __REQ_ELVPRIV)
 +#define REQ_FAILED		(1ULL << __REQ_FAILED)
 +#define REQ_QUIET		(1ULL << __REQ_QUIET)
 +#define REQ_PREEMPT		(1ULL << __REQ_PREEMPT)
 +#define REQ_ALLOCED		(1ULL << __REQ_ALLOCED)
 +#define REQ_COPY_USER		(1ULL << __REQ_COPY_USER)
 +#define REQ_FLUSH		(1ULL << __REQ_FLUSH)
 +#define REQ_FLUSH_SEQ		(1ULL << __REQ_FLUSH_SEQ)
 +#define REQ_IO_STAT		(1ULL << __REQ_IO_STAT)
 +#define REQ_MIXED_MERGE		(1ULL << __REQ_MIXED_MERGE)
 +#define REQ_SECURE		(1ULL << __REQ_SECURE)
- #define REQ_KERNEL		(1ULL << __REQ_KERNEL)
 +#define REQ_PM			(1ULL << __REQ_PM)
 +#define REQ_END			(1ULL << __REQ_END)
  
  #endif /* __LINUX_BLK_TYPES_H */
diff --cc mm/filemap.c
index b7749a9,9b0b852..fc78cf2
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@@ -1199,14 -1200,13 +1199,14 @@@ page_ok
  		 * Ok, we have the page, and it's up-to-date, so
  		 * now we can copy it to user space...
  		 *
- 		 * The file_read_actor routine returns how many bytes were
 -		 * The actor routine returns how many bytes were actually used..
++		 * The file_read_iter_actor routine returns how many bytes were
 +		 * actually used..
  		 * NOTE! This may not be the same as how much of a user buffer
  		 * we filled up (we may be padding etc), so we can only update
  		 * "pos" here (the actor routine has to update the user buffer
  		 * pointers and the remaining count).
  		 */
- 		ret = file_read_actor(desc, page, offset, nr);
 -		ret = actor(desc, page, offset, nr);
++		ret = file_read_iter_actor(desc, page, offset, nr);
  		offset += ret;
  		index += offset >> PAGE_CACHE_SHIFT;
  		offset &= ~PAGE_CACHE_MASK;
@@@ -1455,39 -1426,15 +1426,15 @@@ generic_file_read_iter(struct kiocb *io
  		}
  	}
  
- 	count = retval;
- 	for (seg = 0; seg < nr_segs; seg++) {
- 		read_descriptor_t desc;
- 		loff_t offset = 0;
- 
- 		/*
- 		 * If we did a short DIO read we need to skip the section of the
- 		 * iov that we've already read data into.
- 		 */
- 		if (count) {
- 			if (count > iov[seg].iov_len) {
- 				count -= iov[seg].iov_len;
- 				continue;
- 			}
- 			offset = count;
- 			count = 0;
- 		}
- 
- 		desc.written = 0;
- 		desc.arg.buf = iov[seg].iov_base + offset;
- 		desc.count = iov[seg].iov_len - offset;
- 		if (desc.count == 0)
- 			continue;
- 		desc.error = 0;
- 		do_generic_file_read(filp, ppos, &desc);
- 		retval += desc.written;
- 		if (desc.error) {
- 			retval = retval ?: desc.error;
- 			break;
- 		}
- 		if (desc.count > 0)
- 			break;
- 	}
+ 	desc.written = 0;
+ 	desc.arg.data = iter;
+ 	desc.count = count;
+ 	desc.error = 0;
 -	do_generic_file_read(filp, ppos, &desc, file_read_iter_actor);
++	do_generic_file_read(filp, ppos, &desc);
+ 	if (desc.written)
+ 		retval = desc.written;
+ 	else
+ 		retval = desc.error;
  out:
  	return retval;
  }
