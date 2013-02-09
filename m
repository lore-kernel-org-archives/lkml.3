Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab3BIOQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:16:14 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47273 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3BIOQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:16:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130209131158.22FD53E30EC@localhost>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-8-git-send-email-acourbot@nvidia.com> <20130209131158.22FD53E30EC@localhost>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 9 Feb 2013 23:15:52 +0900
X-Google-Sender-Auth: U8IV_yicOqkhP5HhcQNfJzSlQRo
Message-ID: <CAAVeFu+JOd64rUquq_F1e1g8DVdHSN6qeE6sg9wrPNo1-+0Z-g@mail.gmail.com>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 10:11 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> I've been thinking about the adding of a new API to supplant the old,
> and I'm wondering if we're going about this the wrong way around; at
> least for the public api. We've moved to a model where device drivers
> are really supposed to tread GPIO numbers as opaque handles. Most device
> drivers are well behaved on this point. (Others of course are not so
> well behaved and either hard code or interpret what a number means, but
> those users already need to be fixed before they will work with the
> device tree)
>
> Rather than creating a new API with a long-term-plan to move all old
> users to the new API - touching a lot of code all over the kernel in the
> process - what if we repurposed the existing API in a backwards
> compatible way.
>
> I think the maximum GPIO number I've seen in use is 65535, and that was
> based on dynamic allocation. What if we did the following:
>
> typedef unsigned long gpio_handle_t;
>
> struct gpio_desc *gpio_handle_to_desc(gpio_handle_t gpio)
> {
>         if (gpio <= NR_GPIOS)
>                 return &gpio_desc[gpio];
>         return (struct gpio_desc *)gpio;
> }
>
> int gpio_get_direction(gpio_handle_t gpio)
> {
>         struct gpio_desc *desc = gpio_handle_to_desc(gpio);
>         if (!desc)
>                 return -EEXIST;
>         return gpiod_get_direction(desc);
> }
>
> And do the same for all the other hooks. That will make the gpio changes
> much lower impact across the kernel, allow legacy gpio users to keep
> doing what they are doing, and encourage driver authors to keep out of
> the gpio_desc internals.

So if I understand correctly, this means reserving the range
[0..65535] for integer GPIOs, assuming that anything bigger is a
descriptor (that have been acquired properly using some gpio_get()
function), and keep using the same interface for both cases? I'm not
sure what to think yet, in a way I find the idea elegant and less
traumatic to current GPIO users. On the other hand, I wonder if we
will not run into some walls.

Here is one I can think of right now: what should gpio_is_valid()
return? If the parameter is in the integer range, no problem, it's
valid. If it's bigger, we could check the validity of the pointer if
we use the gpio_desc[] static array that currently exist, but if we
eventually manage to get rid of it things would become harder. Also,
let's say we do gpio_is_valid(0). Is it the GPIO number 0, which is
valid, or a NULL pointer which is invalid? It might also bring some
confusion that the nature of GPIOs depends on the way they are
acquired (integers for gpio_request(), pointers for gpio_get()). Some
users might use gpio_get(), expect to get a number, and be puzzled.

I am not particularly fond of the idea of introducing a new API that
is nearly identical to one that already exists, but it has the merit
of keeping things clear. I also think we should consider this state as
a transition towards the elimination of the GPIO integer API. I might
be misguided to wish for that, but right now I can only see two things
that would prevent us from achieving this:

1) The fast-path that some platforms implemented in their definition
of gpio_get_value() and gpio_set_value() where they directly invoke
their controller's function inline for GPIOs which values are known at
compile time (can't do that with pointers AFAICT)
2) The sysfs interface. But we could still keep the integer space for
that sole purpose and not use it for our in-kernel APIs.

Actually only 1) is a real blocker. Also in the case we cannot/do not
want to get rid of it, keeping the legacy gpio API as a wrapper around
gpiod as I proposed in an earlier RFC should probably not be too
painful (only a single .h file to maintain).

Alex.
