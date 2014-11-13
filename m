Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbaKMS3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:29:39 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34433 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933226AbaKMS3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:29:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+aR7v4F/UevMDthHfp10Z
Date: Thu, 13 Nov 2014 10:28:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk, plagnioj@jcrosoft.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        hns@goldelico.com, Paul Walmsley <paul@pwsan.com>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
Message-ID: <20141113182848.GQ26481@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
 <1415051968-4878-5-git-send-email-marek@goldelico.com>
 <5463585D.9070209@ti.com>
 <20141112150210.GC26481@atomide.com>
 <5464969F.30708@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5464969F.30708@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [141113 03:33]:
> On 12/11/14 17:02, Tony Lindgren wrote:
> 
> >> And, with a quick grep, I see CONTROL_DEVCONF1 touched in multiple
> >> places in the kernel. I wonder if adding a pinmux entry for it could
> >> cause some rather odd problems.
> > 
> > They can all use pinctrl-single no problem.
> 
> Can, but don't. That's my worry. If we touch the DEVCONF1 via pinmux,
> and we have code in mach-omap2 that also touch DEVCONF1, without any
> knowledge (and locking) between those...

Hmm yeah the McBSP clock mux could be racy as the mux register for
McBSP is treated as a clock. This register muxes the clock between
external pin and internal clock. Considering that this should be
selectable at board level as the external clock probably needs to be
used if level shifters are being used, it should be really handled by
pinctrl-single.

The other use for hsmmc.c and pdata-quirks.c for the one time mux for
MMC clock from the MMC clock pin. That can be done with pinctrl-single
from the MMC driver too for DT based booting.

Then we just have the save and restore of the registers for
off-idle.
 
> So _maybe_ that's not an issue, as the pinmux config we have here is
> fixed, and done once at boot time, and maybe the code in mach-omap2 that
> touch DEVCONF1 is also ran just once and not at the same time as the
> pinmux. But I don't know if that's so.

It seems we could just do a read-only check for McBSP in the clock
code for the mux register, or even completely drop that code from
cclock3xxx_data.c and start using the pinctrl for that mux.

Paul & Tero, got any comments here?

Regards,

Tony
