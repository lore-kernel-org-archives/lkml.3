Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaCWGc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:32:27 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59474 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCWGcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:32:25 -0400
Message-ID: <532E7FF5.9060806@converseincode.com>
Date: Sat, 22 Mar 2014 23:32:21 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] LLVMLinux: Remove warning about returning an uninitialized
 variable
References: <201403221101.16961.arnd@arndb.de>		 <1395503299-15203-1-git-send-email-behanw@converseincode.com>	 <1395505786.2143.14.camel@dabdike.int.hansenpartnership.com>	 <532DBC50.9040505@converseincode.com> <1395506558.2143.18.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1395506558.2143.18.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/14 09:42, James Bottomley wrote:
> On Sat, 2014-03-22 at 09:37 -0700, Behan Webster wrote:
>> On 03/22/14 09:29, James Bottomley wrote:
>>> On Sat, 2014-03-22 at 08:48 -0700, behanw@converseincode.com wrote:
>>>> From: Behan Webster <behanw@converseincode.com>
>>>>
>>>> Fix uninitialized return code in default case in cmpxchg-local.h
>>>>
>>>> This patch fixes the code to prevent an uninitialized return value that is detected
>>>> when compiling with clang. The bug produces numerous warnings when compiling the
>>>> Linux kernel with clang.
>>>>
>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>>>> ---
>>>>    include/asm-generic/cmpxchg-local.h | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
>>>> index d8d4c89..9112111 100644
>>>> --- a/include/asm-generic/cmpxchg-local.h
>>>> +++ b/include/asm-generic/cmpxchg-local.h
>>>> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
>>>>    		break;
>>>>    	default:
>>>>    		wrong_size_cmpxchg(ptr);
>>>> +		__builtin_unreachable();
>>> No, that's got to be unreachable() so that it works in all compilers,
>>> (__builtin_unreachable is a gcc-4 ism).
>> It is also supported by clang.
> OK, but it's not supported by gcc-3.  So gcc-3 would crap out seeing the
> statement, which is why we have to wrapper it.
Sorry. I wasn't clear. It is not merely a gcc-4 ism; it is also 
supported by clang.

I'm not arguing it should be used. I understand (and agree with) your 
objection to its use since it isn't supported before gcc-4.

>>> Got to say this still looks wrong.  If wrong_size_cmpxchg() cannot
>>> return, the function should be annotated as such with __noreturn (like
>>> panic()) so the unreachable() should be superfluous.
>> Okay. I can try that instead.
> Great; This seems to work for me (but then my compiler doesn't see the
> unreachable problem).
>
> James
>
> ---
> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
> index d8d4c89..70bef78 100644
> --- a/include/asm-generic/cmpxchg-local.h
> +++ b/include/asm-generic/cmpxchg-local.h
> @@ -4,7 +4,8 @@
>   #include <linux/types.h>
>   #include <linux/irqflags.h>
>   
> -extern unsigned long wrong_size_cmpxchg(volatile void *ptr);
> +extern unsigned long wrong_size_cmpxchg(volatile void *ptr)
> +	__noreturn;
>   
>   /*
>    * Generic version of __cmpxchg_local (disables interrupts). Takes an unsigned
Nice. I'll give it a try. It looks like a much better solution.

Behan

-- 
Behan Webster
behanw@converseincode.com

