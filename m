Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaE2Nhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:37:39 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:48391 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaE2Nhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:37:37 -0400
MIME-Version: 1.0
In-Reply-To: <53847F39.2010503@ti.com>
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com>
	<CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
	<538459E8.6010701@ti.com>
	<20140527084615.GC1801@lahna.fi.intel.com>
	<53847F39.2010503@ti.com>
Date: Thu, 29 May 2014 15:37:37 +0200
Message-ID: <CACRpkdbe1=Yt3UDm9f4ZmZ+K2ZB9nVL+RNr7eU_TbnK-CmNY+A@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 2:04 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 05/27/2014 11:46 AM, Mika Westerberg wrote:

> Regarding remove()/suspend() routines, It's like an axiom for me:
> - always disable irq
> - always stop all works/threads created by driver
> - do everything else
> (It's proved by dozens hours of debugging).
>
> Anyway, above is just my opinion :)

We cannot really let such things be up to someone's
opinion... we need to figure out what is the right way to
do it and do it that way, else we have ambigous semantics
in gpiolib and/or irqchip, which i *hate*.

> So, It's up to you, because it's your code :)

No, let's figure out what is right...

And, FWIW your sequence looks perfectly reasonable.

> Also FYI, I did fast analysis of GPIO drivers - funny statistic below:
> - 16 drivers setup IRQs BEFORE calling gpiochip_add();
> - 22 drivers setup IRQs AFTER calling gpiochip_add();

My idea is that you should call gpiochip_add() *first* and then
add the IRQs to the chip. In succession.

Rationale: with dynamic GPIO numbers, gpio_to_irq()
cannot reasonably be working before the gpiochip is added,
so it should be added first, then the irqchip. Since irq_to_gpio()
is *NOT* to be used (rather obliterated), this is the sequence
we mandate.

This is how the new irqchip helpers work by the way. As I
introduce this to more and more drivers it will look more and
more like this. And attack patches tagged RFT switching the
semantics of drivers are appreciated.

Yours,
Linus Walleij
