Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaG1PXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:23:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaG1PXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:23:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
Date: Mon, 28 Jul 2014 17:23:03 +0200
Message-ID: <13731398.6CtXoCyCVq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53D65C16.2050202@arm.com>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <5959830.lpqeqL7HbK@wuerfel> <53D65C16.2050202@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Zntg9p7L9zoAGLXXgZMKvl8O8y2mortXprSzmPaaSpY
 HM86k0VuLynGSNr0ge2D34jPaKQk49FgGY+BBtXSsLj3MSusMw
 k3+CFMyPomPRRzHjOVKZIAR6SgFp+z58qJIHrkuy2zT9n4I3a1
 7NBELIRISkNertrVeOaE62MfwQk4a1ghk4eGEZtwFa4TYOtWCV
 VvEXptnw43Pwqtcoeds41T4RmHCj/mYxM1hhBe6VgS2p23djg4
 VQiQ0KQMMNli17uCHRStWXixCvpc68/yVQMbWaZls6oy8TPjcp
 9q0LOLLtEgQD2UeW/1mZcE/+ExLZZYV5IeXLu81BTuZ7Y8oVOb
 GIsW8FvAYQodY/dEpgPI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 15:20:06 Andre Przywara wrote:
> On 28/07/14 11:46, Arnd Bergmann wrote:
> > On Monday 28 July 2014 10:23:57 Graeme Gregory wrote:
> >> The PL011 UART is the use-case I keep hitting, that IP block has a 
> >> variable input clock on pretty much everything I have seen in the wild. 
> > 
> > Ok, I see. What does ACPI-5.1 say about pl011?
> > 
> > Interestingly, the subset of pl011 that is specified by SBSA does not
> > contain the IBRD/FBRD registers, effectively making it a fixed-rated
> > UART (I guess that would be a ART, without the U then), and you
> > consequently don't even need to know the clock rate.
> 
> The idea of this was probably to let the baudrate set by some firmware
> code to the "right" value and the spec just didn't want to expose the
> details for the generic UART:
> "This specification does not cover registers needed to configure the
> UART as these are considered hardware-specific and will be set up by
> hardware-specific software."
> To me that reads like the SBSA UART is just for debugging, and you are
> expected just to access the data register.

Right, makes sense. It also avoids the case where Linux for some reason
ends up using a different line rate than the firmware, which can
cause a lot of unnecessary pain.

> > However, my guess is that most hardware in the real world contains
> > an actual pl011 and it does make a lot of sense to allow setting
> > the baud rate on it, which then requires knowing the input clock.
> > 
> > If there is any hardware that implements just the SBSA-mandated subset
> > rather than the full pl011, we should probably implement both
> > in the kernel: a dumb driver that can only send and receive, and the
> > more complex one that can set the bit rates and flow-control but that
> > requires a standardized ACPI table with the input clock rate.
> 
> The fast model I use can be switched to use the SBSA restricted PL011,
> and as expected the Linux kernel crashes at the device doesn't support
> DMA (and a lot more stuff) - but the current code requires it.

It does? We have a lot of platforms that don't have DMA support for
pl011.

> So I am about to implement a new driver for that SBSA subset. So far
> this will be a separate driver, starting from a copy of amba-pl011.c,
> but removing most of the code ;-)

Ok. You might want to consider starting from a different base though.
IIRC, pl011 uses uart_port as the basic abstraction, while the
new driver should probably use the raw tty_port instead.
drivers/tty/goldfish.c is probably a good example to look at for
that.

You could also make it a hvc_driver like drivers/tty/hvc/hvc_vio.c,
but I'm not sure if that model seen favorable by the tty maintainers.
It would probably be the shortest driver though.

	Arnd
