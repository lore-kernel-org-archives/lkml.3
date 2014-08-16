Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHPVci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:32:38 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:48695 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaHPVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:32:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140802113001.GC2739@katana>
References: <1405545251-13087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1405545251-13087-2-git-send-email-rickard_strandqvist@spectrumdigital.se> <20140802113001.GC2739@katana>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat, 16 Aug 2014 23:32:16 +0200
Message-ID: <CAFo99gb3vASH8k3nhKiQ9+0sST4oeKL=sOK27JjOurAvwWxEJg@mail.gmail.com>
Subject: Re: [PATCH v4] i2c: busses: i2c-pxa.c: Fix for possible null pointer dereference
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-02 13:30 GMT+02:00 Wolfram Sang <wsa@the-dreams.de>:
> Hi,
>
>>       res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>       irq = platform_get_irq(dev, 0);
>> -     if (res == NULL || irq < 0) {
>> -             ret = -ENODEV;
>> -             goto eclk;
>> -     }
>> +     if (res == NULL || irq < 0)
>> +             return -ENODEV;
>
> No need to check for valid 'res' here...
>
>>
>> -     if (!request_mem_region(res->start, resource_size(res), res->name)) {
>> -             ret = -ENOMEM;
>> -             goto eclk;
>> -     }
>> +     if (!devm_request_mem_region(&dev->dev, res->start,
>> +                             resource_size(res), res->name))
>> +             return -ENOMEM;
>
> ... and no need to use 'devm_request_mem_region' ...
>
>> -     i2c->reg_base = ioremap(res->start, resource_size(res));
>> -     if (!i2c->reg_base) {
>> -             ret = -EIO;
>> -             goto eremap;
>> -     }
>> +     i2c->reg_base = devm_ioremap_resource(&adev->dev, res));
>> +     if (IS_ERR(i2c->reg_base))
>> +             return -EIO;
>
> ... because devm_ioremap_resource does all that for you. Also, don't
> return -EIO but the PTR_ERR given from the function. Just check other
> drivers how they do it.
>
>>
>>       i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
>>       i2c->reg_idbr = i2c->reg_base + pxa_reg_layout[i2c_type].idbr;
>> @@ -1227,10 +1218,12 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>               i2c->adap.algo = &i2c_pxa_pio_algorithm;
>>       } else {
>>               i2c->adap.algo = &i2c_pxa_algorithm;
>> -             ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
>> -                               dev_name(&dev->dev), i2c);
>> -             if (ret)
>> -                     goto ereqirq;
>> +             ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
>> +                              IRQF_SHARED, dev_name(&dev->dev), i2c);
>> +             if (ret) {
>> +                     clk_disable_unprepare(i2c->clk);
>> +                     return ret;
>
> Maybe you should make a error path with 'goto' out of it...
>
>
>> +             }
>>       }
>>
>>       i2c_pxa_reset(i2c);
>> @@ -1244,7 +1237,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>       ret = i2c_add_numbered_adapter(&i2c->adap);
>>       if (ret < 0) {
>>               printk(KERN_INFO "I2C: Failed to add bus\n");
>> -             goto eadapt;
>> +             return ret;
>
> ... since you forgot disable_unprepare here and could simply reuse it.
>
>
>>       }
>>
>>       platform_set_drvdata(dev, i2c);
>> @@ -1257,20 +1250,6 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>              dev_name(&i2c->adap.dev));
>>  #endif
>>       return 0;
>> -
>> -eadapt:
>> -     if (!i2c->use_pio)
>> -             free_irq(irq, i2c);
>> -ereqirq:
>> -     clk_disable_unprepare(i2c->clk);
>> -     iounmap(i2c->reg_base);
>> -eremap:
>> -     clk_put(i2c->clk);
>> -eclk:
>> -     kfree(i2c);
>> -emalloc:
>> -     release_mem_region(res->start, resource_size(res));
>> -     return ret;
>>  }
>
> You forgot to cleanup the remove function.
>
> BTW I forgot, can you test this patch on real hardware? If not, is there
> somebody who does?
>
> All the best,
>
>    Wolfram



Hi

I have made a lot of changes on changes to changes, and have really
tried to ensure that all would be right.

But I feel like that's enough, Wolfram or anyone else may end this.

And no as I replied earlier, I lack this kind of hardware...


Kind regards
Rickard Strandqvist
