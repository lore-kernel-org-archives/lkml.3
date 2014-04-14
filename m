Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaDNVNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:13:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbaDNVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:12:58 -0400
Date: Mon, 14 Apr 2014 23:12:54 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140414231254.392c0df8@endymion.delvare>
In-Reply-To: <20140414191143.GA26864@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
	<20140414191143.GA26864@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 14 Apr 2014 12:11:43 -0700, Greg KH wrote:
> On Mon, Apr 14, 2014 at 02:53:59PM +0200, Jean Delvare wrote:
> > Configuring kernels from scratch has become an incredibly long and
> > tedious task. The reason is that the number of drivers and options has
> > exploded in the past few years. Which in itself is great - Linux is
> > successful, yeah! - but the side effects must be dealt with.
> > 6000-line .config files are no fun.
> > 
> > Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
> > configuration. The two ethernet drivers below this menu are for ARM
> > machines. I really shouldn't be asked about that on x86-64. I just sent
> > a patch addressing this specific issue, which follows about 50 similar
> > patches from me for similar issues in various subsystems. But I can't
> > do all of that by myself, this is too much work quantitatively, and I
> > am not always the best person to find out the proper hardware
> > dependencies that should be added.
> 
> Ideally, the arch doesn't matter at all for a driver, only the
> infrastructure the driver depends on does.  So perhaps the
> "infrastructure" dependancy should be added for the drivers that you
> feel are only present on ARM platforms?

The infrastructure dependencies are already present and correct as far
as I can tell. In this specific case, NET_CADENCE depends on HAS_IOMEM
and the two actual drivers depend on HAS_DMA. I suppose this is
sufficient, otherwise there would have been build failures reported by
now.

>  Are these all platform devices?

In the case above, yes. But I don't quite see how that makes a
difference. x86 has platform drivers too, they are the essence of the
mfd framework. Almost every architecture can have platform drivers,
just like almost every platform can have PCI devices. I have been
adding dependencies on X86_32 for PCI drivers recently, for example.

I'm very fine with USB drivers being architecture-agnostic. They really
are. But in practice a lot of PCI and platform drivers are only useful
of one architecture, of a few ones at best.

Now I can understand that maybe you would prefer that we separate actual
dependencies from usefulness into separate "name spaces". For example
each driver could have a "target" statement where you say which
architectures are expected to need that driver. Then we could have an
option "hide all drivers which aren't for me". In fact I was about to
propose that in my initial post, but on second thought I had the
feeling that this was mostly duplicating what COMPILE_TEST already
achieves but under a different name. We'd need a compelling reason to
make things more complex, and I don't see such a reason at the moment
(I'm opened to discussion though.)

> > I would like to call for proper hardware dependencies to become a
> > general trend: every new hardware-specific driver which is added to the
> > kernel should depend on ($hardware || COMPILE_TEST), so as to make it
> > clear right away, which type of hardware is expected to need the driver
> > in question.
> 
> Adding more COMPILE_TEST dependancies for platform drivers would be
> wonderful to have, and make your life a little bit easier.  Other than
> that, a simple 'm' selection for a distro config should be fine :)

Huh, please, no. "Just say m if you don't know" was fine in the late
90s, when Linux was mostly x86. You could afford including 3% of
useless drivers, and people working on other architectures said "no" by
default and only included the few drivers they needed.

But today things have changed. We have a lot of very active, mature
architectures, with a bunch of existing drivers and a batch of new
drivers coming with every new kernel version. Saying "m" to everything
increases build times beyond reason. You also hit build failures you
shouldn't have to care about, depmod takes forever, updates are slow as
hell. This is the problem I am trying to solve.

openSUSE 13.1 for x86_64 comes with 2629 (modular) device drivers. In
comparison, openSUSE 11.4 came with 2301 device drivers. So we added at
least 328 new drivers in 2.5 years. How many of these are actually
useful on x86_64? My estimate is less than half. Most likely less than
one third. Quite possibly less than one quarter. We did not see that
many totally new devices in the (PC) x86 world lately, really.

In just two months, only looking at the drivers which happened to cross
my road for one reason or another, I already found about 50 drivers
which were included in openSUSE x86_64 and are are totally useless
there. There is probably 10 times that amount still waiting to be found
and disabled.

And it's not going to get any better over time. As others have already
mentioned, most new drivers these days are NOT for x86, they are for
ARM, AVR32 and other fancy embedded architectures.

"Just say m to everything" is just so wrong today that at SUSE we are
very close to switching our policy to "just say no to everything and
wait for people to complain about missing drivers." This may not sound
too appealing but this is the only way to keep the kernel package at a
reasonable size (and build time), as long as upstream doesn't help us
make smarter decisions. Useless modules aren't free, they aren't even
cheap.

Ideally I would like to be able to run "make oldconfig" on a new kernel
version and only be asked about things I should really care about. And
I'm sure every distro kernel package maintainer and most kernel
developers and advanced users feel the same.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
