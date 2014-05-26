Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaEZNYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:24:23 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:65028 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaEZNYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140526094240.B5508E009B@blue.fi.intel.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<20140519143837.GA5228@infradead.org>
	<CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
	<20140526094240.B5508E009B@blue.fi.intel.com>
Date: Mon, 26 May 2014 08:24:21 -0500
Message-ID: <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Jeff Smith <jsmith.lkml@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Mirrored mapping is absolutely required by several
>> independent proprietary platforms I'm aware of, and remap_file_pages()
>> has historically been the only sane way to accomplish this. (i.e.,
>> shm_open(), mmap(NULL, 2^(n+1) pages), remap_file_pages() on 2nd
>> half).
>
> Em.. What's wrong with shm_open() + two mmap()s to cover both halfs?
>
> fd = shm_open();
> addr1 = mmap(NULL, 2*SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> addr2 = mmap(addr1 + SIZE, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, 0);
>
> Is there a reason why it doens't work?

Your addr2 mmap() call is a bit incorrect semantically and
syntactically (you skipped the length arg). The addr2 request will
fail because mmap() does not implicitly munmap() occupied virtual
address space. Even if you did that, the following still has a race
condition between the addr2 request and another thread grabbing the
same virtual space, which nothing short of a lock on all threads'
mmap()-ing logic can protect:

addr1 = mmap(NULL, 2*SIZE, PROT_READ, MAP_SHARED, fd, 0);
munmap(addr1 + SIZE, SIZE);
/* race on virtual address space here, but n/a for remap_file_pages() ... */
addr2 = mmap(addr1, SIZE, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);

remap_file_pages() is not subject to this problem and allows the
creation of considerably cleaner code. Protecting the address space
corner cases with locks or arbitrarily bounded munmap()-and-retry
loops is a substantial burden over the historically provided approach.

>> but failing that, a reservation API would need
>> to be created (possibly a MAP_RESERVE flag) that would set aside a
>> region that could only be subsequently mapped via explicit
>> address-requesting mmap() calls.
>
> I don't get this part.

I'm proposing that a call along the lines of mmap(NULL, len, prot,
MAP_RESERVED | ..., fd, offset) could return a virtual address block
that is -not- actually mapped but -is- protected from other mmap()
calls not explicitly requesting the space via their addr parameters.
Unfortunately, you'd also need to define separate semantics to
un-reserving not-mapped space, etc.

The important issue is that users need to be able to trivially protect
themselves from transient virtual address space congestion problems
and only fail early on long-term exhaustion situations.
