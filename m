Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaJMIup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:50:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbaJMIum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:50:42 -0400
Message-ID: <1413190208.4202.34.camel@ul30vt.home>
Subject: Re: [PATCH] vfio/pci: make MSI handling optional
From: Alex Williamson <alex.williamson@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 13 Oct 2014 02:50:08 -0600
In-Reply-To: <6188781.C8VgeYvZpD@wuerfel>
References: <6188781.C8VgeYvZpD@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 10:40 +0200, Arnd Bergmann wrote:
> A recent bug fix to the MSIx handling in vfio added references
> to functions that may not be defined if MSI is disabled in the kernel,
> resulting in this link error:
> 
> drivers/built-in.o: In function `vfio_msi_set_vector_signal':
> :(.text+0x450808): undefined reference to `get_cached_msi_msg'
> :(.text+0x45080c): undefined reference to `write_msi_msg'
> 
> From what I can tell, all the MSI specific ioctl handling can
> be made optional in this case, which also reduces the code size
> for the vfo driver. This patches does so using a build-time
> IS_ENABLED() check, which leaves all the build coverage testing
> present but avoids the link error.
> 
> A side-effect of this is that the driver now returns -ENOTTY instead
> of -EINVAL if user space calls VFIO_PCI_MSI_IRQ_INDEX on a kernel
> without MSI support, which seems to be the best behavior, but
> the approach could easily be changed if we want to preserve the
> existing behavior for compatibility reasons.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: b8f02af096b1 ("vfio/pci: Restore MSIx message prior to enabling")
> ---

Why wouldn't we handle this with stubs for `get_cached_msi_msg' and
`write_msi_msg'?  We're really not talking about much code that might
get removed by the compiler with this static branch and and it seems
like a rather non-standard mechanism.  The count of MSI/X IRQs
advertised to the user should be zero without CONFIG_MSI and later range
checks would prevent calls to
these functions for invalid indexes, so it's a bit of a random test in
the code flow.  Thanks,

Alex

> Found using randconfig build testing on ARM.
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 553212f037c3..1117f96b8556 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -827,6 +827,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>  		break;
>  	case VFIO_PCI_MSI_IRQ_INDEX:
>  	case VFIO_PCI_MSIX_IRQ_INDEX:
> +		if (!IS_ENABLED(CONFIG_PCI_MSI))
> +			break;
> +
>  		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>  		case VFIO_IRQ_SET_ACTION_MASK:
>  		case VFIO_IRQ_SET_ACTION_UNMASK:
> 



