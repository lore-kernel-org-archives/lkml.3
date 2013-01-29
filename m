Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3A2AyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:54:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58085 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3A2AyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:54:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
Date: Tue, 29 Jan 2013 02:00:17 +0100
Message-ID: <2666102.mmN6fgRYNJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <3500982.MUDp6kKU3R@vostro.rjw.lan> <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 28, 2013 02:09:22 PM Bjorn Helgaas wrote:
> On Sun, Jan 20, 2013 at 5:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, January 19, 2013 12:07:42 AM Jiang Liu wrote:
> >> As discussed in thread at https://patchwork.kernel.org/patch/1946851/,
> >> there's no value in supporting CONFIG_ACPI_PCI_SLOT=m any more.
> >> So change Kconfig and code to only support building pci_slot as
> >> built-in driver.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> I think we should eventually get rid of acpi_pci_register_driver() and
> do this initialization directly from acpi_pci_root_add().  But
> removing the module option here is a good first step.
> 
> Rafael, do you want to apply this (and [6/8]) via your tree?  If not,
> I can take it.

I will, thanks.

Rafael


> >> ---
> >>  drivers/acpi/Kconfig    |    5 +----
> >>  drivers/acpi/internal.h |    5 +++++
> >>  drivers/acpi/pci_slot.c |   13 +------------
> >>  drivers/acpi/scan.c     |    1 +
> >>  4 files changed, 8 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> >> index 0300bf6..7efd0d0 100644
> >> --- a/drivers/acpi/Kconfig
> >> +++ b/drivers/acpi/Kconfig
> >> @@ -299,7 +299,7 @@ config ACPI_DEBUG_FUNC_TRACE
> >>         is about half of the penalty and is rarely useful.
> >>
> >>  config ACPI_PCI_SLOT
> >> -     tristate "PCI slot detection driver"
> >> +     bool "PCI slot detection driver"
> >>       depends on SYSFS
> >>       default n
> >>       help
> >> @@ -308,9 +308,6 @@ config ACPI_PCI_SLOT
> >>         i.e., segment/bus/device/function tuples, with physical slots in
> >>         the system.  If you are unsure, say N.
> >>
> >> -       To compile this driver as a module, choose M here:
> >> -       the module will be called pci_slot.
> >> -
> >>  config X86_PM_TIMER
> >>       bool "Power Management Timer Support" if EXPERT
> >>       depends on X86
> >> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> >> index e050254..7374cfc 100644
> >> --- a/drivers/acpi/internal.h
> >> +++ b/drivers/acpi/internal.h
> >> @@ -67,6 +67,11 @@ struct acpi_ec {
> >>
> >>  extern struct acpi_ec *first_ec;
> >>
> >> +#ifdef       CONFIG_ACPI_PCI_SLOT
> >> +void acpi_pci_slot_init(void);
> >> +#else
> >> +static inline void acpi_pci_slot_init(void) { }
> >> +#endif
> >>  int acpi_pci_root_init(void);
> >>  int acpi_ec_init(void);
> >>  int acpi_ec_ecdt_probe(void);
> >> diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
> >> index d22585f..a7d7e77 100644
> >> --- a/drivers/acpi/pci_slot.c
> >> +++ b/drivers/acpi/pci_slot.c
> >> @@ -330,19 +330,8 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
> >>       {}
> >>  };
> >>
> >> -static int __init
> >> -acpi_pci_slot_init(void)
> >> +void __init acpi_pci_slot_init(void)
> >>  {
> >>       dmi_check_system(acpi_pci_slot_dmi_table);
> >>       acpi_pci_register_driver(&acpi_pci_slot_driver);
> >> -     return 0;
> >>  }
> >> -
> >> -static void __exit
> >> -acpi_pci_slot_exit(void)
> >> -{
> >> -     acpi_pci_unregister_driver(&acpi_pci_slot_driver);
> >> -}
> >> -
> >> -module_init(acpi_pci_slot_init);
> >> -module_exit(acpi_pci_slot_exit);
> >> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >> index f8a0d0f..cb964ac 100644
> >> --- a/drivers/acpi/scan.c
> >> +++ b/drivers/acpi/scan.c
> >> @@ -1732,6 +1732,7 @@ int __init acpi_scan_init(void)
> >>
> >>       acpi_power_init();
> >>       acpi_pci_root_init();
> >> +     acpi_pci_slot_init();
> >>
> >>       /*
> >>        * Enumerate devices in the ACPI namespace.
> >>
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
