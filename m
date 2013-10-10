Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3JJPcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:32:52 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34873 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3JJPct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <5256BB27.6010107@ti.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054221.8941.87801.stgit@localhost>
	<5256AA7F.8030005@ti.com>
	<CACRpkdZx5+OCcQytkpjd7_nz4hw6VXoXOS0LByKgJ8_cQjbA4g@mail.gmail.com>
	<5256BB27.6010107@ti.com>
Date: Thu, 10 Oct 2013 17:32:47 +0200
Message-ID: <CACRpkdY6NSR7gSc6=_nEr_BdTiEM0Mt9t4GoBSoP26ceVphDhA@mail.gmail.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 4:35 PM, Roger Quadros <rogerq@ti.com> wrote:
> On 10/10/2013 05:04 PM, Linus Walleij wrote:

>> As an innocent bystander who has no clue what the _reconfigure_io_chain()
>> is about can you tell me what this is all about?
>
> The OMAP SoC has a mechanism to monitor and wakeup from a low power state by creating
> an IO ring of all the pads. But there is one bit in one of the control registers that
> needs to be toggled each time the pad configuration is changed to re-arm the IO ring.
> This is exactly what _reconfigure_io_chain() does.

OK I get it, I checked the function in the machone.

>> Is this another one of the OMAP forked paths where you must call back into
>> the machine with a special callback from each and every driver?
>
> _reconfigure_io_chain() is not available for public use and is not called by any driver yet.
> However, it somehow needs to be called from this pinctrl-single driver each time the
> wakeup configuration for any pad is changed.

Actually this is one of those things where the complexity of the platform
seems to start to leak into the nice picture of one-register-per-pin.

If this was *not* pinctrl-single but pinctrl-omap.c, it would make sense to
move this _reconfigure_io code and the PRM registers it is touching down
into the pinctrl driver, because it seems like absolutely no-one else
is using it.

Both the other occurences seem to be in omap_hwmod.c, and seems
to be related to pin muxing, which is now supposed to be handled by
the pin control driver, right?

I think the real solution to this would be something like:

- Add the compatible strings "pinctrl-single-omap3" and
"pinctrl-single-omap4" to drivers/pinctrl/pinctrl-single.c,

- Pass an additional <&ampersand> resource for the prm
 thing to the single driver in the OMAP platform.

- Move this _reconfigure_io code out of the mach-omap2
  machines and hwmod and down into the pinctrl-single driver,
  it can be #ifdef ARCH_OMAP with stubs or whatever, the
  important thing is that it lives with the pinctrl driver.

This does the right thing and let the pinctrl driver handle the io ring,
instead of artificially trying to hide that in the mach-omap2 directory
which is only creating a mess of things.

I know this is sort of breaking the promise of pinctrl-single.c only
handling single registers but we just need to accept the fact that
if this idea is not perfect, trying to hide the facts of life isn't any
good either.

What do you say about this Tony? Good/bad/Linus is a moron? ;-)

Yours,
Linus Walleij
