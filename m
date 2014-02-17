Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaBQTCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:02:01 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:54340 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaBQTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com>
Date: Mon, 17 Feb 2014 11:01:58 -0800
X-Google-Sender-Auth: _4zxbeJisZKhv5iuFbMXgh9SBGs
Message-ID: <CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>
Subject: Re: [RFC, PATCHv2 0/2] mm: map few pages around fault address if they
 are in page cache
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:38 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> Now we have ->fault_nonblock() to ask filesystem for a page, if it's
> reachable without blocking. We request one page a time. It's not terribly
> efficient and I will probably re-think the interface once again to expose
> iterator or something...

Hmm. Yeah, clearly this isn't working, since the real workloads all
end up looking like

>        115,493,976      minor-faults                                                  ( +-  0.00% ) [100.00%]
>       59.686645587 seconds time elapsed                                          ( +-  0.30% )
 becomes
>         47,428,068      minor-faults                                                  ( +-  0.00% ) [100.00%]
>       60.241766430 seconds time elapsed                                          ( +-  0.85% )

and

>        268,039,365      minor-faults                                                 [100.00%]
>      132.830612471 seconds time elapsed
becomes
>        193,550,437      minor-faults                                                 [100.00%]
>      132.851823758 seconds time elapsed

and

>          4,967,540      minor-faults                                                  ( +-  0.06% ) [100.00%]
>       27.215434226 seconds time elapsed                                          ( +-  0.18% )
becomes
>          2,285,563      minor-faults                                                  ( +-  0.26% ) [100.00%]
>       27.292854546 seconds time elapsed                                          ( +-  0.29% )

ie it shows a clear reduction in faults, but the added costs clearly
eat up any wins and it all becomes (just _slightly_) slower.

Sad.

I do wonder if we really need to lock the pages we fault in. We lock
them in order to test for being up-to-date and still mapped. The
up-to-date check we don't really need to worry about: that we can test
without locking by just reading "page->flags" atomically and verifying
that it's uptodate and not locked.

The other reason to lock the page is:

 - for anonymous pages we need the lock for rmap, so the VM generally
always locks the page. But that's not an issue for file-backed pages:
the "rmap" for a filebacked page is just the page mapcount and the
cgroup statistics, and those don't need the page lock.

 - the whole truncation/unmapping thing

So the complex part is racing with truncate/unmapping the page. But
since we hold the page table lock, I *think* what we should be able to
do is:

 - increment the page _mapcount (iow, do "page_add_file_rmap()"
early). This guarantees that any *subsequent* unmap activity on this
page will walk the file mapping lists, and become serialized by the
page table lock we hold.

 - mb_after_atomic_inc() (this is generally free)

 - test that the page is still unlocked and uptodate, and the page
mapping still points to our page.

 - if that is true, we're all good, we can use the page, otherwise we
decrement the mapcount (page_remove_rmap()) and skip the page.

Hmm? Doing something like this means that we would never lock the
pages we prefault, and you can go back to your gang lookup rather than
that "one page at a time". And the race case is basically never going
to trigger.

Comments?

                  Linus
