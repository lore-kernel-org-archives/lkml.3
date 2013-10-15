Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775Ab3JOWK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 18:10:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:31108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759563Ab3JOWK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 18:10:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,502,1378882800"; 
   d="scan'208";a="419673066"
Message-ID: <1381875024.23041.111.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: GPIO: Performance sensitive applications, gpiochip-level locking
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Date: Tue, 15 Oct 2013 15:10:24 -0700
In-Reply-To: <CACRpkdYJV0QYikap4hW2qGKaneZbpAnhDcySXCgy2dQYS4-9iA@mail.gmail.com>
References: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
	 <CACRpkdY4HBmNUMAE6LzGEjR05x+XunxeQrazRk9JLAiHjOcz3A@mail.gmail.com>
	 <1381771798.9489.87.camel@dvhart-mobl4.amr.corp.intel.com>
	 <CACRpkdYJV0QYikap4hW2qGKaneZbpAnhDcySXCgy2dQYS4-9iA@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 00:02 +0200, Linus Walleij wrote:
> On Mon, Oct 14, 2013 at 7:29 PM, Darren Hart <dvhart@linux.intel.com> wrote:
> 
> > In the case of the gpio-sch driver, each operation for direction and
> > value require a lock/unlock. There is no API in gpiolib to lock the chip
> > as a whole and then make lockless calls.
> 
> I don't see why the gpiolib should handle a lock? The lock in this
> driver seems to be there for this type of read/modify/write sequence:
> 
> spin_lock
> val = inb()
> val &= ~mask;
> val |= set;
> outb(val)
> spin_unlock
> 
> It's quite far away from the gpiochip as such ... In the case of ARM
> we are now looking at implementing atomic read/modify/write calls
> so we don't have to use any locks like this, so it's something that
> is not going to be useful for everyone it seems.

Indeed. Thus the comment about being a no-op for some below. If it's a
no-op for most, then this may very well be the wrong thing.

> 
> > We could do this for this
> > specific driver, but it seems to me it would better to do so at the
> > gpiolib layer. For some chips these operations might be no-ops, for
> > others, like the gpio-sch chip, they could avoid the lock/unlock for
> > every call and allow for some performance improvement.
> 
> Yeah, we just need to figure out how to do that properly.
> 
> > Full disclosure here, I don't yet know if the lock/unlock presents a
> > performance bottleneck. I've asked the graphics driver developers to try
> > with the existing API and see if it is adequate.
> 
> OK seems like a good idea. You need a lot of GPIO
> traffic for this to come into effect I believe, the cycles on the
> io-port bus will be the major time consumer, right? Or are
> these fast?
> 
> > My thinking was more
> > along the lines of:
> >
> > gpio_lock_chip(struct gpio_chip *chip)
> > gpio_direction_input_locked(gpio)
> > val = gpio_get_value_locked(gpio)
> > ...
> > gpio_direction_output_locked(gpio
> > gpio_set_value_locked(gpio, val)
> > ...
> > gpio_unlock_chip(struct gpio_chip *chip)
> >
> > I like the possibility of your suggestion, but I wonder if it will be
> > flexible enough.
> 
> Argh, all these accessors with gpiod_* accesors already
> being added this kernel cycle, it's going to be a *lot*
> of duplicated APIs isn't it?

It is, and I don't like it. This also means anyone can call
gpio_*_locked() and bypass the locking.... probably not a good plan.
Fine for internal static implementations, but not for an exported API. I
withdraw the suggestion :-)

> 
> But will the above be flexible? It's just some big anonymous
> lock and doesn't encourage fine-grained locking. It's like a
> "big GPIO lock" and that's maybe not desireable.

If we do anything, it should be more along the lines of what you
suggested - but I still don't know if it will provide adequate
flexibility. I'll wait to hear back from the graphics driver team, and
if they can demonstrate this is a performance bottleneck, I'll come back
with details.

Thanks!
-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


