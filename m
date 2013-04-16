Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3DPNgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:36:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34486 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab3DPNgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:36:04 -0400
Date: Tue, 16 Apr 2013 09:35:56 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH v9] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130416133555.GB9241@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
 <20130416102454.GS6858@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416102454.GS6858@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 12:24:54PM +0200, Joerg Roedel wrote:
> On Mon, Apr 15, 2013 at 06:41:17PM -0400, Neil Horman wrote:
> > +#ifdef CONFIG_IRQ_REMAP
> > +static void __init intel_remapping_check(int num, int slot, int func)
> > +{
> > +	u8 revision;
> > +
> > +	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
> > +
> > +	/*
> > +	 * Revision 0x13 of this chipset supports irq remapping
> > +	 * but has an erratum that breaks its behavior, flag it as such
> > +	 */
> > +	if (revision == 0x13)
> > +		irq_remap_broken = 1;
> > +
> > +}
> > +#else
> 
> Any reason why you don't check this in the Intel IOMMU init code? You
> would safe the ifdefs and you don't have to include
> irq-remapping-internal header files somewhere else in the tree.
> 
> 
> 	Joerg
> 
> 
> 
Actually, hold on that last note, the intel iommu init code doesn't seem to
create any direct relationship between the set of iommu's and the pci_dev's that
implement them.  In the intel_irq_remapping_supported path I can loop over each
dmar_dhrd_unit, and interrogate each of the devices on its **devices list to see
if the device/vendor and revision ids match, but looking at the dhrd parsing
code, I'm not sure the iommu pci_dev is always going to be on that list.  That
seems like its going to be pretty ugly in and of itself.  Do you have a
suggested way to identify the pci_dev of the device we need in that path without
having to simply iterate over every device in that scope?

Neil

