Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaISKrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:47:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:54171 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaISKrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:47:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="602139335"
Date: Fri, 19 Sep 2014 13:46:57 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        Mark Brown <broonie@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, gpio: Increase ARCH_NR_GPIOs to 512
Message-ID: <20140919104657.GJ10854@lahna.fi.intel.com>
References: <1410176880-22524-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdb=yO3TbStfEesJCGDL3D_bq6_C0jwPUmKVuE+Otg8G4g@mail.gmail.com>
 <CAAVeFuKK0BNpYPwZ8c4DbhWmbFnRVuaDo2AqfSNBgBPyUou0_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuKK0BNpYPwZ8c4DbhWmbFnRVuaDo2AqfSNBgBPyUou0_A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:20:22PM +0900, Alexandre Courbot wrote:
> I should have responded to that thread long ago, but I am currently on
> holidays and strangely tend to check my mail less often than I should.
> :P
> 
> On Tue, Sep 9, 2014 at 4:24 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > Argh! This is the kind of stuff I want to get rid of ....
> >
> > Preferably gpio should be a subsystem without a lot of hooks all over
> > the place with arch-specific modifications for this and that, including
> > the max number of GPIOs.
> >
> > I would actually prefer if you bump the value in
> > include/asm-generic/gpio.h to 512 over this.
> >
> > But better still, now that we have descriptors etc would be to define
> > some new per-arch selectable config option like
> > CONFIG_ONLY_DYNAMIC_GPIO that changes the GPIO
> > core to use something like a radix tree to store and retrieve
> > descriptors.
> >
> > I.e. in drivers/gpio/gpiolib.c get rid of this:
> > static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
> >
> > Replace it with a radix tree of descriptors.
> >
> > This however makes it *impossible* to use things like desc_to_gpio()
> > and/or gpio_to_desc() so the code has to be augmented all over the
> > place to avoid any uses of GPIO numbers on that architecture,
> > but I am sure it *can* be done on pure ACPI or device tree
> > systems, and that's what we should aim for.
> 
> desc_to_gpio()/gpio_to_desc() could still work even if we remove the
> big array of GPIO descriptors. Actually that's what I intended to do
> when I first submitted the gpiod patches some time ago but it was
> rejected for performance reasons.
> 
> desc_to_gpio() actually doesn't even access this array - it does its
> job using the chip base and the beginning address of its descriptors
> array.
> 
> gpio_to_desc() would suffer a performance hit. What I initially
> proposed was to parse the linked list of GPIO chips and check if the
> requested number is in their assigned range. This is obviously slower
> than accessing an array, but if we consider that we generally don't
> have too many GPIO chips on a given hardware I don't think the hit
> would be that bad. It would also give some incentive for people to
> move to the gpiod interface.

>From what I can tell based on x86 based systems, there is typically only
one GPIO controller in the PCH/SoC that controls all the pins. A good
example is the Braswell/Cherryview controller.

So I agree with you that the performance hit would be negliglible.

> I also have a patch in my queue that enables multiple users on the
> same GPIO descriptor (something requested since some time already).
> What happens with it is that descriptors ownership is fully
> transferred to the gpio_chip instances, and the static array becomes a
> array of double-pointers, making it considerable smaller and reducing
> the impact of increasing its size. Maybe I should submit that change
> just for this case?

Go for it :)

I can try to assist if any testing is needed.
