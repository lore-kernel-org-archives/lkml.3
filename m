Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3I3L2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:28:24 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40510 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3I3L2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:28:14 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the vfs tree
Date: Mon, 30 Sep 2013 13:26:12 +0200
Message-Id: <1380540373-25352-10-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the vfs tree got conflicts in

	fs/nfs/direct.c
	fs/nfs/file.c

I fixed them up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc fs/nfs/direct.c
index 239c2fe,d71d66c..e83817c
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@@ -118,18 -117,26 +118,17 @@@ static inline int put_dreq(struct nfs_d
   * @nr_segs: size of iovec array
   *
   * The presence of this routine in the address space ops vector means
 - * the NFS client supports direct I/O. However, for most direct IO, we
 - * shunt off direct read and write requests before the VFS gets them,
 - * so this method is only ever called for swap.
 + * the NFS client supports direct I/O. However, we shunt off direct
 + * read and write requests before the VFS gets them, so this method
 + * should never be called.
   */
 -ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
 +ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 +		      loff_t pos)
  {
- 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
- 			iocb->ki_filp->f_path.dentry->d_name.name,
- 			(long long) pos, iter->nr_segs);
 -#ifndef CONFIG_NFS_SWAP
+ 	dprintk("NFS: nfs_direct_IO (%pD) off/no(%Ld/%lu) EINVAL\n",
+ 			iocb->ki_filp, (long long) pos, nr_segs);
  
  	return -EINVAL;
 -#else
 -	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
 -
 -	if (rw == READ || rw == KERNEL_READ)
 -		return nfs_file_direct_read(iocb, iov, nr_segs, pos,
 -				rw == READ ? true : false);
 -	return nfs_file_direct_write(iocb, iov, nr_segs, pos,
 -				rw == WRITE ? true : false);
 -#endif /* CONFIG_NFS_SWAP */
  }
  
  static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
@@@ -1010,13 -905,11 +1009,11 @@@ ssize_t nfs_file_direct_read(struct kio
  	struct address_space *mapping = file->f_mapping;
  	size_t count;
  
 -	count = iov_length(iov, nr_segs);
 +	count = iov_iter_count(iter);
  	nfs_add_stats(mapping->host, NFSIOS_DIRECTREADBYTES, count);
  
- 	dfprintk(FILE, "NFS: direct read(%s/%s, %zd@%Ld)\n",
- 		file->f_path.dentry->d_parent->d_name.name,
- 		file->f_path.dentry->d_name.name,
- 		count, (long long) pos);
+ 	dfprintk(FILE, "NFS: direct read(%pD2, %zd@%Ld)\n",
+ 		file, count, (long long) pos);
  
  	retval = 0;
  	if (!count)
@@@ -1065,13 -959,11 +1062,11 @@@ ssize_t nfs_file_direct_write(struct ki
  	struct address_space *mapping = file->f_mapping;
  	size_t count;
  
 -	count = iov_length(iov, nr_segs);
 +	count = iov_iter_count(iter);
  	nfs_add_stats(mapping->host, NFSIOS_DIRECTWRITTENBYTES, count);
  
- 	dfprintk(FILE, "NFS: direct write(%s/%s, %zd@%Ld)\n",
- 		file->f_path.dentry->d_parent->d_name.name,
- 		file->f_path.dentry->d_name.name,
- 		count, (long long) pos);
+ 	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
+ 		file, count, (long long) pos);
  
  	retval = generic_write_checks(file, &pos, &count, 0);
  	if (retval)
diff --cc fs/nfs/file.c
index 19ac4fd,e2fcacf..cb66d5f
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@@ -174,18 -165,18 +165,17 @@@ nfs_file_flush(struct file *file, fl_ow
  EXPORT_SYMBOL_GPL(nfs_file_flush);
  
  ssize_t
 -nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 -		unsigned long nr_segs, loff_t pos)
 +nfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
  {
- 	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
- 	struct inode * inode = dentry->d_inode;
+ 	struct inode *inode = file_inode(iocb->ki_filp);
  	ssize_t result;
  
  	if (iocb->ki_filp->f_flags & O_DIRECT)
 -		return nfs_file_direct_read(iocb, iov, nr_segs, pos, true);
 +		return nfs_file_direct_read(iocb, iter, pos);
  
- 	dprintk("NFS: read_iter(%s/%s, %lu@%lu)\n",
- 		dentry->d_parent->d_name.name, dentry->d_name.name,
- 		(unsigned long) iov_iter_count(iter), (unsigned long) pos);
 -	dprintk("NFS: read(%pD2, %lu@%lu)\n",
++	dprintk("NFS: read_iter(%pD2, %lu@%lu)\n",
+ 		iocb->ki_filp,
+ 		(unsigned long) iov_length(iov, nr_segs), (unsigned long) pos);
  
  	result = nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping);
  	if (!result) {
@@@ -655,25 -634,24 +633,24 @@@ static int nfs_need_sync_write(struct f
  	return 0;
  }
  
 -ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
 -		       unsigned long nr_segs, loff_t pos)
 +ssize_t nfs_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
 +			    loff_t pos)
  {
- 	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
- 	struct inode * inode = dentry->d_inode;
+ 	struct file *file = iocb->ki_filp;
+ 	struct inode *inode = file_inode(file);
  	unsigned long written = 0;
  	ssize_t result;
 -	size_t count = iov_length(iov, nr_segs);
 +	size_t count = iov_iter_count(iter);
  
- 	result = nfs_key_timeout_notify(iocb->ki_filp, inode);
+ 	result = nfs_key_timeout_notify(file, inode);
  	if (result)
  		return result;
  
- 	if (iocb->ki_filp->f_flags & O_DIRECT)
+ 	if (file->f_flags & O_DIRECT)
 -		return nfs_file_direct_write(iocb, iov, nr_segs, pos, true);
 +		return nfs_file_direct_write(iocb, iter, pos);
  
- 	dprintk("NFS: write_iter(%s/%s, %lu@%lld)\n",
- 		dentry->d_parent->d_name.name, dentry->d_name.name,
- 		(unsigned long) count, (long long) pos);
 -	dprintk("NFS: write(%pD2, %lu@%Ld)\n",
++	dprintk("NFS: write_iter(%pD2, %lu@%Ld)\n",
+ 		file, (unsigned long) count, (long long) pos);
  
  	result = -EBUSY;
  	if (IS_SWAPFILE(inode))
