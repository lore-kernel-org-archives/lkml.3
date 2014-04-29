Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbaD2RR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:17:29 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40810 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817AbaD2RRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:17:25 -0400
Date: Tue, 29 Apr 2014 19:17:20 +0200
From: Robert Richter <rric@kernel.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, andreas.herrmann3@amd.com, daniel@numascale.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, sp@numascale.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
Message-ID: <20140429171720.GL32718@rric.localhost>
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025323.2408.88764.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419025323.2408.88764.stgit@amt.stowe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to Boris I have the following:

On 18.04.14 20:53:23, Myron Stowe wrote:
> +#define AMD_PCIE_CF8(bus, dev, fn, reg) \
> +			(0x80000000 | \
> +			((reg & 0xF00) << 16) | \
> +			((bus & 0xF) << 16) | \
> +			((dev & 0x1F) << 11) | \
> +			((fn & 0x7) << 8) | \
> +			((reg & 0xFC)))

Make this a static function.

> +/* This version of read_pci_config allows reading registers in the ECS area */
> +static inline int _amd_read_pci_config(u8 bus, u8 slot, u8 fn, u32 offset)

No need to inline this, no need for a single tailing underscore.

> +{
> +	u32 value;
> +
> +	if ((!amd_early_ecs_enabled) && (offset > 0xFF))
> +		return -1;
> +
> +	outl(AMD_PCIE_CF8(bus, slot, fn, offset), 0xcf8);
> +	value = inl(0xcfc);
> +
> +	return value;

This design is broken. The return type does not match the functions
return value and you can't do error checking as -1 can be a value too.

Why reinventing this new instead of trying to reuse functions in
arch/x86/pci/direct.c/early.c or so?

Would an access via mmconfig space at this early stage possible? If so
this code could be skipped as we wouln't need it for fam10h (no early
access needed) nor fam15h or newer (mmconfig available).

> +}
> +
>  static struct pci_root_info __init *find_pci_root_info(int node, int link)
>  {
>  	struct pci_root_info *info;
> @@ -48,6 +81,9 @@ static struct pci_root_info __init *find_pci_root_info(int node, int link)
>  		if (info->node == node && info->link == link)
>  			return info;
>  
> +	pr_warn("AMD-Bus: WARNING: Failed to find root info for node %#x, link %#x\n",
> +		node, link);

As there might be (virtual) systems where this case is valid, I
wouldn't print anything here. We should only print things that exist
or error/warnings.

-Robert

> +
>  	return NULL;
>  }
>  
> @@ -118,6 +154,12 @@ static int __init early_fill_mp_bus_info(void)
>  
>  	pr_debug("Found AMD hostbridge at %x:%x.0\n", bus, slot);
