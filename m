Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaBJSEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:04:08 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40426 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaBJSEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:04:01 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c\@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi\@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 05/17] mmc: mmci: Put the device into low power state at system suspend
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-6-git-send-email-ulf.hansson@linaro.org>
	<8738jyu1h9.fsf@paris.lan>
	<CAPDyKFo4QG+D0wKnSEXR=2TW93HKUAbb1EUqGk_U56rS339B3Q@mail.gmail.com>
Date: Mon, 10 Feb 2014 10:03:57 -0800
In-Reply-To: <CAPDyKFo4QG+D0wKnSEXR=2TW93HKUAbb1EUqGk_U56rS339B3Q@mail.gmail.com>
	(Ulf Hansson's message of "Mon, 10 Feb 2014 12:11:24 +0100")
Message-ID: <7hmwhyalpu.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On 4 February 2014 20:22, Kevin Hilman <khilman@linaro.org> wrote:
>> Ulf Hansson <ulf.hansson@linaro.org> writes:
>>
>>> Due to the available runtime PM callbacks, we are now able to put our
>>> device into low power state at system suspend.
>>>
>>> Earlier we could not accomplish this without trusting a power domain
>>> for the device to take care of it. Now we are able to cope with
>>> scenarios both with and without a power domain.
>>>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>> ---
>>>  drivers/mmc/host/mmci.c |   45 +++++++++++++++++++++++++--------------------
>>>  1 file changed, 25 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>>> index c88da1c..074e0cb 100644
>>> --- a/drivers/mmc/host/mmci.c
>>> +++ b/drivers/mmc/host/mmci.c
>>> @@ -1723,33 +1723,38 @@ static int mmci_remove(struct amba_device *dev)
>>>       return 0;
>>>  }
>>>
>>> -#ifdef CONFIG_SUSPEND
>>> -static int mmci_suspend(struct device *dev)
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int mmci_suspend_late(struct device *dev)
>>>  {
>>> -     struct amba_device *adev = to_amba_device(dev);
>>> -     struct mmc_host *mmc = amba_get_drvdata(adev);
>>> +     int ret = 0;
>>>
>>> -     if (mmc) {
>>> -             struct mmci_host *host = mmc_priv(mmc);
>>> -             pm_runtime_get_sync(dev);
>>> -             writel(0, host->base + MMCIMASK0);
>>> -     }
>>> +     if (pm_runtime_status_suspended(dev))
>>> +             return 0;
>>>
>>> -     return 0;
>>> +     if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
>>> +             ret = dev->pm_domain->ops.runtime_suspend(dev);
>>> +     else
>>> +             ret = dev->bus->pm->runtime_suspend(dev);
>>> +
>>> +     if (!ret)
>>> +             pm_runtime_set_suspended(dev);
>>
>> Isn't this basically open-coding pm_runtime_suspend()...
>
> It is similar, but with once big difference.
>
> Since the PM core prevents pm_runtime_suspend() from invoking our
> ->runtime_suspend callback during system suspend (it does so by
> invoking pm_runtime_get_sync() before starting the suspend sequence),
> we then need to make the driver handle that by itself.

Yeah, I still think we need to allow a bus/pm_domain to override that
behavior.


Kevin
