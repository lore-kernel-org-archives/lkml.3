Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3IEUbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:31:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50269 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab3IEUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:31:09 -0400
Message-ID: <5228EA02.3000200@wwwdotorg.org>
Date: Thu, 05 Sep 2013 14:30:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ian campbell <ian.campbell@citrix.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org> <20130830203334.10934.10011@quantum> <522110AA.7040700@wwwdotorg.org> <20130903232219.10934.67434@quantum> <52277DBF.7080104@wwwdotorg.org> <CAPtuhThWHP61FzDBCH5SSFx6kV7==VdF3-M=Lke+cgnrOQL7JQ@mail.gmail.com>
In-Reply-To: <CAPtuhThWHP61FzDBCH5SSFx6kV7==VdF3-M=Lke+cgnrOQL7JQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 12:29 PM, Mike Turquette wrote:
> On Wed, Sep 4, 2013 at 11:36 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 09/03/2013 05:22 PM, Mike Turquette wrote:
>>> Quoting Stephen Warren (2013-08-30 14:37:46)
>>>> On 08/30/2013 02:33 PM, Mike Turquette wrote:
>> ...
>>>>> The clock _data_ seems to always have some churn to it. Moving it out to
>>>>> DT reduces that churn from Linux. My concern above is not about kernel
>>>>> data size.
>>>>
>>>> That sounds like the opposite of what we should be doing.
>>>>
>>>> It's fine for kernel code/data to change; that's a natural part of
>>>> development. Obviously, we should minimize churn, through thorough
>>>> review, domain knowledge, etc.
>>>
>>> And with the "clock mapping" style bindings we'll end up changing both
>>> the DT binding definition and the kernel. Not great.
>>
>> What's a "clock mapping" style binding? I guess that means the style
>> where you have a single DT node that provides multiple clocks, rather
>> than one DT node per clock?
>>
>> If the kernel driver changes its internal data, I don't see why that
>> would have any impact at all on the DT binding definition. We should be
>> able to use one DT binding definition with arbitrary drivers.
> 
> Yes, I'm referring to a single node providing multiple clocks. As an
> example see the Exynos 5420 binding:
> Documentation/devicetree/bindings/clock/exynos5420-clock.txt
> 
> The clock id's are stored as part of the binding definition resulting
> in a mapping scheme that can be fragile.

The mapping shouldn't be fragile if e.g.
include/dt-bindings/clock/exynos5420.h were used to define the values.
That way, both the Exynos clock driver and Exynos DT files could both
include the header, and would always be in sync.

> There have already been
> patches to fix the id's assigned in the binding, which isn't supposed
> to happen because it's a stable interface.

That's definitely a real problem. The values should be stable.
Preferably, the values should be derived from some aspect of the HW, and
hence be stable.

For example, many clock IDs on Tegra are derived from the clock's bit
index within the peripheral clock enable registers. Although I must
admit we have a bit of a mess in the Tegra clocks w.r.t. mis-using clock
IDs for reset IDs and hence there are some peripheral clock IDS that
don't map 1:1 with the register, and there are other clocks which aren't
peripheral clocksthat we've assigned arbitrary IDs to rather than some
HW-derived ID.

Alternatively, perhaps a register address unique to the clock could be used.

If new values are added, the additions should all happen in a single
tree, and hence can be co-ordinated, thus avoiding any merge-conflicts.

Even ignoring HW-derived clock IDs, people writing DT bindings simply
need to get used to bindings being an ABI, and put extra effort into
making sure the list of clocks is accurate and complete.

Finally, while it's true that a DT binding definition is an ABI, and
perhaps DT content isn't (so if there's a DT content bug it can simply
be fixed), if DT is wrong because of insufficient thought about its
content, it's still wrong, and the system doesn't work correctly.
Whether we edit a kernel clock driver or a DT file to solve a problem,
there was still a problem. Placing the data into DT doesn't make it any
less likely there will be a problem if sufficient care isn't taken when
thinking about the clock structure.

> If clock phandles are
> created by individual nodes in DT then the binding definition need
> never be updated due to merge conflicts or renaming which plagues the
> mapping scenario.

That's true.

But if we take that approach, shouldn't we just ban #clock-cells?

The only case #clock-cells would still be legitimate would be an array
of identical clocks represented by a single node, and even then the
argument could be extended so say: just write out a node for each clock
in the array, just like if the clocks weren't in an array or were
different types.

>>> And I'll respond to your points below but the whole "relocate the
>>> problem to DT" argument is simply not my main point. What I want to do
>>> is increase the usefulness of DT by allowing register-level details into
>>> the binding which can
>>
>> Can you expand upon why a DT that encodes register-level details is more
>> useful? I can't see why there would be any difference in usefulness.
> 
> Sure. The usefulness comes out of the fact that we do not need to
> maintain data synchronization across dts and clock provider drivers.

Only the clock IDs. That's a very small amount of information. And
synchronizing the two simply means including a header file that defines
the IDs in both places. This is *exactly* why I created the
include/dt-bindings/ directory, to house such header files.

> The data lives in one place and only one place. We absolutely need a
> phandle to a clock in DT link clock consumer devices to their input
> clocks, so there is no question that should be in DT. Since we're
> already doing that, why not do away with trying to keep dts and C
> files in sync and just put all of the data in dts? It's a pure
> separation of logic and data. The Linux clock provider driver is
> purely logic and no data, which I imagine would appease the mind of
> many a computer scientist.

Separation of code and data is good. However, one can achieve that
simply by putting data into C structs/arrays, without having to parse it
out of DT.

> Can you return the favor and tell me why putting register level
> details into DT is inherently a bad idea? I'll drop my case if I can
> be convinced that putting that level is detail into DT is The Wrong
> Way, but I'll need more to go on than tradition and status quo.

Here are a few reasons, in no particular order:

1)

At least for large SoCs (rather than e.g. a simple clock generator
chip/crystal with 1 or 2 outputs), clock drivers need a *lot* of data.
We can either:

a) Put that data into the clock driver, so it's "just there" for the
clock driver to use.

b) Represent that data in DT, and write code in the clock driver to
parse DT when the driver probe()s.

Option (a) is very simple.

Option (b) entails writing (and executing) a whole bunch of DT parsing
code. It's a lot of effort to define the DT binding for the data,
convert the data into DT format, and write the parsing code. It wastes
execution time at boot. In the end, the result of the parsing is exactly
the same data structures that could have been embedded into DT in the
first place. This seems like a futile effort.

2)

If the clock driver knows it's running on e.g. Tegra20 vs. Tegra30, that
information alone is enough to fully describe all details of the clock
tree present within the SoC. That information is cast in stone in the
SoC HW design.

Philosophically, I believe DT should be used to describe what varies
between different uses of a HW block, not the internals of a HW block
itself. This means describing the environment around an IP block (e.g.
which interrupts sinks an I2C controller is connected to, which GPIOs a
board used for an SD card CD line), rather than the internals of a
block, which are completely fixed.

For clocks, this means that the routing of a clock module's
inputs/outputs are useful to describe in DT, since they may be connected
differently depending on which SoC a clock module is placed into, or
which board an SoC is placed into. However, the HW within the block is
fixed, so doesn't need to be represented by a data structure whose
intent is to represent environmental differences.

To be honest, I would rather not even put e.g. on-SoC I2C, SPI, SDHCI
controllers into DT, since they are 100% defined by the top-level SoC
node. However, in practice we must put those nodes into DT for a few
reasons:

a) They act as a container for the I2C/SPI devices that are connected to
them, so at least something has to exist in DT.

b) There's some board-specific parameterization of those controllers
such as max bus clock rate for I2C/SPI, bus width for SDHCI, which GPIOs
are used for CD/WP for SDHCI, or even whether the controller is
enabled/disabled.

c) Some of the resources those controllers use (IRQs, GPIOs) may also be
used by board-specific entities (e.g. off-SoC IRQ source or GPIO sink).
The on-SoC devices appear in DT in order to allow representation of the
IRQs/GPIOs they use in a consistent manner with off-SoCs devices, for
simplicity.

As such, we end up treating them much like any other off-SoC device in
terms of representing them as a DT node.

3)

Why are clocks a special case?

A "simple-gpio" controller binding and driver was proposed, and we had a
very similar conversation to this one then. I believe simple-gpio was
rejected for the reasons I presented above.

pintctrl-simple was initially rejected because it would have ended up
being essentially a very complex list of (register, value) writes that
the kernel performed at bootup. I'm not sure how pinctrl-simple finally
got accepted into the kernel; I think people were just busy and didn't
notice it and hence didn't object:-(

If we take the "DT should represent the register details" argument to
extreme, why not have some hyperbole? :-)

a) Do it for everything. For example, Tegra20 and Tegra30 I2S are
semantically the same, but with register offsets moved around rather
randomly. Perhaps we should have a mapping table of register field name
to offset, bit position, and size in DT, and some automated abstraction
layer in the kernel to parse this and re-direct all the register IO so
we can use a single driver.

To me this sounds a bit ridiculous, whereas putting all the clock
register details in DT perhaps doesn't (at least depending on exactly
what that ends up meaning). However, they're really exactly the same thing.

b) Why have drivers at all? Shouldn't the kernel just manage the core
ARM CPU, memory, MMU, and other standardized low-level tasks, yet all
drivers should be written in Forth with the byte-code stored in DT and
evaluated by the kernel instead? This even separates the driver code out
of the kernel, and really reduces churn:-)
