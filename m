Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaEJQNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 12:13:13 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:57450 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaEJQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 12:13:11 -0400
Message-ID: <536E5011.4020304@gmail.com>
Date: Sat, 10 May 2014 18:13:05 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/3] Berlin SoC clock tree - DT or not DT?
References: <1399580212-30183-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399580212-30183-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise,

I just noticed that I didn't send the cover letter itself to the
list. Anyway, I decided to review the whole clock mess again and
came up with a quite nice set of patches which split clocks between
DT- and code-registered clocks.

Actually, I need Alexandre to (re-)add BG2Q support first, but if he
is busy, I'll send the preliminary version on Sunday or Monday.

@Mike: I know it is late in the cycle, but I'd love to see this in
for the next release already. There are functional bugs for sure,
but actually Berlin SoC support is so minimal, there is nothing we
can really break. I'll put that in the real patch set's cover letter
again, but when I send it, I will have prepared a topic branch of it
and put it into linux-next to make sure, it doesn't break others.

If you NAK taking it for the next release, we would have to squeeze
in some DT tweaks with fixed-clocks as placeholders for the missing
clocks. Antonine and Alexandre are doing a great job adding
functionality to Berlin SoCs but, of course, lack clocks here and
there. Using DT fixed-clocks would be ok now, but proper clock nodes
even if the corresponding drivers are buggy would be best.

I have compared driver generated frequencies with Marvell's BSP
u-boot clock report and they match, so it isn't too buggy :P

@Alexandre, Antoine:
The latest set of patches is at
https://github.com/shesselba/linux-berlin.git topic/clk

Please have a look at it and prepare BG2Q patches that I can
add/squeeze to it. Also, if you have comments already, do not
hesitate to send them directly to me.

Sebastian

On 05/08/2014 10:16 PM, Sebastian Hesselbarth wrote:
> This is a RFC providing a counter-approach to some patches set by
> Alexandre Belloni [1][2] to bring clock support for Berlin SoCs.
> It is based on those and final patches will include Alexandre's
> Signed-off again, I just dropped it for the RFC.
> 
> I am really unsure what is the best way to represent this in DT
> and/or code, i.e. where to split this up. I's appreciate any
> valuable discussion about it.
> 
> On Berlin SoCs, clock registers reside in global registers together
> with e.g. pin ctrl, pad ctrl, reset, and general purpose regs used
> for secondary boot address.
> 
> Actually, the situation isn't as bad as I initially thought, i.e.
> regarding clocks there is only two types of PLLs, some
> mux/divider/gate cells, and some separate muxes and gates.
> 
> What bothers me most is, there is *always* one that is different from
> the others, e.g.
> 
> - mux/divider/gate cells either have some bits in registers shared
>   with other cells *or* have their own register
> - some cells are missing the gate, some have no mux
> - some m/d/g cells have their shared bits in the same register, some
>   in consecutive registers
> 
> To find a good representation in either code or DT that fits all,
> quickly becomes messy. Anyway, we somehow have to deal with it, so
> here is what I think are the three options:
> 
> a) One single "Berlin2 Clock Tree" DT node (this RFC)
> 
> We basically hide all the gory details of the register mess above
> behind a single clock provider and index each leaf-clock by some
> number. The pro is that DT doesn't get messed up, the con is that
> there is a bunch of structs that each MULTIARCH kernel has to carry
> around (currently ~13k). I tried to put it all in __initconst/data
> so at least it can be free'd later.
> 
> b) Represent each PLL, M/D/G cell, and the single muxes/gates in DT
> 
> Well, the opposite of (a) i.e. exposing all the different register
> offsets and shifts as properties. The pro is that most of the code
> will move to DT which is only used by Berlin SoCs. The con is
> definitely that we have to link all the clocks in DT and therefore
> quickly get up to ~30 clock providers with a lot of clocks each.
> 
> c) Find the way in the middle
> 
> After looking long enough on the register mess, there is some blocks
> that can be separated from each other. Basically it is each of the
> PLLs, the single register dividers, and the rest. This still requires
> a bunch of DT clocks but has far less clock providers. We still need
> to provide some offset/shift properties as BG2/BG2CD's and BG2Q's cells
> are slightly different.
> 
> I know, (c) sounds like the best option. But given the pain I went
> through reading this register set includes (no datasheet available
> of course), I really want some opinions about all three alternatives
> first before touching this code ever again.
> 
> I'd appreciate any review and comments about the three patches attached
> to this RFC *and* to the general approaches above. I just sent the
> drivers and left out anything else, e.g. DT binding docs, Makefile/
> Kconfigs, aso. Also, the patches are not in the correct (bisectable)
> order but sorted by "controversity".
> 
> Sebastian
> 
> [1] https://lkml.org/lkml/2014/4/23/831
> [2] https://lkml.org/lkml/2014/4/24/624
> 
> Sebastian Hesselbarth (3):
>   clk: berlin: add clock tree driver for BG2/BG2CD
>   clk: berlin: add driver for BG2x complex divider cells
>   clk: berlin: add driver for BG2x simple PLLs
> 
>  drivers/clk/berlin/berlin2-div.c | 261 +++++++++++++++++
>  drivers/clk/berlin/berlin2-pll.c | 104 +++++++
>  drivers/clk/berlin/bg2.c         | 615 +++++++++++++++++++++++++++++++++++++++
>  drivers/clk/berlin/common.h      | 124 ++++++++
>  4 files changed, 1104 insertions(+)
>  create mode 100644 drivers/clk/berlin/berlin2-div.c
>  create mode 100644 drivers/clk/berlin/berlin2-pll.c
>  create mode 100644 drivers/clk/berlin/bg2.c
>  create mode 100644 drivers/clk/berlin/common.h
> 

