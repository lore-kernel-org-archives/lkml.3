Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaFQKRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:17:44 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56829 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaFQKRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:17:43 -0400
Message-ID: <53A015B3.2070809@linaro.org>
Date: Tue, 17 Jun 2014 11:17:23 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rob Clark <robdclark@gmail.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3] ARM: add get_user() support for 8 byte types
References: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org> <20140612155843.GK23430@n2100.arm.linux.org.uk>
In-Reply-To: <20140612155843.GK23430@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/14 16:58, Russell King - ARM Linux wrote:
> On Thu, Jun 12, 2014 at 04:42:35PM +0100, Daniel Thompson wrote:
>> A new atomic modeset/pageflip ioctl being developed in DRM requires
>> get_user() to work for 64bit types (in addition to just put_user()).
>>
>> v1: original
>> v2: pass correct size to check_uaccess, and better handling of narrowing
>>     double word read with __get_user_xb() (Russell King's suggestion)
>> v3: fix a couple of checkpatch issues
> 
> This is still unsafe.
> 
>>  #define __get_user_check(x,p)							\
>>  	({								\
>>  		unsigned long __limit = current_thread_info()->addr_limit - 1; \
>>  		register const typeof(*(p)) __user *__p asm("r0") = (p);\
>> -		register unsigned long __r2 asm("r2");			\
>> +		register typeof(x) __r2 asm("r2");			\
> 
> So, __r2 becomes the type of 'x'.  If 'x' is a 64-bit type, and *p is
> an 8-bit, 16-bit, or 32-bit type, this fails horribly by leaving the
> upper word of __r2 undefined.

It is true that at after the switch statement the contents of r3 are
undefined. However...


>  		register unsigned long __l asm("r1") = __limit; \
>  		register int __e asm("r0");			\
>  		switch (sizeof(*(__p))) {			\
> @@ -142,6 +152,12 @@ extern int __get_user_4(void *);
>  		case 4:						\
>  			__get_user_x(__r2, __p, __e, __l, 4);	\
>  			break;					\
> +		case 8:						\
> +			if (sizeof((x)) < 8)			\
> +				__get_user_xb(__r2, __p, __e, __l, 4);\
> +			else					\
> +				__get_user_x(__r2, __p, __e, __l, 8);\
> +			break;					\
>  		default: __e = __get_user_bad(); break;		\
>  		}						\
>  		x = (typeof(*(p))) __r2;			\

... at this point there is a narrowing cast followed by an implicit
widening. This results in compiler either ignoring r3 altogether or, if
spilling to the stack, generating code to set r3 to zero before doing
the store.

I think this approach also makes 8-bit and 16-bit get_user() faster in
some cases where the type of *p and x are similar 8- or 16-bit types.
This is because the compiler will never generate a redundant narrowings.

Note that the speed improvement looks extremely marginal; the size of
the .text section (for a multi_v7_defconfig kernel) only gets 96 bytes
smaller (a.k.a. 0.0015%).


Daniel.
