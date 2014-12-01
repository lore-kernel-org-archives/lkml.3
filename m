Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaLAWI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:08:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25898 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaLAWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:08:26 -0500
Date: Mon, 1 Dec 2014 16:59:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, linux@eikelenboom.it
Subject: Re: [Xen-devel] [PATCH v4 7/7] xen/pciback: Restore configuration
 space when detaching from a guest.
Message-ID: <20141201215927.GH24289@laptop.dumpdata.com>
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
 <1416608271-18931-8-git-send-email-konrad.wilk@oracle.com>
 <547C77E0.5060607@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C77E0.5060607@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:14:56PM +0000, David Vrabel wrote:
> On 21/11/14 22:17, Konrad Rzeszutek Wilk wrote:
> > The commit "xen/pciback: Don't deadlock when unbinding." was using
> > the version of pci_reset_function which would lock the device lock.
> > That is no good as we can dead-lock. As such we swapped to using
> > the lock-less version and requiring that the callers
> > of 'pcistub_put_pci_dev' take the device lock. And as such
> > this bug got exposed.
> > 
> > Using the lock-less version is  OK, except that we tried to
> > use 'pci_restore_state' after the lock-less version of
> > __pci_reset_function_locked - which won't work as 'state_saved'
> > is set to false. Said 'state_saved' is a toggle boolean that
> > is to be used by the sequence of a) pci_save_state/pci_restore_state
> > or b) pci_load_and_free_saved_state/pci_restore_state. We don't
> > want to use a) as the guest might have messed up the PCI
> > configuration space and we want it to revert to the state
> > when the PCI device was binded to us. Therefore we pick
> > b) to restore the configuration space.
> > 
> > We restore from our 'golden' version of PCI configuration space, when an:
> >  - Device is unbinded from pciback
> >  - Device is detached from a guest.
> > 
> > Reported-by:  Sander Eikelenboom <linux@eikelenboom.it>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/xen-pciback/pci_stub.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
> > index 843a2ba..eb8b58e 100644
> > --- a/drivers/xen/xen-pciback/pci_stub.c
> > +++ b/drivers/xen/xen-pciback/pci_stub.c
> > @@ -105,7 +105,7 @@ static void pcistub_device_release(struct kref *kref)
> >  	 */
> >  	__pci_reset_function_locked(dev);
> >  	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> > -		dev_dbg(&dev->dev, "Could not reload PCI state\n");
> > +		dev_info(&dev->dev, "Could not reload PCI state\n");
> 
> Why dev_info when...
> 
> > @@ -279,9 +281,19 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >  	 * (so it's ready for the next domain)
> >  	 */
> >  	device_lock_assert(&dev->dev);
> > -	__pci_reset_function_locked(dev);
> > -	pci_restore_state(dev);
> > -
> > +	dev_data = pci_get_drvdata(dev);
> > +	ret = pci_load_saved_state(dev, dev_data->pci_saved_state);
> > +	if (ret < 0)
> > +		dev_warn(&dev->dev, "Could not reload PCI state\n");
> 
> ... this one is dev_warn?

Should be the same, dev_info I think?
> 
> > +	else {
> > +		__pci_reset_function_locked(dev);
> 
> I think the reset should always be attempted regardless of whether the
> correct state was loaded or not.

/me nods. Will redo it as such.
> 
> David
