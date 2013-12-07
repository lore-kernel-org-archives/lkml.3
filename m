Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab3LGVbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 16:31:01 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45737 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3LGVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 16:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <1385590765-23094-1-git-send-email-khalid.aziz@oracle.com>
References: <1385590765-23094-1-git-send-email-khalid.aziz@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 7 Dec 2013 14:30:36 -0700
Message-ID: <CAErSpo4cm12_mN8EvAfsrrdg=r9YBFVspeLoe-9k-N1pNmqg7w@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Clear Bus Master bit only on kexec reboot
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Chang Liu <cl91tp@gmail.com>, "lan,Tianyu" <tianyu.lan@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Felix Deichmann <jility09@gmail.com>, Florian Otti <f.otti@gmx.at>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 3:19 PM, Khalid Aziz <khalid.aziz@oracle.com> wrote:
> Add a flag to tell the PCI subsystem that kernel is shutting down
> in prepapration to kexec a kernel. Add code in PCI subsystem to use
> this flag to clear Bus Master bit on PCI devices only in case of
> kexec reboot. This fixes https://bugzilla.kernel.org/show_bug.cgi?id=63861
> and avoids any other issues caused by clearing Bus Master bit on PCI
> devices in normal shutdown path. This patch is based on discussion at
> http://marc.info/?l=linux-pci&m=138425645204355&w=2
>
> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
> Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Cc: stable@vger.kernel.org

Applied to my for-linus branch for v3.13, thanks!

Bjorn

> ---
> Changes since v1:
>         - Moved kexec_in_progress flag from pci.h to kexec.h
>         - Changed the type for kexec_in_progress flag to bool
>         - Added #ifdef CONFIG_KEXEC to code in pci-driver.c to
>           ensure it builds with CONFIG_KEXEC not set.
>
>  drivers/pci/pci-driver.c | 12 +++++++++---
>  include/linux/kexec.h    |  3 +++
>  kernel/kexec.c           |  4 ++++
>  3 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 9042fdb..8eca81a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -19,6 +19,7 @@
>  #include <linux/cpu.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/suspend.h>
> +#include <linux/kexec.h>
>  #include "pci.h"
>
>  struct pci_dynid {
> @@ -399,12 +400,17 @@ static void pci_device_shutdown(struct device *dev)
>         pci_msi_shutdown(pci_dev);
>         pci_msix_shutdown(pci_dev);
>
> +#ifdef CONFIG_KEXEC
>         /*
> -        * Turn off Bus Master bit on the device to tell it to not
> -        * continue to do DMA. Don't touch devices in D3cold or unknown states.
> +        * If this is a kexec reboot, turn off Bus Master bit on the
> +        * device to tell it to not continue to do DMA. Don't touch
> +        * devices in D3cold or unknown states.
> +        * If it is not a kexec reboot, firmware will hit the PCI
> +        * devices with big hammer and stop their DMA any way.
>          */
> -       if (pci_dev->current_state <= PCI_D3hot)
> +       if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
>                 pci_clear_master(pci_dev);
> +#endif
>  }
>
>  #ifdef CONFIG_PM
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index d78d28a..5fd33dc 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -198,6 +198,9 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
>  extern size_t vmcoreinfo_size;
>  extern size_t vmcoreinfo_max_size;
>
> +/* flag to track if kexec reboot is in progress */
> +extern bool kexec_in_progress;
> +
>  int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
>                 unsigned long long *crash_size, unsigned long long *crash_base);
>  int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 490afc0..d0d8fca 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -47,6 +47,9 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
>  size_t vmcoreinfo_size;
>  size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
>
> +/* Flag to indicate we are going to kexec a new kernel */
> +bool kexec_in_progress = false;
> +
>  /* Location of the reserved area for the crash kernel */
>  struct resource crashk_res = {
>         .name  = "Crash kernel",
> @@ -1675,6 +1678,7 @@ int kernel_kexec(void)
>         } else
>  #endif
>         {
> +               kexec_in_progress = true;
>                 kernel_restart_prepare(NULL);
>                 printk(KERN_EMERG "Starting new kernel\n");
>                 machine_shutdown();
> --
> 1.8.3.2
>
