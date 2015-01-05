Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbbAEJQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:16:12 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:56750 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbbAEJQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:16:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robh@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] pci: introduce common pci config space accessors
Date: Mon, 05 Jan 2015 10:16:06 +0100
Message-ID: <2224125.SvyFyDvrch@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420424374-32412-1-git-send-email-robh@kernel.org>
References: <1420424374-32412-1-git-send-email-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:cOotyeaQJUZ1cFhqfDqHaDzRZZShbZYFcJoqwZH0YMmMc8EQbCe
 0j1tAvlRkzajWNF+M2mSZSFzBh1MqM+Lb5zXZhk4Yxjx6NJYV8R9l5elqBSW12zvPIxSOTA
 rKXeNu1A+D7GlbuZfBXEpXqpWDPMWj9EvW3xsELE+DIoSWJlRZC6kusJuSpys8yYfMv5JCF
 kpwkuMiANgNK/p7Ue1LiA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2015 20:19:34 Rob Herring wrote:
> Many PCI controllers' configuration space accesses are memory mapped
> varying only in address calculation and access checks. There are 2 main
> access methods: a decoded address space such as ECAM or a single address
> and data register similar to x86. This implementation can support both
> cases as well as be used in cases that need additional pre or post access
> handling.
> 
> A new pci_ops member map_bus is introduced which can do access checks and
> any necessary setup. It returns the address to use for the configuration
> space access. The access types supported are 32-bit only accesses or
> correct byte, word, or dword sized accesses.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

I think this looks very nice, and I don't mind using it as-is, but I'd
like to put up some variations for discussions so we get the best
implementation -- we should try not to change it again soon if someone
comes up with a slightly better way later ;-)

> I've converted a few drivers already. I'll send patches for them after
> some feedback on this. Most already have some function similar to what is
> needed for map_bus, so the conversion is pretty simple. This certainly
> isn't a complete list of possible users. The diffstat so far looks like
> this:
> 
>  arch/arm/mach-cns3xxx/pcie.c          |  46 +++-------------------
>  arch/arm/mach-integrator/pci_v3.c     |  61 +++---------------------------
>  arch/arm/mach-ks8695/pci.c            |  75 +++---------------------------------
>  arch/arm/mach-sa1100/pci-nanoengine.c |  94 ++++-----------------------------------------
>  arch/powerpc/platforms/powermac/pci.c | 206 +++++++++++++++++++--------------------------------------------------------------------------------
>  arch/powerpc/sysdev/fsl_pci.c         |  46 ++--------------------
>  drivers/pci/host/pci-host-generic.c   |  51 ++-----------------------
>  drivers/pci/host/pci-rcar-gen2.c      |  51 ++-----------------------
>  drivers/pci/host/pci-tegra.c          |  55 ++-------------------------
>  drivers/pci/host/pci-xgene.c          | 150 +++++-------------------------------------------------------------------
>  drivers/pci/host/pcie-xilinx.c        |  88 +++++-------------------------------------
>  11 files changed, 93 insertions(+), 830 deletions(-)

Awesome!

> +int pci_generic_config_read(struct pci_bus *bus, unsigned int devfn,
> +			    int where, int size, u32 *val)
> +{
> +	void __iomem *addr;
> +
> +	addr = bus->ops->map_bus(bus, devfn, where);
> +	if (!addr) {
> +		*val = ~0;
> +		return PCIBIOS_DEVICE_NOT_FOUND;
> +	}
> +
> +	if (size == 1)
> +		*val = readb(addr);
> +	else if (size == 2)
> +		*val = readw(addr);
> +	else
> +		*val = readl(addr);
> +
> +	return PCIBIOS_SUCCESSFUL;
> +}

PCI host controller drivers can be loadable modules these days, so
the functions clearly need to be exported.

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 360a966..e7fd519 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -560,6 +560,7 @@ static inline int pcibios_err_to_errno(int err)
>  /* Low-level architecture-dependent routines */
> 
>  struct pci_ops {
> +	void __iomem *(*map_bus)(struct pci_bus *bus, unsigned int devfn, int where);
>  	int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
>  	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
>  };

In various other contexts, we have recently discussed adding new callbacks
to struct pci_host_bridge, or an operations structure below it. I don't see
a strong reason for one place or the other, but maybe someone else does.
If we put it into pci_host_bridge_ops, the first argument would need to
be the pci_host_bridge pointer of course.

For the common map_bus implementations, it would also be nice to put them
into the same file as your new access functions, but then we need a common
location to store at least one __iomem pointer. I guess that place could
either be struct pci_host_bridge or struct pci_bus. In theory, struct pci_ops
would work too, but then we could no longer mark it 'const' in host bridge
drivers.

If we have a common set of map_bus functions, we can even export the
pci_ops structures from drivers/pci/access.c:

const struct pci_ops pci_generic_ecam_ops = {
	.map_bus	= ecam_map_bus,
	.read		= pci_generic_config_read,
	.write		= pci_generic_config_write,
};
EXPORT_SYMBOL_GPL(pci_generic_ecam_ops);

That could of course be done in a follow-up patch, it doesn't have to be
part of your patch, but it would be good to be prepared.

	Arnd
