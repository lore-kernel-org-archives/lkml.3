Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaBNOcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:32:50 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:52056 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaBNOcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:32:48 -0500
MIME-Version: 1.0
In-Reply-To: <52FCCD6D.6020704@samsung.com>
References: <1392240089-19489-1-git-send-email-shuah.kh@samsung.com>
	<CAPDyKFoukY2PGNWimUbRqDr36eJ_+eBASJR4uac6nH4-kowmCQ@mail.gmail.com>
	<52FCCD6D.6020704@samsung.com>
Date: Fri, 14 Feb 2014 15:32:47 +0100
Message-ID: <CAPDyKFqYd=CqfTbO8cCqobg=StjYgeq6NhfKecbnPXc8B+W7FQ@mail.gmail.com>
Subject: Re: [RFT][PATCH v3] mmc: change cb710-mmc platform power management
 to use dev_pm_ops
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, mirq-linux@rere.qmqm.pl,
        Chris Ball <chris@printf.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 February 2014 14:49, Shuah Khan <shuah.kh@samsung.com> wrote:
> On 02/13/2014 02:47 AM, Ulf Hansson wrote:
>>
>> On 12 February 2014 22:21, Shuah Khan <shuah.kh@samsung.com> wrote:
>>>
>>> Change cb710-mmc platform driver to register pm ops using dev_pm_ops
>>> instead
>>> of legacy pm_ops. The existing legacy suspend/resume routines are
>>> identical
>>> and simply clear IRQ mask in the device in case it got undefined during
>>> sleep
>>> state. Changed code to collapse suspend and resume into one .pm interface
>>> for suspend and resume which gets installed for suspend, freeze,
>>> poweroff,
>>> thaw, restore, and resume states using SIMPLE_DEV_PM_OPS().
>>>
>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>> ---
>>>
>>> patch v3: Addresses review comments on patch v2
>>>
>>>   drivers/mmc/host/cb710-mmc.c |   40
>>> ++++++++++++++++------------------------
>>>   1 file changed, 16 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
>>> index 1087b4c..2dc7b2dc 100644
>>> --- a/drivers/mmc/host/cb710-mmc.c
>>> +++ b/drivers/mmc/host/cb710-mmc.c
>>> @@ -662,26 +662,6 @@ static const struct mmc_host_ops cb710_mmc_host = {
>>>          .get_cd = cb710_mmc_get_cd,
>>>   };
>>>
>>> -#ifdef CONFIG_PM
>>> -
>>> -static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t
>>> state)
>>> -{
>>> -       struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
>>> -
>>> -       cb710_mmc_enable_irq(slot, 0, ~0);
>>> -       return 0;
>>> -}
>>> -
>>> -static int cb710_mmc_resume(struct platform_device *pdev)
>>> -{
>>> -       struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
>>> -
>>> -       cb710_mmc_enable_irq(slot, 0, ~0);
>>> -       return 0;
>>> -}
>>> -
>>> -#endif /* CONFIG_PM */
>>> -
>>>   static int cb710_mmc_init(struct platform_device *pdev)
>>>   {
>>>          struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
>>> @@ -762,14 +742,26 @@ static int cb710_mmc_exit(struct platform_device
>>> *pdev)
>>>          return 0;
>>>   }
>>>
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int cb710_mmc_suspend_resume(struct device *dev)
>>> +{
>>> +       struct cb710_slot *slot =
>>> cb710_pdev_to_slot(to_platform_device(dev));
>>> +
>>> +       cb710_mmc_enable_irq(slot, 0, ~0);
>>> +       return 0;
>>> +}
>>> +#
>>> +#define cb710_mmc_suspend_resume NULL
>>
>>
>> You don't need this. The macro will handle this for you.
>>
>
> Without this compiles fail when CONFIG_PM_SLEEP is not defined.

No it won't. You can remove the #else statement.

The functions don't have to be defined for !CONFIG_PM_SLEEP, since the
macro will handle that.

Kind regards
Ulf Hansson

>
> -- Shuah
>
>
> --
> Shuah Khan
> Senior Linux Kernel Developer - Open Source Group
> Samsung Research America(Silicon Valley)
> shuah.kh@samsung.com | (970) 672-0658
