Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3KARZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:25:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:43567 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab3KARZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:25:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,618,1378882800"; 
   d="scan'208";a="420961729"
Date: Sat, 2 Nov 2013 01:22:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Maxim Patlasov <mpatlasov@parallels.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131101172222.GA19478@localhost>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
 <20131029205756.GH9568@quack.suse.cz>
 <CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
 <20131029221324.GC12814@quack.suse.cz>
 <CA+55aFw_jjB687nJKuVdjPM6BicF-+0da-wSYHLBqdx0ZfVrGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_jjB687nJKuVdjPM6BicF-+0da-wSYHLBqdx0ZfVrGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

// Sorry for the late response! I'm in marriage leave these days. :)

On Tue, Oct 29, 2013 at 03:42:08PM -0700, Linus Torvalds wrote:
> On Tue, Oct 29, 2013 at 3:13 PM, Jan Kara <jack@suse.cz> wrote:
> >
> >   So I think we both realize this is only about what the default should be.
> 
> Yes. Most people will use the defaults, but there will always be
> people who tune things for particular loads.
> 
> In fact, I think we have gone much too far in saying "all policy in
> user space", because the fact is, user space isn't very good at
> policy. Especially not at reacting to complex situations with
> different devices. From what I've seen, "policy in user space" has
> resulted in exactly two modes:
> 
>  - user space does something stupid and wrong (example: "nice -19 X"
> to work around some scheduler oddities)
> 
>  - user space does nothing at all, and the kernel people say "hey,
> user space _could_ set this value Xyz, so it's not our problem, and
> it's policy, so we shouldn't touch it".
> 
> I think we in the kernel should say "our defaults should be what
> everybody sane can use, and they should work fine on average". With
> "policy in user space" being for crazy people that do really odd
> things and can really spare the time to tune for their particular
> issue.
> 
> So the "policy in user space" should be about *overriding* kernel
> policy choices, not about the kernel never having them.

Agreed totally. The kernel defaults should better be geared to the
typical use case by the majority users, unless it will lead to insane
behaviors in some less frequent but still relevant use cases.

> And this kind of "you can have many different devices and they act
> quite differently" is a good example of something complicated that
> user space really doesn't have a great model for. And we actually have
> much better possible information in the kernel than user space ever is
> likely to have.
> 
> > Also I'm not sure capping dirty limits at 200MB is the best spot. It may be
> > but I think we should experiment with numbers a bit to check whether we
> > didn't miss something.
> 
> Sure. That said, the patch I suggested basically makes the numbers be
> at least roughly comparable across different architectures. So it's
> been at least somewhat tested, even if 16GB x86-32 machines are
> hopefully pretty rare (but I hear about people installing 32-bit on
> modern machines much too often).

Yeah, it's interesting the new policy rule actually makes x86_64
behave more consistent with i386, and hence have been reasonably
tested.

> >>  - temp-files may not be written out at all.
> >>
> >>    Quite frankly, if you have multi-hundred-megabyte temptiles, you've
> >> got issues
> >   Actually people do stuff like this e.g. when generating ISO images before
> > burning them.
> 
> Yes, but then the temp-file is long-lived enough that it *will* hit
> the disk anyway. So it's only the "create temporary file and pretty
> much immediately delete it" case that changes behavior (ie compiler
> assembly files etc).
> 
> If the temp-file is for something like burning an ISO image, the
> burning part is slow enough that the temp-file will hit the disk
> regardless of when we start writing it.

The temp-file IO avoidance is an optimization not a guarantee. If a
user want to avoid IO seriously, he will probably use tmpfs and
disable swap.

So if we have to do some trade-offs in the optimization, I agree that
we should optimize more towards the "large copies to USB stick" use case.

The alternative solution, per-bdi dirty thresholds, could eliminate
the need to do such trade-offs. So it's worth looking at the two
solutions side by side.

> >   There is one more aspect:
> > - transforming random writes into mostly sequential writes
> 
> Sure. And I think that if you have a big database, that's when you do
> end up tweaking the dirty limits.

Sure. In general, whenever we have to make some tradeoffs, it's
probably better to "sacrifice" the embedded and super computing worlds
much more than the desktop. Because in the former areas, people tend
to have the skill and mind set to do customizations and optimizations.

I wonder if some hand-held devices will set dirty_background_bytes to
0 for better data safety.

> That said, I'd certainly like it even *more* if the limits really were
> per-BDI, and the global limit was in addition to the per-bdi ones.
> Because when you have a USB device that gets maybe 10MB/s on
> contiguous writes, and 100kB/s on random 4k writes, I think it would
> make more sense to make the "start writeout" limits be 1MB/2MB, not
> 100MB/200MB. So my patch doesn't even take it far enough, it's just a
> "let's not be ridiculous". The per-BDI limits don't seem quite ready
> for prime time yet, though. Even the new "strict" limits seems to be
> more about "trusted filesystems" than about really sane writeback
> limits.
> 
> Fengguang, comments?

Basically A) lowering the global dirty limit is a reasonable tradeoff,
and B) the time based per-bdi dirty limits seems like the ultimate
solution that could offer the sane defaults to your heart's content.

Since both will be user interface (including semantic) changes, we
have to be careful. It's obvious that if ever (B) can be implemented
properly and made mature quickly, it would be the best choice and will
eliminate the need to do (A). But as Mel said in the other email, (B)
is not that easy to implement...

> (And I added Maxim to the cc, since he's the author of the strict
> mode, and while it is currently limited to FUSE, he did mention USB
> storage in the commit message..).
 
The *bytes* based per-bdi limits are relatively easy. It's only a
question of code matureness. When exported user interface to the user
space, we can guarantee the exact limit to the user.

However for *time* based per-bdi limits, there will always be
estimation errors as summarized in Mel's email. It offers the sane
semantics to the user, however may not always work to the expectation,
since writeback bandwidth may change over time depending on the workload.

It feels much better to have some hard guarantee. So even when the
time based limits are implemented, we'll probably still want to
disable the slippery time/bandwidth estimation when the user is able
to provide some bytes based per-bdi limits: hey I don't care about
random writes etc. subtle situations. I know this disk's max write
bandwidth is 100MB/s and it's a good rule of thumb. Let's simply set
its dirty limit to 100MB.

Or shall we do the more simple and less volatile "max write bandwidth"
estimation and use it for auto per-bdi dirty limits?

Thanks,
Fengguang
