Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3LFGwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:52:38 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44460 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3LFGwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:52:36 -0500
MIME-Version: 1.0
In-Reply-To: <33026900.FbCAopDPFz@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<3611889.9a0SszCTpv@vostro.rjw.lan>
	<5750980.G76cQES87j@vostro.rjw.lan>
	<33026900.FbCAopDPFz@vostro.rjw.lan>
Date: Thu, 5 Dec 2013 22:52:36 -0800
X-Google-Sender-Auth: VRK9MuaPA1KYkuds07z0qluJBMM
Message-ID: <CAE9FiQV1KvpzfTmzbERS8heAE1z5zf=CjXnnjS9ZMBqmhY7rkw@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 6:49 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
>   for a device and its parent bridge via remove_callback().
>
>   In that case both code paths attempt to acquire
>   pci_remove_rescan_mutex.  If the child device removal acquires
>   it first, there will be no problems.  However, if the parent
>   bridge removal acquires it first, it will eventually execute
>   pci_destroy_dev() for the child device, but that device will
>   not be freed yet due to the reference held by the concurrent
>   child removal.  Consequently, both pci_stop_bus_device() and
>   pci_remove_bus_device() will be executed for that device
>   unnecessarily and pci_destroy_dev() will see a corrupted list
>   head in that object.  Moreover, an excess put_device() will
>   be executed for that device in that case which may lead to a
>   use-after-free in the final kobject_put() done by
>   sysfs_schedule_callback_work().
>
> Index: linux-pm/include/linux/pci.h
> ===================================================================
> --- linux-pm.orig/include/linux/pci.h
> +++ linux-pm/include/linux/pci.h
> @@ -321,6 +321,7 @@ struct pci_dev {
>         unsigned int    multifunction:1;/* Part of multi-function device */
>         /* keep track of device state */
>         unsigned int    is_added:1;
> +       unsigned int    is_gone:1;
>         unsigned int    is_busmaster:1; /* device is busmaster */
>         unsigned int    no_msi:1;       /* device may not use msi */
>         unsigned int    block_cfg_access:1;     /* config space access is blocked */
> Index: linux-pm/drivers/pci/remove.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/remove.c
> +++ linux-pm/drivers/pci/remove.c
> @@ -34,6 +34,7 @@ static void pci_stop_dev(struct pci_dev
>
>  static void pci_destroy_dev(struct pci_dev *dev)
>  {
> +       dev->is_gone = 1;
>         device_del(&dev->dev);
>
>         down_write(&pci_bus_sem);
> @@ -109,8 +110,10 @@ static void pci_remove_bus_device(struct
>   */
>  void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>  {
> -       pci_stop_bus_device(dev);
> -       pci_remove_bus_device(dev);
> +       if (!dev->is_gone) {
> +               pci_stop_bus_device(dev);
> +               pci_remove_bus_device(dev);
> +       }
>  }
>  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
>

Yes, above change should address sys double remove problem.

Thanks

Yinghai
