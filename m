Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbbACNMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 08:12:30 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:47694 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbACNM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 08:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141224215352.GA26482@sysresccd>
References: <20141224215352.GA26482@sysresccd>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 3 Jan 2015 14:12:06 +0100
Message-ID: <CAAVeFuJcWizqtW4mmD8ow5eg2841vgXhZ=7bHDiO3ZJfE2ezog@mail.gmail.com>
Subject: Re: Linux GPIO internals
To: Michael Welling <mwelling@emacinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Roland Stigge <stigge@antcom.de>,
        Wolfgang Grandegger <wg@grandegger.com>, tstratman@emacinc.com,
        Rojhalat Ibrahim <imr@rtschenk.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, sorry for the delayed reply on this interesting issue.

On Wed, Dec 24, 2014 at 10:53 PM, Michael Welling <mwelling@emacinc.com> wrote:
> All,
>
> For years now EMAC has provided an out-of-tree series of class drivers
> for accessing various devices. The EMAC GPIO class and character
> interfaces predate the introduction of the gpiolib interface and have
> been ported across several kernel versions.
>
> http://wiki.emacinc.com/wiki/Using_the_EMAC_GPIO_Class
>
> Recently we have come to the conclusion that continuing to provide
> support for these drivers is getting out of hand. It was agreed that we
> move away from our non-standard drivers and use mainstream drivers for our
> newest products.
>
> That being said, we would like to be able to provide the capabilities
> of our old drivers but it is not the case with the current gpiolib
> implementation.
>
> Here are the major concerns that we have with the gpiolib implementation:
> - There is no mechanism to provide simultaneous access to multiple
>   GPIOs from userspace.
> - The sysfs interface seems to vastly slower than the character
>   interface and it is far more cumbersome to handle access from a
>   userspace C program.
>
> It seems that the first concern was attempted to be addressed by the
> following patch:
> https://lkml.org/lkml/2012/12/23/66
>
> It seems this effort dropped off the radar in January of 2013.
> What happened to this patch?
>
> As for the second issue, I am not sure how to resolve this and am open
> to ideas. I have seen similar concerns in other subsystem that use the
> sysfs interface.
>
> IIO example:
> http://www.spinics.net/lists/linux-iio/msg15344.html
>
> Suggestions?

It seems like your mail is coming just at the right time. We have
recently merged a patch that allows setting several GPIOs at the same
time, if the hardware supports it:

http://patchwork.ozlabs.org/patch/406666/

It lacks sysfs support, but we are also increasingly feeling the
pressure of the old sysfs interface and are planning to develop a new
one:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/311158.html

Our main gripe with the old sysfs interface is its use of the
(potentially varying) integer GPIO namespace, and we would like one
that relies on the new gpiod_ functions. But while we are at it, we
could just as well support GPIO groups and try to make things faster,
although I am not sure why sysfs would be slower than a character
device.

On the top of my head, I think we could have an export interface that
allows to export a group of GPIOs under a given name, and to
manipulate them using gpiod_set/get_array(). Single GPIOs could be
exported as a group of 1.

I have looked at the EMAC GPIO class (very low level, and clearly tied
to a given subset of GPIO hardware), and anything that makes it
upstream would need to feature considerably more abstraction, but we
can certainly try to work something out.

Considering the constraints that we have (no GPIO integers for
exporting, sysfs-based, uses gpiod_*array()), do you think we could
satisfy your goals as well?
