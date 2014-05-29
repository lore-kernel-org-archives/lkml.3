Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaE2Hnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:43:45 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46295 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaE2Hnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <5385EB42.1060604@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org>
	<537FD9A7.3010100@codeaurora.org>
	<5385EB42.1060604@linaro.org>
Date: Thu, 29 May 2014 09:43:42 +0200
Message-ID: <CACRpkdb_ozxL3wAVf7FJr-0A2tWGHkfXeXf5sWaW6h_yzK4QvA@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 3:57 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:

>> This doesn't look endianness agnostic. Shouldn't we use ioread32_rep()
>> to read this fifo?
>
> Is'nt readl endianess aware?

At least once a year read through arch/arm/include/asm/io.h

static inline u32 __raw_readl(const volatile void __iomem *addr)
{
        u32 val;
        asm volatile("ldr %1, %0"
                     : "+Qo" (*(volatile u32 __force *)addr),
                       "=r" (val));
        return val;
}
(...)
#define readl_relaxed(c) ({ u32 __r = le32_to_cpu((__force __le32) \
                                        __raw_readl(c)); __r; })
(...)
#define readl(c)                ({ u32 __v = readl_relaxed(c);
__iormb(); __v; })

readl() reads in little endian.

All PrimeCells are little endian, trouble would occur if and only if
this cell was
used on a big endian CPU, like an ARM used in BE mode, if the macros
didn't look exactly like this.

Thanks to the fact that readl() is always LE things work smoothly.

Then to the question whether to use ioread32() instead:

#define ioread32(p)     ({ unsigned int __v = le32_to_cpu((__force
__le32)__raw_readl(p)); __iormb(); __v; })

Same thing as readl(). The only reason to use ioread32() rather than
readl() is that some archs do not support readl() but only ioread32().
However for that to be a problem, these archs must be utilizing that
primecell! And if they do there are two ways to solve it: either change
the entire world to use ioread/write32 or simply just define readl() and
friends for that arch in its io.h file.

I'd say don't touch it right now.

> we can not use ioread32_rep because as we can not reliably know how many
> words we should read? FIFOCNT would have helped but its not advised to be
> use as per the datasheet.

You are right. readsl() or ioread32_rep() isn't used for this reason.

Yours,
Linus Walleij
