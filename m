Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaCGBBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:01:42 -0500
Received: from dliviu.plus.com ([80.229.23.120]:40661 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbaCGBBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:01:41 -0500
Date: Fri, 7 Mar 2014 00:58:50 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v5 1/7] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140307005850.GG13582@bart.dudau.co.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <201403042330.09607.arnd@arndb.de>
 <20140306160442.GG6457@e106497-lin.cambridge.arm.com>
 <201403070124.13139.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201403070124.13139.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Mar  7 01:01:39 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53191a733191632341560
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:24:12AM +0100, Arnd Bergmann wrote:
> On Thursday 06 March 2014, Liviu Dudau wrote:
> > On Tue, Mar 04, 2014 at 10:30:09PM +0000, Arnd Bergmann wrote:
> > > On Tuesday 04 March 2014, Liviu Dudau wrote:
> > > > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > > > +{
> > > > +       return 0;
> > > > +}
> > > > +
> > > 
> > > How about returning an error here? You don't actually register the range.
> > 
> > That's not the intention here. I basically want a nop, as by default (read x86)
> > we do nothing with the IO range.
> 
> I think x86 is a bad default though, because that is the exception rather than
> the rule. I also think that on x86, you shouldn't have an entry for the I/O
> space in the "ranges" property since there is no translation, and then we don't
> call this function.
> 
> PCI devices described in DT on x86 would still be able to list their I/O BARs
> in DT, but you don't ever translate them into MMIO ranges.

So, if I understand you correctly, you would prefer to fail here and hence stop the
parsing for the x86, rather than pretending everything is OK and going through the
motions?

That was not my original thinking when I've introduced this function here. The main
purpose of the function is to help the correct translation of IO addresses in
pci_address_to_pio(). As Jason has explained very nicely, we have 3 types of
architectures here that we try to support:
  - the ones that have separate IO address space (x86)
  - the ones that have 1:1 mapping between physical IO addresses and logical ports
  - the architectures that memory map the IO addresses in virtual address space
    and then translate the logical addresses into virtual based on a given offset.

For the first two types we don't want to do anything special. Architectures that
fall in the last category will have to provide their own version of this function,
with the arm64 version being generic enough to be used as de facto?

But I can see your point of view as well. I just don't know if that is good enough
for powerpc and microblaze. With the way things are in my patch, they should be able
to switch to of_create_pci_host_bridge() easily*, with your suggestion they will
have to provide their implementation for pci_register_io_range().

We really need to get another architecture converted. If there are no other takers I
will make a stab once the current push towards upstreaming AArch64 hardware support
slows down.

* says the newby with confidence in his voice ;)

Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

