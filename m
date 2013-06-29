Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3F2SDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 14:03:22 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41243 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab3F2SDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:03:21 -0400
Date: Sat, 29 Jun 2013 13:03:18 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        holt@sgi.com, rob@landley.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, yinghai@kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-doc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [RFC] Transparent on-demand memory setup initialization
	embedded in the (GFP) buddy allocator
Message-ID: <20130629180318.GA83854@asylum.americas.sgi.com>
References: <51CBB2F7.3050604@numascale-asia.com> <51CDF417.3050406@sgi.com> <20130629072441.GA15394@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629072441.GA15394@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 09:24:41AM +0200, Ingo Molnar wrote:
> 
> * Nathan Zimmer <nzimmer@sgi.com> wrote:
> 
> > On 06/26/2013 10:35 PM, Daniel J Blueman wrote:
> > >On Wednesday, June 26, 2013 9:30:02 PM UTC+8, Andrew Morton wrote:
> > >>
> > >> On Wed, 26 Jun 2013 11:22:48 +0200 Ingo Molnar
> > ><mi...@kernel.org> wrote:
> > >>
> > >> > except that on 32 TB
> > >> > systems we don't spend ~2 hours initializing 8,589,934,592
> > >page heads.
> > >>
> > >> That's about a million a second which is crazy slow - even my
> > >prehistoric desktop
> > >> is 100x faster than that.
> > >>
> > >> Where's all this time actually being spent?
> > >
> > > The complexity of a directory-lookup architecture to make the 
> > > (intrinsically unscalable) cache-coherency protocol scalable gives you 
> > > a ~1us roundtrip to remote NUMA nodes.
> > >
> > > Probably a lot of time is spent in some memsets, and RMW cycles which 
> > > are setting page bits, which are intrinsically synchronous, so the 
> > > initialising core can't get to 12 or so outstanding memory 
> > > transactions.
> > >
> > > Since EFI memory ranges have a flag to state if they are zerod (which 
> > > may be a fair assumption for memory on non-bootstrap processor NUMA 
> > > nodes), we can probably collapse the RMWs to just writes.
> > >
> > > A normal write will require a coherency cycle, then a fetch and a 
> > > writeback when it's evicted from the cache. For this purpose, 
> > > non-temporal writes would eliminate the cache line fetch and give a 
> > > massive increase in bandwidth. We wouldn't even need a store-fence as 
> > > the initialising core is the only one online.
> > 
> > Could you elaborate a bit more? or suggest a specific area to look at?
> > 
> > After some experiments with trying to just set some fields in the struct 
> > page directly I haven't been able to produce any improvements.  Of 
> > course there is lots about the area which I don't have much experience 
> > with.
> 
> Any such improvement will at most be in the 10-20% range.
> 
> I'd suggest first concentrating on the 1000-fold boot time initialization 
> speedup that the buddy allocator delayed initialization can offer, and 
> speeding up whatever remains after that stage - in a much more 
> development-friendly environment. (You'll be able to run 'perf record 
> ./calloc-1TB' after bootup and get meaningful results, etc.)
> 
> Thanks,
> 
> 	Ingo

I had been focusing on the bigger gains but my attention had been diverted by
hope of an easy, alibiet smaller, win.


I have been experimenting with the patch proper, I am just doing 2MB pages for
the moment.  The improvement is vast,  I'll worry about proper numbers once I
think I have a fully working patch.

Some progress is being made on the real patch.  I think the memory is
being set up correctly, On aligned pages setting the up the page as normal
plus setting new PG_ flag. 

Right now I am trying to sort out free_pages_prepare and free_pages_check.

Thanks,
Nate



