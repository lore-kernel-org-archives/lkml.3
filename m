Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaBJLL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:11:29 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52478 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaBJLLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:11:25 -0500
MIME-Version: 1.0
In-Reply-To: <8738jyu1h9.fsf@paris.lan>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-6-git-send-email-ulf.hansson@linaro.org>
	<8738jyu1h9.fsf@paris.lan>
Date: Mon, 10 Feb 2014 12:11:24 +0100
Message-ID: <CAPDyKFo4QG+D0wKnSEXR=2TW93HKUAbb1EUqGk_U56rS339B3Q@mail.gmail.com>
Subject: Re: [PATCH 05/17] mmc: mmci: Put the device into low power state at
 system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2014 20:22, Kevin Hilman <khilman@linaro.org> wrote:
> Ulf Hansson <ulf.hansson@linaro.org> writes:
>
>> Due to the available runtime PM callbacks, we are now able to put our
>> device into low power state at system suspend.
>>
>> Earlier we could not accomplish this without trusting a power domain
>> for the device to take care of it. Now we are able to cope with
>> scenarios both with and without a power domain.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> ---
>>  drivers/mmc/host/mmci.c |   45 +++++++++++++++++++++++++--------------------
>>  1 file changed, 25 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>> index c88da1c..074e0cb 100644
>> --- a/drivers/mmc/host/mmci.c
>> +++ b/drivers/mmc/host/mmci.c
>> @@ -1723,33 +1723,38 @@ static int mmci_remove(struct amba_device *dev)
>>       return 0;
>>  }
>>
>> -#ifdef CONFIG_SUSPEND
>> -static int mmci_suspend(struct device *dev)
>> +#ifdef CONFIG_PM_SLEEP
>> +static int mmci_suspend_late(struct device *dev)
>>  {
>> -     struct amba_device *adev = to_amba_device(dev);
>> -     struct mmc_host *mmc = amba_get_drvdata(adev);
>> +     int ret = 0;
>>
>> -     if (mmc) {
>> -             struct mmci_host *host = mmc_priv(mmc);
>> -             pm_runtime_get_sync(dev);
>> -             writel(0, host->base + MMCIMASK0);
>> -     }
>> +     if (pm_runtime_status_suspended(dev))
>> +             return 0;
>>
>> -     return 0;
>> +     if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
>> +             ret = dev->pm_domain->ops.runtime_suspend(dev);
>> +     else
>> +             ret = dev->bus->pm->runtime_suspend(dev);
>> +
>> +     if (!ret)
>> +             pm_runtime_set_suspended(dev);
>
> Isn't this basically open-coding pm_runtime_suspend()...

It is similar, but with once big difference.

Since the PM core prevents pm_runtime_suspend() from invoking our
->runtime_suspend callback during system suspend (it does so by
invoking pm_runtime_get_sync() before starting the suspend sequence),
we then need to make the driver handle that by itself.

>
>> +     return ret;
>>  }
>>
>> -static int mmci_resume(struct device *dev)
>> +static int mmci_resume_early(struct device *dev)
>>  {
>> -     struct amba_device *adev = to_amba_device(dev);
>> -     struct mmc_host *mmc = amba_get_drvdata(adev);
>> +     int ret = 0;
>>
>> -     if (mmc) {
>> -             struct mmci_host *host = mmc_priv(mmc);
>> -             writel(MCI_IRQENABLE, host->base + MMCIMASK0);
>> -             pm_runtime_put(dev);
>> -     }
>> +     if (pm_runtime_status_suspended(dev))
>> +             return 0;
>>
>> -     return 0;
>> +     if (dev->pm_domain && dev->pm_domain->ops.runtime_resume)
>> +             ret = dev->pm_domain->ops.runtime_resume(dev);
>> +     else
>> +             ret = dev->bus->pm->runtime_resume(dev);
>> +
>> +     return ret;
>
> ...and this is pm_runtime_resume()? (though both terribly simplified.)

Correct, but again with a big difference. See comment above.

>
> This is starting to show that building with PM_SLEEP but not PM_RUNTIME
> is going to force open-coding a lot of stuff that the runtime PM
> framework already provides.  So either we need some helper functions so
> we're not sprinkling manual calls to bus/pm_domain callbacks all over

I have send a patch a while ago for the PM core, that tried to
implement something similar like this, I wasn't accepted. I will
follow up on that asap.

Still, do you think we could go ahead with this patch? If/when we can
get an acceptance for a PM runtime helper function in the PM core, we
can easily convert to use it later on.

> the place, or maybe where we need to go is have a way for platforms that
> really are "runtime PM centric" to declare that even PM_SLEEP depends on
> PM_RUNTIME.
>
> I'm trying to thing of a good reason to not make PM_SLEEP depend on
> PM_RUNTIME for platforms like this.

This wont help. The PM core will still prevent the runtime_suspend
callback from being invoked during system suspend.


Kind regards
Ulf Hansson

>
> Kevin
>
