Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3FMHno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:43:44 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64831 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3FMHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <201306131043366877997@gmail.com>
References: <1371047193-14228-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<201306131043366877997@gmail.com>
Date: Thu, 13 Jun 2013 09:43:42 +0200
Message-ID: <CACRpkdbe+9Bgv+8Lfm2=i=Rd+x08ZdmBwy35NE1JgXOCnqwgWw@mail.gmail.com>
Subject: Re: pinctrl:when two device use the same pin
From: Linus Walleij <linus.walleij@linaro.org>
To: xulinuxkernel <xulinuxkernel@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 4:43 AM, xulinuxkernel <xulinuxkernel@gmail.com> wrote:

> I am using the kernel pinctrl subsystem, and I have a problem,when two
> devices use the same pin,how about the consumer devices handle the conflict
> pins? some thing like this:
> assumer the device A and B use the same pin pin0,
> device A:                                                            device
> B calling the API
> devm_pinctrl_get_select(&dev_a,"dev_a");
> devm_pinctrl_get_select(&dev_b,"dev_b");
> then the deviceB should be return error,or wait for device A  release pin0?
> like schedule()? or something else?

So you have one of two problems:

- You are trying to probe two drivers on the system, both making
  use of the same pins *at the same time*, this would obviously
  be plain wrong. In this case the solution would be not to add
  the unused device in the first place.

- You are using the same pins with two different devices at
  runtime, i.e. dev A and B actually use the same pins on the
  same one running system.

I assume it's the latter situation, which appear in a few practical
situations, such as a SD card slot being reconfigured into a debug
port becuase we want to get some non-SD-type data out on the
SD card connector. (We have this on the ux500.)

The solution to this situation is described in Documentation/pinctrl.txt
under the heading "Runtime pinmuxing", below is a copy but I think
the basic problem is that you rely on devm_pinctrl_get_select()
to be done at probe instead of retrieveing the pinctrl state handlers
and activeley switching between them at runtime using
pinctrl_select_state() which is what you should do.

Device A should have two states: one which is not using any
pins, and one where it's actively using it's pins, and the same
for device B. At runtime, the drivers shall just activate the state
using the pins when they actually do that.


Copy from Documentation/pinctrl.txt:

Runtime pinmuxing
=================

It is possible to mux a certain function in and out at runtime, say to move
an SPI port from one set of pins to another set of pins. Say for example for
spi0 in the example above, we expose two different groups of pins for the same
function, but with different named in the mapping as described under
"Advanced mapping" above. So that for an SPI device, we have two states named
"pos-A" and "pos-B".

This snippet first muxes the function in the pins defined by group A, enables
it, disables and releases it, and muxes it in on the pins defined by group B:

#include <linux/pinctrl/consumer.h>

struct pinctrl *p;
struct pinctrl_state *s1, *s2;

foo_probe()
{
        /* Setup */
        p = devm_pinctrl_get(&device);
        if (IS_ERR(p))
                ...

        s1 = pinctrl_lookup_state(foo->p, "pos-A");
        if (IS_ERR(s1))
                ...

        s2 = pinctrl_lookup_state(foo->p, "pos-B");
        if (IS_ERR(s2))
                ...
}

foo_switch()
{
        /* Enable on position A */
        ret = pinctrl_select_state(s1);
        if (ret < 0)
            ...

        ...

        /* Enable on position B */
        ret = pinctrl_select_state(s2);
        if (ret < 0)
            ...

        ...
}

The above has to be done from process context. The reservation of the pins
will be done when the state is activated, so in effect one specific pin
can be used by different functions at different times on a running system.


Yours,
Linus Walleij
