Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaERX4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:56:00 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:18103 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaERXz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:55:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvtMAK1HeVN5LL1sPGdsb2JhbABZgwZRgnCnLgsBAQEBAQEGmisBgQoXAwEBAQE4NYIlAQEFOhwjEAgDGAklDwUlAwctG4glDtBHFoU/iHsHgyuBFQSZWZZvKzA
Date: Mon, 19 May 2014 09:55:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: daniel@phunq.net
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140518235555.GC18954@dastard>
References: <5376B273.7000800@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5376B273.7000800@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:50:59PM -0700, Daniel Phillips wrote:
> We would like to offer Tux3 for review for mainline merge. We have
> prepared a new repository suitable for pulling:
> 
> https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/
> 
> Tux3 kernel module files are here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3
> 
> Tux3 userspace tools and tests are here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3/user?h=user

Post patches for review, please.  Go and look at the process used to
merge f2fs for an example of how to filesystem merged....

Ignoring this, I had a quick look at the code.  This is not a code
review - it's a message to tell everyone else not to waste their
time looking at the code right now...

The code is a dog's breakfast of #ifdef hackery, stuff that doesn't
work (lots of code surrounded by "#if 0"), there's "#if __KERNEL__
...  #else .... #endif" all through the code, etc. The "declarations
within code" stuff is just horrible - it's not even used
consistently so it just looks like laziness to me.  IOWs, the code
is an ugly mess and needs a serious amount of cleanup work. Example:

static const struct inode_operations tux_file_iops = {
//      .permission     = ext4_permission,
        .setattr        = tux3_setattr,
        .getattr        = tux3_getattr,
#ifdef CONFIG_EXT4DEV_FS_XATTR
//      .setxattr       = generic_setxattr,
//      .getxattr       = generic_getxattr,
//      .listxattr      = ext4_listxattr,
//      .removexattr    = generic_removexattr,
#endif
//      .fallocate      = ext4_fallocate,
//      .fiemap         = ext4_fiemap,
        .update_time    = tux3_file_update_time,
};

That's code ready for review and merging? Really?

The hacks around VFS and MM functionality need to have demonstrated
methods for being removed. We're not going to merge that page
forking stuff (like you were told at LSF 2013 more than a year ago:
http://lwn.net/Articles/548091/) without rigorous design review and
a demonstration of the solutions to all the hard corner cases it
has. The current code doesn't solve them (e.g. direct IO doesn't
work in tux3), and there's no clear patch set we can review that
demonstrates how it is all supposed to work. i.e. you need to
separate out all the page forking code into a separate patchset for
review, independent of the tux3 code and applies to the core mm/
code.

Then there's all the writeback hacks. You've simply copy-n-pasted
most of fs-writeback.c, including duplicating structures like struct
wb_writeback_work and then hacked in crap (kallsyms lookups!) to be
able to access core structures from kernel module context
(tux3_setup_writeback(), I'm looking at you). This is completely
unacceptible for a merge. Again, you need to separate out all the
writeback changes you need into an independent patchset so that they
can be reviewed independently of the tux3 code that uses it. 

Now, one of the big features tux3 you hyped is built-in snapshotting
capability. All that talk efficient pointer trees (or whatever they
were called) and being so much better than ZFS/btrfs-like COW.
Well, I can't find it anywhere in the code - the only references to
snapshots are 5 comments like this:

	* FIXME: what happen if snapshot was introduced?

IOWs, tux3 is just a prototype of a standard journaling filesystem.
The tux3 code is still missing large parts of it's intended core
functionality and there is nothing to tell us when that might
appear. It really appears to me that tux3 is where btrfs was 5-6
years ago - the core of an idea, but a long, long way from being
feature complete or production ready. btrfs still doesn't handle
ENOSPC well and given that tux3's is following the same development
path (BUG on ENOSPC) it doesn't fill me with any confidence that
tux3 is going to turn out any better than btrfs in 5 years time.

Really, I don't see how you plan to bring tux3 to be feature
complete and production ready in less than 2-3 years. The current
code is barely functional at this point and there's still questions
that haven't been answered about whether core tux3 functionality can
even be made to work properly, let alone integrated effectively.

IMO, it's a waste of time right now asking anyone to review this
code for inclusion until it has been cleaned up, the core
infrastructure problems have been solved and the core filesystem
code is much closer to feature complete.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
