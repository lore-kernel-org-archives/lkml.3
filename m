Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaIJQxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:53:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51374 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaIJQxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:53:52 -0400
Date: Wed, 10 Sep 2014 17:53:47 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 08/10] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140910165347.GJ27864@e106497-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-9-git-send-email-Liviu.Dudau@arm.com>
 <20140909133546.GB2636@e102568-lin.cambridge.arm.com>
 <20140910142241.GD27864@e106497-lin.cambridge.arm.com>
 <20140910151026.GB11640@e102568-lin.cambridge.arm.com>
 <20140910153233.GG27864@e106497-lin.cambridge.arm.com>
 <20140910163746.GB19662@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20140910163746.GB19662@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 10 Sep 2014 16:53:49.0020 (UTC) FILETIME=[CAF799C0:01CFCD17]
X-MC-Unique: 114091017534906401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 05:37:47PM +0100, Lorenzo Pieralisi wrote:
> On Wed, Sep 10, 2014 at 04:32:33PM +0100, Liviu Dudau wrote:
> 
> [...]
> 
> > > > > > +		/*
> > > > > > +		 * If we failed translation or got a zero-sized region
> > > > > > +		 * then skip this range
> > > > > > +		 */
> > > > > > +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > > > > > +		if (!res) {
> > > > > > +			err = -ENOMEM;
> > > > > > +			goto parse_failed;
> > > > > > +		}
> > > > > > +
> > > > > > +		err = of_pci_range_to_resource(&range, dev, res);
> > > > > > +		if (err) {
> > > > > > +			kfree(res);
> > > > > 
> > > > > You might want to add a label to free res to make things more uniform.
> > 
> > Sorry, not following you. How would a label help here?
> 
> It was just a suggestion so ignore it if you do not think it is cleaner.
> It is to make code more uniform and undo operations in one place instead of
> doing it piecemeal (you kfree the res here and jump to complete the clean-up,
> whereas you might want to add a different label and a different goto
> destination and carry out the kfree there).

But that kfree is the only done once, while the pci_free_resource_list() is
done twice.

> 
> I do not mind either, it is just what I noticed.
> 
> > > > > > +			goto parse_failed;
> > > > > > +		}
> > > > > > +
> > > > > > +		if (resource_type(res) == IORESOURCE_IO) {
> > > > > > +			if (*io_base)
> > > > > 
> > > > > You do not zero io_base in the first place so you should ask the API
> > > > > user to do that. Is 0 a valid value BTW ? If it is you've got to resort
> > > > > to something else to detect multiple IO resources.
> > 
> > No, zero is not a valid value. It is the cpu_addr value from the IO range, I'm
> > hopying that no one is crazy enough to map PCI address space at CPU address zero.
> > Thanks for spotting the lack of initialisation though, I need to fix it.
> 
> Mmm...wasn't a trick question sorry :D
> 
> PCI host bridge /pci ranges:
>    IO 0x00000000..0x0000ffff -> 0x00000000
>    More than one I/O resource converted. CPU offset for old range lost!
>      MEM 0x41000000..0x7fffffff -> 0x41000000
>      pci-host-generic 40000000.pci: PCI host bridge to bus 0000:00
>      pci_bus 0000:00: root bus resource [bu-01]
>      pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
>      pci_bus 0000:00: root bus resource [mem 0x41000000-0x7fffffff]
> 

Your DT puts the IO space at CPU address zero? Could you copy the relevant
host bridge node from DT here?

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

