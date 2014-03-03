Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaCCPJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:09:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbaCCPJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:09:34 -0500
Message-ID: <1393859362.2895.34.camel@ul30vt.home>
Subject: Re: [RFC PATCH] vfio-pci: avoid deadlock between unbind and
 VFIO_DEVICE_RESET
From: Alex Williamson <alex.williamson@redhat.com>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: bhelgaas@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org, aik@ozlabs.ru
Date: Mon, 03 Mar 2014 08:09:22 -0700
In-Reply-To: <1393857192-28360-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1393857192-28360-1-git-send-email-cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 11:33 -0300, Thadeu Lima de Souza Cascardo wrote:
> When we unbind vfio-pci from a device, while running a guest, we might
> have a deadlock when such a guest reboots.
> 
> Unbind takes device_lock at device_release_driver, and waits for
> release_q at vfio_del_group_dev.
> 
> release_q will only be woken up when all references to vfio_device are
> gone, and that includes open file descriptors, like the ones a guest
> on qemu will hold.
> 
> If you try to reboot the guest, it will call VFIO_DEVICE_RESET, which
> calls pci_reset_function, which now grabs the device_lock, and we are
> deadlocked.
> 
> Using device_trylock allow us to handle the case when the lock is
> already taken, and avoid this situation.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
> 
> Not tested yet, but I would like some comments now, like would it be
> better to have a pci_try_reset_function, or do trylock on
> pci_reset_function itself?


We already have it:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=61cf16d8bd38c3dc52033ea75d5b1f8368514a17
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=890ed578df82f5b7b5a874f9f2fa4f117305df5f

Is there something insufficient about these or are you testing on and
older kernel?  Thanks,

Alex


> ---
>  drivers/vfio/pci/vfio_pci.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 3b76dc8..d1d2242 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -513,8 +513,18 @@ static long vfio_pci_ioctl(void *device_data,
>  		return ret;
>  
>  	} else if (cmd == VFIO_DEVICE_RESET) {
> -		return vdev->reset_works ?
> -			pci_reset_function(vdev->pdev) : -EINVAL;
> +		struct pci_dev *pdev = vdev->pdev;
> +		int ret = -EBUSY;
> +		if (!vdev->reset_works)
> +			return -EINVAL;
> +		if (pci_cfg_access_trylock(pdev)) {
> +			if (device_trylock(&pdev->dev)) {
> +				ret = __pci_reset_function_locked(pdev);
> +				device_unlock(&pdev->dev);
> +			}
> +			pci_cfg_access_unlock(pdev);
> +		}
> +		return ret;
>  
>  	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
>  		struct vfio_pci_hot_reset_info hdr;



