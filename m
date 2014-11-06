Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaKFK7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:59:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:46565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFK7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:59:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,325,1413270000"; 
   d="scan'208";a="603372689"
Date: Thu, 6 Nov 2014 12:58:55 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] leds: leds-gpio: Convert gpio_blink_set() to use GPIO
 descriptors
Message-ID: <20141106105855.GL1618@lahna.fi.intel.com>
References: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com>
 <545843B1.3020101@nvidia.com>
 <2455157.3p7mHhT8im@vostro.rjw.lan>
 <CAMuHMdXn9W2S7N+YGfjDxQozMtRZCVdTzzdDps6YfOv2FqVBmw@mail.gmail.com>
 <20141106103033.GK1618@lahna.fi.intel.com>
 <CAMuHMdWtcZcpW=r60s9auENZxChiLwr14R0p_soKr7C3yGYOMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWtcZcpW=r60s9auENZxChiLwr14R0p_soKr7C3yGYOMQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:32:19AM +0100, Geert Uytterhoeven wrote:
> Hi Mika,
> 
> On Thu, Nov 6, 2014 at 11:30 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >> "leds: leds-gpio: Add support for GPIO descriptors" broke leds-gpio on
> >> non-DT platforms for me:
> >>
> >>     gpiod_direction_output: invalid GPIO
> >>     leds-gpio: probe of leds-gpio failed with error -22
> >>
> >> (desc is NULL in gpiod_direction_output()).
> >>
> >> DT shmobile reference/multi-platform are fine.
> >>
> >> I noticed the hard way, as I wanted to add some LEDs to a new platform,
> >> but couldn't get it work. It turned out it also had stopped working on
> >> r8a7740/armadillo-legacy, so I started bisecting...
> >
> > Which board file that is?
> >
> > There is a bug that gpio_to_desc() returns NULL instead if ERR_PTR() in
> > that patch but I wonder why gpio_is_valid() and devm_gpio_request_one()
> > do not complain about that prior.
> 
> arch/arm/mach-shmobile/board-armadillo800eva.c

Thanks.

Are you able to put some printks() to the 'if (!template->gpiod)' branch
so that it prints out gpio number and what does devm_gpio_request_one()
return?

Something like:

	if (!template->gpiod) {
		...
		ret = devm_gpio_request_one(parent, template->gpio, flags,
					    template->name);
		dev_info(parent, "GPIO %u, ret: %d\n", template->gpio, ret);
		if (ret < 0)
			...

		led_dat->gpiod = gpio_to_desc(template->gpio);
		dev_info(parent, "GPIOD: %p\n", led_dat->gpiod);
	}
