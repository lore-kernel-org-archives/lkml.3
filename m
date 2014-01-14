Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaANTW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:22:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58665 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaANTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:22:24 -0500
Message-ID: <52D58E6F.4050000@gmail.com>
Date: Tue, 14 Jan 2014 14:22:23 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: netdev@vger.kernel.org, dborkman@redhat.com, linux-kernel@vger.kernel.org,
        darkjames-ws@darkjames.pl
Subject: Re: [PATCH RFC] reciprocal_divide: correction/update of the algorithm
References: <20140113214249.GK6586@order.stressinduktion.org> <1389722825.31367.260.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1389722825.31367.260.camel@edumazet-glaptop2.roam.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-14 13:07, Eric Dumazet wrote:
> On Mon, 2014-01-13 at 22:42 +0100, Hannes Frederic Sowa wrote:
>> This patch is a RFC and part of a series Daniel Borkmann and me want to
>> do when introducing prandom_u32_range{,_ro} and prandom_u32_max{,_ro}
>> helpers later this week.
> 
>> -static inline u32 reciprocal_divide(u32 A, u32 R)
>> +struct reciprocal_value reciprocal_value(u32 d);
>> +
>> +static inline u32 reciprocal_divide(u32 a, struct reciprocal_value R)
>>  {
>> -	return (u32)(((u64)A * R) >> 32);
>> +	u32 t = (u32)(((u64)a * R.m) >> 32);
>> +	return (t + ((a - t) >> R.sh1)) >> R.sh2;
>>  }
> 
> I would rather introduce new helpers and convert users that really need
> them.
> 
> For instance, just use a divide in BPF, because doing this on JIT might
> be too complex for the gains. Strangely, libpcap doesn't seem to
> optimize any divide, like divides by a power of two...
> 
> Reciprocal were added 7 years ago, for very specific uses, but current
> cpus have reasonably fast dividers.

I disagree with the statement that current CPU's have reasonably fast
dividers.  A lot of embedded processors and many low-end x86 CPU's do
not in-fact have any hardware divider, and usually provide it using
microcode based emulation if they provide it at all.  The AMD Jaguar
micro-architecture in particular comes to mind, it uses an iterative
division algorithm provided by the microcode that only produces 2 bits
of quotient per cycle, even in the best case (2 8-bit integers and an
integral 8-bit quotient) this still takes 4 cycles, which is twice as
slow as any other math operation on the same processor.

