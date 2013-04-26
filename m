Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3DZQGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:06:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:34821 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3DZQGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:06:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="21834317"
Date: Fri, 26 Apr 2013 17:06:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/9] xen/smp/spinlock: Fix leakage of the spinlock
 interrupt line for every CPU online/offline
In-Reply-To: <1366142947-18655-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261706050.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> While we don't use the spinlock interrupt line (see for details
> commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23 -
> xen: disable PV spinlocks on HVM) - we should still do the proper
> init / deinit sequence. We did not do that correctly and for the
> CPU init for PVHVM guest we would allocate an interrupt line - but
> failed to deallocate the old interrupt line.
> 
> This resulted in leakage of an irq_desc but more importantly this splat
> as we online an offlined CPU:
> 
> genirq: Flags mismatch irq 71. 0002cc20 (spinlock1) vs. 0002cc20 (spinlock1)
> Pid: 2542, comm: init.late Not tainted 3.9.0-rc6upstream #1
> Call Trace:
>  [<ffffffff811156de>] __setup_irq+0x23e/0x4a0
>  [<ffffffff81194191>] ? kmem_cache_alloc_trace+0x221/0x250
>  [<ffffffff811161bb>] request_threaded_irq+0xfb/0x160
>  [<ffffffff8104c6f0>] ? xen_spin_trylock+0x20/0x20
>  [<ffffffff813a8423>] bind_ipi_to_irqhandler+0xa3/0x160
>  [<ffffffff81303758>] ? kasprintf+0x38/0x40
>  [<ffffffff8104c6f0>] ? xen_spin_trylock+0x20/0x20
>  [<ffffffff810cad35>] ? update_max_interval+0x15/0x40
>  [<ffffffff816605db>] xen_init_lock_cpu+0x3c/0x78
>  [<ffffffff81660029>] xen_hvm_cpu_notify+0x29/0x33
>  [<ffffffff81676bdd>] notifier_call_chain+0x4d/0x70
>  [<ffffffff810bb2a9>] __raw_notifier_call_chain+0x9/0x10
>  [<ffffffff8109402b>] __cpu_notify+0x1b/0x30
>  [<ffffffff8166834a>] _cpu_up+0xa0/0x14b
>  [<ffffffff816684ce>] cpu_up+0xd9/0xec
>  [<ffffffff8165f754>] store_online+0x94/0xd0
>  [<ffffffff8141d15b>] dev_attr_store+0x1b/0x20
>  [<ffffffff81218f44>] sysfs_write_file+0xf4/0x170
>  [<ffffffff811a2864>] vfs_write+0xb4/0x130
>  [<ffffffff811a302a>] sys_write+0x5a/0xa0
>  [<ffffffff8167ada9>] system_call_fastpath+0x16/0x1b
> cpu 1 spinlock event irq -16
> smpboot: Booting Node 0 Processor 1 APIC 0x2
> 
> And if one looks at the /proc/interrupts right after
> offlining (CPU1):
> 
>   70:          0          0  xen-percpu-ipi       spinlock0
>   71:          0          0  xen-percpu-ipi       spinlock1
>   77:          0          0  xen-percpu-ipi       spinlock2
> 
> There is the oddity of the 'spinlock1' still being present.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/smp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index f80e69c..22c800a 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -662,6 +662,7 @@ static void xen_hvm_cpu_die(unsigned int cpu)
>  	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
>  	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
>  	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
> +	xen_uninit_lock_cpu(cpu);
>  	xen_teardown_timer(cpu);
>  	native_cpu_die(cpu);
>  }
> -- 
> 1.8.1.4
> 
