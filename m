Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3JQJYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:24:18 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54146 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab3JQJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <CACmBeS1NoyHWhS5ydONf3x_z8SQu5-vh_XzMazuY9-uYXdg_wQ@mail.gmail.com>
References: <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
	<1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
	<CACRpkda23nUF8i03RWePj+dGa9Wj6E1L8vfPMfxvnGkazfKS5w@mail.gmail.com>
	<CACmBeS1NoyHWhS5ydONf3x_z8SQu5-vh_XzMazuY9-uYXdg_wQ@mail.gmail.com>
Date: Thu, 17 Oct 2013 11:24:12 +0200
Message-ID: <CACRpkdasrZ-rhbL1RMo1ZGA=kwmA==hQ-2-iP9zW+EvW_JZaWg@mail.gmail.com>
Subject: Re: [PATCH v5] gpio: Add MOXA ART GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 1:15 PM, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> On 11 October 2013 17:44, Linus Walleij <linus.walleij@linaro.org> wrote:

>>>     The register responsible for doing enable/disable is located
>>>     at <0x98100100 0x4>, the clock register is very close at
>>>     <0x98100000 0x34>.
(...)
> Arnd made a similar comment suggesting syscon back when MMC mapped the
> same register:
> https://groups.google.com/d/msg/linux.kernel/eeS7vhMWMAc/zNYhzyKilh8J
>
> I think I prefer to have this in the clock driver opposed to using syscon.

OK I can live with this. I've seen both approaches in practice.

> The one downside I can see, individual control of the pins would be
> lost? Does it make sense to enable all pins once? this is acceptable
> for at least UC-7112-LX, it doesn't need to disable/enable pins beyond
> the initial clk_enable().
>
> I say the above because I currently have nothing that requires
> individual pin control. However, I removed one line from MMC that
> turned out to be unnecessary. That line directly access the "PMU"
> register disabling pins 10-17 with the following comment:
>
> "
> /* change I/O multiplexing to SD, so the GPIO 17-10 will be fail */
> moxart_gpio_mp_clear(0xff << 10);
> "
> http://code.google.com/p/linux-2-6-9-moxart/source/browse/drivers/mmc/host/moxasd.c#619

Sorry I don't fully follow this. But don't poke into pin control registers
from other drivers, for separation of concerns. Request and handle
pins through the pin control API.

What you mean is likely that power-on states and boot loaders
have set up the pins for your immediate use cases and everything
seems to work, that is of course nice.

However as development and requirements progress people start
to come in with complex usecases where devices need pins set
to states that differ from the power-on defaults, for example for
power management. And then you run into this.

When/if you need pin control you can wither implement that as
a separate driver which is used by this GPIO driver as a "back-end"
or you can move this driver over to drivers/pinctrl and extend it
with a pin control API there, making it a combined pin control
and GPIO driver.

>>>     I don't think gpio_poweroff driver is right for this hardware
>>>     because the pin is not connected to anything that can do reset.
>>>     The old 2.6.9 kernel driver uses timer poll with eventual call
>>>     to userspace.
>>>
>>>     To test that it works, I added gpio_poweroff anyway, modified
>>>     with gpio_export() the pin can then be seen switching between
>>>     0 and 1 (on "cat /sys/class/gpio/gpio25/value").
>>
>> Hmmmm not quite following this...
>
> I'll try to elaborate. What happens in gpio_poweroff driver does not
> look like something that can reset the hardware. Reset on UC-7112-LX
> is implemented using the same register as the watchdog, in platform
> code hooked up to arm_pm_restart.
>
> The old sources "solved" this by polling the reset pin with eventual
> call_usermodehelper (/sbin/reboot):
> http://code.google.com/p/linux-2-6-9-moxart/source/browse/drivers/char/moxa_watchdog.c#174
>
> What was previously in a kernel driver, would now be solved in userspace?
>
> gpio_export() allowed me to verify the pin number, pressing reset
> toggles the value.
>
> Adding the gpio-leds driver, that pin was automatically exported to
> sysfs, that got me thinking:
>
> How do I export the reset button to sysfs? Should gpio_export() be
> added to platform code?

Aha argh what a mess. No the GPIO poweroff driver is not
intended to fix this. I *think* you should do this:

- Register the gpio pin as a polled input device using
  drivers/input/keyboard/gpio_keys_polled.c

- Have it emit KEY_POWER (from include/uapi/linux/input.h)

- Have your userspace input event (whatever issues select()
  on the /dev/input/* stuff) react to this input by calling
  /sbin/reboot or issueing the same thing that does, i.e.
  call reboot() with magic 0x01234567 I think.

Yours,
Linus Walleij
