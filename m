Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3EaBHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:07:46 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:49495 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3EaBHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:07:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vf+ifmn62vRNZbqpVX1hnqeUkenzvY81gZLenFkEJ9pFA@mail.gmail.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
	<CAHp75Vf+ifmn62vRNZbqpVX1hnqeUkenzvY81gZLenFkEJ9pFA@mail.gmail.com>
Date: Fri, 31 May 2013 09:07:36 +0800
Message-ID: <CAPgLHd-Gj0UXLdMYdQyGtyHY8T_c=XENc-=SZ=nejCKMiAFXkQ@mail.gmail.com>
Subject: Re: [PATCH -next v2] dmaengine: ste_dma40: fix error return code in d40_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: andy.shevchenko@gmail.com
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        vinod.koul@intel.com, djbw@fb.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 02:29 AM, Andy Shevchenko wrote:
> On Thu, May 30, 2013 at 7:32 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> In many of the error handling case, the return value 'ret' not set
>> and 0 will be return from d40_probe() even if error, but we should
>> return a negative error code instead in those error handling case.
>> This patch fixed them, and also removed useless variable 'err'.
> Hold on, please.
>
>> --- a/drivers/dma/ste_dma40.c
>> +++ b/drivers/dma/ste_dma40.c
>> @@ -3619,6 +3618,7 @@ static int __init d40_probe(struct platform_device *pdev)
>>                 if (IS_ERR(base->lcpa_regulator)) {
>>                         d40_err(&pdev->dev, "Failed to get lcpa_regulator\n");
>>                         base->lcpa_regulator = NULL;
>> +                       ret = PTR_ERR(base->lcpa_regulator);
> Is it really what we want?
>
> I thixh you may remove that NULL assignment.

Ohh, I will move the ret = PTR_ERR(base->lcpa_regulator) above the NULL
assignment, the failure path test for base->lcpa_regulator to release regulator.

        if (base->lcpa_regulator) {
            regulator_disable(base->lcpa_regulator);
            regulator_put(base->lcpa_regulator);
        }

>
>
>>                         goto failure;
>>                 }
>>
>> @@ -3647,8 +3647,8 @@ static int __init d40_probe(struct platform_device *pdev)
>>         d40_hw_init(base);
>>
>>         if (np) {
>> -               err = of_dma_controller_register(np, d40_xlate, NULL);
>> -               if (err && err != -ENODEV)
>> +               ret = of_dma_controller_register(np, d40_xlate, NULL);
>> +               if (ret && ret != -ENODEV)
> >From the discussion of dw_dmac I remember we decide that ENODEV check
> is redundant.

Get it, I will remove the ENODEV check.

Thanks,
Yongjun Wei

