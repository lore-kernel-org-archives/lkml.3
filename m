Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbbAERrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:47:33 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:39683 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbbAERrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:47:32 -0500
Date: Mon, 5 Jan 2015 11:47:23 -0600
From: Michael Welling <mwelling@emacinc.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Roland Stigge <stigge@antcom.de>,
        Wolfgang Grandegger <wg@grandegger.com>, tstratman@emacinc.com,
        Rojhalat Ibrahim <imr@rtschenk.de>
Subject: Re: Linux GPIO internals
Message-ID: <20150105174723.GA11391@sysresccd>
References: <20141224215352.GA26482@sysresccd>
 <CAAVeFuJcWizqtW4mmD8ow5eg2841vgXhZ=7bHDiO3ZJfE2ezog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuJcWizqtW4mmD8ow5eg2841vgXhZ=7bHDiO3ZJfE2ezog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 02:12:06PM +0100, Alexandre Courbot wrote:
> Hi Michael, sorry for the delayed reply on this interesting issue.
> 
> On Wed, Dec 24, 2014 at 10:53 PM, Michael Welling <mwelling@emacinc.com> wrote:
> > All,
> >
> > For years now EMAC has provided an out-of-tree series of class drivers
> > for accessing various devices. The EMAC GPIO class and character
> > interfaces predate the introduction of the gpiolib interface and have
> > been ported across several kernel versions.
> >
> > http://wiki.emacinc.com/wiki/Using_the_EMAC_GPIO_Class
> >
> > Recently we have come to the conclusion that continuing to provide
> > support for these drivers is getting out of hand. It was agreed that we
> > move away from our non-standard drivers and use mainstream drivers for our
> > newest products.
> >
> > That being said, we would like to be able to provide the capabilities
> > of our old drivers but it is not the case with the current gpiolib
> > implementation.
> >
> > Here are the major concerns that we have with the gpiolib implementation:
> > - There is no mechanism to provide simultaneous access to multiple
> >   GPIOs from userspace.
> > - The sysfs interface seems to vastly slower than the character
> >   interface and it is far more cumbersome to handle access from a
> >   userspace C program.
> >
> > It seems that the first concern was attempted to be addressed by the
> > following patch:
> > https://lkml.org/lkml/2012/12/23/66
> >
> > It seems this effort dropped off the radar in January of 2013.
> > What happened to this patch?
> >
> > As for the second issue, I am not sure how to resolve this and am open
> > to ideas. I have seen similar concerns in other subsystem that use the
> > sysfs interface.
> >
> > IIO example:
> > http://www.spinics.net/lists/linux-iio/msg15344.html
> >
> > Suggestions?
> 
> It seems like your mail is coming just at the right time. We have
> recently merged a patch that allows setting several GPIOs at the same
> time, if the hardware supports it:
> 
> http://patchwork.ozlabs.org/patch/406666/
>

This looks like a good starting point. Being able to access to multiple
GPIOs simultaneously on the same controller bank is great.

What is nice about the EMAC class is that the GPIOs do not necessarily
have to be on the same bank (or controller) to be grouped together. The
system call overhead of accessing a single IO is the same as multiple
IOs in the same group.

Still wondering what happened to the gpioblock patch.

> It lacks sysfs support, but we are also increasingly feeling the
> pressure of the old sysfs interface and are planning to develop a new
> one:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/311158.html
> 
> Our main gripe with the old sysfs interface is its use of the
> (potentially varying) integer GPIO namespace, and we would like one
> that relies on the new gpiod_ functions. But while we are at it, we
> could just as well support GPIO groups and try to make things faster,
> although I am not sure why sysfs would be slower than a character
> device.

The with the migration from the legacy GPIO namespace it only seems
natural for the sysfs interface to follow. Adding groups in the process
would provide most of what is needed.

The sysfs interface is great for command line and scripting languages
but it has more overhead. It requires string conversion at both the
kernel and userspace. More system calls are typically required for
similar transactions.

> 
> On the top of my head, I think we could have an export interface that
> allows to export a group of GPIOs under a given name, and to
> manipulate them using gpiod_set/get_array(). Single GPIOs could be
> exported as a group of 1.
>

This sounds good. Currently we group the IOs with devicetree
registrations.

http://git.emacinc.com/source/linux-at91.git/blob/linux-3.10-at91/arch/arm/boot/dts/ipac-9x25.dts#L226

It would be nice if it were possible to create the groups from
userspace.

> I have looked at the EMAC GPIO class (very low level, and clearly tied
> to a given subset of GPIO hardware), and anything that makes it
> upstream would need to feature considerably more abstraction, but we
> can certainly try to work something out.

I am more worried about standardizing EMAC's code base than pushing our
old code into the mainline.

> 
> Considering the constraints that we have (no GPIO integers for
> exporting, sysfs-based, uses gpiod_*array()), do you think we could
> satisfy your goals as well?

This should be satisfactory for most use cases. I will try to support
efforts toward modernizing the sysfs interface.

Would a character interface to gpiolib ever be considered? 
