Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbbASGAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:00:17 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61860 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbASGAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:00:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY-yFKsYbCrMpnViMFoQEugyGQivaV0M+GDzLrbDO7i6Q@mail.gmail.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
 <CACRpkdY-yFKsYbCrMpnViMFoQEugyGQivaV0M+GDzLrbDO7i6Q@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 19 Jan 2015 14:59:54 +0900
Message-ID: <CAAVeFuJUxad0dJ9vK1DaDJPDLM+rc5b77=PgcJT5+Bv1=iWGxg@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 9:58 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Dec 18, 2014 at 9:23 AM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
>
>> This makes it possible to assign GPIOs at runtime. The
>> motivation for it is because of need to forward GPIOs from
>> one device to an other. That feature may be useful for
>> example with some mfd devices, but initially it is needed
>> because on some Intel Braswell based ACPI platforms the GPIO
>> resources controlling signals of the USB PHY are given to
>> the controller device object for whatever reason, so the
>> driver of that controller needs be able to pass them to the
>> PHY device somehow.
>>
>> So basically this is meant to allow patching of bad (bad
>> from Linux kernels point of view) hardware descriptions
>> provided by system fw in the drivers.
>>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> ---
>>
>> Hi,
>>
>> I'm sending this first as a RFC in case you guys have some better
>> idea how to solve our problem. I actually already have couple
>> platforms where the GPIO resources are given to the "wrong" device
>> objects now.
>>
>> Originally we were thinking about simply handling our problem with
>> hacks to the PHY drivers, basically also checking if the parent has
>> GPIOs. That would only work if the controller is always the parent,
>> which it's not, but even if it was, it would be too risky. The PHY
>> drivers don't know which controller they are attached to, so what is
>> to say that the GPIOs aren't really attached to the controller.
>>
>> So the safest way to handle our problem is to deal with it in quirks
>> in the controller drivers. Solving it by bouncing the GPIOs did not
>> feel ideal there doesn't seem to be any other way. The API is copied
>> from clkdev (clk_register_clkdev). In the end it's really only one
>> function for adding the lookups and one for removing them.
>>
>> The way it's implemented is by modifying the current style of handling
>> the lookups a little bit. The per device lookup table is basically
>> reverted back to the single linked-list format since it seems that
>> these lookups may have to be assigned from several sources.
>
> Oh ain't that great.
>
> So now we start patching around the kernel because the ACPI
> tables are erroneous for GPIOs. I'd like some feedback from
> Rafael &| Darren on this patch, i.e. if you two think this is a good
> way of accounting for bad GPIO descriptions in ACPI tables then
> ACK this patch.
>
> I guess the other option would be to fix up the ACPI DSDT
> itself to put resources right, correct? Is this not possible?
>
> Alexandre also need to ACK it before I dare do anything with
> it.

I am not really fond of this idea since it adds complexity to the
(already too complex) GPIO lookup, and only solves to a local level
(GPIO) what is a more global problem (bad ACPI tables that can affect
any subsystem).

Also I don't think any new functions is actually needed: on an ACPI
system we can safely assume that the platform lookup tables are not
used at all. So, although it is a hack as well, you can just call
gpiod_add_lookup_table() with a runtime-built table from the driver
that needs to pass the GPIO so the receipient can receive it through
the lookup table fallback gpiod_get() uses if no GPIO is defined via
ACPI.

So I think that even with the current state of the code you can
achieve what you need. Should you do it, that's another question - it
seems more to-the-point to find a way to fix/patch the ACPI tables at
runtime, if that is possible at all, to provide a more general
solution to this issue.
