Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaEZJnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:43:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:12887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaEZJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,911,1392192000"; 
   d="scan'208";a="517756677"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jeff Smith <jsmith.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140526094240.B5508E009B@blue.fi.intel.com>
Date: Mon, 26 May 2014 12:42:40 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Smith wrote:
> On Mon, May 19, 2014 at 9:38 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, May 19, 2014 at 05:35:40PM +0300, Kirill A. Shutemov wrote:
> >> >From functional POV, emulation *should* be identical to original
> >> remap_file_pages(), but slower. It would be nice, if you test it early.
> >>
> >> It's not clear yet how long emulation will be there.
> >
> > Stop right there.  We found out about two real life users of
> > remap_file_pages() already, without even committing the patches to warn
> > about using it to any tree.
> >
> > I think at this point the whole idea of removing the API should be dead
> > on the floor, as we do not needlessly break userspace programs.
> >
> > If we can get rid of the ugly guts and provide a good enough emulation
> > that the user won't cry I'd love to get rid of this cruft, but even
> > that doesn't look certain yet.
> 
> Sorry for being late to the party, but I just noticed this proposal
> via the LWN summary byline.
> 
> I wanted to comment that Kenny's use case is (I believe) quite
> widespread. I've used the technique since ~2008, and I've come across
> other people in subsequent jobs who independently developed the same
> technique. Mirrored mapping is absolutely required by several
> independent proprietary platforms I'm aware of, and remap_file_pages()
> has historically been the only sane way to accomplish this. (i.e.,
> shm_open(), mmap(NULL, 2^(n+1) pages), remap_file_pages() on 2nd
> half).

Em.. What's wrong with shm_open() + two mmap()s to cover both halfs?

fd = shm_open();
addr1 = mmap(NULL, 2*SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
addr2 = mmap(addr1 + SIZE, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, 0);

Is there a reason why it doens't work?

> It may not be individuals who are involved in the kernel development
> scene to any great extent, but I am sure that remap_file_pages() being
> deprecated would seriously piss off a lot of individuals. The pattern
> has even had a section in the Wikipedia article for quite some time:
> http://en.wikipedia.org/wiki/Circular_buffer#Mirroring

I believe remap_file_pages() is abused here. But it seems we will have to
keep emulation in place for a long time.

> 
> It would be most preferable from a user standpoint to keep the
> existing system intact, but failing that, a reservation API would need
> to be created (possibly a MAP_RESERVE flag) that would set aside a
> region that could only be subsequently mapped via explicit
> address-requesting mmap() calls.

I don't get this part.

-- 
 Kirill A. Shutemov
