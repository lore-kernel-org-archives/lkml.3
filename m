Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3GLKef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:34:35 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:60166 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3GLKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:34:33 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dongjin Kim'" <tobetter@gmail.com>,
        "'Julius Werner'" <jwerner@chromium.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Felipe Balbi'" <balbi@ti.com>, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olofj@chromium.org>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Fabio Estevam'" <festevam@gmail.com>,
        "'Philipp Zabel'" <p.zabel@pengutronix.de>,
        Yulgon Kim <yulgon.kim@samsung.com>, s.nawrocki@samsung.com,
        grant.likely@linaro.org, arnd@arndb.de
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Date: Fri, 12 Jul 2013 12:34:25 +0200
Message-ID: <2736758.WIzxm4p4Im@thinkpad>
User-Agent: KMail/4.10.5 (Linux/3.9.9-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <001701ce7e99$95b2c460$c1184d20$@samsung.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org> <CAODwPW-=bo2BqcHopY32N76p6DDGNDmCrKFo1R4gEEZhsG-DYg@mail.gmail.com> <001701ce7e99$95b2c460$c1184d20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 12 of July 2013 09:48:54 Jingoo Han wrote:
> On Friday, July 12, 2013 6:46 AM, Julius Werner wrote:
> > Hi Jingoo,
> > 
> > Yeah, I followed that discussion back then, but it seems to have
> > stalled a little (at least the HSIC patches haven't been picked up in
> > any kernel.org repo yet to my knowledge).
> > 
> > The problem is that I think these approaches cannot work reliably. I
> > agree that it would be nice to control the HSIC device from its own
> > driver, and have spent quite some time playing around with the
> > usb/misc/usb3503.c driver to try to make this work... but there's a
> > timing dependency here that you just can't model correctly with
> > independent drivers.
> > 
> > If the HSIC device is already active during boot (e.g. because it was
> > used by firmware), there's always a chance that the USB stack will
> > come up before the driver that resets it does. The device will be
> > enumerated as normal, and when the other driver later pulls the reset
> > signal the USB stack will not notice because there is no real
> > disconnect detection on HSIC. Only when you eventually try to send
> > another transfer to the device will you start to get timeouts, and the
> > newly reset device will not be able to reenumerate because the host
> > never asks it to.
> > 
> > I really don't see how you could solve this without putting some kind
> > of synchronization mechanism in the USB drivers. So this leaves
> > ehci-s5p and phy-samsung-usb2 as the only possible places, and I chose
> > the latter since all the host-side HSIC initialization is also there
> > already. I think if you think of it as "reset whatever is on the other
> > side of this PHY", it's okay to put it as an optional feature into the
> > PHY driver.
> 
> CC'ed Tomasz Figa, Dongjin Kim, Yulgon Kim
> 
> 
> Hi Tomasz, Dongjin,
> 
> Julius Werner wants to put 'SMSC 3503 hub reset on Arndale board'
> to 'phy-samsung-usb*.c' files, because there is a timing dependency
> above mentioned.
> The following is the original patch sent by Julius Werner two day ago.
> (http://www.spinics.net/lists/linux-samsung-soc/msg20250.html)

Well, I think this is simply broken. Following are the reasons why I think so:
 a) you can use the smsc3503 chip on any USB/HSIC controller and with any 
USB/HSIC PHY, so you would have to add such reset GPIO to _every_ PHY or 
controller driver,
 b) you might want to use other USB/HSIC hubs like this one that requires some 
initialization sequence, other than just toggling a GPIO, so you would have to 
add cases for all of those hubs or other chips in _every_ PHY or controller 
driver.

> Previously, Olof mentioned that 'drivers/platform/arm/' would be used.
> (http://patches.linaro.org/16856/)
> 
> Also, another way was mentioned by Fabio Estevam, using
> 'drivers/reset/gpio-reset.c' which is not merged yet.
> (http://permalink.gmane.org/gmane.linux.drivers.devicetree/36830)
> 
> I think that 'phy-samsung-usb*.c' files are not a good place.
> However, Julius Werner's comment looks reasonable enough.

I can see this problem almost equivalent to the problem with on-board WLAN 
adapters connected using SDIO. Those adapters require some kind of power on 
sequence before they can be enumerated using standard MMC/SDIO mechanisms and 
so does this USB/HSIC hub.

So basically this is a thing that we should consider on a more generic level, 
not just for this particular single chip.

CCing some extra people to increase chance of getting more opinions on this.

Best regards,
Tomasz

