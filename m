Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3BROqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:46:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3BROq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:46:29 -0500
Date: Mon, 18 Feb 2013 14:46:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
Message-ID: <20130218142440.GA29814@suse.de>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
 <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos>
 <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com>
 <20130214150810.GA26095@gmail.com>
 <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
 <20130215114425.GD26955@gmail.com>
 <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 10:26:30AM -0800, Linus Torvalds wrote:
> On Fri, Feb 15, 2013 at 3:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> c060f943d092 may be related as you config does not have
> >> CONFIG_SPARSEMEM defined.
> >
> > Right, that's the commit causing the x86 regression:
> >
> >  c060f943d0929f3e429c5d9522290584f6281d6e is the first bad commit
> >  commit c060f943d0929f3e429c5d9522290584f6281d6e
> >  Date:   Fri Jan 11 14:31:51 2013 -0800
> >
> >      mm: use aligned zone start for pfn_to_bitidx calculation
> 
> Ok, looking more at this, I don't really want to revert it, and I have
> an idea of what is wrong.
> 
> When we allocate the zone use bitmap, we do not take the
> zone_start_pfn into account. So I *think* that what happens is that
> "pfn_to_bitidx()" simply overruns the allocation for unaligned zonesm
> and the spinlock just happens to be right after (or the overrun causes
> some other memory corruption that then indirectly causes the spinlock
> corruption).
> 

More likely the latter. I'd expect the usemap to be adjacent to the
zone->wait_table because of when they are allocated by the bootmem
allocator. This would break wait_on_page_[locked|writeback] at the very
least. If page_waitqueue() returned a corrupt pointer from the wait table
then it would lead to further corruption elsewhere each time wait_on_page_foo
was called.

> So I'm wondering if the fix is simply something like the attached
> patch. It takes the zone_start_pfn into account when allocating the
> zone bitmap.
> 
> Laura? Mel?
> 

Looks correct to me and should cc stable@vger.kernel.org

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
