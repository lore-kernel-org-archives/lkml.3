Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3EXTgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:36:37 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:37936 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3EXTgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130509195135.16108.70845.stgit@grignak.americas.hpqcorp.net>
References: <20130509195135.16108.70845.stgit@grignak.americas.hpqcorp.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 24 May 2013 13:36:14 -0600
Message-ID: <CAErSpo4_h+yrjGTEpJ-Q=nwfcd3xi0qa0z6NQad1EQDZom8kUQ@mail.gmail.com>
Subject: Re: [PATCH v2] aerdrv: Move cper_print_aer() call out of interrupt context
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:51 PM, Lance Ortiz <lance.ortiz@hp.com> wrote:
> The following warning was seen on 3.9 when a corrected PCIe error was being
> handled by the AER subsystem.
>
> WARNING: at .../drivers/pci/search.c:214 pci_get_dev_by_id+0x8a/0x90()
>
> This occurred because a call to pci_get_domain_bus_and_slot() was added to
> cper_print_pcie() to setup for the call to cper_print_aer().  The warning
> showed up because cper_print_pcie() is called in an interrupt context and
> pci_get* functions are not supposed to be called in that context.
>
> The solution is to move the cper_print_aer() call out of the interrupt
> context and into aer_recover_work_func() to avoid any warnings when calling
> pci_get* functions.
>
> v2 - Re-worded header text.  Removed prefix arg from cper_print_aer().
>      Added TODO message in cper_print_aer().
>
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> ---
>
>  drivers/acpi/apei/cper.c               |   18 ------------------
>  drivers/acpi/apei/ghes.c               |    3 ++-
>  drivers/pci/pcie/aer/aerdrv_core.c     |    6 +++++-
>  drivers/pci/pcie/aer/aerdrv_errprint.c |   10 ++++++++--
>  include/linux/aer.h                    |    4 ++--
>  5 files changed, 17 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 1e5d8a4..8713229 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -250,10 +250,6 @@ static const char *cper_pcie_port_type_strs[] = {
>  static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>                             const struct acpi_hest_generic_data *gdata)
>  {
> -#ifdef CONFIG_ACPI_APEI_PCIEAER
> -       struct pci_dev *dev;
> -#endif
> -
>         if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
>                 printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
>                        pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
> @@ -285,20 +281,6 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>                 printk(
>         "%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
>         pfx, pcie->bridge.secondary_status, pcie->bridge.control);
> -#ifdef CONFIG_ACPI_APEI_PCIEAER
> -       dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> -                       pcie->device_id.bus, pcie->device_id.function);
> -       if (!dev) {
> -               pr_err("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> -                       pcie->device_id.segment, pcie->device_id.bus,
> -                       pcie->device_id.slot, pcie->device_id.function);
> -               return;
> -       }
> -       if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO)
> -               cper_print_aer(pfx, dev, gdata->error_severity,
> -                               (struct aer_capability_regs *) pcie->aer_info);
> -       pci_dev_put(dev);
> -#endif
>  }
>
>  static const char *apei_estatus_section_flag_strs[] = {
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index d668a8a..f2084b5 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -454,7 +454,8 @@ static void ghes_do_proc(struct ghes *ghes,
>                                 aer_severity = cper_severity_to_aer(sev);
>                                 aer_recover_queue(pcie_err->device_id.segment,
>                                                   pcie_err->device_id.bus,
> -                                                 devfn, aer_severity);
> +                                                 devfn, aer_severity,
> +                                                 pcie_err->aer_info);
>                         }
>
>                 }
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 564d97f..ceba124 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -582,6 +582,7 @@ struct aer_recover_entry
>         u8      devfn;
>         u16     domain;
>         int     severity;
> +       u8      *regs;
>  };
>
>  static DEFINE_KFIFO(aer_recover_ring, struct aer_recover_entry,
> @@ -595,7 +596,7 @@ static DEFINE_SPINLOCK(aer_recover_ring_lock);
>  static DECLARE_WORK(aer_recover_work, aer_recover_work_func);
>
>  void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
> -                      int severity)
> +                      int severity, u8 *aer_regs)
>  {
>         unsigned long flags;
>         struct aer_recover_entry entry = {
> @@ -603,6 +604,7 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
>                 .devfn          = devfn,
>                 .domain         = domain,
>                 .severity       = severity,
> +               .regs           = aer_regs,
>         };
>
>         spin_lock_irqsave(&aer_recover_ring_lock, flags);
> @@ -629,6 +631,8 @@ static void aer_recover_work_func(struct work_struct *work)
>                                PCI_SLOT(entry.devfn), PCI_FUNC(entry.devfn));
>                         continue;
>                 }
> +               cper_print_aer(pdev, entry.severity,
> +                               (struct aer_capability_regs *)entry.regs);

I like this change a lot because pci_get_domain_bus_and_slot() is sort
of a dubious interface to begin with, and we were using it twice in
this path -- once in cper_print_pcie() and then again (for the exact
same device) here in aer_recover_work_func() -- and this patch gets
rid of the first one.

Normally we shouldn't have to look up a pci_dev from a bus
number/device number.  This is an exception because there's no
connection between the life of a pci_dev in the kernel and the
information from firmware, so there's not really a better way to do
it.

>                 do_recovery(pdev, entry.severity);
>                 pci_dev_put(pdev);
>         }
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 5ab1425..f277dc3 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -220,13 +220,19 @@ int cper_severity_to_aer(int cper_severity)
>  }
>  EXPORT_SYMBOL_GPL(cper_severity_to_aer);
>
> -void cper_print_aer(const char *prefix, struct pci_dev *dev, int cper_severity,
> +void cper_print_aer(struct pci_dev *dev, int cper_severity,
>                     struct aer_capability_regs *aer)
>  {
>         int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
>         u32 status, mask;
>         const char **status_strs;
>
> +       /*
> +        * TODO: This function needs to be re-written so that it's output
> +        * matches the output of aer_print_error().  Right now, the output
> +        * is formatted very differently.
> +        */
> +
>         aer_severity = cper_severity_to_aer(cper_severity);
>         if (aer_severity == AER_CORRECTABLE) {
>                 status = aer->cor_status;
> @@ -244,7 +250,7 @@ void cper_print_aer(const char *prefix, struct pci_dev *dev, int cper_severity,
>         agent = AER_GET_AGENT(aer_severity, status);
>         dev_err(&dev->dev, "aer_status: 0x%08x, aer_mask: 0x%08x\n",
>                status, mask);
> -       cper_print_bits(prefix, status, status_strs, status_strs_size);
> +       cper_print_bits("", status, status_strs, status_strs_size);
>         dev_err(&dev->dev, "aer_layer=%s, aer_agent=%s\n",
>                aer_error_layer[layer], aer_agent_string[agent]);
>         if (aer_severity != AER_CORRECTABLE)
> diff --git a/include/linux/aer.h b/include/linux/aer.h
> index ec10e1b..d8cf12b 100644
> --- a/include/linux/aer.h
> +++ b/include/linux/aer.h
> @@ -49,10 +49,10 @@ static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
>  }
>  #endif
>
> -extern void cper_print_aer(const char *prefix, struct pci_dev *dev,
> +extern void cper_print_aer(struct pci_dev *dev,
>                            int cper_severity, struct aer_capability_regs *aer);
>  extern int cper_severity_to_aer(int cper_severity);
>  extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
> -                             int severity);
> +                             int severity,  u8 *aer_regs);

Can the aer_regs type be made "struct aer_capability_regs *"?  It'd be
nice if we could avoid the casting when passing the pointer around.
We might still need a cast in ghes_do_proc() when calling
aer_recover_queue(), but I *think* everyplace else would be OK with
keeping the exact type.

Bjorn
