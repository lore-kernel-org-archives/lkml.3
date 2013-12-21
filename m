Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LUCqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:46:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22990 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3LUCqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:46:08 -0500
Date: Fri, 20 Dec 2013 18:45:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Richard Hansen <rhansen@rhansen.org>
Subject: Re: [PATCH v2] fuse: Fix IOC_[GS]ET{FLAGS,VERSION} argument size
 brokenness.
Message-ID: <20131221024554.GA20750@birch.djwong.org>
References: <20131219232739.GA10192@birch.djwong.org>
 <20131220233534.GC10192@birch.djwong.org>
 <99199002-0C82-42B6-B237-163561AD821B@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99199002-0C82-42B6-B237-163561AD821B@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 07:09:23PM -0700, Andreas Dilger wrote:
> To be honest, FS_IOC_SETVERSION isn't used by many/any users, so it might be
> better to avoid doing anything with that for now.
> 
> In the past we even talked about adding a deprecation warning for that ioctl
> since it adds complexity for little value. 

I suspect that most FUSE servers don't handle any of these four ioctls,
but so long as they're there, we ought to make them less surprising to
userspace.

As far as getting rid of SETVERSION, I think that's best left to a fs driver
(or a fuse server) to make that decision, unless everyone wants to eliminate
SETVERSION entirely?  I don't remember anyone complaining when I proposed to
disable SETVERSION on metadata_csum ext4 filesystems, but that's hardly
conclusive. :)

The only providers of SETVERSION seem to be ext[234], reiser3, and ocfs2.

--D

> 
> Cheers, Andreas
> 
> > On Dec 20, 2013, at 16:35, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> > 
> > The IOC_[GS]ETFLAGS and IOC_[GS]ETVERSION ioctls, despite being
> > defined to take a "long" parameter, actually take "int" parameters.
> > FUSE unfortunately assumed that the ioctl definitions never lie, and
> > transfers a long's worth of data in and out of userspace, which causes
> > stack smashing in chattr, and other bugs elsewhere.
> > 
> > So, special-case this in FUSE so that we don't crash userland.
> > 
> > v2: Do the same for the IOC_[GS]ETVERSION ioctls, as Richard Hansen
> >    points out.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > fs/fuse/file.c |   16 ++++++++++++++++
> > 1 file changed, 16 insertions(+)
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 7e70506..f8766ab 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -2385,6 +2385,22 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
> >        iov->iov_base = (void __user *)arg;
> >        iov->iov_len = _IOC_SIZE(cmd);
> > 
> > +        /*
> > +         * The IOC_[GS]ETFLAGS and IOC_[GS]ETVERSION ioctls take int
> > +         * parameters even though the ioctl definition specifies long.
> > +         * Userland has been expecting int for ages (and chattr
> > +         * segfaults on FUSE filesystems), so special case that here.
> > +         * The IOC32 variants were declared with int, so they don't
> > +         * need this correction.
> > +         */
> > +        switch (cmd) {
> > +        case FS_IOC_GETFLAGS:
> > +        case FS_IOC_SETFLAGS:
> > +        case FS_IOC_GETVERSION:
> > +        case FS_IOC_SETVERSION:
> > +            iov->iov_len = sizeof(int);
> > +        }
> > +
> >        if (_IOC_DIR(cmd) & _IOC_WRITE) {
> >            in_iov = iov;
> >            in_iovs = 1;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
