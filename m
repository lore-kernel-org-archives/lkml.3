Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaGWAWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:22:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914AbaGWAWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:22:11 -0400
Message-ID: <1406074923.4463.45.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: Add device specific (non)reset for AMD GPUs
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2014 18:22:03 -0600
In-Reply-To: <20140722215259.GE19181@google.com>
References: <20140716190955.4722.25453.stgit@gimli.home>
	 <20140722195557.GD19181@google.com> <1406060607.4463.36.camel@ul30vt.home>
	 <20140722215259.GE19181@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 15:52 -0600, Bjorn Helgaas wrote:
> On Tue, Jul 22, 2014 at 02:23:27PM -0600, Alex Williamson wrote:
> > On Tue, 2014-07-22 at 13:55 -0600, Bjorn Helgaas wrote:
> > > On Wed, Jul 16, 2014 at 01:14:08PM -0600, Alex Williamson wrote:
> > > > There are numerous ATI/AMD GPUs available that report that they
> > > > support a PM reset (NoSoftRst-) but for which such a reset has no
> > > > apparent effect on the device.  These devices continue to display the
> > > > same framebuffer across PM reset and the fan speed remains constant,
> > > > while a proper bus reset causes the display to lose sync and the fan
> > > > to reset to high speed.  Create a device specific reset for ATI vendor
> > > > devices that tries to catch these devices and report that
> > > > pci_reset_function() is not supported.
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > > 
> > > > This patch makes the series "vfio-pci: Reset improvements" far more
> > > > useful for users with one of these GPUs.  If pci_reset_function()
> > > > indicates that it's supported and successful, then I have no reason
> > > > to resort to a bus/slot reset in the vfio-pci code.  Since it doesn't
> > > > seem to do anything anyway, let's just forget that PM reset exists
> > > > for these devices.
> > > > 
> > > >  drivers/pci/quirks.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 53 insertions(+)
> > > > 
> > > > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > > > index 460c354..bed9c63 100644
> > > > --- a/drivers/pci/quirks.c
> > > > +++ b/drivers/pci/quirks.c
> > > > @@ -3289,6 +3289,57 @@ static int reset_chelsio_generic_dev(struct pci_dev *dev, int probe)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Numerous AMD/ATI GPUs report that they're capable of PM reset (NoSoftRst-)
> > > > + * and pci_reset_function() reports the device as successfully reset, but
> > > > + * there's no apparent effect from the reset.  Test for these, being sure to
> > > > + * allow FLR should it ever exist, and use the device specific reset to
> > > > + * disable any sort of function-local reset if only PM reset is available.
> > > > + */
> > > > +static int reset_ati_gpu(struct pci_dev *dev, int probe)
> > > > +{
> > > > +	u16 pm_csr;
> > > > +	u32 devcap;
> > > > +	int af_pos;
> > > > +
> > > > +	/*
> > > > +	 * VGA class devices, not on the root bus, PCI function 0 of a
> > > > +	 * multifunction device with PM capabilities
> > > > +	 */
> > > > +	if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA ||
> > > > +	    pci_is_root_bus(dev->bus) || PCI_FUNC(dev->devfn) ||
> > > > +	    !dev->multifunction || !dev->pm_cap)
> > > > +		return -ENOTTY;
> > > > +
> > > > +	/* PM reports NoSoftRst- */
> > > > +	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pm_csr);
> > > > +	if (pm_csr & PCI_PM_CTRL_NO_SOFT_RESET)
> > > > +		return -ENOTTY;
> > > > +
> > > > +	/* No PCIe FLR */
> > > > +	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &devcap);
> > > > +	if (devcap & PCI_EXP_DEVCAP_FLR)
> > > > +		return -ENOTTY;
> > > > +
> > > > +	/* No AF FLR */
> > > > +	af_pos = pci_find_capability(dev, PCI_CAP_ID_AF);
> > > > +	if (af_pos) {
> > > > +		u8 af_cap;
> > > > +
> > > > +		pci_read_config_byte(dev, af_pos + PCI_AF_CAP, &af_cap);
> > > > +		if ((af_cap && PCI_AF_CAP_TP) && (af_cap && PCI_AF_CAP_FLR))
> > > > +			return -ENOTTY;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * We could attempt a singleton bus/slot reset here to override
> > > > +	 * PM reset priority over these, but the devices we're interested
> > > > +	 * in are multifunction GPU + audio devices in their known configs.
> > > > +	 */
> > > > +
> > > > +	return -EINVAL;
> > > > +}
> > > > +
> > > >  #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
> > > >  #define PCI_DEVICE_ID_INTEL_IVB_M_VGA      0x0156
> > > >  #define PCI_DEVICE_ID_INTEL_IVB_M2_VGA     0x0166
> > > > @@ -3304,6 +3355,8 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
> > > >  		reset_intel_generic_dev },
> > > >  	{ PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
> > > >  		reset_chelsio_generic_dev },
> > > > +	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > > > +		reset_ati_gpu },
> > > 
> > > I'm a little confused, but maybe we just need a comment about what the
> > > return values from pci_dev_specific_reset() mean.  Based on reading
> > > __pci_dev_reset(), it looks like:
> > > 
> > >   0 means "I support this reset method" (if probe) or
> > >   "I performed this reset" (if !probe),
> > >   
> > >   ENOTTY means "I don't support this reset method, try another one",
> > > 
> > >   anything else means "I don't support this reset method and don't try
> > >   any others" (it'd be useful to know what this is good for).
> > > 
> > > But reset_ati_gpu() never returns 0, so it seems like your patch makes
> > > it so we can never reset any ATI device at all.  So I must be missing
> > > something.
> > 
> > Nope, you're not missing anything.  The return value behavior is exactly
> > as you describe and the ATI GPUs that advertise NoSoftRst- don't appear
> > to do any sort of reset when moving them back from D3, so I'm
> > effectively trying to negate that as a viable reset option.  I think
> > this is what the anything-else return value is meant for.  I only return
> > "I don't support this reset method and don't try any others" after I
> > verify there are no other options, so if they come out with FLR support,
> > that would still get precedence.  It's a little awkward, but I don't
> > know how to test whether a reset function was successful.  It seems like
> > it would be device specific.  Anyone from AMD reading the list that can
> > comment on what sort of reset happens on these GPUs for a D3->D0 reset?
> 
> I was expecting to see "return 0" for some of the cases, e.g., maybe
> for non-GPU devices that support FLR or AF FLR.
> 
> You currently always return -ENOTTY or -EINVAL, which means we won't
> support any kind of reset on any ATI device.  It looks like most ATI
> devices are graphics, but there are a few IDE, USB, SMBus, SATA, etc.
> devices that look like they'll be caught by this quirk.  That doesn't
> sound like what you intend.

The goal of the function is to identify a GPU (VGA) device that only
supports PM reset and return -EINVAL to indicate we can't do a function
level reset.  Any other case returns -ENOTTY to indicate we don't handle
the device, try something else.  This function therefore never returns 0
because it doesn't provide a reset mechanism of its own.  It only blocks
the known useless reset or defers to a standard reset.  Anything that's
not a class VGA display drops out through the first -ENOTTY path.  I
think it's doing what I intend, but maybe you're still spotting
something wrong with my methodology.  Thanks,

Alex

