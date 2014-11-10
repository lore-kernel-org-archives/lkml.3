Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaKJFPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:15:24 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59208 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaKJFPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <545FE821.5060107@coldplug.net>
References: <1415567571-6144-1-git-send-email-alchark@gmail.com>
	<CAOMZO5C+O4h=f=vtLTdBZktnfVWzfeLjOQG-oecxh_c9u-QMqA@mail.gmail.com>
	<545FE821.5060107@coldplug.net>
Date: Mon, 10 Nov 2014 08:15:21 +0300
Message-ID: <CABjd4YxyUJi6RaGWicFeoJ7C27qhUFsAbq-nJTreACrt-voeYA@mail.gmail.com>
Subject: Re: [PATCH] mmc: wmt-sdmmc: fix unmatched release_mem_region
From: Alexey Charkov <alchark@gmail.com>
To: lautriv <lautriv@coldplug.net>
Cc: Fabio Estevam <festevam@gmail.com>, Tony Prisk <linux@prisktech.co.nz>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-10 1:18 GMT+03:00 lautriv <lautriv@coldplug.net>:
> On 11/09/2014 10:55 PM, Fabio Estevam wrote:
>>
>> On Sun, Nov 9, 2014 at 7:12 PM, Alexey Charkov <alchark@gmail.com> wrote:
>>
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +       if (!res) {
>>> +               ret = -ENODEV;
>>> +               goto fail1;
>>
>> You could save this NULL check...
>>
>>> +       }
>>>          mmc = mmc_alloc_host(sizeof(struct wmt_mci_priv), &pdev->dev);
>>>          if (!mmc) {
>>>                  dev_err(&pdev->dev, "Failed to allocate mmc_host\n");
>>> @@ -813,7 +819,7 @@ static int wmt_mci_probe(struct platform_device
>>> *pdev)
>>>          if (of_get_property(np, "cd-inverted", NULL))
>>>                  priv->cd_inverted = 1;
>>>
>>> -       priv->sdmmc_base = of_iomap(np, 0);
>>
>> If you move ' res = platform_get_resource' right here as
>> devm_ioremap_resource() already does the NULL check.
>>
>>> +       priv->sdmmc_base = devm_ioremap_resource(&pdev->dev, res);
>>>          if (!priv->sdmmc_base) {
>>>                  dev_err(&pdev->dev, "Failed to map IO space\n");
>>>                  ret = -ENOMEM;
>
> This was the original intention but it would fall between the failX jumps, i
> discussed that with Alexey and we decided to change it with the cleanup to
> hold this patch small.

I think Fabio means something slightly different than what we
discussed. We haven't realized that the first thing
devm_ioremap_resource does is exactly that (!res) check, so we can
skip ours altogether.

Looking at the function code a bit closer, we should also make the
check look like "if (IS_ERR(priv->sdmmc_base)", kill the dev_err call
(as it's also done internally), and then just do "ret =
PTR_ERR(priv->sdmmc_base)" and jump to the label.

Thanks a lot,
Alexey
