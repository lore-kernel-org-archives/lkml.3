Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3CBFWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 00:22:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:59471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3CBFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 00:22:03 -0500
Message-ID: <51318C9B.8000403@infradead.org>
Date: Fri, 01 Mar 2013 21:22:35 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2013-03-01-15-50 uploaded (strict user copy)
References: <20130301235135.E9F105A41B2@corp2gmr1-2.hot.corp.google.com> <51316B64.90102@infradead.org> <5131753F.3070302@codeaurora.org> <51317D2B.6060601@codeaurora.org>
In-Reply-To: <51317D2B.6060601@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/13 20:16, Stephen Boyd wrote:
> On 03/01/13 19:42, Stephen Boyd wrote:
>> On 03/01/13 19:00, Randy Dunlap wrote:
>>> On 03/01/13 15:51, akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2013-03-01-15-50 has been uploaded to
>>>>
>>>>    http://www.ozlabs.org/~akpm/mmotm/
>>>>
>>> on i386:
>>>
>>> ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
>>>
>>> which I don't understand.
>>> lib/usercopy.o is built and building binfmt_misc.c says:
>>>
>>>   CC [M]  fs/binfmt_misc.o
>>> In file included from arch/x86/include/asm/uaccess.h:537:0,
>>>                  from include/linux/uaccess.h:5,
>>>                  from include/linux/highmem.h:8,
>>>                  from include/linux/pagemap.h:10,
>>>                  from fs/binfmt_misc.c:27:
>>> arch/x86/include/asm/uaccess_32.h: In function 'parse_command.part.1':
>>> arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]
>> Hm.. That's because it's part of lib and not obj, right?

Yes, this fixes the build error.

>> diff --git a/lib/Makefile b/lib/Makefile
>> index 59fabd0..4c55104 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -15,7 +15,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>>          is_single_threaded.o plist.o decompress.o kobject_uevent.o \
>>          earlycpio.o percpu-refcount.o
>>  
>> -lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>> +obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>>  lib-$(CONFIG_MMU) += ioremap.o
>>  lib-$(CONFIG_SMP) += cpumask.o
>>  
>>
> 
> I'm a little confused though because it is lib-y on x86 before my patch.

binfmt_misc is built as a loadable module in my config.
It must be the only user of copy_from_user_overflow() in this config.
I guess that it would also fail prior to your patch, but I haven't
tested it.  Anyway, your patch above is correct and needed.

thanks,
-- 
~Randy
