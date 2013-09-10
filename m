Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3IJUpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:45:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3IJUpq (ORCPT <rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 10 Sep 2013 16:45:46 -0400
Date: Tue, 10 Sep 2013 22:45:44 +0200
From: Jan Kara <jack@suse.cz>
To: Howard Chu <hyc@symas.com>
Cc: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: dirty_expire_centisecs, msync behavior
Message-ID: <20130910204544.GB3046@quack.suse.cz>
References: <522BBE46.9060809@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522BBE46.9060809@symas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Sat 07-09-13 17:01:10, Howard Chu wrote:
> The documentation for dirty_expire_centisecs states: "Data which has
> been dirty in-memory for longer than this interval will be written
> out next time a flusher thread wakes up."
> 
> In practice, it appears that once the expire time has passed, all
> dirty pages get flushed, regardless of their age. This behavior
> makes this setting fairly useless. This appears to have been the
> behavior for most of 2.6 and 3.x. Can anyone explain, is the current
> behavior really as intended, and is the doc just out of date?
  What really happens is that all inodes which have been dirtied before
'expire time' are completely flushed.

> On a slightly related note, what was the key problem with this patch
> "msync: support syncing a small part of the file"?
> http://thread.gmane.org/gmane.linux.kernel/1313767/focus=1317498
> 
> Andrew Morton's message states that Paolo's patch would break
> nonlinear mappings, and the matter was dropped. Why wasn't it
> possible to write a patch that would also work with nonlinear
> mappings? I couldn't find any earlier context for that subject,
> pointers welcome.
  It is certainly possible. But actually I'm not 100% sure it is worth it.
Because each fsync() call has a certain overhead in the filesystem and that
is rather considerable - forcing a journal transaction to disk, flushing
disk caches, ... So splitting one large fsync() into several smaller ones
(even if they together write significantly less pages) is often slower.
 
> My interest in both of these questions stems from what I've observed
> while testing the LMDB memory-mapped database. On a machine with
> 32GB RAM, using a database that occupies about 18GB of memory, doing
> continuous writes to the DB without ever calling msync, and default
> writeback settings, I see DB throughput spike downward every time
> the flusher wakes up. The DB is a mmap'd file on an XFS partition,
> and a DB write operation simply dirties a random set of pages. After
> the program has been running for more than dirty_expire_centisecs,
> every dirty_writeback_centisecs the DB app basically stops while the
> flusher writes out all the dirty pages.
  What kernel version are you using? What you describe sounds like the
problems that happened due to 'stable pages under writeback' work. We
didn't allow page to be redirtied while it was under writeback. In 3.10
we fixed that so workloads that are redirtying pages should be improved.

> I'm curious about a couple things - since the DB knows which pages
> it is dirtying in a given transaction, would it help overall
> throughput if the DB told the OS (via msync) exactly which ranges to
> flush? Obviously not, in the current implementation of msync, but
> can a patch like Paolo's make this better? And can the
> dirty_expire_centisecs behavior be fixed, so that it's only writing
> out a smaller set of pages on each wakeup? What else can we do to
> minimize the impact of the flusher? If I turn it off completely the
> throughput nearly doubles, from 5100 DB writes/sec to 9000/sec. If I
> turn off the timed flush and just use dirty_background_bytes the
> throughput just slows to around 7000/sec.
  After 3.10 running flusher should have rather minimal impact on the
parallel mmap workload. It still locks the page when submitting it for IO
but when the underlying blocks are allocated (which is your case I believe)
this interval when the page is locked is very short.

> It seems to me the main slowdown is because the OS is locking dirty
> pages indiscriminately. The DB does copy-on-write, so pages that it
> dirties in one transaction will not be written again in the next
> transaction. I would have expected read-only accesses to these pages
> to be able to progress without any delay but that doesn't seem to be
> the case.
  So I would be really surprised if read-only access to the pages blocked
because you shouldn't really enter the kernel at all if those pages are
already mapped and faulted in.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
