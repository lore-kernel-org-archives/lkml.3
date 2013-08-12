Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3HLWs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:48:57 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59061 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3HLWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:48:56 -0400
Date: Mon, 12 Aug 2013 15:48:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130812224853.GA9580@roeck-us.net>
References: <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net>
 <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130812164548.GE23006@n2100.arm.linux.org.uk>
 <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
 <20130812200628.GG23006@n2100.arm.linux.org.uk>
 <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
 <20130812212149.GH23006@n2100.arm.linux.org.uk>
 <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com>
 <20130812221250.GI23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812221250.GI23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 11:12:50PM +0100, Russell King - ARM Linux wrote:
> On Mon, Aug 12, 2013 at 10:36:17PM +0100, Peter Maydell wrote:
> > On this point, yes. Equivalent bit from the PB926 TRM:
> > http://infocenter.arm.com/help/topic/com.arm.doc.dui0224i/Cacdijji.html
> > 
> > (There are differences between the PCI controllers on
> > the different boards. Differences I know of are:
> >  * size of the three memory mapped regions
> >  * whether the top bits of the PCI address come from the top
> >    or bottom of the IMAP* registers
> > I believe (based on some experimentation and an educated guess)
> > that these both changed at the same point, but some of the board
> > TRMs claim to be part one way part the other, presumably due to
> > copy and paste error. In particular PB1176's TRM has a mangled
> > description of the IMAP* registers which didn't match what the
> > h/w actually did in my testing.)
> 
> Bah, updated TRMs since my version.
> 
> Right, so if I've traced everything correctly, this should work:
> 
>         /*
>          * Slot INTA    INTB    INTC    INTD
>          *  31  PCI1    PCI2    PCI3    PCI0
>          *  30  PCI0    PCI1    PCI2    PCI3
>          *  29  PCI3    PCI0    PCI1    PCI2
>          */
>         return IRQ_SIC_PCI0 + ((slot + 2 + pin - 1) & 3);
> 
Assuming this is what you mean, I added the above code to
versatile_map_irq(). It does not work, unfortunately, at least not
in qemu 1.4.0.

This is what the kernel reports for interrupt numbers:

kernel			irq	result
--------------------------------------
3.10.6:			92	fails
3.10.6+above change:	94	fails
3.10.6+Paul's patch:	91	works

Now is this a qemu problem or a kernel problem ?

Thanks,
Guenter
