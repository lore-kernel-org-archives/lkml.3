Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaGQLc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:32:56 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59018 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbaGQLcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:32:51 -0400
Message-ID: <53C7B459.7020604@gmail.com>
Date: Thu, 17 Jul 2014 19:32:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, Lars-Peter Clausen <lars@metafoo.de>,
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
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <53C796E1.8080708@nod.at> <8453588.VVyODXRso0@wuerfel> <53C7AC6F.1070001@nod.at>
In-Reply-To: <53C7AC6F.1070001@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2014 06:58 PM, Richard Weinberger wrote:
> Am 17.07.2014 12:28, schrieb Arnd Bergmann:
>> On Thursday 17 July 2014 11:26:57 Richard Weinberger wrote:
>>> Am 17.07.2014 11:20, schrieb Arnd Bergmann:
>>>> On Thursday 17 July 2014 09:27:58 Chen Gang wrote:
>>>>>                                          gfp_t gfp_mask, unsigned int order);
>>>>>  extern void devm_free_pages(struct device *dev, unsigned long addr);
>>>>>  
>>>>> +#ifdef CONFIG_HAS_IOMEM
>>>>>  void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
>>>>> +#elif defined(CONFIG_COMPILE_TEST)
>>>>> +static inline void __iomem *devm_ioremap_resource(struct device *dev,
>>>>> +                                               struct resource *res)
>>>>> +{
>>>>> +       pr_warn("no hardware io memory, only for COMPILE_TEST\n");
>>>>> +       return (__force void __iomem *)ERR_PTR(-ENXIO);
>>>>> +}
>>>>> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
>>>>>  
>>>>>  /* allows to add/remove a custom action to devres stack */
>>>>
>>>> To be honest, I think it's a bad idea to introduce wrappers functions
>>>> that are only available when CONFIG_COMPILE_TEST is set.
>>>>
>>>> COMPILE_TEST is a great tool in general, but it has its limits.
>>>> In particular, the case for !CONFIG_IOMEM is completely obscure
>>>> and we won't find any bugs by allowing more drivers to be built
>>>> in those configurations, but attempting to do it would cause
>>>> endless churn by changing each instance of 'depends on HAS_IOMEM'
>>>> to 'depends on HAS_IOMEM || COMPILE_TEST'.
>>>>
>>>> Note that s390 no has gained support for IOMEM, tile has it most
>>>> of the time (when PCI is enabled, so you get it in half the
>>>> test builds already), score should set HAS_IOMEM and doesn't
>>>> even have public compilers, and uml doesn't even compile in
>>>> latest mainline. Nothing else ever sets NO_IOMEM.
>>>
>>> Huh? UML (v3.16-rc5-143-gb6603fe) builds fine here. What build issue are you facing?
>>
>> This is what I got upon trying earlier. I have not attempted to look into
>> why this is happening. Note this is on linux-next from yesterday,
>> not mainline as I incorrectly stated above.
>>
>> In file included from ../arch/um/include/asm/fixmap.h:58:0,
>>                  from ../arch/um/include/asm/pgtable.h:11,
>>                  from ../include/linux/mm.h:51,
>>                  from ../kernel/uid16.c:6:
>> ../include/asm-generic/fixmap.h: In function 'fix_to_virt':
>> ../include/asm-generic/fixmap.h:31:2: error: size of unnamed array is negative
>>   BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
> 
> So, this is next-20140716?
> I don't see the fixmap issue you're reporting, also not on the most recent next.
> 
> All I see is the known ext4 issue with CONFIG_SMP=n:
> 
> fs/ext4/super.c: In function ‘ext4_commit_super’:
> fs/ext4/super.c:4547:41: error: ‘struct percpu_counter’ has no member named ‘counters’
>   if (EXT4_SB(sb)->s_freeclusters_counter.counters)
>                                          ^
> fs/ext4/super.c:4551:39: error: ‘struct percpu_counter’ has no member named ‘counters’
>   if (EXT4_SB(sb)->s_freeinodes_counter.counters)
> 

Yeah, and I have notified to ext4 related maintainer, yesterday, and he
has already send fix patch for it, I guess it will be integrated into
main line soon.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
