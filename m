Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaGQJAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:00:00 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44325 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaGQI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:59:46 -0400
Message-ID: <53C7905D.9090003@gmail.com>
Date: Thu, 17 Jul 2014 16:59:09 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org, arnd@arndb.de,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <20140713201753.GA29955@kroah.com> <53C39569.9020802@nod.at> <53C3994C.1010309@metafoo.de> <53C39B66.4060500@nod.at> <5A40E1FC-CA61-4AFF-B205-4BAC175AA7AC@gmail.com> <53C47725.8000005@gmail.com> <53C47B76.4080306@roeck-us.net> <53C47FB7.6080304@gmail.com> <53C53CE1.4090803@gmail.com> <53C7269E.4010702@gmail.com> <20140717083756.GA19686@ulmo>
In-Reply-To: <20140717083756.GA19686@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2014 04:37 PM, Thierry Reding wrote:
> On Thu, Jul 17, 2014 at 09:27:58AM +0800, Chen Gang wrote:
> [...]
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index c2421e0..a7500c3 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -630,7 +630,16 @@ extern unsigned long devm_get_free_pages(struct device *dev,
>>  					 gfp_t gfp_mask, unsigned int order);
>>  extern void devm_free_pages(struct device *dev, unsigned long addr);
>>  
>> +#ifdef CONFIG_HAS_IOMEM
>>  void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
>> +#elif defined(CONFIG_COMPILE_TEST)
>> +static inline void __iomem *devm_ioremap_resource(struct device *dev,
>> +						struct resource *res)
>> +{
>> +	pr_warn("no hardware io memory, only for COMPILE_TEST\n");
> 
> Maybe: "Hardware doesn't support memory-mapped I/O"? I'm not sure if
> it's useful to include the reference to COMPILE_TEST, especially since
> the #elif will be dropped in favour of a simple #else.
> 

OK, thanks. I will use the comments which you provide.

And also use #else instead of #elif, use 'dev_warn' instead of 'pr_warn'
which Guenter suggests.

>> +	return (__force void __iomem *)ERR_PTR(-ENXIO);
> 
> There's apparently an IOMEM_ERR_PTR() for this nowadays...
> 

IOMEM_ERR_PTR() is defined within "lib/devres.c", not in "./include".
But may we move it from "lib/devres.c" to "./include/linux/err.h"?

For me, I am not quite sure, it may need additional discussion, but at
least, that will be another patch.

>> +}
>> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
>>  
>>  /* allows to add/remove a custom action to devres stack */
>>  int devm_add_action(struct device *dev, void (*action)(void *), void *data);
>> diff --git a/include/linux/io.h b/include/linux/io.h
>> index b76e6e5..59128aa 100644
>> --- a/include/linux/io.h
>> +++ b/include/linux/io.h
>> @@ -58,14 +58,42 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
>>  }
>>  #endif
>>  
>> +#ifdef CONFIG_HAS_IOMEM
>> +
>>  void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
>>  			    unsigned long size);
>>  void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
>>  				    unsigned long size);
>>  void devm_iounmap(struct device *dev, void __iomem *addr);
>> +void devm_ioremap_release(struct device *dev, void *res);
>> +
>> +#elif defined(CONFIG_COMPILE_TEST)
>> +
>> +static inline void __iomem *devm_ioremap(struct device *dev,
>> +				resource_size_t offset, unsigned long size)
> 
> For consistency with other functions above, please keep arguments on
> subsequent lines aligned with the first argument on the first line, like
> so:
> 
> static inline void __iomem *devm_ioremap(struct device *dev,
> 					 resource_size_t offset,
> 					 unsigned long size)
> 

That sounds fine to me, thanks.

>> +{
>> +	pr_warn("no hardware io memory, only for COMPILE_TEST\n");
>> +	return NULL;
>> +}
>> +static inline void __iomem *devm_ioremap_nocache(struct device *dev,
>> +				resource_size_t offset, unsigned long size)
>> +{
>> +	pr_warn("no hardware io memory, only for COMPILE_TEST\n");
>> +	return NULL;
>> +}
> 
> Perhaps this should call devm_ioremap() so we don't have to repeat the
> same error message? Or maybe make it:
> 
> 	#define devm_ioremap_nocache devm_ioremap
> 

That sounds fine to me, thanks.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
