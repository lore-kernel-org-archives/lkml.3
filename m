Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaLDHXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:23:42 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57269 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLDHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:23:41 -0500
Date: Thu, 4 Dec 2014 02:23:37 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
In-Reply-To: <3913269.qTFsa05Ysv@wuerfel>
Message-ID: <alpine.LFD.2.11.1412040143260.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> <3913269.qTFsa05Ysv@wuerfel>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Arnd Bergmann wrote:

> On Wednesday 03 December 2014 14:43:06 Nicolas Pitre wrote:
> > At least on ARM, do_div() is optimized to turn constant divisors into
> > an inline multiplication by the reciprocal value at compile time. 
> > However this optimization is missed entirely whenever ktime_divns() is
> > used and the slow out-of-line division code is used all the time.
> > 
> > Let ktime_divns() use do_div() inline whenever the divisor is constant
> > and small enough.  This will make things like ktime_to_us() and 
> > ktime_to_ms() much faster.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> 
> Very cool. I've been thinking about doing something similar for the
> general case but couldn't get the math to work.
> 
> Can you think of an architecture-independent way to ktime_to_sec,
> ktime_to_ms, and ktime_to_us efficiently based on what you did for
> the ARM do_div implementation?

Sure.  gcc generates rather shitty code on ARM compared to the output 
from my do_div() implementation. But here it is:

u64 ktime_to_us(ktime_t kt)
{
	u64 ns = ktime_to_ns(kt);
	u32 x_lo, x_hi, y_lo, y_hi;
	u64 res, carry;

	x_hi = ns >> 32;
	x_lo = ns;
	y_hi = 0x83126e97;
	y_lo = 0x8d4fdf3b;

	res = (u64)x_lo * y_lo;
	carry = (u64)(u32)res + y_lo;
	res = (res >> 32) + (carry >> 32);

	res += (u64)x_lo * y_hi;
	carry = (u64)(u32)res + (u64)x_hi * y_lo;
	res = (res >> 32) + (carry >> 32);

	res += (u64)x_hi * y_hi;
	return res >> 9;
}

For ktime_to_ms() the constants would be as follows:

	y_hi = 0x8637bd05;
	y_lo = 0xaf6c69b5;
	final shift = 19

For ktime_to_sec() that would be:

	y_hi = 0x89705f41;
	y_lo = 0x36b4a597;
	final shift = 29


Nicolas
