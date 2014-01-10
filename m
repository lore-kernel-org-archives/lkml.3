Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaAJOBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:01:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaAJOBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:01:36 -0500
Message-ID: <52CFFD1C.7050005@oracle.com>
Date: Fri, 10 Jan 2014 22:01:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [xfs] c91c46c12: xfstests generic/313 regression
References: <20140110122700.GA12624@localhost> <52CFF402.5080409@oracle.com> <20140110133306.GA22918@infradead.org>
In-Reply-To: <20140110133306.GA22918@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10 2014 21:33 PM, Christoph Hellwig wrote:
> On Fri, Jan 10, 2014 at 09:22:10PM +0800, Jeff Liu wrote:
>> Hi Fengguang,
>>
>> Thanks for help catching up this.  I think the below patch can fix it
>> up, but maybe there would have a neater solution once Christoph is back.
> 
> I'd just remove the mask variable that caused the problem.  Untested
> patch below:
I also thought to fix this problem in this way, however I'm not sure
if those flags can be set back to iattr->ia_valid internally...

Otherwise, this fix looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0ce1d75..ce966c5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -714,7 +714,6 @@ xfs_setattr_size(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> -	int			mask = iattr->ia_valid;
>  	xfs_off_t		oldsize, newsize;
>  	struct xfs_trans	*tp;
>  	int			error;
> @@ -735,8 +734,8 @@ xfs_setattr_size(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>  	ASSERT(S_ISREG(ip->i_d.di_mode));
> -	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> -			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> +	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> +		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
>  	oldsize = inode->i_size;
>  	newsize = iattr->ia_size;
> @@ -745,7 +744,7 @@ xfs_setattr_size(
>  	 * Short circuit the truncate case for zero length files.
>  	 */
>  	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
> -		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
> +		if (!(iattr->ia_valid & (ATTR_CTIME|ATTR_MTIME)))
>  			return 0;
>  
>  		/*
> @@ -833,10 +832,11 @@ xfs_setattr_size(
>  	 * these flags set.  For all other operations the VFS set these flags
>  	 * explicitly if it wants a timestamp update.
>  	 */
> -	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
> +	if (newsize != oldsize &&
> +	    !(iattr->ia_valid & (ATTR_CTIME | ATTR_MTIME))) {
>  		iattr->ia_ctime = iattr->ia_mtime =
>  			current_fs_time(inode->i_sb);
> -		mask |= ATTR_CTIME | ATTR_MTIME;
> +		iattr->ia_valid |= ATTR_CTIME | ATTR_MTIME;
>  	}
>  
>  	/*
> @@ -872,9 +872,9 @@ xfs_setattr_size(
>  		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
> -	if (mask & ATTR_MODE)
> +	if (iattr->ia_valid & ATTR_MODE)
>  		xfs_setattr_mode(ip, iattr);
> -	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> +	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
>  		xfs_setattr_time(ip, iattr);
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
