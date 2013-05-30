Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967576Ab3E3GFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:05:07 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57658 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967561Ab3E3GE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
References: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
Date: Wed, 29 May 2013 23:04:57 -0700
X-Google-Sender-Auth: -dZMQqgTfAwYcnFGGOctpBzsizM
Message-ID: <CAE9FiQUCOJ5FFwRWpVy59RqEwGC2KMNXvKe5HUAKLSES5fAR+Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: set correct value for iov device before device
From: Yinghai Lu <yinghai@kernel.org>
To: Xudong Hao <xudong.hao@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:45 PM, Xudong Hao <xudong.hao@intel.com> wrote:
> Since device registering is put into pci_device_add(), it must set value of
> Virtual Function device's member before the pci_dev is put to device tree. Or
> some relevant subsystem of driver model such as xen will report a incorrect
> IOV device to Xen hypervior.
>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> ---
>  drivers/pci/iov.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index c93071d..43d3de9 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -110,12 +110,12 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
>         if (reset)
>                 __pci_reset_function(virtfn);
>
> -       pci_device_add(virtfn, virtfn->bus);
> -       mutex_unlock(&iov->dev->sriov->lock);
> -
>         virtfn->physfn = pci_dev_get(dev);
>         virtfn->is_virtfn = 1;
>
> +       pci_device_add(virtfn, virtfn->bus);
> +       mutex_unlock(&iov->dev->sriov->lock);
> +
>         rc = pci_bus_add_device(virtfn);
>         sprintf(buf, "virtfn%u", id);
>         rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);

I have similar patch at
https://patchwork.kernel.org/patch/2562551/
   [5/7] PCI, ACPI: Don't glue ACPI dev with pci VFs

and Jiang has another one
https://patchwork.kernel.org/patch/2613481/
   [v3,part1,10/10] PCI, IOV: hide remove and rescan sysfs interfaces
for SR-IOV virtual functions

Thanks

Yinghai
