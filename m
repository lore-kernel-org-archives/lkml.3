Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaHAFzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:55:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49957 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAFzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:55:01 -0400
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca> <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca> <20140731044909.GR26465@dastard> <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca> <20140731235306.GR20518@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20140731235306.GR20518@dastard>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <6DD09269-A8D4-4464-9E82-4B2EA665FA96@dilger.ca>
Cc: Abhijith Das <adas@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>
X-Mailer: iPhone Mail (11D257)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
Date: Fri, 1 Aug 2014 07:54:56 +0200
To: Dave Chinner <david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 1, 2014, at 1:53, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 31, 2014 at 01:19:45PM +0200, Andreas Dilger wrote:
>> None of these issues are relevant in the API that I'm thinking about. 
>> The syscall just passes the list of inode numbers to be prefetched
>> into kernel memory, and then stat() is used to actually get the data into
>> userspace (or whatever other operation is to be done on them),
>> so there is no danger if the wrong inode is prefetched.  If the inode
>> number is bad the filesystem can just ignore it.
> 
> Which means the filesystem has to treat the inode number as
> potentially hostile. i.e. it can not be trusted to be correct and so
> must take slow paths to validate the inode numbers. This adds
> *significant* overhead to the readahead path for some filesystems:
> readahead is only a win if it is low cost.
> 
> For example, on XFS every untrusted inode number lookup requires an
> inode btree lookup to validate the inode is actually valid on disk
> and that is it allocated and has references. That lookup serialises
> against inode allocation/freeing as well as other lookups. In
> comparison, when using a trusted inode number from a directory
> lookup within the kernel, we only need to do a couple of shift and
> mask operations to convert it to a disk address and we are good to
> go.
> 
> i.e. the difference is at least 5 orders of magnitude higher CPU usage
> for an "inode number readahead" syscall versus a "directory
> readahead" syscall, it has significant serialisation issues and it
> can stall other modification/lookups going on at the same time.
> That's *horrible behaviour* for a speculative readahead operation,
> but because the inodenumbers are untrusted, we can't avoid it.

For ext4 this is virtually free. The same needs to happen for any
inode number from NFS so it can't be that bad. 

Also, since this API would be prefetching inodes in bulk it
could presumably optimize this to some extent. 

> So, again, it's way more overhead than userspace just calling
> stat() asycnhronously on many files at once as readdir/gentdents
> returns dirents from the kernel to speed up cache population.

To me this seems like saying it is just as fast to submit hundreds of
256-byte random reads for a file as it is for large linear reads with
readahead.  Yes, it is possible for the kernel to optimize the random
read workload to some extent, but not as easily as getting reads
in order in the first place. 

> That's my main issue with this patchset - it's implementing
> something in kernelspace that can *easily* be done generically in
> userspace without introducing all sorts of nasty corner cases that
> we have to handle in the kernel. We only add functionality to the kernel if there's a
> compelling reason to do it in kernelspace, and right now I just
> don't see any numbers that justify adding readdir+stat() readahead
> or inode number based cache population in kernelspace.

The original patch showed there was definitely a significant win with
the prefetch case over the single threaded readdir+stat. There is
also something to be said for keeping complexity out of applications.
Sure it is possible for apps to get good performance from AIO,
but very few do so because of complexity. 

> Before we add *any* syscall for directory readahead, we need
> comparison numbers against doing the dumb multithreaded
> userspace readahead of stat() calls. If userspace can do this as
> fast as the kernel can....

I'd be interested to see this also, but my prediction is that this will not
deliver the kind of improvements you are expecting. 

Cheers, Andreas