Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3LSWK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:10:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42488 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3LSWKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:10:24 -0500
Date: Thu, 19 Dec 2013 15:10:19 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Murray <amurray@embedded-bits.co.uk>,
        Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 32/38] pcie: add missing put_device call
Message-ID: <20131219221019.GB15201@google.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Greg, Yinghai]

On Thu, Dec 19, 2013 at 04:06:46PM +0100, Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.
> Removed the kfree() as put_device will result in release_pcie_device being
> called and hence the container of the device will be kfree'd.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

Thanks, I applied a slightly modified version of this to my pci/deletion
branch for v3.14.

I think the get_device() after device_register() succeeds and the
put_device() before device_unregister() are superfluous, so I propose the
series included below.  Any comments?

> ---
>  drivers/pci/pcie/portdrv_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 08d131f..80fb1f2 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -345,7 +345,7 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
>  
>  	retval = device_register(device);
>  	if (retval)
> -		kfree(pcie);
> +		put_device(device);
>  	else
>  		get_device(device);
>  	return retval;


commit 8f3acca9acec1503f6b374faef2d1013cbf502af
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Thu Dec 19 14:20:09 2013 -0700

    PCI/portdrv: Cleanup error paths
    
    Make the straightline path the normal no-error path.  Check for errors and
    return them directly, instead of checking for success and putting the
    normal path in an "if" body.
    
    No functional change.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 0b6e76604068..fc86d323fecc 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -344,11 +344,13 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
 	device_enable_async_suspend(device);
 
 	retval = device_register(device);
-	if (retval)
+	if (retval) {
 		kfree(pcie);
-	else
-		get_device(device);
-	return retval;
+		return retval;
+	}
+
+	get_device(device);
+	return 0;
 }
 
 /**
@@ -498,12 +500,12 @@ static int pcie_port_probe_service(struct device *dev)
 
 	pciedev = to_pcie_device(dev);
 	status = driver->probe(pciedev);
-	if (!status) {
-		dev_printk(KERN_DEBUG, dev, "service driver %s loaded\n",
-			driver->name);
-		get_device(dev);
-	}
-	return status;
+	if (status)
+		return status;
+
+	dev_printk(KERN_DEBUG, dev, "service driver %s loaded\n", driver->name);
+	get_device(dev);
+	return 0;
 }
 
 /**

commit f39862058e1f278e0495cd9ea57de571e74aa1fe
Author: Levente Kurusa <levex@linux.com>
Date:   Thu Dec 19 14:22:35 2013 -0700

    PCI/portdrv: Add put_device() after device_register() failure
    
    This is required so that we give up the last reference to the device.
    Removed the kfree() as put_device will result in release_pcie_device()
    being called and hence the container of the device will be kfree'd.
    
    [bhelgaas: fix conflict after my previous cleanup]
    Signed-off-by: Levente Kurusa <levex@linux.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index fc86d323fecc..9811eea53511 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -345,7 +345,7 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
 
 	retval = device_register(device);
 	if (retval) {
-		kfree(pcie);
+		put_device(device);
 		return retval;
 	}
 

commit e75f34ce6633549486a044d64b2a79240d4113a8
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Thu Dec 19 14:24:13 2013 -0700

    PCI/portdrv: Remove extra get_device()/put_device() for pcie_device
    
    Previously pcie_device_init() called get_device() if device_register() for
    the new pcie_device succeeded, and remove_iter() called put_device() when
    removing before unregistering the device.
    
    But device_register() already increments the reference count in
    device_add(), so we don't need to do it again here.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 9811eea53511..6a6e54909335 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -349,7 +349,6 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
 		return retval;
 	}
 
-	get_device(device);
 	return 0;
 }
 
@@ -456,10 +455,8 @@ int pcie_port_device_resume(struct device *dev)
 
 static int remove_iter(struct device *dev, void *data)
 {
-	if (dev->bus == &pcie_port_bus_type) {
-		put_device(dev);
+	if (dev->bus == &pcie_port_bus_type)
 		device_unregister(dev);
-	}
 	return 0;
 }
 
