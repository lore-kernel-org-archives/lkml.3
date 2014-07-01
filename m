Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaGAMYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:24:45 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44129 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbaGAMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:24:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140701121142.GM23300@sirena.org.uk>
References: <1404215726-2480-1-git-send-email-broonie@kernel.org>
 <20140701120622.GJ32514@n2100.arm.linux.org.uk> <20140701121142.GM23300@sirena.org.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 1 Jul 2014 21:24:22 +0900
Message-ID: <CAAVeFuJqRW0ih8Mg9MFwLf=wQ7eVK5+pm8deW0vTUdozJ16FfQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Still free GPIOs using gpio_free()
To: Mark Brown <broonie@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 9:11 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jul 01, 2014 at 01:06:22PM +0100, Russell King - ARM Linux wrote:
>> On Tue, Jul 01, 2014 at 12:55:26PM +0100, Mark Brown wrote:
>
>> > Even though we mostly use GPIO descriptors internally we still use
>> > gpio_request_one() to request so we need to pair that with gpio_free() to
>> > release the GPIO.
>
>> This doesn't explain the reason...  I see the current GPIO code doing this:
>
>> void gpio_free(unsigned gpio)
>> {
>>         gpiod_free(gpio_to_desc(gpio));
>> }
>> EXPORT_SYMBOL_GPL(gpio_free);
>
> Huh, good point (though it still seems a bit neater to match up the
> request and release functions I guess).  Linus?

Yeah it's a nice habit to free the GPIOs using the same interface as
the one used to obtain them. Although if we are to allow the regulator
framework to request GPIO through both the integer and descriptor
interfaces, we certainly don't want to track that information forever.

On top of that we want to limit the use of gpio_to_desc() and
desc_to_gpio() in drivers as much as possible, so I'd say I prefer to
see gpiod_free() used no matter where the GPIO came from.
