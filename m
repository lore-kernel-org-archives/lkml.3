Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaAHPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:01:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60431 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaAHPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:01:30 -0500
Message-ID: <52CD6849.4050007@gmail.com>
Date: Wed, 08 Jan 2014 23:01:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggest] arch: metag: compiler: Are they compiler's issues?
References: <52B8F33C.3030808@gmail.com> <52CA85FF.8050604@imgtec.com>
In-Reply-To: <52CA85FF.8050604@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 06:31 PM, James Hogan wrote:
> On 24/12/13 02:36, Chen Gang wrote:
>> Helllo Maintainers:
>>
>> When compile metag with allmodconfig, I met the 2 kinds of issues, I
>> guess they are compiler's issues, please help check, thanks.
>>
>>
>> Issue 1: compiler report the issue, but after check the related kernel
>> source code, I can not find any issues.
>>
>>     CC [M]  drivers/isdn/hisax/s0box.o
>>   drivers/isdn/hisax/hscx_irq.c: In function 'hscx_fill_fifo':
>>   /upstream/linux-next/arch/metag/include/asm/io.h:62: error: 'asm' operand requires impossible reload
>>   make[3]: *** [drivers/isdn/hisax/s0box.o] Error 1
>>   make[2]: *** [drivers/isdn/hisax] Error 2
>>   make[1]: *** [drivers/isdn] Error 2
>>   make: *** [drivers] Error 2
> 
> This was a compiler bug in an old version of the toolchain.
> What does metag-linux-gcc -v give you?
> It should be "gcc version 4.2.4 (IMG-1.4.0.700)"
> 

OK, thanks, and the gcc version is below:

[root@gchen ~]# /usr/bin/metag-buildroot-linux-uclibc-gcc -v
Using built-in specs.
Target: metag-buildroot-linux-uclibc
Configured with: /upstream/src/metag/metag-core-2013.11/output/toolchain/gcc-4.2.4/configure --prefix=/upstream/src/metag/metag-core-2013.11/output/host/usr --build=x86_64-unknown-linux-gnu --host=x86_64-unknown-linux-gnu --target=metag-buildroot-linux-uclibc --enable-languages=c --with-sysroot=/upstream/src/metag/metag-core-2013.11/output/host/usr/metag-buildroot-linux-uclibc/sysroot --with-build-time-tools=/upstream/src/metag/metag-core-2013.11/output/host/usr/metag-buildroot-linux-uclibc/bin --disable-__cxa_atexit --enable-target-optspace --disable-libgomp --with-gnu-ld --disable-libssp --disable-multilib --enable-tls --enable-shared --with-gmp=/upstream/src/metag/metag-core-2013.11/output/host/usr --with-mpfr=/upstream/src/metag/metag-core-2013.11/output/host/usr --disable-nls --enable-threads --with-cpu=2.1 --enable-meta-default --disable-symvers
Thread model: posix
gcc version 4.2.4 (IMG-1.4.0.300)


>> Issue 2: they are about structure variables alignment, I guess, the
>> compiler can not notice about the "#pragma pack()" correctly.
>>
>>     CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
>>   drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
>>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
>>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
>>   make[5]: *** [drivers/staging/lustre/lustre/lov/lov_pack.o] Error 1
>>   make[4]: *** [drivers/staging/lustre/lustre/lov] Error 2
>>   make[3]: *** [drivers/staging/lustre/lustre] Error 2
>>   make[2]: *** [drivers/staging/lustre] Error 2
>>   make[1]: *** [drivers/staging] Error 2
>>   make: *** [drivers] Error 2
>>
>>     MODPOST 2909 modules
>>   ERROR: "__compiletime_assert_426" [net/batman-adv/batman-adv.ko] undefined!
>>   ERROR: "__compiletime_assert_429" [net/batman-adv/batman-adv.ko] undefined!
>>   ERROR: "__compiletime_assert_425" [net/batman-adv/batman-adv.ko] undefined!
>>   ERROR: "__compiletime_assert_428" [net/batman-adv/batman-adv.ko] undefined!
>>   ERROR: "__compiletime_assert_427" [net/batman-adv/batman-adv.ko] undefined!
>>   ERROR: "__compiletime_assert_430" [net/batman-adv/batman-adv.ko] undefined!
> 
> I suspect this is due to bad assumptions in the code. The metag ABI is
> unusual in padding the size of structs to a 32bit boundary even if all
> members are <32bit. This is actually permitted by the C standard but
> it's a bit of a pain. e.g.
> 
> struct s {
> 	short x
> 	struct {
> 		short x[3];
> 	} y;
> 	short z;
> };
> 
> on x86
> 	alignof(s::y) == 2
> 	s::y at offset 2
> 	sizeof(s::y) == 6
> 	s::z at offset 6+2 = 8
> 	sizeof(struct s) == 10
> 
> but on metag
> 	alignof(s::y) == 4
> 	s::y at offset 4
> 	sizeof(s::y) == 8 (padding, this is what catches people out)
> 	s::z at offset 4+8 = 12
> 	sizeof(struct s) == 16 (and here too)
> 
> Adding packed attribute on outer struct reduces sizeof(struct s) to 12
> on metag:
> 	alignof(s::y) == 4
> 	s::y at offset 2 (packed)
> 	sizeof(s::y) == 8 (still padded)

In my memory, when packed(2), it breaks the C standard (although I am
not quit sure).

And I guess, all C programmers will assume it will be 6 when within
pack(2) or pack(1).

> 	s::z at offset 2+8 = 10
> 	sizeof(struct s) == 12 (packed)
> 
> Also reduced to 12 if only inner struct is marked packed:
> 	alignof(s::y) == 2
> 	s::y at offset 2
> 	sizeof(s::y) == 6 (packed)
> 	s::z at offset 2+6 = 8
> 	sizeof(struct s) == 12 (still padded)
> 
> Adding packed attribute on both outer and inner struct reduces
> sizeof(struct s) to 10 to match x86.
> 
> Unfortunately it's years too late to change this ABI, so we're stuck
> with it.
> 

Unfortunately too, most using cases are related with API (the related
structure definition must be the same in binary data).

I am sure there are still another ways to bypass this issue, but that
will make the code looks very strange (especially they are API).

:-(

>>
>>
>> Making cross-compiler:
>>
>>   git clone git://github.com/img-meta/metag-buildroot.git metag-core-2013.11
>>   make meta2_defconfig.
> 
> That loads the meta2_defconfig. Did you rebuild it? If in doubt you can
> always "rm -fr output" and re-make.
> 

Yeah, I had done, and no doubt to me.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
