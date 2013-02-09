Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3BIKLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:11:48 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39242 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3BIKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:10:05 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
To: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
In-Reply-To: <CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-8-git-send-email-acourbot@nvidia.com> <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com> <CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com>
Date: Sat, 09 Feb 2013 09:17:29 +0000
Message-Id: <20130209091729.978C73E1A18@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 15:57:32 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> On Wed, Feb 6, 2013 at 2:53 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> >> +/**
> >> + * Convert a GPIO number to its descriptor
> >> + */
> >> +static struct gpio_desc *gpio_to_desc(unsigned gpio)
> >> +{
> >> +       if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
> >> +               return NULL;
> >
> > Don't we want to return ERR_PTR(-EINVAL); here?
> >
> > Then you can use IS_ERR() on the pointers later.
> >
> > This is the approach taken by the external API for clk
> > and pins.
> 
> Yes, that completely makes sense.
> 

No, it does not. The ERR_PTR()/IS_ERR() is a horrible pattern for code
readability because it breaks the expectations that programmers have for
what is and is not a bad pointer. There are decades of history where the
test for a bad pointer is 'if (!ptr)'. Not only does ERR_PTR make make
that test not work, but the compiler won't tell you when you get it
wrong.

There are places where ERR_PTR makes sense. Particularly when
communicating with userspace where error codes have very specific
meanings, but I don't want it in the GPIO subsystem.

g.

