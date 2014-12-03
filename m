Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLCUbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:31:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32218 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:30:58 -0500
Date: Wed, 3 Dec 2014 10:52:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, linux@eikelenboom.it
Subject: Re: [Xen-devel] [PATCH v4 7/7] xen/pciback: Restore configuration
 space when detaching from a guest.
Message-ID: <20141203155208.GC3081@laptop.dumpdata.com>
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
 <1416608271-18931-8-git-send-email-konrad.wilk@oracle.com>
 <547E4736.5000303@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547E4736.5000303@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 06:11:50PM -0500, Boris Ostrovsky wrote:
> On 11/21/2014 05:17 PM, Konrad Rzeszutek Wilk wrote:
> >The commit "xen/pciback: Don't deadlock when unbinding." was using
> >the version of pci_reset_function which would lock the device lock.
> >That is no good as we can dead-lock. As such we swapped to using
> >the lock-less version and requiring that the callers
> >of 'pcistub_put_pci_dev' take the device lock. And as such
> >this bug got exposed.
> >
> >Using the lock-less version is  OK, except that we tried to
> >use 'pci_restore_state' after the lock-less version of
> >__pci_reset_function_locked - which won't work as 'state_saved'
> >is set to false. Said 'state_saved' is a toggle boolean that
> >is to be used by the sequence of a) pci_save_state/pci_restore_state
> >or b) pci_load_and_free_saved_state/pci_restore_state. We don't
> >want to use a) as the guest might have messed up the PCI
> >configuration space and we want it to revert to the state
> >when the PCI device was binded to us. Therefore we pick
> >b) to restore the configuration space.
> 
> 
> Doesn't this all mean that patch 1/7 broke pcistub_put_pci_dev()?

It fixed it (there was a deadlock there).

But the fix to the dead-lock exposed this bug.

One could say that 1/7 broke it because it never worked in the
first place, but now that it works (thanks to #1)  - it did not
work right?

Squashing the patches together is a bit too much I fear.

> 
> -boris
> 
> 
> >
> >We restore from our 'golden' version of PCI configuration space, when an:
> >  - Device is unbinded from pciback
> >  - Device is detached from a guest.
> >
> >Reported-by:  Sander Eikelenboom <linux@eikelenboom.it>
> >Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >---
> >  drivers/xen/xen-pciback/pci_stub.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
> >index 843a2ba..eb8b58e 100644
> >--- a/drivers/xen/xen-pciback/pci_stub.c
> >+++ b/drivers/xen/xen-pciback/pci_stub.c
> >@@ -105,7 +105,7 @@ static void pcistub_device_release(struct kref *kref)
> >  	 */
> >  	__pci_reset_function_locked(dev);
> >  	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> >-		dev_dbg(&dev->dev, "Could not reload PCI state\n");
> >+		dev_info(&dev->dev, "Could not reload PCI state\n");
> >  	else
> >  		pci_restore_state(dev);
> >@@ -257,6 +257,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >  {
> >  	struct pcistub_device *psdev, *found_psdev = NULL;
> >  	unsigned long flags;
> >+	struct xen_pcibk_dev_data *dev_data;
> >+	int ret;
> >  	spin_lock_irqsave(&pcistub_devices_lock, flags);
> >@@ -279,9 +281,19 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >  	 * (so it's ready for the next domain)
> >  	 */
> >  	device_lock_assert(&dev->dev);
> >-	__pci_reset_function_locked(dev);
> >-	pci_restore_state(dev);
> >-
> >+	dev_data = pci_get_drvdata(dev);
> >+	ret = pci_load_saved_state(dev, dev_data->pci_saved_state);
> >+	if (ret < 0)
> >+		dev_warn(&dev->dev, "Could not reload PCI state\n");
> >+	else {
> >+		__pci_reset_function_locked(dev);
> >+		/*
> >+		 * The usual sequence is pci_save_state & pci_restore_state
> >+		 * but the guest might have messed the configuration space up.
> >+		 * Use the initial version (when device was bound to us).
> >+		 */
> >+		pci_restore_state(dev);
> >+	}
> >  	/* This disables the device. */
> >  	xen_pcibk_reset_device(dev);
> 
