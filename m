Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbAJVAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:00:30 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58223 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbAJVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <4665410.x9Uu42bKmJ@wuerfel>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<20150110003540.GA32037@node.dhcp.inet.fi>
	<CA+55aFz74hjhCcdz5J4r-xK4KW7oqNDA3i=jXHW0prGMMwgMvw@mail.gmail.com>
	<4665410.x9Uu42bKmJ@wuerfel>
Date: Sat, 10 Jan 2015 13:00:27 -0800
X-Google-Sender-Auth: M530JVPRPSgG3Fkj-NXvUSTgLBI
Message-ID: <CA+55aFxphoLdFkwkVFQ87Q8EbYNqFAE-n0yTvCSOJzSO2MtDgw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 12:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On a recent kernel, I get 628 MB for storing all files of the
> kernel tree in 4KB pages, and 3141 MB for storing the same data
> in 64KB pages, almost exactly factor 5, or 2.45 GiB wasted.

Ok, so it's even worse than it used to be.  Partly because the tree
has grown, partly because I did the math for 16kB and 64kB is just
hugely worse.

I did the math back in the days when the PPC people were talking about
16kB pages (iirc - it's been closer to a decade, so I might
misremember the details).

And back then, with 4kB pages I could cache the kernel tree twice over
in 1GB, and have enough left to run a graphical desktop. So enough
memory to build a tree and also enough to have two kernel trees and do
"diff -urN" between them.

Of course, back then, 1-2GB was the usual desktop memory size, so the
"I can do kernel development in 1GB without excessive IO" mattered to
me in ways it wouldn't today.

And it was before "git", so the whole "two kernel trees and do diffs
between them" was a real concern.

With 16kB pages, I think I had to have twice the memory for the same loads.

> IIRC, AIX works great with 64k pages, but only because of two
> reasons that don't apply on Linux:

.. there's a few other ones:

 (c) nobody really runs AIX on dekstops. It's very much a DB load
environment, with historically some HPC.

 (d) the powerpc TLB fill/buildup/teardown costs are horrible, so on
AIX the cost of lots of small pages is much higher too.

Now obviously, we *could* try to have a 64kB page size, and then do
lots of tricks to actually allocate file caches in partial pages in
order to avoid the internal fragmentation costs. HOWEVER:

 - that obviously doesn't help with the page management overhead (in
fact, it hurts). So it would be purely about trying to optimize for
bad TLB's.

 - that adds a *lot* of complexity to the VM. The coherency issues
when you may need to move cached information between partial pages and
full pages (required for mmap, but *most* files don't get mmap'ed)
would actually be pretty horrible.

 - all of this cost and complexity wouldn't help at all on x86, so it
would be largely untested and almost inevitably broken crap.

so I feel pretty confident in saying it won't happen. It's just too
much of a bother, for little to no actual upside. It's likely a much
better approach to try to instead use THP for anonymous mappings.

                            Linus
