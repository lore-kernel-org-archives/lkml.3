Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaBROQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:16:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:19283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbaBROQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:16:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="485203869"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [RFC, PATCHv2 0/2] mm: map few pages around fault address if
 they are in page cache
Thread-Topic: [RFC, PATCHv2 0/2] mm: map few pages around fault address if
 they are in page cache
Thread-Index: AQHPLA+LtMkhTgsne06MzzyLvYMEt5q6U3MAgAE1CAD//3vEjg==
Date: Tue, 18 Feb 2014 14:15:59 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE04062DEA1@FMSMSX114.amr.corp.intel.com>
References: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>,<53035FE2.4080300@redhat.com>
In-Reply-To: <53035FE2.4080300@redhat.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.46]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't really need to lock all the pages being returned to protect against truncate.  We only need to lock the one at the highest index, and check i_size while that lock is held since truncate_inode_pages_range() will block on any page that is locked.

We're still vulnerable to holepunches, but there's no locking currently between holepunches and truncate, so we're no worse off now.
________________________________________
From: Rik van Riel [riel@redhat.com]
Sent: February 18, 2014 5:28 AM
To: Linus Torvalds; Kirill A. Shutemov
Cc: Andrew Morton; Mel Gorman; Andi Kleen; Wilcox, Matthew R; Dave Hansen; Alexander Viro; Dave Chinner; linux-mm; linux-fsdevel; Linux Kernel Mailing List
Subject: Re: [RFC, PATCHv2 0/2] mm: map few pages around fault address if they are in page cache

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
