Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaCEL6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:58:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:42461 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbaCEL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:58:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,592,1389772800"; 
   d="scan'208";a="466999007"
Date: Wed, 5 Mar 2014 14:05:50 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] gpiolib: Allow GPIO chips to request their own GPIOs
Message-ID: <20140305120550.GO5018@intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
 <1393257611-18031-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdZSdb_xn=swV3owEr0YwCiYVXp-90iyc=9yi-M_P=+L+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZSdb_xn=swV3owEr0YwCiYVXp-90iyc=9yi-M_P=+L+Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:49:41AM +0800, Linus Walleij wrote:
> On Tue, Feb 25, 2014 at 12:00 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Sometimes it is useful to allow GPIO chips themselves to request GPIOs they
> > own through gpiolib API. One usecase is ACPI ASL code that should be able
> > to toggle GPIOs through GPIO operation regions.
> >
> > We can't really use gpio_request() and its counterparts because it will pin
> > the module to the kernel forever (as it calls module_get()). Instead we
> > provide a gpiolib internal functions gpiochip_request/free_own_desc() that
> > work the same as gpio_request() but don't manipulate module refrence count.
> >
> > Since it's the GPIO chip driver who requests the GPIOs in the first place
> > we can be sure that it cannot be unloaded without the driver knowing about
> > that. Furthermore we only limit this functionality to be available only
> > inside gpiolib.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> I fully trust you in doing the ACPI stuff in patches 2-n but on this patch
> in particular I want Alexandre's review tag as well, as he's working
> actively with the descriptor API and I don't want to add too many quirks
> without his consent.

Thanks for your trust :)

> So Alexandre, what do you say about this?

I'm about to send v2 of the series with Rafael's comments taken into
account. However, I stumbled to another locking problem:

I'm going to move taking the gpio_lock outside of __gpiod_request() and
have __gpiod_request() to release that lock, so that we can call
chip->request() safely.

Since we are using _irqsave()/_irqrestore() versions, it means that I need
to pass flags as a pointer from gpiod_request() to __gpiod_request() like:

	spin_lock_irqsave(&gpio_lock, flags);
	if (try_module_get(chip->owner)) {
		ret = __gpiod_request(desc, label, &flags);
		...

Is that acceptable or can you guys suggest some alternative? One
alternative that I can think about is to have __gpiod_request() to take the
lock and move try_module_get() outside to gpiod_request():

__gpiod_request()
{
	unsigned long flags;

	spin_lock_irqsave(&gpio_lock, flags);
	...
}

gpiod_request():
{
	...
	if (try_module_get(chip->owner)) {
		ret = __gpiod_request(desc, label);
		...
}

Thoughts?
