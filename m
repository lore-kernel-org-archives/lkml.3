Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaAJGH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:07:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41052 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJGHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:07:51 -0500
MIME-Version: 1.0
In-Reply-To: <52CEAEB0.80304@samsung.com>
References: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
 <1389243541-13122-1-git-send-email-ch.naveen@samsung.com> <52CEAEB0.80304@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 10 Jan 2014 11:37:30 +0530
Message-ID: <CAHfPSqA=xkHX1kajjYfNz2KMrnfHGdWzu9GWvSE4ZjWWZb-hQA@mail.gmail.com>
Subject: Re: [PATCH 2/6 v2] crypto:s5p-sss: Add device tree support
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

Thanks for time and review comments they are really helping me a lot
in getting the patches merged.

Secondly, accept my apologies for not giving proper writeup of why i
din't address
few of your comments on v1 of this patchset.

On 9 January 2014 19:44, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Naveen,
>
>
> On 09.01.2014 05:59, Naveen Krishna Chatradhi wrote:
>>
>> This patch adds device tree support to the s5p-sss.c crypto driver.
>> Implements a varient struct to address the changes in SSS hardware
>> on various SoCs from Samsung.
>>
>> Also, Documentation under devicetree/bindings added.
>>
>> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> CC: David S. Miller <davem@davemloft.net>
>> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
>> TO: <linux-crypto@vger.kernel.org>
>> CC: <linux-samsung-soc@vger.kernel.org>
>> ---
>> Changes since v1:
>> 1. Added description of the SSS module in Documentation
>> 2. Corrected the interrupts description
>> 3. Added varient struct instead of the version variable
>>
>>   .../devicetree/bindings/crypto/samsung-sss.txt     |   20 +++++
>>   drivers/crypto/s5p-sss.c                           |   81
>> ++++++++++++++++++--
>>   2 files changed, 95 insertions(+), 6 deletions(-)
>>   create mode 100644
>> Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> new file mode 100644
>> index 0000000..0e45b0d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> @@ -0,0 +1,20 @@
>> +Samsung SoC SSS (Security SubSystem) module
>> +
>> +The SSS module in S5PV210 SoC supports the following:
>> +-- Feeder (FeedCtrl)
>> +-- Advanced Encryption Standard (AES)
>> +-- Data Encryption Standard (DES)/3DES
>> +-- Public Key Accelerator (PKA)
>> +-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
>> +-- PRNG: Pseudo Random Number Generator
>> +
>> +Required properties:
>> +
>> +- compatible : Should contain entries for this and backward compatible
>> +  SSS versions:
>> +  - "samsung,s5p-secss" for S5PV210 SoC.
>
>
> As I wrote in my previous reply, please use specific compatible string
> containing name of SoC on which the block described by it appeared first.
> Let me say it again, for security block that showed up first on S5PV210 the
> string will be "samsung,s5pv210-secss".
1. .name           = "s5p-secss", is the name used in the present driver.
    So, i dint modify that.
2. I'm not sure which one is the first soc to have the new varient.
    May be Exynos4210. Will modify in the next version.

>
>
>> +- reg : Offset and length of the register set for the module
>> +- interrupts : the interrupt-specifier for the SSS module.
>> +               Two interrupts "feed control and hash" in case of S5PV210
>> +- clocks : the required gating clock for the SSS module.
>> +- clock-names : the gating clock name to be requested in the SSS driver.
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index 93cddeb..78e0c37 100644
>> --- a/drivers/crypto/s5p-sss.c
>> +++ b/drivers/crypto/s5p-sss.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/scatterlist.h>
>>   #include <linux/dma-mapping.h>
>>   #include <linux/io.h>
>> +#include <linux/of.h>
>>   #include <linux/crypto.h>
>>   #include <linux/interrupt.h>
>>
>> @@ -145,6 +146,20 @@
>>   #define AES_KEY_LEN         16
>>   #define CRYPTO_QUEUE_LEN    1
>>
>> +/**
>> + * struct samsung_aes_varient - platform specific SSS driver data
>
>
> typo: s/varient/variant/g
>
> Anyway, I think this should be moved to the patch adding support for
> Exynos5, as before it there is no use for this struct and it's not directly
> related to DT support.
>
>
>> + * @has_hash_irq: true if SSS module uses hash interrupt, false otherwise
>> + * @aes_offset: AES register offset from SSS module's base.
>> + *
>> + * Specifies platform specific configuration of SSS module.
>> + * Note: A structure for driver specific platform data is used for future
>> + * expansion of its usage.
>> + */
>> +struct samsung_aes_varient {
>> +       bool                        has_hash_irq;
>> +       unsigned int                aes_offset;
>> +};
>> +
>>   struct s5p_aes_reqctx {
>>         unsigned long mode;
>>   };
>> @@ -173,10 +188,56 @@ struct s5p_aes_dev {
>>         struct crypto_queue         queue;
>>         bool                        busy;
>>         spinlock_t                  lock;
>> +
>> +       struct samsung_aes_varient *varient;
>>   };
>>
>>   static struct s5p_aes_dev *s5p_dev;
>>
>> +static struct samsung_aes_varient s5p_aes_data = {
>
>
> Remember to mark constant data as const.
>
>
>> +       .has_hash_irq   = true,
>> +       .aes_offset     = 0x4000,
>> +};
>> +
>> +static const struct platform_device_id s5p_sss_ids[] = {
>> +       {
>> +               .name           = "s5p-secss",
>> +               .driver_data    = (kernel_ulong_t)&s5p_aes_data,
>> +       },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(platform, s5p_sss_ids);
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id s5p_sss_dt_match[] = {
>> +       {
>> +               .compatible = "samsung,s5p-secss",
>> +               .data = (void *)&s5p_aes_data,
>
>
> No need to cast pointers to (void *) explicitly.
>
>
>> +       },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
>> +#else
>> +static struct of_device_id s5p_sss_dt_match[] =  {
>> +       { },
>> +};
>
>
> Hmm, I don't think there is any need for this.
I think all Exynos4 and Exynos5 now supports DT
But, i'm not sure of the S5PV210 series.
>
>
>> +#endif
>> +
>> +static inline struct samsung_aes_varient *find_s5p_sss_version
>> +                                  (struct platform_device *pdev)
>> +{
>> +       if (IS_ENABLED(CONFIG_OF)) {
>> +               if (pdev->dev.of_node) {
>
>
> What about using a single if, as follows:
>
> if (IS_ENABLED(CONFIG_IF) && pdev->dev.of_node)
>
>
>> +                       const struct of_device_id *match;
>> +                       match = of_match_node(s5p_sss_dt_match,
>
>
> You can use of_match_ptr(s5p_sss_dt_match) instead of referring to the table
> directly to eliminate the need for empty table.
>
>
>> +                                               pdev->dev.of_node);
>> +               return (struct samsung_aes_varient *)match->data;
>> +               }
>> +       }
>> +       return (struct samsung_aes_varient *)
>> +                       platform_get_device_id(pdev)->driver_data;
>> +}
>> +
>>   static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct
>> scatterlist *sg)
>>   {
>>         SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
>> @@ -564,6 +625,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>         struct s5p_aes_dev *pdata;
>>         struct device      *dev = &pdev->dev;
>>         struct resource    *res;
>> +       struct samsung_aes_varient *varient;
>>
>>         if (s5p_dev)
>>                 return -EEXIST;
>> @@ -580,6 +642,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>                                      resource_size(res), pdev->name))
>>                 return -EBUSY;
>>
>> +       varient = find_s5p_sss_version(pdev);
>> +
>>         pdata->clk = devm_clk_get(dev, "secss");
>>         if (IS_ERR(pdata->clk)) {
>>                 dev_err(dev, "failed to find secss clock source\n");
>> @@ -606,18 +670,21 @@ static int s5p_aes_probe(struct platform_device
>> *pdev)
>>         }
>>
>
> The if (variant->has_hash_irq) should start here and cover the whole block
> handling second interrupt. This should be more readable.
Indeed it is, But, adding extra tab was causing more lines to cross 80char limit
so, I used it this way.. Will modify in the next version.
>
>
>>         pdata->irq_hash = platform_get_irq(pdev, 1);
>> -       if (pdata->irq_hash < 0) {
>> +       if (varient->has_hash_irq && pdata->irq_hash < 0) {
>>                 err = pdata->irq_hash;
>>                 dev_warn(dev, "hash interrupt is not available.\n");
>>                 goto err_irq;
>>         }
>> -       err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
>> -                              IRQF_SHARED, pdev->name, pdev);
>> -       if (err < 0) {
>> -               dev_warn(dev, "hash interrupt is not available.\n");
>> -               goto err_irq;
>> +       if (varient->has_hash_irq) {
>> +               err = devm_request_irq(dev, pdata->irq_hash,
>> s5p_aes_interrupt,
>> +                                      IRQF_SHARED, pdev->name, pdev);
>> +               if (err < 0) {
>> +                       dev_warn(dev, "hash interrupt is not
>> available.\n");
>> +                       goto err_irq;
>> +               }
>>         }
>>
>> +       pdata->varient = varient;
>>         pdata->dev = dev;
>>         platform_set_drvdata(pdev, pdata);
>>         s5p_dev = pdata;
>> @@ -674,9 +741,11 @@ static int s5p_aes_remove(struct platform_device
>> *pdev)
>>   static struct platform_driver s5p_aes_crypto = {
>>         .probe  = s5p_aes_probe,
>>         .remove = s5p_aes_remove,
>> +       .id_table       = s5p_sss_ids,
>>         .driver = {
>>                 .owner  = THIS_MODULE,
>>                 .name   = "s5p-secss",
>> +               .of_match_table = s5p_sss_dt_match,
>
>
> .of_match_table = of_match_ptr(s5p_sss_dt_match),
I dint use it, Some time back there was a patchset from Sachin
https://lkml.org/lkml/2013/9/28/61
Please suggest me on this.
>
> Best regards,
> Tomasz



-- 
Shine bright,
(: Nav :)
