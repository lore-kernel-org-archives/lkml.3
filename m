Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaCNLzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:55:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:60640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaCNLzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:55:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v6 1/3] Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
Date: Fri, 14 Mar 2014 12:54:17 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Tanmay Inamdar <tinamdar@apm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1394020150-1875-1-git-send-email-Liviu.Dudau@arm.com> <201403070137.38621.arnd@arndb.de> <20140307010950.GE21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140307010950.GE21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201403141254.17572.arnd@arndb.de>
X-Provags-ID: V02:K0:XQoR4YE0VONG+xZdO1NDT5cIyLlEEd26rM9X5K/IBau
 K5DHuFbQlUdPQ3WBXB0TTQ/fpoUBzOylJzaAQbzF32B9MS9Kzm
 P/Qzc4DOPqxxEg5YT4vh+s2+QHT0b9b2UC7YuIODYyS2wgyQDA
 JNWL1EimMiE7rqlNzadOf1G+r1WGey1dxKU3FMDzPd+f/PA9HM
 RwuDl21LazM2IguckyDHBWjxWwOUOZd7E/YMkT8CHt1n7+eRV8
 wVIjcGu6uOLjHKFzDKosm+ARF1beN+/bIlnXttnp8j8Ieg/c6T
 U4jEgdh+5UkutY6/EvQmM0EgtB+hbiYkqkupIIMUtS1o3KTeJV
 76QfEFoNf0wEd8LoptDwaL/rraGFLU1OLkEBz/STM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014, Russell King - ARM Linux wrote:
> On Fri, Mar 07, 2014 at 01:37:38AM +0100, Arnd Bergmann wrote:
> > On Thursday 06 March 2014, Russell King - ARM Linux wrote:

> > > arch/microblaze/include/asm/io.h:/* from asm-generic/io.h */
> > 
> > PCI_IOBASE=0, IO_SPACE_LIMIT=0xffffffff, so no change.
> 
> Seems to define _IO_BASE not PCI_IOBASE.

It gets the implicit PCI_IOBASE from asm-generic/io.h at the moment.

> > 
> > PCI_IOBASE=0, IO_SPACE_LIMIT=0xffffffff, so no change.
> 
> Doesn't appear to define PCI_IOBASE.

Same here.

> > For most of these, I assume we actually want to remove support
> > for inb/outb as they don't support I/O space accesses. The other
> > ones look correct to me.
> 
> Right, so:
> 
> #ifdef CONFIG_HAS_IOPORT
> #ifndef CONFIG_GENERIC_IOMAP
> static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> {
>         return (void __iomem *) port;
> }
> 
> changing that to include PCI_IOBASE in there will result in a build
> failure if the C compiler sees that.  In other words, when HAS_IOPORT=y
> and GENERIC_IOMAP=n.
> 
> HAS_IOPORT is set when HAS_IOMEM is also set and NO_IOPORT unset.
> 
> It looks to me like blackfin doesn't set NO_IOPORT nor NO_IOMEM, so
> this would have HAS_IOPORT set, and from what I can see doesn't set
> GENERIC_IOMAP.  So, this change probably breaks blackfin.

I also see the same thing that Liviu mentioned, that PCI_IOBASE=0
is always provided by asm-generic/io.h if not set otherwise.

On a related topic, Uwe Kleine-König has submitted a patch to
rename CONFIG_HAS_IOPORT to CONFIG_HAS_IOPORT_MAP to clarify what
it does, and to allow us to add a new CONFIG_HAS_IOPORT option
that will let us remove all the I/O port handling code for
architectures that don't have any I/O access method.

	Arnd
