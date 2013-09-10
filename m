Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3IJWjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:39:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3IJWjc (ORCPT <rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 10 Sep 2013 18:39:32 -0400
Date: Wed, 11 Sep 2013 00:39:29 +0200
From: Jan Kara <jack@suse.cz>
To: Howard Chu <hyc@symas.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: dirty_expire_centisecs, msync behavior
Message-ID: <20130910223929.GB9805@quack.suse.cz>
References: <522BBE46.9060809@symas.com>
 <20130910204544.GB3046@quack.suse.cz>
 <522F934C.7080001@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522F934C.7080001@symas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-09-13 14:46:52, Howard Chu wrote:
> >On Sat 07-09-13 17:01:10, Howard Chu wrote:
> >>The documentation for dirty_expire_centisecs states: "Data which has
> >>been dirty in-memory for longer than this interval will be written
> >>out next time a flusher thread wakes up."
> >>
> >>In practice, it appears that once the expire time has passed, all
> >>dirty pages get flushed, regardless of their age. This behavior
> >>makes this setting fairly useless. This appears to have been the
> >>behavior for most of 2.6 and 3.x. Can anyone explain, is the current
> >>behavior really as intended, and is the doc just out of date?
> >   What really happens is that all inodes which have been dirtied before
> >'expire time' are completely flushed.
> 
> Still it appears to be more than that. If I suspend the writer, I
> can see (using atop) that the flusher always keeps writing until the
> number of dirty pages is zero, and that happens in much shorter than
> the expire time. This is on an Ubuntu build 3.5.0-23-generic.
> Perhaps this behavior has also changed in more recent kernels?
> Another person has reported the same thing using 3.0
> 
> http://stackoverflow.com/questions/18353467/implementation-of-dirty-expire-centisecs
  Well, let me explain the mechanism in more detail: When the first page is
dirtied in an inode, the current time is recorded in the inode. When this
time gets older than dirty_expire_centisecs, all dirty pages in the inode
are written. So with this mechanism in mind the behavior you describe looks
expected to me.

> >>On a slightly related note, what was the key problem with this patch
> >>"msync: support syncing a small part of the file"?
> >>http://thread.gmane.org/gmane.linux.kernel/1313767/focus=1317498
> >>
> >>Andrew Morton's message states that Paolo's patch would break
> >>nonlinear mappings, and the matter was dropped. Why wasn't it
> >>possible to write a patch that would also work with nonlinear
> >>mappings? I couldn't find any earlier context for that subject,
> >>pointers welcome.
> >   It is certainly possible. But actually I'm not 100% sure it is worth it.
> >Because each fsync() call has a certain overhead in the filesystem and that
> >is rather considerable - forcing a journal transaction to disk, flushing
> >disk caches, ... So splitting one large fsync() into several smaller ones
> >(even if they together write significantly less pages) is often slower.
> 
> OK... But does msync() have to do that? Is msync() closer to fsync()
> in behavior, or just fdatasync()?
  Requirements of msync() seem equivalent to fdatasync(). But both fsync()
and fdatasync() have similar requirements wrt journalling and cache
flushes. We can save commiting some transactions if the only updates to the
inode are timestamps (and we do that optimization in ext4) but still it is
pretty expensive.

> And also, if you're using something without journaling, like ext2, I
> would think it's a pure win.
  True, for some filesystems, some workloads, or some HW configurations it
will be a win. For others it will be a loss. BTW, even ext2 should flush
disk caches after fsync(2). Otherwise you can still loose the data after a
power failure.
 
> >>My interest in both of these questions stems from what I've observed
> >>while testing the LMDB memory-mapped database. On a machine with
> >>32GB RAM, using a database that occupies about 18GB of memory, doing
> >>continuous writes to the DB without ever calling msync, and default
> >>writeback settings, I see DB throughput spike downward every time
> >>the flusher wakes up. The DB is a mmap'd file on an XFS partition,
> >>and a DB write operation simply dirties a random set of pages. After
> >>the program has been running for more than dirty_expire_centisecs,
> >>every dirty_writeback_centisecs the DB app basically stops while the
> >>flusher writes out all the dirty pages.
> >   What kernel version are you using? What you describe sounds like the
> >problems that happened due to 'stable pages under writeback' work. We
> >didn't allow page to be redirtied while it was under writeback. In 3.10
> >we fixed that so workloads that are redirtying pages should be improved.
> 
> Currently using 3.5 (as noted earlier in this reply). Out of
> curiosity, do you happen to know how long the pre-3.10 behavior has
> existed? Is it a 3.x change that wasn't present in 2.6?
  3.0 was the first kernel with this problematic logic.
 
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
