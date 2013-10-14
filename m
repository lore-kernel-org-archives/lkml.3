Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3JNLPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:15:31 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53619 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3JNLP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda23nUF8i03RWePj+dGa9Wj6E1L8vfPMfxvnGkazfKS5w@mail.gmail.com>
References: <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
	<1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
	<CACRpkda23nUF8i03RWePj+dGa9Wj6E1L8vfPMfxvnGkazfKS5w@mail.gmail.com>
Date: Mon, 14 Oct 2013 13:15:28 +0200
Message-ID: <CACmBeS1NoyHWhS5ydONf3x_z8SQu5-vh_XzMazuY9-uYXdg_wQ@mail.gmail.com>
Subject: Re: [PATCH v5] gpio: Add MOXA ART GPIO driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the replies.

On 11 October 2013 17:44, Linus Walleij <linus.walleij@linaro.org> wrote:
>>     The register responsible for doing enable/disable is located
>>     at <0x98100100 0x4>, the clock register is very close at
>>     <0x98100000 0x34>.
>
> If we don't know we have to guess.
>
> This layout makes me think that the IO-window at 0x98100000 is
> a power-clock-and-reset controller. It contains some register
> to latch the pins enable/disable them, or if this is even a clock
> gate? Are you sure about this? Is it now a gated clock, simply,
> so that this bit should be handled in the clock driver, i.e.
> this bit gets set by clk_enable() from the GPIO driver?

The IO-window at 0x98100000 contains registers that are read to
determine PLL and APB clock frequencies. Sorry I don't know more than
that.

This is part of a pending patch adding the clock driver:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/203494.html

Arnd made a similar comment suggesting syscon back when MMC mapped the
same register:
https://groups.google.com/d/msg/linux.kernel/eeS7vhMWMAc/zNYhzyKilh8J

I think I prefer to have this in the clock driver opposed to using syscon.

The one downside I can see, individual control of the pins would be
lost? Does it make sense to enable all pins once? this is acceptable
for at least UC-7112-LX, it doesn't need to disable/enable pins beyond
the initial clk_enable().

I say the above because I currently have nothing that requires
individual pin control. However, I removed one line from MMC that
turned out to be unnecessary. That line directly access the "PMU"
register disabling pins 10-17 with the following comment:

"
/* change I/O multiplexing to SD, so the GPIO 17-10 will be fail */
moxart_gpio_mp_clear(0xff << 10);
"
http://code.google.com/p/linux-2-6-9-moxart/source/browse/drivers/mmc/host/moxasd.c#619


>>     I don't think gpio_poweroff driver is right for this hardware
>>     because the pin is not connected to anything that can do reset.
>>     The old 2.6.9 kernel driver uses timer poll with eventual call
>>     to userspace.
>>
>>     To test that it works, I added gpio_poweroff anyway, modified
>>     with gpio_export() the pin can then be seen switching between
>>     0 and 1 (on "cat /sys/class/gpio/gpio25/value").
>
> Hmmmm not quite following this...

I'll try to elaborate. What happens in gpio_poweroff driver does not
look like something that can reset the hardware. Reset on UC-7112-LX
is implemented using the same register as the watchdog, in platform
code hooked up to arm_pm_restart.

The old sources "solved" this by polling the reset pin with eventual
call_usermodehelper (/sbin/reboot):
http://code.google.com/p/linux-2-6-9-moxart/source/browse/drivers/char/moxa_watchdog.c#174

What was previously in a kernel driver, would now be solved in userspace?

gpio_export() allowed me to verify the pin number, pressing reset
toggles the value.

Adding the gpio-leds driver, that pin was automatically exported to
sysfs, that got me thinking:

How do I export the reset button to sysfs? Should gpio_export() be
added to platform code?


from drivers/power/reset/gpio-poweroff.c:

static void gpio_poweroff_do_poweroff(void)
{
        BUG_ON(!gpio_is_valid(gpio_num));

        /* drive it active, also inactive->active edge */
        gpio_direction_output(gpio_num, !gpio_active_low);
        mdelay(100);
        /* drive inactive, also active->inactive edge */
        gpio_set_value(gpio_num, gpio_active_low);
        mdelay(100);

        /* drive it active, also inactive->active edge */
        gpio_set_value(gpio_num, !gpio_active_low);

        /* give it some time */
        mdelay(3000);

        WARN_ON(1);
}


Regards,
Jonas
