Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaJTWbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:31:23 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41586 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751233AbaJTWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:31:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Jfd8bTaQPF6Y21U6TgaPM
Date: Mon, 20 Oct 2014 15:29:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        kishon@ti.com, s.nawrocki@samsung.com
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141020222942.GA2560@atomide.com>
References: <20141019090107.GA19132@amd>
 <201410191658.45851@pali>
 <20141019205033.GA4738@amd>
 <201410192300.20625@pali>
 <20141020130855.GA1067@amd>
 <20141020164542.GD5192@atomide.com>
 <20141020220338.GA19314@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020220338.GA19314@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141020 15:04]:
> On Mon 2014-10-20 09:45:42, Tony Lindgren wrote:
> > * Pavel Machek <pavel@ucw.cz> [141020 06:10]:
> > > Hi!
> > > 
> > > > My N900 can boot kernel from v3.12-rc5-n900 branch compiled with 
> > > > arch/arm/configs/rx51_defconfig. Also it can boot full Maemo5 
> > > > system (with CSSU and some minor system changes) and usb network 
> > > > via g_nokia.ko gadget working fine...
> > > > 
> > > > So if it does not working for you then kernel usb subsystem could 
> > > > have problems with using gadgets directly from zimage.
> > > 
> > > After some hand-bisecting and real-bisecting, I found two commits that
> > > cause problems for 3.13: With these reverted, I get usb networking
> > > back in 3.13 on nokia n900.
> > > 
> > > (Pali, if you revert these, you should get working usb networking in
> > > your 3.13 branch, too.)
> > > 
> > > Any ideas?
> > 
> > Hmm maybe check if current stable kernels work for you without
> > reverting anything ? Few weeks ago I did the the following two fixes
> > with cc stable v3.13+:
> > 
> > 96be39ab34b7 usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
> > 85601b8d81e2 usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down
> 
> I tried these on top of 3.14 (where my revert fixes stuff) and no, it
> does not seem to help. (Trying stable would be a bit more work).
> 
> Do you want me to try on 3.13, too?

Sounds like there's something else missing too then. Maybe give
v3.18-rc1 and device tree based boot a try?

FYI, there's some PM support there too since v3.16-rc7, so using
anything pre v3.17 is probably not fun on the battery. Well it works
with omap2plus_defconfig long as serial port timeouts are configured,
no USB cable is connected and and the screen is blanked. When it works,
both keyboard debug LEDs will go off during idle, which really should
be most of the time if you plan to use it as a phone. The left debug
LED goes off for retention idle, when both go off it's hitting
off-idle.

I'm using the following test script here, if it does not idle for
you, there are probably some other drivers loaded that currently
block deeper idle states.

Regards,

Tony

8< ---------------
#!/bin/bash

uarts=$(find /sys/class/tty/ttyO*/device/power/ -type d)
for uart in $uarts; do
        echo 3000 > $uart/autosuspend_delay_ms
        #echo -1 > $uart/autosuspend_delay_ms
done

uarts=$(find /sys/class/tty/ttyO*/power/ -type d)
for uart in $uarts; do
        echo enabled > $uart/wakeup
        echo auto > $uart/control
done

echo 255 > /sys/devices/68000000.ocp/48098000.spi/spi_master/spi1/spi1.2/backlight/acx565akm/brightness
echo 1 > /sys/devices/platform/omapfb/graphics/fb0/blank

echo 1 > /sys/kernel/debug/pm_debug/enable_off_mode
