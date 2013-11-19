Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3KSPIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:08:34 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52199 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751301Ab3KSPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:08:31 -0500
Date: Tue, 19 Nov 2013 15:07:43 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
Message-ID: <20131119150743.GG26487@arm.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
 <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
 <52898417.80601@nvidia.com>
 <20131118115842.GE4050@arm.com>
 <528AD11F.7060009@nvidia.com>
 <20131119122656.GF26487@arm.com>
 <CAAVeFuLkGGfUqVV88U44f1gN_3umD=PoTgHw241hLVLy4FRoLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuLkGGfUqVV88U44f1gN_3umD=PoTgHw241hLVLy4FRoLQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:29:39PM +0000, Alexandre Courbot wrote:
> On Tue, Nov 19, 2013 at 9:26 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Tue, Nov 19, 2013 at 02:46:55AM +0000, Alex Courbot wrote:
> >> 2) devices have already shipped with this firmware. Are we going to just
> >> renounce supporting them, even though the necessary support is
> >> lightweight and fits within already existing interfaces?
> >
> > I'm talking only about ARMv8 here. Please see my reply to Stephen for
> > the details of (not) reusing existing firmware.
> >
> >> I certainly do hope that for ARMv8 things will be different and more
> >> standardized. But that's not something that can be guaranteed unless ARM
> >> strongly enforces it to firmware vendors. In case such a non-standard
> >> firmware gets used again, I *do* hope that using cpu_ops will be
> >> preferred over saying "this device cannot be supported in mainline, ever".
> >
> > cpu_ops or firmware_ops is just a name and can be unified (TBD what
> > common functionality it contains). What I don't want to encourage is
> > each SoC registering its own firmware interface.
> 
> Sorry, are you talking about interface as in SMC interface, or as in
> cpu_operations/firmware_ops?

Both. I don't want to see platforms defining their own SMC interface for
no good reason. The cpu_ops/firmware_ops handling in the kernel is just
some naming but the key is having standard SMC interfaces for CPU
operations.

> >> The kernel already supports non-standard hardware, BIOS, ACPI through
> >> hacks that are *way* more horrible than that. This should certainly not
> >> be encouraged, but that's not a valid reason to forbid otherwise
> >> perfectly fine devices to run mainline IMHO.
> >
> > So you say we should just stop trying to standardise anything because
> > people don't care anyway. Why do we even bother with DT (or ACPI) since
> > board files were fine in the past (with a bit more code)?
> 
> Oh no, that's not what I am saying at all. Standardization is good.
> PSCI is good. Of course I would prefer that the secure monitor we use
> follow established conventions - that'd be less work to support it and
> less hassle to get my patches merged.
> 
> I may have misunderstood you, but I felt your mail sounded a bit like
> "we won't merge support for firmwares that do not follow PSCI".

Just to clarify it: I won't merge support for _ARMv8_ firmware that does
not follow a standard CPU booting/power protocol supported by Linux.
Currently we only support PSCI. If there is a need for another protocol
and a good proposal, I'm open for discussions.

The above is all related to having no SoC code under arch/arm64 (or
board files, whatever you want to call them).

> I
> agree that whenever it is possible to support a firmware through a
> standard interface, this should be done - no discussion. But right now
> I have two devices that are good representatives of Tegra 4 and
> available in stores, which I would like to see supported in mainline
> to satisfy requests from the community for Tegra development
> platforms, and also initiate the habit to support future
> NVIDIA-branded devices in mainline. Their secure monitor unfortunately
> does not follow PSCI or the SMC convention and needs a custom
> firmware_ops. Are they unworthy of mainline?

Are they ARMv8? Since we didn't have any such rules on ARMv7 and
earlier, standard secure interface is nice to have but should not
prevent upstreaming. I made this clear already that it is ARMv8 only,
please don't try to generalise it.

> And if, by sheer misfortune, the same thing happened on an ARMv8
> device (despite the EL1/EL3 separation), what would be the outcome?

If some people get it wrong and they have to work around firmware bugs
for devices already in the field, we may need to bend the rules (bugs do
happen, both in software and hardware). But definitely _not_ when people
don't even bother.

> IMHO, more devices in mainline is beneficial to everybody, and
> actually *encourages* SoC vendors/firmware providers to follow
> conventions. Banning devices is what triggers the kind of "screw it"
> reactions mentioned earlier,

By following some rules and doing things in a standard way (firmware
interface in this case), it is more likely that their SoC support
requires minimal kernel code and it's easier to upstream and maintain.

> and on the contrary once a device is in,
> you tend to make sure the next ones follow the kernel trends because
> you know you will need to support them in mainline as well and it will
> make your life easier.

Not really. The next device won't follow the kernel trends but just the
same non-standard way of doing things that were accepted in the first
place.

-- 
Catalin
