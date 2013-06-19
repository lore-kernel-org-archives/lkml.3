Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861Ab3FSRLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:11:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43424 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700Ab3FSRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:11:27 -0400
Date: Wed, 19 Jun 2013 13:11:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] xen: disable non-boot VCPUs during suspend
Message-ID: <20130619171103.GD13046@phenom.dumpdata.com>
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com>
 <1371655523-15609-2-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371655523-15609-2-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 04:25:20PM +0100, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> syscore_suspend() and syscore_resume() expect there to be only one
> online CPU.  e.g., hrtimers_resume() only triggers events for the
> current CPU.  Xen's suspend path was leaving all VCPUs online and then
> attempting to fixup problems afterwards (e.g., with an explicit call
> to clock_was_set() to trigger pending high resolution timers).
> 
> Instead, disable non-boot CPUs before calling stop_machine() and
> reenable them afterwards.
> 
> This is then similar to what the kexec code does before and after a
> kexec jump (see kernel_kexec() in kernel/kexec.c).
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Looks like a bug-fix. But considering that the VCPU hotplug code
in PVHVM had bugs in until v3.10 it probably shouldn't even hit
stable tree.

Looks ok to me so will stick it on the 3.11 train if nobody screams.

> ---
>  drivers/xen/manage.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 412b96c..596e55a 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -148,8 +148,19 @@ static void do_suspend(void)
>  		si.post = &xen_post_suspend;
>  	}
>  
> +	/*
> +	 * syscore_suspend() and syscore_resume() called in
> +	 * xen_suspend() above, assume that only the boot CPU is
> +	 * online.
> +	 */
> +	err = disable_nonboot_cpus();
> +	if (err)
> +		goto out_resume;
> +
>  	err = stop_machine(xen_suspend, &si, cpumask_of(0));
>  
> +	enable_nonboot_cpus();
> +
>  	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
>  
>  	if (err) {
> @@ -166,9 +177,6 @@ out_resume:
>  
>  	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
>  
> -	/* Make sure timer events get retriggered on all CPUs */
> -	clock_was_set();
> -
>  out_thaw:
>  #ifdef CONFIG_PREEMPT
>  	thaw_processes();
> -- 
> 1.7.2.5
> 
