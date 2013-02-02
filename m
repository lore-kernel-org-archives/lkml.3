Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3BBL6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 06:58:54 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:64228 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797Ab3BBL6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 06:58:52 -0500
Message-ID: <1359806321.30277.3.camel@infinity>
Subject: Re: [PATCH 1/2] ACPI / scan: Make namespace scanning and trimming
 mutually exclusive
From: Steven Newbury <steve@snewbury.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Date: Sat, 02 Feb 2013 11:58:41 +0000
In-Reply-To: <CAE9FiQV+DDb0ap=sipQjUWCdz8Qsfs2dYDVrb0FmKL4F1BjhOw@mail.gmail.com>
References: <1581701.fnbebHrKch@vostro.rjw.lan>
	 <3032117.IcK9I7rYQT@vostro.rjw.lan>
	 <CAE9FiQV+DDb0ap=sipQjUWCdz8Qsfs2dYDVrb0FmKL4F1BjhOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=aSmuriqxytUA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=UAOgjMSbS-LR0liV_TYA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=LI9Vle30uBYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 15:19 -0800, Yinghai Lu wrote:
> On Sat, Jan 26, 2013 at 2:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > There is no guarantee that acpi_bus_scan() and acpi_bus_trim() will
> > not be run in parallel for the same scope of the ACPI namespace,
> > which may lead to a great deal of confusion, so introduce a new mutex
> > to prevent that from happening.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> 
> Steven,
> 
> Can you apply this one to for-pci-res-alloc to check if racing with
> docking hotplug/eject
> still happen?
> or wait one or two days after i rebase that branch.

Tried merging with linux-pm/bleeding-edge, same behaviour:

[ 3589.013578] ACPI: \_SB_.PCI0.PCIE.GDCK: undocking
[ 3589.585356] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none
[ 3589.585422] ACPI: Delete PCI Interrupt Routing Table for 0000:04
[ 3589.585426] pci 0000:03:08.0: Oops, 'acpi_handle' corrupt
[ 3589.585446] pci_bus 0000:04: busn_res: [bus 04] is released

03:08.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
Express-to-PCI Bridge (rev aa)
04:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI
Manhattan [Mobility Radeon HD 5430 Series]
04:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI Cedar HDMI
Audio [Radeon HD 5400/6300 Series]


> > ---
> >  drivers/acpi/scan.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -52,6 +52,7 @@ static const struct acpi_device_id acpi_
> >
> >  static LIST_HEAD(acpi_device_list);
> >  static LIST_HEAD(acpi_bus_id_list);
> > +static DEFINE_MUTEX(acpi_scan_lock);
> >  DEFINE_MUTEX(acpi_device_lock);
> >  LIST_HEAD(acpi_wakeup_device_list);
> >
> > @@ -1612,19 +1613,22 @@ static acpi_status acpi_bus_device_attac
> >  int acpi_bus_scan(acpi_handle handle)
> >  {
> >         void *device = NULL;
> > +       int error = 0;
> > +
> > +       mutex_lock(&acpi_scan_lock);
> >
> >         if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
> >                 acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> >                                     acpi_bus_check_add, NULL, NULL, &device);
> >
> >         if (!device)
> > -               return -ENODEV;
> > -
> > -       if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
> > +               error = -ENODEV;
> > +       else if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
> >                 acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> >                                     acpi_bus_device_attach, NULL, NULL, NULL);
> >
> > -       return 0;
> > +       mutex_unlock(&acpi_scan_lock);
> > +       return error;
> >  }
> >  EXPORT_SYMBOL(acpi_bus_scan);
> >
> > @@ -1653,6 +1657,8 @@ static acpi_status acpi_bus_remove(acpi_
> >
> >  void acpi_bus_trim(struct acpi_device *start)
> >  {
> > +       mutex_lock(&acpi_scan_lock);
> > +
> >         /*
> >          * Execute acpi_bus_device_detach() as a post-order callback to detach
> >          * all ACPI drivers from the device nodes being removed.
> > @@ -1667,6 +1673,8 @@ void acpi_bus_trim(struct acpi_device *s
> >         acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
> >                             acpi_bus_remove, NULL, NULL);
> >         acpi_bus_remove(start->handle, 0, NULL, NULL);
> > +
> > +       mutex_unlock(&acpi_scan_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(acpi_bus_trim);
> >
> >


