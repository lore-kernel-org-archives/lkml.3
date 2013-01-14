Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3ANAFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 19:05:01 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:44572 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3ANAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 19:04:59 -0500
MIME-Version: 1.0
In-Reply-To: <50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
	<50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Mon, 14 Jan 2013 01:04:58 +0100
Message-ID: <CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, chanho0207@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 7:50 AM, Chanho Min <chanho.min@lge.com> wrote:

> We tested as follows:
> We set baud rate to 3Mbps and transfer 5000 bytes via /dev/tty at
> a time. Then 4096 bytes is received by DMA irq. But, There is no way
> to get remaining 904 bytes, unless another 3192 bytes are coming,

OK clearly cut phenomena: IRQs seem to appear from the
PL080 TC (transfer complete) IRQ only, not from any of the
PL011 IRQs.

So there will be zero IRQs from the uart in /proc/interrupts
but a few of them from the PL080, correct?

>>- What DMA controller are you using with the
>>  PL011?
>
> PL080.
> We don't add any customized configuration from the mainline.

OK sorry I was thinking of the old times when we has
.cctl configured from the platform.

>> - If they cannot be software-configured, how are
>>   they then configured in hardware? Burst-only?
>> Burst single
>
> As far as I know, single request is not disabled at PL080.
> Could you explain what single request has to do with this?

At some point we reasoned that we may actually be saved
by the reverse phenomena - if single request is *NOT*
connected, there will very often be some characters in the
FIFO, and that's enough to trigger the RTIM IRQ, and we get
a nice flow. So maybe the platforms that actually work, work
because they have bursts only.

But that would pose a problem when an even burst of
characters arrive. Say 16 characters, this will be transferred
in two bursts and leave the FIFO empty, but no DMA TC
IRQ since the buffer is not full, and we'd get your
phenomena.

But I could never reproduce the latter theoretical problem,
so I think the hardware actually has a fix for this, around
the burst signal logic.

But it may very well be that the single request can not be
enabled for the PL011 for it to work properly.

You may not be able to turn this off, and in that case this
kind of code is the only way forward indeed.

Yours,
Linus Walleij
