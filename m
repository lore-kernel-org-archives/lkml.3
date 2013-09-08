Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab3IHXkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 19:40:43 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26694 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab3IHXkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 19:40:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhISAKEKLVJ5LJ62/2dsb2JhbABagwc4gxKrGQOOfoU3gSQXdIIlAQEFOhwjEAgDGAklDwUlAyETiAHFZBaON4EzB4QdA5d0kWeDMiqBLQ
Date: Mon, 9 Sep 2013 09:40:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] pramfs
Message-ID: <20130908234031.GS12779@dastard>
References: <522AE04C.6000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522AE04C.6000002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 10:14:04AM +0200, Marco Stornelli wrote:
> Hi all,
> 
> this is an attempt to include pramfs in mainline. At the moment pramfs
> has been included in LTSI kernel. Since last review the code is more
> or less the same but, with a really big thanks to Vladimir Davydov and
> Parallels, the development of fsck has been started and we have now
> the possibility to correct fs errors due to corruption. It's a "young"
> tool but we are working on it. You can clone the code from our repos:
> 
> git clone git://git.code.sf.net/p/pramfs/code pramfs-code
> git clone git://git.code.sf.net/p/pramfs/Tools pramfs-Tools

The 1980s are calling, and they want their filesytem back. :)

So, Devil's Advocate time. Convince me as to why pramfs should be
merged.

Why do we want a single threaded, block based filesystem (i.e. based
on 1980s filesystem technology) as the basis for storing information
in persistent memory in 2013?  Persistent memory over the next few
years is going to require support for 10s to 100s of TB of storage
and concurrency of 100s to 1000s of CPU cores banging on the memory
at full speed. By design, pramfs is simply not sufficient for our
future needs.

pramfs uses indirect block indexing - not even extents - for file
data.  That doesn't scale effectively to large files or fragmented
files, which is what the single threaded bitmap block allocator will
cause because it's a just a basic "find the next zero bit in the
bitmap" allocator.

It doesn't have any recovery mechanisms built in to it (like a redo
log) nor can it do atomic multi-variable updates to persistent
memory segments, so a crash at the wrong time will leave you with a
corrupted filesystem. We learnt this lesson years ago - fsck on
every boot does not scale and people hate having boot interrupted by
needing to manually intervene in recovery operations to get their
system back up and running.

The directory structure is a linked list of inodes, linked by inode
number. The operations to add or remove an inode are not atomic from
a persistent memory perspsective and so a crash between them will
result in a corrupt directory. Lookup has to iterate the linked list
to find a name match - that's not going to scale at all, and it's
completely serialised, too, so concurrent lookups into the same
directory are out of the question.

Further, the readdir cookie is the position of the inode in the
linked list, which means telldir/seekdir are fundamentally broken in
the presence of directory modification. It also uses the magic
number of "3" to indicate the end of the directory, which is kinda
weird.

If we were in the 1980s, then pramfs would be wonderful. The reality
is, though, it is 2013 and we have another 30-odd years of
filesystem development knowledge under our belts. IMO, pramfs won't
even effectively scale to the needs of a modern smart phone, let
alone a server with a couple of terabytes of persistent memory.

>From that perspective, pramfs is really just a toy and not something
we could use as the basis of future persistent memory storage
development because we'd need to start again from scratch.

IOWs, I'm looking at pramfs with an eye to 5-10 years in the future.
I can see lots of problems just with 5 year old technology in pramfs
and AFAIC just because it's been included in a LSTI kernel doesn't
mean we should include it mainline. I'm not denying that We need a
persistent memory filesystem in mainline, but we don't want to merge
something that already borders on obsolesence and then have to both
maintain it and simultaneously design a new filesystem that handles
our current and future needs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
