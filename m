Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaLDLI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:08:27 -0500
Received: from smtp.citrix.com ([66.165.176.89]:20999 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbaLDLIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:08:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,514,1413244800"; 
   d="scan'208";a="199640142"
Message-ID: <5480407F.7070402@citrix.com>
Date: Thu, 4 Dec 2014 11:07:43 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH v5 8/9] xen-pciback: drop SR-IOV VFs when PF driver unloads
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com> <1417642834-20350-9-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1417642834-20350-9-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote:
> From: Jan Beulich <JBeulich@suse.com>
> 
> When a PF driver unloads, it may find it necessary to leave the VFs
> around simply because of pciback having marked them as assigned to a
> guest. Utilize a suitable notification to let go of the VFs, thus
> allowing the PF to go back into the state it was before its driver
> loaded (which in particular allows the driver to be loaded again with
> it being able to create the VFs anew, but which also allows to then
> pass through the PF instead of the VFs).
> 
> Don't do this however for any VFs currently in active use by a guest.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> [v2: Removed the switch statement, moved it about]
> [v3: Redid it a bit differently]

Jan, are you happy with Konrad's change now?

David

> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -1518,6 +1518,53 @@ parse_error:
>  fs_initcall(pcistub_init);
>  #endif
>  
> +#ifdef CONFIG_PCI_IOV
> +static struct pcistub_device *find_vfs(const struct pci_dev *pdev)
> +{
> +	struct pcistub_device *psdev = NULL;
> +	unsigned long flags;
> +	bool found = false;
> +
> +	spin_lock_irqsave(&pcistub_devices_lock, flags);
> +	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
> +		if (!psdev->pdev && psdev->dev != pdev
> +		    && pci_physfn(psdev->dev) == pdev) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
> +	if (found)
> +		return psdev;
> +	return NULL;
> +}
> +
> +static int pci_stub_notifier(struct notifier_block *nb,
> +			     unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	const struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (action != BUS_NOTIFY_UNBIND_DRIVER)
> +		return NOTIFY_DONE;
> +
> +	if (!pdev->is_physfn)
> +		return NOTIFY_DONE;
> +
> +	for (;;) {
> +		struct pcistub_device *psdev = find_vfs(pdev);
> +		if (!psdev)
> +			break;
> +		device_release_driver(&psdev->dev->dev);
> +	}
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
> @@ -1539,12 +1586,19 @@ static int __init xen_pcibk_init(void)
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

