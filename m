Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3DZQUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:20:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51920 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3DZQU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:20:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="21837090"
Date: Fri, 26 Apr 2013 17:20:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 7/9] xen/spinlock: Disable IRQ spinlock (PV) allocation
 on PVHVM
In-Reply-To: <1366142947-18655-8-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261718420.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-8-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> (xen: disable PV spinlocks on HVM) for details.
> 
> But we did not disable it everywhere - which means that when
> we boot as PVHVM we end up allocating per-CPU irq line for
> spinlock. This fixes that.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Is there any point in calling xen_init_lock_cpu in PVHVM guests?
At that point we might as well remove the call from xen_hvm_cpu_notify.


>  arch/x86/xen/spinlock.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 47ae032..8b54603 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -367,6 +367,13 @@ void __cpuinit xen_init_lock_cpu(int cpu)
>  	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
>  	     cpu, per_cpu(lock_kicker_irq, cpu));
>  
> +	/*
> +	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> +	 * (xen: disable PV spinlocks on HVM)
> +	 */
> +	if (xen_hvm_domain())
> +		return;
> +
>  	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
>  	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
>  				     cpu,
> @@ -385,12 +392,26 @@ void __cpuinit xen_init_lock_cpu(int cpu)
>  
>  void xen_uninit_lock_cpu(int cpu)
>  {
> +	/*
> +	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> +	 * (xen: disable PV spinlocks on HVM)
> +	 */
> +	if (xen_hvm_domain())
> +		return;
> +
>  	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
>  	per_cpu(lock_kicker_irq, cpu) = -1;
>  }
>  
>  void __init xen_init_spinlocks(void)
>  {
> +	/*
> +	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
> +	 * (xen: disable PV spinlocks on HVM)
> +	 */
> +	if (xen_hvm_domain())
> +		return;
> +
>  	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
>  
>  	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
> -- 
> 1.8.1.4
> 
