Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaIXPPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:15:32 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:38857 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaIXPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:15:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Sep 2014 17:14:49 +0200
From: Stefan Agner <stefan@agner.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybird
In-Reply-To: <CACRpkdbJePuG0g=AFGqjDS4=yW0CXnkpf1Yr_1P4e9Kkpu9n-g@mail.gmail.com>
References: <cover.1410020458.git.stefan@agner.ch>
 <ff236f6dab7f3408551f8f4b0345e62b37fd99c5.1410020459.git.stefan@agner.ch>
 <CACRpkdaNbTj+hXtNFZ6DqosHPfHg2G+X2Cb_S_15mULpdebgrQ@mail.gmail.com>
 <a7c933339713dc1783770faf1eceb734@agner.ch>
 <CACRpkdbJePuG0g=AFGqjDS4=yW0CXnkpf1Yr_1P4e9Kkpu9n-g@mail.gmail.com>
Message-ID: <2543d19c268e9ef1609759e98f3818d9@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-24 13:10, schrieb Linus Walleij:
> On Tue, Sep 23, 2014 at 1:51 PM, Stefan Agner <stefan@agner.ch> wrote:
>> [Me]
>>> postcore again. I don't like this, can you get rid of it?
>>
>> I guess we could load this driver easily a bit later. IMHO, since lots
>> of other driver use GPIO's, we should it load before all the drivers
>> gets loaded (before device_initcall).
> 
> Nope. We use deferred probing to control that today. Ideally
> all drivers should be device_initcall() and deferred probe be used
> to order things, not by playing around with initcalls.
> 

You can not "nope" my humble opinion, this is not possible, its write
protected! :-)

I fully understand the deferred probe approach, and I also think its
really a good approach for almost all drivers. The system by itself
makes sure the drivers are loaded in correct order. But if all drivers
use pinctrl, and the pinctrl happens to be the last initialized driver,
I first get 30 messages with probe deferred before the pinctrl driver
finally gets initialized. IMHO, this is a waste of resources... Giving
the system some hint what we need early (e.g. pinctrl or even GPIO
drivers) is just sensible. But maybe I miss something here...

Fact is, currently, without touching GPIO infrastructure code, the GPIO
driver can not be deferred when the pinctrl driver is missing. The
of_gpiochip_add_pin_range function does not handle the missing pinctrl
driver. Hence as of now, the pinctrl still needs an earlier initcall.
But anyway, currently the pinctrl driver is already using arch_initcall,
this patch set is no longer touching that.

>> Most GPIO driver do this, some statistic again:
>> $ grep -h -o ".*_initcall" drivers/gpio/*.c | sort | uniq -c | sort -n
>> -r
>>      33 subsys_initcall
>>      14 postcore_initcall
>>       2 device_initcall
>>       2 arch_initcall
>>       1 late_initcall
>>       1 core_initcall
> 
> Yeah old legacy. There are patch attacks to get rid of this.
> 
> The reason we can't just change them is because sometimes
> dependent drivers do not handle the errorpath very well can can't
> defer cleanly.
> 
> With a new driver I expect deferred probe to be used.
> 

Actually, the esdhc driver gets the cd-gpio directly and does not handle
EPROBE_DEFER properly, hence Vybrid would be affected too. But I
understand that we need to start somewhere. I will change the GPIO
driver to device_initcall and going to fix esdhc driver.

--
Stefan


