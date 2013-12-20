Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3LTXMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:12:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16664 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3LTXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:12:09 -0500
Date: Fri, 20 Dec 2013 15:10:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Richard Hansen <rhansen@rhansen.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        Aurelien Jarno <aurelien@aurel32.net>,
        Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] fuse: Fix IOC_[GS]ETFLAGS argument size brokenness
Message-ID: <20131220231004.GB10192@birch.djwong.org>
References: <20131219232739.GA10192@birch.djwong.org>
 <52B3E16F.7070409@rhansen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B3E16F.7070409@rhansen.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 01:19:27AM -0500, Richard Hansen wrote:
> On 2013-12-19 18:27, Darrick J. Wong wrote:
> > The IOC_[GS]ETFLAGS ioctls, despite being defined to take a "long"
> > parameter, actually take "int" parameters.  FUSE unfortunately assumed
> > that the ioctl definitions never lie, and transfers a long's worth of
> > data in and out of userspace, which causes stack smashing in chattr,
> > and other bugs elsewhere.
> > 
> > So, special-case this in FUSE, and document this int/long quirk in
> > include/uapi/linux/fs.h.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/fuse/file.c          |   11 +++++++++++
> >  include/uapi/linux/fs.h |    1 +
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 7e70506..5fa8181 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -2385,6 +2385,17 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
> >  		iov->iov_base = (void __user *)arg;
> >  		iov->iov_len = _IOC_SIZE(cmd);
> >  
> > +		/*
> > +		 * The IOC_[GS]ETFLAGS ioctls take int parameters even though
> > +		 * the ioctl definition specifies long.  Userland has been
> > +		 * expecting int for ages (and chattr segfaults on FUSE
> > +		 * filesystems), so special case that here.  The IOC32
> > +		 * variants were declared with int, so they don't need this.
> > +		 */
> > +		if (cmd == FS_IOC_GETFLAGS || cmd == FS_IOC_SETFLAGS) {
> > +			iov->iov_len = sizeof(int);
> > +		}
> > +
> >  		if (_IOC_DIR(cmd) & _IOC_WRITE) {
> >  			in_iov = iov;
> >  			in_iovs = 1;
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 6c28b61..bc8aa8e 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -154,6 +154,7 @@ struct inodes_stat_t {
> >  #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
> >  #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
> >  
> > +/* IOC_[GS]ETFLAGS take an int argument despite being defined to take long. */
> >  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
> >  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
> >  #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
> 
> This change to include/uapi/linux/fs.h is similar to but not as thorough as:
> 
> http://mid.gmane.org/1385548839-16617-1-git-send-email-aurelien@aurel32.net
> https://lkml.org/lkml/2013/11/27/93
> 
> (The above linked patch is the patch Aurelien referenced in the
> "Argument type for FS_IOC_GETFLAGS/FS_IOC_SETFLAGS ioctls" thread on
> linux-fsdevel; see
> <http://mid.gmane.org/20131127231430.GG29912@hall.aurel32.net>.)

Aha!  I thought I'd seen something like that on the list, though it doesn't
seem to be in -rc.  Thank you for pointing that out.

And yes, now that I look at all the [GS]ETVERSION implementations, I think FUSE
could special-case those two ioctls too.

--D
> 
> -Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
