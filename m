Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3GPKju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab3GPKjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:39:49 -0400
Date: Tue, 16 Jul 2013 12:39:39 +0200
From: Niels de Vos <ndevos@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCH] fuse: fix occasional dentry leak when
 readdirplus is used
Message-ID: <20130716103939.GL18803@ndevos-laptop.usersys.redhat.com>
References: <1373893160-30601-1-git-send-email-ndevos@redhat.com>
 <51E456B6.8050601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E456B6.8050601@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 04:08:22PM -0400, Brian Foster wrote:
> On 07/15/2013 08:59 AM, Niels de Vos wrote:
> > In case d_lookup() returns a dentry with d_inode == NULL, the dentry is
> > not returned with dput(). This results in triggering a BUG() in
> > shrink_dcache_for_umount_subtree():
> > 
> >   BUG: Dentry ...{i=0,n=...} still in use (1) [unmount of fuse fuse]
> > 
> > Reported-by: Justin Clift <jclift@redhat.com>
> > Signed-off-by: Niels de Vos <ndevos@redhat.com>
> > 
> > --
> > Reproducing the BUG() on kernels with fuse that support READDIRPLUS can
> > be done with the GlusterFS tests:
> > - http://www.gluster.org/community/documentation/index.php/Using_the_Gluster_Test_Framework
> > 
> > After some stressing of the VFS and fuse mountpoints, bug-860663.t will
> > hit the BUG(). It does not happen on running this test stand-alone.
> 
> Hi Neils,
> 
> FYI, this is fairly easy to reproduce on-demand with gluster:
> 
> - mount a volume to two local mountpoints (i.e., I used a single
> storage/posix translator volume):
> 	glusterfs --volfile=./test.vol /mnt/{1,2} --use-readdirp=1
> - create a negative dentry in one mountpoint:
> 	ls /mnt/1/file (results in ENOENT)
> - create the file via the second mountpoint:
> 	touch /mnt/2/file
> - run a readdirp on the first mountpoint:
> 	ls /mnt/1/
> - umount /mnt/2 /mnt/1

Thanks, that definitely makes it easier to verify the fix.

> > ---
> >  fs/fuse/dir.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 0eda527..da67a15 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -1246,7 +1246,9 @@ static int fuse_direntplus_link(struct file *file,
> >  		if (err)
> >  			goto out;
> >  		dput(dentry);
> > -		dentry = NULL;
> > +	} else if (dentry) {
> > +		/* this dentry does not have a d_inode, just drop it */
> > +		dput(dentry);
> >  	}
> 
> I'm not really familiar with the dcache code, but is it appropriate to
> also d_invalidate() the dentry in this case (as the previous code block
> does)? Perhaps Miklos or somebody more familiar with dcache can confirm...

I do not *think* d_invalidate() is needed. The vmcores I have seem where 
this BUG() happened, only have dentry->d_flags = 0x18 which translates 
to (DCACHE_OP_DELETE | DCACHE_OP_PRUNE) and d_subdirs as an empty list.  
d_invalidate() only calls __d_drop(), which only does something when the 
dentry is hashed.

I am not sure if a dentry can be hashed, but still does not have a valid 
non-NULL d_inode. If that is the case, d_invalidate() should indeed be 
called.

Thanks,
Niels

> Brian
> 
> >  
> >  	dentry = d_alloc(parent, &name);
> > 
> 

-- 
Niels de Vos
Sr. Software Maintenance Engineer
Support Engineering Group
Red Hat Global Support Services
