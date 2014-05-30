Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaE3JAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:00:21 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:46154 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaE3JAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:00:12 -0400
MIME-Version: 1.0
In-Reply-To: <5387DF42.5020506@codeaurora.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org>
	<537FD9A7.3010100@codeaurora.org>
	<5385EB42.1060604@linaro.org>
	<CACRpkdb_ozxL3wAVf7FJr-0A2tWGHkfXeXf5sWaW6h_yzK4QvA@mail.gmail.com>
	<5387DF42.5020506@codeaurora.org>
Date: Fri, 30 May 2014 11:00:11 +0200
Message-ID: <CACRpkdaEEYYfE8adDKjU7j4onnExQD2z3S+DOh5KnrKhNOHW9Q@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 3:30 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Hm... that doesn't sound right. Please see this thread on lkml[1], and
> also this video from Ben H.[2]

But Benji is talking about the *PCI BUS*, and this is raw register
access. He just says that "This is how a BE CPU is normally
wired to a LE bus" we have no idea whether that is actually the
case on any existing system with this peripheral. Such things
have to be tested.

> My understanding is that this is a fifo
> so I would think we want to use the ioread32_rep() function here (or
> other "string" io functionality). Otherwise we're going to byteswap the
> data that we're trying to interpret as a buffer and big endian CPUs
> won't work.

You don't know that until you have tested on real BE ARM
hardware with this PrimeCell. How do you know the SoC
designers will have been smart enough to insert byte swap
logic?

>> You are right. readsl() or ioread32_rep() isn't used for this reason.
>
> We could always use a size of 1 right?

What do you mean? Do you mean using:

ioread32_rep(io, buf, 1)?

Notice this is totally equivalent to readsl() in arm/include/asm/io.h:

#define readsl(p,d,l)           __raw_readsl(p,d,l)
#define ioread32_rep(p,d,c)     __raw_readsl(p,d,c)

The semantic effect is switching from readl() -> readsl() or
conversely ioread32 -> ioread32_rep() which will use
__raw accessors in native endianness rather than LE access.

Which is what you want if the bus will do byte swapping. Which
we don't know if it does, because noone has such a system and
can verify.

If the native bus is not byte swapping this will just force you to
use cpu_to_le32() on the result. That is not helpful at all.

We need to experiment with real BE hardware with this
PrimeCell to determine whether to do this, and until that is
done just don't try to outsmart the hardware by thinking ahead
and designing for the unknown, that will just fail.

Yours,
Linus Walleij
