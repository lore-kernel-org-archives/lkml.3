Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaBRN2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:28:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbaBRN2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:28:31 -0500
Message-ID: <53035FE2.4080300@redhat.com>
Date: Tue, 18 Feb 2014 08:28:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCHv2 0/2] mm: map few pages around fault address if
 they are in page cache
References: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com> <CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>
In-Reply-To: <CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 02:01 PM, Linus Torvalds wrote:

>  - increment the page _mapcount (iow, do "page_add_file_rmap()"
> early). This guarantees that any *subsequent* unmap activity on this
> page will walk the file mapping lists, and become serialized by the
> page table lock we hold.
> 
>  - mb_after_atomic_inc() (this is generally free)
> 
>  - test that the page is still unlocked and uptodate, and the page
> mapping still points to our page.
> 
>  - if that is true, we're all good, we can use the page, otherwise we
> decrement the mapcount (page_remove_rmap()) and skip the page.
> 
> Hmm? Doing something like this means that we would never lock the
> pages we prefault, and you can go back to your gang lookup rather than
> that "one page at a time". And the race case is basically never going
> to trigger.
> 
> Comments?

What would the direct io code do when it runs into a page with
elevated mapcount, but for which a mapping cannot be found yet?

Looking at the code, it looks like the above scheme could cause
some trouble with invalidate_inode_pages2_range(), which has
the following sequence:

                        if (page_mapped(page)) {
				... unmap page
			}
                        BUG_ON(page_mapped(page));

In other words, it looks like incrementing _mapcount first could
lead to an oops in the truncate and direct IO code.

The page lock is used to prevent such races.

*sigh*

-- 
All rights reversed
