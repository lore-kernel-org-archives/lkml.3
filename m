Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3LOAV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 19:21:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3LOAV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 19:21:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Date: Sun, 15 Dec 2013 01:21:24 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com> <201312141950.09447.arnd@arndb.de> <52ACBC18.6020301@roeck-us.net>
In-Reply-To: <52ACBC18.6020301@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312150121.24414.arnd@arndb.de>
X-Provags-ID: V02:K0:w/s4AxdbODg88qgEJ/VfJgM/kLErIDnCzKLJ0H9Tn2m
 NluUw9YRvLkj1uYdio32qriTTcG/FRJrRxSyacyITqS7paQnGa
 YcJorW8wKgVXHnuy1EO363jC64R5RvP9efYWACYK9rxL343bqg
 /tsIi5XNyJZWPb2I1+E9sMUUvoDSVOcH1UlzZr3gXjA8IEQOtJ
 YmvwYh7ddicJyQcxiFx0UNGYXOREo0wcgk1pbL+nSMiwrjtTvD
 Vn2K1Jv3WVgJXaMEbxyOUvuJWSdrlJIMnF8FL2MIaQqsqW6QHm
 UhQNaodoe0J0s6hwyAFN3k5Gq++1G4vPlk/QGu5rbXTmQDenZG
 7YzlZe/CnQvLlXkTCmIM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 December 2013, Guenter Roeck wrote:
> Hmm ... not sure I agree. I don't see a problem with something like "arm,moxart-reboot".
> There are already vexpress-reboot and xgene-reboot properties which do pretty much
> the same.
> 
> Actually, you don't even need that; the reset driver could simply re-use the
> "moxa,moxart-watchdog" property. After all, all that specifies is that there
> is a compatible driver. Look for "samsung,s3c2410-wdt" for an example of another
> reset handler doing just that.
> 
> Attaching it to the watchdog device seems to be more problematic given the
> (currently) optional nature of the watchdog driver and its different scope.

As far as I'm concerned a watchdog driver is just as optional as a reboot
driver. The vexpress and xgene reset drivers are different because those
are actually dedicated devices that are there only to do rebooting.

The "samsung,s3c2410-wdt" device is exactly the same category as the moxart
one, but the code to use it performs the same hack by scanning the
device tree ad hoc from the platform initialization. I think it should
be integrated into watchdog the same way, and if we have more drivers
in that category, we'd probably want a generic watchdog reboot callback
function that wdt drivers can hook up to the architecture reset handler.

The main difference I see between plat-samsung and mach-moxart here is that
the samsung platforms still need a lot of code in arch/arm to get things
to work (this will have to change as soon as we get an arm64 exynos, which
would have everything in proper drivers), while for moxart this is the only
non-driver code.

Reusing the moxa,moxart-watchdog device from a separate reboot driver is
a violation of the driver model, since we can't really bind two platform
drivers to one platform device, unless you add another device in drivers/mfd
to create two children for wdt and reboot, but that would be really silly.
You could use the same code that samsung has at the moment in a loadable
module, which effectively implements a linux-2.4 style driver that probes
the device in the module_init function rather than registering a struct
device_driver with a probe callback.

	Arnd
