Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaGQKka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:40:30 -0400
Received: from smtp-out-155.synserver.de ([212.40.185.155]:1116 "EHLO
	smtp-out-155.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGQKkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:40:25 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17631
Message-ID: <53C7A819.40403@metafoo.de>
Date: Thu, 17 Jul 2014 12:40:25 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Chen Gang <gang.chen.5i5j@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <53C53CE1.4090803@gmail.com> <53C7269E.4010702@gmail.com> <6823014.2plXDE9VA9@wuerfel>
In-Reply-To: <6823014.2plXDE9VA9@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:20 AM, Arnd Bergmann wrote:
> On Thursday 17 July 2014 09:27:58 Chen Gang wrote:
>>                                           gfp_t gfp_mask, unsigned int order);
>>   extern void devm_free_pages(struct device *dev, unsigned long addr);
>>
>> +#ifdef CONFIG_HAS_IOMEM
>>   void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
>> +#elif defined(CONFIG_COMPILE_TEST)
>> +static inline void __iomem *devm_ioremap_resource(struct device *dev,
>> +                                               struct resource *res)
>> +{
>> +       pr_warn("no hardware io memory, only for COMPILE_TEST\n");
>> +       return (__force void __iomem *)ERR_PTR(-ENXIO);
>> +}
>> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
>>
>>   /* allows to add/remove a custom action to devres stack */
>
> To be honest, I think it's a bad idea to introduce wrappers functions
> that are only available when CONFIG_COMPILE_TEST is set.
>
> COMPILE_TEST is a great tool in general, but it has its limits.
> In particular, the case for !CONFIG_IOMEM is completely obscure
> and we won't find any bugs by allowing more drivers to be built
> in those configurations, but attempting to do it would cause
> endless churn by changing each instance of 'depends on HAS_IOMEM'
> to 'depends on HAS_IOMEM || COMPILE_TEST'.

The point of this exercise is that we do not have to replace a good chunk of 
'depends on COMPILE_TEST' with 'depends on COMPILE_TEST && HAS_IOMEM'

E.g. the typical Kconfig entry for your random SoC peripheral driver looks like

config ARCH_FOOBAR_DRIVER
	depends on ARCH_FOOBAR || COMPILE_TEST
	...

Now when COMPILE_TEST is not set there is a implicit dependency on HAS_IOMEM 
since the architecture will provide it. If COMPILE_TEST is selected the 
driver will also be build-able on architectures that do no have HAS_IOMEM 
and hence linking the driver fails. One way to fix this is of course to 
replace the COMPILE_TEST with (COMPILE_TEST && HAS_IOMEM). But this is very 
often overlooked and only noticed later on when somebody actually builds a 
allyesconfig on an architecture that does not provide HAS_IOMEM. To avoid 
these kinds of build errors and tedious fixup patches the idea is to provide 
a stub function when HAS_IOMEM is not enabled, but COMPILE_TEST is enabled.

