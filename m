Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaDGIf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:35:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56249 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaDGIfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:35:55 -0400
Date: Mon, 7 Apr 2014 09:35:50 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140407083550.GF17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
 <20140405001953.GE15806@google.com>
 <1396777793.3671.15.camel@pasglop>
MIME-Version: 1.0
In-Reply-To: <1396777793.3671.15.camel@pasglop>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 07 Apr 2014 08:36:06.0845 (UTC) FILETIME=[6B484ED0:01CF523C]
X-MC-Unique: 114040709355323301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 10:49:53AM +0100, Benjamin Herrenschmidt wrote:
> On Fri, 2014-04-04 at 18:19 -0600, Bjorn Helgaas wrote:
> > > Introduce a pci_register_io_range() helper function that can be used
> > > by the architecture code to keep track of the I/O ranges described by the
> > > PCI bindings. If the PCI_IOBASE macro is not defined that signals
> > > lack of support for PCI and we return an error.
> > 
> > I don't quite see how you intend to use this, because this series doesn't
> > include any non-stub implementation of pci_register_io_range().
> > 
> > Is this anything like the ia64 strategy I mentioned above?  If so, it would
> > be really nice to unify some of this stuff.
> 
> We also use two different strategies on ppc32 and ppc64
> 
>  - On ppc32, inb/outb turn into an MMIO access to _IO_BASE + port
> 
> That _IO_BASE is a variable which is initialized to the ioremapped address
> of the IO space MMIO aperture of the first bridge we discover. Then port
> numbers are "fixed up" on all other bridges so that the addition _IO_BASE + port
> fits the ioremapped address of the IO space on that bridge. A bit messy... and breaks
> whenever drivers copy port numbers into variables of the wrong type such as shorts.
> 
>  - On ppc64, we have more virtual space, so instead we reserve a range
> of address space (fixed) for IO space, it's always the same. Bridges IO spaces
> are then mapped into that range, so we always have a positive offset from _IO_BASE
> which makes things a bit more robust and less "surprising" than ppc32. Additionally,
> the first 64k are reserved. They are only mapped if we see an ISA bridge (which some
> older machines have). Otherwise it's left unmapped, so crappy drivers trying to
> hard code x86 IO ports will blow up immediately which I deem better than silently
> whacking the wrong hardware. In addition, we have a mechanism we use on powernv to
> re-route accesses to that first 64k to the power8 built-in LPC bus which can
> have some legacy IOs on it such as a UART or a RTC.
> 
> Cheers,
> Ben.
> 

Hi Benjamin,

Thanks for the summary, is really useful as I was recently looking into code in that
area. One thing I was trying to understand is why ppc needs _IO_BASE at all rather
than using the generic PCI_IOBASE? 

Best regards,
Liviu
 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

