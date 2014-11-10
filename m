Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKJXFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:05:03 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64768 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaKJXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:04:59 -0500
Date: Mon, 10 Nov 2014 16:04:54 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
Message-ID: <20141110230454.GA21470@google.com>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Michael, since he merged 2311b1f2bbd3, which added
pci_resource_to_user()]

On Fri, Oct 24, 2014 at 05:28:05PM +0100, Lorenzo Pieralisi wrote:
> The addresses stored in PCI device resources for memory spaces
> correspond to CPU physical addresses, which do not necessarily
> map 1:1 to PCI bus addresses as programmed in PCI devices configuration
> spaces.
> 
> Therefore, the changes applied by commits:
> 
> 8c05cd08a7504b855c26526
> 3b519e4ea618b6943a82931
> 
> imply that the sanity checks carried out in pci_mmap_fits() to
> ensure that the user executes an mmap of a "real" pci resource are
> erroneous when executed through procfs. Some platforms (ie SPARC)
> expect the offset value to be passed in (procfs mapping) to be the
> PCI BAR configuration value as read from the PCI device configuration
> space, not the fixed-up CPU physical address that is present in PCI
> device resources.
> 
> The required pgoff (offset in mmap syscall) value passed from userspace
> is supposed to represent the resource value exported through
> /proc/bus/pci/devices when the resource is mmapped though procfs (and 0
> when the mapping is carried out through sysfs resource files), which
> corresponds to the PCI resource filtered through the pci_resource_to_user()
> API.
> 
> This patch converts the PCI resource to the expected "user visible"
> value through pci_resource_to_user() before carrying out sanity checks
> in pci_mmap_fits() so that the check is carried out on the resource
> values as expected from the userspace mmap API.

I'm trying to figure out what's going on here.  I think this fix is
correct, but it seems like there might be some additional simplification we
could do.

This patch is apparently a bug fix for mmap via procfs.  And the bug
apparently affects platforms where pci_resource_to_user() applies a
non-zero offset, i.e., microblaze, mips, power, and sparc.  It would be
helpful to have a bug report or an example of something that doesn't work.

The second patch fixes a bug on ARM.  How does that patch depend on this
one?  Since ARM doesn't implement pci_resource_to_user(), I wouldn't think
this first patch would change anything on ARM.

Here's what I think I understand so far:

  Applications can mmap PCI memory space via either sysfs or procfs (the
  procfs method is deprecated but still supported):

    - In sysfs, there's a separate /sys/devices/pci*/.../resource* file
      for each device BAR, and the application opens the appropriate
      file and supplies the offset from the beginning of the BAR as the
      mmap(2) offset.

    - In procfs, the application opens the single /proc/bus/pci/... file
      for the device.  On most platforms, it supplies the CPU physical
      address as the mmap(2) offset.  On a few platforms, such as SPARC,
      it supplies the bus address, i.e., a BAR value, instead.

But I'm not sure I have this right.  If the procfs offset is either the
CPU physical address or the BAR value, then pci_resource_to_user()
should be (depending on the arch) either a no-op or use
pci_resource_to_bus().

But that's not how it's implemented.  Maybe it *could* be?  If
pci_resource_to_user() gives you something that's not a CPU physical
address and not a bus address, what *does* it give you, and why would we
need this third kind of thing?

FWIW, I think the discussion leading up to pci_resource_to_user() is here:
http://lkml.iu.edu/hypermail/linux/kernel/0504.3/0467.html

Bjorn

> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> ---
>  drivers/pci/pci-sysfs.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 92b6d9a..777d8bc 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -963,17 +963,20 @@ void pci_remove_legacy_files(struct pci_bus *b)
>  int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
>  		  enum pci_mmap_api mmap_api)
>  {
> -	unsigned long nr, start, size, pci_start;
> +	unsigned long nr, start, size, pci_offset;
> +	resource_size_t pci_start, pci_end;
>  
>  	if (pci_resource_len(pdev, resno) == 0)
>  		return 0;
>  	nr = vma_pages(vma);
>  	start = vma->vm_pgoff;
> +	pci_resource_to_user(pdev, resno, &pdev->resource[resno],
> +			     &pci_start, &pci_end);
>  	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
> -	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
> -			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
> -	if (start >= pci_start && start < pci_start + size &&
> -			start + nr <= pci_start + size)
> +	pci_offset = (mmap_api == PCI_MMAP_PROCFS) ?
> +			pci_start >> PAGE_SHIFT : 0;
> +	if (start >= pci_offset && start < pci_offset + size &&
> +			start + nr <= pci_offset + size)
>  		return 1;
>  	return 0;
>  }
> -- 
> 2.1.2
> 
