Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaBRS2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:28:14 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51180 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaBRS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140218180730.C2552E0090@blue.fi.intel.com>
References: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>
	<20140218175900.8CF90E0090@blue.fi.intel.com>
	<20140218180730.C2552E0090@blue.fi.intel.com>
Date: Tue, 18 Feb 2014 10:28:11 -0800
X-Google-Sender-Auth: MmAbS7BB0-nF0kid9GWt6Lx9Idc
Message-ID: <CA+55aFwEAYhhUijNUf1dRppzh=+5QfXTAdGQe8D_mJH77tPHug@mail.gmail.com>
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

On Tue, Feb 18, 2014 at 10:07 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> Patch is wrong. Correct one is below.

Hmm. I don't hate this. Looking through it, it's fairly simple
conceptually, and the code isn't that complex either. I can live with
this.

I think it's a bit odd how you pass both "max_pgoff" and "nr_pages" to
the fault-around function, though. In fact, I'd consider that a bug.
Passing in "FAULT_AROUND_PAGES" is just wrong, since the code cannot -
and in fact *must* not - actually fault in that many pages, since the
starting/ending address can be limited by other things.

So I think that part of the code is bogus. You need to remove
nr_pages, because any use of it is just incorrect. I don't think it
can actually matter, since the max_pgoff checks are more restrictive,
but if you think it can matter please explain how and why it wouldn't
be a major bug?

Apart from that, I'd really like to see numbers for different ranges
of FAULT_AROUND_ORDER, because I think 5 is pretty high, but on the
whole I don't find this horrible, and you still lock the page so it
doesn't involve any new rules. I'm not hugely happy with another raw
radix-tree user, but it's not horrible.

Btw, is the "radix_tree_deref_retry(page) -> goto restart" really
necessary? I'd be almost more inclined to just make it just do a
"break;" to break out of the loop and stop doing anything clever at
all.

IOW, from a quick look there's a couple of small details I don't like
that look odd, but ..

                Linus
