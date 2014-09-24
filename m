Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaIXMFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:05:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37197 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbaIXMFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:05:11 -0400
Date: Wed, 24 Sep 2014 13:05:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: Re: [PATCH v2] kvm-vfio: do not use module_init
Message-ID: <20140924120505.GF28823@arm.com>
References: <1411559780-12676-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411559780-12676-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:56:20PM +0100, Paolo Bonzini wrote:
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
>  virt/kvm/kvm_main.c | 9 +++++++++
>  virt/kvm/vfio.c     | 4 ++--
>  virt/kvm/vfio.h     | 6 ++++++
>  3 files changed, 17 insertions(+), 2 deletions(-)
>  create mode 100644 virt/kvm/vfio.h
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index db57363cc287..ad3439835adb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -58,6 +58,10 @@
>  #include "coalesced_mmio.h"
>  #include "async_pf.h"
>  
> +#ifdef CONFIG_KVM_VFIO
> +#include "vfio.h"
> +#endif

Can't you include this unconditionally, then have the #ifdef in the header
and a static inline kvm_vfio_ops_init that returns 0?

Will
