Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaCEMwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:52:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60016 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753070AbaCEMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:52:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] gpiolib: Allow GPIO chips to request their own GPIOs
Date: Wed, 05 Mar 2014 14:07:43 +0100
Message-ID: <8377171.cpEJInc4ro@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140305120550.GO5018@intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdZSdb_xn=swV3owEr0YwCiYVXp-90iyc=9yi-M_P=+L+Q@mail.gmail.com> <20140305120550.GO5018@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 02:05:50 PM Mika Westerberg wrote:
> On Wed, Mar 05, 2014 at 10:49:41AM +0800, Linus Walleij wrote:
> > On Tue, Feb 25, 2014 at 12:00 AM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > 
> > > Sometimes it is useful to allow GPIO chips themselves to request GPIOs they
> > > own through gpiolib API. One usecase is ACPI ASL code that should be able
> > > to toggle GPIOs through GPIO operation regions.
> > >
> > > We can't really use gpio_request() and its counterparts because it will pin
> > > the module to the kernel forever (as it calls module_get()). Instead we
> > > provide a gpiolib internal functions gpiochip_request/free_own_desc() that
> > > work the same as gpio_request() but don't manipulate module refrence count.
> > >
> > > Since it's the GPIO chip driver who requests the GPIOs in the first place
> > > we can be sure that it cannot be unloaded without the driver knowing about
> > > that. Furthermore we only limit this functionality to be available only
> > > inside gpiolib.
> > >
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > I fully trust you in doing the ACPI stuff in patches 2-n but on this patch
> > in particular I want Alexandre's review tag as well, as he's working
> > actively with the descriptor API and I don't want to add too many quirks
> > without his consent.
> 
> Thanks for your trust :)
> 
> > So Alexandre, what do you say about this?
> 
> I'm about to send v2 of the series with Rafael's comments taken into
> account. However, I stumbled to another locking problem:
> 
> I'm going to move taking the gpio_lock outside of __gpiod_request() and
> have __gpiod_request() to release that lock, so that we can call
> chip->request() safely.
> 
> Since we are using _irqsave()/_irqrestore() versions, it means that I need
> to pass flags as a pointer from gpiod_request() to __gpiod_request() like:
> 
> 	spin_lock_irqsave(&gpio_lock, flags);
> 	if (try_module_get(chip->owner)) {
> 		ret = __gpiod_request(desc, label, &flags);

Ouch.  Sorry for overlooking that.

> 		...
> 
> Is that acceptable or can you guys suggest some alternative? One
> alternative that I can think about is to have __gpiod_request() to take the
> lock and move try_module_get() outside to gpiod_request():
> 
> __gpiod_request()
> {
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&gpio_lock, flags);
> 	...
> }
> 
> gpiod_request():
> {
> 	...
> 	if (try_module_get(chip->owner)) {
> 		ret = __gpiod_request(desc, label);
> 		...
> }
> 
> Thoughts?

If that works, it would be better than passing the flags IMO.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
