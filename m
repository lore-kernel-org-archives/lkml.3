Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3DZQLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:11:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7208 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3DZQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:11:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="20804108"
Date: Fri, 26 Apr 2013 17:11:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3/9] xen/time: Fix kasprintf splat when allocating timer%d
 IRQ line.
In-Reply-To: <1366142947-18655-4-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261707000.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> When we online the CPU, we get this splat:
> 
> smpboot: Booting Node 0 Processor 1 APIC 0x2
> installing Xen timer for CPU 1
> BUG: sleeping function called from invalid context at /home/konrad/ssd/konrad/linux/mm/slab.c:3179
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> Pid: 0, comm: swapper/1 Not tainted 3.9.0-rc6upstream-00001-g3884fad #1
> Call Trace:
>  [<ffffffff810c1fea>] __might_sleep+0xda/0x100
>  [<ffffffff81194617>] __kmalloc_track_caller+0x1e7/0x2c0
>  [<ffffffff81303758>] ? kasprintf+0x38/0x40
>  [<ffffffff813036eb>] kvasprintf+0x5b/0x90
>  [<ffffffff81303758>] kasprintf+0x38/0x40
>  [<ffffffff81044510>] xen_setup_timer+0x30/0xb0
>  [<ffffffff810445af>] xen_hvm_setup_cpu_clockevents+0x1f/0x30
>  [<ffffffff81666d0a>] start_secondary+0x19c/0x1a8
> 
> The solution to that is use kasprintf in the CPU hotplug path
> that 'online's the CPU. That is, do it in in xen_hvm_cpu_notify,
> and remove the call to in xen_hvm_setup_cpu_clockevents.
> 
> Unfortunatly the later is not a good idea as the bootup path
> does not use xen_hvm_cpu_notify so we would end up never allocating
> timer%d interrupt lines when booting. As such add the check for
> atomic() to continue.

This last is not reflected in the code.

Also, is it actually OK to move xen_setup_timer out of
xen_hvm_setup_cpu_clockevents?

xen_setup_cpu_clockevents registers xen_clock_events as clocksource and
xen_clock_events is setup by xen_setup_timer so we need to make sure
that the call order remains the same.


> CC: stable@vger.kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c | 5 ++++-
>  arch/x86/xen/time.c      | 6 +++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 47d3243..ddbd54a 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1641,8 +1641,11 @@ static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  		xen_vcpu_setup(cpu);
> -		if (xen_have_vector_callback)
> +		if (xen_have_vector_callback) {
>  			xen_init_lock_cpu(cpu);
> +			if (xen_feature(XENFEAT_hvm_safe_pvclock))
> +				xen_setup_timer(cpu);
> +		}
>  		break;
>  	default:
>  		break;
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0296a95..054cc01 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -497,7 +497,11 @@ static void xen_hvm_setup_cpu_clockevents(void)
>  {
>  	int cpu = smp_processor_id();
>  	xen_setup_runstate_info(cpu);
> -	xen_setup_timer(cpu);
> +	/*
> +	 * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
> +	 * doing it xen_hvm_cpu_notify (which gets called by smp_init during
> +	 * early bootup and also during CPU hotplug events).
> +	 */
>  	xen_setup_cpu_clockevents();
>  }
>  
> -- 
> 1.8.1.4
> 
