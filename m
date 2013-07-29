Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3G2OcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:32:12 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44659 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3G2OcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <1374657972-2456-1-git-send-email-wangyijing@huawei.com>
References: <1374657972-2456-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Jul 2013 08:31:49 -0600
Message-ID: <CAErSpo4jww8mX61-tw8aTXtv5TR2fCg_+6pfwPKHdwB=iL=mBA@mail.gmail.com>
Subject: Re: [PATCH] PCI: update NumVFs register properly during
 enable/disable sriov
To: Yijing Wang <wangyijing@huawei.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Don]

On Wed, Jul 24, 2013 at 3:26 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Currently, we only update NumVFs register during sriov_enable().
> This register should also be updated properly during sriov_disable.
> Otherwise, we will get the stale "Number of VFs" info from lspci.

Has this always been broken, or was it broken by a recent change?

Can you post a transcript demonstrating what's going wrong?  Doesn't
have to be in the changelog unless it's short, but just something to
help reproduce the problem.

> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/iov.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index de8ffac..6e4844b 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -286,7 +286,6 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>             (!(iov->cap & PCI_SRIOV_CAP_VFM) && (nr_virtfn > initial)))
>                 return -EINVAL;
>
> -       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
>         pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_OFFSET, &offset);
>         pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_STRIDE, &stride);
>         if (!offset || (nr_virtfn > 1 && !stride))
> @@ -334,6 +333,7 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>                         return rc;
>         }
>
> +       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
>         iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
>         pci_cfg_access_lock(dev);
>         pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> @@ -368,6 +368,7 @@ failed:
>         iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
>         pci_cfg_access_lock(dev);
>         pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> +       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, 0);
>         ssleep(1);
>         pci_cfg_access_unlock(dev);
>
> @@ -401,6 +402,7 @@ static void sriov_disable(struct pci_dev *dev)
>                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
>
>         iov->num_VFs = 0;
> +       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, 0);
>  }
>
>  static int sriov_init(struct pci_dev *dev, int pos)
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
