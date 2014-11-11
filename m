Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaKKBCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:02:38 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34749 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaKKBCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:02:36 -0500
Date: Mon, 10 Nov 2014 18:02:31 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, willy@linux.intel.com, unruh@physics.ubc.ca,
        linux-kernel@vger.kernel.org, martin@lucina.net
Subject: Re: [PATCH 1/3] PCI: Restore detection of read-only BARs
Message-ID: <20141111010231.GC21470@google.com>
References: <20141030175430.22238.47671.stgit@amt.stowe>
 <20141030175437.22238.47243.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030175437.22238.47243.stgit@amt.stowe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:54:37AM -0600, Myron Stowe wrote:
> Commit 6ac665c63dca ("PCI: rewrite PCI BAR reading code") altered
> __pci_read_base's local variable 'l', masking off its lower non-addressing
> related bits, prior to it being passed in as the 'base' parameter to
> pci_size().  This masking broke pci_size's r/o BAR detection logic's
> comparison check for r/o BARs that have lower order bits set.  For such
> occurrences, the 'base == maxbase' check will no longer ever be "true".
> 
> This patch resolves this issue by also masking off the non-addressing
> related bits of 'sz' before passing it into pci_size() as the 'maxbase'
> parameter.  With this change the r/o detection logic of pci_size() will
> once again catch known occurrences that have been encountered to date:
>   - AGP aperture BAR of AMD-7xx host bridges; if the AGP window
>     disabled, this BAR is read-only and read as 0x00000008 [1]
>   - BAR0-4 of ALi IDE controllers can be non-zero and read-only [1]
>   - Intel Sandy Bridge - Thermal Management Controller [8086:0103];
>     BAR 0 returning 0xfed98004 [2]
>   - Intel Xeon E5 v3/Core i7 Power Control Unit [8086:2fc0];
>     Bar 0 returning 0x00001a [3]
> 
> 
> [1] From Thomas Gleixner's "Linux kernel history" repository:
>     https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/drivers/pci/probe.c?id=1307ef6621991f1c4bc3cec1b5a4ebd6fd3d66b9
>     pre-git commit 1307ef662199  "PCI: probing read-only Bars"
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=43331
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=85991

I like this patch and I think it's correct.

The only thing that bothers me is that Martin reported that lspci showed
"Memory at <ignored>" for this BAR:
https://bugzilla.kernel.org/show_bug.cgi?id=43331#c36 .

I guess this is because lspci reads the BAR values from
/sys/bus/pci/devices/.../config, which uses pci_read_config(), which
actually reads config space again, so it sees whatever is actually in the
BAR, not the cleared out resource in the pci_dev. Oh well, I guess that's
OK.

> Reported-by: William Unruh <unruh@physics.ubc.ca>
> Reported-by: Martin Lucina <martin@lucina.net>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/pci/probe.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 5ed9930..19dc247 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -216,14 +216,17 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  		res->flags |= IORESOURCE_SIZEALIGN;
>  		if (res->flags & IORESOURCE_IO) {
>  			l &= PCI_BASE_ADDRESS_IO_MASK;
> +			sz &= PCI_BASE_ADDRESS_IO_MASK;
>  			mask = PCI_BASE_ADDRESS_IO_MASK & (u32) IO_SPACE_LIMIT;
>  		} else {
>  			l &= PCI_BASE_ADDRESS_MEM_MASK;
> +			sz &= PCI_BASE_ADDRESS_MEM_MASK;
>  			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
>  		}
>  	} else {
>  		res->flags |= (l & IORESOURCE_ROM_ENABLE);
>  		l &= PCI_ROM_ADDRESS_MASK;
> +		sz &= PCI_ROM_ADDRESS_MASK;
>  		mask = (u32)PCI_ROM_ADDRESS_MASK;
>  	}
>  
> 
