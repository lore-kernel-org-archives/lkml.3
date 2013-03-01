Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3CAPNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:13:40 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:35477 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CAPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:13:38 -0500
Message-ID: <5130C59E.8020702@gmail.com>
Date: Fri, 01 Mar 2013 09:13:34 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Murray <Andrew.Murray@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC PATCH RESEND v2] of/pci: Provide support for parsing PCI
 DT ranges property
References: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
In-Reply-To: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 06:23 AM, Andrew Murray wrote:
> This patch factors out common implementations patterns to reduce overall kernel
> code and provide a means for host bridge drivers to directly obtain struct
> resources from the DT's ranges property without relying on architecture specific
> DT handling. This will make it easier to write archiecture independent host bridge
> drivers and mitigate against further duplication of DT parsing code.
> 
> This patch can be used in the following way:
> 
> 	struct of_pci_range_iter iter;
> 	for_each_of_pci_range(&iter, np) {
> 
> 		//directly access properties of the address range, e.g.:
> 		//iter.pci_space, iter.pci_addr, iter.cpu_addr, iter.size or
> 		//iter.flags
> 
> 		//alternatively obtain a struct resource, e.g.:
> 		//struct resource res;
> 		//range_iter_fill_resource(iter, np, res);
> 	}
> 
> Additionally the implementation takes care of adjacent ranges and merges them
> into a single range (as was the case with powerpc and microblaze).
> 
> The modifications to microblaze, mips and powerpc have not been tested.
> 
> v2:
>   This follows on from suggestions made by Grant Likely
>   (marc.info/?l=linux-kernel&m=136079602806328)
> 
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  arch/microblaze/pci/pci-common.c |  100 +++++++++++--------------------------
>  arch/mips/pci/pci.c              |   44 ++++-------------
>  arch/powerpc/kernel/pci-common.c |   93 ++++++++++-------------------------
>  drivers/of/address.c             |   54 ++++++++++++++++++++
>  include/linux/of_address.h       |   30 +++++++++++
>  5 files changed, 151 insertions(+), 170 deletions(-)

The thing is that this still leaves pci_process_bridge_OF_ranges
basically identical for microblaze and powerpc which is really what
needs to be moved out to common code. Obviously, struct pci_controller
vs. struct pci_sys_data on ARM is an issue, but they all have
fundamentally the same data.

All these common fields should be in a common PCI controller struct.
Perhaps introducing this with just what you need would work. Depending
how invasive moving those fields to a new struct is, you could have a
wrapper that just copies/translates the fields to the arch specific struct.

There's also things like ioremap of the i/o range. ARM uses a fixed
virtual address, so we need to do something different. Just returning
the i/o cpu_addr and moving the ioremap out of this function would solve
that.

Rob

