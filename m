Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaJ0SPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:15:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37159 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJ0SPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:15:47 -0400
Message-ID: <544E8BCC.5080208@gmail.com>
Date: Mon, 27 Oct 2014 19:15:40 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 06/12] mmc: sdhci-pxav3: Move I/O clock to private
 data
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com> <1413883364-681-7-git-send-email-sebastian.hesselbarth@gmail.com> <CAPDyKFroUmuQU_mBmSNEQAHe9Y-OF4pkkK=4Qe=JtibWThaHPA@mail.gmail.com>
In-Reply-To: <CAPDyKFroUmuQU_mBmSNEQAHe9Y-OF4pkkK=4Qe=JtibWThaHPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 02:28 PM, Ulf Hansson wrote:
> On 21 October 2014 11:22, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>> As we are using references to the I/O clock throughout the driver,
>> move it to the private data. Also, in preparation for core clock,
>> rename it to clk_io.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Chris Ball <chris@printf.net>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
>> Cc: linux-mmc@vger.kernel.org
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/mmc/host/sdhci-pxav3.c | 24 +++++++++++++-----------
>>   1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
>> index e52bbbb09d88..a34a589670e6 100644
>> --- a/drivers/mmc/host/sdhci-pxav3.c
>> +++ b/drivers/mmc/host/sdhci-pxav3.c
>> @@ -59,6 +59,7 @@
>>   #define SDCE_MISC_INT_EN       (1<<1)
>>
>>   struct sdhci_pxa {
>> +       struct clk *clk_io;
>>          u8      power_mode;
>>   };
>>
>> @@ -288,9 +289,7 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
>>          struct sdhci_host *host = NULL;
>>          struct sdhci_pxa *pxa = NULL;
>>          const struct of_device_id *match;
>> -
>>          int ret;
>> -       struct clk *clk;
>>
>>          pxa = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_pxa), GFP_KERNEL);
>>          if (!pxa)
>> @@ -310,14 +309,14 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
>>          pltfm_host = sdhci_priv(host);
>>          pltfm_host->priv = pxa;
>>
>> -       clk = devm_clk_get(dev, NULL);
>> -       if (IS_ERR(clk)) {
>> +       pxa->clk_io = devm_clk_get(dev, NULL);
>> +       if (IS_ERR(pxa->clk_io)) {
>>                  dev_err(dev, "failed to get io clock\n");
>> -               ret = PTR_ERR(clk);
>> +               ret = PTR_ERR(pxa->clk_io);
>>                  goto err_clk_get;
>>          }
>> -       pltfm_host->clk = clk;
>> -       clk_prepare_enable(clk);
>> +       pltfm_host->clk = pxa->clk_io;
>
> Is the above still needed?
>
>> +       clk_prepare_enable(pxa->clk_io);

Ulf,

I guess it is. It sets sdhci_pltfm_host's clk field which is used
by sdhci-pltfm.c to e.g. determine sdhci clock rate.

Sebastian
