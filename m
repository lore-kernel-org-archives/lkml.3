Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3ILPZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:25:02 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:32773 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3ILPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:24:59 -0400
Date: Thu, 12 Sep 2013 16:24:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] Documentation: add LP3943 DT bindings and document
Message-ID: <20130912152455.GN11227@lee--X1>
References: <1378949700-6384-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378949700-6384-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Milo Kim wrote:

> Bindings for LP3943 MFD, GPIO and PWM controller are added.
> And LP3943 driver document is added also.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  Documentation/00-INDEX                             |    2 +
>  .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 ++++++++++++
>  Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 +++++++++++
>  .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++++++++++++++++
>  Documentation/lp3943.txt                           |   62 ++++++++++++++++++++

I don't think we want driver documentation here.

>  5 files changed, 192 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
>  create mode 100644 Documentation/lp3943.txt
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index 0c4cc68..5dd921f 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -285,6 +285,8 @@ logo.gif
>  	- full colour GIF image of Linux logo (penguin - Tux).
>  logo.txt
>  	- info on creator of above logo & site to get additional images from.
> +lp3943.txt
> +	- info on LP3943 MFD driver structure.

-- " --

> diff --git a/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt b/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
> diff --git a/Documentation/devicetree/bindings/mfd/lp3943.txt b/Documentation/devicetree/bindings/mfd/lp3943.txt
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt b/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
> diff --git a/Documentation/lp3943.txt b/Documentation/lp3943.txt
> new file mode 100644
> index 0000000..576ebd0
> --- /dev/null
> +++ b/Documentation/lp3943.txt
> @@ -0,0 +1,62 @@
> +TI/National Semiconductor LP3943 MFD driver
> +===========================================
> +
> +LP3943 is an integrated device capable of driving 16 output channels.
> +It can be used for GPIO expander and PWM generators.
> +LP3493 registers are controlled via the I2C interface.
> +
> +Driver structure
> +----------------
> +                                  LED control    General usage for a device
> +                                  ___________   ____________________________
> +
> +  LP3943 MFD ---- GPIO expander    leds-gpio        eg) HW enable pin
> +              |
> +              --- PWM generator    leds-pwm         eg) PWM input
> +
> +
> +Why do we need GPIO and PWM drivers instead of LED driver?
> +To support LED control and general usage, GPIO and PWM drivers are necessary.
> +
> +According to the datasheet(1), it's just a LED driver which has 16 channels.
> +But here is another application, a GPIO expander.(2)
> +
> +  (1) http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
> +  (2) http://www.ti.com/lit/an/snva287a/snva287a.pdf
> +
> +Internal two PWM channels are used for LED dimming effect.
> +And each output pin can be used as a GPIO as well.
> +LED functionality can work with GPIOs or PWMs.
> +LEDs can be controlled with legacy leds-gpio(static brightness) or
> +leds-pwm drivers(dynamic brightness control).
> +Additionally, it can be used for generic GPIO and PWM controller.
> +For example, a GPIO is HW enable pin of a device.
> +PWM is input pin of a backlight device.
> +
> +
> +LP3943 PWM port map
> +-------------------
> +Each PWM channel can be mapped to one or multiple output pins.
> +
> +For example, PWM 0 is used for a backlight device.
> +PWM 1 is for RGB LEDs.
> +
> +  PWM channel    Output pins    PWM consumer
> +  ___________    ___________    ____________
> +  PWM 0          pin 1          backlight
> +  PWM 1          pin 7, 8, 9    RGB LEDs
> +
> +Then, PWM port map is as below.
> +PWM 0: num_outputs = 1, output = pin 1
> +PWM 1: num_outputs = 3, output = pin 7, 8, 9
> +
> +The 'lp3943_pwm_map' structure is used for this feature.
> +
> +
> +Device tree supported
> +---------------------
> +Please refer to the documents below.
> +
> +Documentation/devicetree/bindings/mfd/lp3943.txt
> +Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
> +Documentation/devicetree/bindings/pwm/pwm-lp3943.txt

Why do you need to document your driver in this way?

If this stuff is really important (and most of it really isn't), then
put it either in the commit log or in the driver.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
