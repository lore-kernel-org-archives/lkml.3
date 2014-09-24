Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaIXMOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:14:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37295 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbaIXMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:14:36 -0400
Date: Wed, 24 Sep 2014 13:14:33 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: Re: [PATCH v3] kvm-vfio: do not use module_init
Message-ID: <20140924121433.GG28823@arm.com>
References: <1411560568-15989-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411560568-15989-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 01:09:28PM +0100, Paolo Bonzini wrote:
> /me got confused between the kernel and QEMU.  In the kernel, you can
> only have one module_init function, and it will prevent unloading the
> module unless you also have the corresponding module_exit function.
> 
> So, commit 80ce1639727e (KVM: VFIO: register kvm_device_ops dynamically,
> 2014-09-02) broke unloading of the kvm module, by adding a module_init
> function and no module_exit.
> 
> Repair it by making kvm_vfio_ops_init weak, and checking it in
> kvm_init.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Alex Williamson <Alex.Williamson@redhat.com>
> Fixes: 80ce1639727e9d38729c34f162378508c307ca25
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c |  4 ++++
>  virt/kvm/vfio.c     |  4 ++--
>  virt/kvm/vfio.h     | 13 +++++++++++++
>  3 files changed, 19 insertions(+), 2 deletions(-)
>  create mode 100644 virt/kvm/vfio.h

Looks good to me, thanks for fixing this:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index db57363cc287..499db0977f3c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -57,6 +57,7 @@
>  
>  #include "coalesced_mmio.h"
>  #include "async_pf.h"
> +#include "vfio.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/kvm.h>
> @@ -3226,6 +3227,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		goto out_undebugfs;
>  	}
>  
> +	r = kvm_vfio_ops_init();
> +	WARN_ON(r);
> +
>  	return 0;
>  
>  out_undebugfs:
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index bb11b36ee8a2..281e7cf2b8e5 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -18,6 +18,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
> +#include "vfio.h"
>  
>  struct kvm_vfio_group {
>  	struct list_head node;
> @@ -278,8 +279,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
>  	return 0;
>  }
>  
> -static int __init kvm_vfio_ops_init(void)
> +int kvm_vfio_ops_init(void)
>  {
>  	return kvm_register_device_ops(&kvm_vfio_ops, KVM_DEV_TYPE_VFIO);
>  }
> -module_init(kvm_vfio_ops_init);
> diff --git a/virt/kvm/vfio.h b/virt/kvm/vfio.h
> new file mode 100644
> index 000000000000..92eac75d6b62
> --- /dev/null
> +++ b/virt/kvm/vfio.h
> @@ -0,0 +1,13 @@
> +#ifndef __KVM_VFIO_H
> +#define __KVM_VFIO_H
> +
> +#ifdef CONFIG_KVM_VFIO
> +int kvm_vfio_ops_init(void);
> +#else
> +static inline int kvm_vfio_ops_init(void)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#endif
> -- 
> 1.8.3.1
> 
> 
