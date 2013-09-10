Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3IJWe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:34:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35399 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IJWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:34:26 -0400
Message-ID: <522F9E6C.2010905@wwwdotorg.org>
Date: Tue, 10 Sep 2013 16:34:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lars Poeschel <poeschel@lemonage.de>,
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
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02> <522F78CB.2020507@wwwdotorg.org> <20130910213718.GH29403@sirena.org.uk>
In-Reply-To: <20130910213718.GH29403@sirena.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 03:37 PM, Mark Brown wrote:
> On Tue, Sep 10, 2013 at 01:53:47PM -0600, Stephen Warren wrote:
> 
>> Doesn't this patch call gpio_request() on the GPIO first, and
>> hence prevent the driver's own gpio_request() from succeeding,
>> since the GPIO is already requested? If this is not a problem, it
>> sounds like a bug in gpio_request() not ensuring mutual exclusion
>> for the GPIO.
> 
> Or at the very least something that's likely to break in the
> future.

Looking at the GPIO code, it already prevents double-requests:

>         if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
>                 desc_set_label(desc, label ? : "?");
>                 status = 0;
>         } else {
>                 status = -EBUSY;
>                 module_put(chip->owner);
>                 goto done;
>         }

And I tested it in practice, and it really does fail.
