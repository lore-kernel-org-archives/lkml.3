Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3CUQGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:06:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54131 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab3CUQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:06:30 -0400
Date: Thu, 21 Mar 2013 17:06:25 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC PATCH RESEND v2] of/pci: Provide support for parsing PCI
 DT ranges property
Message-ID: <20130321170625.2a1bf226@skate>
In-Reply-To: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
References: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Murray,

On Fri,  1 Mar 2013 12:23:36 +0000, Andrew Murray wrote:
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

Thanks, I've tested this successfully with the Marvell PCIe driver. I'm
about to send a new version of the Marvell PCIe patch set that includes
this RFC proposal.

I only made two small changes compared to your version, detailed below.


> +#define for_each_of_pci_range(iter, np) \
> +	for (; of_pci_process_ranges(iter, np);)

In the initial part of the loop, I added a memset() to initialize to
zero the "iter" structure. Otherwise, if you forget to do it before
calling of_pci_process_ranges(), it may crash (depending on the random
values present in the uninitialized structure).

> +#define range_iter_fill_resource(iter, np, res) \
> +	do { \
> +		res->flags = iter.flags; \
> +		res->start = iter.cpu_addr; \
> +		res->end = iter.cpu_addr + iter.size - 1; \
> +		res->parent = res->child = res->sibling = NULL; \
> +		res->name = np->full_name; \
> +	} while (0)

And here, I enclosed all the usage of the macro parameters in
parenthesis. Like (res)->flags instead of res->flags. If you don't do
that, then passing &foobar as the 'res' parameter causes some
compilation failure because &foobar->res is not valid, while
(&foobar)->res is.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
