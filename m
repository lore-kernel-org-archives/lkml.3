Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159AbaKNOhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:37:01 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47465 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaKNOg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:36:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141113235840.GS26481@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
	<1415051968-4878-5-git-send-email-marek@goldelico.com>
	<5463585D.9070209@ti.com>
	<20141112150210.GC26481@atomide.com>
	<5464969F.30708@ti.com>
	<20141113182848.GQ26481@atomide.com>
	<alpine.DEB.2.02.1411132251320.17030@utopia.booyaka.com>
	<20141113235840.GS26481@atomide.com>
Date: Fri, 14 Nov 2014 16:36:58 +0200
Message-ID: <CANOLnONkQu-BBvZH5nb+VngCxq=xnk60JkTd6Jha1uFt2j8gJQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
From: Grazvydas Ignotas <notasas@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robh+dt@kernel.org, Tero Kristo <t-kristo@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, bcousson@baylibre.com,
        galak@codeaurora.org, Grant Likely <grant.likely@linaro.org>,
        Marek Belisko <marek@goldelico.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 1:58 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Paul Walmsley <paul@pwsan.com> [141113 15:01]:
>> Hi
>>
>> On Thu, 13 Nov 2014, Tony Lindgren wrote:
>>
>> > * Tomi Valkeinen <tomi.valkeinen@ti.com> [141113 03:33]:
>> > > On 12/11/14 17:02, Tony Lindgren wrote:
>> > >
>> > > >> And, with a quick grep, I see CONTROL_DEVCONF1 touched in multiple
>> > > >> places in the kernel. I wonder if adding a pinmux entry for it could
>> > > >> cause some rather odd problems.
>> > > >
>> > > > They can all use pinctrl-single no problem.
>> > >
>> > > Can, but don't. That's my worry. If we touch the DEVCONF1 via pinmux,
>> > > and we have code in mach-omap2 that also touch DEVCONF1, without any
>> > > knowledge (and locking) between those...
>> >
>> > Hmm yeah the McBSP clock mux could be racy as the mux register for
>> > McBSP is treated as a clock. This register muxes the clock between
>> > external pin and internal clock. Considering that this should be
>> > selectable at board level as the external clock probably needs to be
>> > used if level shifters are being used, it should be really handled by
>> > pinctrl-single.
>> >
>> > The other use for hsmmc.c and pdata-quirks.c for the one time mux for
>> > MMC clock from the MMC clock pin. That can be done with pinctrl-single
>> > from the MMC driver too for DT based booting.
>> >
>> > Then we just have the save and restore of the registers for
>> > off-idle.
>> >
>> > > So _maybe_ that's not an issue, as the pinmux config we have here is
>> > > fixed, and done once at boot time, and maybe the code in mach-omap2 that
>> > > touch DEVCONF1 is also ran just once and not at the same time as the
>> > > pinmux. But I don't know if that's so.
>> >
>> > It seems we could just do a read-only check for McBSP in the clock
>> > code for the mux register, or even completely drop that code from
>> > cclock3xxx_data.c and start using the pinctrl for that mux.
>> >
>> > Paul & Tero, got any comments here?
>>
>> It's best to move all of the SCM register reads/writes to an SCM IP block
>> driver.  This driver would be the only entity that would touch the SCM IP
>> block registers - no other code on the system would touch it (perhaps
>> aside from anything needed for early init).  The SCM driver would enforce
>> mutual exclusion via a spinlock, so concurrent SCM register modifications
>> wouldn't flake out.  Then the SCM driver would register clocks with the
>> CCF, register pins with the pinctrl subsystem, etc. etc.
>
> We actually do have that with pinctrl-single + syscon. We certainly
> need to implement more Linux framework drivers for the SCM registers.
> Things like regulators, clocks, and PHYs, but they should use
> pinctrl-single + syscon. See the the pbias-regulator.c for example.
>
> Looking at the McBSP clock handling, threre's yet more handling of
> the same DEVCONF1 mux register in omap2_mcbsp_set_clks_src that gets
> alled from omap_mcbsp_dai_set_dai_sysclk.
>
> To me it seems that if we handle the DEVCONF with pinctrl-single, we
> don't need most of the McBSP fck code or the omap2_mcbsp_set_clks_src.
> Having the mux register as the clock enable register is not nice..
> Who knows what the clock coming from the external pin might be :)

How will audio do dynamic muxing without that code?
The pin must be remuxed back to internal clock when audio stops, or
else PM breaks.


Gražvydas
