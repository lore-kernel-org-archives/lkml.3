Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaFPOWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:22:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30017 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:22:30 -0400
Date: Mon, 16 Jun 2014 10:22:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] xenpv: don't BUG when failing to setup NMI callback
Message-ID: <20140616142216.GE11200@laptop.dumpdata.com>
References: <1402916820-27500-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402916820-27500-1-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 01:07:00PM +0200, Vitaly Kuznetsov wrote:
> some old Xen hypervisors (prior to 3.2) forbid DomUs to register
> NMI callbacks. E.g. we have the following code in xen-3.1:
> 
>     if ( (d->domain_id != 0) || (v->vcpu_id != 0) )
>         return -EINVAL;
> 
> Commit 6efa20e49b9cb1db1ab66870cc37323474a75a13 introduced kernel
> crash in case PV guest fails to register NMI callback. All x86_64
> PV guests will fail to boot on top of such hypervisors (RHEL5
> example):
> 
> (XEN) traps.c:405:d7 Unhandled invalid opcode fault/trap [#6] in domain 7 on VCPU 0 [ec=0000]
> (XEN) domain_crash_sync called from entry.S
> (XEN) Domain 7 (vcpu#0) crashed on cpu#3:
> (XEN) ----[ Xen-3.1.2-389.el5  x86_64  debug=n  Not tainted ]----
> (XEN) CPU:    3
> (XEN) RIP:    e033:[<ffffffff81004d96>]
> (XEN) RFLAGS: 0000000000000282   CONTEXT: guest
> (XEN) rax: ffffffffffffffea   rbx: 0000000000000000   rcx: 0000000000000002
> (XEN) rdx: 0000000000000001   rsi: ffffffff81b0fe28   rdi: 0000000000000000
> (XEN) rbp: ffffffff81b0fe40   rsp: ffffffff81b0fde8   r8:  0000000000000000
> (XEN) r9:  ffffffff81b0fdd0   r10: 0000000000007ff0   r11: 00000000ffffffff
> (XEN) r12: ffffffff81d65900   r13: 0000000000000000   r14: 0000000000000000
> (XEN) r15: 0000000000000000   cr0: 0000000080050033   cr4: 00000000000026b0
> (XEN) cr3: 000000013a263000   cr2: 0000000000000000
> (XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
> ...
> 
> However it is possible to proceed without NMI callback registered.
> 
> Changes in v2:
> - skip nmi in cvt_gate_to_trap() for Xen < 3.2
> - do not call xen_enable_nmi() when running under Xen < 3.2
> - never BUG() in xen_enable_nmi()
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Awesome!

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

David, if you don't get to stash this patch in the queue - I can
do it on Friday.

> ---
>  arch/x86/xen/enlighten.c |  9 +++++----
>  arch/x86/xen/setup.c     | 17 ++++++++++++++---
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index f17b292..60ec5ef 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -746,12 +746,13 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  		 */
>  		;
>  #endif
> -	} else if (addr == (unsigned long)nmi)
> +	} else if (addr == (unsigned long)nmi) {
>  		/*
> -		 * Use the native version as well.
> +		 * Use the native version as well but require Xen >= 3.2
>  		 */
> -		;
> -	else {
> +		if (!xen_running_on_version_or_later(3, 2))
> +			return 0;
> +	} else {
>  		/* Some other trap using IST? */
>  		if (WARN_ON(val->ist != 0))
>  			return 0;
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 821a11a..fdc73d3 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -593,8 +593,14 @@ void xen_enable_syscall(void)
>  void xen_enable_nmi(void)
>  {
>  #ifdef CONFIG_X86_64
> -	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
> -		BUG();
> +	int ret;
> +
> +	ret = register_callback(CALLBACKTYPE_nmi, (char *)nmi);
> +	if (ret != 0) {
> +		/* Hypervisor probably forbids us to register NMI callback or
> +		   some other error happened */
> +		pr_warn("xen: failed to register NMI callback: %d\n", ret);
> +	}
>  #endif
>  }
>  void __init xen_pvmmu_arch_setup(void)
> @@ -611,7 +617,12 @@ void __init xen_pvmmu_arch_setup(void)
>  
>  	xen_enable_sysenter();
>  	xen_enable_syscall();
> -	xen_enable_nmi();
> +
> +	/* Xen versions prior to 3.2 forbid DomUs to register NMI callbacks */
> +	if (xen_running_on_version_or_later(3, 2))
> +		xen_enable_nmi();
> +	else
> +		pr_warn("xen: skipping NMI callback registration for Xen < 3.2");
>  }
>  
>  /* This function is not called for HVM domains */
> -- 
> 1.9.3
> 
