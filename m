Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3FBN72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 09:59:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3FBN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 09:59:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Date: Sun, 02 Jun 2013 15:59:12 +0200
Message-ID: <8513280.folT80711V@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130602122954.GA3875@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de> <20130602122954.GA3875@shaftnet.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bk0ce2ovaRZE7OvqA2BQ/e2qwcEJnfMTktI+wm7dSV1
 KKVe5wjxb9WCMjWUEsqIDwaTxBj04eqBCdOToII2slZfUwbDbX
 FZ8gH8/3Z/tNlxuSm2Z4VYMZDXLeWUyNH8bv0C0tTc1AkL4VUK
 VkChyZl2uQ6EOmCvvs1Z+zcOJ1YohcdYOg9NaypRtgqY3FX8ow
 Xmqq8Z+tY2aX9GvCT4rrXBQxYwTwjTGTK5KKaodoz587IsFReZ
 LFV6u5dzgFHCS3vlrjoQI4ylkbWkQXbnySBHDbGxZ8cG9HAOFp
 gGq/m7FAFwN1QDCAZnH1MiXo5von6Ak8Z6b+hdfr9ktDX9P6P4
 jnLy+nSASU/EQ4IAOPB4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 June 2013 08:29:54 Solomon Peachy wrote:
> On Sun, Jun 02, 2013 at 12:37:21AM +0200, Arnd Bergmann wrote:
> > I got compile errors with the cw1200, which has lead me to take a
> > closer look. It seems the driver still has a number of issues,
> > and this addresses some of them and marks others as FIXME:
> 
> In short, NACK, at least not as posted.
> 
> The concerns are legitimate, but the time to object to such fundamental 
> stuff was at some point during the past *seven* rounds of patches I 
> posted over a period of nearly as many months.

The driver doesn't reliably build, and I'm trying to fix it.
>From my perspective, we can just mark it 'depends on !ARM'
to get it off my radar, but other people are doing build
testing on x86 and will run into the same issues.

> > * The cw1200_sagrad.c file should not be there, hardcoding
> >   hardware configuration in .c files has been obsolete since
> >   Linux-2.4, so we should just remove it. Most of that file
> >   was already commented out since it does not compile.
> 
> The problem with the cw1200 is that you need certain information about 
> the hardware design in order to initialize it; this information has to 
> come from somewhere.

If the hardware cannot be identified from register access, the
information should get passed through firmware. On most architectures
that means device tree data, on x86 that would be ACPI tables.

> The Sagrad wifi devices are available in a standard SD form factor 
> reference design that plugs into a standard SDIO-supporing slot.  The 
> cw1200_sagrad module is there to support these off-the-shelf devices. 

The code does not look particularly off-the-shelf though:

static struct resource cw1200_href_resources[] = {
       {
               .start = 215,  /* fix me as appropriate */
               .end = 215,    /* ditto */
               .flags = IORESOURCE_IO,
               .name = "cw1200_wlan_reset",
       },
       {
               .start = 216,  /* fix me as appropriate */
               .end = 216,    /* ditto */
               .flags = IORESOURCE_IO,
               .name = "cw1200_wlan_powerup",
       },
       {
               .start = NOMADIK_GPIO_TO_IRQ(216), /* fix me as appropriate */
               .end = NOMADIK_GPIO_TO_IRQ(216),   /* ditto */
               .flags = IORESOURCE_IRQ,
               .name = "cw1200_wlan_irq",
       },
};

There is nothing generic about that.

> Requiring users to recompile their kernel or update their devicetree 
> data for what amounts to an off-the-shelf hot-pluggable device is simply 
> not acceptable.

That was the intention of the patch. Right now, you require users
to modify cw1200_sagrad.c.

> At the same time, if people plop the sagrad device directly on their 
> board (or independently do a chip-down design) they may need to make 
> changes to the platform data depending on how closely it tracks the 
> Sagrad reference design.

We can use platform_data if there is convincing evidence that people
are going to be using that in mainline kernels. However, your SDIO driver
doesn't actually do that, it just hardcodes settings in cw1200_sagrad.c
and calls a local function to get that data, rather than getting the data
from the dev_get_platdata() in it's probe callback at a point where
it knows the device is actually there.

> Further complicating things, there's no way to alter the SDIO 
> vendor/device IDs that the device reports in order to distingish between 
> any of this.
> 
> If you have a better suggestion on how to handle this set of conflicting 
> requirements then I'm all ears, but it's rather pointless to object to 
> code that's ugly because it has to support ugly hardware.
>
> (That said, the commented-out bits in cw1200_sagrad are mostly there for 
>  documentation purposes, and it could be moved to a proper documentation 
>  file instead.)

I think a better place for that would be the include/linux/platform_data
header file.

If we only care about two cases a) a default sagrad card that can use
hardcoded data and b) a board that uses the same chip and requires
custom data, then I would suggest including the sagrad data in the
sdio driver as a default (as my patch does) but allow overriding
it with platform data.

> > * Move the parts of cw1200_sagrad.c that actually got used into
> >   cw1200_sdio.c, because it doesn't build otherwise.
> 
> The idea was that either you build cw1200_sagrad or provide your own 
> platform_data.  I separated all of the implemenation-specific code out 
> as cleanly as I could.

The problem with this is that it is impossible to build a kernel that
supports both, or even two devices of the same type.

> > * Make the platform_data for the sdio driver private to
> >   cw1200_sdio.c. The platform that was referenced here is
> >   going to use device tree based probing only in the future,
> >   which means the platform data has to go away anyway.
> 
> When you say "the platform" what are you referring to?  SDIO?  There's 
> no mention of any specific board (or even arch/subarch) in cw1200_sdio 
> or cw1200_sagrad.

I mean arch/arm/mach-nomadik, which is the platform that originally
defined NOMADIK_GPIO_TO_IRQ(). Note that in recent kernels, mach-ux500
also uses this macro internally, but it's already gone in nomadik
and will stop working in ux500 in the future.

> In the real world, this driver will have to support non-devicetree 
> operation for as long as Linux does, and indeed longer, thanks to 
> compat-drivers/backports.

I don't mind the backports supporting that, but we should probably
move on in mainline. The existance of backports is no excuse for
keeping around broken code.

> And for what it's worth, none of the platforms I have access to have 
> devicetree support since I'm stuck using vendor-supplied kernels.

Out of tree platforms are also not really an issue, since you already
need to patch the kernel. You can patch it some more to add platform
data back.

> > * Add comments about passing GPIO numbers in platform_data:
> >   You should not use IORESOURCE_IO, which is for legacy ISA
> >   I/O ports on PCs, not for GPIOs.
> 
> Fair enough.  The use of resources was something already in the driver 
> when I inherited it, but I've seen this pattern a lot elsewhere.  Is 
> there a specific driver I should reference instead?

just look in include/linux/platform_data/. The most common type for
gpio numbers is 'int'.

> > It may actually be easier to remove the sdio driver entirely,
> > since it clearly doesn't work and requires a lot of cleanup.
> 
> Several hundred thousand in-the-field devices already deployed with this 
> driver clearly disagree with you.

Sorry for misinterpreting that, the cw1200_sagrad file really looked
like it was written for some out-of-tree board and subsequently
all lines that didn't compile got commented out.

> I've personally tested this driver on six different hardware platforms, 
> using mainline kernels for some and vendor-supplied kernels for others. 

I was only talking about mainline kernels, obviously the driver has
worked somewhere before, but that is not the point if the working
version is not the one that got merged.

In fact my mobile phone has a cw1200 chip that was working until
recently. Now it just crashes when I do 'ifconfig wlan0 up'
or enable WLAN in the Android settings menu. :(

I'm not blaming you for that ;-)

> With module-down and SD-slot designs.  Others have tested other 
> platforms.  Every configurable option and line item in both the SPI and 
> SDIO platform data is there because it needs to be in order to support 
> the variety of hardware designs already in the wild.
> 
> This driver will also be part of the compat-drivers/backports project, 
> and as such has to work within that framework as well.
> 
> If you have constructive suggestions on how to handle this set of 
> requirements in a cleaner manner, I'm all ears.

I think the most important part is separating the generic sagrad
add-on card code from any platform-specific code and removing the
use of cw1200_get_platform_data() function that breaks the build.

	Arnd
