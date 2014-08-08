Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHHSlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:41:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33435 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaHHSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:41:12 -0400
Message-ID: <53E519C2.9060405@gmail.com>
Date: Fri, 08 Aug 2014 20:41:06 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
CC: Stephen Warren <swarren@nvidia.com>, Yufeng Shen <miletus@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags
 on DT booting
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk> <53E4D9A5.908@itdev.co.uk> <20140808162146.GC26820@core.coreip.homeip.net> <53E4FD1B.6060600@collabora.co.uk> <53E5170C.10302@collabora.co.uk>
In-Reply-To: <53E5170C.10302@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC Linus, as this became also pinctrl related.

On 08.08.2014 20:29, Javier Martinez Canillas wrote:
> Hello,
> 
> On 08/08/2014 06:38 PM, Javier Martinez Canillas wrote:
>>
>>
>> It seems as if the first call to exynos_irq_set_type() that is made by OF is a
>> no-op while the second call is the one that actually setups the hw correctly.
>> Does this make any sense? Maybe is related to the pin not being muxed in the
>> correct function when the "interrupts" property is parsed by OF?
>>
> 
> So after a conversation with Tomasz Figa over IRC the problem was after all that
> the pin was reconfigured. The IRQ trigger type resulted to be just a red herring
> and not a direct cause.
> 
> The pinctrl-eyxnos driver does the IRQ pinmux setup in the .irq_set_type
> function handler. So what happened was that OF parsed the "interrupts" property
> and called exynos_irq_set_type() which did the pinmux setup.
> 
> But after that, due a DTS pinctrl configuration the pin function was changed as
> a GPIO input and that happened before the atmel driver was probed. So when the
> driver called request_threaded_irq(), the correct flags were used but the pin
> was not configured as an IRQ anymore so IRQ were not fired.
> 
> Setting a trigger type just had the side effect of calling exynos_irq_set_type()
> which again setup the pin as an IRQ.
> 
> To fix the issue a variation of patch [0] will be posted that moves the IRQ
> pinmux setup from .irq_set_type to the .irq_request_resources function handler.
> That way the pin will be setup as IRQ regardless of the the trigger type [1]
> when someone calls request_[threaded]_irq().
> 
> Only the mentioned patch fixes the issue but Tomasz said that even a call to
> gpio_direction_{input,output} can change the pin configuration so he will post
> another patch that will add a bit mask to samsung_pin_bank to prevent any pinmux
> reconfiguration.

To add a bit more information about the hardware, setting up a GPIO
interrupt on Samsung SoCs is a two-step operation - in addition to
trigger configuration in a dedicated register, the pinmux must be also
reconfigured to GPIO interrupt, which is a different function than
normal GPIO input, although I/O-wise they both behave in the same way
and gpio_get_value() can be used on a pin configured as IRQ as well.

I'm afraid that such design implies that handling of this in the driver
must be done on a very low level, because it involves three possible
interfaces changing the pinmux - pinctrl, GPIO and irqchip and such
subtletes like gpio_direction_input() that shouldn't neither fail if a
pin is already configured as an interrupt nor change the configuration
to normal input.

Best regards,
Tomasz
