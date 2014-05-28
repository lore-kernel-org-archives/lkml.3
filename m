Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaE1BJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:09:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34412 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaE1BJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:09:40 -0400
Message-ID: <53853753.1030506@codeaurora.org>
Date: Tue, 27 May 2014 18:09:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH] spi: Set cs-gpios to output direction
References: <1400893054-16126-1-git-send-email-sboyd@codeaurora.org> <20140524115457.GP22111@sirena.org.uk>
In-Reply-To: <20140524115457.GP22111@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/14 04:54, Mark Brown wrote:
> On Fri, May 23, 2014 at 05:57:34PM -0700, Stephen Boyd wrote:
>> Some gpios used for cs-gpios may not be configured for output by
>> default. In these cases gpio_set_value() won't have any effect
>> and so the chip select line won't toggle. Request the cs-gpios
>> and set them to output direction once we know if the chip select
>> is default high or default low.
> Currently the SPI framework is expecting that the controller driver will
> own the GPIOs so it's not requesting them at all - starting to request
> them in the core without warning is likely to lead to double requests
> which doesn't seem like the best idea ever.  The driver has to
> understand that there are GPIO chip selects since it needs to figure out
> what to do with any underlying hardware chip selects that it can't stop
> toggling (there may be none or it may be directable into space with
> pinmux but we can't rely on that).  

Ok. My SPI controller is relying on the pinctrl framework to request
these gpios and I didn't have that configured in DT.

>
>> I wonder if we should request the gpios when the master controller
>> probes or when a spi device is added? We only know what the default
>> value should be when the spi device is added. On the other hand,
>> we should probably fail probe if the gpio controller isn't ready when
>> the spi master controller probes.
> Right, plus the fact that each driver has to open code the requesting,
> probe deferral handling and so on.  It's not super awesome, the whole
> area around GPIO chip select handling needs a bit of a sorched earth
> refactoring.
>
> Ideally we'd be able to error out only the device using an individual
> GPIO rather than the whole controller if a GPIO isn't there for some
> reason so doing it at device time would be nicer but my recollection is
> that this won't play nicely with deferred probe, it's a while since I
> looked so I may be misremembering.

Yes. There would need to be some hook into the SPI core from the driver
core that notified of any new driver probes. Then we could try and get
any pending cs-gpios again and then add the device that uses that chip
select.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

