Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3B0Hw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:52:27 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:39736 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3B0Hw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:52:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLazaZEbbUVtR_Zyub3hgTesW6JcD9Kxgk7dUXuESpLOw@mail.gmail.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
 <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
 <20130226175311.D17173E2EF8@localhost> <CAAVeFuLazaZEbbUVtR_Zyub3hgTesW6JcD9Kxgk7dUXuESpLOw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 Feb 2013 07:52:04 +0000
X-Google-Sender-Auth: HGETgavrGwxfuO4GNbW_PQoQBCw
Message-ID: <CACxGe6tyDrOF1eNNjY0j4tctx=C+m+9xkjGUFRW33hU+k6+o-g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 1:22 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Feb 27, 2013 at 2:53 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Fri, 22 Feb 2013 11:19:44 +0900, Alexandre Courbot <gnurou@gmail.com> wrote:
>>> Grant, will you be able to include these for 3.9? They fix code that
>>> you merged recently, so I'd be glad if they could be squashed into the
>>> patch mentioned in the description.
>>
>> They won't get squashed in because the tree is already composed and in
>> linux-next. I don't rebase unless I really need to. I've applied them
>> and I'll probably push to Linus since they are effectively bug fixes of
>> a sort and the merge window hasn't closed yet.
>
> That's fine too - as long as the patches with side-effects are merged.
> That will allow me to continue going forward with GPIO, thanks!

While you're working on that, I'd like you to keep the following in
mind. I'm getting concerned with the level of overhead that the gpio
access routines are incuring. They're doing a lot of checks right now
when with GPIOs we want it to be as fast as possible for the case of
mmio gpios. (i2c and spi gpios are always going to be slow, so I'm not
so concerned here). gpio_get, gpio_set and gpio_direction all need to
be fast.

Basically, I think the model should be that if you've got a gpio_desc
pointer, then you've got a valid gpio. A lot of the checks that are
currently performed in the gpiod_ versions of functions can be moved
to the gpio_ versions where a lookup has to be performed anyway. For
example, right now gpiod_direction_output() is 61 lines long. Madness!
 :-)

I've been playing with an idea of pulling in some basic MMIO gpio
access directly into gpiolib so that when appropriate gpiolib itself
can have a fast path for doing the register access and shadow register
management.

g.
