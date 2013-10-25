Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3JYQis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:38:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43987 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3JYQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:38:47 -0400
Date: Fri, 25 Oct 2013 12:38:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Santosh.Jodh@citrix.com, JBeulich@suse.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, mukesh.rathor@oracle.com,
        xhejtman@ics.muni.cz, yuval.shaia@oracle.com
Subject: Re: [v1 1/2] xen/p2m: Create identity mappings for PFNs beyound E820
 and PCI BARs
Message-ID: <20131025163826.GA5320@phenom.dumpdata.com>
References: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
 <1382713401-4882-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382713401-4882-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:03:20AM -0400, Konrad Rzeszutek Wilk wrote:
> On bootup the E820 "gaps" or E820_RESV regions are marked as
> identity regions. Meaning that any lookup done in the P2M
> will return the same value: pfn_to_mfn(pfn) == pfn.
> 
> This is needed for PCI devices so that drivers can reference
> the correct bus address. Unfortunatly there are also PCIe
> devices which setup their MMIO region above the E820. By default
> we assume in the P2M that any region above the last E820 entry
> is to be used for ballooning. That is not true - and we don't
> mark such regions as IDENTIY_FRAME but INVALID_P2M_ENTRY.
> The result is that any lookup in the P2M (pfn_to_mfn(pfn) == 0)
> gets us the 0 bus address which is hardly correct.
> 
> A solution that this patch implements is to walk the PCI device
> BAR regions and mark them as IDENTITY_FRAMEs in the P2M.
> Naturally some checks are needed such as making sure that the
> BAR regions are not part of the balloon pages, nor regular RAM.
> 
> We only set them to IDENTITY if the:
>  pfn_to_mfn(pfn) == INVALID_P2M_ENTRY.
> 
> Another solution would be to mark all P2M entries beyond the
> last E820 entry _and_ not in the balloon regions as IDENTITY.
> 
> If done, that means in worst case we have to reserve MAX_DOMAIN_PAGES
> pages (so 2MB) of virtual space in case we have to create
> new P2M leafs. We could be fancy and make the P2M code understand
> p2m_mid_missing and p2_mid_identity and do the right things.
> But that is quite complex while this particular patch only
> gets invoked if there are PCI devices. Another solution (David
> Vrabel ideas) was to consider INVALID_P2M_ENTRY as 1-1 regions.
> The author of this patch is not sure of the ramifications
> as it would require surgery in various P2M codebits.
> 
> Reported-by: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Reported-by: Lance Larsh <lance.larsh@oracle.com>
> CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> CC: David Vrabel <david.vrabel@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/balloon.c | 19 +++++++++++++
>  drivers/xen/pci.c     | 79 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  include/xen/balloon.h |  1 +
>  3 files changed, 96 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index b232908..258e3f9 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -133,6 +133,25 @@ static void balloon_append(struct page *page)
>  	adjust_managed_page_count(page, -1);
>  }
>  
> +/*
> + * Check if any the balloon pages overlap with the supplied
> + * pfn and its range.
> + */
> +bool balloon_pfn(unsigned long pfn, unsigned long nr)
> +{
> +	struct page *page;
> +
> +	if (list_empty(&ballooned_pages))
> +		return false;
> +
> +	list_for_each_entry(page, &ballooned_pages, lru) {
> +		unsigned long b_pfn = page_to_pfn(page);
> +
> +		if (b_pfn >= pfn && b_pfn < pfn + nr)
> +			return true;
> +	}
> +	return false;
> +}
>  /* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
>  static struct page *balloon_retrieve(bool prefer_highmem)
>  {
> diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
> index 18fff88..6b86eda 100644
> --- a/drivers/xen/pci.c
> +++ b/drivers/xen/pci.c
> @@ -22,6 +22,9 @@
>  #include <xen/xen.h>
>  #include <xen/interface/physdev.h>
>  #include <xen/interface/xen.h>
> +#include <xen/interface/memory.h>
> +#include <xen/page.h>
> +#include <xen/balloon.h>
>  
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> @@ -127,6 +130,72 @@ static int xen_add_device(struct device *dev)
>  	return r;
>  }
>  
> +static void xen_p2m_add_device(struct device *dev)
> +{
> +	int i;
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +
> +	/* Verify whether the MMIO BARs are 1-1 in the P2M. */
> +	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> +		unsigned long pfn, start, end, ok_pfns;
> +		char bus_addr[64];
> +		char *fmt;
> +
> +		if (!pci_resource_len(pci_dev, i))
> +			continue;
> +
> +		if (pci_resource_flags(pci_dev, i) == IORESOURCE_IO)
> +			fmt = " (bus address [%#06llx-%#06llx])";
> +		else
> +			fmt = " (bus address [%#010llx-%#010llx])";
> +
> +		snprintf(bus_addr, sizeof(bus_addr), fmt,
> +			 (unsigned long long) (pci_resource_start(pci_dev, i)),
> +			 (unsigned long long) (pci_resource_end(pci_dev, i)));
> +
> +		start = pci_resource_start(pci_dev, i) >> PAGE_SHIFT;
> +		end = pci_resource_end(pci_dev, i) >> PAGE_SHIFT;
> +
> +		/*
> +		 * We don't worry about the balloon scratch page as it has a
> +		 * valid PFN - which means we will catch in the loop below.
> +		 */
> +		if (balloon_pfn(start, end - start)) {
> +			dev_warn(dev, "%s is within balloon pages!\n", bus_addr);
> +			continue;
> +		}
> +
> +		for (ok_pfns = 0, pfn = start; pfn < end; pfn++) {
> +			unsigned long mfn = pfn_to_mfn(pfn);
> +
> +			if (mfn == pfn) {
> +				ok_pfns++;
> +				continue;
> +			}
> +			if (mfn != INVALID_P2M_ENTRY) { /* RAM */
> +				dev_warn(dev, "%s is within RAM [%lx] region!\n", bus_addr, pfn);
> +				break;
> +			}
> +		}
> +		if (ok_pfns == end - start) /* All good. */
> +			continue;
> +
> +		if (pfn != end - 1) /* We broke out of the loop above. */
> +			continue;

There are some bugs in this code so please wait until the next posting
which hopefully will also include me testing it on affected hardware.
