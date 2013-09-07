Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab3IGM13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 08:27:29 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61996 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3IGM11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 08:27:27 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tero Kristo <t-kristo@ti.com>, Mark Rutland <Mark.Rutland@arm.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ian campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
Date: Sat, 07 Sep 2013 14:27:22 +0200
Message-ID: <1984707.GmRl1S5nrO@flatron>
User-Agent: KMail/4.11.1 (Linux/3.10.10-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <522A267B.4010200@wwwdotorg.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <52297BE2.8010603@ti.com> <522A267B.4010200@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 of September 2013 13:01:15 Stephen Warren wrote:
> On 09/06/2013 12:53 AM, Tero Kristo wrote:
> > On 09/05/2013 11:30 PM, Stephen Warren wrote:
> ...
> 
> >> 1)
> >> 
> >> At least for large SoCs (rather than e.g. a simple clock generator
> >> chip/crystal with 1 or 2 outputs), clock drivers need a *lot* of
> >> data.
> >> We can either:
> >> 
> >> a) Put that data into the clock driver, so it's "just there" for the
> >> clock driver to use.
> >> 
> >> b) Represent that data in DT, and write code in the clock driver to
> >> parse DT when the driver probe()s.
> >> 
> >> Option (a) is very simple.
> > 
> > How can you claim option (a) to be very simple compared to (b)? I
> > think
> > both are as easy / or hard to implement.
> 
> Well, the work required for (b) is a pure super-set of the work require
> for (a), so clearly (a) is less work (perhaps the issue you're debating
> is harder/easier rather than more/less work?)

+1

> >> Option (b) entails writing (and executing) a whole bunch of DT
> >> parsing
> >> code.It's a lot of effort to define the DT binding for the data,
> >> convert the data into DT format, and write the parsing code. It
> >> wastes
> >> execution time at boot. In the end, the result of the parsing is
> >> exactly the same data structures that could have been embedded into
> >> DT in the first place. This seems like a futile effort.
> > 
> > Not really, consider a new SoC where you don't have any kind of data
> > at
> > all. You need to write the data tables anyway, whether they are under
> > DT or some kernel data struct.
> 
> Yes.
> 
> But beyond writing the data tables, you also don't/do have to write all
> the DT parsing code based on choosing (a) or (b), etc.

+1

> > The execution time remain in place for
> > parsing DT data though, but I wouldn't think this to be a problem.
> > Also, you should consider multiarch ARM kernel, where same kernel
> > binary should support multiple SoCs, this would entail having clock
> > data for all built in to the kernel, which can be a problem also.
> 
> There's no reason that the clock data has to be built into the kernel at
> all; we should support even SoC clock drivers as modules in an initrd.
> Alternatively, drop the unused data from the kernel after boot via
> __init or similar. Alternatively, "pre-link" the clock driver module
> into the kernel in a way that allows it to be unloaded after boot even
> though it was built-in.

Well, at least in case of all Samsung platforms, you need a functional 
clock driver for system boot-up, to initialize timers needed for 
scheduling (their frequencies are derived from rates of input clocks), 
ungate clocks of IP blocks and so on. This means that clocks must be 
available at early stage of kernel boot-up.

This doesn't imply, though, that clocks data will have to be built into 
the kernel in future. At the moment I don't think our driver model or 
initramfs handling is flexible enough to provide loadable modules with 
drivers that can be probed and possibly deferred at such early init. 
However, looking at future multiplatform kernels, it's hard to imagine 
using huge kernels packed with a lot of built-in drivers for every 
supported platform, so definitely a way to separate them from the kernel 
image will be needed.

> > You can just as easily claim that anything internal to SoC should be
> > left out from DT, as this is cast in stone (or rather, silicon) also.
> > We should only use it to describe board layout. Everything else, the
> > kernel can 'know' by compile time.
> 
> I did, immediately below:-) And then I went on to explain why that's
> necessary in many cases.
> 
> ...
> 
> > I can turn this around, as you went to this road. Why have DT at all?
> 
> I believe (at least for ARM) the idea was to avoid churn to the kernel
> for supporting the numerous different *boards*.
> 
> The kernel needs and contains drivers for HW blocks, and so since
> they're there, they may as well encode everything about the HW block.
> 
> However, in most cases, the kernel shouldn't contain drivers for boards;
> boards are built from various common components which have drivers. DT
> is used to describe how those components are inter-connected. Hence, we
> can hopefully remove all board-related churn from the kernel (once the
> DT files are moved out of the kernel).

I fully second this. That's why we have #interrupt-cells and one 
interrupt-controller node, instead of a bunch of single interrupt nodes. 
That's why we also have #gpio-cells and not nodes of single GPIO pins, 
although a shadow of the infamous idea of gpio- or pinctrl-simple is still 
visible, even here in this thread.

Moreover, if we look at this from a wider perspective, if we start to 
describe IP internals in device tree and make drivers rely on this, what 
happens when someone reuse the same IP or chip on an ACPI-driven x86 
system? (Intel already makes x86 based SoCs...)

If the driver had all the data about the IP inside, then ACPI, device tree 
or FEX^W any other hardware description method, even static platform 
drivers with static resources, could easily instantiate the driver, which 
would just work, regardless of the platform. Otherwise, the driver would 
need a glue retrieving data about the IP for every used description 
system. Is it something we are supposed to cope with?

> > Personally I hate the whole idea of a devicetree, however am forced to
> > use it as somebody decided it is a good idea to have one. It doesn't
> > really solve any problems, it just creates new ones in a way of
> > political BS where everybody claims they know how DT should be used,
> > and this just prevents people from actually using it at all. Also, it
> > creates just one new unnecessary dependency for boot, previously we
> > had bootloader and kernel images which had to be in sync, now we have
> > bootloader + DT + kernel. What next? Maybe we should move the clock
> > data into a firmware file of its own?
> 
> Well, I can sympathize, but I think the time is past for debating that.
> 
> > Why do you care so much what actually goes into the devicetree?

Well, why do we care so much what actually goes into the kernel? I believe 
both are the same reasons.

> To get DT right.
> 
> Even if we went back to board files and mach-xxx specific code rather
> than cleanly separated drivers, it would still be beneficial to have
> much more oversight of board/mach-xxx code than there was previously.
> Board files made it very easy to do SoC-specific hacks. To avoid that,
> in either DT or board files, we're trying to impose standards so that we
> pick correct, generic, appropriate solutions, rather than letting
> everyone run of with isolated ad-hoc solutions.

+1

> > Shouldn't people be let use it how they see fit?

This question can be easily reworded to: Shouldn't people be let to use 
whatever hacks they find enough for their own things to work?

> > For the clock
> > bindings
> > business this is the same, even if the bindings are there, you are
> > free
> > to use them if you like, and if you don't like them, you can do things
> > differently.
> 
> We'd be better of creating as much standardization as possible, so that
> all SoCs/boards/.. work as similarly as possible, and we achieve maximal
> code reuse, design-reuse, and allow people to understand everything
> rather than just one particular SoC's/board's solution.
> 
> If we don't get some re-use and standardization out of DT, we really may
> as well just use board files.

Well, I believe that board files could give us the same standardization 
level, but... _only_ if done correctly. The problem with board files was 
that they allowed many kinds of different hacks without really any level 
of control over contents of board files.

On the contrary, device tree enforces a lot of things and even if it takes 
some freedom from people which need to use it, it helps to keep things 
standardized.

Best regards,
Tomasz

