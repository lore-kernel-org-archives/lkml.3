Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaIRStg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:49:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45933 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaIRStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:49:35 -0400
Date: Thu, 18 Sep 2014 11:48:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 2/5] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140918184823.GA10155@birch.djwong.org>
References: <cover.1410983998.git.milosz@adfin.com>
 <a5d46efa590f0d32cf209495cdb897ffadb859c5.1410983999.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d46efa590f0d32cf209495cdb897ffadb859c5.1410983999.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:20:47PM +0000, Milosz Tanski wrote:
> New syscalls with an extra flag argument. For now all flags except for 0 are
> not supported.
> 
> Signed-off-by: Milosz Tanski <milosz@adfin.com>
> ---
>  fs/read_write.c                   | 80 +++++++++++++++++++++++++++++++++------
>  include/linux/syscalls.h          | 12 ++++++
>  include/uapi/asm-generic/unistd.h | 10 ++++-
>  mm/filemap.c                      |  2 +-
>  4 files changed, 90 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 9f6d13d..3db2e87 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -864,6 +864,8 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
>  		return -EBADF;
>  	if (!(file->f_mode & FMODE_CAN_READ))
>  		return -EINVAL;
> +	if (flags & ~0)
> +		return -EINVAL;
>  
>  	return do_readv_writev(READ, file, vec, vlen, pos, flags);
>  }
> @@ -877,21 +879,23 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
>  		return -EBADF;
>  	if (!(file->f_mode & FMODE_CAN_WRITE))
>  		return -EINVAL;
> +	if (flags & ~0)
> +		return -EINVAL;
>  
>  	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
>  }
>  
>  EXPORT_SYMBOL(vfs_writev);
>  
> -SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
> -		unsigned long, vlen)
> +static ssize_t do_readv(unsigned long fd, const struct iovec __user *vec,
> +			unsigned long vlen, int flags)
>  {
>  	struct fd f = fdget_pos(fd);
>  	ssize_t ret = -EBADF;
>  
>  	if (f.file) {
>  		loff_t pos = file_pos_read(f.file);
> -		ret = vfs_readv(f.file, vec, vlen, &pos, 0);
> +		ret = vfs_readv(f.file, vec, vlen, &pos, flags);
>  		if (ret >= 0)
>  			file_pos_write(f.file, pos);
>  		fdput_pos(f);
> @@ -903,15 +907,15 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
>  	return ret;
>  }
>  
> -SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
> -		unsigned long, vlen)
> +static ssize_t do_writev(unsigned long fd, const struct iovec __user *vec,
> +			 unsigned long vlen, int flags)
>  {
>  	struct fd f = fdget_pos(fd);
>  	ssize_t ret = -EBADF;
>  
>  	if (f.file) {
>  		loff_t pos = file_pos_read(f.file);
> -		ret = vfs_writev(f.file, vec, vlen, &pos, 0);
> +		ret = vfs_writev(f.file, vec, vlen, &pos, flags);
>  		if (ret >= 0)
>  			file_pos_write(f.file, pos);
>  		fdput_pos(f);
> @@ -929,8 +933,9 @@ static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
>  	return (((loff_t)high << HALF_LONG_BITS) << HALF_LONG_BITS) | low;
>  }
>  
> -SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
> -		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
> +static ssize_t do_preadv(unsigned long fd, const struct iovec __user *vec,
> +			 unsigned long vlen, unsigned long pos_l,
> +			 unsigned long pos_h, int flags)
>  {
>  	loff_t pos = pos_from_hilo(pos_h, pos_l);
>  	struct fd f;
> @@ -943,7 +948,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
>  	if (f.file) {
>  		ret = -ESPIPE;
>  		if (f.file->f_mode & FMODE_PREAD)
> -			ret = vfs_readv(f.file, vec, vlen, &pos, 0);
> +			ret = vfs_readv(f.file, vec, vlen, &pos, flags);
>  		fdput(f);
>  	}
>  
> @@ -953,8 +958,9 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
>  	return ret;
>  }
>  
> -SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
> -		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
> +static ssize_t do_pwritev(unsigned long fd, const struct iovec __user *vec,
> +			  unsigned long vlen, unsigned long pos_l,
> +			  unsigned long pos_h, int flags)
>  {
>  	loff_t pos = pos_from_hilo(pos_h, pos_l);
>  	struct fd f;
> @@ -967,7 +973,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
>  	if (f.file) {
>  		ret = -ESPIPE;
>  		if (f.file->f_mode & FMODE_PWRITE)
> -			ret = vfs_writev(f.file, vec, vlen, &pos, 0);
> +			ret = vfs_writev(f.file, vec, vlen, &pos, flags);
>  		fdput(f);
>  	}
>  
> @@ -977,6 +983,56 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
>  	return ret;
>  }
>  
> +SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen)
> +{
> +	return do_readv(fd, vec, vlen, 0);
> +}
> +
> +SYSCALL_DEFINE4(readv2, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen, int, flags)
> +{
> +	return do_readv(fd, vec, vlen, flags);
> +}
> +
> +SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen)
> +{
> +	return do_writev(fd, vec, vlen, 0);
> +}
> +
> +SYSCALL_DEFINE4(writev2, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen, int, flags)
> +{
> +	return do_writev(fd, vec, vlen, flags);
> +}
> +
> +SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
> +{
> +	return do_preadv(fd, vec,  vlen, pos_l, pos_h, 0);
> +}
> +
> +SYSCALL_DEFINE6(preadv2, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
> +		int, flags)
> +{
> +	return do_preadv(fd, vec,  vlen, pos_l, pos_h, flags);
> +}
> +
> +SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
> +{
> +	return do_pwritev(fd, vec, vlen, pos_l, pos_h, 0);
> +}
> +
> +SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
> +		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
> +		int, flags)
> +{
> +	return do_pwritev(fd, vec, vlen, pos_l, pos_h, flags);
> +}
> +

A few months ago I was working on extending these interfaces (well, the
p{read,write}* ones and AIO) to tack on an IO extension buffer at the end of
the syscall arguments.

Hrmm, I guess I never /did/ send out a v2 after LSF.  The last time we
discussed this[1], the discussion ended with the creation of a structure that
looked something like this:

/* IO extension flags */
#define IO_EXT_PI	(1)	/* protection info (checksums, etc) */
#define IO_EXT_REPLICA	(0x2)	/* replica */
#define IO_EXT_ALL	(IO_EXT_PI | IO_EXT_REPLICA)

/* IO extension descriptor */
struct io_extension {
	__u64 ie_has;

	/* PI stuff */
	__u64 ie_pi_buf;
	__u32 ie_pi_buflen;
	__u64 ie_pi_flags;

	/* which replica do you want? */
	__u32 ie_replica;
};

Given the suggestion of avoiding an explosion of syscalls (here by stuffing all
these bits into a structure), I wonder what people think of moving 'int flags'
into this structure?  At least for the pread/pwrite variants since they already
have a lot of parameters, and for AIO whose struct iocb only has enough room
left for one pointer.

(For anyone paying attention to the original IO extension discussion: I've been
working on plumbing in the ie_replica parameter -- if your FS/blockdev/whatever
can store/fetch alternate copies of a data block, you can request a specific
copy.  Or I suppose one could interpret it as a "desperation" parameter; the
higher the number, the more extraordinary measures the storage can take to
recover data.)

--D

[1] http://article.gmane.org/gmane.linux.kernel.aio.general/3904

>  #ifdef CONFIG_COMPAT
>  
>  static ssize_t compat_do_readv_writev(int type, struct file *file,
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 0f86d85..0c49ae4 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -559,19 +559,31 @@ asmlinkage long sys_readahead(int fd, loff_t offset, size_t count);
>  asmlinkage long sys_readv(unsigned long fd,
>  			  const struct iovec __user *vec,
>  			  unsigned long vlen);
> +asmlinkage long sys_readv2(unsigned long fd,
> +			  const struct iovec __user *vec,
> +			  unsigned long vlen, int flags);
>  asmlinkage long sys_write(unsigned int fd, const char __user *buf,
>  			  size_t count);
>  asmlinkage long sys_writev(unsigned long fd,
>  			   const struct iovec __user *vec,
>  			   unsigned long vlen);
> +asmlinkage long sys_writev2(unsigned long fd,
> +			    const struct iovec __user *vec,
> +			    unsigned long vlen, int flags);
>  asmlinkage long sys_pread64(unsigned int fd, char __user *buf,
>  			    size_t count, loff_t pos);
>  asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
>  			     size_t count, loff_t pos);
>  asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
>  			   unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
> +asmlinkage long sys_preadv2(unsigned long fd, const struct iovec __user *vec,
> +			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h,
> +			    int flags);
>  asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
>  			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
> +asmlinkage long sys_pwritev2(unsigned long fd, const struct iovec __user *vec,
> +			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h,
> +			    int flags);
>  asmlinkage long sys_getcwd(char __user *buf, unsigned long size);
>  asmlinkage long sys_mkdir(const char __user *pathname, umode_t mode);
>  asmlinkage long sys_chdir(const char __user *filename);
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 11d11bc..75ad687 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -213,6 +213,14 @@ __SC_COMP(__NR_pwrite64, sys_pwrite64, compat_sys_pwrite64)
>  __SC_COMP(__NR_preadv, sys_preadv, compat_sys_preadv)
>  #define __NR_pwritev 70
>  __SC_COMP(__NR_pwritev, sys_pwritev, compat_sys_pwritev)
> +#define __NR_readv2 280
> +__SC_COMP(__NR_readv2, sys_readv2)
> +#define __NR_writev2 281
> +__SC_COMP(__NR_writev2, sys_writev2)
> +#define __NR_preadv2 282
> +__SC_COMP(__NR_preadv2, sys_preadv2)
> +#define __NR_pwritev2 283
> +__SC_COMP(__NR_pwritev2, sys_pwritev2)
>  
>  /* fs/sendfile.c */
>  #define __NR3264_sendfile 71
> @@ -707,7 +715,7 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
>  __SYSCALL(__NR_memfd_create, sys_memfd_create)
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 280
> +#define __NR_syscalls 284
>  
>  /*
>   * All syscalls below here should go away really,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6e3ba07..e0919ba 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1726,7 +1726,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  		}
>  	}
>  
> -	retval = do_generic_file_read(file, ppos, iter, retval);
> +	retval = do_generic_file_read(file, ppos, iter, retval, iocb->ki_rwflags);
>  out:
>  	return retval;
>  }
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
