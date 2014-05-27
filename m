Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaE0Nuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:50:54 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47297 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaE0Nuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:50:52 -0400
MIME-Version: 1.0
In-Reply-To: <1401178092-1228-6-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com> <1401178092-1228-6-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 May 2014 07:50:31 -0600
Message-ID: <CAErSpo7A17+VfQ524-VpdpCCtf93d980h-u+z6DnBtR6BoNmPg@mail.gmail.com>
Subject: Re: [Patch V3 05/37] x86, PCI, ACPI: use kmalloc_node() to optimize
 for performance
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 2:07 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Use kmalloc_node() instead of kmalloc() when possible to optimize
> for performance on NUMA platforms.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I think this is micro-optimization, because I don't think these
structures are referenced often.  It might be nicer if we could
arrange to run this path on the local node, as we do in
pci_call_probe(), so all allocs would happen there.  But I'm OK with
this as-is.

> ---
>  arch/x86/pci/acpi.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 01edac6c5e18..91bef49df228 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -448,7 +448,7 @@ static void probe_pci_root_info(struct pci_root_info *info,
>                 return;
>
>         size = sizeof(*info->res) * info->res_num;
> -       info->res = kzalloc(size, GFP_KERNEL);
> +       info->res = kzalloc_node(size, GFP_KERNEL, info->sd.node);
>         if (!info->res) {
>                 info->res_num = 0;
>                 return;
> @@ -456,7 +456,7 @@ static void probe_pci_root_info(struct pci_root_info *info,
>
>         size = sizeof(*info->res_offset) * info->res_num;
>         info->res_num = 0;
> -       info->res_offset = kzalloc(size, GFP_KERNEL);
> +       info->res_offset = kzalloc_node(size, GFP_KERNEL, info->sd.node);
>         if (!info->res_offset) {
>                 kfree(info->res);
>                 info->res = NULL;
> @@ -495,7 +495,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>         if (node != NUMA_NO_NODE && !node_online(node))
>                 node = NUMA_NO_NODE;
>
> -       info = kzalloc(sizeof(*info), GFP_KERNEL);
> +       info = kzalloc_node(sizeof(*info), GFP_KERNEL, node);
>         if (!info) {
>                 printk(KERN_WARNING "pci_bus %04x:%02x: "
>                        "ignored (out of memory)\n", domain, busnum);
> --
> 1.7.10.4
>
