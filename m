Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3HLWNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:13:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41278 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3HLWNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:13:04 -0400
Date: Mon, 12 Aug 2013 23:12:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130812221250.GI23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk> <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com> <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com> <20130812200628.GG23006@n2100.arm.linux.org.uk> <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com> <20130812212149.GH23006@n2100.arm.linux.org.uk> <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:36:17PM +0100, Peter Maydell wrote:
> On this point, yes. Equivalent bit from the PB926 TRM:
> http://infocenter.arm.com/help/topic/com.arm.doc.dui0224i/Cacdijji.html
> 
> (There are differences between the PCI controllers on
> the different boards. Differences I know of are:
>  * size of the three memory mapped regions
>  * whether the top bits of the PCI address come from the top
>    or bottom of the IMAP* registers
> I believe (based on some experimentation and an educated guess)
> that these both changed at the same point, but some of the board
> TRMs claim to be part one way part the other, presumably due to
> copy and paste error. In particular PB1176's TRM has a mangled
> description of the IMAP* registers which didn't match what the
> h/w actually did in my testing.)

Bah, updated TRMs since my version.

Right, so if I've traced everything correctly, this should work:

        /*
         * Slot INTA    INTB    INTC    INTD
         *  31  PCI1    PCI2    PCI3    PCI0
         *  30  PCI0    PCI1    PCI2    PCI3
         *  29  PCI3    PCI0    PCI1    PCI2
         */
        return IRQ_SIC_PCI0 + ((slot + 2 + pin - 1) & 3);
