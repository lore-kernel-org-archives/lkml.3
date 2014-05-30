Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaE3Baq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:30:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32984 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaE3Bao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:30:44 -0400
Message-ID: <5387DF42.5020506@codeaurora.org>
Date: Thu, 29 May 2014 18:30:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org> <1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org> <537FD9A7.3010100@codeaurora.org> <5385EB42.1060604@linaro.org> <CACRpkdb_ozxL3wAVf7FJr-0A2tWGHkfXeXf5sWaW6h_yzK4QvA@mail.gmail.com>
In-Reply-To: <CACRpkdb_ozxL3wAVf7FJr-0A2tWGHkfXeXf5sWaW6h_yzK4QvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/14 00:43, Linus Walleij wrote:
> On Wed, May 28, 2014 at 3:57 PM, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>
>>> This doesn't look endianness agnostic. Shouldn't we use ioread32_rep()
>>> to read this fifo?
>> Is'nt readl endianess aware?
> At least once a year read through arch/arm/include/asm/io.h
>
> static inline u32 __raw_readl(const volatile void __iomem *addr)
> {
>         u32 val;
>         asm volatile("ldr %1, %0"
>                      : "+Qo" (*(volatile u32 __force *)addr),
>                        "=r" (val));
>         return val;
> }
> (...)
> #define readl_relaxed(c) ({ u32 __r = le32_to_cpu((__force __le32) \
>                                         __raw_readl(c)); __r; })
> (...)
> #define readl(c)                ({ u32 __v = readl_relaxed(c);
> __iormb(); __v; })
>
> readl() reads in little endian.
>
> All PrimeCells are little endian, trouble would occur if and only if
> this cell was
> used on a big endian CPU, like an ARM used in BE mode, if the macros
> didn't look exactly like this.
>
> Thanks to the fact that readl() is always LE things work smoothly.
>
> Then to the question whether to use ioread32() instead:
>
> #define ioread32(p)     ({ unsigned int __v = le32_to_cpu((__force
> __le32)__raw_readl(p)); __iormb(); __v; })
>
> Same thing as readl(). The only reason to use ioread32() rather than
> readl() is that some archs do not support readl() but only ioread32().
> However for that to be a problem, these archs must be utilizing that
> primecell! And if they do there are two ways to solve it: either change
> the entire world to use ioread/write32 or simply just define readl() and
> friends for that arch in its io.h file.
>
> I'd say don't touch it right now.

Hm... that doesn't sound right. Please see this thread on lkml[1], and
also this video from Ben H.[2] My understanding is that this is a fifo
so I would think we want to use the ioread32_rep() function here (or
other "string" io functionality). Otherwise we're going to byteswap the
data that we're trying to interpret as a buffer and big endian CPUs
won't work.

>
>> we can not use ioread32_rep because as we can not reliably know how many
>> words we should read? FIFOCNT would have helped but its not advised to be
>> use as per the datasheet.
> You are right. readsl() or ioread32_rep() isn't used for this reason.
>
>

We could always use a size of 1 right?

[1] https://lkml.org/lkml/2012/10/22/671
[2] http://linuxplumbers.ubicast.tv/videos/big-and-little-endian-inside-out/

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

