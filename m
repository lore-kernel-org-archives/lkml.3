Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaAUTGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:06:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:8831 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaAUTGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:06:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="468546020"
Date: Tue, 21 Jan 2014 12:06:20 -0700 (MST)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Alexander Gordeev <agordeev@redhat.com>
cc: Keith Busch <keith.busch@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/2] nvme: Cleanup nvme_dev_start() and fix IRQ leak
In-Reply-To: <20140121100719.GC8847@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LRH.2.03.1401211151110.25844@AMR>
References: <cover.1389904166.git.agordeev@redhat.com> <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com> <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com> <alpine.LRH.2.03.1401171419370.25844@AMR>
 <20140120083835.GA19068@dhcp-26-207.brq.redhat.com> <20140120084212.GC19068@dhcp-26-207.brq.redhat.com> <alpine.LRH.2.03.1401201541000.25844@AMR> <20140121100311.GA8847@dhcp-26-207.brq.redhat.com> <20140121100719.GC8847@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Alexander Gordeev wrote:
> This is an attempt to make handling of admin queue in a
> single scope. This update also fixes a IRQ leak in case
> nvme_setup_io_queues() failed to allocate enough iomem
> and bailed out with -ENOMEM errno.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---

> +static void nvme_teardown_admin_queue(struct nvme_dev *dev)
> +{
> +	nvme_disable_queue(dev, 0);
> +	nvme_free_queue(dev->queues[0]);
> +}

> @@ -2402,11 +2398,20 @@ static int nvme_dev_start(struct nvme_dev *dev)
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

Oh no! Your new teardown function is freeing the admin queue, but it
would be used immediatly after that in nvme_setup_io_queues ...

> +
> +	if (result)
> 		goto disable;

... but you'll never actually get to setup io queues because the 'result'
here is non-zero if we were successful, and is the number of queues the
controller can allocate. I think you meant to do this instead:

+	if (result < 0)

>
> -	return result;
> +	result = nvme_setup_io_queues(dev, result);
> +	if (result)
> +		goto disable;
> +
> +	return 0;

