Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaKNHcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:32:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55627 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbaKNHco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:32:44 -0500
Message-ID: <5465AFF6.506@ti.com>
Date: Fri, 14 Nov 2014 09:32:06 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Marek Belisko <marek@goldelico.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <plagnioj@jcrosoft.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
References: <1415051968-4878-1-git-send-email-marek@goldelico.com> <1415051968-4878-5-git-send-email-marek@goldelico.com> <5463585D.9070209@ti.com> <20141112150210.GC26481@atomide.com> <5464969F.30708@ti.com> <20141113182848.GQ26481@atomide.com> <alpine.DEB.2.02.1411132251320.17030@utopia.booyaka.com> <20141113235840.GS26481@atomide.com>
In-Reply-To: <20141113235840.GS26481@atomide.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 01:58 AM, Tony Lindgren wrote:
> * Paul Walmsley <paul@pwsan.com> [141113 15:01]:
>> Hi
>>
>> On Thu, 13 Nov 2014, Tony Lindgren wrote:
>>
>>> * Tomi Valkeinen <tomi.valkeinen@ti.com> [141113 03:33]:
>>>> On 12/11/14 17:02, Tony Lindgren wrote:
>>>>
>>>>>> And, with a quick grep, I see CONTROL_DEVCONF1 touched in multiple
>>>>>> places in the kernel. I wonder if adding a pinmux entry for it could
>>>>>> cause some rather odd problems.
>>>>>
>>>>> They can all use pinctrl-single no problem.
>>>>
>>>> Can, but don't. That's my worry. If we touch the DEVCONF1 via pinmux,
>>>> and we have code in mach-omap2 that also touch DEVCONF1, without any
>>>> knowledge (and locking) between those...
>>>
>>> Hmm yeah the McBSP clock mux could be racy as the mux register for
>>> McBSP is treated as a clock. This register muxes the clock between
>>> external pin and internal clock. Considering that this should be
>>> selectable at board level as the external clock probably needs to be
>>> used if level shifters are being used, it should be really handled by
>>> pinctrl-single.
>>>
>>> The other use for hsmmc.c and pdata-quirks.c for the one time mux for
>>> MMC clock from the MMC clock pin. That can be done with pinctrl-single
>>> from the MMC driver too for DT based booting.
>>>
>>> Then we just have the save and restore of the registers for
>>> off-idle.
>>>
>>>> So _maybe_ that's not an issue, as the pinmux config we have here is
>>>> fixed, and done once at boot time, and maybe the code in mach-omap2 that
>>>> touch DEVCONF1 is also ran just once and not at the same time as the
>>>> pinmux. But I don't know if that's so.
>>>
>>> It seems we could just do a read-only check for McBSP in the clock
>>> code for the mux register, or even completely drop that code from
>>> cclock3xxx_data.c and start using the pinctrl for that mux.
>>>
>>> Paul & Tero, got any comments here?
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

The PRCM/clock cleanups that I have under work basically splits the 
clock inits under their respective IP blocks; currently everything is 
registered under generic PRCM. System control module will be one of the 
clock providers (and is going to look like a driver), which will be 
registering its own clocks. This doesn't change the fact that pinctrl is 
directly mapping its own register space atm though, it might be possible 
to re-route this to use the generic system control module if need be though.

I guess its just a political decision which way we want to go, currently 
we have lots of system control clocks under the clock data (for 
AM33xx,AM43xx,OMAP3), but we can remove these easily if need be. In some 
cases it is nicer to have the data in the clock tree though, the drivers 
don't need to care if they are touching a clock or a pinctrl entity. 
Some people have been converting additional stuff to CCF outside of 
PRCM, like Archit did some work to try and get control module clock 
support for DRA7, and Tomi has been talking to convert some of the DSS 
internal clocks to CCF also.

-Tero

