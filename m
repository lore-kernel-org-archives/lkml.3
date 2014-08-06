Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaHFUKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:10:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25688 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaHFUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:10:11 -0400
Date: Wed, 6 Aug 2014 16:09:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: gregkh@linuxfoundation.org, boris.ostrovsky@oracle.com,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH v5] Fixes to Xen pciback for 3.17.
Message-ID: <20140806200959.GA1570@laptop.dumpdata.com>
References: <75613802.20140805104438@eikelenboom.it>
 <53E0A45C.4050400@citrix.com>
 <1985206568.20140805114433@eikelenboom.it>
 <20140805134930.GE13057@laptop.dumpdata.com>
 <1724263917.20140805160443@eikelenboom.it>
 <182103485.20140806205959@eikelenboom.it>
 <20140806191831.GB30062@laptop.dumpdata.com>
 <1081188855.20140806212559@eikelenboom.it>
 <20140806193916.GA31040@laptop.dumpdata.com>
 <276705485.20140806214743@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276705485.20140806214743@eikelenboom.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 09:47:43PM +0200, Sander Eikelenboom wrote:
> 
> Wednesday, August 6, 2014, 9:39:16 PM, you wrote:
> 
> > On Wed, Aug 06, 2014 at 09:25:59PM +0200, Sander Eikelenboom wrote:
> >> 
> >> Wednesday, August 6, 2014, 9:18:31 PM, you wrote:
> >> 
> >> > On Wed, Aug 06, 2014 at 08:59:59PM +0200, Sander Eikelenboom wrote:
> >> >> 
> >> >> Tuesday, August 5, 2014, 4:04:43 PM, you wrote:
> >> >> 
> >> >> 
> >> >> > Tuesday, August 5, 2014, 3:49:30 PM, you wrote:
> >> >> 
> >> >> >> On Tue, Aug 05, 2014 at 11:44:33AM +0200, Sander Eikelenboom wrote:
> >> >> >>> 
> >> >> >>> Tuesday, August 5, 2014, 11:31:08 AM, you wrote:
> >> >> >>> 
> >> >> >>> > On 05/08/14 09:44, Sander Eikelenboom wrote:
> >> >> >>> >> 
> >> >> >>> >> Monday, August 4, 2014, 8:43:18 PM, you wrote:
> >> >> >>> >> 
> >> >> >>> >>> On Fri, Aug 01, 2014 at 04:30:05PM +0100, David Vrabel wrote:
> >> >> >>> >>>> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> >> >> >>> >>>>> Greg: goto GHK
> >> >> >>> >>>>>
> >> >> >>> >>>>> This is v5 version of patches to fix some issues in Xen PCIback.
> >> >> >>> >>>>
> >> >> >>> >>>> Applied to devel/for-linus-3.17.
> >> >> >>> >> 
> >> >> >>> >>> Thank you.
> >> >> >>> >>>>
> >> >> >>> >>>> I dropped the stable Cc for #2 pending a final decision on whether it
> >> >> >>> >>>> really is a stable candidate.
> >> >> >>> >> 
> >> >> >>> >>> OK.
> >> >> >>> >>>>
> >> >> >>> >>>> David
> >> >> >>> >> 
> >> >> >>> >> Hi Konrad / David,
> >> >> >>> >> 
> >> >> >>> >> This series still lacks a resolution on the sysfs /do_flr /reset,
> >> >> >>> >> as a result the pci devices are not reset after shutdown of a guest.
> >> >> >>> >> (no more pciback 0000:xx:xx.x: restoring config space at offset xxx)
> >> >> >>> >> 
> >> >> >>> >> So this series now introduces a regression to 3.16, which causes devices to malfunction 
> >> >> >>> >> after a guest reboot or after assigning the devices to another guest.
> >> >> >>> 
> >> >> >>> > I don't follow what you're saying.  The lack of a device reset for PCI
> >> >> >>> > devices with no FLR method isn't a regression as this has never worked.
> >> >> >>> >  Can you explain in more detail what the regression is and which patch
> >> >> >>> > caused it?
> >> >> >>> 
> >> >> >>> I haven't bisected it to a specific patch in this series,
> >> >> >>> but this patch series (when pulled on top of 3.16) cause the following:
> >> >> >>> 
> >> >> >>> - Do a system start and HVM guest start
> >> >> >>> - HVM guest with pci passthrough, devices work fine
> >> >> >>> - shutdown the HVM guest
> >> >> >>> - "pciback 0000:xx:xx.x: restoring config space at offset xxx" messages do not
> >> >> >>>   appear anymore when shutting down the HVM guest (as they do with vanilla 3.16)
> >> >> >>> - Starting the HVM guest again with the same devices passed through.
> >> >> >>> - Devices malfunction (for example a USB host controller will fail a simple 
> >> >> >>>   "lsusb"
> >> >> >>> - And this all works fine on vanilla 3.16.  
> >> >> 
> >> >> >> Hm, the only patch that makes code changes is 63fc5ec97cc54257d1c4ee49ed2131f754a5ff9b
> >> >> >> "xen/pciback: Don't deadlock when unbinding."
> >> >> >> but it does not change any of that code path. Only figures out whether
> >> >> >> to take a lock or not.
> >> >> 
> >> >> > Ok and the do_flr nack by david is unrelated to this part (i didn't check just 
> >> >> > assumed there could be a connection)
> >> >> 
> >> >> >> I will try it out on my box and see if I can reproduce it.
> >> >> 
> >> >> >> And just to be 100% sure - you are using vanilla Xen? No changes on top
> >> >> >> of it?
> >> >> 
> >> >> > Except the fix from jan for the pirq/msi stuff (and an unrelated hpet one), other than that no.
> >> >> > If you can't reproduce i will see if i can dive deeper into it tonight !
> >> >> 
> >> >> Hi Konrad,
> >> >> 
> >> >> It looks like the issues is this part of the change:
> >> >> 
> >> >>     --- a/drivers/xen/xen-pciback/pci_stub.c
> >> >>     +++ b/drivers/xen/xen-pciback/pci_stub.c
> >> >>     @@ -250,6 +250,8 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
> >> >>     * - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
> >> >>     *
> >> >>     * As such we have to be careful.
> >> >>     + *
> >> >>     + * To make this easier, the caller has to hold the device lock.
> >> >>     */
> >> >>     void pcistub_put_pci_dev(struct pci_dev *dev)
> >> >>     {
> >> >>     @@ -276,11 +278,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >> >>     /* Cleanup our device
> >> >>     * (so it's ready for the next domain)
> >> >>     */
> >> >>     -
> >> >>     - /* This is OK - we are running from workqueue context
> >> >>     - * and want to inhibit the user from fiddling with 'reset'
> >> >>     - */
> >> >>     - pci_reset_function(dev);
> >> >>     + lockdep_assert_held(&dev->dev.mutex);
> >> >>     + __pci_reset_function_locked(dev);
> >> >>     pci_restore_state(dev);
> >> >>    /* This disables the device. */
> >> >> 
> >> >> More specifically:
> >> >> The old "pci_reset_function(dev)" potentially seems to do much more than 
> >> >> __pci_reset_function_locked(dev).
> >> >> 
> >> >> 
> >> >> "__pci_reset_function_locked(dev)" only calls  "__pci_dev_reset"
> >> >> while "pci_reset_function" not only calls pci_dev_reset, but on succes
> >> >> it also calls: "pci_dev_save_and_disable" which does a save state etc.
> >> >> 
> >> >> 
> >> >> So i added a little more debug:
> >> >> 
> >> >> device_lock_assert(&dev->dev);
> >> >> ret = __pci_reset_function_locked(dev);
> >> >> dev_dbg(&dev->dev, "%s __pci_reset_function_locked:%d  dev->state_saved:%d\n", __func__, ret, (!dev->state_saved) ? 0 : 1 );
> >> >> pci_restore_state(dev);
> >> >> 
> >> >> And this returns:
> >> >> [  494.570579] pciback 0000:04:00.0: pcistub_put_pci_dev __pci_reset_function_locked:0  dev->state_saved:0
> >> >> 
> >> >> So that confirms there is no saved_state to get restored by 
> >> >> pci_restore_state(dev) in the next line.
> >> >> 
> >> >> However there seems to be no "locked" variant of the function 
> >> >> "pci_reset_function" in pci.c that has all the same logic ...
> >> 
> >> > Yup. I've a preliminary patch:
> >> 
> >> Preliminary in the sense: "this should fix it .. needs more testing" ?
> 
> > This should fix it, albeit the fix has a disastrous flaw. Here is the proper version:
> 
> 
> > From 00a5b6e3c9ee2c2d605879bdaebc627fa640b024 Mon Sep 17 00:00:00 2001
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Date: Wed, 6 Aug 2014 16:21:32 -0400
> > Subject: [PATCH] xen/pciback: Restore configuration space when detaching from
> >  a guest.
> 
> > The commit 9eea3f7695226f9af9992cebf8e98ac0ad78b277
> > "xen/pciback: Don't deadlock when unbinding." was using
> > the version of pci_reset_function which would lock the device lock.
> > That is no good as we can dead-lock. As such we swapped to using
> > the lock-less version and requiring that the callers
> > of 'pcistub_put_pci_dev' take the device lock. And as such
> > this bug got exposed.
> 
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
> 
> > To still retain the PCI configuration space, we save it once
> > more and store it on our private copy to be restored when:
> >  - Device is unbinded from pciback
> >  - Device is detached from a guest.
> 
> > Reported-by:  Sander Eikelenboom <linux@eikelenboom.it>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/xen-pciback/pci_stub.c |   25 +++++++++++++++++++++----
> >  1 files changed, 21 insertions(+), 4 deletions(-)
> 
> > diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
> > index 1ddd22f..8cf7f2b 100644
> > --- a/drivers/xen/xen-pciback/pci_stub.c
> > +++ b/drivers/xen/xen-pciback/pci_stub.c
> > @@ -105,7 +105,7 @@ static void pcistub_device_release(struct kref *kref)
> >          */
> >         __pci_reset_function_locked(dev);
> >         if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> > -               dev_dbg(&dev->dev, "Could not reload PCI state\n");
> > +               dev_info(&dev->dev, "Could not reload PCI state\n");
> >         else
> >                 pci_restore_state(dev);
> >  
> > @@ -257,6 +257,7 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >  {
> >         struct pcistub_device *psdev, *found_psdev = NULL;
> >         unsigned long flags;
> > +       struct xen_pcibk_dev_data *dev_data;
> >  
> >         spin_lock_irqsave(&pcistub_devices_lock, flags);
> >  
> > @@ -279,9 +280,25 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >          * (so it's ready for the next domain)
> >          */
> >         device_lock_assert(&dev->dev);
> > -       __pci_reset_function_locked(dev);
> > -       pci_restore_state(dev);
> > -
> > +       dev_data = pci_get_drvdata(dev);
> > +       if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> > +               dev_info(&dev->dev, "Could not reload PCI state\n");
> > +       else {
> > +               __pci_reset_function_locked(dev);
> > +               /*
> > +                * The usual sequence is pci_save_state & pci_restore_state
> > +                * but the guest might have messed the configuration space up.
> > +                * Use the initial version (when device was binded to us).
> > +                */
> > +               pci_restore_state(dev);
> > +               /*
> > +                * The next steps are to reload the configuration for the
> > +                * next time we bind & unbind to a guest - or unload from
> > +                * pciback.
> > +                */
> > +               pci_save_state(dev);
> > +               dev_data->pci_saved_state = pci_store_saved_state(dev);
> > +       }
> >         /* This disables the device. */
> >         xen_pcibk_reset_device(dev);
> >  
> 
> 
> Is it save to have "__pci_reset_function_locked(dev)" to be conditional on succes of 
> "pci_load_and_free_saved_state" ?

It could be redone a bit differently - as in:

 rc = pci_load_and_free_saved_state(..);
 __pci_reset_function_locked(dev);
 if (!rc) {
	pci_restore_state(dev);
	...

In which case we will only do the restore state (and save state) when the device
is in expected state. And the reset happens at that point.

> 
> Or is it safer because you don't reset the device although it's in an unknown 
> state (and resetting it while it's back to dom0 could lead to more problems  ?)

It could very well lead to disaster. I am not exactly sure what the ramifications
are with a device for which we cannot save PCI configuration space - aka - extremely
borked.

> 
