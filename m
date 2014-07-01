Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbaGASZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:25:57 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47567 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbaGASZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <009301cf93f6$f938a270$eba9e750$%han@samsung.com>
References: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1404084516-901-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<009301cf93f6$f938a270$eba9e750$%han@samsung.com>
Date: Tue, 1 Jul 2014 20:25:54 +0200
Message-ID: <CAFo99gY2qEEqwJgu-NQryAe2=o5AsDjL+SFaau6BA7CBMH8Xkg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: busses: i2c-pxa.c: Fix for possible null pointer dereferenc
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-30 2:05 GMT+02:00 Jingoo Han <jg1.han@samsung.com>:
> On Monday, June 30, 2014 8:29 AM, Rickard Strandqvist wrote:
>>
>> Fix for possible null pointer dereferenc, and there is a risk for memory leak in when something
>> unexpected happens and the function returns.
>
> Would you split the patch into two patches?
>
>   [PATCH 1/2] i2c: pxa: Fix for possible null pointer dereference
>   [PATCH 2/2] i2c: pxa: Use devm_* functions
>
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
>>  1 file changed, 16 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
>> index be671f7..886877a 100644
>> --- a/drivers/i2c/busses/i2c-pxa.c
>> +++ b/drivers/i2c/busses/i2c-pxa.c
>> @@ -1141,10 +1141,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>       struct resource *res = NULL;
>>       int ret, irq;
>>
>> -     i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
>> +     i2c = devm_kzalloc(&dev->dev, sizeof(struct pxa_i2c), GFP_KERNEL);
>>       if (!i2c) {
>>               ret = -ENOMEM;
>> -             goto emalloc;
>> +             goto err_nothing_to_release;
>>       }
>>
>>       /* Default adapter num to device id; i2c_pxa_probe_dt can override. */
>> @@ -1154,18 +1154,19 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>       if (ret > 0)
>>               ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
>>       if (ret < 0)
>> -             goto eclk;
>> +             goto err_nothing_to_release;
>>
>>       res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>       irq = platform_get_irq(dev, 0);
>>       if (res == NULL || irq < 0) {
>>               ret = -ENODEV;
>> -             goto eclk;
>> +             goto err_nothing_to_release;
>>       }
>>
>> -     if (!request_mem_region(res->start, resource_size(res), res->name)) {
>> +     if (!devm_request_mem_region(&dev->dev, res->start,
>> +                             resource_size(res), res->name)) {
>>               ret = -ENOMEM;
>> -             goto eclk;
>> +             goto emalloc;
>>       }
>>
>>       i2c->adap.owner   = THIS_MODULE;
>> @@ -1176,16 +1177,16 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>
>>       strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
>>
>> -     i2c->clk = clk_get(&dev->dev, NULL);
>> +     i2c->clk = devm_clk_get(&dev->dev, NULL);
>>       if (IS_ERR(i2c->clk)) {
>>               ret = PTR_ERR(i2c->clk);
>> -             goto eclk;
>> +             goto emalloc;
>>       }
>>
>> -     i2c->reg_base = ioremap(res->start, resource_size(res));
>> -     if (!i2c->reg_base) {
>> +     i2c->reg_base = devm_ioremap(&dev->dev, res->start, resource_size(res));
>> +     if (IS_ERR(i2c->reg_base)) {
>
> Did you check what devm_ioremap() returns?
> It returns 'valid addr value' Or NULL as below.
> So, IS_ERR() should NOT be used.
>
> ./lib/devres.c
>
> void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
>                            unsigned long size)
> {
>         void __iomem **ptr, *addr;
>
>         ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
>         if (!ptr)
>                 return NULL;
>
>         addr = ioremap(offset, size);
>         if (addr) {
>                 *ptr = addr;
>                 devres_add(dev, ptr);
>         } else
>                 devres_free(ptr);
>
>         return addr;
> }
> EXPORT_SYMBOL(devm_ioremap);
>
> Best regards,
> Jingoo Han
>
>>               ret = -EIO;
>> -             goto eremap;
>> +             goto emalloc;
>>       }
>>
>>       i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
>> @@ -1227,10 +1228,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>               i2c->adap.algo = &i2c_pxa_pio_algorithm;
>>       } else {
>>               i2c->adap.algo = &i2c_pxa_algorithm;
>> -             ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
>> -                               dev_name(&dev->dev), i2c);
>> +             ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
>> +                              IRQF_SHARED, dev_name(&dev->dev), i2c);
>>               if (ret)
>> -                     goto ereqirq;
>> +                     goto emalloc;
>>       }
>>
>>       i2c_pxa_reset(i2c);
>> @@ -1261,15 +1262,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>  eadapt:
>>       if (!i2c->use_pio)
>>               free_irq(irq, i2c);
>> -ereqirq:
>> -     clk_disable_unprepare(i2c->clk);
>> -     iounmap(i2c->reg_base);
>> -eremap:
>> -     clk_put(i2c->clk);
>> -eclk:
>> -     kfree(i2c);
>>  emalloc:
>>       release_mem_region(res->start, resource_size(res));
>> +err_nothing_to_release:
>>       return ret;
>>  }
>>
>> --
>> 1.7.10.4
>


Hi

Excuse my late reply.


1)  A fix of the original error I made in my original patch.
But it was completely different from this solution, you have trouble
seeing it as something reasonable to do.

My original patch:

 eclk:
        kfree(i2c);
 emalloc:
-       release_mem_region(res->start, resource_size(res));
+       if(res)
+               release_mem_region(res->start, resource_size(res));
        return ret;
 }

2) Wolfram Sang helped me with a patch example from commit 9b2b98a3b4de
It hade this code below. I thought that it seem a little strange, but
I trust Wolfram.

-       dev->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
-       if (!dev->virtbase) {
+       dev->virtbase = devm_ioremap(&adev->dev, adev->res.start,
+                               resource_size(&adev->res));
+       if (IS_ERR(dev->virtbase)) {
                ret = -ENOMEM;
-               goto err_no_ioremap;
+               goto err_no_mem;
        }


Kind regards
Rickard Strandqvist
