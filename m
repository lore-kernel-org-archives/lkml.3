Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaBLRqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:46:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13552 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752013AbaBLRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:46:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1969vVG88TuPjr0WeCsV5roHFOEF6SEgmw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0D8F0525C61
Date: Wed, 12 Feb 2014 12:45:54 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>, keescook@chromium.org
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140212174554.GM27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <201402121251.06280.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402121251.06280.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laura,

Sorry to hijack the thread (sort of).  :)

+ Kees Cook

On Wed, Feb 12, 2014 at 12:51:05PM +0100, Arnd Bergmann wrote:
> On Wednesday 12 February 2014, Laura Abbott wrote:
> > This is an RFC to seed the random number pool earlier when using devicetree.
> > The big issue this is trying to solve is the fact that the stack canary for
> > ARM tends to be the same across bootups of the same device. This is because
> > the random number pools do not get initialized until after the canary has
> > been set up. The canary can be moved later, but in general there is still
> > no way to reliably get random numbers early for other features (e.g. vector
> > randomization).
> 
> Implementation-wise this looks reasonable, and it obviously addresses a
> very real problem.
> 
> > The goal here is to allow devices to add to the random pools via
> > add_device_randomness or some other method of their chosing at FDT time.
> > I realize that ARCH_RANDOM is already available but this didn't work because
> > 1) ARCH_RANDOM is not multi-platform compatible without added
> > infrastructure to ARM
> 
> That could certainly be done, but I agree that a more generic
> approach like you did is nicer. One thing that might be useful
> would be to wire up your OF_RANDOM infrastructure as a generic
> implementation of ARCH_RANDOM, and merge your header file into
> include/asm-generic/archrandom.h, with an added way to call
> arch_get_random_long() for the devices you add.
> 
> > The big reason to skip ARCH_RANDOM though is that the random number generation
> > we have would be reasonable if only seeded earlier.
> 
> Yes, makes sense.
> 
> I also wonder if we should add a 'trivial' implementation that just
> reads a DT property full of random numbers to use as either an initial
> seed, or to feed into arch_get_random_long(). This would allow the
> boot loader to pass any entropy it has already gathered into the kernel,
> but leaves the danger that people might pass static not-so-random data
> through a precompiled dtb file ;-). If we get the boot loaders to be
> smart enough, doing only this would be a much simpler kernel implementation
> than your suggestion, but I'm not sure how far I want to trust boot loaders.

I brought this up at last weeks devicetree irc meeting.  My goal is to
provide early randomness for kaslr on ARM.  Currently, my idea is modify
the init script to save an additional random seed from /dev/urandom to
/boot/random-seed.

The bootloader would then load this file into ram, and pass the
address/size to the kernel either via dt, or commandline.  kaslr (run in
the decompressor) would consume some of this randomness, and then
random.c would consume the rest in a non-crediting initialization.

While not ideal, it works in absence of an HRNG, and is no worse than
the current situation of storing the seed in /var/lib/misc/random-seed.
It also doesn't require modification of the bootloaders.  Just an
updated kernel, and update the bootloader environment to load the
seed.

Unfortunately, it's an idea so far.  I have one project to get off of my
plate, then this is next :)

thx,

Jason.
