Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaBDQTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:19:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaBDQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:18:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Murray <amurray@embedded-bits.co.uk>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 4 Feb 2014 17:18:41 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <20140204122951.GC27975@e106497-lin.cambridge.arm.com> <CAPcvp5HN4pBysOdS5_ep_3Lp7GDDKw4YrgmKjYzBet7PtaOLUg@mail.gmail.com>
In-Reply-To: <CAPcvp5HN4pBysOdS5_ep_3Lp7GDDKw4YrgmKjYzBet7PtaOLUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402041718.41931.arnd@arndb.de>
X-Provags-ID: V02:K0:/3df7JX9jNw+h4n0Tgw12W9RdZB8WBv7jhniQxGrKbf
 DoDJxyKsdeK5ewBv4hxPwhyJVvIlRgVjxbo1vEc+f9uo+KM+wC
 djHnAYG8TFv8hnlwbzrulbZiN32VOnxoqFwBnkOOLI1vpItd4b
 F797AKuzePQV+j878CThLMRjXOjkDSjicw22WdV5IFzH+YllAY
 hT38Y4TpqaJbfgCy1va620N5hmSzDIHBff5ZDJgZDRPeH03JCg
 lFUStUvAO8te02a1rEMsh2AiOttCCDFi+9tNytczWiKwikiQOo
 URlJyzZY3GKfQewoLUi8LD1iUdopqascqQrikQ/5QaxBA6AALa
 yweJ1pf3kLpbIITPyg1vrznBTJ4JKEf4fmte7Q5KB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014, Andrew Murray wrote:
> On 4 February 2014 12:29, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > On Mon, Feb 03, 2014 at 10:34:40PM +0000, Andrew Murray wrote:
> >> On 3 February 2014 18:43, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> >> > index 4cc813e..ce5bad2 100644
> >> > --- a/arch/arm64/include/asm/io.h
> >> > +++ b/arch/arm64/include/asm/io.h
> >> > @@ -120,9 +120,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
> >> >  /*
> >> >   *  I/O port access primitives.
> >> >   */
> >> > +#define arch_has_dev_port()    (0)
> >> >  #define IO_SPACE_LIMIT         0xffff
> >> >  #define PCI_IOBASE             ((void __iomem *)(MODULES_VADDR - SZ_2M))
> >> >
> >> > +#define ioport_map(port, nr)   (PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
> >> > +#define ioport_unmap(addr)
> >>
> >> I'm not sure that this will work. The in[bwl], out[bwl] macros in
> >> arch/arm64/include/asm/io.h already add the PCI_IOBASE offset.
> >>
> >> Instead of these two #defines, why not just enforce that
> >> GENERIC_PCI_IOMAP is enabled? Or at least wrap these defines with 'if
> >> (!config_enabled(CONFIG_GENERIC_PCI_IOMAP))' or similar.
> >
> > GENERIC_PCI_IOMAP is enabled for AArch64. We have select GENERIC_IOMAP in
> > arch/arm64/Kconfig which in turn selects GENERIC_PCI_IOMAP in lib/Kconfig.
> 
> Sorry, it was intent to suggest using the ioport_[map|unmap] functions
> in lib/iomap.c instead of defining something similar here. I guess you
> will also need to also define CONFIG_HAS_IOPORT for this to happen.

We do want CONFIG_HAS_IOPORT, but I would say that we should not use
CONFIG_GENERIC_IOMAP. As I explained in another reply, enabling this
was probably a simple mistake, and we only need this if we want I/O
spaces that are /not/ memory mapped. IMHO any ARM64 system that doesn't
map its PCI I/O space into MMIO space can live without I/O port
access.

	Arnd
