Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaKAGNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 02:13:54 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52902 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKAGNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 02:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbhEBQfEpkK6-4GNyTQvvJ2qJ+RfXUULJNxvrbrpv1NAg@mail.gmail.com>
References: <1414447799-1284-1-git-send-email-matthias.klein@linux.com>
 <544ECAB2.3060706@wwwdotorg.org> <544ECFB4.7040704@linux.com> <CACRpkdbhEBQfEpkK6-4GNyTQvvJ2qJ+RfXUULJNxvrbrpv1NAg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 1 Nov 2014 15:13:31 +0900
Message-ID: <CAAVeFuL-D9Z+6zbEt0x1kv7f8iHH9z94jjrqkpa89QO8SK3SUg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthias Klein <matthias.klein@linux.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 6:49 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Oct 28, 2014 at 12:05 AM, Matthias Klein
> <matthias.klein@linux.com> wrote:
>> Am 27.10.2014 um 23:44 schrieb Stephen Warren:
>
>>> What's the motivation for this? The GPIO IDs should all come from DT,
>>> which encodes everything as an ID relative to a particular controllers, and
>>> hence the actual value of the base address should be irrelevant.
>>
>> - To be in sync with the GPIO numbers in the datasheet / documentation
>
> We are moving away from global GPIO numbers because they are
> an eternal pain. We would replace them with a local offset number
> just as the second column in /proc/interrupts
>
> Hm we should patch <debugfs/gpio> to show local offsets...
>
>> - For userland applications which rely on these GPIO numbers
>
> ARGH!!!
>
> A much better idea is to add labels to your GPIOs so you can
> identify them by name. Augment the driver with labeling capability
> if need be, see e.g. commit 781f6d710d4482eab05cfaad50060a0ea8c0e4e0
> "gpio: generic: Add label to platform data"
>
> You just need to figure out how to do the same naming from the
> device tree. Maybe some new binding is needed, others are
> discussing how to do exporting of GPIOs from devicetree
> anyway, see the mailing list.

On a related note we are feeling more and more pressure for a way to
unambiguously access GPIOs from user-space, and we should probably try
and come with a solution for this. Ideas so far:

1) Export GPIOs with a name - it seems like this one will happen soon.

2) Export GPIOs using their controller-relative number (instead of
their global number) under the controller's sysfs node. But since
controllers are also named after the first global number they manage,
we would still have a problem here.

In any case this reliance of user-space on particular GPIO numbers is
becoming a burden. We will soon get rid of the global
ARCH_NR_GPIOS-sized array of gpio_descs, and the next step would be to
get rid of the ARCH_NR_GPIOS itself. However, this macro is used to
decide the starting number for GPIO chips without an explicit "base"
attribute, so I am not sure whether we can remove it at all, unless we
can agree that GPIO numbers are variable and not part of the ABI.
