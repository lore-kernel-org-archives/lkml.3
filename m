Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaGHRzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:55:46 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:42350 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaGHRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:55:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwd7sKSKu0+pfSOUGUQrbVuCO_ZBAXds=uGYx5=yfV=VA@mail.gmail.com>
References: <CACxGe6vFHADzsE7_69B+jjT3kwX_3kOdUBzjtSVEYETwR7HY3Q@mail.gmail.com>
	<CA+55aFwd7sKSKu0+pfSOUGUQrbVuCO_ZBAXds=uGYx5=yfV=VA@mail.gmail.com>
Date: Tue, 8 Jul 2014 10:55:43 -0700
X-Google-Sender-Auth: ETRe5Q7RAKhiwWYu1jV4zlPxEa8
Message-ID: <CA+55aFwwZB=aZ12WikKETtV-mZKPvVRMvC0ie6-UbUq8bkgAUQ@mail.gmail.com>
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

On Sun, Jul 6, 2014 at 12:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Why does the code not just do something like
>
>   #define MAX_PHYS_ADDR ((phys_addr_t) ~0)
>
> and then do
>
>   if (base > MAX_PHYS_ADDR || base + size > MAX_PHYS_ADDR)

Actually, there's an even better model, which is to just check if a
value fits in a type.

You could do something like

  #define FITS(type, value) ((value) == (type)(value))

and then you can just use

    if (!FITS(phys_addr_t, base) || !FITS(phys_addr_t, base+size))

instead. The compiler will trivially turn the comparisons into no-ops
if the type is sufficient to hold the value.

We already do this in a few places, it might even be worth it making a
generic macro. People have been confused by the "x == x" kind of
comparisons before, see for example fs/buffer.c:grow_buffers(), which
does

        index = block >> sizebits;
        if (unlikely(index != block >> sizebits)) {

where "index" is a pgoff_t, but "block >> sizebits" is a sector_t, so
that comparison actually checks that "block >> sizebits" fits in the
type, even though it looks like it compares the same computed value
against itself.

           Linus
