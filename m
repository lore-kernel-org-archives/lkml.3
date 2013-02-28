Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3B1DDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 22:03:21 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47234 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3B1DDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 22:03:19 -0500
Date: Wed, 27 Feb 2013 18:59:31 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
Message-ID: <20130228025931.GA13764@lizard.gateway.2wire.net>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227231826.GA30154@lizard.fhda.edu>
 <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
 <20130228013514.GA7556@lizard.fhda.edu>
 <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:17:06PM -0500, Paul Gortmaker wrote:
[...]
> > Testing patches takes time, and if I have to do it for all bunch of
> > different machines and architectures, it becomes mess and unmanageable. In
> 
> So, you actually want my change then -- you do not want to test for
> goldfish power issues unless goldfish is selected.  This is how I see
> the situation.

No, I want to cover as much as possible code in one go. This is not 'all
or nothing' thing, plus I can't test whether the driver actually works,
but testing that it compiles is a great deal, because quite often patches
just don't compile. :-)

And part of my task is to catch the trivial errors (but not all! 99% of
them). Putting unneeded(!) 'depends on' makes my life harder.

> > another words, it is easier for me to use as little different
> > setups/.configs/cross-compilers/trees/etc as possible.
> >
> > For example, here is the scenario:
> >
> > - someone sends me a patch for goldfish driver;
> > - I quickly compile it on my [underpowered] x86 laptop without need for
> >   cross-compilation and special configs;
> > - It compiles fine, produces no warnings, so I happily send out the
> >   'Applied, thanks!' email;
> 
> I can not see how the above is at all relevant.  If someone sends you a
> patch for ARCH != x86, then your workflow will fail, regardless of what
> actually is within the patch.

Again, it is not 'all or nothing'. If the patch, supposedly, for Alpha, I
won't even bother compile-testing it. Instead, I will spend more brain
power to look into the patch, and see if it is actually sane. Doing so
will take 5 seconds more of my time for this single patch for the rare
architecture, instead of *hours* setting up cross tools and compile the
patch for this weird arch.

> As a maintainer, you need to be able to
> handle cross compiles -- you can't escape the slightly more detailed
> testing requirements we need to get from subsystem maintainers.  There
> are cross compile capable toolchains on kernel.org, and I use them
> regularly before sending out changes that can impact multiple arch.
> 
> ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/
> 
> We can forgive individual contributors for not being arch aware, but
> at the subsystem maintainer level, folks should be arch aware, and
> doing regular x-compiles.

Seriously? You mean, as a maintainer, I must compile it for every weird
architecture out there? No way. I care not to break 99% users -- x86, and
maybe ARM. If MIPS guys (or automated linux-next builds) see an error, I
will fix it -- but by no chance I will spend my time compiling myself for
all the crazy architectures and configs for every patch that I apply.

But don't get me wrong, I am perfectly fine with actually testing the
patches on any weird arches -- if you are ready to lend me time on a ready
to use cloud-based automated build farm with all kinds of cross tools, I
will set up a 'testing' branch and will use it for compile-testing.

> > Now, with your patch:
> >
> > - Someone sends me a patch for goldfish driver;
> > - I starting to look for my cross-compilers collections, making all the
> >   environment setups, setting up a new build tree, looking for the
> >   outdated goldfish config, the ARM thing fails to build somewhere in
> >   arch/arm/plat-foo and drivers/mfd/bar. I become grumpy... and, you might
> >   not believe me, I open and edit drivers/power/Kconfig and remove
> 
> I am confused here.  If there are correct depends lines here in the Kconfig,
> then it _protects_ you from suffering like this.

No, if it says 'depends on FLUFFY_ARCH', it says that all that
'1%-users-fluffy-arch' must be buildable so that I could test the single
patch. Which is so often not true, the fluffy arches are quite often
broken. (Unlike x86, since we have tons of users for x86.)

So for me it is easier to remove the 'depends on FLUFFY_ARCH' and
compile-test it on x86, if that is possible (and in case of goldfish it is
surely possible).

> Yet, you want me to think
> that it adds new work, new cross compile requirements and so on.  I do
> not see how that can possibly happen.

Without additional 'depends on' I cover 99% of drivers, that is enough.
Again, I am not trying to be perfect.

> 
> >   needless 'depends on' (that is, I actually do these kind of things when
> >   I feel lazy enough).
> >
> > Do you agree that without the additional deps life is easier for me? :)
> 
> No, I do not agree.  In fact I see it as totally the opposite.  But I already
> said that I would not pursue this further, based only on differing points
> of view, and so, after sending this, I will adhere to that now.

I see. In that case, please feel free to send the patch to akpm with my
Nack and pointing to this discussion. If Andrew agrees and I was wrong
(and I'm really curious whether I am right or wrong), I will start
applying such patches in future.

Thanks,

Anton
