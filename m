Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbaD2JXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:23:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50475 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaD2JXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:23:17 -0400
Date: Tue, 29 Apr 2014 11:23:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140429092313.GA19146@xo-6d-61-c0.localdomain>
References: <20140414145359.48b7337c@endymion.delvare>
 <20140414191143.GA26864@kroah.com>
 <20140414231254.392c0df8@endymion.delvare>
 <20140415045214.GA32541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415045214.GA32541@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Configuring kernels from scratch has become an incredibly long and
> > > > tedious task. The reason is that the number of drivers and options has
> > > > exploded in the past few years. Which in itself is great - Linux is
> > > > successful, yeah! - but the side effects must be dealt with.
> > > > 6000-line .config files are no fun.
> > > > 
> > > > Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
> > > > configuration. The two ethernet drivers below this menu are for ARM
> > > > machines. I really shouldn't be asked about that on x86-64. I just sent
> > > > a patch addressing this specific issue, which follows about 50 similar
> > > > patches from me for similar issues in various subsystems. But I can't
> > > > do all of that by myself, this is too much work quantitatively, and I
> > > > am not always the best person to find out the proper hardware
> > > > dependencies that should be added.
> > > 
> > > Ideally, the arch doesn't matter at all for a driver, only the
> > > infrastructure the driver depends on does.  So perhaps the
> > > "infrastructure" dependancy should be added for the drivers that you
> > > feel are only present on ARM platforms?
> > 
> > The infrastructure dependencies are already present and correct as far
> > as I can tell. In this specific case, NET_CADENCE depends on HAS_IOMEM
> > and the two actual drivers depend on HAS_DMA. I suppose this is
> > sufficient, otherwise there would have been build failures reported by
> > now.
> 
> That's good to hear.
> 
> > >  Are these all platform devices?
> > 
> > In the case above, yes. But I don't quite see how that makes a
> > difference. x86 has platform drivers too, they are the essence of the
> > mfd framework. Almost every architecture can have platform drivers,
> > just like almost every platform can have PCI devices. I have been
> > adding dependencies on X86_32 for PCI drivers recently, for example.
> > 
> > I'm very fine with USB drivers being architecture-agnostic. They really
> > are. But in practice a lot of PCI and platform drivers are only useful
> > of one architecture, of a few ones at best.
> 
> Why would PCI devices only be useful on one architecture?  PCI works on
> almost all arches that Linux supports, if it's a PCI card, it could be
> on any of those processors.  If it's a mini-pci, the chances are less,
> but still quite possible.

Many machines (arm) have PCI but not PCI slot. It would be good to use that information
to reduce ammount of config questions.

> > Huh, please, no. "Just say m if you don't know" was fine in the late
> > 90s, when Linux was mostly x86. You could afford including 3% of
> > useless drivers, and people working on other architectures said "no" by
> > default and only included the few drivers they needed.
> > 
> > But today things have changed. We have a lot of very active, mature
> > architectures, with a bunch of existing drivers and a batch of new
> > drivers coming with every new kernel version. Saying "m" to everything
> > increases build times beyond reason. You also hit build failures you
> > shouldn't have to care about, depmod takes forever, updates are slow as
> > hell. This is the problem I am trying to solve.
> 
> What is the build time difference you are seeing?  I do 'allmodconfig'
> builds all the time, with over 3000 modules.  The build works just fine
> on "modern" hardware.  Cutting out 100 modules might speed it up a bit,
> but really, is that a big deal overall?

Well, cutting 100 config questions would be worth it.

I am configuring kernels for N900. After kernel learns, it is n900, it would be possible
to ask very little questions: it has no ISA, no PCI and set of devices on i2c / platform
bus is well known and well defined...


> There are a lot of new devices out there, and we are dragging in tons of
> previously out-of-tree drivers in.  Look at the huge explosion of the
> IIO drivers that we now have, supporting hundreds of new types of
> sensors.  We have new bus types, coming from the work done by CERN and
> other research groups.  We have wacky co-processor boards, and odd huge
> iron controller boards.  All of these work on x86 platforms.
> 
> Yes lots of drivers are moving out of the arm SOC area into the
> "generic" part of the kernel, and that's a good thing.  Lots of those IP
> blocks are now showing up on x86 platforms as well, as that processor
> goes after the previously-arm-only markets (we have examples of that in
> the USB gadget area of the kernel).

It would be better to actually update our Kconfig when IP block moves into
new area then giving up and asking our users all the time...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
