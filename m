Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616AbaH0R6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:58:24 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:62817 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaH0R6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMhWvWhmp5GeznnveVupK+D5b2peF8bAC0jKFjxeR54cew@mail.gmail.com>
References: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
	<1409096705-24290-2-git-send-email-davidriley@chromium.org>
	<CAOesGMhWvWhmp5GeznnveVupK+D5b2peF8bAC0jKFjxeR54cew@mail.gmail.com>
Date: Wed, 27 Aug 2014 10:58:20 -0700
Message-ID: <CAASgrz0oG8-dnCai6_EF+MVnSjpztXP4b_ZOHorn6FZDdEL6pg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] power: Add simple gpio-restart driver
From: David Riley <davidriley@google.com>
To: Olof Johansson <olof@lixom.net>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Tue, Aug 26, 2014 at 7:14 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
>
>
> On Tue, Aug 26, 2014 at 4:45 PM, David Riley <davidriley@chromium.org> wrote:
>> This driver registers a restart handler to set a GPIO line high/low
>> to reset a board based on devicetree bindings.
>>
>> Signed-off-by: David Riley <davidriley@chromium.org>
>> ---
>>  .../devicetree/bindings/gpio/gpio-restart.txt      |  48 +++++++
>>  drivers/power/reset/Kconfig                        |   8 ++
>>  drivers/power/reset/Makefile                       |   1 +
>>  drivers/power/reset/gpio-restart.c                 | 142 +++++++++++++++++++++
>>  4 files changed, 199 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-restart.txt
>>  create mode 100644 drivers/power/reset/gpio-restart.c
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-restart.txt b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
>> new file mode 100644
>> index 0000000..7cd58788
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
>> @@ -0,0 +1,48 @@
>> +Driver a GPIO line that can be used to restart the system as a
>> +restart handler.
>> +
>> +The driver supports both level triggered and edge triggered power off.
>> +At driver load time, the driver will request the given gpio line and
>> +install a restart handler. If the optional properties 'input' is
>> +not found, the GPIO line will be driven in the inactive state.
>> +Otherwise its configured as an input.
>> +
>> +When do_kernel_restart is called the various restart handlers will be tried
>> +in order.
>
> The above sentence documents the kernel behavior, not the hardware
> description/binding.

I've cleaned this up.

>
>> +The gpio is configured as an output, and drive active, so
>> +triggering a level triggered power off condition. This will also cause an
>> +inactive->active edge condition, so triggering positive edge triggered
>> +power off.
>
>> + After a delay of 100ms, the GPIO is set to inactive, thus
>> +causing an active->inactive edge, triggering negative edge triggered power
>> +off. After another 100ms delay the GPIO is driver active again. If the
>> +power is still on and the CPU still running after a 3000ms delay, a
>> +WARN_ON(1) is emitted.
>
> It's possible that this behavior is inadequate for some hardware in
> the future -- if so they can amend the binding (i.e. this comment is
> an attempt at preemptive bikeshed avoidance :)

Changed to be configurable at the request of Guenter.

>> +
>> +Required properties:
>> +- compatible : should be "gpio-restart".
>> +- gpios : The GPIO to set high/low, see "gpios property" in
>> +  Documentation/devicetree/bindings/gpio/gpio.txt. If the pin should be
>> +  low to power down the board set it to "Active Low", otherwise set
>> +  gpio to "Active High".
>> +
>> +Optional properties:
>> +- input : Initially configure the GPIO line as an input. Only reconfigure
>> +  it to an output when the machine_restart function is called. If this optional
>> +  property is not specified, the GPIO is initialized as an output in its
>> +  inactive state.
>
> Isn't this the same as configuring the pin as tristate? I think that
> should probably be controlled by pinmux setup instead?

I think this still needs to be usable independently of pinctrl and it
keeps consistency with gpio-poweroff.

>
>> +- priority : A priority ranging from 0 to 255 (default 128) according to
>> +  the following guidelines:
>> +       0:      Restart handler of last resort, with limited restart
>> +               capabilities
>> +       128:    Default restart handler; use if no other restart handler is
>> +               expected to be available, and/or if restart functionality is
>> +               sufficient to restart the entire system
>> +       255:    Highest priority restart handler, will preempt all other
>> +               restart handlers
>
> This is sort of leaking linux implementation, but it's also a useful
> feature to have in the description. It seems sane enough to me to use.
>
>> +
>> +Examples:
>> +
>> +gpio-restart {
>> +       compatible = "gpio-restart";
>> +       gpios = <&gpio 4 0>;
>> +       priority = /bits/ 8 <200>;
>
> I think it makes sense to just have this as a regular cell instead of
> doing an 8-bit value -- it's how we normally handle these elsewhere.

Done.

>
>
> -Olof
