Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161997AbaKOA00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 19:26:26 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40276 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161621AbaKOA0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 19:26:24 -0500
Date: Fri, 14 Nov 2014 17:26:18 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Don't reject 64bit mmio on 32bit/PAE mode
Message-ID: <20141115002618.GA4280@google.com>
References: <1415937550-14469-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415937550-14469-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 07:59:10PM -0800, Yinghai Lu wrote:
> Aaron reported 32bit/PAE mode, has problem with 64bit resource.
> 
> [    6.610012] pci 0000:03:00.0: reg 0x10: [mem 0x383fffc00000-0x383fffdfffff 64bit pref]
> [    6.622195] pci 0000:03:00.0: reg 0x20: [mem 0x383fffe04000-0x383fffe07fff 64bit pref]
> [    6.656112] pci 0000:03:00.1: reg 0x10: [mem 0x383fffa00000-0x383fffbfffff 64bit pref]
> [    6.668293] pci 0000:03:00.1: reg 0x20: [mem 0x383fffe00000-0x383fffe03fff 64bit pref]
> [    6.702055] pci 0000:00:02.2: PCI bridge to [bus 03-04]
> [    6.706434] pci 0000:00:02.2:   bridge window [io  0x1000-0x1fff]
> [    6.711783] pci 0000:00:02.2:   bridge window [mem 0x91900000-0x91cfffff]
> [    6.717906] pci 0000:00:02.2: can't handle 64-bit address space for bridge
> 
> So the kernel reject 64bit mmio on pci pref bridge that is assigned by
> firmware.
> 
> When 32bit PAE is enabled, we could support 64bit mmio.
> but BITS_PER_LONG==64 checking could reject firmware assigned mmio that
> is above 4G. On x86 32bit always has BITS_PER_LONG equal to 32.
> 
> We could use CONFIG_ARCH_DMA_ADDR_T_64BIT or dma_addr_t size checking instead.
> Use dma_addr_t size checking to avoid using MARCO.
> 
> Also need to change to use dma_addr_t instead of unsigned long
> for base/limit to avoid overflow.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=88131
> Reported-by: Aaron Ma <mapengyu@gmail.com>
> Tested-by: Aaron Ma <mapengyu@gmail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to for-linus for v3.18, thanks!

> ---
>  drivers/pci/probe.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -406,15 +406,15 @@ static void pci_read_bridge_mmio_pref(st
>  {
>  	struct pci_dev *dev = child->self;
>  	u16 mem_base_lo, mem_limit_lo;
> -	unsigned long base, limit;
> +	dma_addr_t base, limit;
>  	struct pci_bus_region region;
>  	struct resource *res;
>  
>  	res = child->resource[2];
>  	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
>  	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
> -	base = ((unsigned long) mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
> -	limit = ((unsigned long) mem_limit_lo & PCI_PREF_RANGE_MASK) << 16;
> +	base = ((dma_addr_t) mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
> +	limit = ((dma_addr_t) mem_limit_lo & PCI_PREF_RANGE_MASK) << 16;
>  
>  	if ((mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
>  		u32 mem_base_hi, mem_limit_hi;
> @@ -428,15 +428,15 @@ static void pci_read_bridge_mmio_pref(st
>  		 * this, just assume they are not being used.
>  		 */
>  		if (mem_base_hi <= mem_limit_hi) {
> -#if BITS_PER_LONG == 64
> -			base |= ((unsigned long) mem_base_hi) << 32;
> -			limit |= ((unsigned long) mem_limit_hi) << 32;
> -#else
> -			if (mem_base_hi || mem_limit_hi) {
> -				dev_err(&dev->dev, "can't handle 64-bit address space for bridge\n");
> -				return;
> +			if (sizeof(dma_addr_t) < 8) {
> +				if (mem_base_hi || mem_limit_hi) {
> +					dev_err(&dev->dev, "can't handle 64-bit address space for bridge\n");
> +					return;
> +				}
> +			} else  {
> +				base |= ((dma_addr_t) mem_base_hi) << 32;
> +				limit |= ((dma_addr_t) mem_limit_hi) << 32;
>  			}
> -#endif
>  		}
>  	}
>  	if (base <= limit) {
