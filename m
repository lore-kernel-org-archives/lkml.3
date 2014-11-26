Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaKZOhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:37:51 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:61457 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaKZOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:37:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141125222556.GA7712@sirena.org.uk>
References: <1416853893-1993-1-git-send-email-andrew.smirnov@gmail.com>
	<20141125124229.GY7712@sirena.org.uk>
	<CAHQ1cqGvDft1t5MkaqT-xsfBygdghA3mK_a7x+Z3L6HtvqrwhA@mail.gmail.com>
	<20141125134048.GE7712@sirena.org.uk>
	<CAHQ1cqHSdV4XTxwnPYfdBK8mVYQk9O3akynSM_hUGmVDMRU3FA@mail.gmail.com>
	<20141125222556.GA7712@sirena.org.uk>
Date: Wed, 26 Nov 2014 06:37:47 -0800
Message-ID: <CAHQ1cqHc8SRePFktaEtH33YLTQPhCS0vnh2YQ1S+xQc1AHAV4g@mail.gmail.com>
Subject: Re: [RFC, PATCH, RESEND] spi, spidev: Add support for long SPI transfers
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Andrey Yurovsky <yurovsky@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> OK, I think I use too generic terms and descriptions and maybe that's
>> why it is not very clear what I mean. Just to give more context I am
>> working with i.MX6 SPI peripheral, and AFAIK I have two options of
>> using it:
>
> Ah, i.MX...  When I've worked with it I managed the chip select with
> GPIO since it was flipping the chip select per word.

Yep, that's pretty much what I am observing, except now the size of
the "word" is configurable.

>
>> - Use a generic GPIO as SS/CS. This way everything works exactly as
>> you describe, but unfortunately using GPIO leads to a significant
>> overhead for SS/CS assertion/deassertion.
>
> It's really surprising that it's expensive to use a GPIO, I've not seen
> other users complaining about that.  Do we understand why (I'm guessing
> you have some extremely performance sensitive application here so you're
> just more picky than most)?

Yeah, I agree, I have a niche use case and just happen to be more
picky because of that. I have a rather slow clock (8Mhz out of
potential 20Mhz) that is out of my control; rather verbose protocol
which has 32bits+ of overhead per 32bit of data with fixed transaction
length of 64bits(so I get a lot of small equally sized transactions);
sizeable chunk of data to transfer 4K of 32bit words. On top of that
the system needs to do those 4K transfers as fast as possible so my
timing requirements are very severe as well.

>
>> - Use hardware controlled SS/CS in which case peripheral toggles the
>> line every "burst" it transmits, "burst" is n bits where n can be from
>> 1 to 2^12
>>  For 1 <= n <= 32, and software SS/CS the concept of a "burst" matches
>> the meaning of "bits_per_word" field and this is exactly how it is
>> setup in the driver.
>
> But if we go over 32 bits it doesn't do the byte swapping?

*Sigh* It's FIFO is little endian as well so it does do byte swapping.

> Hardware designers are wonderful, creative people sometimes.  In general this
> isn't going to be sufficient for all transfers even with the non swapped
> case since it means we can't do more than one transfer per message
> unless we start coalescing in the core and putting in dummies for cases
> where transfers change (we should do these things, they're a win in
> general since we can just set the message up and let the hardware do the
> transfer, but it's not completely trivial).
>
>> So with all of this in mind what I am trying to achive is to have
>> longest transaction with minimal CS/SS switching overhead. The change
>> in my patch allows me to set the length of a burst to its limit.
>
> The driver should probably just be doing that where it can, it seems
> like the burst size should be based on the transfer length not the word
> size - we might need to just manually mangle the data for short
> transfers.

Yeah, I thought about this idea yesterday as well. I agree this is
probably the right way to solve this. I'll have my hack as a temporary
kludge and will try to improve the driver in the mean time.

Thank you for you input and please ignore the patch that I sent.

Andrey
