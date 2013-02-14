Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3BNCTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:19:15 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:56646 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab3BNCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:19:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEaAPpIHFF5LPNV/2dsb2JhbABFhWW0dIURAQKBAxdzgh8BAQQBJxMcIwULCAMYCSUPBSUDIROIDAW/bxWNGiFqD4M7A5YjkFSDGoFW
Date: Thu, 14 Feb 2013 13:19:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH RFC 10/12] userns: Convert xfs to use kuid/kgid/kprojid
 where appropriate
Message-ID: <20130214021908.GJ26694@dastard>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
 <1353415420-5457-10-git-send-email-ebiederm@xmission.com>
 <20121120235524.GK2591@dastard>
 <20121121195246.GN2822@localhost>
 <87obfoxetf.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obfoxetf.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:13:16AM -0800, Eric W. Biederman wrote:
> Joel Becker <jlbec@evilplan.org> writes:
> 
> > On Wed, Nov 21, 2012 at 10:55:24AM +1100, Dave Chinner wrote:
> >> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> > index 2778258..3656b88 100644
> >> > --- a/fs/xfs/xfs_inode.c
> >> > +++ b/fs/xfs/xfs_inode.c
> >> > @@ -570,11 +570,12 @@ xfs_dinode_from_disk(
> >> >  	to->di_version = from ->di_version;
> >> >  	to->di_format = from->di_format;
> >> >  	to->di_onlink = be16_to_cpu(from->di_onlink);
> >> > -	to->di_uid = be32_to_cpu(from->di_uid);
> >> > -	to->di_gid = be32_to_cpu(from->di_gid);
> >> > +	to->di_uid = make_kuid(&init_user_ns, be32_to_cpu(from->di_uid));
> >> > +	to->di_gid = make_kgid(&init_user_ns, be32_to_cpu(from->di_gid));
> >> 
> >> You can't do this, because the incore inode structure is written
> >> directly to the log. This is effectively an on-disk format change.
> >
> > 	Yeah, I don't get this either.  Over in ocfs2, you do the
> > correct thing, translating at the boundary from ocfs2_dinode to struct
> > inode.
> 
> This is the boundary.

It is *a* boundary. It is the in-core disk inode to on disk inode
boundary (i.e. struct xfs_icdinode to struct xfs_dinode).
Namespaces don't belong at this boundary - this is internal XFS
stuff that nothing from the VFS should be interacting with. The
structure of XFS is roughly:

	userspace
	---------
	   VFS
	---------
	 VFS/XFS	<<<<<< here is where you need to modify
	interface
	---------
	core XFS
	---------
	XFS/disk	<<<<<< here is where you actually modified
	interface
	---------
	 storage


IOWs, the boundary you are looking for is the VFS/XFS boundary (i.e.
struct inode to struct xfs_icdinode). i.e. namespace aware uid/gid
is in the struct inode, flattened 32 bit values are in the struct
xfs_icdinode. The struct inode and the struct xfs_icdinode are both
embedded in the struct xfs_inode, so we just have to translate
between the two internal structures are the right point in time.

Hence for namespaces to work correctly, anything that is currently
using current_fs*id() for uid/gid comparison needs to be converted
to use the VFS inode values (i.e. VFS_I(ip)->i_*id). For values
written to the xfs inode, the VFS uid/gid needs to be flattened to
a 32bit value.

These flattened values are needed during inode allocation (for
initial on-disk values) and creating dquots associated with the new
inodes. You should be able to derive them from current_fs*id(),
right? Then when changing uid/gid via .setattr, we can flatten the
namespace aware VFS uid/gid and into the XFS incore idinode (i.e.
ip->i_d.di_*id) via the same method. Conversion from XFS on-disk to
namespace aware VFS uid/gid then occurs when when initialising the
VFS inode from the XFS inode (i.e. in xfs_setup_inode() like I
previously suggested).

This keeps namespace aware uid/gid up at the VFS layer and
conversion at the VFS/XFS boundaries in the XFS code, and everything
should work fine.

> The crazy thing is that is that xfs appears to
> directly write their incore inode structure into their journal. 

Off topic, but it's actually a very sane thing to do. It's called
logical object logging, as opposed to physical logging like ext3/4
and ocfs2 use. XFS uses a combination of logical logging
(superblock, dquots, inodes) and physical logging (via buffers).

Logical logging decouples in-memory object modification from buffer
IO and ensures the buffer is not a single point of serialisation
when multiple objects share a single buffer. Hence we can read/write
an inode buffer and concurrent modify inodes in memory from that
buffer at the same time.  i.e. we only need buffers for IO, not for
ongoing modifications.

This decoupling allows XFS to use large buffers for inodes and so
minimise IO for reading and/or writing inodes.  Further, we can also
easily serialise logged, in-memory modifications for all objects in
a single backing buffer with only minor interruption to ongoing
modifications. It also allows us to use simple fire-and-forget
writeback semantics for metadata.

IOWs, the use of logical logging techniques vastly improves
concurrency and scalability over the physical logging methods other
filesystems use. Call it crazy if you want, but I find general most
people say this simply because they don't understand why XFS does
what it does....

> I had
> missed the journal reference the first time through and simply assumed
> since this is where the disk inode to the incore inode coversion
> happened that the weird scary comment in the xfs header file was wrong.

Comments in XFS, especially weird scary ones, are rarely wrong. Some
of them might have been there for close on 20 years, but they are
our documentation for all the weird, scary stuff that XFS does.  I
rely on them being correct, so it's something I always pay attention
to during code review. IOWs, When we add, modify or remove something
weird and scary, the comments are updated appropriately so we'll
know why the code is doing something weird and scary in another 20
years time. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
