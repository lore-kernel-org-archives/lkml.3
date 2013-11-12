Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3KLAlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:41:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58661 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:41:48 -0500
Message-ID: <52817922.8070408@ti.com>
Date: Mon, 11 Nov 2013 18:41:06 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sricharan R <r.sricharan@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [RFC] Refactoring and moving dmtimer code
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas and everyone,

I'm currently trying to refactor our dmtimer code in various ways and there are
different challenges in doing so, some goals are shorterm and others long term,
but I need some guidance so that I can do things the right way to begin with.

I wanted to start a discussion on what needs to be done, and sort of track
what's blocking us and establish certain guidelines/recommendations before
starting to do things etc.

(1)
With ARCH_MULTIPLATFORM turned on, arch/arm/plat-*/include/plat/ is no longer
accessible to drivers/. Due to this, all such drivers that need direct access to
a *specific* dmtimer don't work and are disabled:
drivers/media/rc/ir-rx51.c and
drivers/staging/tidspbridge/core/dsp-clock.c

We're also going to be having mailbox code needing dedicated timers at some point.

So as a first step, I'd like to split dmtimer.h
(arch/arm/plat-omap/include/plat/dmtimer.h) into a public header.

The header currently consists of 2 parts, First part is mostly "private" where
__omap_dmtimer functions are defined, which should really not be accessible to
users of the dmtimer API. Second mostly would be the public dmtimer API which
*should* be public so that drivers that need it are not disabled with
ARCH_MULTIPLATFORM.

Could you suggest a good place for this header? I'd like to split this header
and expose a second "dmtimer.h" in a suitable include directory.

(2)
Moving of dmtimer.c code out of plat-omap into a suitable drivers/ directory

This could be the next step where we move dmtimer.c into a suitable place other
than arch/arm/plat-omap/.
The public dmtimer API will be declared through the above header. Drivers that
need specific timers such as DSP and mailbox can use it.

Though this part of the code would not deal with clocksource framework, does it
makes sense to move it into drivers/clocksource/? Any other suggestions?

(3)
Establish an omap clocksource driver in drivers/clocksource/

Currently all our system timer code resides in arch/arm/mach-omap2/timer.c, in
the long run I'd like to convert this to a clocksource driver. But currently the
code is a bit dependent and entangled with PM code (which we call hwmod). This
work may have to wait till hwmod cleanups can happen, that's why I'm keeping it
for last before we can finish with the baby steps. Suggestions are welcome here.

(2) and (3) can indeed be combined into a single driver even and placed in a
suitable location. But the big question I guess is, is drivers/clocksource/ the
right place.

Thanks in advance for your valuable guidance, looking forward to getting some
momentum with this work.

regards,

-Joel
