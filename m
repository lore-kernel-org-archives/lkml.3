Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3CAX17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:27:59 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43554 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CAX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:27:58 -0500
MIME-Version: 1.0
In-Reply-To: <1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
	<1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
Date: Fri, 1 Mar 2013 17:27:56 -0600
Message-ID: <CALRxmdDEccTaS2Houuns44DoQ_8wUbXAMiXQ8w0Ks9R2F2u-Ag@mail.gmail.com>
Subject: Re: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
From: Stuart Yoder <b08248@gmail.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 6:52 AM, Varun Sethi <Varun.Sethi@freescale.com> wrote:
[cut]
> +static phys_addr_t get_phys_addr(struct fsl_dma_domain *dma_domain, unsigned long iova)
> +{
> +       u32 win_cnt = dma_domain->win_cnt;
> +       struct dma_window *win_ptr =
> +                               &dma_domain->win_arr[0];
> +       struct iommu_domain_geometry *geom;
> +
> +       geom = &dma_domain->iommu_domain->geometry;
> +
> +       if (!win_cnt || !dma_domain->geom_size) {
> +               pr_err("Number of windows/geometry not configured for the domain\n");
> +               return 0;
> +       }
> +
> +       if (win_cnt > 1) {
> +               u64 subwin_size;
> +               unsigned long subwin_iova;
> +               u32 wnd;
> +
> +               subwin_size = dma_domain->geom_size >> ilog2(win_cnt);

Could it be just geom_size / win_cnt ??

> +               subwin_iova = iova & ~(subwin_size - 1);
> +               wnd = (subwin_iova - geom->aperture_start) >> ilog2(subwin_size);
> +               win_ptr = &dma_domain->win_arr[wnd];
> +       }
> +
> +       if (win_ptr->valid)
> +               return (win_ptr->paddr + (iova & (win_ptr->size - 1)));
> +
> +       return 0;
> +}
> +
> +static int map_liodn_subwins(int liodn, struct fsl_dma_domain *dma_domain)

Just call it map_subwins().  They are just sub windows, not "liodn sub windows".

[cut]

> +static int map_liodn_win(int liodn, struct fsl_dma_domain *dma_domain)

Call it map_win().

[cut]
> +static struct fsl_dma_domain *iommu_alloc_dma_domain(void)
> +{
> +       struct fsl_dma_domain *domain;
> +
> +       domain = kmem_cache_zalloc(fsl_pamu_domain_cache, GFP_KERNEL);
> +       if (!domain)
> +               return NULL;
> +
> +       domain->stash_id = ~(u32)0;
> +       domain->snoop_id = ~(u32)0;
> +       domain->win_cnt = max_subwindow_count;

To align with my previous comments on fsl_pamu.c, I think instead of referencing
a global variable (in fsl_pamu.c) you should be making an accessor API
call here to get
the max subwindow _count.

> +       domain->geom_size = 0;
> +
> +       INIT_LIST_HEAD(&domain->devices);
> +
> +       spin_lock_init(&domain->domain_lock);
> +
> +       return domain;
> +}
> +
> +static inline struct device_domain_info *find_domain(struct device *dev)
> +{
> +       return dev->archdata.iommu_domain;
> +}
> +
> +static void remove_domain_ref(struct device_domain_info *info, u32 win_cnt)
> +{
> +               list_del(&info->link);
> +               spin_lock(&iommu_lock);
> +               if (win_cnt)
> +                       pamu_free_subwins(info->liodn);
> +               pamu_disable_liodn(info->liodn);
> +               spin_unlock(&iommu_lock);
> +               spin_lock(&device_domain_lock);
> +               info->dev->archdata.iommu_domain = NULL;
> +               kmem_cache_free(iommu_devinfo_cache, info);
> +               spin_unlock(&device_domain_lock);
> +}

The above function is literally removing the _device_ reference from the domain.
The name implies that it is removing a "domain reference".   Suggestion is
to call it "remove_device_ref".

Also, the whitespace is messed up there.  You have 2 tabs instead of 1.

> +static void destroy_domain(struct fsl_dma_domain *dma_domain)
> +{
> +       struct device_domain_info *info;
> +
> +       /* Dissociate all the devices from this domain */
> +       while (!list_empty(&dma_domain->devices)) {
> +               info = list_entry(dma_domain->devices.next,
> +                       struct device_domain_info, link);
> +               remove_domain_ref(info, dma_domain->win_cnt);
> +       }
> +}

This function is removing all devices from a domain...maybe to be
consistent with my
suggestion below on detach_domain(), call this detach_all_devices().
 We have 2 functions
doing almost the same thing....one detaches a single device, one
detaches all devices.
The current names "destroy_domain" and "detach_domain" are not as clear to me.

> +static void detach_domain(struct device *dev, struct fsl_dma_domain *dma_domain)
> +{
> +       struct device_domain_info *info;
> +       struct list_head *entry, *tmp;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&dma_domain->domain_lock, flags);
> +       /* Remove the device from the domain device list */
> +       if (!list_empty(&dma_domain->devices)) {
> +               list_for_each_safe(entry, tmp, &dma_domain->devices) {
> +                       info = list_entry(entry, struct device_domain_info, link);
> +                       if (info->dev == dev)
> +                               remove_domain_ref(info, dma_domain->win_cnt);
> +               }
> +       }
> +       spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +}

This function is not "detaching a domain", but is detaching a device.
 Call it detach_device().

> +static void attach_domain(struct fsl_dma_domain *dma_domain, int liodn, struct device *dev)
> +{

Same thing here.   This is not attaching a domain, but attaching a
device.  Call it attach_device.

> +       struct device_domain_info *info, *old_domain_info;
> +
> +       spin_lock(&device_domain_lock);
> +       /*
> +        * Check here if the device is already attached to domain or not.
> +        * If the device is already attached to a domain detach it.
> +        */
> +       old_domain_info = find_domain(dev);
> +       if (old_domain_info && old_domain_info->domain != dma_domain) {
> +               spin_unlock(&device_domain_lock);
> +               detach_domain(dev, old_domain_info->domain);
> +               spin_lock(&device_domain_lock);
> +       }
> +
> +       info = kmem_cache_zalloc(iommu_devinfo_cache, GFP_KERNEL);
> +
> +       info->dev = dev;
> +       info->liodn = liodn;
> +       info->domain = dma_domain;
> +
> +       list_add(&info->link, &dma_domain->devices);
> +       /*
> +        * In case of devices with multiple LIODNs just store
> +        * the info for the first LIODN as all
> +        * LIODNs share the same domain
> +        */
> +       if (!old_domain_info)
> +               dev->archdata.iommu_domain = info;
> +       spin_unlock(&device_domain_lock);
> +
> +}
> +

[cut]
> +/* Configure geometry settings for all LIODNs associated with domain */
> +static int configure_domain(struct fsl_dma_domain *dma_domain,
> +                           struct iommu_domain_geometry *geom_attr,
> +                           u32 win_cnt)

This function is not configuring the iommu domain...which is a concept
in the Linux driver, it is taking the domain geometry and setting
up the PAMU tables for all LIODNs currently in the domain.

Maybe it would help if you used a prefix like "pamu" or "paact" to
identify functions that operate on the actual PAMU tables.

maybe:  pamu_set_domain_geometry()

> +{
> +       struct device_domain_info *info;
> +       int ret = 0;
> +
> +       if (!list_empty(&dma_domain->devices)) {
> +               list_for_each_entry(info, &dma_domain->devices, link) {
> +                       ret = configure_liodn(info->liodn, info->dev, dma_domain,
> +                                             geom_attr, win_cnt);

...and following the above naming convention, call this (?): pamu_set_liodn

> +                       if (ret)
> +                               break;
> +               }
> +       }
> +
> +       return ret;
> +}
> +

[cut]
> +static int fsl_pamu_window_enable(struct iommu_domain *domain, u32 wnd_nr,
> +                                 phys_addr_t paddr, u64 size, int iommu_prot)
> +{
> +       struct fsl_dma_domain *dma_domain = domain->priv;
> +       struct dma_window *wnd;
> +       int prot = 0;
> +       int ret;
> +       unsigned long flags;
> +       u64 win_size;
> +
> +       if (iommu_prot & IOMMU_READ)
> +               prot |= PAACE_AP_PERMS_QUERY;
> +       if (iommu_prot & IOMMU_WRITE)
> +               prot |= PAACE_AP_PERMS_UPDATE;
> +
> +       spin_lock_irqsave(&dma_domain->domain_lock, flags);
> +       if (!dma_domain->win_arr) {
> +               pr_err("Number of windows not configured\n");
> +               spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +               return -ENODEV;
> +       }
> +
> +       if (wnd_nr >= dma_domain->win_cnt) {
> +               pr_err("Invalid window index\n");
> +               spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +               return -EINVAL;
> +       }
> +
> +       win_size = dma_domain->geom_size >> ilog2(dma_domain->win_cnt);

Isn't size just geom_size / win_cnt.   Not sure why you do the ilog2()
and right shift...
We already validated that  win_cnt is power of 2 when it was set.

> +       if (size > win_size) {
> +               pr_err("Invalid window size \n");
> +               spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +               return -EINVAL;
> +       }
> +
> +       if (dma_domain->win_cnt == 1) {
> +               if (dma_domain->enabled) {
> +                       pr_err("Disable the window before updating the mapping\n");
> +                       spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +                       return -EBUSY;
> +               }
> +
> +               ret = check_size(size, domain->geometry.aperture_start);
> +               if (ret) {
> +                       pr_err("Aperture start not aligned to the size\n");
> +                       spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +                       return -EINVAL;
> +               }
> +       }

Why is win_cnt==1 a special case?    Would the geometry not have been verified
when it was originally set up?

Also, do you need a check here to verify if the geometry has been set.  Is it a
requirement to set the geometry prior to window enable?

> +       wnd = &dma_domain->win_arr[wnd_nr];
> +       if (!wnd->valid) {
> +               wnd->paddr = paddr;
> +               wnd->size = size;
> +               wnd->prot = prot;
> +
> +               ret = update_domain_mapping(dma_domain, wnd_nr);
> +               if (!ret) {
> +                       wnd->valid = 1;
> +                       dma_domain->mapped++;
> +               }
> +       } else {
> +               pr_err("Disable the window before updating the mapping\n");
> +               ret = -EBUSY;
> +       }
> +
> +       spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +
> +       return ret;
> +}
> +
> +/*

[cut]
> +static int fsl_pamu_attach_device(struct iommu_domain *domain,
> +                                 struct device *dev)
> +{
> +       struct fsl_dma_domain *dma_domain = domain->priv;
> +       const u32 *prop;
> +       u32 prop_cnt;
> +       int len, ret = 0;
> +       struct pci_dev *pdev = NULL;
> +       struct pci_controller *pci_ctl;
> +
> +       /*
> +        * Hack to make attach device work for the PCI devices. Simply assign the
> +        * the LIODN for the PCI controller to the PCI device.
> +        */

Instead of "Simply assign...", perhaps say instead:  Use the LIODN for the
PCI controller when attaching a PCI device.

> +       if (dev->bus == &pci_bus_type) {
> +               pdev = to_pci_dev(dev);
> +               pci_ctl = pci_bus_to_host(pdev->bus);
> +               /*
> +                * make dev point to pci controller device
> +                * so we can get the LIODN programmed by
> +                * u-boot;
> +                */
> +               dev = pci_ctl->parent;
> +       }
> +
> +       prop = of_get_property(dev->of_node, "fsl,liodn", &len);

suggestion: name "prop" to be "liodn" and "prop_cnt" to be "liodn_cnt".  That
will be more clear.

> +       if (prop) {
> +               prop_cnt = len / sizeof(u32);
> +               ret = handle_attach_device(dma_domain, dev,
> +                                        prop, prop_cnt);
> +       } else {
> +               pr_err("missing fsl,liodn property at %s\n",
> +                         dev->of_node->full_name);
> +                       ret = -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +static void fsl_pamu_detach_device(struct iommu_domain *domain,
> +                                     struct device *dev)
> +{
> +       struct fsl_dma_domain *dma_domain = domain->priv;
> +       const u32 *prop;
> +       int len;
> +       struct pci_dev *pdev = NULL;
> +       struct pci_controller *pci_ctl;
> +
> +       /*
> +        * Hack to make detach device work for the PCI devices. Simply assign the
> +        * the LIODN for the PCI controller to the PCI device.
> +        */
> +       if (dev->bus == &pci_bus_type) {
> +               pdev = to_pci_dev(dev);
> +               pci_ctl = pci_bus_to_host(pdev->bus);
> +               /*
> +                * make dev point to pci controller device
> +                * so we can get the LIODN programmed by
> +                * u-boot;
> +                */
> +               dev = pci_ctl->parent;
> +       }
> +
> +       prop = of_get_property(dev->of_node, "fsl,liodn", &len);
> +       if (prop)
> +               detach_domain(dev, dma_domain);
> +       else
> +               pr_err("missing fsl,liodn property at %s\n",
> +                         dev->of_node->full_name);
> +}

I understand why you need the LIODN when attaching, but why do you get it
in the detatch function.   You are not using "prop" here.

[cut]
> +static  bool check_pci_ctl_endpt_part(struct pci_controller *pci_ctl)
> +{
> +       u32 version;
> +
> +       /* Check the PCI controller version number by readding BRR1 register */
> +       version = in_be32(pci_ctl->cfg_addr + (PCI_FSL_BRR1 >> 2));
> +       version &= PCI_FSL_BRR1_VER;
> +       /* If PCI controller version is >= 0x204 we can partition endpoints*/
> +       if (version >= 0x204)
> +               return 1;
> +
> +       return 0;
> +}

Can we just use the compatible string here to identify the different
kinds of PCI
controllers?   Reading the actual device registers is ugly right now because
you are #defining the BRR1 stuff in a generic powerpc header.

> +static int fsl_pamu_add_device(struct device *dev)
> +{
> +       struct iommu_group *group = NULL;
> +       struct pci_dev *pdev;
> +       struct pci_dev *bridge, *dma_pdev = NULL;
> +       struct pci_controller *pci_ctl;
> +       int ret;
> +
> +       /*
> +        * For platform devices we allocate a separate group for
> +        * each of the devices.
> +        */
> +       if (dev->bus == &pci_bus_type) {
> +               bool pci_endpt_part;

That variable name is not clear, the abbreviations are not natural.  I
would just
call it pci_endpoint_partitioning.

> +               pdev = to_pci_dev(dev);
> +               /* Don't create device groups for virtual PCI bridges */
> +               if (pdev->subordinate)
> +                       return 0;
> +
> +               pci_ctl = pci_bus_to_host(pdev->bus);
> +               pci_endpt_part = check_pci_ctl_endpt_part(pci_ctl);
> +               /* We can partition PCIe devices so assign device group to the device */
> +               if (pci_endpt_part) {
> +                       bridge = pci_find_upstream_pcie_bridge(pdev);
> +                       if (bridge) {
> +                               if (pci_is_pcie(bridge))
> +                                       dma_pdev = pci_get_domain_bus_and_slot(
> +                                                               pci_domain_nr(pdev->bus),
> +                                                               bridge->subordinate->number, 0);
> +                               if (!dma_pdev)
> +                                       dma_pdev = pci_dev_get(bridge);
> +                       } else
> +                               dma_pdev = pci_dev_get(pdev);
> +                       /* Account for quirked devices */
> +                       swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
> +                       group = get_device_iommu_group(&pdev->dev);
> +                       pci_dev_put(pdev);
> +                       /*
> +                        * PCIe controller is not a paritionable entity
> +                        * free the controller device iommu_group.
> +                        */
> +                       if (pci_ctl->parent->iommu_group)
> +                               iommu_group_remove_device(pci_ctl->parent);
> +               } else {
> +                       /*
> +                        * All devices connected to the controller will share the
> +                        * PCI controllers device group. If this is the first
> +                        * device to be probed for the pci controller, copy the
> +                        * device group information from the PCI controller device
> +                        * node and remove the PCI controller iommu group.
> +                        * For subsequent devices, the iommu group information can
> +                        * be obtained from sibling devices (i.e. from the bus_devices
> +                        * link list).
> +                        */
> +                       if (pci_ctl->parent->iommu_group) {
> +                               group = get_device_iommu_group(pci_ctl->parent);
> +                               iommu_group_remove_device(pci_ctl->parent);
> +                       } else {
> +                               /* check if this is the first device on the bus*/
> +                               if (pdev->bus_list.next == pdev->bus_list.prev) {
> +                                       struct pci_bus *bus = pdev->bus->parent;
> +                                       int found = 0;
> +                                       /* Traverese the parent bus list to get
> +                                        * pdev & dev for the sibling device.
> +                                        */
> +                                       while (bus) {
> +                                               if (!list_empty(&bus->devices)) {
> +                                                       pdev = container_of(bus->devices.next,
> +                                                                struct pci_dev, bus_list);
> +                                                       group = iommu_group_get(&pdev->dev);
> +                                                       /*
> +                                                        * All devices should be associated with
> +                                                        * a group.
> +                                                        */
> +                                                       if (group)
> +                                                               found = 1;
> +                                                       break;
> +                                               } else
> +                                                       bus = bus->parent;
> +                                       }
> +                                       if (!found)
> +                                               dev_err(&pdev->dev, "Failed to allocate group for the device\n");
> +                               } else {
> +                                       /*
> +                                        * Get the pdev & dev for the sibling device
> +                                        */
> +                                       pdev = container_of(pdev->bus_list.prev, struct pci_dev, bus_list);
> +                                       group = iommu_group_get(&pdev->dev);
> +                               }
> +                       }
> +               }
> +       } else
> +               group = get_device_iommu_group(dev);
> +
> +       if (IS_ERR(group))
> +               return PTR_ERR(group);
> +
> +       ret = iommu_group_add_device(group, dev);
> +
> +       iommu_group_put(group);
> +       return ret;
> +}
> +

Regards,
Stuart
