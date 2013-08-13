Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab3HMXKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:10:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:47479 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756090Ab3HMXKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:10:22 -0400
Date: Tue, 13 Aug 2013 18:10:20 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, Nathan Zimmer <nzimmer@sgi.com>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
	embedded in the buddy allocator
Message-ID: <20130813231020.GA22667@asylum.americas.sgi.com>
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com> <1376344480-156708-1-git-send-email-nzimmer@sgi.com> <CA+55aFwTQLexJkf67P0b7Z7cw8fePjdDSdA4SOkM+Jf+kBPYEA@mail.gmail.com> <520A6DFC.1070201@sgi.com> <CA+55aFwRHdQ_f6ryUU1yWkW1Qz8cG958jLZuyhd_YdOq4-rfRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwRHdQ_f6ryUU1yWkW1Qz8cG958jLZuyhd_YdOq4-rfRA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:51:37AM -0700, Linus Torvalds wrote:
> I realize that benchmarking cares, and yes, I also realize that some
> benchmarks actually want to reboot the machine between some runs just
> to get repeatability, but if you're benchmarking a 16TB machine I'm
> guessing any serious benchmark that actually uses that much memory is
> going to take many hours to a few days to run anyway? Having some way
> to wait until the memory is all done (which might even be just a silly
> shell script that does "ps" and waits for the kernel threads to all go
> away) isn't going to kill the benchmark - and the benchmark itself
> will then not have to worry about hittinf the "oops, I need to
> initialize 2GB of RAM now because I hit an uninitialized page".
> 
I am not overly concerned with cost having to setup a page struct on first
touch but what I need to avoid is adding more permanent cost to page faults
on a system that is already "primed".

> Ok, so I don't know all the issues, and in many ways I don't even
> really care. You could do it other ways, I don't think this is a big
> deal. The part I hate is the runtime hook into the core MM page
> allocation code, so I'm just throwing out any random thing that comes
> to my mind that could be used to avoid that part.
> 

The only mm structure we are adding to is a new flag in page->flags.
That didn't seem too much.

I had hoped to restrict the core mm changes to check_new_page and
free_pages_check but I haven't gotten there yet.

Not putting on uninitialized pages on to the lru would work but then I 
would be concerned over any calculations based on totalpages.  I might be
too paranoid there but having that be incorrect until after a system is booted
worries me.


Nate
