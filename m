Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaDOBAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:00:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51597 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaDOBAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:00:13 -0400
X-Originating-IP: 209.216.165.100
Date: Mon, 14 Apr 2014 18:00:04 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140415010003.GA2765@jtriplet-mobl1>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
 <20140409060133.GA6766@gmail.com>
 <20140409081709.GA283@x4>
 <20140414103205.GA2846@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414103205.GA2846@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 12:32:05PM +0200, Ingo Molnar wrote:
> 
> * Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
> > On 2014.04.09 at 08:01 +0200, Ingo Molnar wrote:
> > > 
> > > * Andi Kleen <ak@linux.intel.com> wrote:
> > > 
> > > > On Tue, Apr 08, 2014 at 03:44:25PM -0700, Linus Torvalds wrote:
> > > > > On Tue, Apr 8, 2014 at 1:49 PM,  <josh@joshtriplett.org> wrote:
> > > > > >
> > > > > > In addition to making the kernel smaller and such (I'll leave the
> > > > > > specific stats there to Andi), here's the key awesomeness of LTO that
> > > > > > you, personally, should find useful and compelling: LTO will eliminate
> > > > > > the need to add many lower-level Kconfig symbols to compile out bits of
> > > > > > the kernel.
> > > > > 
> > > > > Actually that, to me, is a negative right now.
> > > > > 
> > > > > Since there's no way we'll make LTO the default in the foreseeable
> > > > > future, people starting to use it like that is just a bad bad thing.
> > > > > 
> > > > > So really, the main advantage of LTO would be any actual 
> > > > > optimizations it can do. And call me anal, but I want *numbers* 
> > > > > for that before I merge it. Not handwaving. I'm not actually aware 
> > > > > of how well - if at all - code generation actually improves.
> > > > 
> > > > Well it looks very different if you look at the generated code. gcc 
> > > > becomes a lot more aggressive.
> > > > 
> > > > But as I said there's currently no significant performance 
> > > > improvement known, so if your only goal is better performance this 
> > > > patch (as currently) known is not a big winner.  My suspicion is 
> > > > that's mostly because the standard benchmarks we run are not too 
> > > > compiler sensitive.
> > > > 
> > > > However the users seem to care about the other benefits, like code 
> > > > size.
> > > > 
> > > > And there may well be loads that are compiler sensitive. As Honza 
> > > > posted, for non kernel workloads LTO is known to have large 
> > > > benefits.
> > > > 
> > > > Besides at this point it's pretty much just some additions to the 
> > > > Makefiles.
> > > 
> > > So the reason I've been mostly ignoring the LTO patches myself (I only 
> > > took LTO related changes that had other justifications such as 
> > > cleanups) is that I've actually implemented full LTO in a userspace 
> > > project myself, and my experience was:
> > > 
> > >   1) There was very little if any measurable LTO runtime speedup, 
> > >      despite agressive GCC options and despite user-space generally 
> > >      offering more optimizations opportunities than kernel space.
> > > 
> > >   2) LTO with current build tools meant a 1.5x-3x build speed
> > >      slowdown (on a very fast box with tons of CPUs and RAM),
> > >      which made LTO essentially a non-starter for development
> > >      work. (And that was with the Gold linker.)
> > > 
> > > and looking at your characterisation of LTO you only conceded
> > > #1 much after you started pushing LTO and you are clearly trying
> > > to avoid talking about #2 while it's very much relevant...
> > > 
> > > I'm willing to be convinced by actual numbers, and LTO tooling might 
> > > eventually improve, etc., but right now LTO is much ado about very 
> > > little, being pushed in a somewhat dishonest way.
> > 
> > I did some measurements on Andi's lto-3.14 branch:
> > 
> > options    size     build time
> > ------------------------------
> > -O2        4408880  1:56.98
> > -flto -O2  4213072  2:36.22
> > -Os        3833248  1:45.13         
> > -flto -Os  3651504  2:34.51
> > 
> > This was measured on my AMD 4 core machine with a monolithic .config
> > where "CONFIG_MODULES is not set". The compiler is gcc trunk (4.9).
> > So on x86_86 you get 5% size reduction for 25-30% build time slowdown.
> 
> Note that the build slowdowns you measured are more like 30-45%:
> 
>    156.22/116.98 == 33.5% slowdown
>    154.51/105.13 == 46.9% slowdown
> 
> not 25-30%.
> 
> But yeah, that sounds about right and is obviously relevant data, and 
> goes beyond 'a bit slower' .
> 
> Also note that the 5% size reduction due to LTO consists of two big 
> parts:
> 
>   - removal of unused facilities in that .config
>   - true optimizations
> 
> it would be important to know the proportion of true optimizations, 
> because those are that matter most. Unused facilities will take up a 
> bit of RAM, and perhaps fragment the CPU cache a tiny bit, but aren't 
> nearly as relevant as true optimizations.

RAM usage and vmlinux size are worthwhile optimization goals as well,
and LTO makes a difference there, both directly (the 5% already
observed) and through additional changes (working to help LTO throw away
more unused code, such as helpers and lib/ bits).  And doing a better
job of compiling out unused bits means less proliferation of Kconfig
options; with LTO, we don't need a Kconfig option (and associated
dependencies added elsewhere) for every random helper or library
function.

> and it slows down 
> kernel development'.

No, it doesn't slow down development builds; it makes kernel builds
slower if and only if LTO is turned on, which most kernel developers
won't need to do.  On the other hand, distro and embedded kernels can do
so for final builds, and developers pushing to minimize the kernel can
turn it on for their own work as needed.

- Josh Triplett
