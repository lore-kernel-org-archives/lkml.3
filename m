Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaDFJuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:50:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:43418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbaDFJuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:50:52 -0400
Message-ID: <1396777793.3671.15.camel@pasglop>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 06 Apr 2014 19:49:53 +1000
In-Reply-To: <20140405001953.GE15806@google.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
	 <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
	 <20140405001953.GE15806@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 18:19 -0600, Bjorn Helgaas wrote:
> > Introduce a pci_register_io_range() helper function that can be used
> > by the architecture code to keep track of the I/O ranges described by the
> > PCI bindings. If the PCI_IOBASE macro is not defined that signals
> > lack of support for PCI and we return an error.
> 
> I don't quite see how you intend to use this, because this series doesn't
> include any non-stub implementation of pci_register_io_range().
> 
> Is this anything like the ia64 strategy I mentioned above?  If so, it would
> be really nice to unify some of this stuff.

We also use two different strategies on ppc32 and ppc64

 - On ppc32, inb/outb turn into an MMIO access to _IO_BASE + port

That _IO_BASE is a variable which is initialized to the ioremapped address
of the IO space MMIO aperture of the first bridge we discover. Then port
numbers are "fixed up" on all other bridges so that the addition _IO_BASE + port
fits the ioremapped address of the IO space on that bridge. A bit messy... and breaks
whenever drivers copy port numbers into variables of the wrong type such as shorts.

 - On ppc64, we have more virtual space, so instead we reserve a range
of address space (fixed) for IO space, it's always the same. Bridges IO spaces
are then mapped into that range, so we always have a positive offset from _IO_BASE
which makes things a bit more robust and less "surprising" than ppc32. Additionally,
the first 64k are reserved. They are only mapped if we see an ISA bridge (which some
older machines have). Otherwise it's left unmapped, so crappy drivers trying to
hard code x86 IO ports will blow up immediately which I deem better than silently
whacking the wrong hardware. In addition, we have a mechanism we use on powernv to
re-route accesses to that first 64k to the power8 built-in LPC bus which can
have some legacy IOs on it such as a UART or a RTC.

Cheers,
Ben.


