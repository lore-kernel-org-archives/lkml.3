Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaBTOrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:47:42 -0500
Received: from dliviu.plus.com ([80.229.23.120]:52028 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbaBTOrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:47:12 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2014 09:47:11 EST
Date: Thu, 20 Feb 2014 14:38:29 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Message-ID: <20140220143829.GA1556@bart.dudau.co.uk>
Mail-Followup-To: Yijing Wang <wangyijing@huawei.com>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
 <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
 <5302FED1.80903@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5302FED1.80903@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Feb 20 14:40:18 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 530613d23191259912610
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:33:53PM +0800, Yijing Wang wrote:
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mm.h>
> > +#include <linux/of_pci.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/slab.h>
> > +
> > +#include <asm/pci-bridge.h>
> > +
> > +
> > +/*
> > + * Return the domain number for this bus
> > + */
> > +int pci_domain_nr(struct pci_bus *bus)
> > +{
> > +	struct pci_host_bridge *bridge = to_pci_host_bridge(bus->bridge);

Hi Yijing,

> 
> Here bus is specific to root bus ? or, what about use find_pci_host_bridge() to get the pci_host_bridge
> instead.

Yes, the call should be to find_pci_host_bridge(). I sort of implied that the
bus is always the root bus, which is obviously not correct. Thanks for pointing it out.

> 
> > +
> > +	if (bridge)
> > +		return bridge->domain_nr;
> > +
> > +	return 0;
> > +}
> > +
> > +int pci_proc_domain(struct pci_bus *bus)
> > +{
> > +	return pci_domain_nr(bus);
> > +}
> > +
> > +/*
> > + * Called after each bus is probed, but before its children are examined
> > + */
> > +void pcibios_fixup_bus(struct pci_bus *bus)
> > +{
> > +	struct pci_dev *dev;
> > +	struct resource *res;
> > +	int i;
> > +
> > +	if (bus->self != NULL) {
> 
> What about use !pci_is_root_bus() ?

Again, good call, will change.

> 
> > +		pci_read_bridge_bases(bus);
> > +
> > +		pci_bus_for_each_resource(bus, res, i) {
> > +			if (!res || !res->flags || res->parent)
> > +				continue;
> > +
> > +			/*
> > +			 * If we are going to reassign everything, we can
> > +			 * shrink the P2P resource to have zero size to
> > +			 * save space
> > +			 */
> > +			if (pci_has_flag(PCI_REASSIGN_ALL_RSRC)) {
> > +				res->flags |= IORESOURCE_UNSET;
> > +				res->start = 0;
> > +				res->end = -1;
> > +				continue;
> > +			}
> > +		}
> > +	}
> > +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

