Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaEZNhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:37:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:23318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaEZNhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:37:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,913,1392192000"; 
   d="scan'208";a="545057755"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jeff Smith <jsmith.lkml@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
 <20140526094240.B5508E009B@blue.fi.intel.com>
 <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140526133727.009C2E009B@blue.fi.intel.com>
Date: Mon, 26 May 2014 16:37:26 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Smith wrote:
> >> Mirrored mapping is absolutely required by several
> >> independent proprietary platforms I'm aware of, and remap_file_pages()
> >> has historically been the only sane way to accomplish this. (i.e.,
> >> shm_open(), mmap(NULL, 2^(n+1) pages), remap_file_pages() on 2nd
> >> half).
> >
> > Em.. What's wrong with shm_open() + two mmap()s to cover both halfs?
> >
> > fd = shm_open();
> > addr1 = mmap(NULL, 2*SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> > addr2 = mmap(addr1 + SIZE, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, 0);
> >
> > Is there a reason why it doens't work?
> 
> Your addr2 mmap() call is a bit incorrect semantically and
> syntactically (you skipped the length arg).

My bad.

> The addr2 request will fail because mmap() does not implicitly munmap()
> occupied virtual address space.

Please, consider reading man page for mmap(2). MAP_FIXED in particular.

> Even if you did that, the following still has a race
> condition between the addr2 request and another thread grabbing the
> same virtual space, which nothing short of a lock on all threads'
> mmap()-ing logic can protect:
> 
> addr1 = mmap(NULL, 2*SIZE, PROT_READ, MAP_SHARED, fd, 0);
> munmap(addr1 + SIZE, SIZE);
> /* race on virtual address space here, but n/a for remap_file_pages() ... */
> addr2 = mmap(addr1, SIZE, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);

No. MAP_FIXED will do the job: it does munmap() + mmap() atomically from
userspace POV.

> >> but failing that, a reservation API would need
> >> to be created (possibly a MAP_RESERVE flag) that would set aside a
> >> region that could only be subsequently mapped via explicit
> >> address-requesting mmap() calls.
> >
> > I don't get this part.
> 
> I'm proposing that a call along the lines of mmap(NULL, len, prot,
> MAP_RESERVED | ..., fd, offset) could return a virtual address block
> that is -not- actually mapped but -is- protected from other mmap()
> calls not explicitly requesting the space via their addr parameters.
> Unfortunately, you'd also need to define separate semantics to
> un-reserving not-mapped space, etc.

You're inventing a wheel. All you need is there for ages. And in portable
way.

-- 
 Kirill A. Shutemov
