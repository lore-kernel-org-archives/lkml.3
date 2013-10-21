Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3JUMgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:36:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab3JUMgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:36:14 -0400
Subject: Re: modalias char-major-10-130
From: Jean Delvare <jdelvare@suse.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20130705205307.GB14258@spo001.leaseweb.com>
References: <1372854803.22042.22.camel@chaos.site>
	 <20130705205307.GB14258@spo001.leaseweb.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 21 Oct 2013 14:36:07 +0200
Message-ID: <1382358967.4599.39.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Sorry for the very very late reply :(

Le Friday 05 July 2013 à 22:53 +0200, Wim Van Sebroeck a écrit :
> Hi Jean,
> 
> > All watchdog drivers include:
> > 
> > MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> > 
> > which causes a modalias char-major-10-130 to be added to every watchdog
> > driver module. As a result, any access to /dev/watchdog on a system with
> > no watchdog driver loaded and working will result in an attempt to load
> > several dozen drivers. At best one or two will actually work, the others
> > will:
> > 
> > * Waste time failing to load.
> > * Waste memory succeeding to load but not finding any device to bind to.
> > * Pollute the kernel log.
> > * Sometimes even load while they should not and break the system. I just
> > had a report about advantechwdt doing that on some systems.
> > 
> > And the attempt order will presumably be random, so it might as well
> > load softdog before a hardware-based watchdog which would have been
> > preferred.
> > 
> > This looks so 90s. Drivers for enumerated devices have hardware-based
> > modaliases, so char-major-10-130 shouldn't be needed. Other drivers
> > should certainly not be loaded randomly if they need to poke the
> > hardware to detect the presence of a supported device.
> > 
> > My opinion is that the char-major-10-130 modalias should ONLY be defined
> > by user-space, when the user knows he/she needs a watchdog driver which
> > doesn't support auto-loading via hardware-based auto-loading.
> > 
> > So, can we please get rid of all these
> > MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) statements? They do more harm than
> > good as far as I can see.
> 
> You have a valid point: There were we have modaliases and other detection
> mechanism we should indeed remove them. The rest should be evaluated
> afterwards on a case by case basis. Certain intel based drivers should
> (like advantechwdt) should indeed be fixed because they poke in the hardware
> directly and can't be really detected.

I would suggest a bigger move and remove _all_
MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) statements. I just can't find any
value in them.

Either the device is enumerated and the driver already has a module
alias (e.g. PCI, USB etc.) that will get the right driver loaded
automatically.

Or the device is not enumerated and loading its driver will lead to more
or less intrusive hardware poking. Such hardware poking should be
limited to a bare minimum, so the user should really decide which
drivers should be tried and in what order. Trying them all in arbitrary
order can't do any good.

On top of that, loading that many drivers at once bloats the kernel log.
Also many drivers will stay loaded afterward, bloating the output of
"lsmod" and wasting memory.

If defining char-major-10-130 is needed then it should happen in
user-space.

Thanks,
-- 
Jean Delvare
Suse L3 Support

