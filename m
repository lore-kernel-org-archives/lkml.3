Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaCQQWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:22:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41525 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaCQQWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:22:15 -0400
Date: Mon, 17 Mar 2014 16:22:11 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140317162211.GH6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Rob Herring <robherring2@gmail.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
 <CAL_Jsq+9X-9VahsP79mtHN0RC64vRA_2R3ucjX0LefO6q2YN3Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+9X-9VahsP79mtHN0RC64vRA_2R3ucjX0LefO6q2YN3Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 17 Mar 2014 16:22:24.0371 (UTC) FILETIME=[14833C30:01CF41FD]
X-MC-Unique: 114031716221203301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:05:38PM +0000, Rob Herring wrote:
> On Fri, Mar 14, 2014 at 10:34 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > Use the generic host bridge functions to provide support for
> > PCI Express on arm64. There is no support for ISA memory.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> > ---
> >  arch/arm64/Kconfig            |  19 +++-
> >  arch/arm64/include/asm/Kbuild |   1 +
> >  arch/arm64/include/asm/io.h   |   3 +-
> >  arch/arm64/include/asm/pci.h  |  51 ++++++++++
> >  arch/arm64/kernel/Makefile    |   1 +
> >  arch/arm64/kernel/pci.c       | 173 ++++++++++++++++++++++++++++++++
> >  6 files changed, 246 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/pci.h
> >  create mode 100644 arch/arm64/kernel/pci.c
> 
> [snip]
> 
> > +#endif
> > +
> > +extern unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr);
> 
> Can we at least align the function definition across architectures if
> not the implementation.

The choice of names is unfortunate. We are trying to follow the spirit of the
arch/arm function, not the implementation, and for RFC that served the purpose.

I'll come up with a better name as I don't intend to share the implementation
with arch/arm here.

Best regards,
Liviu

> 
> 
> > +int pci_register_io_range(phys_addr_t address, resource_size_t size)
> > +{
> > +       struct ioresource *res;
> > +       resource_size_t allocated_size = 0;
> > +
> > +       /* find if the range has not been already allocated */
> > +       list_for_each_entry(res, &io_list, list) {
> > +               if (address >= res->start &&
> > +                       address + size <= res->start + size)
> > +                       return 0;
> > +               allocated_size += res->size;
> > +       }
> > +
> > +       /* range not already registered, check for space */
> > +       if (allocated_size + size > IO_SPACE_LIMIT)
> 
> I believe this needs to be "allocated_size + size - 1".
> 
> > +               return -E2BIG;
> > +
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

