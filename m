Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaGBMJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:09:53 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:61702 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaGBMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:09:52 -0400
Message-ID: <53B3F687.5050502@gmail.com>
Date: Wed, 02 Jul 2014 14:09:43 +0200
From: Pascal Huerst <pascal.huerst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: santosh.shilimkar@ti.com
CC: khilman@deeprootsystems.com, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-omap@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Subject: gpio-omap: wakeup mask
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

we have a device with an am335x and are using some gpios on bank0 to
wake up the device from suspend to ram.

We have some user buttons which are configured in the devicetree as
gpio-keys and one power-key which should wake up the device:

&buttons {
        power {
                label = "Power";
                gpios = <&gpio0 6 1>;
                linux,code = <116>;
                gpio-key,wakeup;
        };

        one {
                label = "One";
                gpios = <&gpio0 11 1>;
                linux,code = <2>;
        };

        : : :
}

The problem is, that the device wakes up on any trigger on bank 0. No
matter which button was pressed. "gpio-key,wakeup" seems not to have any
influence.

Now, if I comment the following lines out in drivers/gpio/gpio-omap.c :
set_gpio_trigger(...).

321
322 if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
323    _gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
324      bank->context.wake_en =
325        readl_relaxed(bank->base + bank->regs->wkup_en);
326 }
327

Everything works as expected. But I don't really understand why? Is this
a bug, or does this break something else I have not discovered yet?

Thanks,
Pascal
