Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbaLEEaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:30:14 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:60402 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361AbaLEEaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:30:12 -0500
Date: Thu, 4 Dec 2014 23:30:08 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: pang.xunlei@zte.com.cn
cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kernel-owner@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] optimize ktime_divns for constant divisors
In-Reply-To: <OF0EDEDB1C.C03829F7-ON48257DA5.00062083-48257DA5.0007628B@zte.com.cn>
Message-ID: <alpine.LFD.2.11.1412042056240.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> <3913269.qTFsa05Ysv@wuerfel> <alpine.LFD.2.11.1412040143260.470@knanqh.ubzr> <OF0EDEDB1C.C03829F7-ON48257DA5.00062083-48257DA5.0007628B@zte.com.cn>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014, pang.xunlei@zte.com.cn wrote:

> Nicolas,
> 
> On Thursday 04 December 2014 15:23:37: Nicolas Pitre wrote:
> > Nicolas Pitre <nicolas.pitre@linaro.org> 
> > 
> > u64 ktime_to_us(ktime_t kt)
> > {
> >    u64 ns = ktime_to_ns(kt);
> >    u32 x_lo, x_hi, y_lo, y_hi;
> >    u64 res, carry;
> > 
> >    x_hi = ns >> 32;
> >    x_lo = ns;
> >    y_hi = 0x83126e97;
> >    y_lo = 0x8d4fdf3b;
> > 
> >    res = (u64)x_lo * y_lo;
> >    carry = (u64)(u32)res + y_lo;
> >    res = (res >> 32) + (carry >> 32);
> > 
> >    res += (u64)x_lo * y_hi;
> >    carry = (u64)(u32)res + (u64)x_hi * y_lo;
> >    res = (res >> 32) + (carry >> 32);
> > 
> >    res += (u64)x_hi * y_hi;
> >    return res >> 9;
> > }
> 
> What's the first carry operation for?

Hmmm... OK there is a bug.

The code should actually be:

	res = (u64)x_lo * y_lo;
	carry = (u64)(u32)res + y_lo;
	res = (res >> 32) + (carry >> 32) + y_hi;

(the addition of y_hi was missing on the third line of the above block)

The equation is: res = (y + x*y) >> 9

> Moreover, I think the carry operations can be omitted, like below:
> u64 ktime_to_us(ktime_t kt)
> {
>          u64 ns = ktime_to_ns(kt);
>          u32 x_lo, x_hi, y_lo, y_hi;
>          u64 res;
> 
>          x_hi = ns >> 32;
>          x_lo = ns;
>          y_hi = 0x83126e97;
>          y_lo = 0x8d4fdf3b;
> 
>          res = (u64)x_lo * y_lo;
>          res = (res >> 32);

See above. y must be added to res before shifting, and that may cause an 
overflow.

>          res += (u64)x_lo * y_hi + (u64)x_hi * y_lo;

That, too, risk overflowing.

Let's say x_lo = 0xffffffff and x_hi = 0xffffffff.  You get:

	0xffffffff * 0x83126e97 ->  0x83126e967ced9169
	0xffffffff * 0x8d4fdf3b ->  0x8d4fdf3a72b020c5
	                           -------------------
	                           0x110624dd0ef9db22e

Therefore the sum doesn't fit into a u64 variable.

It is possible to skip carry handling but only when the MSB of both 
constants are zero.  Here it is not the case.

>          res = (res >> 32);
> 
>          res += (u64)x_hi * y_hi;
> 
>          return res >> 9;
> }
> 
> Also, I ran this code using ktime "122500000000", and it results as
> 122499999 due to the y_lo deviation,

Please see bug fix above.

> maybe can use 0x8d4fdf3c instead?

No, that won't work with 0xfffffffffffffd97 for example.


Nicolas
