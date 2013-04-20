Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965621Ab3DTC3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 22:29:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:20347 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965552Ab3DTC3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 22:29:40 -0400
X-Spam-Score: -100.8
Message-ID: <5171FD67.2080104@asianux.com>
Date: Sat, 20 Apr 2013 10:28:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] ARM64: kernel: compiling issue, need implement cmpxchg64
 with assembler language.
References: <51712E5E.2020809@asianux.com> <201304191412.54601.arnd@arndb.de>
In-Reply-To: <201304191412.54601.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月19日 20:12, Arnd Bergmann wrote:
> On Friday 19 April 2013, Chen Gang wrote:
>> in arch/arm64/include/asm, not define the function cmpxchg64
>>
>>   when compiling with allmodconfig,
>>     drivers/block/blockconsole.c will need this function.
>>
>>   I am not quite familiar with ARM64 (neither ARM64 assembler)
>>
>>   can any member helps to send related patch ?
>>     if no one have time to send related patch, I should try.
>>     and I am glad to try, but need additional time resources,
>>     if I try, I should finish it within this month (2013-4-30).
>>
>>   welcome any suggestions or completions.
> 
> cmpxchg64 is the same as cmpxchg on 64-bit platforms, can't the
> driver be changed to use the latter?
> 
> 	Arnd
> 
> 

  can we be sure that cmpxchg64 is equal to cmpchg on all 64-bit platforms ?
    (I guess, the driver may need cross multiple platforms)
    (it seems, under x86, s390, better use cmpxchg64, at least they define it).

  whether we can be sure or not,
    I still prefer to define the macro cmpxchg64 just the alias of cmpxchg.
      (and I also guess ARM64 is always on 64-bit platform)

  the related patch may be like below.

-------------------------------patch begin--------------------------------------

diff --git a/arch/arm64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h
index 968b5cb..b572d2b 100644
--- a/arch/arm64/include/asm/cmpxchg.h
+++ b/arch/arm64/include/asm/cmpxchg.h
@@ -170,4 +170,6 @@ static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
 				       (unsigned long)(n),		\
 				       sizeof(*(ptr))))
 
+#define cmpxchg64(ptr,o,n)	cmpxchg((ptr),(o),(n))
+
 #endif	/* __ASM_CMPXCHG_H */

-------------------------------patch end----------------------------------------



  I think, we can also reference the implementation of s390:
    it is in arch/s390/include/asm/cmpxchg.h.
    since we are ARM64, excluding ARM(32,16...), we can only consider 64-bit.
    if in the future, ARM64 and ARM are merged together:
      we can use CONFIG_64BIT to switch the cmpxchg64 definition.
      if define CONFIG_64BIT, use cmpxchg instead of cmpxchg64.
      else, use the definition of ARM (arch/arm/include/asm/cmpxchg.h already defines cmpxchg64)

-------------------------------reference begin----------------------------------

#ifdef CONFIG_64BIT
#define cmpxchg64(ptr, o, n)						\
({									\
	cmpxchg((ptr), (o), (n));					\
})
#else /* CONFIG_64BIT */
...
-------------------------------reference end------------------------------------

  :-)

-- 
Chen Gang

Asianux Corporation
