Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3DZQGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:06:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7849 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab3DZQGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:06:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="20802940"
Date: Fri, 26 Apr 2013 17:06:04 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/9] xen/smp: Fix leakage of timer interrupt line for
 every CPU online/offline.
In-Reply-To: <1366142947-18655-2-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261705490.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> In the PVHVM path when we do CPU online/offline path we would
> leak the timer%d IRQ line everytime we do a offline event. The
> online path (xen_hvm_setup_cpu_clockevents via
> x86_cpuinit.setup_percpu_clockev) would allocate a new interrupt
> line for the timer%d.
> 
> But we would still use the old interrupt line leading to:
> 
> kernel BUG at /home/konrad/ssd/konrad/linux/kernel/hrtimer.c:1261!
> invalid opcode: 0000 [#1] SMP
> RIP: 0010:[<ffffffff810b9e21>]  [<ffffffff810b9e21>] hrtimer_interrupt+0x261/0x270
> .. snip..
>  <IRQ>
>  [<ffffffff810445ef>] xen_timer_interrupt+0x2f/0x1b0
>  [<ffffffff81104825>] ? stop_machine_cpu_stop+0xb5/0xf0
>  [<ffffffff8111434c>] handle_irq_event_percpu+0x7c/0x240
>  [<ffffffff811175b9>] handle_percpu_irq+0x49/0x70
>  [<ffffffff813a74a3>] __xen_evtchn_do_upcall+0x1c3/0x2f0
>  [<ffffffff813a760a>] xen_evtchn_do_upcall+0x2a/0x40
>  [<ffffffff8167c26d>] xen_hvm_callback_vector+0x6d/0x80
>  <EOI>
>  [<ffffffff81666d01>] ? start_secondary+0x193/0x1a8
>  [<ffffffff81666cfd>] ? start_secondary+0x18f/0x1a8
> 
> There is also the oddity (timer1) in the /proc/interrupts after
> offlining CPU1:
> 
>   64:       1121          0  xen-percpu-virq      timer0
>   78:          0          0  xen-percpu-virq      timer1
>   84:          0       2483  xen-percpu-virq      timer2
> 
> This patch fixes it.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: stable@vger.kernel.org

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/smp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 09ea61d..f80e69c 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -662,6 +662,7 @@ static void xen_hvm_cpu_die(unsigned int cpu)
>  	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
>  	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
>  	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
> +	xen_teardown_timer(cpu);
>  	native_cpu_die(cpu);
>  }
>  
> -- 
> 1.8.1.4
> 
