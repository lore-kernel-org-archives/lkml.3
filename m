Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaIWP1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:27:22 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36756 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbaIWP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:27:20 -0400
MIME-Version: 1.0
In-Reply-To: <1410868367-11056-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410868367-11056-7-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 23 Sep 2014 17:27:19 +0200
Message-ID: <CACRpkdaMboJa4e7PyxDQCFX_+a0Odr57i-00qs0bJePkBqfaYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 06/16] gpio / ACPI: Add support for _DSD device properties
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> With release of ACPI 5.1 and _DSD method we can finally name GPIOs (and
> other things as well) returned by _CRS. Previously we were only able to
> use integer index to find the corresponding GPIO, which is pretty error
> prone if the order changes.
>
> With _DSD we can now query GPIOs using name instead of an integer index,
> like the below example shows:
>
>   // Bluetooth device with reset and shutdown GPIOs
>   Device (BTH)
>   {
>       Name (_HID, ...)
>
>       Name (_CRS, ResourceTemplate ()
>       {
>           GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
>                   "\\_SB.GPO0", 0, ResourceConsumer) {15}
>           GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
>                   "\\_SB.GPO0", 0, ResourceConsumer) {27, 31}
>       })
>
>       Name (_DSD, Package ()
>       {
>           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>           Package ()
>           {
>               Package () {"reset-gpio", Package() {^BTH, 1, 1, 0 }},
>               Package () {"shutdown-gpio", Package() {^BTH, 0, 0, 0 }},
>           }
>       })
>   }
>
> The format of the supported GPIO property is:
>
>   Package () { "name", Package () { ref, index, pin, active_low }}
>
>   ref - The device that has _CRS containing GpioIo()/GpioInt() resources,
>         typically this is the device itself (BTH in our case).
>   index - Index of the GpioIo()/GpioInt() resource in _CRS starting from zero.
>   pin - Pin in the GpioIo()/GpioInt() resource. Typically this is zero.
>   active_low - If 1 the GPIO is marked as active_low.
>
> Since ACPI GpioIo() resource does not have field saying whether it is
> active low or high, the "active_low" argument can be used here. Setting
> it to 1 marks the GPIO as active low.
>
> In our Bluetooth example the "reset-gpio" refers to the second GpioIo()
> resource, second pin in that resource with the GPIO number of 31.
>
> This patch implements necessary support to gpiolib for extracting GPIOs
> using _DSD device properties.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

If Rafael is happy with this approach, and you decide to take it
through the ACPI tree.

Yours,
Linus Walleij
