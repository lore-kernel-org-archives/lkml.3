Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaAFKbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:31:31 -0500
Received: from multi.imgtec.com ([194.200.65.239]:42294 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaAFKba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:31:30 -0500
Message-ID: <52CA85FF.8050604@imgtec.com>
Date: Mon, 6 Jan 2014 10:31:27 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <linux-metag@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggest] arch: metag: compiler: Are they compiler's issues?
References: <52B8F33C.3030808@gmail.com>
In-Reply-To: <52B8F33C.3030808@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_06_10_31_28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/12/13 02:36, Chen Gang wrote:
> Helllo Maintainers:
> 
> When compile metag with allmodconfig, I met the 2 kinds of issues, I
> guess they are compiler's issues, please help check, thanks.
> 
> 
> Issue 1: compiler report the issue, but after check the related kernel
> source code, I can not find any issues.
> 
>     CC [M]  drivers/isdn/hisax/s0box.o
>   drivers/isdn/hisax/hscx_irq.c: In function 'hscx_fill_fifo':
>   /upstream/linux-next/arch/metag/include/asm/io.h:62: error: 'asm' operand requires impossible reload
>   make[3]: *** [drivers/isdn/hisax/s0box.o] Error 1
>   make[2]: *** [drivers/isdn/hisax] Error 2
>   make[1]: *** [drivers/isdn] Error 2
>   make: *** [drivers] Error 2

This was a compiler bug in an old version of the toolchain.
What does metag-linux-gcc -v give you?
It should be "gcc version 4.2.4 (IMG-1.4.0.700)"

> Issue 2: they are about structure variables alignment, I guess, the
> compiler can not notice about the "#pragma pack()" correctly.
> 
>     CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
>   drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
>   make[5]: *** [drivers/staging/lustre/lustre/lov/lov_pack.o] Error 1
>   make[4]: *** [drivers/staging/lustre/lustre/lov] Error 2
>   make[3]: *** [drivers/staging/lustre/lustre] Error 2
>   make[2]: *** [drivers/staging/lustre] Error 2
>   make[1]: *** [drivers/staging] Error 2
>   make: *** [drivers] Error 2
> 
>     MODPOST 2909 modules
>   ERROR: "__compiletime_assert_426" [net/batman-adv/batman-adv.ko] undefined!
>   ERROR: "__compiletime_assert_429" [net/batman-adv/batman-adv.ko] undefined!
>   ERROR: "__compiletime_assert_425" [net/batman-adv/batman-adv.ko] undefined!
>   ERROR: "__compiletime_assert_428" [net/batman-adv/batman-adv.ko] undefined!
>   ERROR: "__compiletime_assert_427" [net/batman-adv/batman-adv.ko] undefined!
>   ERROR: "__compiletime_assert_430" [net/batman-adv/batman-adv.ko] undefined!

I suspect this is due to bad assumptions in the code. The metag ABI is
unusual in padding the size of structs to a 32bit boundary even if all
members are <32bit. This is actually permitted by the C standard but
it's a bit of a pain. e.g.

struct s {
	short x
	struct {
		short x[3];
	} y;
	short z;
};

on x86
	alignof(s::y) == 2
	s::y at offset 2
	sizeof(s::y) == 6
	s::z at offset 6+2 = 8
	sizeof(struct s) == 10

but on metag
	alignof(s::y) == 4
	s::y at offset 4
	sizeof(s::y) == 8 (padding, this is what catches people out)
	s::z at offset 4+8 = 12
	sizeof(struct s) == 16 (and here too)

Adding packed attribute on outer struct reduces sizeof(struct s) to 12
on metag:
	alignof(s::y) == 4
	s::y at offset 2 (packed)
	sizeof(s::y) == 8 (still padded)
	s::z at offset 2+8 = 10
	sizeof(struct s) == 12 (packed)

Also reduced to 12 if only inner struct is marked packed:
	alignof(s::y) == 2
	s::y at offset 2
	sizeof(s::y) == 6 (packed)
	s::z at offset 2+6 = 8
	sizeof(struct s) == 12 (still padded)

Adding packed attribute on both outer and inner struct reduces
sizeof(struct s) to 10 to match x86.

Unfortunately it's years too late to change this ABI, so we're stuck
with it.

> 
> 
> Making cross-compiler:
> 
>   git clone git://github.com/img-meta/metag-buildroot.git metag-core-2013.11
>   make meta2_defconfig.

That loads the meta2_defconfig. Did you rebuild it? If in doubt you can
always "rm -fr output" and re-make.

Cheers
James

>   "cd metag-core-2013.11; cp -r output/host/usr/* /usr/"
> 
> 
> Welcome any additional suggestions, discussions or completions.
> 
> Thanks.
> 

