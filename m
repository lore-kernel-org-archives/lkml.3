Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3DZQSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:18:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:26944 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3DZQSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:18:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="21836671"
Date: Fri, 26 Apr 2013 17:18:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6/9] xen/spinlock:  Check against default value of -1
 for IRQ line.
In-Reply-To: <1366142947-18655-7-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261717300.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-7-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> The default (uninitialized) value of the IRQ line is -1.
> Check if we already have allocated an spinlock interrupt line
> and if somebody is trying to do it again. Also set it to -1
> when we offline the CPU.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/spinlock.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index f7a080e..47ae032 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -364,6 +364,9 @@ void __cpuinit xen_init_lock_cpu(int cpu)
>  	int irq;
>  	const char *name;
>  
> +	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
                  shouldn't this be >= ^


> +	     cpu, per_cpu(lock_kicker_irq, cpu));
>
>  	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
>  	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
>  				     cpu,
> @@ -383,6 +386,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
>  void xen_uninit_lock_cpu(int cpu)
>  {
>  	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
> +	per_cpu(lock_kicker_irq, cpu) = -1;
>  }
>  
>  void __init xen_init_spinlocks(void)
> -- 
> 1.8.1.4
> 
