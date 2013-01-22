Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3AVAye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:54:34 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:55411 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3AVAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301211739470.6300@xanadu.home>
References: <1358787763-1226-1-git-send-email-matt@genesi-usa.com> <alpine.LFD.2.02.1301211739470.6300@xanadu.home>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 18:54:12 -0600
Message-ID: <CAKGA1bkQ9e8gmSPz_4csJWjEOKj3ZVqSLijSTRWxgDSaZoYqCA@mail.gmail.com>
Subject: Re: [PATCH] crypto: fix FTBFS with ARM SHA1-asm and THUMB2_KERNEL
To: Nicolas Pitre <nico@fluxnic.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@linaro.org>,
        David McCullough <david_mccullough@mcafee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 4:46 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Mon, 21 Jan 2013, Matt Sealey wrote:
>
>> The optimized assembler SHA1 code for ARM does not conform to Thumb2
>> register usage requirements, so it cannot be built when the kernel is
>> configured with THUMB2_KERNEL.
>>
>> Fix the FTBFS for now by preventing misconfigurations of the kernel.
>>
>> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
>
> A .arm directive at the top of the assembly code would be a better
> "fix", as that wouldn't reduce functionality.

If I recall, doing that last time for ssi-fiq.S was the wrong solution
and it was suggesed proper configuration (on top of possibly rewriting
the assembly) was better than hacking around in the assembly..

> Yet, I'd invite you to have a look at commit 638591cd7b in linux-next.

I took a peek, and invite you to ignore my patch. I only tracked the
top of Linus' tree..

That said, it seems nobody benchmarked this on something different
than IXP425 or KS8695 to see if it's markedly faster than the
(moderately recently updated) C-code implementation outside of the
mentioned in the logs for initial commit? It seems like rather a
specific optimization for a rather specific use case for rather
specific processors (and therefore a small test base) probably meant
for a very specific product line somewhere. Whether you get any
benefit in enabling this config item or not for any other ARM platform
is up for debate, isn't it?

If it *is* in fact much faster everywhere, and it works in any ARM or
THUMB2 configuration, there's a case to be built for it being the
default ARM implementation for AES and SHA1..

This question is to the implementor/committer (Dave McCullough), how
exactly did you measure the benchmark and can we reproduce it on some
other ARM box?

If it's long and laborious and not so important to test the IPsec
tunnel use-case, what would be the simplest possible benchmark to see
if the C vs. assembly version is faster for a particular ARM device? I
can get hold of pretty much any Cortex-A8 or Cortex-A9 that matters, I
have access to a Chromebook for A15, and maybe an i.MX27 or i.MX35 and
a couple Marvell boards (ARMv6) if I set my mind to it... that much
testing implies we find a pretty concise benchmark though with a
fairly common kernel version we can spread around (i.MX, OMAP and the
Chromebook, I can handle, the rest I'm a little wary of bothering to
spend too much time on). I think that could cover a good swath of
not-ARMv5 use cases from lower speeds to quad core monsters.. but I
might stick to i.MX to start with..

--
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
