Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaBEI5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:57:34 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47203 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaBEI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:57:32 -0500
MIME-Version: 1.0
In-Reply-To: <000401cf222f$43263b20$c972b160$%han@samsung.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
	<000401cf222f$43263b20$c972b160$%han@samsung.com>
Date: Wed, 5 Feb 2014 09:57:32 +0100
Message-ID: <CACRpkdbB8LFM0Vu8VRo4niqxwxUdS-c5gmmWaxbUTbnLCLZbMA@mail.gmail.com>
Subject: Re: [PATCH] backlight: add PWM dependencies
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 6:01 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Tuesday, February 04, 2014 9:57 PM, Linus Walleij wrote:
>>
>> In some compilations the LM3630A and LP855X backlight drivers
>> fail like this:
>>
>> drivers/built-in.o: In function `lm3630a_pwm_ctrl':
>> drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
>> drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
>> drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
>> drivers/built-in.o: In function `lp855x_pwm_ctrl':
>> drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
>> drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
>> drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'
>>
>> This is because both drivers depend on the PWM framework, so
>> add this dependency to their Kconfig entries.
>
> However, even though, when CONFIG_PWM is not enabled, the problem
> should not happen. pwm_config(),pwm_disable(), and pwm_enable()
> are already defined for CONFIG_PWM=n case as below.

So you may think but it does happen :-)

I reproduced this with the defconfig for ARM pxa255-idp and enabling
all boards for that platform, then enabling all available backlight drivers
as compiled-in objects (y).

> ./include/linux/pwm.h
> #if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
>         .....
> #else

Hm PXA that I am using defines CONFIG_HAVE_PWM, but doesn't
provide the required signatures (pwm_config/pwm_disable/pwm_enable).

One of two things is wrong:

- Either the PXA platform is breaking the CONFIG_HAVE_PWM
  contract by not providing pwm_config/pwm_disable/pwm_enable
  functions. Then HAVE_PWM should be removed from the PXA
  Kconfig selects.

Or:

- There is no such contract that these functions must exist if
  CONFIG_HAVE_PWM is defined, and the
  #if IS_ENABLED(CONFIG_HAVE_PWM)
  should be removed from <linux/pwm.h>

Does anyone know which one it is?

PWM subsystem maintainer? :-)

Yours,
Linus Walleij
