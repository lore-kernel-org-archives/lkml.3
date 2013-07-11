Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3GKHt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:49:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32992 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3GKHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307102054340.11279-100000@netrider.rowland.org>
References: <201307110112.57398.arnd@arndb.de>
	<Pine.LNX.4.44L0.1307102054340.11279-100000@netrider.rowland.org>
Date: Thu, 11 Jul 2013 09:49:23 +0200
X-Google-Sender-Auth: Zr9GWErV8-NnPzH54ZVwOwWVnKk
Message-ID: <CAMuHMdWF8pHQ7RfojiJK7NxULZZjecvzSkP6R+Q-5ib4A516Bw@mail.gmail.com>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 3:01 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 11 Jul 2013, Arnd Bergmann wrote:
>
>> On Wednesday 10 July 2013, Alan Stern wrote:
>> > This isn't right.  There are USB host controllers that use PIO, not
>> > DMA.  The HAS_DMA dependency should go with the controller driver, not
>> > the USB core.
>> >
>> > On the other hand, the USB core does call various routines like
>> > dma_unmap_single.  It ought to be possible to compile these calls even
>> > when DMA isn't enabled.  That is, they should be defined as do-nothing
>> > stubs.
>>
>> The asm-generic/dma-mapping-broken.h file intentionally causes link
>> errors, but that could be changed.
>>
>> The better approach in my mind would be to replace code like
>>
>>
>>       if (hcd->self.uses_dma)
>>
>> with
>>
>>       if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
>>
>> which will reliably cause that reference to be omitted from object code,
>> but not stop giving link errors for drivers that actually require
>> DMA.
>
> How will it give link errors for drivers that require DMA?

It won't. Unless the host driver itself calls into the DMA API, too
(are there any that don't?).

> Besides, wouldn't it be better to get an error at config time rather
> than at link time?  Or even better still, not to be allowed to
> configure drivers that depend on DMA if DMA isn't available?

Indeed.

> If we add an explicit dependency for HAS_DMA to the Kconfig entries for
> these drivers, then your suggestion would be a good way to allow
> usbcore to be built independently of DMA support.

However, having the link errors helps when annotating the Kconfig files
with HAS_DMA dependencies.

Unfortunately the check for "hcd->self.uses_dma" (which boils down to
"dev->dma_mask != NULL") isn't sufficient to cause breakage at compilation
time when a Kconfig entry incorrectly doesn't depend on HAS_DMA.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
