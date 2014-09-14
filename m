Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaINLmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 07:42:03 -0400
Received: from services.gouders.net ([141.101.32.176]:54355 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaINLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 07:42:00 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <1410691491-18000-1-git-send-email-andreas.noever@gmail.com>
	(Andreas Noever's message of "Sun, 14 Sep 2014 12:44:51 +0200")
References: <gh8uln71g1.fsf@lena.gouders.net>
	<1410691491-18000-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sun, 14 Sep 2014 13:40:46 +0200
Message-ID: <ghfvfu1lc1.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Noever <andreas.noever@gmail.com> writes:

> This is an implementation of fix 1 (Add a quirk to fix the _CRS information
> based on what amd_bus.c read from the hardware) which makes pci=nocrs ignore bus numbers from crs.
>
> If this works then we can add the board to the crs blacklist (Dirk can you attach the output of dmidecode to the bugzilla report?).

I attached the information to the bugzilla report.

Do you want me to test this fix as is or should I wait (e.g. for an
updated crs blacklist)?

Dirk

>
>
>
> ---
>  arch/x86/pci/acpi.c     |  7 +++----
>  arch/x86/pci/bus_numa.c | 12 +-----------
>  2 files changed, 4 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index cfd1b13..b073948 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -522,15 +522,14 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>  	} else {
>  		probe_pci_root_info(info, device, busnum, domain);
>  
> -		/* insert busn res at first */
> -		pci_add_resource(&resources,  &root->secondary);
>  		/*
>  		 * _CRS with no apertures is normal, so only fall back to
>  		 * defaults or native bridge info if we're ignoring _CRS.
>  		 */
> -		if (pci_use_crs)
> +		if (pci_use_crs) {
> +			pci_add_resource(&resources,  &root->secondary);
>  			add_resources(info, &resources);
> -		else {
> +		} else {
>  			free_pci_root_info_res(info);
>  			x86_pci_root_bus_resources(busnum, &resources);
>  		}
> diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
> index f3a2cfc..b735d0e 100644
> --- a/arch/x86/pci/bus_numa.c
> +++ b/arch/x86/pci/bus_numa.c
> @@ -31,8 +31,6 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
>  {
>  	struct pci_root_info *info = x86_find_pci_root_info(bus);
>  	struct pci_root_res *root_res;
> -	struct pci_host_bridge_window *window;
> -	bool found = false;
>  
>  	if (!info)
>  		goto default_resources;
> @@ -40,15 +38,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
>  	printk(KERN_DEBUG "PCI: root bus %02x: hardware-probed resources\n",
>  	       bus);
>  
> -	/* already added by acpi ? */
> -	list_for_each_entry(window, resources, list)
> -		if (window->res->flags & IORESOURCE_BUS) {
> -			found = true;
> -			break;
> -		}
> -
> -	if (!found)
> -		pci_add_resource(resources, &info->busn);
> +	pci_add_resource(resources, &info->busn);
>  
>  	list_for_each_entry(root_res, &info->resources, list) {
>  		struct resource *res;
