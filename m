Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3GEBK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:10:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56205 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3GEBKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:10:24 -0400
X-Spam-Score: -100.8
Message-ID: <51D61CCB.40409@asianux.com>
Date: Fri, 05 Jul 2013 09:09:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] arch/*/asm/include/bitops.h: api issue, find_*_bit()
 defination are different with each other
References: <51AE8FEF.1020809@asianux.com> <51AE903C.6010806@asianux.com> <51AE909D.9080006@asianux.com> <20130605071915.GK23140@pengutronix.de> <51AF225A.5020703@asianux.com> <51B05865.30305@asianux.com> <51BFD51E.3040202@asianux.com>
In-Reply-To: <51BFD51E.3040202@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch whether OK, when you have time.

Thanks.

On 06/18/2013 11:33 AM, Chen Gang wrote:
> Hello related Maintainers:
> 
> Please help check this patch when you have time.
> 
> Thanks.
> 
> On 06/06/2013 05:37 PM, Chen Gang wrote:
>>
>> For arm and m68k, they customize find_*_bit(), but the API is different
>> with 'generic'.
>>
>> avr32, s390, and unicore32 also customize find_*_bit(), but the API is
>> the same with 'generic', and the left architectures all use 'generic'.
>>
>> So need change arm and m68k related API to match the 'generic', then
>> all another modules can face same public API for various architectures.
>>
>> Also beautify code and comments to pass "./scripts/checkpatch.pl"
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/arm/include/asm/bitops.h  |   26 ++++++++++++++++++--------
>>  arch/arm/lib/findbit.S         |   14 ++++++++++----
>>  arch/m68k/include/asm/bitops.h |   25 ++++++++++++++-----------
>>  3 files changed, 42 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
>> index e691ec9..83e4d3a 100644
>> --- a/arch/arm/include/asm/bitops.h
>> +++ b/arch/arm/include/asm/bitops.h
>> @@ -161,18 +161,28 @@ extern int _test_and_change_bit(int nr, volatile unsigned long * p);
>>  /*
>>   * Little endian assembly bitops.  nr = 0 -> byte 0 bit 0.
>>   */
>> -extern int _find_first_zero_bit_le(const void * p, unsigned size);
>> -extern int _find_next_zero_bit_le(const void * p, int size, int offset);
>> -extern int _find_first_bit_le(const unsigned long *p, unsigned size);
>> -extern int _find_next_bit_le(const unsigned long *p, int size, int offset);
>> +extern unsigned long _find_first_zero_bit_le(const void *p,
>> +						unsigned long size);
>> +extern unsigned long _find_next_zero_bit_le(const void *p, unsigned long size,
>> +						unsigned long offset);
>> +extern unsigned long _find_first_bit_le(const unsigned long *p,
>> +						unsigned long size);
>> +extern unsigned long _find_next_bit_le(const unsigned long *p,
>> +						unsigned long size,
>> +						unsigned long offset);
>>  
>>  /*
>>   * Big endian assembly bitops.  nr = 0 -> byte 3 bit 0.
>>   */
>> -extern int _find_first_zero_bit_be(const void * p, unsigned size);
>> -extern int _find_next_zero_bit_be(const void * p, int size, int offset);
>> -extern int _find_first_bit_be(const unsigned long *p, unsigned size);
>> -extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
>> +extern unsigned long _find_first_zero_bit_be(const void *p,
>> +						unsigned long size);
>> +extern unsigned long _find_next_zero_bit_be(const void *p, unsigned long size,
>> +						unsigned long offset);
>> +extern unsigned long _find_first_bit_be(const unsigned long *p,
>> +						unsigned long size);
>> +extern unsigned long _find_next_bit_be(const unsigned long *p,
>> +						unsigned long size,
>> +						unsigned long offset);
>>  
>>  #ifndef CONFIG_SMP
>>  /*
>> diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
>> index 64f6bc1..817dd70 100644
>> --- a/arch/arm/lib/findbit.S
>> +++ b/arch/arm/lib/findbit.S
>> @@ -19,7 +19,8 @@
>>  
>>  /*
>>   * Purpose  : Find a 'zero' bit
>> - * Prototype: int find_first_zero_bit(void *addr, unsigned int maxbit);
>> + * Prototype: unsigned long find_first_zero_bit(const void *p,
>> + *						unsigned long size);
>>   */
>>  ENTRY(_find_first_zero_bit_le)
>>  		teq	r1, #0	
>> @@ -40,7 +41,9 @@ ENDPROC(_find_first_zero_bit_le)
>>  
>>  /*
>>   * Purpose  : Find next 'zero' bit
>> - * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
>> + * Prototype: unsigned long find_next_zero_bit(const void *p,
>> + *						unsigned long size,
>> + *						unsigned long offset);
>>   */
>>  ENTRY(_find_next_zero_bit_le)
>>  		teq	r1, #0
>> @@ -60,7 +63,8 @@ ENDPROC(_find_next_zero_bit_le)
>>  
>>  /*
>>   * Purpose  : Find a 'one' bit
>> - * Prototype: int find_first_bit(const unsigned long *addr, unsigned int maxbit);
>> + * Prototype: unsigned long find_first_bit(const unsigned long *p,
>> + *					unsigned long size);
>>   */
>>  ENTRY(_find_first_bit_le)
>>  		teq	r1, #0	
>> @@ -81,7 +85,9 @@ ENDPROC(_find_first_bit_le)
>>  
>>  /*
>>   * Purpose  : Find next 'one' bit
>> - * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
>> + * Prototype: unsigned long find_next_bit(const unsigned long *p,
>> + *					unsigned long size,
>> + *					unsigned long offset);
>>   */
>>  ENTRY(_find_next_bit_le)
>>  		teq	r1, #0
>> diff --git a/arch/m68k/include/asm/bitops.h b/arch/m68k/include/asm/bitops.h
>> index c6baa91..b1d8752 100644
>> --- a/arch/m68k/include/asm/bitops.h
>> +++ b/arch/m68k/include/asm/bitops.h
>> @@ -320,11 +320,11 @@ static inline int bfchg_mem_test_and_change_bit(int nr,
>>  #include <asm-generic/bitops/ffz.h>
>>  #else
>>  
>> -static inline int find_first_zero_bit(const unsigned long *vaddr,
>> -				      unsigned size)
>> +static inline unsigned long find_first_zero_bit(const unsigned long *vaddr,
>> +				      unsigned long size)
>>  {
>>  	const unsigned long *p = vaddr;
>> -	int res = 32;
>> +	unsigned int res = 32;
>>  	unsigned int words;
>>  	unsigned long num;
>>  
>> @@ -346,11 +346,12 @@ out:
>>  }
>>  #define find_first_zero_bit find_first_zero_bit
>>  
>> -static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
>> -				     int offset)
>> +static inline unsigned long find_next_zero_bit(const unsigned long *vaddr,
>> +						unsigned long size,
>> +						unsigned long offset)
>>  {
>>  	const unsigned long *p = vaddr + (offset >> 5);
>> -	int bit = offset & 31UL, res;
>> +	unsigned int bit = offset & 31UL, res;
>>  
>>  	if (offset >= size)
>>  		return size;
>> @@ -376,10 +377,11 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
>>  }
>>  #define find_next_zero_bit find_next_zero_bit
>>  
>> -static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
>> +static inline unsigned long find_first_bit(const unsigned long *vaddr,
>> +						unsigned long size)
>>  {
>>  	const unsigned long *p = vaddr;
>> -	int res = 32;
>> +	unsigned int res = 32;
>>  	unsigned int words;
>>  	unsigned long num;
>>  
>> @@ -401,11 +403,12 @@ out:
>>  }
>>  #define find_first_bit find_first_bit
>>  
>> -static inline int find_next_bit(const unsigned long *vaddr, int size,
>> -				int offset)
>> +static inline unsigned long find_next_bit(const unsigned long *vaddr,
>> +						unsigned long size,
>> +						unsigned long offset)
>>  {
>>  	const unsigned long *p = vaddr + (offset >> 5);
>> -	int bit = offset & 31UL, res;
>> +	unsigned int bit = offset & 31UL, res;
>>  
>>  	if (offset >= size)
>>  		return size;
>>
> 
> 


-- 
Chen Gang
