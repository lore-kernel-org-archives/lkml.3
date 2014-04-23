Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaDWSNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:13:10 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47564 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaDWSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:13:08 -0400
Date: Wed, 23 Apr 2014 11:11:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: 3.15rc2 hanging processes on exit.
In-Reply-To: <CA+55aFziPHmSP5yjxDP6h_hRY-H2VgWZKsqC7w8+B9d9wXqn6Q@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1404231057470.2678@eggly.anvils>
References: <20140422180308.GA19038@redhat.com> <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com> <alpine.LSU.2.11.1404221303060.6220@eggly.anvils> <20140423144901.GA24220@redhat.com>
 <CA+55aFziPHmSP5yjxDP6h_hRY-H2VgWZKsqC7w8+B9d9wXqn6Q@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Linus Torvalds wrote:
> On Wed, Apr 23, 2014 at 7:49 AM, Dave Jones <davej@redhat.com> wrote:
> >
> > So for reasons I can't figure out, I've not been able to hit it on 3.14

Thanks for trying.  Not the reassuring answer that I was hoping for,
so I'd better give it a little more thought, to see if we have some
reason in 3.15-rc why it should now appear.  Not worth spending too
much effort on, though: Linus's fix looked good whatever.

> > The only 'interesting' thing I've hit in overnight testing is this, which
> > I'm not sure if I've also seen in my .15rc testing, but it doesn't look
> > familiar to me.  (Though the vm oopses I've seen the last few months
> > are starting to all blur together in my memory)
> >
> >
> > kernel BUG at mm/mlock.c:82!
> 
> That's
> 
>   mlock_vma_page:
>     BUG_ON(!PageLocked(page));
> 
> which is odd, because:
> 
> > Call Trace:
> >  [<ffffffffbe196612>] try_to_unmap_nonlinear+0x2a2/0x530
> >  [<ffffffffbe1972a7>] rmap_walk+0x157/0x320
> >  [<ffffffffbe1976e3>] try_to_unmap+0x93/0xf0
> >  [<ffffffffbe1bb8f6>] migrate_pages+0x3b6/0x7b0
> 
> All the calls to "try_to_unmap()" in mm/migrate.c are preceded by the pattern
> 
>         if (!trylock_page(page)) {
>                  ....
>                 lock_page(page);
>         }

Yes, that's true of the mm/migrate.c end, but the nonlinear
try_to_unmap_cluster() (Being unable to point directly to the desired
page) does this thing of unmapping a cluster of (likely unrelated) pages,
in the hope that if it keeps getting called repeatedly, it will sooner or
later have unmapped everything required.

> 
> where there are just a few "goto out" style cases for the "ok, we're
> not going to wait for this page lock" in there.
> 
> Very odd.  Does anybody see anything I missed?

Easily explained (correct me if I'm wrong): Dave is reporting this from
his testing of 3.14, but Linus is looking at his 3.15-rc git tree, which
now contains

commit 57e68e9cd65b4b8eb4045a1e0d0746458502554c
Author: Vlastimil Babka <vbabka@suse.cz>
Date:   Mon Apr 7 15:37:50 2014 -0700
    mm: try_to_unmap_cluster() should lock_page() before mlocking

precisely to fix this (long-standing but long-unnoticed) issue,
which Sasha reported a couple of months ago.

Hugh
