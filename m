Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBJMdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:33:55 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33383 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaBJMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:33:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140204191609.GU22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-8-git-send-email-ulf.hansson@linaro.org>
	<20140204191609.GU22609@sirena.org.uk>
Date: Mon, 10 Feb 2014 13:33:50 +0100
Message-ID: <CAPDyKFqNdw-6R12cUOre8UOTOnB-PpxHD5rPAMCwuS3i--Sesg@mail.gmail.com>
Subject: Re: [PATCH 07/17] spi: pl022: Don't ignore power domain and amba bus
 at system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2014 20:16, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Feb 04, 2014 at 04:58:48PM +0100, Ulf Hansson wrote:
>
>> @@ -2328,8 +2300,23 @@ static int pl022_suspend(struct device *dev)
>>               return ret;
>>       }
>>
>> -     pm_runtime_get_sync(dev);
>> -     pl022_suspend_resources(pl022, false);
>> +     pm_runtime_disable(dev);
>> +
>> +     if (!pm_runtime_status_suspended(dev)) {
>> +             if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
>> +                     ret = dev->pm_domain->ops.runtime_suspend(dev);
>> +             else
>> +                     ret = dev->bus->pm->runtime_suspend(dev);
>> +
>> +             if (ret) {
>> +                     pm_runtime_enable(dev);
>> +                     return ret;
>> +             }
>> +
>> +             pm_runtime_set_suspended(dev);
>> +     }
>
> This seems like a fairly hideous thing to be having to open code in an
> individual driver, it all looks generic and like something that most if
> not all devices ought to be doing and it looks very vulnerable to being
> broken by changes in the core.  At the very least I would expect this to
> be done in a helper function, though it would be even nicer if the
> driver core were figuring this stuff out for us based on the device
> level callback so that drivers didn't need to worry about being in power
> domains or manually calling bus level callbacks.
>
> Putting it in a helper would at least mean that it's easier for the
> mechanics to be transferred to the core proper later on.

I agree, a helper function would be nice. I have earlier sent a patch
to the PM core, that is similar to the code above, though it was
rejected in it's current form. Let me follow up on this again.

At this point, would a way forward be to still go ahead with this
patch and then convert to, when/if, the helper function from the PM
core becomes available?

Kind regards
Ulf Hansson
