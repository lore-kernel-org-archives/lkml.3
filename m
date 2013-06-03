Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3FCWqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:46:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34405 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621Ab3FCWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:46:06 -0400
Date: Mon, 3 Jun 2013 23:45:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
	decompressor
Message-ID: <20130603224555.GR18614@n2100.arm.linux.org.uk>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org> <20130603222321.GP18614@n2100.arm.linux.org.uk> <51AD1AB3.9050908@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD1AB3.9050908@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:37:39PM -0700, Stephen Boyd wrote:
> On 06/03/13 15:23, Russell King - ARM Linux wrote:
> > On Mon, Jun 03, 2013 at 02:13:39PM -0700, Stephen Boyd wrote:
> >> We
> >> can't get any information about why the decompression failed if
> >> we have debug_ll enabled. I had to patch the error() routine to
> >> not while loop forever to get that print after do_decompress to
> >> be useful.)
> > Maybe your implementation of puts() for the decompressor is faulty then?
> > Because it works for me - when something goes wrong with the decompression,
> > I get a message such as:
> >
> > Decompressing kernel...
> >
> > CRC error
> >
> >  -- System halted
> >
> 
> I was expecting to see
> 
> Decompressing kernel...
> 
> CRC error
> 
> decompressor returned an error
> 
> 
> but since we loop forever this code in arch/arm/boot/compressed/misc.c
> doesn't do anything:
> 
>         if (ret)
>                 error("decompressor returned an error");

I think that's just a final catch-all in case one of the decompressors
doesn't use the error() function pointer it was passed.

> In my case I'm booting a kernel with textoffset = 0x208000 but RAM
> starts at 0x0. Does "minimum of RAM start" mean 0x0 or 0x200000?

The basic requirement for zImage's is no less than the start of RAM
plus 32K.  Or let me put it another way - start of writable memory
plus 32K.

Whether you need an offset of 0x200000 or not is not for the
decompressor to know.  If you're having to avoid the first 0x200000
bytes of memory for some reason (eg, secure firmware or DSP needs
it left free) then there's no way for the decompressor to know that,
so it's irrelevant.

So, lets say that your platform has a DSP which needs the first 0x200000
bytes left free.  So the boot loader _already_ needs to know to load
the image not at zero, but above 0x200000.  The additional 32K
requirement is really nothing new and so should be treated in just the
same way.

Leave at least 32K of usable memory below the zImage at all times.
