Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaDTKVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 06:21:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbaDTKVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 06:21:13 -0400
Date: Sun, 20 Apr 2014 12:21:05 +0200
From: Borislav Petkov <bp@suse.de>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, daniel@numascale.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, sp@numascale.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] ACPI/PCI: Warn if we have to "guess" host bridge
 node information
Message-ID: <20140420102105.GA19676@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025339.2408.17866.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140419025339.2408.17866.stgit@amt.stowe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:53:39PM -0600, Myron Stowe wrote:
> The vast majority of platforms are not supplying ACPI _PXM (proximity)
> information corresponding to host bridge (PNP0A03/PNP0A08) devices
> resulting in sysfs "numa_node" values of -1 (NUMA_NO_NODE) [1]:
>   # for i in /sys/devices/pci0000\:00/*/numa_node; do cat $i; done | uniq
>   -1
> 
>   # find /sys/ -name "numa_node" | while read fname; do cat $fname; \
>     done | uniq
>   -1
> 
> AMD based platforms provide a fall-back for this situation via amd_bus.c.
> These platforms snoop out the information by directly reading specific
> registers from the Northbridge and caching them via 'alloc_pci_root_info'.
> 
> Later during boot processing when host bridges are discovered -
> 'pci_acpi_scan_root' - the kernel looks for their corresponding ACPI _PXM
> method - drivers/acpi/numa.c::acpi_get_node().  If the BIOS supplied a
> _PXM method then that node (proximity) value is associated.  If the BIOS
> did not supply a _PXM method *and* the platform is AMD based, the
> fall-back cached values obtained directly from the Northbridge are used;
> otherwise, "NUMA_NO_NODE" is associated.
> 
> There are a number of issues with this fall-back mechanism the most
> notable being that amd_bus.c extracts a 3-bit number from a CPU register
> and uses it as the node number.  The node numbers used by Linux are
> logical and there's no reason they need to be identical to settings in the
> CPU registers.  So if we have some node information obtained in the normal
> way (from _PXM, SLIT, SRAT, etc.) and some from amd_bus.c, there's no
> reason to believe they will be compatible.
> 
> This patch warns when this situation occurs:
>   pci_root PNP0A08:00: [Firmware Bug]: No _PXM; guessing node number 0
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=72051
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
> 
>  arch/x86/pci/acpi.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 01edac6..80c09ba 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -489,8 +489,12 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>  	}
>  
>  	node = acpi_get_node(device->handle);
> -	if (node == NUMA_NO_NODE)
> +	if (node == NUMA_NO_NODE) {
>  		node = x86_pci_root_bus_node(busnum);
> +		if (node != NUMA_NO_NODE)
> +			dev_info(&device->dev, FW_BUG "No _PXM; guessing node number %x\n",

Hmm, I'm not really convinced this message is user-friendly enough. Can
we be more descriptive here please?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
