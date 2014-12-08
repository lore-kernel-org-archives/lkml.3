Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaLHE6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:58:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:12238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbaLHE6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:58:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="495243335"
From: "Wu, Feng" <feng.wu@intel.com>
To: Eric Auger <eric.auger@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v2 18/25] KVM: kvm-vfio: implement the VFIO skeleton for VT-d
 Posted-Interrupts
Thread-Topic: [v2 18/25] KVM: kvm-vfio: implement the VFIO skeleton for VT-d
 Posted-Interrupts
Thread-Index: AQHQD9hl7T5X4iAiPke989gQlb4RtpyFBa9Q
Date: Mon, 8 Dec 2014 04:58:31 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0022E2DC0@SHSMSX104.ccr.corp.intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
 <1417592394-24343-19-git-send-email-feng.wu@intel.com>
 <54807F5C.4050607@linaro.org>
In-Reply-To: <54807F5C.4050607@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Eric Auger [mailto:eric.auger@linaro.org]
> Sent: Thursday, December 04, 2014 11:36 PM
> To: Wu, Feng; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; gleb@kernel.org; pbonzini@redhat.com;
> dwmw2@infradead.org; joro@8bytes.org; alex.williamson@redhat.com;
> jiang.liu@linux.intel.com
> Cc: linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v2 18/25] KVM: kvm-vfio: implement the VFIO skeleton for VT-d
> Posted-Interrupts
> 
> Hi Feng,
> 
> On 12/03/2014 08:39 AM, Feng Wu wrote:
> > This patch adds the kvm-vfio interface for VT-d Posted-Interrrupts.
> > When guests updates MSI/MSI-x information for an assigned-device,
> update
> > QEMU will use KVM_DEV_VFIO_DEVICE_POSTING_IRQ attribute to setup
> > IRTE for VT-d PI. This patch implement this IRQ attribute.
> s/implement/implements
> >
> > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > ---
> >  include/linux/kvm_host.h |   19 ++++++++
> >  virt/kvm/vfio.c          |  103
> ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 122 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 5cd4420..8d06678 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1134,6 +1134,25 @@ static inline int
> kvm_arch_vfio_set_forward(struct kvm_fwd_irq *fwd_irq,
> >  }
> >  #endif
> >
> > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_POSTING
> > +/*
> > + * kvm_arch_vfio_update_pi_irte - set IRTE for Posted-Interrupts
> > + *
> > + * @kvm: kvm
> > + * @host_irq: host irq of the interrupt
> > + * @guest_irq: gsi of the interrupt
> > + * returns 0 on success, < 0 on failure
> > + */
> > +int kvm_arch_vfio_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
> > +				 uint32_t guest_irq);
> > +#else
> > +static int kvm_arch_vfio_update_pi_irte(struct kvm *kvm, unsigned int
> host_irq,
> > +					uint32_t guest_irq)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> >
> >  static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool
> val)
> > diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> > index 6bc7001..5e5515f 100644
> > --- a/virt/kvm/vfio.c
> > +++ b/virt/kvm/vfio.c
> > @@ -446,6 +446,99 @@ out:
> >  	return ret;
> >  }
> >
> > +static int kvm_vfio_pci_get_irq_count(struct pci_dev *pdev, int irq_type)
> > +{
> > +	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
> > +		u8 pin;
> > +
> > +		pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> > +		if (pin)
> > +			return 1;
> > +	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX)
> > +		return pci_msi_vec_count(pdev);
> > +	else if (irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
> > +		return pci_msix_vec_count(pdev);
> > +
> > +	return 0;
> > +}
> for platform case I was asked to move the retrieval of absolute irq
> number to the architecture specific part. I don't know if it should
> apply to PCI stuff as well? This explains why I need to pass the VFIO
> device (or struct device handle) to the arch specific part. Actually we
> do the same job, we provide a phys/virt IRQ mapping to KVM, right? So to
> me our architecture specific API should look quite similar?

In my patch, QEMU passes IRQ type(MSI/MSIx in my case), VFIO device index,
and sub-index via "struct kvm_vfio_dev_irq" to KVM, then KVM will find the
real host irq from the VFIO device index and the IRQ type. Is this something
similar with your patch?

> 
> > +
> > +static int kvm_vfio_set_pi(struct kvm_device *kdev, int32_t __user *argp)
> > +{
> > +	struct kvm_vfio_dev_irq pi_info;
> > +	uint32_t *gsi;
> > +	unsigned long minsz;
> > +	struct vfio_device *vdev;
> > +	struct msi_desc *entry;
> > +	struct device *dev;
> > +	struct pci_dev *pdev;
> > +	int i, max, ret;
> > +
> > +	minsz = offsetofend(struct kvm_vfio_dev_irq, count);
> > +
> > +	if (copy_from_user(&pi_info, (void __user *)argp, minsz))
> > +		return -EFAULT;
> > +
> > +	if (pi_info.argsz < minsz || pi_info.index >= VFIO_PCI_NUM_IRQS)
> PCI specific check, same remark as above but I will let Alex further
> comment on this and possibly invalidate this commeny ;-)
> > +		return -EINVAL;
> > +
> > +	vdev = kvm_vfio_get_vfio_device(pi_info.fd);
> > +	if (IS_ERR(vdev))
> > +		return PTR_ERR(vdev);
> > +
> > +	dev = kvm_vfio_external_base_device(vdev);
> > +	if (!dev || !dev_is_pci(dev)) {
> > +		ret = -EFAULT;
> > +		goto put_vfio_device;
> > +	}
> > +
> > +	pdev = to_pci_dev(dev);
> > +
> > +	max = kvm_vfio_pci_get_irq_count(pdev, pi_info.index);
> > +	if (max <= 0) {
> > +		ret = -EFAULT;
> > +		goto put_vfio_device;
> > +	}
> > +
> > +	if (pi_info.argsz - minsz < pi_info.count * sizeof(int) ||
> shouldn' we use the actual datatype?

I am afraid I don't get this, could you please be more specific? Thanks a lot!

> > +	    pi_info.start >= max || pi_info.start + pi_info.count > max) {
> > +		ret = -EINVAL;
> > +		goto put_vfio_device;
> > +	}
> > +
> > +	gsi = memdup_user((void __user *)((unsigned long)argp + minsz),
> > +			   pi_info.count * sizeof(int));
> same question as above
> > +	if (IS_ERR(gsi)) {
> > +		ret = PTR_ERR(gsi);
> > +		goto put_vfio_device;
> > +	}
> > +
> > +#ifdef CONFIG_PCI_MSI
> > +	for (i = 0; i < pi_info.count; i++) {
> > +		list_for_each_entry(entry, &pdev->msi_list, list) {
> > +			if (entry->msi_attrib.entry_nr != pi_info.start+i)
> > +				continue;
> > +
> > +			ret = kvm_arch_vfio_update_pi_irte(kdev->kvm,
> > +							   entry->irq,
> > +							   gsi[i]);
> > +			if (ret) {
> > +				ret = -EFAULT;
> why -EFAULT? and not propagation of original error code?
Yes, you are right. Thanks for the comments!

> you may have posting set for part of the subindexes and unset for rest.
> Isn't it an issue?

QEMU will always set the posting for all the sub-indexes for MSI/MSIx,
once the guest updates the configuration of some sub-indexes, KVM will
update it accordingly. So in which case will what you mentioned above
happen?

Thanks,
Feng

> 
> Best Regards
> 
> Eric
> > +				goto free_gsi;
> > +			}
> > +		}
> > +	}
> > +#endif
> > +
> > +	ret = 0;
> > +
> > +free_gsi:
> > +	kfree(gsi);
> > +
> > +put_vfio_device:
> > +	kvm_vfio_put_vfio_device(vdev);
> > +	return ret;
> > +}
> > +
> >  static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
> >  {
> >  	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
> > @@ -456,6 +549,11 @@ static int kvm_vfio_set_device(struct kvm_device
> *kdev, long attr, u64 arg)
> >  	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
> >  		ret = kvm_vfio_control_irq_forward(kdev, attr, argp);
> >  		break;
> > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_POSTING
> > +	case KVM_DEV_VFIO_DEVICE_POSTING_IRQ:
> > +		ret = kvm_vfio_set_pi(kdev, argp);
> > +		break;
> > +#endif
> >  	default:
> >  		ret = -ENXIO;
> >  	}
> > @@ -511,6 +609,11 @@ static int kvm_vfio_has_attr(struct kvm_device
> *dev,
> >  		case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
> >  			return 0;
> >  #endif
> > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_POSTING
> > +		case KVM_DEV_VFIO_DEVICE_POSTING_IRQ:
> > +			return 0;
> > +#endif
> > +
> >  		}
> >  		break;
> >  	}
> >

