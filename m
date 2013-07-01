Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3GACJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 22:09:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38621 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3GACJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 22:09:43 -0400
X-Spam-Score: -100.8
Message-ID: <51D0E4B3.6080402@asianux.com>
Date: Mon, 01 Jul 2013 10:08:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] arch: tile: include: asm: add cmpxchg64() definition
References: <51CA6D21.3090901@asianux.com> <51CC492C.1040105@tilera.com> <51CCD891.8000806@asianux.com> <51CCEC27.8050508@asianux.com> <20130628150941.GA22767@linux-mips.org>
In-Reply-To: <20130628150941.GA22767@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly thank you very much for replying quickly with details.

On 06/28/2013 11:09 PM, Ralf Baechle wrote:
> On Fri, Jun 28, 2013 at 09:51:35AM +0800, Chen Gang wrote:
> 
>> Need add cmpxchg64(), or will cause compiling issue.
>>
>> Just define it as cmpxchg(), since cmpxchg() can support 8 bytes.
>>
>> The related error (with allmodconfig):
>>
>>   drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
>>   drivers/block/blockconsole.c:164:2: error: implicit declaration of function ‘cmpxchg64’ [-Werror=implicit-function-declaration]
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/tile/include/asm/cmpxchg.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
>> index 276f067..7688c28 100644
>> --- a/arch/tile/include/asm/cmpxchg.h
>> +++ b/arch/tile/include/asm/cmpxchg.h
>> @@ -68,6 +68,8 @@ extern unsigned long __cmpxchg_called_with_bad_pointer(void);
>>  
>>  #define tas(ptr) (xchg((ptr), 1))
>>  
>> +#define cmpxchg64(ptr, o, n)		cmpxchg((ptr), (o), (n))
> 
> that's broken.  cmpxchg64 is suposed to work on 64 bit operands ONLY.  This
> definition (used by MIPS and Alpha) will work properly:
> 

Oh, really it is. thanks.

> #define cmpxchg64(ptr, o, n)                                            \
> ({                                                                      \
> 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);                              \
> 	cmpxchg((ptr), (o), (n));                                       \
> })
> 

I should follow it to send patch v2, thanks.

> This should cure blockconsole on Tile but not on MIPS.
> 
> struct blockconsole {
> ..
>            u64 console_bytes;
> ..
> };
> 
> static void bcon_advance_console_bytes(struct blockconsole *bc, int bytes)
> {
> 	u64 old, new;
> 	...
> 	} while (cmpxchg64(&bc->console_bytes, old, new) != old);
> }
> 
> So it's using cmpxchg64() to operate on 64 bit objects - but that's not
> going to work on every architecture.  Many 32 bit architectures only
> provide atomic operations that operate on 32 bit quantities.
> 

I guess your meaning is:

  cmpxchg64() should be an atomic operation.
  but on some of 32-bit architectures, they don't implement it as atomic
    (no lock protected, at least).
  it may cause issue on these 32-bit architectures.

Is it correct ?

If it is correct, I should continue to try to fix it.


Thanks.
-- 
Chen Gang
