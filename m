Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3FCIkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:40:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3FCIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:40:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Date: Mon, 03 Jun 2013 10:40:42 +0200
Message-ID: <2014948.bdhzSga56L@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130602144725.GC3875@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de> <8513280.folT80711V@wuerfel> <20130602144725.GC3875@shaftnet.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:l9AT+tM+SeNVluzf3YKSKGmNRBsDyFxgGPJh071fnz8
 2eE8EIWP+HGYph6iqXs0NyK7FacpUtpKq4fwW9nlbUCOdua/iY
 H6bqbHkfF/ME0iwSGlZfKQr0uxlRSDEJWVbuPDHEixRXPR9Pke
 ZdFaKToP0wgChiA6HteudBODeqYJUzTUEzLnBftAFuDVUGzKgW
 Ftf2uifbdBdGL4LFe08B1vr6ReCIXUVxCa15viEnj2joJVnmw+
 G1XMFI4XC4bO27cIvCryrpUssVSCz/EpkINVBXKkhHCUBYRg2Z
 uJIwbbprE9NYpF3A44LMIASyIujVJtnMD3JfN1D233fCH0kz5f
 kiWxoW6VHH9wmwkTMapE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 June 2013 10:47:26 Solomon Peachy wrote:
> On Sun, Jun 02, 2013 at 03:59:12PM +0200, Arnd Bergmann wrote:
> > The driver doesn't reliably build, and I'm trying to fix it.
> > From my perspective, we can just mark it 'depends on !ARM'
> > to get it off my radar, but other people are doing build
> > testing on x86 and will run into the same issues.
> 
> AFAIK the only remaining build problem is when CONFIG_CW1200_SAGRAD is 
> not defined so there's no "platform" data provided.

Yes, that is correct. My first approach was to always 'select CW1200_SAGRAD'
from the CW1200_SDIO driver, but then it becomes impossible to have
a different definition of the data in platform code. Even without doing
it you also have a build error if you try to add a platform_data definition
to more than one board file in the kernel or enable the sagrad driver
at the same time as a platform.

> > If we only care about two cases a) a default sagrad card that can use
> > hardcoded data and b) a board that uses the same chip and requires
> > custom data, then I would suggest including the sagrad data in the
> > sdio driver as a default (as my patch does) but allow overriding
> > it with platform data.
> 
> Yes, those are the only use cases we care about.  And that sounds like a 
> viable approach, so I'll code that up.
> 
> I guess adding a function along the lines of 
> "cw1200_sdio_set_platform_data()" (to be called by the board/platform 
> setup code) would be the right way to do this?

It's much better than what you have today, but not ideal because it
means the driver cannot be a loadable module any more.

> As an aside, I wish I'd received this feedback a couple of months ago.

Yes, I agree it's unfortunate timing. Our review process is certainly
not perfect when you have to wait for stuff to break in linux-next
before you get people to notice the problems.

At least it's not in a released kernel yet.

> > The problem with this is that it is impossible to build a kernel that
> > supports both, or even two devices of the same type.
> 
> Adding proper devicetree support will solve this problem down the line, 
> but I don't think there's any way to fix this for non-DT systems thanks 
> to that chicken-and-egg probing situation.
> 
> (I wish I had a DT-capable platform handy to develop against..)

All ST-Ericsson DB8500 (ux500) systems should now work with DT, and will
be DT-only in one of the next few kernel releases.

> > I don't mind the backports supporting that, but we should probably
> > move on in mainline. The existance of backports is no excuse for
> > keeping around broken code.
> 
> I already have one patch queued up for backports to re-enable <2.6.36 
> support, and I have no problem adding more.  
> 
> That said, until all SDIO/SPI-supporting targets in the mainline are 
> converted to a devicetree (or equivalent) model, I imagine the 
> platform_data crap will have to remain.

I'm not sure about this: I would argue that only the boards that
are part of mainline and have a cw1200 wired up are what matters here.

Having an SoC platform with SDIO support and the potential to add
a board file including cw1200 is not relevant as long as that board
file does not actually get added. If someone can patch the kernel
to add a board file, they can also patch the driver in any way
necessary.

In contrast, with devicetree we normally anticipate that people can
have their external dts files which reference DT-enabled drivers
even if the dts file is not itself part of the kernel.

> > just look in include/linux/platform_data/. The most common type for
> > gpio numbers is 'int'.
> 
> I've already posted a patch that converts them over.

ok.

> > In fact my mobile phone has a cw1200 chip that was working until
> > recently. Now it just crashes when I do 'ifconfig wlan0 up'
> > or enable WLAN in the Android settings menu. :(
> > 
> > I'm not blaming you for that ;-)
> 
> What model, out of curiousity?

This is a Sony xperia Sola. Wireless was working for about a year
with the original Android 2.3 image, but it broke a week after
I installed CyanogenMod 9.1.

> > I think the most important part is separating the generic sagrad
> > add-on card code from any platform-specific code and removing the
> > use of cw1200_get_platform_data() function that breaks the build.
> 
> I'll convert SDIO driver to using the sagrad data as default and add a 
> 'set_platform_data' sort of function to allow it to be optionally 
> overridden.  It shouldn't take long, and I'll post the patch as soon as 
> I'm finished.

Ok, sounds like a good next step.

Regarding a long-term solution, I think what we should do here is to
move the reset logic into the SDIO framework itself: We have similar
requirements even for eMMC and SD cards, where you need to provide
the correct voltage to a device on the MMC port in order for it to
work. Today this is supported to a varying degree on the MMC controller
level, where we hook into various frameworks (clk, reset-controller,
regulator, gpio, pinctrl, power domain) based on platformm data or
device tree information on the controller node.

I think you can do this today with cw1200 as long as you know which
MMC controller you have, which may also solve your problem, but it
would be nice if that could be made more generic for SDIO, since
the problem is neither controller-specific nor device-specific
but can happen on any SDIO device.

Looking at the source code for my phone, there is one clock that
needs to be enabled for the cw1200 through pdata->clk_ctrl. This
should probably just be a turned into an anonymous clock so the
cw1200 driver itself does "clk = clk_get(dev, NULL); clk_enable(clk);"
and the callback can be removed.
There is also IRQ and reset logic in this board-mop500-wlan.c file.
The IRQ logic seems fine, and for the reset, I would suggest using
the gpio-reset driver that is getting proposed for merging in 3.11,
and to add a call to device_reset() into the sdio layer.

	Arnd
