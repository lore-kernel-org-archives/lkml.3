Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3GYTrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:47:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40210 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab3GYTrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:47:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
Date: Thu, 25 Jul 2013 21:57:47 +0200
Message-ID: <1658856.3PiOm7PIQU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVOKv-EBPFoVUi5HBPmDDrjmc9nuww68Tm865fkCJeWkA@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <6958813.eThhpoh5QO@vostro.rjw.lan> <CAE9FiQVOKv-EBPFoVUi5HBPmDDrjmc9nuww68Tm865fkCJeWkA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 06:25:06 AM Yinghai Lu wrote:
> On Wed, Jul 24, 2013 at 5:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, July 23, 2013 07:20:53 PM Yinghai Lu wrote:
> >> On Tue, Jul 23, 2013 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > [...]
> >
> >> [  102.631369] pci_host_bridge pci0000:00: freeing pci_host_bridge info
> >
> > By the way this looks fishy:
> >
> >> [  102.633091] ACPI: Device does not support D3cold
> >> [  102.633915] ACPI: Device does not support D3cold
> >> [  102.635221] ACPI: Device does not support D3cold
> >> [  102.636103] ACPI: Device does not support D3cold
> >> [  102.636902] ACPI: Device does not support D3cold
> >> [  102.637685] ACPI: Device does not support D3cold
> >> [  102.638467] ACPI: Device does not support D3cold
> >> [  102.639631] ACPI: Device does not support D3cold
> >> [  102.640472] ACPI: Device does not support D3cold
> >> [  102.641310] ACPI: Device does not support D3cold
> >> [  102.642105] ACPI: Device does not support D3cold
> >> [  102.642928] ACPI: Device does not support D3cold
> >> [  102.643725] ACPI: Device does not support D3cold
> >> [  102.644544] ACPI: Device does not support D3cold
> >> [  102.645344] ACPI: Device does not support D3cold
> >> [  102.646126] ACPI: Device does not support D3cold
> >> [  102.646902] ACPI: Device does not support D3cold
> >> [  102.647677] ACPI: Device does not support D3cold
> >> [  102.648485] ACPI: Device does not support D3cold
> >> [  102.649269] ACPI: Device does not support D3cold
> >> [  102.650065] ACPI: Device does not support D3cold
> >> [  102.650822] ACPI: Device does not support D3cold
> >> [  102.652483] ACPI: Device does not support D3cold
> >> [  102.654157] ACPI: Device does not support D3cold
> >> [  102.655803] ACPI: Device does not support D3cold
> >> [  102.657419] ACPI: Device does not support D3cold
> >> [  102.658528] ACPI: Device does not support D3cold
> >> [  102.659255] ACPI: Device does not support D3cold
> >> [  102.659973] ACPI: Device does not support D3cold
> >> [  102.661807] ACPI: Device does not support D3cold
> >> [  102.661925] ACPI: Device does not support D3cold
> >> [  102.662047] ACPI: Device does not support D3cold
> >> [  102.662148] ACPI: Device does not support D3cold
> >> [  102.662258] ACPI: Device does not support D3cold
> >> [  102.662374] ACPI: Device does not support D3cold
> >> [  102.662486] ACPI: Device does not support D3cold
> >> [  102.662597] ACPI: Device does not support D3cold
> >> [  102.662711] ACPI: Device does not support D3cold
> >> [  102.662814] ACPI: Device does not support D3cold
> >> [  102.662918] ACPI: Device does not support D3cold
> >> [  102.663019] ACPI: Device does not support D3cold
> >
> > Can you please check if it goes away with the patch below applied?
> >
> >> [  102.663039] ACPI: \_SB_.PCI0: No _EJ0 support for device
> >
> >
> > ---
> >  drivers/acpi/device_pm.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > Index: linux-pm/drivers/acpi/device_pm.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/device_pm.c
> > +++ linux-pm/drivers/acpi/device_pm.c
> > @@ -159,7 +159,8 @@ int acpi_device_set_power(struct acpi_de
> >         int result = 0;
> >         bool cut_power = false;
> >
> > -       if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> > +       if (!device || !device->flags.power_manageable
> > +           || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> >                 return -EINVAL;
> >
> >         /* Make sure this is a valid target state */
> >
> 
> yes, with this change, those print out are gone.

Cool, thanks!

Rafael

