Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaKUWDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:03:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaKUWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:03:50 -0500
Date: Fri, 21 Nov 2014 17:03:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: xen-devel <xen-devel@lists.xenproject.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-pciback: drop SR-IOV VFs when PF driver unloads
Message-ID: <20141121220338.GA17981@laptop.dumpdata.com>
References: <545B9C5F020000780004561B@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B9C5F020000780004561B@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:05:51PM +0000, Jan Beulich wrote:
> When a PF driver unloads, it may find it necessary to leave the VFs
> around simply because of pciback having marked them as assigned to a
> guest. Utilize a suitable notification to let go of the VFs, thus
> allowing the PF to go back into the state it was before its driver
> loaded (which in particular allows the driver to be loaded again with
> it being able to create the VFs anew, but which also allows to then
> pass through the PF instead of the VFs).
> 
> Don't do this however for any VFs currently in active use by a guest.

I rewrote it a bit to be more in the style of pciback:


>From d364ca863f5d506750171ca014f6100080b029dc Mon Sep 17 00:00:00 2001
From: Jan Beulich <JBeulich@suse.com>
Date: Thu, 6 Nov 2014 15:05:51 +0000
Subject: [PATCH] xen-pciback: drop SR-IOV VFs when PF driver unloads

When a PF driver unloads, it may find it necessary to leave the VFs
around simply because of pciback having marked them as assigned to a
guest. Utilize a suitable notification to let go of the VFs, thus
allowing the PF to go back into the state it was before its driver
loaded (which in particular allows the driver to be loaded again with
it being able to create the VFs anew, but which also allows to then
pass through the PF instead of the VFs).

Don't do this however for any VFs currently in active use by a guest.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
[v2: Removed the switch statement, moved it about]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 43 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 017069a..0763e01 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -1502,6 +1502,42 @@ parse_error:
 fs_initcall(pcistub_init);
 #endif
 
+#ifdef CONFIG_PCI_IOV
+static int pci_stub_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	struct device *dev = data;
+	const struct pci_dev *pdev = to_pci_dev(dev);
+	struct pcistub_device *psdev;
+	unsigned long flags;
+	bool found = false;
+
+	if (action != BUS_NOTIFY_UNBIND_DRIVER)
+		goto out;
+
+	if (!pdev->is_physfn)
+		goto out;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (!psdev->pdev && psdev->dev != pdev
+		    && pci_physfn(psdev->dev) == pdev) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	if (found)
+		device_release_driver(&psdev->dev->dev);
+out:
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block pci_stub_nb = {
+	.notifier_call = pci_stub_notifier,
+};
+#endif
+
 static int __init xen_pcibk_init(void)
 {
 	int err;
@@ -1523,12 +1559,19 @@ static int __init xen_pcibk_init(void)
 	err = xen_pcibk_xenbus_register();
 	if (err)
 		pcistub_exit();
+#ifdef CONFIG_PCI_IOV
+	else
+		bus_register_notifier(&pci_bus_type, &pci_stub_nb);
+#endif
 
 	return err;
 }
 
 static void __exit xen_pcibk_cleanup(void)
 {
+#ifdef CONFIG_PCI_IOV
+	bus_unregister_notifier(&pci_bus_type, &pci_stub_nb);
+#endif
 	xen_pcibk_xenbus_unregister();
 	pcistub_exit();
 }
-- 
1.9.3



Haven't yet tested it.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> ---
>  drivers/xen/xen-pciback/pci_stub.c |   46 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> --- 3.18-rc3/drivers/xen/xen-pciback/pci_stub.c
> +++ 3.18-rc3-pciback-release-VFs/drivers/xen/xen-pciback/pci_stub.c
> @@ -1502,6 +1502,45 @@ parse_error:
>  fs_initcall(pcistub_init);
>  #endif
>  
> +#ifdef CONFIG_PCI_IOV
> +static int pci_stub_notifier(struct notifier_block *nb,
> +			     unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	const struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	switch (action) {
> +	case BUS_NOTIFY_UNBIND_DRIVER:
> +		if (!pdev->is_physfn)
> +			break;
> +		for (;;) {
> +			struct pcistub_device *psdev;
> +			unsigned long flags;
> +			bool found = false;
> +
> +			spin_lock_irqsave(&pcistub_devices_lock, flags);
> +			list_for_each_entry(psdev, &pcistub_devices, dev_list)
> +				if (!psdev->pdev && psdev->dev != pdev
> +				    && pci_physfn(psdev->dev) == pdev) {
> +					found = true;
> +					break;
> +				}
> +			spin_unlock_irqrestore(&pcistub_devices_lock, flags);
> +			if (!found)
> +				break;
> +			device_release_driver(&psdev->dev->dev);
> +		}
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block pci_stub_nb = {
> +	.notifier_call = pci_stub_notifier,
> +};
> +#endif
> +
>  static int __init xen_pcibk_init(void)
>  {
>  	int err;
> @@ -1523,12 +1562,19 @@ static int __init xen_pcibk_init(void)
>  	err = xen_pcibk_xenbus_register();
>  	if (err)
>  		pcistub_exit();
> +#ifdef CONFIG_PCI_IOV
> +	else
> +		bus_register_notifier(&pci_bus_type, &pci_stub_nb);
> +#endif
>  
>  	return err;
>  }
>  
>  static void __exit xen_pcibk_cleanup(void)
>  {
> +#ifdef CONFIG_PCI_IOV
> +	bus_unregister_notifier(&pci_bus_type, &pci_stub_nb);
> +#endif
>  	xen_pcibk_xenbus_unregister();
>  	pcistub_exit();
>  }
> 
> 
> 
