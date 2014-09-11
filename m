Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaIKDKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 23:10:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46501 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaIKDKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 23:10:07 -0400
Date: Thu, 11 Sep 2014 05:10:05 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 5/9] KVM: KVM-VFIO: update user API to program forwarded
 IRQ
Message-ID: <20140911031005.GF2784@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-6-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409575968-5329-6-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 02:52:44PM +0200, Eric Auger wrote:
> add new device group commands:
> - KVM_DEV_VFIO_DEVICE_FORWARD_IRQ and
>   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ
> 
> which enable to turn forwarded IRQ mode on/off.
> 
> the kvm_arch_forwarded_irq struct embodies a forwarded IRQ
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v1 -> v2:
> - struct kvm_arch_forwarded_irq moved from arch/arm/include/uapi/asm/kvm.h
>   to include/uapi/linux/kvm.h
>   also irq_index renamed into index and guest_irq renamed into gsi
> - ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
> ---
>  Documentation/virtual/kvm/devices/vfio.txt | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h                   |  9 +++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
> index ef51740..048baa0 100644
> --- a/Documentation/virtual/kvm/devices/vfio.txt
> +++ b/Documentation/virtual/kvm/devices/vfio.txt
> @@ -13,6 +13,7 @@ VFIO-group is held by KVM.
>  
>  Groups:
>    KVM_DEV_VFIO_GROUP
> +  KVM_DEV_VFIO_DEVICE
>  
>  KVM_DEV_VFIO_GROUP attributes:
>    KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
> @@ -20,3 +21,28 @@ KVM_DEV_VFIO_GROUP attributes:
>  
>  For each, kvm_device_attr.addr points to an int32_t file descriptor
>  for the VFIO group.
> +
> +KVM_DEV_VFIO_DEVICE attributes:
> +  KVM_DEV_VFIO_DEVICE_FORWARD_IRQ
> +  KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ
> +
> +For each, kvm_device_attr.addr points to a kvm_arch_forwarded_irq struct.
> +This user API makes possible to create a special IRQ handling mode,

  KVM_DEV_VFIO_DEVICE_FORWARD_IRQ enables a special IRQ handling mode on
  hardware that supports it,

> +where KVM and a VFIO platform driver collaborate to improve IRQ
> +handling performance.
> +
> +'fd represents the file descriptor of a valid VFIO device whose physical

fd is described out of context here.  Can you copy the struct definition
into this document, perhaps right after the "For each, ..." line above.

> +IRQ, referenced by its index, is injected into the VM guest irq (gsi).
                                             as a virtual IRQ (specified
					     by the gsi field) into the
					     VM.

> +
> +On FORWARD_IRQ, KVM-VFIO device programs:
   When setting the  KVM_DEV_VFIO_DEVICE_FORWARD_IRQ attribute, the
   KVM-VFIO device tells the host (or VFIO?) to not complete the
   physical IRQ, and instead ensures that KVM (or the VM) completes the
   physical IRQ.

> +- the host, to not complete the physical IRQ itself.
> +- the GIC, to automatically complete the physical IRQ when the guest
> +  completes the virtual IRQ.

and drop this bullet form.

> +This avoids trapping the end-of-interrupt for level sensitive IRQ.

avoid this last line, it's specific to ARM.

> +
> +On UNFORWARD_IRQ, one returns to the mode where the host completes the
   When setting the KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ attribute, the
   host (VFIO?) will again complete the physical IRQ and KVM will not...
 
> +physical IRQ and the guest completes the virtual IRQ.
> +
> +It is up to the caller of this API to make sure the IRQ is not
> +outstanding when the FORWARD/UNFORWARD is called. This could lead to

outstanding? can you be specific?

don't refer to FOWARD/UNFORWARD, either refer to these attributes by
their full name or use a clear reference in proper English.

> +some inconsistency on who is going to complete the IRQ.

This sounds like the whole thing is fragile and if userspace doesn't do
things right, IRQ handling of a piece of hardware is going to be
inconsistent?  Is this the case?  If so, we need some stronger
semantics.  If not, this should be rephrased.

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index cf3a2ff..8cd7b0e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -947,6 +947,12 @@ struct kvm_device_attr {
>  	__u64	addr;		/* userspace address of attr data */
>  };
>  
> +struct kvm_arch_forwarded_irq {
> +	__u32 fd; /* file desciptor of the VFIO device */
> +	__u32 index; /* VFIO device IRQ index */
> +	__u32 gsi; /* gsi, ie. virtual IRQ number */
> +};
> +
>  #define KVM_DEV_TYPE_FSL_MPIC_20	1
>  #define KVM_DEV_TYPE_FSL_MPIC_42	2
>  #define KVM_DEV_TYPE_XICS		3
> @@ -954,6 +960,9 @@ struct kvm_device_attr {
>  #define  KVM_DEV_VFIO_GROUP			1
>  #define   KVM_DEV_VFIO_GROUP_ADD			1
>  #define   KVM_DEV_VFIO_GROUP_DEL			2
> +#define  KVM_DEV_VFIO_DEVICE			2
> +#define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
> +#define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
>  #define KVM_DEV_TYPE_ARM_VGIC_V2	5
>  #define KVM_DEV_TYPE_FLIC		6
>  
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
