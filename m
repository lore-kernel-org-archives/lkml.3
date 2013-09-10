Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3IJTxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:53:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55872 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3IJTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:53:52 -0400
Message-ID: <522F78CB.2020507@wwwdotorg.org>
Date: Tue, 10 Sep 2013 13:53:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Mark Brown <broonie@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02>
In-Reply-To: <2052193.CMUEUJFRgS@lem-wkst-02>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 02:47 AM, Lars Poeschel wrote:
> On Tuesday 10 September 2013 17:19:24, Mark Brown wrote:
>> On Wed, Sep 04, 2013 at 02:16:36PM -0600, Stephen Warren wrote:
>>> On 09/04/2013 03:05 AM, Lars Poeschel wrote:
>>>> The driver that tries to use the GPIO requested by this patch before HAS
>>>> to
>>>> fail. This is exactly the intention of this patch. We don't want the
>>>> GPIO to be requested any more, if it is used as an interrupt pin.
>>>
>>> That will break existing drivers. There are drivers that request the
>>> same GPIO and IRQ. IIRC, the SDHCI CD (Card Detect) GPIO is requested
>>> that way.
>>
>> Yes, plus input devices and audio jack detection among others.  This
>> pattern is very common if the GPIO is actually being used as a GPIO, an
>> edge triggered interrupt is used to flag when something happens and the
>> state is determined by reading the GPIO state (often with some
>> debounce).
> 
> And I say it again for those coming into the discussion late, like it has been 
> said many many times before: This patch does not break any of this drivers. 
> They simply request their GPIO from DT and turn it into an irq using 
> gpio_to_irq, request that irq on their behalf and use it as GPIO and IRQ in 
> parallel. At least this is not a problem.

Doesn't this patch call gpio_request() on the GPIO first, and hence
prevent the driver's own gpio_request() from succeeding, since the GPIO
is already requested? If this is not a problem, it sounds like a bug in
gpio_request() not ensuring mutual exclusion for the GPIO.
