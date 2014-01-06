Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaAFIds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:33:48 -0500
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:44208 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaAFIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:33:45 -0500
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 03:33:44 EST
X-Originating-IP: 50.43.14.201
Date: Mon, 6 Jan 2014 00:17:35 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH] drivers: Remove unused devm_*_put functions
Message-ID: <20140106081735.GA27508@leaf>
References: <20131221104920.GA3626@rashika>
 <CACRpkdYyFXt1g-fL9dUTwQLnT4senUjvRpehc6yuQ9rV4ztwSA@mail.gmail.com>
 <CAAVeFuJug5wNZrSr5UcP8w8E0a3iYF=bcNEzJgQaZ=u4CX8Daw@mail.gmail.com>
 <20140103202215.GA12111@leaf>
 <CAAVeFuLgDRKy3a0JOoLxjZjbtbE8s5vpPV+HPe9A-Z2ua8xTGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuLgDRKy3a0JOoLxjZjbtbE8s5vpPV+HPe9A-Z2ua8xTGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 04:48:39PM +0900, Alexandre Courbot wrote:
> On Sat, Jan 4, 2014 at 5:22 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Fri, Jan 03, 2014 at 08:07:22PM +0900, Alexandre Courbot wrote:
> >> On Thu, Jan 2, 2014 at 10:07 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> >> > On Sat, Dec 21, 2013 at 11:49 AM, Rashika Kheria
> >> > <rashika.kheria@gmail.com> wrote:
> >> >> -/**
> >> >> - * devm_gpiod_put - Resource-managed gpiod_put()
> >> >> - * @desc:      GPIO descriptor to dispose of
> >> >> - *
> >> >> - * Dispose of a GPIO descriptor obtained with devm_gpiod_get() or
> >> >> - * devm_gpiod_get_index(). Normally this function will not be called as the GPIO
> >> >> - * will be disposed of by the resource management code.
> >> >> - */
> >> >> -void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
> >> >> -{
> >> >> -       WARN_ON(devres_release(dev, devm_gpiod_release, devm_gpiod_match,
> >> >> -               &desc));
> >> >> -}
> >> >> -EXPORT_SYMBOL(devm_gpiod_put);
> >> >
> >> > Alexandre what do you think about this? Can we think of a scenario
> >> > where explicit garbage collection is going to be needed or should we
> >> > remove this for now?
> >>
> >> Sorry for the delayed reply, I quickly saw the patch and then the
> >> holidays got in the way. :)
> >>
> >> I think all these functions should be kept. It is true that they are
> >> seldomly used, and that the purpose of devm is to garbage-collect
> >> resources upon driver removal, but they might (actually, probably
> >> will) become needed by someone at some point in the future. One
> >> example I can think of is two drivers that collaborate to share the
> >> same GPIO line. If they acquire the GPIO through devm_gpiod_get() they
> >> will need devm_gpiod_put() to release it so the other driver can
> >> acquire it.
> >>
> >> On a more general note, devm_clk_put(), devm_regulator_put(),
> >> devm_pinctrl_put() and probably others devm_*_put() functions are
> >> actively used in the kernel, to  support the idea that a devm removal
> >> function makes sense. That not all the subsystem-provided functions
> >> are used by mainline drivers does not necessary mean they should be
> >> removed, especially if they serve a purpose. We should keep our APIs
> >> consistent and future-proof, not to mention out-of-tree drivers that
> >> may use them.
> >>
> >> So this patch is a nack as far as I'm concerned, not only the GPIO
> >> part, but the whole of it.
> >
> > As far as I can tell, the few calls to the devm_*_put functions I can
> > see look like unnecessary calls as part of driver/device
> > uninitialization, and could be removed either directly or with minor
> > reworking.  That there are only 1-2 calls to each in the entire kernel
> > is also quite telling.
> >
> > In any case, it's disappointing to have a pile of unused functions in
> > the kernel on the theory that they *might* be needed; it's not like it'd
> > be hard to retrieve them from git if they're ever needed.
> 
> My motivation is mainly API consistency ; and these functions are
> small enough to not worry too much about them IMHO. If we *really*
> want to get rid of them when they are unneeded, how about defining
> them as static inline in the corresponding header file? Since they are
> short and seldomly used (when used at all), this may be an acceptable
> compromise.

That seems quite reasonable.

> > However, if you're insistent on keeping them, it'd be easy enough to
> > provide patches to include an appropriate header with prototypes for
> > them instead, which would also eliminate the warning this patch series
> > set out to eliminate.
> 
> The patch did not mention any warning, unless I missed something.
> Would be nice to explicitly mention it in the commit message.

This patch and the others like it are seeking to eliminate
-Wmissing-prototypes warnings from GCC and -Wdecl warnings from Sparse,
caused by having functions that are neither static nor prototyped in
advance.

- Josh Triplett
