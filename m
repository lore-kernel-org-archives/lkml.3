Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3E1Xjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:39:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53679 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759267Ab3E1Xjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:39:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] ACPI, PCI: remove unused global list acpi_pci_roots in pci_root.c
Date: Wed, 29 May 2013 01:48:46 +0200
Message-ID: <2988573.Onrd73VTTU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3502693.GdBGlhPugI@vostro.rjw.lan>
References: <1368536439-19421-1-git-send-email-jiang.liu@huawei.com> <CAErSpo6-xtrNgPYxu_4QRtZs76P9B6b4JXQPENhX6hyNPpKx+g@mail.gmail.com> <3502693.GdBGlhPugI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 01:21:08 AM Rafael J. Wysocki wrote:
> On Tuesday, May 28, 2013 04:37:03 PM Bjorn Helgaas wrote:
> > On Tue, May 14, 2013 at 7:00 AM, Jiang Liu <liuj97@gmail.com> wrote:
> > > Now the global list acpi_pci_roots pci_root.c is useless, remove it.
> > >
> > > Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> > > Cc: Len Brown <lenb@kernel.org>
> > > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > Cc: linux-acpi@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  drivers/acpi/pci_root.c | 25 +++----------------------
> > >  include/acpi/acpi_bus.h |  1 -
> > >  2 files changed, 3 insertions(+), 23 deletions(-)
> > 
> > This and the "use acpi_handle_print()" patch look fine to me.
> > 
> > Rafael, I can take them, or if you want to take them yourself, you can add
> > 
> >   Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> OK, I'll take them.

Well, if I do that, there will be conflicts between our trees, so I think it's
better if you handle them.

Please add

	Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

to both.

Thanks,
Rafael


> > > diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> > > index b80e06e..91ddfd6 100644
> > > --- a/drivers/acpi/pci_root.c
> > > +++ b/drivers/acpi/pci_root.c
> > > @@ -65,10 +65,6 @@ static struct acpi_scan_handler pci_root_handler = {
> > >         .detach = acpi_pci_root_remove,
> > >  };
> > >
> > > -/* Lock to protect both acpi_pci_roots lists */
> > > -static DEFINE_MUTEX(acpi_pci_root_lock);
> > > -static LIST_HEAD(acpi_pci_roots);
> > > -
> > >  static DEFINE_MUTEX(osc_lock);
> > >
> > >  /**
> > > @@ -423,7 +419,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
> > >                 }
> > >         }
> > >
> > > -       INIT_LIST_HEAD(&root->node);
> > >         root->device = device;
> > >         root->segment = segment & 0xFFFF;
> > >         strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
> > > @@ -501,10 +496,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
> > >          * TBD: Need PCI interface for enumeration/configuration of roots.
> > >          */
> > >
> > > -       mutex_lock(&acpi_pci_root_lock);
> > > -       list_add_tail(&root->node, &acpi_pci_roots);
> > > -       mutex_unlock(&acpi_pci_root_lock);
> > > -
> > >         /*
> > >          * Scan the Root Bridge
> > >          * --------------------
> > > @@ -518,7 +509,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
> > >                             "Bus %04x:%02x not present in PCI namespace\n",
> > >                             root->segment, (unsigned int)root->secondary.start);
> > >                 result = -ENODEV;
> > > -               goto out_del_root;
> > > +               goto end;
> > >         }
> > >
> > >         /* ASPM setting */
> > > @@ -538,20 +529,13 @@ static int acpi_pci_root_add(struct acpi_device *device,
> > >         if (system_state != SYSTEM_BOOTING) {
> > >                 pcibios_resource_survey_bus(root->bus);
> > >                 pci_assign_unassigned_bus_resources(root->bus);
> > > -       }
> > > -
> > > -       /* need to after hot-added ioapic is registered */
> > > -       if (system_state != SYSTEM_BOOTING)
> > > +               /* need to after hot-added ioapic is registered */
> > >                 pci_enable_bridges(root->bus);
> > > +       }
> > >
> > >         pci_bus_add_devices(root->bus);
> > >         return 1;
> > >
> > > -out_del_root:
> > > -       mutex_lock(&acpi_pci_root_lock);
> > > -       list_del(&root->node);
> > > -       mutex_unlock(&acpi_pci_root_lock);
> > > -
> > >  end:
> > >         kfree(root);
> > >         return result;
> > > @@ -568,9 +552,6 @@ static void acpi_pci_root_remove(struct acpi_device *device)
> > >
> > >         pci_remove_root_bus(root->bus);
> > >
> > > -       mutex_lock(&acpi_pci_root_lock);
> > > -       list_del(&root->node);
> > > -       mutex_unlock(&acpi_pci_root_lock);
> > >         kfree(root);
> > >  }
> > >
> > > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > > index 22ba56e..4eb9a88 100644
> > > --- a/include/acpi/acpi_bus.h
> > > +++ b/include/acpi/acpi_bus.h
> > > @@ -447,7 +447,6 @@ int register_acpi_bus_type(struct acpi_bus_type *);
> > >  int unregister_acpi_bus_type(struct acpi_bus_type *);
> > >
> > >  struct acpi_pci_root {
> > > -       struct list_head node;
> > >         struct acpi_device * device;
> > >         struct pci_bus *bus;
> > >         u16 segment;
> > > --
> > > 1.8.1.2
> > >
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
