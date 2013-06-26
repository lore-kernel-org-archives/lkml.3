Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3FZIj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:39:58 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401Ab3FZIjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:39:55 -0400
Message-ID: <51CAA8D6.9000505@nod.at>
Date: Wed, 26 Jun 2013 10:39:50 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Jeff Dike <jdike@addtoit.com>, Arnd Bergmann <arnd@arndb.de>,
        dhsharp@google.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com>
In-Reply-To: <51CAA78C.5040900@asianux.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2013 10:34, schrieb Chen Gang:
> On 06/26/2013 04:05 PM, Richard Weinberger wrote:
>>>>>>>> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
>>>>>>>> index d5afe96..e80331d 100644
>>>>>>>> --- a/include/asm-generic/io.h
>>>>>>>> +++ b/include/asm-generic/io.h
>>>>>>>> @@ -303,10 +303,10 @@ static inline void *phys_to_virt(unsigned long address)
>>>>>>>>  /*
>>>>>>>>   * Change "struct page" to physical address.
>>>>>>>>   *
>>>>>>>> - * This implementation is for the no-MMU case only... if you have an MMU
>>>>>>>> + * This implementation is for the no-MMU or UML case only... if you have an MMU
>>>>>>>>   * you'll need to provide your own definitions.
>>>>>>>>   */
>>>>>>>> -#ifndef CONFIG_MMU
>>>>>>>> +#if !CONFIG_MMU || CONFIG_UML
>>>>>>>>  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>>>>>>>>  {
>>>>>>>>  	return (void __iomem*) (unsigned long)offset;
>>>>>>>> @@ -325,7 +325,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>>>>>>>>  static inline void iounmap(void __iomem *addr)
>>>>>>>>  {
>>>>>>>>  }
>>>>>>>> -#endif /* CONFIG_MMU */
>>>>>>>> +#endif /* !CONFIG_MMU || CONFIG_UML */
>>>>>>>>  
>>>>>>>>  #ifdef CONFIG_HAS_IOPORT
>>>>>>>>  #ifndef CONFIG_GENERIC_IOMAP
>>>>>>>>
>>>>>>
>>>>>> UML has no io memory but a MMU, so I'd argue that you better fix drivers/ptp/ptp_pch.c dependencies.
>>>>>> _If_ ptp_pch.c really works without real io memory, you can look what I did in my GENERIC_IO series[1]
>>>>>> to make nandsim work on UML. Maybe this helps.
>>>>>>
>>>>
>>>> But "no io memory" is not the excuse to not define the related dummy
>>>> function.
>> UML has no io memory, period.
>> Same applies for s390, it also includes asm-generic/io.h in the !CONFIG_PCI
>> case.
>> UML and s390 are very special here.
>>
> 
> Oh, yes, really the same.
> 
>>>> The drivers internal code has already check the related return value,
>>>> so it is the architecture's duty to 'tell' the driver whether support
>>>> io memory (e.g. define ioremap, but return NULL).
>> It does so already by setting CONFIG_HAS_IOMEM=n
> 
> Excuse me, I use "grep -rn ioremap *" under "include/" and "arch/um/"
> directory, but can not find the related definition for 'ioremap'.
> 
> Is there another declaration or definition way which I don't know ?
> (maybe it is).

Both UML and s390 (in the !CONFIG_PCI) do not define ioremap() because
without io memory you cannot have a ioremap().

> For our case, the ".config" file does not define 'CONFIG_HAS_IOMEM', can
> I assume it means "CONFIG_HAS_IOMEM=n" ?

If I'm not mistaken it works the other way around.
All archs except UML and s390 set CONFIG_HAS_IOMEM=y.

Thanks,
//richard
