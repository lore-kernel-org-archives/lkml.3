Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3CBUOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 15:14:08 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40879 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3CBUOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 15:14:06 -0500
Date: Sat, 2 Mar 2013 15:13:56 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130302201356.GB13985@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <51322709.6060702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51322709.6060702@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 11:21:29AM -0500, Prarit Bhargava wrote:
> On 03/01/2013 12:17 PM, Neil Horman wrote:
> > A few years back intel published a spec update:
> > http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> > 
> > For the 5520 and 5500 chipsets which contained an errata (specificially errata
> > 53), which noted that these chipsets can't properly do interrupt remapping, and
> > as a result the recommend that interrupt remapping be disabled in bios.  While
> > many vendors have a bios update to do exactly that, not all do, and of course
> > not all users update their bios to a level that corrects the problem.  As a
> > result, occasionally interrupts can arrive at a cpu even after affinity for that
> > interrupt has be moved, leading to lost or spurrious interrupts (usually
> > characterized by the message:
> > kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> > 
> > There have been several incidents recently of people seeing this error, and
> > investigation has shown that they have system for which their BIOS level is such
> > that this feature was not properly turned off.  As such, it would be good to
> > give them a reminder that their systems are vulnurable to this problem.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Prarit Bhargava <prarit@redhat.com>
> > CC: Don Zickus <dzickus@redhat.com>
> > CC: Don Dutile <ddutile@redhat.com>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Asit Mallick <asit.k.mallick@intel.com>
> > CC: linux-pci@vger.kernel.org
> > ---
> >  drivers/iommu/intel_irq_remapping.c | 20 ++++++++++++++++++++
> >  include/linux/pci_ids.h             |  2 ++
> >  2 files changed, 22 insertions(+)
> > 
> > diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> > index f3b8f23..9bfb6c2 100644
> > --- a/drivers/iommu/intel_irq_remapping.c
> > +++ b/drivers/iommu/intel_irq_remapping.c
> > @@ -1113,3 +1113,23 @@ struct irq_remap_ops intel_irq_remap_ops = {
> >  	.msi_setup_irq		= intel_msi_setup_irq,
> >  	.setup_hpet_msi		= intel_setup_hpet_msi,
> >  };
> > +
> > +
> > +static void intel_remapping_check(struct pci_dev *dev)
> > +{
> > +	u8 revision;
> > +
> > +	pci_read_config_byte(dev, PCI_REVISION_ID, &revision);
> > +
> > +	if ((revision == 0x13) && irq_remapping_enabled) {
> > +		pr_warn("WARNING WARNING WARNING WARNING WARNING WARNING\n"
> > +			"This system BIOS has enabled interrupt remapping\n"
> > +			"on a chipset that contains an errata making that\n"
> > +			"feature unstable.  Please reboot with nointremap\n"
> > +			"added to the kernel command line and contact\n"
> > +			"your BIOS vendor for an update");
> 
> Make this one line?  Might be too long but I believe the preferred policy is now
> to keep the output on one line so that it is easy to find in the kernel source.
> 
> Also, IMO, remove the WARNING WARNING stuff.
> 
> You also should probably use HW_ERR here too.
> 
> P.
> 
I can do that, I'll post version 2 on monday.
Neil

