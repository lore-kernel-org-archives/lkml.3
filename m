Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaHFCCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:02:45 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28549 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbaHFCCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:02:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AikJAC+M4VN5LKl0PGdsb2JhbABaFoJ3UleuIAEBAQEBAQadeIdMAYEOFwUBAQEBODaEAwEBBAE6HBYKAwULCAMOCgkMGQ8FJQMHGhMeiBwHDsJhEwQYhWSIeFgHCoRBBY57hi+CN4QrmEErL4EEAh4G
Date: Wed, 6 Aug 2014 12:01:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Abhijith Das <adas@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
Message-ID: <20140806020149.GI20518@dastard>
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
 <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca>
 <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com>
 <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca>
 <20140731044909.GR26465@dastard>
 <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca>
 <20140731235306.GR20518@dastard>
 <6DD09269-A8D4-4464-9E82-4B2EA665FA96@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6DD09269-A8D4-4464-9E82-4B2EA665FA96@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 07:54:56AM +0200, Andreas Dilger wrote:
> On Aug 1, 2014, at 1:53, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jul 31, 2014 at 01:19:45PM +0200, Andreas Dilger wrote:
> >> None of these issues are relevant in the API that I'm thinking about. 
> >> The syscall just passes the list of inode numbers to be prefetched
> >> into kernel memory, and then stat() is used to actually get the data into
> >> userspace (or whatever other operation is to be done on them),
> >> so there is no danger if the wrong inode is prefetched.  If the inode
> >> number is bad the filesystem can just ignore it.
> > 
> > Which means the filesystem has to treat the inode number as
> > potentially hostile. i.e. it can not be trusted to be correct and so
> > must take slow paths to validate the inode numbers. This adds
> > *significant* overhead to the readahead path for some filesystems:
> > readahead is only a win if it is low cost.
> > 
> > For example, on XFS every untrusted inode number lookup requires an
> > inode btree lookup to validate the inode is actually valid on disk
> > and that is it allocated and has references. That lookup serialises
> > against inode allocation/freeing as well as other lookups. In
> > comparison, when using a trusted inode number from a directory
> > lookup within the kernel, we only need to do a couple of shift and
> > mask operations to convert it to a disk address and we are good to
> > go.
> > 
> > i.e. the difference is at least 5 orders of magnitude higher CPU usage
> > for an "inode number readahead" syscall versus a "directory
> > readahead" syscall, it has significant serialisation issues and it
> > can stall other modification/lookups going on at the same time.
> > That's *horrible behaviour* for a speculative readahead operation,
> > but because the inodenumbers are untrusted, we can't avoid it.
> 
> For ext4 this is virtually free.

Yes, due to it's old-school fixed inode table design. But we aren't
designing functionality exclusely for ext4 - many filesystems do
dynamic inode allocation - and so we need to take the overhead of
inode number validation into account when discussing the
effectiveness of a generic readahead mechanism.

> The same needs to happen for any
> inode number from NFS so it can't be that bad. 

NFS is RPC rate limited, not inode number validation rate limited -
the inode number lookup during file handle translation is not a
limiting factor. e.g. we might be able to do 50,000 NFS getattr RPCs
per second on a modern CPU when we hit the inode cache and 10% of
that CPU load will be file handle translation.

However, local filesystems might be able to do 500,000 stat() calls
with the same CPU from a local filesystem on cached inodes. Let's
now add readahead that uses 10% of a CPU over per 50,000 inode
numbers.  Ignoring the overhead of the everything else but
filehandle translation, we run out of CPU at 500,000 inode number
lookups per second. So we burn up the entire CPU just doing inode
number validationand cache lookups, without actually doing any real
work. So adding inode number based readahead just slowed this
workload down by 50%...

Readahead is not always a win....

> Also, since this API would be prefetching inodes in bulk it
> could presumably optimize this to some extent. 

So can userspace.

> > So, again, it's way more overhead than userspace just calling
> > stat() asycnhronously on many files at once as readdir/gentdents
> > returns dirents from the kernel to speed up cache population.
> 
> To me this seems like saying it is just as fast to submit hundreds of
> 256-byte random reads for a file as it is for large linear reads with
> readahead.  Yes, it is possible for the kernel to optimize the random
> read workload to some extent, but not as easily as getting reads
> in order in the first place. 

Strawman.

For ext4, optimised inode read ordering is as simple as dispatching
the IO in ascending inode number order. Same as for many other
filesystems that use direct indexed, fixed location tables for
inodes. And it's the same for XFS, where the inode number is a
direct encoding of it's location in the address space of the
underlying block device.

Seriously, Chris Mason proved years ago how much we can gain
from simple userspace optimisations years ago with his ACP tool.

https://oss.oracle.com/~mason/acp/

This doesn't even use threading - just orders all the stat() calls
and readahead() based on the inode number or a FIBMAP call - and it
shows how substantial the improvements can be from simple userspace
changes.

> > That's my main issue with this patchset - it's implementing
> > something in kernelspace that can *easily* be done generically in
> > userspace without introducing all sorts of nasty corner cases that
> > we have to handle in the kernel. We only add functionality to the kernel if there's a
> > compelling reason to do it in kernelspace, and right now I just
> > don't see any numbers that justify adding readdir+stat() readahead
> > or inode number based cache population in kernelspace.
> 
> The original patch showed there was definitely a significant win with
> the prefetch case over the single threaded readdir+stat.

Sure, but so is acp, hence showing what userspace optimisation gains
us before we even consider implementations using threading and/or
async stat() calls.

> There is
> also something to be said for keeping complexity out of applications.

Yes, that's why I've been saying it should be in glibc hidden behind
ftw() and friends so no application has to be changed to benefit
from the readahead on traversal workloads.

> Sure it is possible for apps to get good performance from AIO,
> but very few do so because of complexity. 

True, but it's also true that few use AIO because they don't need
the few extra percent of performance that AIO can extract from the
system.

> > Before we add *any* syscall for directory readahead, we need
> > comparison numbers against doing the dumb multithreaded
> > userspace readahead of stat() calls. If userspace can do this as
> > fast as the kernel can....
> 
> I'd be interested to see this also, but my prediction is that this will not
> deliver the kind of improvements you are expecting. 

Do you really think I'd be saying we need numbers if I didn't have
a good idea of what the numbers are going to say? ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
