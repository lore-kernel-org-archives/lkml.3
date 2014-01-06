Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaAFRth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:49:37 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:54108 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaAFRtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:49:35 -0500
Date: Mon, 6 Jan 2014 18:50:20 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        fuse-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hansen <rhansen@rhansen.org>
Subject: Re: [fuse-devel] [PATCH v2] fuse: Fix IOC_[GS]ET{FLAGS, VERSION}
 argument size brokenness.
Message-ID: <20140106175020.GG16230@tucsk.piliscsaba.szeredi.hu>
References: <20131219232739.GA10192@birch.djwong.org>
 <20131220233534.GC10192@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220233534.GC10192@birch.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 03:35:34PM -0800, Darrick J. Wong wrote:
> The IOC_[GS]ETFLAGS and IOC_[GS]ETVERSION ioctls, despite being
> defined to take a "long" parameter, actually take "int" parameters.
> FUSE unfortunately assumed that the ioctl definitions never lie, and

FUSE doesn't really assume anything.  It just says, that ioctl's that *properly*
use the _IO* macros will work.  Everything else will not.

It's unfortunate that IOC_SET/GETFLAGS is something that may actually make sense
on a fuse filesystem...

Two ways out of this:

 A) Add quirks to fuse
 B) Add new, fixed ioctls and use those from chattr if available

I'd very much prefer B.

Thanks,
Miklos

> transfers a long's worth of data in and out of userspace, which causes
> stack smashing in chattr, and other bugs elsewhere.
> 
> So, special-case this in FUSE so that we don't crash userland.
> 
> v2: Do the same for the IOC_[GS]ETVERSION ioctls, as Richard Hansen
>     points out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/fuse/file.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 7e70506..f8766ab 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2385,6 +2385,22 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
>  		iov->iov_base = (void __user *)arg;
>  		iov->iov_len = _IOC_SIZE(cmd);
>  
> +		/*
> +		 * The IOC_[GS]ETFLAGS and IOC_[GS]ETVERSION ioctls take int
> +		 * parameters even though the ioctl definition specifies long.
> +		 * Userland has been expecting int for ages (and chattr
> +		 * segfaults on FUSE filesystems), so special case that here.
> +		 * The IOC32 variants were declared with int, so they don't
> +		 * need this correction.
> +		 */
> +		switch (cmd) {
> +		case FS_IOC_GETFLAGS:
> +		case FS_IOC_SETFLAGS:
> +		case FS_IOC_GETVERSION:
> +		case FS_IOC_SETVERSION:
> +			iov->iov_len = sizeof(int);
> +		}
> +
>  		if (_IOC_DIR(cmd) & _IOC_WRITE) {
>  			in_iov = iov;
>  			in_iovs = 1;
> 
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT 
> organizations don't have a clear picture of how application performance 
> affects their revenue. With AppDynamics, you get 100% visibility into your 
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clktrk
> _______________________________________________
> fuse-devel mailing list
> fuse-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/fuse-devel
