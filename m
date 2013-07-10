Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3GJV6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:58:14 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:53194 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3GJV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <1373356545-45944-1-git-send-email-wangyijing@huawei.com>
References: <1373356545-45944-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Jul 2013 15:57:51 -0600
Message-ID: <CAErSpo6L8W40JBjNfE+bf_HWaW5be0VLdK+YyN3+J+05--ukyA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: introduce PCIe Device Serial NUmber Capability support
To: Yijing Wang <wangyijing@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Oliver Neukum <oneukum@suse.de>,
        Paul Bolle <pebolle@tiscali.nl>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 1:55 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Introduce PCIe Ext Capability Device Serial Number support,
> so we can use the unique device serial number to identify
> the physical device. During system suspend, if the PCIe
> device was removed and inserted a new same device, after
> system resume there is no good way to identify it, maybe
> Device Serial Number is a good choice if device support.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Paul Bolle <pebolle@tiscali.nl>
> Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/pci.c   |   33 +++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h   |    1 +
>  drivers/pci/probe.c |    3 +++
>  include/linux/pci.h |    4 ++++
>  4 files changed, 41 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index e37fea6..d08df2b 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2048,6 +2048,39 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
>  }
>
>  /**
> + * pci_get_dsn - get device serial number
> + * @dev: the PCI device
> + * @sn: saved device serial number
> + */
> +void pci_get_dsn(struct pci_dev *dev, u64 *sn)

How about:

    u64 pci_device_serial_number(struct pci_dev *dev)

"get" suggests reference counting, which isn't happening here.  And
why pass a pointer to a return value when we can just as easily return
it directly?

> +{
> +       int pos;
> +       u32 lo, hi;
> +
> +       if (!pci_is_pcie(dev))
> +               goto out;
> +
> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
> +       if (!pos)
> +               goto out;
> +
> +       pci_read_config_dword(dev, pos + 4, &lo);
> +       pci_read_config_dword(dev, pos + 8, &hi);
> +       *sn = ((u64)hi << 32) | lo;
> +       return;
> +
> +out:
> +       *sn = 0;
> +       return;
> +}
> +EXPORT_SYMBOL(pci_get_dsn);
> +
> +void pci_dsn_init(struct pci_dev *dev)
> +{
> +       return pci_get_dsn(dev, &dev->sn);
> +}
> +
> +/**
>   * pci_configure_ari - enable or disable ARI forwarding
>   * @dev: the PCI device
>   *
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 68678ed..f626006 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -202,6 +202,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>                     struct resource *res, unsigned int reg);
>  int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
>  void pci_configure_ari(struct pci_dev *dev);
> +void pci_dsn_init(struct pci_dev *dev);
>
>  /**
>   * pci_ari_enabled - query ARI forwarding status
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 46ada5c..d4c6e7e 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1322,6 +1322,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
>         /* Power Management */
>         pci_pm_init(dev);
>
> +       /* Device Serial Number */
> +       pci_dsn_init(dev);

    dev->sn = pci_serial_number(dev);

Obvious, no comment or wrapper function needed.

> +
>         /* Vital Product Data */
>         pci_vpd_pci22_init(dev);
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0fd1f15..59cd205 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -342,6 +342,7 @@ struct pci_dev {
>         struct list_head msi_list;
>         struct kset *msi_kset;
>  #endif
> +       u64 sn;         /* device serieal number, 0 if not support */
>         struct pci_vpd *vpd;
>  #ifdef CONFIG_PCI_ATS
>         union {
> @@ -995,6 +996,9 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>  ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
>  int pci_vpd_truncate(struct pci_dev *dev, size_t size);
>
> +/* Device Serial Number */
> +void pci_get_dsn(struct pci_dev *dev, u64 *sn);
> +
>  /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>  resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
>  void pci_bus_assign_resources(const struct pci_bus *bus);
> --
> 1.7.1
>
>
