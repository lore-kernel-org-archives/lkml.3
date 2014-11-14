Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161799AbaKNSCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:02:01 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35124 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161282AbaKNSB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:01:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18p7tPU7eG2VHBUCZVgbVFI
Date: Fri, 14 Nov 2014 10:01:04 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk, plagnioj@jcrosoft.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
Message-ID: <20141114180104.GT31250@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
 <1415051968-4878-5-git-send-email-marek@goldelico.com>
 <5463585D.9070209@ti.com>
 <20141112150210.GC26481@atomide.com>
 <5464969F.30708@ti.com>
 <20141113182848.GQ26481@atomide.com>
 <alpine.DEB.2.02.1411132251320.17030@utopia.booyaka.com>
 <20141113235840.GS26481@atomide.com>
 <5465AFF6.506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5465AFF6.506@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tero Kristo <t-kristo@ti.com> [141113 23:33]:
> On 11/14/2014 01:58 AM, Tony Lindgren wrote:
> 
> The PRCM/clock cleanups that I have under work basically splits the clock
> inits under their respective IP blocks; currently everything is registered
> under generic PRCM. System control module will be one of the clock providers
> (and is going to look like a driver), which will be registering its own
> clocks.

Yes that's nice. The clock modules in the SCM should probably use the
syscon mapping unless there's a clear separate IO area for them. And
then use pinctrl for registers that are muxes for external pins unless
they are in some dedicated clock register area.

> This doesn't change the fact that pinctrl is directly mapping its
> own register space atm though, it might be possible to re-route this to use
> the generic system control module if need be though.

Mapping dedicated IO areas to individual drivers is not a problem. These
drivers can eventually be children of a core SCM driver if needed.
 
> I guess its just a political decision which way we want to go, currently we
> have lots of system control clocks under the clock data (for
> AM33xx,AM43xx,OMAP3), but we can remove these easily if need be. In some
> cases it is nicer to have the data in the clock tree though, the drivers
> don't need to care if they are touching a clock or a pinctrl entity. Some
> people have been converting additional stuff to CCF outside of PRCM, like
> Archit did some work to try and get control module clock support for DRA7,
> and Tomi has been talking to convert some of the DSS internal clocks to CCF
> also.

Setting up CCF drivers for SCM makes sense to me. I suggest the
following guidelines:

1. If there's a clear separate dedicated IO area in SCM, it can be
   a driver implementing a Linux generic framework for CCF, regulators,
   pinctrl, or PHY.

2. For the random control registers, we should use syscon or
   pinctrl-single to implement Linux generic framwork functions for
   CCF, regulators, pinctrl or PHY.

3. For resource management, we can have a core SCM driver that takes
   care of the save and restore of registers and clocking if needed.
   I believe currently SCM clocks are always enabled though. We can
   set the drivers in #1 and #2 abobe to be childer of the core SCM
   driver if we ever need to manage clocks during runtime.

Regards,

Tony
