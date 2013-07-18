Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3GRIOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:14:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25196 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756847Ab3GRIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:14:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+HbxYhUhag1vVlRz2O3D0
Date: Thu, 18 Jul 2013 01:14:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 2/3] ARM: OMAP2+: omap_device: add pinctrl handling
Message-ID: <20130718081405.GS7656@atomide.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
 <1374061312-25469-3-git-send-email-grygorii.strashko@ti.com>
 <20130717153838.GJ7656@atomide.com>
 <51E6CCB6.2000907@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E6CCB6.2000907@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130717 10:11]:
> On 07/17/2013 06:38 PM, Tony Lindgren wrote:
> >* Grygorii Strashko <grygorii.strashko@ti.com> [130717 04:49]:
> >>Before switching to DT pinctrl states of OMAP IPs have been handled by hwmod
> >>framework. After switching to DT-boot the pinctrl handling was dropped from
> >>hwmod framework and, as it was recommended, OMAP IP's drivers have to be updated
> >>to handle pinctrl states by itself using pinctrl_pm_select_xx() helpers
> >>(see http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html)
> >>
> >>But this is not right for OMAP2+ SoC where real IPs state is controlled
> >>by omap_device core which enables/disables modules & clocks actually.
> >
> >I'm not convinced we should try to handle this in a generic way
> >as only some devices need dynamic remuxing of some pins.
> >
> >>For example, if OMAP I2C driver will handle pinctrl state during system wide
> >>suspend the following issue may occure:
> >>- suspend_noirq - I2C device can be still active because of PM auto-suspend
> >>   |-_od_suspend_noirq
> >>      |- omap_i2c_suspend_noirq
> >>         |- PINs state set to SLEEP
> >>   |- pm_generic_runtime_suspend
> >>      |- omap_i2c_runtime_suspend()
> >>         |- PINs state set to IDLE  <--- *oops* PINs state is IDLE and not SLEEP
> >>   |- omap_device_idle()
> >>      |- omap_hwmod_idle()
> >>         |- _idle()
> >>            |- disbale module (sysc&clocks)
> >
> >And in this example you are assuming that you need separate idle and
> >sleep states, which is not true at least for most cases I've seen.
> 
> I don't need both states (at least right now) :), but
> - if any OMAP2+ driver will have two states defined: "idle" and "sleep"
> - and if it will try to manage them from drivers callbacks only using
>   pure calls to pinctrl_pm_select_xx() helpers
> 
> the "idle" state will be selected during suspend and *not* "sleep".

But the drivers have separate calls for runtime PM and suspend/resume?

> >It is possible that am33xx needs separate idle and sleep states, but
> >most likely only for some pins. For omap[345] we can get away with
> >just the default state for most cases.
> >
> 
> 
> In case, if only "default" state is defined for device - nothing will
>  be done by OMAP device framework for it (I mean any call to
> pinctrl_pm_select_xx() will do nothing - it just checks that there is
> no state and returns 0).

If we want to automate something, it should be done at Linux generic
level rather than at omap "bus" level. That sort of relates to drivers
needing to know when they've lost context too, which should be
implemented in Linux generic way.

Regards,

Tony
