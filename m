Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaL0QIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 11:08:32 -0500
Received: from imap.thunk.org ([74.207.234.97]:44145 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaL0QIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 11:08:30 -0500
Date: Sat, 27 Dec 2014 11:08:29 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Leon Pollak <leon.pollak@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Old O_DIRECT story
Message-ID: <20141227160829.GD24553@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Leon Pollak <leon.pollak@gmail.com>, linux-kernel@vger.kernel.org
References: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 03:31:26PM +0200, Leon Pollak wrote:
> Hi, all.
> There was a discussion here:
> https://lkml.org/lkml/2007/1/10/231
> 
> Linus wrote in this discussion:
> "So don't use O_DIRECT. Use things like madvise() and posix_fadvise()
> instead"
> 
> After the full week of tests, searches, discussions, I have impudence to
> turn to the community - has one tried to implement this approach?

As Linus stated in one of the other messages in the thread:

   As a result, our madvise and/or posix_fadvise interfaces may not be all
   that strong, because people sadly don't use them that much. It's a sad
   example of a totally broken interface (O_DIRECT) resulting in better
   interfaces not getting used, and then not getting as much development
   effort put into them.

There are two reasons to use O_DIRECT.  One is controlling the cache
usage, and the other is performance.

> The situation is very simple:
> I have the incoming DMA stream using scatter/gather technique. the driver
> read() function provides the next ready DMA buffer descriptor with the
> virtual address pointer to the acquired data. I need to store this data to
> the disk partition as fast as possible, as the incoming stream is too very
> fast. According to tests, O_DIRECT/mapping is fast enough, while write() is
> not.

Do you understand *why* write is not fast enough?  Is it realy a
matter of memory bandwidth issues, where you are actually limited by
the copy time implied by the write(2).  If you are being constrained
by memory bandwidth issues, then this won't help, but if the issue
with using buffered writes is that you can't control the writeback
precisely enough, you might try using sync_file_range(2).

The perf program should help confirm if you really are getting hit by
memory bandwidth issues.

> I tried in all ways to implement this with mmap(), but it does not success,
> because I did not find a way to mmap() file as O_WRONLY. Mapping as O_RDWR
> makes kernel to pre-fill mapped memory with partition data. So, kernel and
> DMA actually compete on the RAM area to fill it - one with garbage, one
> with actual data. Kernel wins.

I would be *very* surprised that mmap() is fast enough, because the
overhead in dealing with the page tables and TLB flush usually dooms
the mmap() method.

But if in fact the issue is the pre-fill with partition table, if you
are using a file system, and using fallocate so that you are mapping
in a sparse file, then there would be no pre-population.  I'm guessing
though that since you mention "partition data", you're using a raw
block device, right?

> So, how to implement Linus's advice?

Ultimately, if nothing else works, O_DIRECT is still there for a
reason.  Nothing should stop you from using it.  It is a very awkward
interface, yes, but from a design perspective, it is ugly as sin.  But
at the end of the day, you really need the performance, it's there for
you to use.

Cheers,

						- Ted
