Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaKZHom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:44:42 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52424 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaKZHok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:44:40 -0500
Date: Wed, 26 Nov 2014 08:44:35 +0100
From: Pieter Smith <pieter@boesman.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Josh Triplett <josh@joshtriplett.org>, fuse-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] fs/fuse: support compiling out splice
Message-ID: <20141126074435.GA15377@smipidev>
References: <1416899996-21315-1-git-send-email-pieter@boesman.nl>
 <1416899996-21315-5-git-send-email-pieter@boesman.nl>
 <20141125141713.GA9137@tucsk.suse.de>
 <20141125194242.GA21633@smipidev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125194242.GA21633@smipidev>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 08:42:42PM +0100, Pieter Smith wrote:
> On Tue, Nov 25, 2014 at 03:17:13PM +0100, Miklos Szeredi wrote:
> > [Trimming CC.  Please do the same for other patches.  I for one am not
> > interested in the general tinification discussion]
> > 
> > On Tue, Nov 25, 2014 at 08:19:39AM +0100, Pieter Smith wrote:
> > > To implement splice support, fs/fuse makes use of nosteal_pipe_buf_ops. This
> > > struct is exported by fs/splice. The goal of the larger patch set is to
> > > completely compile out fs/splice, so uses of the exported struct need to be
> > > compiled out along with fs/splice.
> > > 
> > > This patch therefore compiles out splice support in fs/fuse when
> > > CONFIG_SYSCALL_SPLICE is undefined.
> > > 
> > > Signed-off-by: Pieter Smith <pieter@boesman.nl>
> > > ---
> > >  fs/fuse/dev.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > > index ca88731..e984302 100644
> > > --- a/fs/fuse/dev.c
> > > +++ b/fs/fuse/dev.c
> > > @@ -1191,8 +1191,9 @@ __releases(fc->lock)
> > >   * request_end().  Otherwise add it to the processing list, and set
> > >   * the 'sent' flag.
> > >   */
> > > -static ssize_t fuse_dev_do_read(struct fuse_conn *fc, struct file *file,
> > > -				struct fuse_copy_state *cs, size_t nbytes)
> > > +static ssize_t __maybe_unused
> > > +fuse_dev_do_read(struct fuse_conn *fc, struct file *file,
> > > +		 struct fuse_copy_state *cs, size_t nbytes)
> > 
> > fuse_dev_do_read() is definitely going to remain used.  So no point in adding
> > __maybe_unused.
> 
> Off course, but at least gcc now also is aware that this is intentional and
> nicely refrains from nagging you with a warning.
> 
My apologies. My response was too hasty. You are right. This should not be
needed. I will revert this piece in v6 of this patch.
> > >  {
> > >  	int err;
> > >  	struct fuse_req *req;
> > > @@ -1291,6 +1292,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
> > >  	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
> > >  }
> > >  
> > > +#ifdef CONFIG_SYSCALL_SPLICE
> > >  static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
> > >  				    struct pipe_inode_info *pipe,
> > >  				    size_t len, unsigned int flags)
> > > @@ -1368,6 +1370,9 @@ out:
> > >  	kfree(bufs);
> > >  	return ret;
> > >  }
> > > +#else /* CONFIG_SYSCALL_SPLICE */
> > > +#define fuse_dev_splice_read NULL
> > > +#endif
> > 
> > This looks fine.
> > 
> > Thanks,
> > Miklos
> > 
> > >  
> > >  static int fuse_notify_poll(struct fuse_conn *fc, unsigned int size,
> > >  			    struct fuse_copy_state *cs)
> > > -- 
> > > 2.1.0
> > > 
