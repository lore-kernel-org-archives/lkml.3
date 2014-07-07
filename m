Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaGGVW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:22:28 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62754 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaGGVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:22:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v8 4/9] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Mon, 7 Jul 2014 23:22:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>, Sinan Kaya <okaya@codeaurora.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Will Deacon <Will.Deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <6122131.ozzYjjjRQi@wuerfel> <20140707111133.GP6501@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140707111133.GP6501@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201407072322.00990.arnd@arndb.de>
X-Provags-ID: V02:K0:HYjbeHgGBFRnS787Bx7/dwrYtGIW7YMCRxk/Ivi2TC7
 QoQvBxV9fV6T0fctawk5lQB5uC+J/htcAZoSI+YTj08MPmSGEf
 DgTVcKKeIPw/Qu9K1l5d8tzeARDkjtheRVnn/k/6xKm+MIHfW9
 RqQwl6uPqccix0fsj7pdkL9Hxd1kdmkNpnG/sL2NFsChQfeCDG
 wmxowdhXe4ZYtI9UZDbpyzthVIl/4tbZ6vip3+k2B7m5ROi9Ay
 DddfBXtOmtmO9eUQECkU3HeFIL7lhxyQWauvWxqN5Q4at6H6IX
 Z16QdY4Cyg49Plqy7rO2f7EFBo6q0gRgZyOwwaLKz57C0TAX4v
 LHwsGuO7BhI/PZFzgYvw79EuykR9OCoMiUqcSdJVU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2014, Liviu Dudau wrote:
> On Sat, Jul 05, 2014 at 09:46:09PM +0100, Arnd Bergmann wrote:
> > On Saturday 05 July 2014 14:25:52 Rob Herring wrote:
> > > On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > > > The ranges property for a host bridge controller in DT describes
> > > > the mapping between the PCI bus address and the CPU physical address.
> > > > The resources framework however expects that the IO resources start
> > > > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
> > > > The conversion from pci ranges to resources failed to take that into account.
> > > 
> > > I don't think this change is right. There are 2 resources: the PCI bus
> > > addresses and cpu addresses. This function deals with the cpu
> > > addresses. Returning pci addresses for i/o and cpu addresses for
> > > memory is going to be error prone. We probably need both cpu and pci
> > > resources exposed to host controllers.
> > > 
> > > Making the new function only deal with i/o bus resources and naming it
> > > of_pci_range_to_io_resource would be better.
> > 
> > I think you are correct that this change by itself is will break existing
> > drivers that rely on the current behavior of of_pci_range_to_resource,
> > but there is also something wrong with the existing implementation:
> 
> Either I'm very confused or I've managed to confuse everyone else. The I/O
> resources described using CPU addresses *are* using "pseudo" port based
> addresses (or at least that is my understanding and my reading of the code).
> Can you point me to a function that is expecting the IO resource to have
> the start address at the physical address of the mapped space?

pci_v3_preinit() in arch/arm/mach-integrator/pci_v3.c for instance takes
the resource returned by of_pci_range_to_resource and programs the
start and size into hardware registers that expect a physical address
as far as I can tell.

> I was trying to fix exactly this issue, that you cannot use the resource
> structure returned by this function in any call that is expecting an IO
> resource.

I looked at the other drivers briefly, and I think you indeed fix the Tegra
driver with this but break the integrator driver as mentioned above.
The other callers of of_pci_range_to_resource() are apparently not
impacted as they recalculate the values they get.

	Arnd
