Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaEZATj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 20:19:39 -0400
Received: from mail-ve0-f195.google.com ([209.85.128.195]:54068 "EHLO
	mail-ve0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaEZATi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 20:19:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140519143837.GA5228@infradead.org>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<20140519143837.GA5228@infradead.org>
Date: Sun, 25 May 2014 19:19:37 -0500
Message-ID: <CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Jeff Smith <jsmith.lkml@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 9:38 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 19, 2014 at 05:35:40PM +0300, Kirill A. Shutemov wrote:
>> >From functional POV, emulation *should* be identical to original
>> remap_file_pages(), but slower. It would be nice, if you test it early.
>>
>> It's not clear yet how long emulation will be there.
>
> Stop right there.  We found out about two real life users of
> remap_file_pages() already, without even committing the patches to warn
> about using it to any tree.
>
> I think at this point the whole idea of removing the API should be dead
> on the floor, as we do not needlessly break userspace programs.
>
> If we can get rid of the ugly guts and provide a good enough emulation
> that the user won't cry I'd love to get rid of this cruft, but even
> that doesn't look certain yet.

Sorry for being late to the party, but I just noticed this proposal
via the LWN summary byline.

I wanted to comment that Kenny's use case is (I believe) quite
widespread. I've used the technique since ~2008, and I've come across
other people in subsequent jobs who independently developed the same
technique. Mirrored mapping is absolutely required by several
independent proprietary platforms I'm aware of, and remap_file_pages()
has historically been the only sane way to accomplish this. (i.e.,
shm_open(), mmap(NULL, 2^(n+1) pages), remap_file_pages() on 2nd
half).

It may not be individuals who are involved in the kernel development
scene to any great extent, but I am sure that remap_file_pages() being
deprecated would seriously piss off a lot of individuals. The pattern
has even had a section in the Wikipedia article for quite some time:
http://en.wikipedia.org/wiki/Circular_buffer#Mirroring

It would be most preferable from a user standpoint to keep the
existing system intact, but failing that, a reservation API would need
to be created (possibly a MAP_RESERVE flag) that would set aside a
region that could only be subsequently mapped via explicit
address-requesting mmap() calls.

Thanks for any consideration of these concerns.
--Jeff
