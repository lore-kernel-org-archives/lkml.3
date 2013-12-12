Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3LLNkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:40:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:8140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab3LLNks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:40:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="443083727"
Message-ID: <1386855640.6066.73.camel@tursulin-linux.isw.intel.com>
Subject: Re: Potentially unbounded allocations in seq_read?
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Dec 2013 13:40:40 +0000
In-Reply-To: <20131211180703.GY10323@ZenIV.linux.org.uk>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
	 <20131211174909.GW10323@ZenIV.linux.org.uk>
	 <1386784797.6066.63.camel@tursulin-linux.isw.intel.com>
	 <20131211180703.GY10323@ZenIV.linux.org.uk>
Organization: Intel Corporation UK Plc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 18:07 +0000, Al Viro wrote:
> On Wed, Dec 11, 2013 at 05:59:57PM +0000, Tvrtko Ursulin wrote:
> > On Wed, 2013-12-11 at 17:49 +0000, Al Viro wrote:
> > > On Wed, Dec 11, 2013 at 05:04:41PM +0000, Tvrtko Ursulin wrote:
> > > > Hi all,
> > > > 
> > > > It seems that the buffer allocation in seq_read can double in size
> > > > indefinitely, at least I've seen that in practice with /proc/<pid>/smaps
> > > > (attempting to double m->size to 4M on a read of 1000 bytes). This
> > > > produces an ugly WARN_ON_ONCE, which should perhaps be avoided? (given
> > > > that it can be triggered by userspace at will)
> > > 
> > > An entry in /proc/<pid>/smaps that did not fit into 2Mb?  Seriously?
> > > How in hell has that happened?  If you can trigger that at will, please
> > > post the reproducer.
> > 
> > Yeah, no, wrong assumption. It was not about the size but the number of
> > reads. For example:
> > 
> > open("/proc/3131/smaps", O_RDONLY|O_LARGEFILE) = 3
> > fstat64(1, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
> > brk(0xf9019000)                         = 0xf9019000
> > read(3, "be483000-be4ab000 rw-s 00000000 "..., 4096) = 4054
> > write(1, "be483000-be4ab000 rw-s 00000000 "..., 4054) = 4054
> > read(3, "be5c3000-be5c5000 rw-s 10da3f000"..., 4096) = 3656
> > write(1, "be5c3000-be5c5000 rw-s 10da3f000"..., 3656) = 3656
> > read(3, "be6b1000-be6b2000 rw-s 10da48000"..., 4096) = 3661
> > write(1, "be6b1000-be6b2000 rw-s 10da48000"..., 3661) = 3661
> > read(3, "be6b9000-be6ba000 rw-s 10da38000"..., 4096) = 3599
> > write(1, "be6b9000-be6ba000 rw-s 10da38000"..., 3599) = 3599
> > read(3, "be6d6000-be7b6000 rw-s 10d889000"..., 4096) = 3599
> > write(1, "be6d6000-be7b6000 rw-s 10d889000"..., 3599) = 3599
> > read(3, "be884000-be885000 rw-s 10d85c000"..., 4096) = 3661
> > write(1, "be884000-be885000 rw-s 10d85c000"..., 3661) = 3661
> > read(3, "be88d000-be8de000 rw-p 00000000 "..., 4096) = 4007
> > write(1, "be88d000-be8de000 rw-p 00000000 "..., 4007) = 4007
> > read(3, "bea29000-bea4d000 r-xp 00000000 "..., 4096) = 4057
> > write(1, "bea29000-bea4d000 r-xp 00000000 "..., 4057) = 4057
> > read(3, "beab3000-bead0000 r--p 00000000 "..., 4096) = 2092
> > write(1, "beab3000-bead0000 r--p 00000000 "..., 2092) = 2092
> > read(3, 0xf9017030, 4096)               = -1 ENOMEM (Out of memory)
> 
> OK, so you've got ENOMEM somewhere, but where had it come from?
> The buffer from previous read() ought to have sufficed for this one,
> unless the next entry had been much longer than usual...

So this is the story... task_mmu.c:show_map_vma() calls seq_path. There
we have a d_path call which returns -ENAMETOOLONG and keeps doing so
even though the buffer grows to huge proportions. It is something on
tmpfs, don't know what.

But in the meantime, shouldn't seq_path be a bit more considerate on
this particular error and not mark the state as "could not fit" forever?
Perhaps it would make sense to limit it a bit?

Or even more so, on errors _other_ than -ENAMETOOLONG it will at the
moment mark the result as "need more space". That also sounds broken to
me.

Regards,

Tvrtko

