Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaFZJh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:37:59 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37320 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaFZJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:37:57 -0400
Message-ID: <53ABE9F0.9090003@gmail.com>
Date: Thu, 26 Jun 2014 15:07:52 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, jslaby@suse.cz,
        gregkh@linuxfoundation.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 2/2] serial: amba-pl010: Use devres APIs
References: <1403503151-4166-1-git-send-email-tushar.b@samsung.com> <1403503151-4166-3-git-send-email-tushar.b@samsung.com> <53A821B7.2000702@linaro.org>
In-Reply-To: <53A821B7.2000702@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 06:16 PM, Daniel Thompson wrote:
> On 23/06/14 06:59, Tushar Behera wrote:
>> Migrating to use devres managed APIs devm_kzalloc, devm_ioremap and
>> devm_clk_get.
>>
>> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
>> ---
>>  drivers/tty/serial/amba-pl010.c |   46 ++++++++++++++-------------------------
>>  1 file changed, 16 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
>> index 971af1e..af8deba 100644
>> --- a/drivers/tty/serial/amba-pl010.c
>> +++ b/drivers/tty/serial/amba-pl010.c
>> @@ -46,6 +46,7 @@
>>  #include <linux/amba/serial.h>
>>  #include <linux/clk.h>
>>  #include <linux/slab.h>
>> +#include <linux/io.h>
>>  
>>  #include <asm/io.h>
> 
> Adding <linux/io.h> makes including <asm/io.h> redundant.
> 

Okay, I will remove the <asm/io.h> in next iteration.

> 
>> @@ -688,28 +689,22 @@ static int pl010_probe(struct amba_device *dev, const struct amba_id *id)
>>  		if (amba_ports[i] == NULL)
>>  			break;
>>  
>> -	if (i == ARRAY_SIZE(amba_ports)) {
>> -		ret = -EBUSY;
>> -		goto out;
>> -	}
>> +	if (i == ARRAY_SIZE(amba_ports))
>> +		return -EBUSY;
>>  
>> -	uap = kzalloc(sizeof(struct uart_amba_port), GFP_KERNEL);
>> -	if (!uap) {
>> -		ret = -ENOMEM;
>> -		goto out;
>> -	}
>> +	uap = devm_kzalloc(&dev->dev, sizeof(struct uart_amba_port),
>> +			   GFP_KERNEL);
>> +	if (!uap)
>> +		return -ENOMEM;
>>  
>> -	base = ioremap(dev->res.start, resource_size(&dev->res));
>> -	if (!base) {
>> -		ret = -ENOMEM;
>> -		goto free;
>> -	}
>> +	base = devm_ioremap(&dev->dev, dev->res.start,
>> +			    resource_size(&dev->res));
>> +	if (!base)
>> +		return -ENOMEM;
>>  
>> -	uap->clk = clk_get(&dev->dev, NULL);
>> -	if (IS_ERR(uap->clk)) {
>> -		ret = PTR_ERR(uap->clk);
>> -		goto unmap;
>> -	}
>> +	uap->clk = devm_clk_get(&dev->dev, NULL);
>> +	if (IS_ERR(uap->clk))
>> +		return PTR_ERR(uap->clk);
>>  
>>  	uap->port.dev = &dev->dev;
>>  	uap->port.mapbase = dev->res.start;
>> @@ -727,15 +722,9 @@ static int pl010_probe(struct amba_device *dev, const struct amba_id *id)
>>  
>>  	amba_set_drvdata(dev, uap);
>>  	ret = uart_add_one_port(&amba_reg, &uap->port);
>> -	if (ret) {
>> +	if (ret)
>>  		amba_ports[i] = NULL;
>> -		clk_put(uap->clk);
>> - unmap:
>> -		iounmap(base);
>> - free:
>> -		kfree(uap);
>> -	}
>> - out:
>> +
>>  	return ret;
>>  }
>>  
>> @@ -750,9 +739,6 @@ static int pl010_remove(struct amba_device *dev)
>>  		if (amba_ports[i] == uap)
>>  			amba_ports[i] = NULL;
>>  
>> -	iounmap(uap->port.membase);
>> -	clk_put(uap->clk);
>> -	kfree(uap);
>>  	return 0;
>>  }
> 
> Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
> 

Thanks for reviewing.

-- 
Tushar Behera
