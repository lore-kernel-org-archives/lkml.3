Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946AbaEFDPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:15:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:53809 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933762AbaEFDPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,993,1389772800"; 
   d="scan'208";a="534085775"
Message-ID: <536853F5.7040107@intel.com>
Date: Tue, 06 May 2014 11:16:05 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Joe Thomas <Joe.Thomas@dothill.com>
Subject: Re: [PATCH] ahci: unregister acpi notify handler when a ZPODD is
 unbound
References: <1398873887-23920-1-git-send-email-levex@linux.com>
In-Reply-To: <1398873887-23920-1-git-send-email-levex@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 12:04 AM, Levente Kurusa wrote:
> When a ZPODD device is unbound via sysfs, the acpi notify handler
> is not removed. This causes panics as observed in Bug #74601. The

Ah...too bad, I forgot to consider this situation, thanks for tracking
this.

> panic only happens when the wake happens from outside the kernel
> (i.e. inserting media or pressing a button). Implement a new
> ahci_remove_one function which causes zpodd_exit to be called for all
> ZPODD devices on the unbound PCI device.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
> ---
> 
> Hi,
> 
> I am not sure if the loop below is correct. Maybe there is a better
> solution to loop through all the devices which might use ZPODD?

I didn't find a proper place either. For hotplug, we did the zpodd_exit
at ata_scsi_handle_link_detach. But for host controller pci device
removal, we used scsi_remove_host in ata_port_detach and there is no
place to add the zpodd_exit for a to-be-removed scsi device...

Looks like we can only iterate the ata devices and call zpodd_exit
explicitly for them if they are zpodd devices. Instead of adding a new
remove callback, what about just embed that into the ata_port_detach
like the following example?


diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 943cc8b83e59..43652da6fea6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6314,6 +6314,8 @@ int ata_host_activate(struct ata_host *host, int irq,
 static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
+	struct ata_link *link;
+	struct ata_device *dev;
 
 	if (!ap->ops->error_handler)
 		goto skip_eh;
@@ -6333,6 +6335,13 @@ static void ata_port_detach(struct ata_port *ap)
 	cancel_delayed_work_sync(&ap->hotplug_task);
 
  skip_eh:
+	/* clean up zpodd related stuffs on port removal */
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		ata_for_each_dev(dev, link, ALL) {
+			if (zpodd_dev_enabled(dev))
+				zpodd_exit(dev);
+		}
+	}
 	if (ap->pmp_link) {
 		int i;
 		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)

Thanks,
Aaron

> 
> Thanks, Lev.
> 
>  drivers/ata/ahci.c         | 21 +++++++++++++++++++++
>  drivers/ata/ahci.h         |  4 ++++
>  drivers/ata/libata-zpodd.c |  1 +
>  3 files changed, 26 insertions(+)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 5a0bf8e..6d92bc9 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -475,12 +475,33 @@ static const struct pci_device_id ahci_pci_tbl[] = {
>  	{ }	/* terminate list */
>  };
>  
> +#ifdef CONFIG_SATA_ZPODD
> +void ahci_remove_one(struct pci_dev *pdev)
> +{
> +	struct ata_host *host = pci_get_drvdata(pdev);
> +	struct ata_link *link;
> +	struct ata_device *dev;
> +	int i;
> +
> +	for (i = 0; i < host->n_ports; i++)
> +		ata_for_each_link(link, host->ports[i], HOST_FIRST)
> +			ata_for_each_dev(dev, link, ALL)
> +				if (dev->zpodd)
> +					zpodd_exit(dev);
> +
> +	ata_pci_remove_one(pdev);
> +}
> +#endif
>  
>  static struct pci_driver ahci_pci_driver = {
>  	.name			= DRV_NAME,
>  	.id_table		= ahci_pci_tbl,
>  	.probe			= ahci_init_one,
> +#ifdef CONFIG_SATA_ZPODD
> +	.remove			= ahci_remove_one,
> +#else
>  	.remove			= ata_pci_remove_one,
> +#endif
>  #ifdef CONFIG_PM
>  	.suspend		= ahci_pci_device_suspend,
>  	.resume			= ahci_pci_device_resume,
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 51af275..87e4e6d 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -383,6 +383,10 @@ void ahci_print_info(struct ata_host *host, const char *scc_s);
>  int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
>  void ahci_error_handler(struct ata_port *ap);
>  
> +#ifdef CONFIG_SATA_ZPODD
> +extern void zpodd_exit(struct ata_device *dev);
> +#endif /* CONFIG_SATA_ZPODD */
> +
>  static inline void __iomem *__ahci_port_base(struct ata_host *host,
>  					     unsigned int port_no)
>  {
> diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
> index f3a65a3..fe66949 100644
> --- a/drivers/ata/libata-zpodd.c
> +++ b/drivers/ata/libata-zpodd.c
> @@ -281,3 +281,4 @@ void zpodd_exit(struct ata_device *dev)
>  	kfree(dev->zpodd);
>  	dev->zpodd = NULL;
>  }
> +EXPORT_SYMBOL_GPL(zpodd_exit);
> 

