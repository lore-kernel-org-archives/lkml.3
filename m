Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaLEKIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:08:25 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:63714 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLEKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:08:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, pang.xunlei@zte.com.cn,
        linux-kernel-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
Date: Fri, 05 Dec 2014 11:08:07 +0100
Message-ID: <2145860.PBxl6kLNRF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1412042056240.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> <OF0EDEDB1C.C03829F7-ON48257DA5.00062083-48257DA5.0007628B@zte.com.cn> <alpine.LFD.2.11.1412042056240.470@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:5rzO/0X298gtlfrp3O35IN/iNR+aPHENUBVBgqhQ9i+vGxhiiiC
 bbw2x+OjxuwJjrQwedBECxAbhOfoyfmScY6AaQsvNn4Rx7Rec576JiUf9LVSImoMWsfZePG
 R9wd2RYhVXkITU9MUaO5qf7q9ASK7WTUgEcpT412X7yxL2AgvcYzJX5ADlTt4MEHrfRJv1F
 WuzGqsxqhGiHD5mX0X+6w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 23:30:08 Nicolas Pitre wrote:
> >          res += (u64)x_lo * y_hi + (u64)x_hi * y_lo;
> 
> That, too, risk overflowing.
> 
> Let's say x_lo = 0xffffffff and x_hi = 0xffffffff.  You get:
> 
>         0xffffffff * 0x83126e97 ->  0x83126e967ced9169
>         0xffffffff * 0x8d4fdf3b ->  0x8d4fdf3a72b020c5
>                                    -------------------
>                                    0x110624dd0ef9db22e
> 
> Therefore the sum doesn't fit into a u64 variable.
> 
> It is possible to skip carry handling but only when the MSB of both 
> constants are zero.  Here it is not the case.

If I understand this right, there are two possible optimizations to
avoid the overflow:

- for anything using monotonic time, or elapsed time, we can guarantee
  that the upper bits are zero. Relying on monotonic time is a bit
  dangerous, because that would mean introducing an API that works
  with ktime_get() but not ktime_get_real(), and risk introducing
  subtle bugs.
  However, ktime_us_delta() could be optimized, and we can introduce
  similar ktime_sec_delta() and ktime_ms_delta() functions with
  the same properties.

- one could always pre-shift the ktime_t value. For a division by
  1000, we can shift right by 3 bits first, then do the multiplication
  and then do another shift. Not sure if that helps at all or if
  the extra shift operation makes this counterproductive.

	Arnd
