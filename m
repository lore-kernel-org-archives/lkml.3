Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3BCXbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:31:49 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60150 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab3BCXbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:31:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Myron Stowe <mstowe@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
Date: Mon, 04 Feb 2013 00:38 +0100
Message-ID: <2520964.6C1RTjdEJr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359931635.2426.98.camel@zim.stowe>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com> <1359931635.2426.98.camel@zim.stowe>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 03, 2013 03:47:15 PM Myron Stowe wrote:
> On Mon, 2013-01-28 at 14:09 -0700, Bjorn Helgaas wrote:
> > On Sun, Jan 20, 2013 at 5:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Saturday, January 19, 2013 12:07:42 AM Jiang Liu wrote:
> > >> As discussed in thread at https://patchwork.kernel.org/patch/1946851/,
> > >> there's no value in supporting CONFIG_ACPI_PCI_SLOT=m any more.
> > >> So change Kconfig and code to only support building pci_slot as
> > >> built-in driver.
> > >>
> > >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> > >
> > > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > I think we should eventually get rid of acpi_pci_register_driver() and
> > do this initialization directly from acpi_pci_root_add().  But
> > removing the module option here is a good first step.
> 
> Bjorn, Rafael:
> 
> If either of you are interested in that still let me know and I can
> re-work any or all of the "PCI/ACPI: Remove "pci_root" sub-driver
> support" series - https://lkml.org/lkml/2012/12/7/11

I am.  However, I think it's better to wait with the rework until our trees
are merged into the mainline, so that you can base the patchset on a common
tree.

> Note [PATCH 13/15] was effectively the same as below and continued on
> with initializing directly from acpi_pci_root_add() in [PATCH 14/15].
> There may have been worthwhile fixes in some of the earlier content such
> as [PATCH 11/15] worth re-considering also.

Well, as I said.  All of the patches in the series making sense after v3.9-rc1
will be interesting to me certainly.

Thanks,
Rafael


> > Rafael, do you want to apply this (and [6/8]) via your tree?  If not,
> > I can take it.
> > 
> > >> ---
> > >>  drivers/acpi/Kconfig    |    5 +----
> > >>  drivers/acpi/internal.h |    5 +++++
> > >>  drivers/acpi/pci_slot.c |   13 +------------
> > >>  drivers/acpi/scan.c     |    1 +
> > >>  4 files changed, 8 insertions(+), 16 deletions(-)
> > >>
> > >> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > >> index 0300bf6..7efd0d0 100644
> > >> --- a/drivers/acpi/Kconfig
> > >> +++ b/drivers/acpi/Kconfig
> > >> @@ -299,7 +299,7 @@ config ACPI_DEBUG_FUNC_TRACE
> > >>         is about half of the penalty and is rarely useful.
> > >>
> > >>  config ACPI_PCI_SLOT
> > >> -     tristate "PCI slot detection driver"
> > >> +     bool "PCI slot detection driver"
> > >>       depends on SYSFS
> > >>       default n
> > >>       help
> > >> @@ -308,9 +308,6 @@ config ACPI_PCI_SLOT
> > >>         i.e., segment/bus/device/function tuples, with physical slots in
> > >>         the system.  If you are unsure, say N.
> > >>
> > >> -       To compile this driver as a module, choose M here:
> > >> -       the module will be called pci_slot.
> > >> -
> > >>  config X86_PM_TIMER
> > >>       bool "Power Management Timer Support" if EXPERT
> > >>       depends on X86
> > >> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> > >> index e050254..7374cfc 100644
> > >> --- a/drivers/acpi/internal.h
> > >> +++ b/drivers/acpi/internal.h
> > >> @@ -67,6 +67,11 @@ struct acpi_ec {
> > >>
> > >>  extern struct acpi_ec *first_ec;
> > >>
> > >> +#ifdef       CONFIG_ACPI_PCI_SLOT
> > >> +void acpi_pci_slot_init(void);
> > >> +#else
> > >> +static inline void acpi_pci_slot_init(void) { }
> > >> +#endif
> > >>  int acpi_pci_root_init(void);
> > >>  int acpi_ec_init(void);
> > >>  int acpi_ec_ecdt_probe(void);
> > >> diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
> > >> index d22585f..a7d7e77 100644
> > >> --- a/drivers/acpi/pci_slot.c
> > >> +++ b/drivers/acpi/pci_slot.c
> > >> @@ -330,19 +330,8 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
> > >>       {}
> > >>  };
> > >>
> > >> -static int __init
> > >> -acpi_pci_slot_init(void)
> > >> +void __init acpi_pci_slot_init(void)
> > >>  {
> > >>       dmi_check_system(acpi_pci_slot_dmi_table);
> > >>       acpi_pci_register_driver(&acpi_pci_slot_driver);
> > >> -     return 0;
> > >>  }
> > >> -
> > >> -static void __exit
> > >> -acpi_pci_slot_exit(void)
> > >> -{
> > >> -     acpi_pci_unregister_driver(&acpi_pci_slot_driver);
> > >> -}
> > >> -
> > >> -module_init(acpi_pci_slot_init);
> > >> -module_exit(acpi_pci_slot_exit);
> > >> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > >> index f8a0d0f..cb964ac 100644
> > >> --- a/drivers/acpi/scan.c
> > >> +++ b/drivers/acpi/scan.c
> > >> @@ -1732,6 +1732,7 @@ int __init acpi_scan_init(void)
> > >>
> > >>       acpi_power_init();
> > >>       acpi_pci_root_init();
> > >> +     acpi_pci_slot_init();
> > >>
> > >>       /*
> > >>        * Enumerate devices in the ACPI namespace.
> > >>
> > > --
> > > I speak only for myself.
> > > Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
