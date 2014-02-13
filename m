Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaBMNtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:49:45 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:20399 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBMNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:49:43 -0500
X-AuditID: cbfec37d-b7ff46d000005528-d3-52fccd764346
Message-id: <52FCCD6D.6020704@samsung.com>
Date: Thu, 13 Feb 2014 06:49:33 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, mirq-linux@rere.qmqm.pl,
        Chris Ball <chris@printf.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Shuah Khan <shuahkhan@gmail.com>, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFT][PATCH v3] mmc: change cb710-mmc platform power management to
 use dev_pm_ops
References: <1392240089-19489-1-git-send-email-shuah.kh@samsung.com>
 <CAPDyKFoukY2PGNWimUbRqDr36eJ_+eBASJR4uac6nH4-kowmCQ@mail.gmail.com>
In-reply-to: <CAPDyKFoukY2PGNWimUbRqDr36eJ_+eBASJR4uac6nH4-kowmCQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.9]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9hX92ys3+CDD5+kLKYcHk7o8XlXXPY
	LI7872e0+Nx7hNHi2/NTjBZnTl9itfj608Hi+NpwBw6PnbPusnvcubaHzePGq4VMHrPa9rF5
	bLnazuLxeZNcAFsUl01Kak5mWWqRvl0CV8acM5tZCxpEKq49+c7SwPibv4uRk0NCwETi2KRW
	VghbTOLCvfVsXYxcHEICyxgl/u38yAjh9DJJ/Dy3mAXC2cAo8floOzNIC6+AlsT1058YQWwW
	AVWJZX/3g8XZBNQlPr/ewQ5iCwnISTQtWQ0WFxWIkHh1diILRK+gxI/J98BsEQENiT0Pz4Od
	wSxwnkli4ScrEFtYIEGipxnmim5GiYt71gIVcXBwCgRL/FlSBFFvLbFy0jZGCFteYvOat8wQ
	e5Ul/lw+xQTxmoLEh+P/mCcwisxCsnoWkvZZSNoXMDKvYhQrLU4uKE5KT60w0StOzC0uzUvX
	S87P3cQIia3aHYz3v9ocYhTgYFTi4bVY9jtIiDWxrLgy9xCjBAezkghv+JE/QUK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYfQuY1h7ktQrWfdiY6Bmql37osHP5DJWI1/bx1RFOXffY1i9V2R9u
	Hfe2XzVjqSL/tVkf+vlXP7q+P/jEkrl7/61l+n3VtqPQTMpAT/5Wt7o33wWulV+sDM+uqRL5
	eesjs8ScNz0XPf4wXPi4gN/2Cn/HTy45x6/TNfpyLm37sNa1Yd2V/qy5SizFGYmGWsxFxYkA
	vQW2JYsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 02:47 AM, Ulf Hansson wrote:
> On 12 February 2014 22:21, Shuah Khan <shuah.kh@samsung.com> wrote:
>> Change cb710-mmc platform driver to register pm ops using dev_pm_ops instead
>> of legacy pm_ops. The existing legacy suspend/resume routines are identical
>> and simply clear IRQ mask in the device in case it got undefined during sleep
>> state. Changed code to collapse suspend and resume into one .pm interface
>> for suspend and resume which gets installed for suspend, freeze, poweroff,
>> thaw, restore, and resume states using SIMPLE_DEV_PM_OPS().
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>
>> patch v3: Addresses review comments on patch v2
>>
>>   drivers/mmc/host/cb710-mmc.c |   40 ++++++++++++++++------------------------
>>   1 file changed, 16 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
>> index 1087b4c..2dc7b2dc 100644
>> --- a/drivers/mmc/host/cb710-mmc.c
>> +++ b/drivers/mmc/host/cb710-mmc.c
>> @@ -662,26 +662,6 @@ static const struct mmc_host_ops cb710_mmc_host = {
>>          .get_cd = cb710_mmc_get_cd,
>>   };
>>
>> -#ifdef CONFIG_PM
>> -
>> -static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
>> -{
>> -       struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
>> -
>> -       cb710_mmc_enable_irq(slot, 0, ~0);
>> -       return 0;
>> -}
>> -
>> -static int cb710_mmc_resume(struct platform_device *pdev)
>> -{
>> -       struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
>> -
>> -       cb710_mmc_enable_irq(slot, 0, ~0);
>> -       return 0;
>> -}
>> -
>> -#endif /* CONFIG_PM */
>> -
>>   static int cb710_mmc_init(struct platform_device *pdev)
>>   {
>>          struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
>> @@ -762,14 +742,26 @@ static int cb710_mmc_exit(struct platform_device *pdev)
>>          return 0;
>>   }
>>
>> +#ifdef CONFIG_PM_SLEEP
>> +static int cb710_mmc_suspend_resume(struct device *dev)
>> +{
>> +       struct cb710_slot *slot = cb710_pdev_to_slot(to_platform_device(dev));
>> +
>> +       cb710_mmc_enable_irq(slot, 0, ~0);
>> +       return 0;
>> +}
>> +#else
>> +#define cb710_mmc_suspend_resume NULL
>
> You don't need this. The macro will handle this for you.
>

Without this compiles fail when CONFIG_PM_SLEEP is not defined.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
