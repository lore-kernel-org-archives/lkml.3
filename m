Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3KNFla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:41:30 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47480 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3KNFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:41:22 -0500
Date: Thu, 14 Nov 2013 14:41:16 +0900
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs_bin_mmap lockdep trace.
Message-ID: <20131114054116.GC29031@mtj.dyndns.org>
References: <20131113184538.GA7269@redhat.com>
 <20131113201043.GE13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113201043.GE13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hey,

On Wed, Nov 13, 2013 at 08:10:43PM +0000, Al Viro wrote:
> On Wed, Nov 13, 2013 at 01:45:38PM -0500, Dave Jones wrote:
> > Al, is this one also known ? Also seen on v3.12-7033-g42a2d923cc34
> 
> Umm...  I've seen something like that reported after sysfs merge went in
> (right after 3.12), but I hadn't looked into details.
> 
> > -> #3 (&mm->mmap_sem){++++++}:
> 
> 	[sr_block_ioctl() grabs sr_mutex and does copy_from_user() under it]
> 
> > -> #2 (sr_mutex){+.+.+.}:
> 	[sr_block_open() grabs sr_mutex under ->bd_mutex]
> 
> > -> #1 (&bdev->bd_mutex){+.+.+.}:
> 	[sysfs_blk_trace_attr_show() grabs ->bd_mutex and is called under
> sysfs_open_file ->mutex]
> 
> > -> #0 (&of->mutex){+.+.+.}:
> 	[sysfs_open_file ->mutex is grabbed by ->mmap()]
> 
> Cute...  AFAICS, it came from "sysfs: copy bin mmap support from fs/sysfs/bin.c
> to fs/sysfs/file.c".  The first impression is that sysfs_bin_mmap() is
> checking for battr->mmap too late, but I'm not sure whether we need of->mutex
> to stabilize it...  Tejun, any comments?

Hmmm... so this is a false positive from regular and bin file paths
being merged.  There was a sysfs regular file which grabbed sr_mutex
while holding sysfs mutex and only bin files supported mmap which of
course nest under mmap_sem.  As the two paths were separate and using
separate locks, this deadlock scenario didn't trigger.  Now that the
two paths are merged, lockdep considers the two paths to be using the
same mutex (they're per-file so still actually separate) and generates
this warning.  The easiest way out would be giving different lock
subclasses to files w/ and w/o mmap method.  I'll think more about it.

Thanks.

-- 
tejun
