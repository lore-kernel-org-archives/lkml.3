Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3J2WNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:13:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3J2WN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:13:29 -0400
Date: Tue, 29 Oct 2013 23:13:24 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131029221324.GC12814@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
 <20131029205756.GH9568@quack.suse.cz>
 <CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-10-13 14:33:53, Linus Torvalds wrote:
> On Tue, Oct 29, 2013 at 1:57 PM, Jan Kara <jack@suse.cz> wrote:
> > On Fri 25-10-13 10:32:16, Linus Torvalds wrote:
> >>
> >> It definitely doesn't work. I can trivially reproduce problems by just
> >> having a cheap (==slow) USB key with an ext3 filesystem, and going a
> >> git clone to it. The end result is not pretty, and that's actually not
> >> even a huge amount of data.
> >
> >   I'll try to reproduce this tomorrow so that I can have a look where
> > exactly are we stuck. But in last few releases problems like this were
> > caused by problems in reclaim which got fed up by seeing lots of dirty
> > / under writeback pages and ended up stuck waiting for IO to finish. Mel
> > has been tweaking the logic here and there but maybe it haven't got fixed
> > completely. Mel, do you know about any outstanding issues?
> 
> I'm not sure this has ever worked, and in the last few years the
> common desktop memory size has continued to grow.
> 
> For servers and "serious" desktops, having tons of dirty data doesn't
> tend to be as much of a problem, because those environments are pretty
> much defined by also having fairly good IO subsystems, and people
> seldom use crappy USB devices for more than doing things like reading
> pictures off them etc. And you'd not even see the problem under any
> such load.
> 
> But it's actually really easy to reproduce by just taking your average
> USB key and trying to write to it. I just did it with a random ISO
> image, and it's _painful_. And it's not that it's painful for doing
> most other things in the background, but if you just happen to run
> anything that does "sync" (and it happens in scripts), the thing just
> comes to a screeching halt. For minutes.
  Yes, I agree that caching more than couple of seconds worth of writeback
for a device isn't good.

> Same obviously goes with trying to eject/unmount the media etc.
> 
> We've had this problem before with the whole "ratio of dirty memory"
> thing. It was a mistake. It made sense (and came from) back in the
> days when people had 16MB or 32MB of RAM, and the concept of "let's
> limit dirty memory to x% of that" was actually fairly reasonable. But
> that "x%" doesn't make much sense any more. x% of 16GB (which is quite
> the reasonable amount of memory for any modern desktop) is a huge
> thing, and in the meantime the performance of disks have gone up a lot
> (largely thanks to SSD's), but the *minimum* performance of disks
> hasn't really improved all that much (largely thanks to USB ;).
> 
> So how about we just admit that the whole "ratio" thing was a big
> mistake, and tell people that if they want to set a dirty limit, they
> should do so in bytes? Which we already really do, but we default to
> that ratio nevertheless. Which is why I'd suggest we just say "the
> ratio works fine up to a certain amount, and makes no sense past it".
> 
> Why not make that "the ratio works fine up to a certain amount, and
> makes no sense past it" be part of the calculations. We actually
> *hace* exactly that on HIGHMEM machines, where we have this
> configuration option of "vm_highmem_is_dirtyable" that defaults to
> off. It just doesn't trigger on nonhighmem machines (today: "64-bit").
> 
> So I would suggest that we just expose that "vm_highmem_is_dirtyable"
> on 64-bit too, and just say that anything over 1GB is highmem. That
> means that 32-bit and 64-bit environments will basically act the same,
> and I think it makes the defaults a bit saner.
> 
> Limiting the amount of dirty memory to 100MB/200MB (for "start
> background writing" and "wait synchronously" respectively) even if you
> happen to have 16GB of memory sounds like a good idea. Sure, it might
> make some benchmarks a bit slower, but it will at least avoid the
> "wait forever" symptom. And if you really have a very studly IO
> subsystem, the fact that it starts writing out earlier won't really be
> a problem.
  So I think we both realize this is only about what the default should be.
There will always be people who have loads which benefit from setting dirty
limits high but I agree they are minority. The reason why we left the
limits at what they are now despite them having less and less sence is that
we didn't want to break user expectations. If we cap the dirty limits as
you suggest, I bet we'll get some user complaints and "don't break users"
policy thus tells me we shouldn't do such changes ;)

Also I'm not sure capping dirty limits at 200MB is the best spot. It may be
but I think we should experiment with numbers a bit to check whether we
didn't miss something.
 
> After all, there are two reasons to do delayed writes:
> 
>  - temp-files may not be written out at all.
> 
>    Quite frankly, if you have multi-hundred-megabyte temptiles, you've
> got issues
  Actually people do stuff like this e.g. when generating ISO images before
burning them.

>  - coalescing writes improves throughput
> 
>    There are very much diminishing returns, and the big return is to
> make sure that we write things out in a good order, which a 100MB
> buffer should make more than possible.
  True.

  There is one more aspect:
- transforming random writes into mostly sequential writes

  Different userspace programs use simple memory mapped databases which do
random writes into their data files. The less you writeback these the
better (at least from throughput POV). I'm not sure how large are these
files together on average user desktop though but my guess would be that
100 MB *should* be enough for them. Can anyone with GNOME / KDE desktop try
running with limits set this low for some time?
 
> so I really think that it's insane to default to 1.6GB of dirty data
> before you even start writing it out if you happen to have 16GB of
> memory.
> 
> And again: if your benchmark is to create a kernel tree and then
> immediately delete it, and you used to do that without doing any
> actual IO, then yes, the attached patch will make that go much slower.
> But for that benchmark, maybe you should just set the dirty limits (in
> bytes) by hand, rather than expect the default kernel values to prefer
> benchmarks over sanity?
> 
> Suggested patch attached. Comments?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
