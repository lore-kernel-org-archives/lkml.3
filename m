Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3BRItn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:49:43 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:56713 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3BRItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:49:42 -0500
Date: Mon, 18 Feb 2013 09:49:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
Message-ID: <20130218084937.GC15989@gmail.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Right, that's the commit causing the x86 regression:
> >
> >  c060f943d0929f3e429c5d9522290584f6281d6e is the first bad commit
> >  commit c060f943d0929f3e429c5d9522290584f6281d6e
> >  Date:   Fri Jan 11 14:31:51 2013 -0800
> >
> >      mm: use aligned zone start for pfn_to_bitidx calculation
> 
> Ok, looking more at this, I don't really want to revert it, 
> and I have an idea of what is wrong.
> 
> When we allocate the zone use bitmap, we do not take the 
> zone_start_pfn into account. So I *think* that what happens is 
> that "pfn_to_bitidx()" simply overruns the allocation for 
> unaligned zonesm and the spinlock just happens to be right 
> after (or the overrun causes some other memory corruption that 
> then indirectly causes the spinlock corruption).
> 
> So I'm wondering if the fix is simply something like the 
> attached patch. It takes the zone_start_pfn into account when 
> allocating the zone bitmap.
> 
> Laura? Mel?
> 
> Ingo, can you test this? I was going to do the 3.8 today, but 
> I guess I can just wait, and if you can test this we could get 
> it in..

Yes, your patch fixes the bug: with the patch applied to 
f741656d646f plus the failing .config the system booted up
just fine.

I also double checked that vanilla upstream f741656d646f still 
locks up - so it's your patch that made the difference.

Tested-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
