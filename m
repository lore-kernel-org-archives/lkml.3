Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaIXKZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:25:32 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61238 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaIXKZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZGBe1UfazBUgtq=oHgRpFPkRcxYtJz++JgUbzUSiOsyg@mail.gmail.com>
References: <1409930524-1529-1-git-send-email-octavian.purdila@intel.com>
	<CACRpkdZGBe1UfazBUgtq=oHgRpFPkRcxYtJz++JgUbzUSiOsyg@mail.gmail.com>
Date: Wed, 24 Sep 2014 13:25:29 +0300
Message-ID: <CAE1zotJ8J-qP+HM0GSXJ0WL-GcGGOEGKEW-X2Fd6F=1gQbFBww@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix a few issues with gpiochip_remove
From: Octavian Purdila <octavian.purdila@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:51 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Fri, Sep 5, 2014 at 5:22 PM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
>
>> The current implementation of gpiochip_remove() does not check to see
>> if the GPIO pins are busy before removing the associated irqchip and
>> this is causing the following warning:
> (...)
>> A retry operation is needed in the case of MFD devices that bundles a
>> GPIO device and another device that is an indirect consumer of the
>> GPIO device (typical an I2C bus).
>
> We have just finalized a set of patches making gpiochip_remove()
> not return an error code, because it just must work.
>
> It seems like this patch want us to sort of reverse that whole train
> of work and go back to the old style of having gpiochip_remove()
> be able to fail :-/
>
> I would suggest that if this usecase is to be supported for thing
> like MFD devices, we need to introduce gpiochip_try_remove()
> in parallel with the current implementation, so that those drivers
> that actually want to retry the remove the chip can use that
> interface explicitly.
>
> Can you look into this option?
>
> Please also look over gpiochip_remove() as it looks right now
> in linux-next...
>

I was not aware of the changes to gpiochip_remove() when I sent this
patch and I do agree that it is better to have gpiochip_remove() not
be able to fail.

The main issue is actually with USB devices not necessarily MFD. If
the USB device is unplugged while IRQ GPIOs are requested then I see
the issues mentioned in the patch.

I will try to rework the patch to use the assumption that
gpiochip_remove() must not fail. That will likely need adding some
reference counting when calling gpiod_request() and gpiod_free().
