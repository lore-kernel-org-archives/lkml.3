Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaDOKyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:54:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaDOKyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:54:17 -0400
Date: Tue, 15 Apr 2014 12:54:13 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140415125413.302d1ce1@endymion.delvare>
In-Reply-To: <20140415045214.GA32541@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
	<20140414191143.GA26864@kroah.com>
	<20140414231254.392c0df8@endymion.delvare>
	<20140415045214.GA32541@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 14 Apr 2014 21:52:14 -0700, Greg KH wrote:
> On Mon, Apr 14, 2014 at 11:12:54PM +0200, Jean Delvare wrote:
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

"If it's a PCI card" is the key conditional here. Most PCI "devices"
out there do not come in the form of PCI cards. They are embedded into
processors, south bridges, north bridges etc. They are, in essence,
"platform devices", which in turn makes their drivers "platform
drivers", even though they get registered within the kernel using
pci_register_driver().

For all these drivers, depending on a specific architecture or platform
makes sense.

> > (...)
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
> What is the build time difference you are seeing?

I'm not seeing a build time "difference" at this point, as we don't know
yet exactly which drivers can be omitted. That's the problem which
started this discussion ;-)

What I do see is build times which look excessive. Or, at the very
least, have room for improvement.

> I do 'allmodconfig'
> builds all the time, with over 3000 modules.  The build works just fine
> on "modern" hardware.

Well, when you build an "allmodconfig" kernel, you get what you asked
for, and that's fine. That's not what distro kernel people do. Also,
distro kernels are many. We have 34 kernel flavors for openSUSE 13.1
for example. And every commit potentially triggers a rebuild of the
whole set, to catch regressions as fast as possible. So every module we
build for no good reason, gets built a hundred times each day.

> Cutting out 100 modules might speed it up a bit,
> but really, is that a big deal overall?

I don't think we're talking about only 100 modules there, more like
1000. Not that I wouldn't want to clean things up even if that was only
100 useless modules, but please don't minimize the importance of the
problem. The exact number is very difficult to evaluate, as evaluating
it would basically require almost the same effort as actually fixing
all the driver dependencies.

Also, again, it's not only a matter of build time. I can only quote
myself: "You also hit build failures you shouldn't have to care about,
depmod takes forever, updates are slow as hell." No matter how powerful
your build farm is, these additional problems still exist.

So please don't lose the focus. The question I raised is "how to help
people generate sane kernel configuration files", not "how to help
people build their kernel faster". The improved build time is only a
(very) nice side effect.

> > openSUSE 13.1 for x86_64 comes with 2629 (modular) device drivers. In
> > comparison, openSUSE 11.4 came with 2301 device drivers. So we added at
> > least 328 new drivers in 2.5 years. How many of these are actually
> > useful on x86_64? My estimate is less than half.
> 
> And really, that's only 130 new modules a year or so, with all of the
> new hardware coming out, is that really a lot?

The absolute number doesn't mean much. The important point is how many
of these we actually need. Most new PC devices are handled by adding
their IDs to existing drivers. Sometimes with a lot of code additions
(think new Radeon graphics cards for example) but in most cases it
doesn't take a new driver. The new drivers, these days, are for
embedded devices.

> Yes, it's a pain for distros, and yes, it would be nice if people wrote
> better Kconfig help text.  Pushing back on that is the key here.  If you
> see new drivers show up that you don't know where they work on, ask the
> developers and make up patches.

That would be a very good start, yes. I get very grumpy when a new
Kconfig option is added and the Kconfig help text doesn't give me a
clue if I should enable it or not. As a kernel maintainer, I do push
back when I have to. But as a developer / distro kernel maintainer, I
am mostly the victim of other kernel maintainers not pushing back.

But even if we got perfect Kconfig help texts, updating a distribution
to the next kernel version would still be much easier if we only had to
answer the 10 questions which really matter to us, rather than 50
questions, 40 of which end up being "no" because they don't even make
sense for us. These "no" take time. Hence my request that developers
and maintainers add hardware dependencies whenever that makes sense.

> > Most likely less than one third. Quite possibly less than one quarter.
> > We did not see that many totally new devices in the (PC) x86 world
> > lately, really.
> 
> There are a lot of new devices out there, and we are dragging in tons of
> previously out-of-tree drivers in.  Look at the huge explosion of the
> IIO drivers that we now have, supporting hundreds of new types of
> sensors.  

IIO is the typical example of drivers which can currently be built
everywhere while only useful on embedded architectures. Thanks for
proving my point ;-) That was an easy one though, in openSUSE we ended
up disabling CONFIG_IIO altogether in all non-arm configs. What's a lot
more difficult to deal with are subsystems where each driver
individually may or may not be useful for a specific architecture /
platform. For example network device drivers, GPIO drivers, I2C bus
drivers, hwmon drivers, MFD... Everything where the functionality
itself is generic but the implementations aren't.

> We have new bus types, coming from the work done by CERN and
> other research groups.  We have wacky co-processor boards, and odd huge
> iron controller boards.  All of these work on x86 platforms.

They work there, yes. Are they useful there? Maybe. Are they used on
"traditional x86" (aka PC / server)? I very much doubt it.

Not all of this can necessarily be expressed with dependencies on
Kconfig symbols which exist today. It may make sense to introduce new
symbols to define per-usage subsets of a given architecture (e.g.
X86_PC or X86_EMBEDDED), or even perpendicular target selection ("What
device type is this kernel for? CONFIG_CELLPHONE / CONFIG_TABLET ...),
to make configuration easier. But I believe that just starting with
what is already available should already help a lot.

> Yes lots of drivers are moving out of the arm SOC area into the
> "generic" part of the kernel, and that's a good thing.  Lots of those IP
> blocks are now showing up on x86 platforms as well, as that processor
> goes after the previously-arm-only markets (we have examples of that in
> the USB gadget area of the kernel).

I'm perfectly happy with "depends on (X86 || ARM || COMPILE_TEST)" if
that corresponds to reality. That will make PPC people happy at
least :-) I didn't claim that adding that type of dependencies will
magically achieve the perfect kernel config for my specific case, I'm
just saying that such dependencies would help (me and others) a lot.

> > In just two months, only looking at the drivers which happened to cross
> > my road for one reason or another, I already found about 50 drivers
> > which were included in openSUSE x86_64 and are are totally useless
> > there. There is probably 10 times that amount still waiting to be found
> > and disabled.
> 
> Great, but were all of these new in the past year?  :)

No, I believe most of the ones I found and fixed were older. But I
don't quite see how it matters. The problem isn't new. Simply I think
it's easier to get the dependencies right on new drivers than on
existing drivers, which is why I propose that we start there. Just like
we require than new drivers pass checkpatch.pl, while old drivers don't
get deleted is they do not. But I certainly don't want to discourage
people from adding dependencies on existing drives, in fact I would
encourage them to do that.

> > And it's not going to get any better over time. As others have already
> > mentioned, most new drivers these days are NOT for x86, they are for
> > ARM, AVR32 and other fancy embedded architectures.
> > 
> > "Just say m to everything" is just so wrong today that at SUSE we are
> > very close to switching our policy to "just say no to everything and
> > wait for people to complain about missing drivers." This may not sound
> > too appealing but this is the only way to keep the kernel package at a
> > reasonable size (and build time), as long as upstream doesn't help us
> > make smarter decisions. Useless modules aren't free, they aren't even
> > cheap.
> 
> I'd argue that your build systems need to get faster, the laptop I'm
> typing this on can do a full modconfig build, with over 3000 modules, in
> around 20 minutes.  My build server in the cloud can do that in less
> than 5 minutes, and that's not a very fast machine these days.

Electricity isn't free, hardware isn't free, rack slot count is finite
and server room space is limited over here.

I don't quite see why we should invest in new hardware to shorten the
build times, if the same can be achieved with our current hardware
simply with better configuration files. Plus there is no reason to
choose between the two. We can have new hardware _and_ better configs
and improve the build times further :-) So your proposal is off-topic
to some degree.

And really, I don't see why I should have to wait for 10 minutes for my
build to complete if half of that is spent building drivers that will
never be used. The fact that 10 minutes is "reasonable" is irrelevant.

Of course, if the Linux Foundation, or you personally, are willing to
buy me a brand new workstation with more CPU power than I currently
have, I'll gladly accept. You can also donate your powerful laptop to
the OBS project, they'll be happy to add it to their build farm ;-)

> > Ideally I would like to be able to run "make oldconfig" on a new kernel
> > version and only be asked about things I should really care about. And
> > I'm sure every distro kernel package maintainer and most kernel
> > developers and advanced users feel the same.
> 
> I agree, but partitioning all new drivers off to a single arch might be
> hard to do.  It's not a simple problem, I'd suggest getting a faster
> build box to start with :)

I know it's not simple, but we could start with the low-hanging fruits,
which I believe are many. What I'm really asking for is not "all new
drivers partitioned to a single arch", but "new drivers partitioned to
whatever arch or platform dependencies make sense where applicable." I
don't think this is unreasonable.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
