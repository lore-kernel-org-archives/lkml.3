Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaCTLSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:18:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:51517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:18:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Date: Thu, 20 Mar 2014 12:17:22 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com> <8312584.jdZZuHGAjg@wuerfel> <20140320094654.GZ6457@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140320094654.GZ6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403201217.22339.arnd@arndb.de>
X-Provags-ID: V02:K0:tlEY6V1q5Gb3zFG5CMOXiAnizesa7dpl3PO/gFTtcGv
 SPej8vlHsEh5nO39bqR/enKg1TcS62vwgIS+LQYcER+d2kUvmJ
 LhjzYXPhQwx7cTYUlrPTaylTV+G0N+Q59QAcAFR+mF2lQT3TL0
 KLL1Eaok3sqWi5boPlqc6RrTLW2H9Xf/QZuKKzuyxlSrDN9894
 +27LzQKBUbZKWQeyfSHREcs9jNpTbECOFRjt7bRBbNiMp361do
 nlopimEQrofbteatmnei0nLz8oJuA8k/a2uCzDusUOI/XEikZp
 8QG7Cq6Gxob+SQDHdid4CKUc9clj2tUnwdg06TPU/wRgkN50Bz
 Q8Mn+0H44KMqzDYlNyH02LuTbZJp2UO//PyPjNOY7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014, Liviu Dudau wrote:
> On Wed, Mar 19, 2014 at 06:37:51PM +0000, Arnd Bergmann wrote:
> > On Wednesday 19 March 2014 17:21:41 Liviu Dudau wrote:
> > > 
> > > My ultimate point is that no matter how long we argue about the shape of the functions that
> > > I've added into arch/arm64/kernel/pci.c I don't think we can get away without having that
> > > file, or at least not in the first phase if we want speedy integration into mainline.
> > 
> > Let me simplify the discussion here:
> > 
> > NAK to adding yet another architecture specific implementation.
> 
> So what would be your approach for handling pci_address_to_pio() in a non-arch specific way?
> 
> unsigned long __weak pci_address_to_pio(phys_addr_t address)
> {
> #ifdef ARCH_HAS_IOSPACE
>         if (address > IO_SPACE_LIMIT)
>                 return (unsigned long)-1;
> 
>         return (unsigned long) address;
> #else
>         struct ioresource *res;
> 
>         list_for_each_entry(res, &io_list, list) {
>                 if (address >= res->start &&
>                         address < res->start + res->size) {
>                         return res->start - address;
>                 }
>         }
> 
>         return (unsigned long)-1;
> #endif
> }
> 
> 
> Either that, or you have more magic rabbits than me.

I don't even understand why you want to create a generic pci_address_to_pio
implementation, when we don't need that for arm64 at all. Unless I'm
missing something important, that function is only called in case of
PCI_PROBE_DEVTREE with pci_of_scan on PowerPC. I don't expect any
architecture to do the same thing, and the only other architecture that
needs something like it (sparc) has a different implementation.

The regular (non-DEVTREE) PCI bus scan should just be able to translate
the BUS I/O addresses into Linux I/O port numbers using io_offset,
without going through an intermediate step of translating into a CPU
physical address first, so the entire lookup method won't get used.

The reason why PowerPC needs it is that they traditionally don't
use PCI config space access to assign or look at resources, but
instead rely on the firmware to have set it up in advance and then
put matching information into DT and the BARs. For Solaris and AIX,
it's probably easier to use the information from DT, but in Linux,
we already need to implement the manual bus scan, e.g. to do
PCI device hotplugging if nothing else.

	Arnd
