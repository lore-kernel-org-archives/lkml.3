Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaGNPnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:43:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaGNPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:43:00 -0400
Date: Mon, 14 Jul 2014 11:42:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] xen/pciback: Don't deadlock when unbinding.
Message-ID: <20140714154245.GA6989@laptop.dumpdata.com>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
 <1405109332-31659-3-git-send-email-konrad@kernel.org>
 <53C04D81.3010002@oracle.com>
 <20140711210201.GC25233@laptop.dumpdata.com>
 <20140714141328.GA5112@laptop.dumpdata.com>
 <53C3E975.60900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3E975.60900@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:30:13AM -0400, Boris Ostrovsky wrote:
> On 07/14/2014 10:13 AM, Konrad Rzeszutek Wilk wrote:
> >On Fri, Jul 11, 2014 at 05:02:01PM -0400, Konrad Rzeszutek Wilk wrote:
> >>>>--- a/drivers/xen/xen-pciback/pci_stub.c
> >>>>+++ b/drivers/xen/xen-pciback/pci_stub.c
> >>>>@@ -250,6 +250,8 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
> >>>>   *  - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
> >>>>   *
> >>>>   *  As such we have to be careful.
> >>>>+ *
> >>>>+ *  To make this easier, the caller has to hold the device lock.
> >>>Should we assert that the lock is being held?
> >>Yes of course we should. Thank you!
> >How about this:
> >
> > From 388a03c598218dac8bfeb6c5bf3992e0d1e37d1e Mon Sep 17 00:00:00 2001
> >From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >Date: Tue, 8 Jul 2014 11:12:02 -0400
> >Subject: [PATCH] xen/pciback: Don't deadlock when unbinding.
> >
> >As commit 0a9fd0152929db372ff61b0d6c280fdd34ae8bdb
> >'xen/pciback: Document the entry points for 'pcistub_put_pci_dev''
> >explained there are four entry points in this function.
> >Two of them are when the user fiddles in the SysFS to
> >unbind a device which might be in use by a guest or not.
> >
> >Both 'unbind' states will cause a deadlock as the the PCI lock has
> >already been taken, which then pci_device_reset tries to take.
> >
> >We can simplify this by requiring that all callers of
> >pcistub_put_pci_dev MUST hold the device lock. And then
> >we can just call the lockless version of pci_device_reset.
> >
> >To make it even simpler we will modify xen_pcibk_release_pci_dev
> >to quality whether it should take a lock or not - as it ends
> >up calling xen_pcibk_release_pci_dev and needs to hold the lock.
> >
> >Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >---
> >[v2: Per David Vrabel's suggestion - use lockless version of reset]
> >[v3: Per Boris suggestion add assertion mechanism]
> >---
> >  drivers/xen/xen-pciback/passthrough.c |  9 +++++++--
> >  drivers/xen/xen-pciback/pci_stub.c    | 12 ++++++------
> >  drivers/xen/xen-pciback/pciback.h     |  7 ++++---
> >  drivers/xen/xen-pciback/vpci.c        |  9 +++++++--
> >  drivers/xen/xen-pciback/xenbus.c      |  2 +-
> >  5 files changed, 25 insertions(+), 14 deletions(-)
> >
> >diff --git a/drivers/xen/xen-pciback/passthrough.c b/drivers/xen/xen-pciback/passthrough.c
> >index 828dddc..d0c3fb4 100644
> >--- a/drivers/xen/xen-pciback/passthrough.c
> >+++ b/drivers/xen/xen-pciback/passthrough.c
> >@@ -69,7 +69,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
> >  }
> >  static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
> >-					struct pci_dev *dev)
> >+					struct pci_dev *dev, bool lock)
> >  {
> >  	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
> >  	struct pci_dev_entry *dev_entry, *t;
> >@@ -87,8 +87,13 @@ static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
> >  	mutex_unlock(&dev_data->lock);
> >-	if (found_dev)
> >+	if (found_dev) {
> >+		if (lock)
> >+			device_lock(&found_dev->dev);
> >  		pcistub_put_pci_dev(found_dev);
> >+		if (lock)
> >+			device_unlock(&found_dev->dev);
> >+	}
> >  }
> >  static int __xen_pcibk_init_devices(struct xen_pcibk_device *pdev)
> >diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
> >index d57a173..8293fbb 100644
> >--- a/drivers/xen/xen-pciback/pci_stub.c
> >+++ b/drivers/xen/xen-pciback/pci_stub.c
> >@@ -250,6 +250,8 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
> >   *  - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
> >   *
> >   *  As such we have to be careful.
> >+ *
> >+ *  To make this easier, the caller has to hold the device lock.
> >   */
> >  void pcistub_put_pci_dev(struct pci_dev *dev)
> >  {
> >@@ -276,11 +278,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
> >  	/* Cleanup our device
> >  	 * (so it's ready for the next domain)
> >  	 */
> >-
> >-	/* This is OK - we are running from workqueue context
> >-	 * and want to inhibit the user from fiddling with 'reset'
> >-	 */
> >-	pci_reset_function(dev);
> >+	lockdep_assert_held(&dev->dev.mutex);
> >+	__pci_reset_function_locked(dev);
> >  	pci_restore_state(dev);
> 
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> 
> (Although I wonder about the fact that we are exposing the mutex which is
> typically hidden by device_lock()/unlock() inlines. Have you considered
> adding something like is_device_locked() to device.h?)

I did, but this is a bug-fix (which can be backported to stable) so I thought
it would not be nice - as that is more of an API change.

Instead I split it up and there is another patch that makes it
an 'device_lock_assert' function.

And thanks to your idea - I did find two instances where we did
call without a mutex held.

Reposting shortly (will retain your Reviewed-by - please scream if you
prefer that I drop it).
