Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaLDOGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:06:06 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39144 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaLDOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:06:04 -0500
Message-ID: <548069F6.7020308@linaro.org>
Date: Thu, 04 Dec 2014 15:04:38 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Feng Wu <feng.wu@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        dwmw2@infradead.org, joro@8bytes.org, alex.williamson@redhat.com,
        jiang.liu@linux.intel.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org
Subject: Re: [v2 17/25] KVM: kvm-vfio: User API for VT-d Posted-Interrupts
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com> <1417592394-24343-18-git-send-email-feng.wu@intel.com>
In-Reply-To: <1417592394-24343-18-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,
On 12/03/2014 08:39 AM, Feng Wu wrote:
> This patch adds and documents a new attribute
> KVM_DEV_VFIO_DEVICE_POSTING_IRQ in KVM_DEV_VFIO_DEVICE group.
> This new attribute is used for VT-d Posted-Interrupts.
> 
> When guest OS changes the interrupt configuration for an
> assigned device, such as, MSI/MSIx data/address fields,
> QEMU will use this IRQ attribute to tell KVM to update the
> related IRTE according the VT-d Posted-Interrrupts Specification,
> such as, the guest vector should be updated in the related IRTE.
> 
> Signed-off-by: Feng Wu <feng.wu@intel.com>
> ---
>  Documentation/virtual/kvm/devices/vfio.txt |    9 +++++++++
>  include/uapi/linux/kvm.h                   |   10 ++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
> index f7aff29..41e12b7 100644
> --- a/Documentation/virtual/kvm/devices/vfio.txt
> +++ b/Documentation/virtual/kvm/devices/vfio.txt
> @@ -42,3 +42,12 @@ activated before VFIO_DEVICE_SET_IRQS has been called to trigger the IRQ
>  or associate an eventfd to it. Unforwarding can only be called while the
>  signaling has been disabled with VFIO_DEVICE_SET_IRQS. If this condition is
>  not satisfied, the command returns an -EBUSY.
> +
> +  KVM_DEV_VFIO_DEVICE_POSTING_IRQ: Use posted interrtups mechanism to post
typo
> +                                   the IRQ to guests.
> +For this attribute, kvm_device_attr.addr points to a kvm_vfio_dev_irq struct.
> +
> +When guest OS changes the interrupt configuration for an assigned device,
> +such as, MSI/MSIx data/address fields, QEMU will use this IRQ attribute
> +to tell KVM to update the related IRTE according the VT-d Posted-Interrrupts
> +Specification, such as, the guest vector should be updated in the related IRTE.
For my curiosity are there any restrictions about the instant at which
the change can be done?
I do not get here how you deactivate the posting?

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a269a42..7d98650 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -949,6 +949,7 @@ struct kvm_device_attr {
>  #define  KVM_DEV_VFIO_DEVICE			2
>  #define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
>  #define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
> +#define   KVM_DEV_VFIO_DEVICE_POSTING_IRQ			3
Maybe we should align our naming verb vs verbing here?
Best Regards
Eric
>  
>  enum kvm_device_type {
>  	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
> @@ -973,6 +974,15 @@ struct kvm_arch_forwarded_irq {
>  	__u32 gsi; /* gsi, ie. virtual IRQ number */
>  };
>  
> +struct kvm_vfio_dev_irq {
> +	__u32	argsz;
> +	__u32	fd;		/* file descriptor of the VFIO device */
> +	__u32	index;		/* VFIO device IRQ index */
> +	__u32	start;
> +	__u32	count;
> +	__u32	gsi[];		/* gsi, ie. virtual IRQ number */
> +};
> +
>  /*
>   * ioctls for VM fds
>   */
> 

