Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3EVVHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:07:12 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:56486
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756925Ab3EVVHK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:07:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VS-10(zzbb2dI98dI9371I1432I179dNzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
Date: Wed, 22 May 2013 16:06:57 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Alexander Graf <agraf@suse.de>,
        <kvm-ppc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>
In-Reply-To: <1369105607-20957-4-git-send-email-aik@ozlabs.ru> (from
	aik@ozlabs.ru on Mon May 20 22:06:46 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1369256817.1374.29@scott-Lenovo-G560>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 10:06:46 PM, Alexey Kardashevskiy wrote:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 8465c2a..da6bf61 100644
> --- a/arch/powerpc/kvm/powerpc.c
> @@ -396,6 +396,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> +++ b/arch/powerpc/kvm/powerpc.c
>  		break;
>  #endif
>  	case KVM_CAP_SPAPR_MULTITCE:
> +	case KVM_CAP_SPAPR_TCE_IOMMU:
>  		r = 1;
>  		break;
>  	default:

Don't advertise SPAPR capabilities if it's not book3s -- and probably  
there's some additional limitation that would be appropriate.

> @@ -1025,6 +1026,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r = kvm_vm_ioctl_create_spapr_tce(kvm, &create_tce);
>  		goto out;
>  	}
> +	case KVM_CREATE_SPAPR_TCE_IOMMU: {
> +		struct kvm_create_spapr_tce_iommu create_tce_iommu;
> +		struct kvm *kvm = filp->private_data;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&create_tce_iommu, argp,
> +				sizeof(create_tce_iommu)))
> +			goto out;
> +		r = kvm_vm_ioctl_create_spapr_tce_iommu(kvm,  
> &create_tce_iommu);
> +		goto out;
> +	}
>  #endif /* CONFIG_PPC_BOOK3S_64 */
> 
>  #ifdef CONFIG_KVM_BOOK3S_64_HV
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5a2afda..450c82a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_PPC_RTAS 91
>  #define KVM_CAP_IRQ_XICS 92
>  #define KVM_CAP_SPAPR_MULTITCE (0x110000 + 89)
> +#define KVM_CAP_SPAPR_TCE_IOMMU (0x110000 + 90)

Hmm...

> @@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_DEVICE_ATTR	  _IOW(KVMIO,  0xe2, struct  
> kvm_device_attr)
>  #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct  
> kvm_device_attr)
> 
> +/* ioctl for SPAPR TCE IOMMU */
> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct  
> kvm_create_spapr_tce_iommu)

Shouldn't this go under the vm ioctl section?

-Scott
