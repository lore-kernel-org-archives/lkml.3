Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaDOEtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:49:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaDOEtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:49:13 -0400
Date: Mon, 14 Apr 2014 21:52:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140415045214.GA32541@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
 <20140414191143.GA26864@kroah.com>
 <20140414231254.392c0df8@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414231254.392c0df8@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:12:54PM +0200, Jean Delvare wrote:
> Hi Greg,
> 
> On Mon, 14 Apr 2014 12:11:43 -0700, Greg KH wrote:
> > On Mon, Apr 14, 2014 at 02:53:59PM +0200, Jean Delvare wrote:
> > > Configuring kernels from scratch has become an incredibly long and
> > > tedious task. The reason is that the number of drivers and options has
> > > exploded in the past few years. Which in itself is great - Linux is
> > > successful, yeah! - but the side effects must be dealt with.
> > > 6000-line .config files are no fun.
> > > 
> > > Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
> > > configuration. The two ethernet drivers below this menu are for ARM
> > > machines. I really shouldn't be asked about that on x86-64. I just sent
> > > a patch addressing this specific issue, which follows about 50 similar
> > > patches from me for similar issues in various subsystems. But I can't
> > > do all of that by myself, this is too much work quantitatively, and I
> > > am not always the best person to find out the proper hardware
> > > dependencies that should be added.
> > 
> > Ideally, the arch doesn't matter at all for a driver, only the
> > infrastructure the driver depends on does.  So perhaps the
> > "infrastructure" dependancy should be added for the drivers that you
> > feel are only present on ARM platforms?
> 
> The infrastructure dependencies are already present and correct as far
> as I can tell. In this specific case, NET_CADENCE depends on HAS_IOMEM
> and the two actual drivers depend on HAS_DMA. I suppose this is
> sufficient, otherwise there would have been build failures reported by
> now.

That's good to hear.

> >  Are these all platform devices?
> 
> In the case above, yes. But I don't quite see how that makes a
> difference. x86 has platform drivers too, they are the essence of the
> mfd framework. Almost every architecture can have platform drivers,
> just like almost every platform can have PCI devices. I have been
> adding dependencies on X86_32 for PCI drivers recently, for example.
> 
> I'm very fine with USB drivers being architecture-agnostic. They really
> are. But in practice a lot of PCI and platform drivers are only useful
> of one architecture, of a few ones at best.

Why would PCI devices only be useful on one architecture?  PCI works on
almost all arches that Linux supports, if it's a PCI card, it could be
on any of those processors.  If it's a mini-pci, the chances are less,
but still quite possible.

> > > I would like to call for proper hardware dependencies to become a
> > > general trend: every new hardware-specific driver which is added to the
> > > kernel should depend on ($hardware || COMPILE_TEST), so as to make it
> > > clear right away, which type of hardware is expected to need the driver
> > > in question.
> > 
> > Adding more COMPILE_TEST dependancies for platform drivers would be
> > wonderful to have, and make your life a little bit easier.  Other than
> > that, a simple 'm' selection for a distro config should be fine :)
> 
> Huh, please, no. "Just say m if you don't know" was fine in the late
> 90s, when Linux was mostly x86. You could afford including 3% of
> useless drivers, and people working on other architectures said "no" by
> default and only included the few drivers they needed.
> 
> But today things have changed. We have a lot of very active, mature
> architectures, with a bunch of existing drivers and a batch of new
> drivers coming with every new kernel version. Saying "m" to everything
> increases build times beyond reason. You also hit build failures you
> shouldn't have to care about, depmod takes forever, updates are slow as
> hell. This is the problem I am trying to solve.

What is the build time difference you are seeing?  I do 'allmodconfig'
builds all the time, with over 3000 modules.  The build works just fine
on "modern" hardware.  Cutting out 100 modules might speed it up a bit,
but really, is that a big deal overall?

> openSUSE 13.1 for x86_64 comes with 2629 (modular) device drivers. In
> comparison, openSUSE 11.4 came with 2301 device drivers. So we added at
> least 328 new drivers in 2.5 years. How many of these are actually
> useful on x86_64? My estimate is less than half.

And really, that's only 130 new modules a year or so, with all of the
new hardware coming out, is that really a lot?

Yes, it's a pain for distros, and yes, it would be nice if people wrote
better Kconfig help text.  Pushing back on that is the key here.  If you
see new drivers show up that you don't know where they work on, ask the
developers and make up patches.

> Most likely less than one third. Quite possibly less than one quarter.
> We did not see that many totally new devices in the (PC) x86 world
> lately, really.

There are a lot of new devices out there, and we are dragging in tons of
previously out-of-tree drivers in.  Look at the huge explosion of the
IIO drivers that we now have, supporting hundreds of new types of
sensors.  We have new bus types, coming from the work done by CERN and
other research groups.  We have wacky co-processor boards, and odd huge
iron controller boards.  All of these work on x86 platforms.

Yes lots of drivers are moving out of the arm SOC area into the
"generic" part of the kernel, and that's a good thing.  Lots of those IP
blocks are now showing up on x86 platforms as well, as that processor
goes after the previously-arm-only markets (we have examples of that in
the USB gadget area of the kernel).

> In just two months, only looking at the drivers which happened to cross
> my road for one reason or another, I already found about 50 drivers
> which were included in openSUSE x86_64 and are are totally useless
> there. There is probably 10 times that amount still waiting to be found
> and disabled.

Great, but were all of these new in the past year?  :)

> And it's not going to get any better over time. As others have already
> mentioned, most new drivers these days are NOT for x86, they are for
> ARM, AVR32 and other fancy embedded architectures.
> 
> "Just say m to everything" is just so wrong today that at SUSE we are
> very close to switching our policy to "just say no to everything and
> wait for people to complain about missing drivers." This may not sound
> too appealing but this is the only way to keep the kernel package at a
> reasonable size (and build time), as long as upstream doesn't help us
> make smarter decisions. Useless modules aren't free, they aren't even
> cheap.

I'd argue that your build systems need to get faster, the laptop I'm
typing this on can do a full modconfig build, with over 3000 modules, in
around 20 minutes.  My build server in the cloud can do that in less
than 5 minutes, and that's not a very fast machine these days.

> Ideally I would like to be able to run "make oldconfig" on a new kernel
> version and only be asked about things I should really care about. And
> I'm sure every distro kernel package maintainer and most kernel
> developers and advanced users feel the same.

I agree, but partitioning all new drivers off to a single arch might be
hard to do.  It's not a simple problem, I'd suggest getting a faster
build box to start with :)

thanks,

greg k-h
