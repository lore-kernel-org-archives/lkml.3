Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3CFJnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:43:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43756 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3CFJnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:43:01 -0500
Date: Wed, 6 Mar 2013 09:42:56 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, jg1.han@samsung.com
Subject: Re: [RFC PATCH RESEND v2] of/pci: Provide support for parsing PCI
 DT ranges property
Message-ID: <20130306094255.GA9814@arm.com>
References: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
 <5130C59E.8020702@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5130C59E.8020702@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Mar 2013 09:42:57.0358 (UTC) FILETIME=[FBBD46E0:01CE1A4E]
X-MC-Unique: 113030609425901501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 03:13:34PM +0000, Rob Herring wrote:
> On 03/01/2013 06:23 AM, Andrew Murray wrote:
> > This patch factors out common implementations patterns to reduce overall kernel
> > code and provide a means for host bridge drivers to directly obtain struct
> > resources from the DT's ranges property without relying on architecture specific
> > DT handling. This will make it easier to write archiecture independent host bridge
> > drivers and mitigate against further duplication of DT parsing code.
> > 
> > This patch can be used in the following way:
> > 
> > 	struct of_pci_range_iter iter;
> > 	for_each_of_pci_range(&iter, np) {
> > 
> > 		//directly access properties of the address range, e.g.:
> > 		//iter.pci_space, iter.pci_addr, iter.cpu_addr, iter.size or
> > 		//iter.flags
> > 
> > 		//alternatively obtain a struct resource, e.g.:
> > 		//struct resource res;
> > 		//range_iter_fill_resource(iter, np, res);
> > 	}
> > 
> > Additionally the implementation takes care of adjacent ranges and merges them
> > into a single range (as was the case with powerpc and microblaze).
> > 
> > The modifications to microblaze, mips and powerpc have not been tested.
> > 
> > v2:
> >   This follows on from suggestions made by Grant Likely
> >   (marc.info/?l=linux-kernel&m=136079602806328)
> > 
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> >  arch/microblaze/pci/pci-common.c |  100 +++++++++++--------------------------
> >  arch/mips/pci/pci.c              |   44 ++++-------------
> >  arch/powerpc/kernel/pci-common.c |   93 ++++++++++-------------------------
> >  drivers/of/address.c             |   54 ++++++++++++++++++++
> >  include/linux/of_address.h       |   30 +++++++++++
> >  5 files changed, 151 insertions(+), 170 deletions(-)
> 
> The thing is that this still leaves pci_process_bridge_OF_ranges
> basically identical for microblaze and powerpc which is really what
> needs to be moved out to common code. Obviously, struct pci_controller
> vs. struct pci_sys_data on ARM is an issue, but they all have
> fundamentally the same data.
Yes it does. To make things worse struct pci_controller is duplicated and
pretty much identical between microblaze and powerpc. There is good scope
for getting rid of lots of code here :).

> 
> All these common fields should be in a common PCI controller struct.
> Perhaps introducing this with just what you need would work. Depending
> how invasive moving those fields to a new struct is, you could have a
> wrapper that just copies/translates the fields to the arch specific struct.
Yes I see how this would be a good approach. Though my concern would be how
quirks are handled - if microblaze has the same quirks as powerpc then you'll
see the same duplicated code between those two architectures. Or you'd see
the architecture code pick apart the common pci controller struct... I'll
investigate and see what can be done.

A lack of an accepted way to parse DT ranges on ARM is blocking Thierry,
Thomas and Jingoo from upstreaming their drivers - do you think there is some
middle ground or temporary solution for these drivers?

> 
> There's also things like ioremap of the i/o range. ARM uses a fixed
> virtual address, so we need to do something different. Just returning
> the i/o cpu_addr and moving the ioremap out of this function would solve
> that.
Yes I've noticed this wasn't quite right. I'm not quite sure how this fits
in with the DT. I guess the DT ranges would contain 0 for the PCI address
and a physical address which represents the host bridges I/O range. You
would then use these two addresses as inputs to pci_ioremap_io - and then
set the start address of the struct resource to 0 and pass to
pci_add_resource_offset with io_offset set to 0 - does this seem correct for
ARM?

Andrew Murray
> 
> Rob
> 
> 

