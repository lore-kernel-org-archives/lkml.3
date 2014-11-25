Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaKYVSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:18:49 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33443 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaKYVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:18:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141125134048.GE7712@sirena.org.uk>
References: <1416853893-1993-1-git-send-email-andrew.smirnov@gmail.com>
	<20141125124229.GY7712@sirena.org.uk>
	<CAHQ1cqGvDft1t5MkaqT-xsfBygdghA3mK_a7x+Z3L6HtvqrwhA@mail.gmail.com>
	<20141125134048.GE7712@sirena.org.uk>
Date: Tue, 25 Nov 2014 13:18:45 -0800
Message-ID: <CAHQ1cqHSdV4XTxwnPYfdBK8mVYQk9O3akynSM_hUGmVDMRU3FA@mail.gmail.com>
Subject: Re: [RFC, PATCH, RESEND] spi, spidev: Add support for long SPI transfers
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Andrey Yurovsky <yurovsky@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> A spi_message (which is the thing that covers the entire /CS assert
> modulo non-standard fiddling) is composed of multiple spi_transfers
> so the above still applies...
>

You are correct, I think I was confused because the driver I was
working with didn't seem to implement it this way for hardware CS
case.

>
> No it doesn't, chip select can frequently be manipulated independently of
> data transfers and almost all controllers can support transfers much
> longer than their FIFOs either by doing that or by keeping the FIFO
> topped up during transfer.

You are correct, I reread the datasheet and even from my niche use
case FIFO depth is irrelevant. I apologize.

>
>> in my wording of the summary and not use the word "transfer" anywhere,
>> but it looks like I slipped twice and that might have contributed to
>> this confusion. I apologize for this and hope that my comments
>> clarified my meaning/intent
>
> Sorry it's still not at all clear, please re-read what I wrote about
> what bits_per_word means since I really don't think you've understood
> what it's for.

OK, I think I use too generic terms and descriptions and maybe that's
why it is not very clear what I mean. Just to give more context I am
working with i.MX6 SPI peripheral, and AFAIK I have two options of
using it:

- Use a generic GPIO as SS/CS. This way everything works exactly as
you describe, but unfortunately using GPIO leads to a significant
overhead for SS/CS assertion/deassertion.

- Use hardware controlled SS/CS in which case peripheral toggles the
line every "burst" it transmits, "burst" is n bits where n can be from
1 to 2^12
 For 1 <= n <= 32, and software SS/CS the concept of a "burst" matches
the meaning of "bits_per_word" field and this is exactly how it is
setup in the driver.

So with all of this in mind what I am trying to achive is to have
longest transaction with minimal CS/SS switching overhead. The change
in my patch allows me to set the length of a burst to its limit.

Andrey
