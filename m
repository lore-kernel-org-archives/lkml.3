Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab3GCVtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:49:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61893 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932241Ab3GCVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:49:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
Date: Wed, 03 Jul 2013 23:58:48 +0200
Message-ID: <2379111.jZKlkkBZzV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo5QQym0b828gq9sAjvh0SdbNhXo0mo8_dU1_52dTVO+GA@mail.gmail.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com> <1372860295-8306-7-git-send-email-mika.westerberg@linux.intel.com> <CAErSpo5QQym0b828gq9sAjvh0SdbNhXo0mo8_dU1_52dTVO+GA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 03, 2013 03:45:50 PM Bjorn Helgaas wrote:
> On Wed, Jul 3, 2013 at 8:04 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> > PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> > deeper in hierarchy:
> >
> > Device (RP05)
> > {
> >    // ...
> >    Device (HRUP)
> >    {
> >        // ...
> >        Device (HRDN)
> >        {
> >            // ...
> >            Device (EPUP)
> >            {
> >                // ...
> >                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
> >                {
> >                    Return (One)
> >                }
> >            }
> >        }
> >    }
> > }
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpi_pcihp.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> > index 2a47e82..d92ebfb 100644
> > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
> >         status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> >         if (ACPI_SUCCESS(status) && removable)
> >                 return 1;
> > +
> > +       /*
> > +        * Workaround for Thunderbolt implementation on Acer Aspire S5.
> > +        *
> > +        * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> > +        * slot (device under pci bridge). In Acer Aspire S5 case we have it
> > +        * deeper in hierarchy.
> 
> s/imeplementation/implementation/
> 
> If you're casting aspersions on Acer for having an incorrect ACPI
> implementation, you should probably provide a spec reference.  I think
> it's likely that the Acer implementation is actually correct per the
> spec, but Linux just isn't smart enough to handle it.

Agreed.

> > +        */
> > +       status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> > +                       &removable);
> > +       if (ACPI_SUCCESS(status) && removable)
> > +               return 1;
> > +
> >         return 0;
> >  }
> >
> > --
> > 1.8.3.2
> >

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
