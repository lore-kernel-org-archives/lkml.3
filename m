Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3EGF4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:56:01 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6986 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3EGFz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:55:59 -0400
Message-ID: <51889744.1090109@huawei.com>
Date: Tue, 7 May 2013 13:55:16 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: <wsa@the-dreams.de>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/2] i2c: pxa: no need release_mem_region before request_mem_region
 successful
References: <5187ABF9.4000903@huawei.com> <51886E12.8070701@cn.fujitsu.com>
In-Reply-To: <51886E12.8070701@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/7 10:59, Gu Zheng wrote:
> Hi libo,
> 
> On 05/06/2013 09:11 PM, Libo Chen wrote:
> 
>>
>> move release_mem_region above kfree(i2c) && below clk_put(i2c->clk)
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>  drivers/i2c/busses/i2c-pxa.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
>> index ea6d45d..3188cd0 100644
>> --- a/drivers/i2c/busses/i2c-pxa.c
>> +++ b/drivers/i2c/busses/i2c-pxa.c
>> @@ -1129,7 +1129,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
>>  	i2c->clk = clk_get(&dev->dev, NULL);
>>  	if (IS_ERR(i2c->clk)) {
>>  		ret = PTR_ERR(i2c->clk);
>> -		goto eclk;
>> +		goto emm;
> 
> The new tag 'emm' seems not suitable here, keep the original 'eclk' here, modify the upper 'eclk' tags instead:
> ...
> 	ret = i2c_pxa_probe_dt(dev, i2c, &i2c_type);
> 	if (ret > 0)
> 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
> 	if (ret < 0)
> -		goto eclk;
> +		goto etype;
> 
> 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
> 	irq = platform_get_irq(dev, 0);
> 	if (res == NULL || irq < 0) {
> 		ret = -ENODEV;
> -		goto eclk;
> +		goto edev;


Thanks a lot.  Yes, it is . Original lable name seems not suitable.
but lable:edev is redundant, useless .

I concern this patch is usefull for your work? However I will change it later.

Thanks,
Libo


> 	}
> 
> 	if (!request_mem_region(res->start, resource_size(res), res->name)) {
> 		ret = -ENOMEM;
> -		goto eclk;
> +		goto emem;
> 	}
> ...
> 
>>  	}
>>
>>  	i2c->reg_base = ioremap(res->start, resource_size(res));
>> @@ -1206,10 +1206,11 @@ ereqirq:
>>  	iounmap(i2c->reg_base);
>>  eremap:
>>  	clk_put(i2c->clk);
>> +emm:
>> +	release_mem_region(res->start, resource_size(res));
>>  eclk:
>>  	kfree(i2c);
> 
>    eclk:
> 	release_mem_region(res->start, resource_size(res));
>    etype:
>    edev:
>    emem:
>   	kfree(i2c);
> 
>>  emalloc:
>> -	release_mem_region(res->start, resource_size(res));
>>  	return ret;
>>  }
>>
> 
> Thanks,
> Gu
> 
> 
> .
> 


