Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaATQlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:41:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:1131 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaATQlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,691,1384329600"; 
   d="scan'208";a="469576615"
Date: Mon, 20 Jan 2014 09:41:09 -0700 (MST)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Alexander Gordeev <agordeev@redhat.com>
cc: Keith Busch <keith.busch@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] nvme: Cleanup nvme_dev_start()
In-Reply-To: <20140120084314.GD19068@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LRH.2.03.1401200856580.25844@AMR>
References: <cover.1389904166.git.agordeev@redhat.com> <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com> <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com> <alpine.LRH.2.03.1401171419370.25844@AMR>
 <20140120083835.GA19068@dhcp-26-207.brq.redhat.com> <20140120084314.GD19068@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Alexander Gordeev wrote:
> This update fixes an oddity when a device is first added
> and then removed from dev_list in case of initialization
> failure, instead of just being added in case of success.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
> drivers/block/nvme-core.c |   19 ++++++++-----------
> 1 files changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index e1e4ad4..e4e12be 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -2105,29 +2105,26 @@ static int nvme_dev_start(struct nvme_dev *dev)
> 	if (result)
> 		goto unmap;
>
> -	spin_lock(&dev_list_lock);
> -	list_add(&dev->node, &dev_list);
> -	spin_unlock(&dev_list_lock);
> -
> 	result = set_queue_count(dev, num_online_cpus());
> 	if (result == -EBUSY)

For whatever reason, some of these devices unfortunetly don't support
legacy interrupts. We expect an interrupt when the completion is posted
for setting the queue count, but failing that, we rely on the polling
thread to invoke the completion, so the device needs to be in the dev_list
before calling set_queue_count.
