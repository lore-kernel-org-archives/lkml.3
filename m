Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaATWtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:49:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:41382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaATWtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:49:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,692,1384329600"; 
   d="scan'208";a="461915995"
Date: Mon, 20 Jan 2014 15:48:56 -0700 (MST)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Alexander Gordeev <agordeev@redhat.com>
cc: Keith Busch <keith.busch@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] nvme: Cleanup nvme_dev_start() and fix IRQ leak
In-Reply-To: <20140120084212.GC19068@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LRH.2.03.1401201541000.25844@AMR>
References: <cover.1389904166.git.agordeev@redhat.com> <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com> <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com> <alpine.LRH.2.03.1401171419370.25844@AMR>
 <20140120083835.GA19068@dhcp-26-207.brq.redhat.com> <20140120084212.GC19068@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Alexander Gordeev wrote:
> This is an attempt to make handling of admin queue in a
> single scope. This update also fixes a IRQ leak in case
> nvme_setup_io_queues() failed to allocate enough iomem
> and bailed out with -ENOMEM errno.

This definitely seems to improve the code flow, but this leak was already
fixed in the latest linux-nvme tree with this commit:

http://git.infradead.org/users/willy/linux-nvme.git/commit/c5dc9192d52a4a3a479f701e97386347d454af84

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
> drivers/block/nvme-core.c |   44 +++++++++++++++++++++++---------------------
> 1 files changed, 23 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index 3e1ae55..e1e4ad4 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -1287,6 +1287,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
> 	if (result)
> 		return result;
>
> +	dev->entry[0].vector = pdev->pci_dev->irq;
> 	result = queue_request_irq(dev, nvmeq, "nvme admin");
> 	if (result)
> 		return result;
> @@ -1297,6 +1298,11 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
> 	return result;
> }
>
> +static int nvme_teardown_admin_queue(struct nvme_dev *dev)
> +{
> +	free_irq(dev->entry[0].vector, dev->queues[0]);
> +}
> +
> struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
> 				unsigned long addr, unsigned length)
> {
> @@ -1744,17 +1750,10 @@ static size_t db_bar_size(struct nvme_dev *dev, unsigned nr_io_queues)
> 	return 4096 + ((nr_io_queues + 1) << (dev->db_stride + 3));
> }
>
> -static int nvme_setup_io_queues(struct nvme_dev *dev)
> +static int nvme_setup_io_queues(struct nvme_dev *dev, int nr_io_queues)
> {
> 	struct pci_dev *pdev = dev->pci_dev;
> -	int result, cpu, i, vecs, nr_io_queues, size, q_depth;
> -
> -	nr_io_queues = num_online_cpus();
> -	result = set_queue_count(dev, nr_io_queues);
> -	if (result < 0)
> -		return result;
> -	if (result < nr_io_queues)
> -		nr_io_queues = result;
> +	int result, cpu, i, vecs, size, q_depth;
>
> 	size = db_bar_size(dev, nr_io_queues);
> 	if (size > 8192) {
> @@ -1771,20 +1770,15 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
> 		dev->queues[0]->q_db = dev->dbs;
> 	}
>
> -	/* Deregister the admin queue's interrupt */
> -	free_irq(dev->entry[0].vector, dev->queues[0]);
> -
> 	for (i = 0; i < nr_io_queues; i++)
> 		dev->entry[i].entry = i;
> 	vecs = pci_enable_msix_range(pdev, dev->entry, 1, nr_io_queues);
> 	if (vecs < 0) {
> 		vecs = pci_enable_msi_range(pdev, 1, min(nr_io_queues, 32));
> -		if (vecs < 0) {
> +		if (vecs < 0)
> 			vecs = 1;
> -		} else {
> -			for (i = 0; i < vecs; i++)
> -				dev->entry[i].vector = i + pdev->irq;
> -		}
> +		for (i = 0; i < vecs; i++)
> +			dev->entry[i].vector = i + pdev->irq;
> 	}
>
> 	/*
> @@ -1928,7 +1922,6 @@ static int nvme_dev_map(struct nvme_dev *dev)
> 	if (pci_enable_device_mem(pdev))
> 		return result;
>
> -	dev->entry[0].vector = pdev->irq;
> 	pci_set_master(pdev);
> 	bars = pci_select_bars(pdev, IORESOURCE_MEM);
> 	if (pci_request_selected_regions(pdev, bars, "nvme"))
> @@ -2116,11 +2109,20 @@ static int nvme_dev_start(struct nvme_dev *dev)
> 	list_add(&dev->node, &dev_list);
> 	spin_unlock(&dev_list_lock);
>
> -	result = nvme_setup_io_queues(dev);
> -	if (result && result != -EBUSY)
> +	result = set_queue_count(dev, num_online_cpus());
> +	if (result == -EBUSY)
> +		return -EBUSY;
> +
> +	nvme_teardown_admin_queue(dev);
> +
> +	if (result)
> 		goto disable;
>
> -	return result;
> +	result = nvme_setup_io_queues(dev, result);
> +	if (result)
> +		goto disable;
> +
> +	return 0;
>
>  disable:
> 	spin_lock(&dev_list_lock);
> --
