Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3H0T06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:26:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62036 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3H0T0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130827191623.GY3005@radagast>
References: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
	<1376857245-2088-4-git-send-email-geert@linux-m68k.org>
	<20130819012400.GA2895@shlinux1.ap.freescale.net>
	<20130827191623.GY3005@radagast>
Date: Tue, 27 Aug 2013 21:26:54 +0200
X-Google-Sender-Auth: Ts94lHXC1vYCEaitPgfcl_i783M
Message-ID: <CAMuHMdVxvubhh3Ky=XxJd0+YydxooWGAth7WqgFA5=LnzQkJ3Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] usb: chipidea: USB_CHIPIDEA should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Peter Chen <peter.chen@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 9:16 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Aug 19, 2013 at 09:24:01AM +0800, Peter Chen wrote:
>> On Sun, Aug 18, 2013 at 10:20:44PM +0200, Geert Uytterhoeven wrote:
>> > If NO_DMA=y:
>> >
>> > drivers/built-in.o: In function `dma_set_coherent_mask':
>> > include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
>> >
>> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> > ---
>> >  drivers/usb/chipidea/Kconfig |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
>> > index d1bd8ef..dbd5232 100644
>> > --- a/drivers/usb/chipidea/Kconfig
>> > +++ b/drivers/usb/chipidea/Kconfig
>> > @@ -1,6 +1,6 @@
>> >  config USB_CHIPIDEA
>> >     tristate "ChipIdea Highspeed Dual Role Controller"
>> > -   depends on USB || USB_GADGET
>> > +   depends on (USB || USB_GADGET) && HAS_DMA
>> >     help
>> >       Say Y here if your system has a dual role high speed USB
>> >       controller based on ChipIdea silicon IP. Currently, only the
>>
>> I can't understand why the DMA can't be changed to fix this instead
>> of changing every driver?
>
> I'm with you. It'd be nicer to just provide empty stubs when !HAS_DMA

That would give us drivers that compile but don't work.
Not having stubs is intentional, cfr. the comment at the top of
include/asm-generic/dma-mapping-broken.h:

/* define the dma api to allow compilation but not linking of
 * dma dependent code.  Code that depends on the dma-mapping
 * API needs to set 'depends on HAS_DMA' in its Kconfig
 */

and the comments in the commit that introduced it:

commit 1b0fac45878bb88759eec347c273285195649ff7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Jul 15 23:40:26 2007 -0700

    dma-mapping: prevent dma dependent code from linking on !HAS_DMA archs

    Continuing the work started in 411f0f3edc141a582190d3605cadd1d993abb6df ...

    This enables code with a dma path, that compiles away, to build without
    requiring additional code factoring.  It also prevents code that calls
    dma_alloc_coherent and dma_free_coherent from linking whereas previously
    the code would hit a BUG() at run time.  Finally, it allows archs that set
    !HAS_DMA to delete their asm/dma-mapping.h file.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
