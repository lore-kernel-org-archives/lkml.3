Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaGFTYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 15:24:45 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:46585 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaGFTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 15:24:43 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vFHADzsE7_69B+jjT3kwX_3kOdUBzjtSVEYETwR7HY3Q@mail.gmail.com>
References: <CACxGe6vFHADzsE7_69B+jjT3kwX_3kOdUBzjtSVEYETwR7HY3Q@mail.gmail.com>
Date: Sun, 6 Jul 2014 12:24:42 -0700
X-Google-Sender-Auth: ytALZ54MlWQEDjidq1dg7MW5H4g
Message-ID: <CA+55aFwd7sKSKu0+pfSOUGUQrbVuCO_ZBAXds=uGYx5=yfV=VA@mail.gmail.com>
Subject: Re: [GIT PULL] bug fix for devicetree memory parsing
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@linaro.org>, Laura Abbott <lauraa@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 2:37 AM, Grant Likely <grant.likely@linaro.org> wrote:
>
> Can you pull this bug fix into your tree please?

I took it, but I think both your explanation and the patch itself is
actually crap. It may fix the issue, but it's seriously confused.

Your explanation says that it's a 32-bit platform issue. No it's not.
Most 32-bit configurations still have a 64-bit phys_addr_t (ie
PAE/LPAE etc).

And the code is crap, because it uses ULONG_MAX etc in ways that
simply make no f*cking sense. And why does it care about sizeof?

Why does the code not just do something like

  #define MAX_PHYS_ADDR ((phys_addr_t) ~0)

and then do

  if (base > MAX_PHYS_ADDR || base + size > MAX_PHYS_ADDR)
    ...

and be done with it? All those sizeof tests are completely pointless.
If it turns out that phys_addr_t is the same size as u64, then the
tests will never be true, and the compiler will happily optimize them
away.

So I think this fixes a problem, but it's all ugly as hell. I ended up
pulling it because I'm lazy and don't have a machine to test a proper
fix on anyway, but I hope this can get cleaned up. And more
importantly, I hope maintainers will spend a bit more time thinking
about things like this. It's not just that the code is unnecessarily
complex, it's WRONG. Comparing things to "ULONG_MAX" makes absolutely
zero sense, since "ULONG_MAX" has nothing to do with anything. It's
just stupid and misleading, and it just so happens to work by random
luck because it so *happens* that phys_addr_t is smaller than "u64"
only when ULONG_MAX happens to be the same size. But even that is not
guaranteed (ie some stupid broken architecture might have a 32-bit
physical address space despite having a 64-bit "long")

                Linus
